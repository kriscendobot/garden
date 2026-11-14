#!/bin/bash
# issue-status-pass.sh — one deterministic status comment for an issue-inbox arrival
# whose real reply has not come (designs/issue-inbox-timely-acknowledgement.md).
#
# Leader-only timer (garden-issue-status), 120s, still ticks under drain. No LLM runs
# anywhere in this path, and no issue or comment text is ever echoed: the comment is a
# fixed template filled only with board counts. GitHub is the only state (the
# `<!-- garden-status:<number>:<arrival-id> -->` marker); no journal writes, no cursor,
# so a restart or leader handoff re-derives everything. It never closes an issue.
#
# Per tick:
#   1. Skip if the host-shared REST latch is live (never gh_rest_budget_defer: this
#      is a maintainer-facing path).
#   2. List the last 24h of issues + issue-comments (handlers/issue-source-gh.sh).
#   3. MAINTAINER-TRUST GATE first: drop any author not on maintainers/allowlist
#      (allowlist-only, the watcher's rule) BEFORE any body is read.
#   4. Arrivals: open issues, and comments whose first line starts with the exact
#      "@<bot> " (comment_classify_exactly_addressed, shared with the watcher).
#   5. Drop arrivals with ANY bot comment created after them (an earlier status
#      counts; a reaction does not).
#   6. Timeout (age >= TIMEOUT) or deep queue (age >= EARLY, job in todo, >= EARLY_AHEAD
#      unpinned jobs ahead) fires; a claim younger than CLAIM_GRACE holds it, but never
#      past TIMEOUT + CLAIM_GRACE of age. Re-list and re-check before posting.
#
# GARDEN_ISSUE_STATUS_DRY_RUN=1 (the first-deploy default) logs what would be posted.
#
# Test seams: GARDEN_ISSUE_STATUS_{REPO,MAINTAINERS_FILE,BOARD,SOURCE,COMMENTS,POST,NOW_EPOCH}.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
# shellcheck source=comment-classify.sh
source "$HERE/comment-classify.sh"

: "${GARDEN_ISSUE_STATUS_DRY_RUN:=1}"
: "${GARDEN_ISSUE_STATUS_TIMEOUT_SECS:=1200}"
: "${GARDEN_ISSUE_STATUS_EARLY_SECS:=300}"
: "${GARDEN_ISSUE_STATUS_EARLY_AHEAD:=6}"
: "${GARDEN_ISSUE_STATUS_CLAIM_GRACE_SECS:=300}"
: "${GARDEN_ISSUE_STATUS_LOOKBACK_SECS:=86400}"
: "${GARDEN_ISSUE_STATUS_SOURCE:=$HERE/handlers/issue-source-gh.sh}"
: "${GARDEN_ISSUE_STATUS_STATE:=$GARDEN_STATE/issue-status}"
: "${GARDEN_ISSUE_STATUS_TICK_BUDGET_SECS:=480}"
: "${GARDEN_ISSUE_STATUS_READ_TIMEOUT_SECS:=180}"
: "${GARDEN_ISSUE_STATUS_KILL_AFTER_SECS:=10}"
: "${GARDEN_BOT_LOGIN:=kriscendobot}"
# Declare the comment machine-authored: the gh wrapper's footer renders `model automatic`.
export GARDEN_NO_LLM=1

iso_epoch() { [ -n "${1:-}" ] && date -u -d "$1" +%s 2>/dev/null || printf '0\n'; }
lc() { printf '%s' "$1" | tr '[:upper:]' '[:lower:]'; }

# Keep every potentially blocking GitHub read inside one pass-wide wall-clock
# budget. The unit allows 600s; the 480s default leaves systemd enough time to
# reap a timed-out gh/git subtree and run ExecStopPost. A read begun late in the
# pass is clipped to the remaining budget, rather than receiving a fresh timeout.
# Any timeout stops the pass without recording state, so the next tick re-derives
# and retries every unanswered arrival from GitHub.
TICK_DEADLINE=$(( $(date +%s) + GARDEN_ISSUE_STATUS_TICK_BUDGET_SECS ))
bounded_read() { # output-file error-file command [args...]
  local output="$1" error="$2" remaining run_for rc
  shift 2
  # Reserve timeout's escalation window inside the tick wall. The ordinary
  # per-read timeout remains the configured value when that much wall remains.
  remaining=$(( TICK_DEADLINE - $(date +%s) - GARDEN_ISSUE_STATUS_KILL_AFTER_SECS ))
  run_for="$GARDEN_ISSUE_STATUS_READ_TIMEOUT_SECS"
  [ "$run_for" -le "$remaining" ] || run_for="$remaining"
  if [ "$run_for" -le 0 ]; then
    return 124
  fi
  set +e
  timeout --signal=TERM --kill-after="${GARDEN_ISSUE_STATUS_KILL_AFTER_SECS}s" \
    "${run_for}s" "$@" >"$output" 2>"$error"
  rc=$?
  set -e
  return "$rc"
}

deadline_exit() { # read-description
  log "WARN: issue-status: $1 exceeded the remaining tick budget; stopping cleanly so unanswered arrivals retry next tick"
  exit 0
}

# --- the rule table (pure; `--decide` exposes it to the test) -----------------
# decide <age> <state> <ahead> <claim-age-or-dash> → post | hold
decide() {
  local age="$1" state="$2" ahead="$3" claim_age="$4"
  if [ "$state" = doin ] && [ "$claim_age" != - ] \
     && [ "$claim_age" -lt "$GARDEN_ISSUE_STATUS_CLAIM_GRACE_SECS" ] \
     && [ "$age" -lt $(( GARDEN_ISSUE_STATUS_TIMEOUT_SECS + GARDEN_ISSUE_STATUS_CLAIM_GRACE_SECS )) ]; then
    printf 'hold\n'; return
  fi
  if [ "$age" -ge "$GARDEN_ISSUE_STATUS_TIMEOUT_SECS" ]; then printf 'post\n'; return; fi
  if [ "$age" -ge "$GARDEN_ISSUE_STATUS_EARLY_SECS" ] && [ "$state" = todo ] \
     && [ "$ahead" -ge "$GARDEN_ISSUE_STATUS_EARLY_AHEAD" ]; then
    printf 'post\n'; return
  fi
  printf 'hold\n'
}

# render <spine> <state> <ahead> <running> <claimed-at> <paused> <number> <arrival-id>
# Fixed templates; every argument is a board-derived value, never issue text.
render() {
  local spine="$1" state="$2" ahead="$3" running="$4" claimed="$5" paused="$6"
  case "$state" in
    todo) printf 'Received. This is queued as `%s`, with %s jobs ahead and %s running. A gardener will reply here when it picks this up.' "$spine" "$ahead" "$running" ;;
    doin) printf 'Received. A gardener claimed this as `%s` at %s and is working on it. It will reply here.' "$spine" "$claimed" ;;
    *) printf 'Received, but intake is running behind and this is not on the job board yet. It will be queued when intake catches up.' ;;
  esac
  [ "$paused" = 1 ] && printf ' The garden is paused for maintenance, so pickup may be delayed further.'
  printf ' This is an automatic status note.\n\n<!-- garden-status:%s:%s -->\n' "$7" "$8"
}

case "${1:-}" in
  --decide) shift; decide "$@"; exit 0 ;;
  --render) shift; render "$@"; exit 0 ;;
esac

# 1. The REST latch: GitHub is refusing or about to refuse; the next tick retries.
if api_cooldown_active rest; then log "issue-status: REST cooldown live; skipping tick"; exit 0; fi

# --- journal view (repo, maintainers, board); last fetched view on a failed fetch ---
JOURNAL_VIEW="$GARDEN_ISSUE_STATUS_STATE/journal"
need_journal=0
[ -n "${GARDEN_ISSUE_STATUS_REPO:-}" ] && [ -n "${GARDEN_ISSUE_STATUS_MAINTAINERS_FILE:-}" ] \
  && [ -n "${GARDEN_ISSUE_STATUS_BOARD:-}" ] || need_journal=1
if [ "$need_journal" = 1 ]; then
  ensure_clone "$JOURNAL_VIEW"
  ( sync_clone "$JOURNAL_VIEW" ) >/dev/null 2>&1 || log "issue-status: journal fetch failed; using the last fetched view"
fi
jshow() { git -C "$JOURNAL_VIEW" show "origin/$JOURNAL_BRANCH:$1" 2>/dev/null || true; }

REPO="${GARDEN_ISSUE_STATUS_REPO:-$(jshow config/garden-repo | sed -e 's/#.*//' -e 's/[[:space:]]//g' | head -1)}"
declare -a MAINTAINERS=()
while IFS= read -r m; do
  m="$(lc "$(printf '%s' "${m%%#*}" | tr -d '[:space:]')")"; [ -n "$m" ] && MAINTAINERS+=("$m")
done < <(if [ -n "${GARDEN_ISSUE_STATUS_MAINTAINERS_FILE:-}" ]; then cat "$GARDEN_ISSUE_STATUS_MAINTAINERS_FILE"; else jshow maintainers/allowlist; fi)
# Inert until armed, exactly like the watcher.
[ -n "$REPO" ] && [ "${#MAINTAINERS[@]}" -gt 0 ] || exit 0
is_maintainer() { local a l; l="$(lc "$1")"; for a in "${MAINTAINERS[@]}"; do [ "$a" = "$l" ] && return 0; done; return 1; }

TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
[ -x "$(command -v timeout 2>/dev/null || true)" ] \
  || { log "WARN: issue-status: timeout is unavailable; skipping tick rather than starting unbounded GitHub reads"; exit 0; }
BOARD="${GARDEN_ISSUE_STATUS_BOARD:-}"
if [ -z "$BOARD" ]; then
  BOARD="$TMP/board"; mkdir -p "$BOARD"
  git -C "$JOURNAL_VIEW" archive "origin/$JOURNAL_BRANCH" jobs/todo jobs/doin 2>/dev/null | tar -x -C "$BOARD" 2>/dev/null || true
  mkdir -p "$BOARD/jobs/tada"
  git -C "$JOURNAL_VIEW" ls-tree --name-only "origin/$JOURNAL_BRANCH" jobs/tada/ 2>/dev/null \
    | while IFS= read -r p; do : > "$BOARD/$p"; done
fi
mkdir -p "$BOARD/jobs/todo" "$BOARD/jobs/doin" "$BOARD/jobs/tada"

running="$(find "$BOARD/jobs/doin" -maxdepth 1 -name '*.md' | wc -l | tr -d ' ')"
paused=0; fleet_draining && paused=1
board_state() { # spine → todo|doin|tada|not-on-board
  local s
  for s in doin todo tada; do [ -f "$BOARD/jobs/$s/$1.md" ] && { printf '%s\n' "$s"; return; }; done
  printf 'not-on-board\n'
}
ahead_of() { # spine → unpinned todo jobs with an older posted_at
  local mine f n=0 p
  mine="$(iso_epoch "$(plan_field "$BOARD/jobs/todo/$1.md" posted_at)")"
  for f in "$BOARD"/jobs/todo/*.md; do
    [ -f "$f" ] && [ "$f" != "$BOARD/jobs/todo/$1.md" ] || continue
    [ -z "$(job_requirements "$f")" ] || continue
    p="$(iso_epoch "$(plan_field "$f" posted_at)")"
    [ "$p" -gt 0 ] && [ "$p" -lt "$mine" ] && n=$(( n + 1 ))
  done
  printf '%s\n' "$n"
}
claimed_at_of() { [ -f "$BOARD/jobs/doin/$1.md" ] || return 0; sed -n 's/^[[:space:]]*claimed_at:[[:space:]]*//p' "$BOARD/jobs/doin/$1.md" | head -1; }

# --- GitHub reads/writes --------------------------------------------------------
# read_comments <number> <output> <error> → "created<TAB>author<TAB>marker-or-dash" per comment.
# Only a BOT comment's body is inspected, and only for the status marker.
read_comments() {
  local number="$1" output="$2" error="$3" jq_filter
  if [ -n "${GARDEN_ISSUE_STATUS_COMMENTS:-}" ]; then
    bounded_read "$output" "$error" "$GARDEN_ISSUE_STATUS_COMMENTS" "$REPO" "$number"
    return
  fi
  jq_filter=".[] | [.created_at, .user.login, (if (.user.login|ascii_downcase) == (\"$GARDEN_BOT_LOGIN\"|ascii_downcase) then ((.body // \"\") | (capture(\"garden-status:(?<m>[0-9]+:[A-Za-z0-9]+)\").m // \"-\")) else \"-\" end)] | @tsv"
  # gh_api_retry is a common.sh shell function, so run it in a bounded child bash
  # rather than asking timeout to exec a non-existent `gh_api_retry` binary.
  bounded_read "$output" "$error" bash -c \
    'source "$1"; shift; gh_api_retry --paginate "$1" --jq "$2"' \
    _ "$HERE/common.sh" "repos/$REPO/issues/$number/comments" "$jq_filter"
}
post_comment() { # number body-file
  if [ -n "${GARDEN_ISSUE_STATUS_POST:-}" ]; then "$GARDEN_ISSUE_STATUS_POST" "$REPO" "$1" "$2"; return; fi
  gh api -X POST "repos/$REPO/issues/$1/comments" -F body=@"$2" >/dev/null
}
# answered <number> <arrival-created-epoch> <arrival-id> — rc 0 when a bot comment
# post-dates the arrival or this arrival's marker is already present.
answered() {
  local created author marker bot; bot="$(lc "$GARDEN_BOT_LOGIN")"
  # `|| [ -n ... ]`: gh_api_retry prints its payload without a trailing newline, so
  # the newest comment (usually the bot's reply) is an unterminated last line that
  # a bare `read` drops. The dry run caught exactly that on #51 (2026-11-13).
  while IFS=$'\t' read -r created author marker || [ -n "${created:-}" ]; do
    [ "$(lc "$author")" = "$bot" ] || continue
    [ "$marker" = "$1:$3" ] && return 0
    [ "$(iso_epoch "$created")" -gt "$2" ] && return 0
  done < "$TMP/comments-$1"
  return 1
}

# 2. The source window.
now="${GARDEN_ISSUE_STATUS_NOW_EPOCH:-$(date -u +%s)}"
since="$(date -u -d "@$(( now - GARDEN_ISSUE_STATUS_LOOKBACK_SECS ))" +%FT%TZ)"
source_rc=0
bounded_read "$TMP/source" "$TMP/source.err" "$GARDEN_ISSUE_STATUS_SOURCE" "$REPO" "$since" || source_rc=$?
if [ "$source_rc" -eq 124 ] || [ "$source_rc" -eq 137 ]; then
  deadline_exit "issue source read"
elif [ "$source_rc" -ne 0 ]; then
  log "issue-status: issue source failed for $REPO; retrying next tick"; exit 0
fi
slug="$(printf '%s' "$REPO" | tr '/' '-')"
declare -A DONE=()
posted=0 would=0
while IFS=$'\t' read -r kind created id number author _submitter state _cb _ca _url body || [ -n "${kind:-}" ]; do
  [ -n "${kind:-}" ] && [ -n "${number:-}" ] || continue
  # 3. Trust gate: before ANY body is read.
  is_maintainer "${author:-}" || continue
  [ "$state" = open ] || continue
  case "$kind" in
    issue) aid=issue ;;
    issue-comment)
      comment_classify_exactly_addressed "$body" issue-comment || continue
      aid="$id" ;;
    *) continue ;;
  esac
  [ -z "${DONE[$number]+x}" ] || continue
  created_epoch="$(iso_epoch "$created")"; [ "$created_epoch" -gt 0 ] || continue
  age=$(( now - created_epoch ))
  [ "$age" -ge "$GARDEN_ISSUE_STATUS_EARLY_SECS" ] || continue
  # 5. Already answered?
  if [ ! -f "$TMP/comments-$number" ]; then
    comments_rc=0
    read_comments "$number" "$TMP/comments-$number" "$TMP/comments-$number.err" || comments_rc=$?
    if [ "$comments_rc" -eq 124 ] || [ "$comments_rc" -eq 137 ]; then
      rm -f "$TMP/comments-$number"
      deadline_exit "comment read for #$number"
    elif [ "$comments_rc" -ne 0 ]; then
      log "issue-status: comment list failed for #$number; retrying next tick"
      rm -f "$TMP/comments-$number"
      continue
    fi
  fi
  answered "$number" "$created_epoch" "$aid" && continue
  # 6. The rules.
  spine="issue-$slug-$number"; st="$(board_state "$spine")"
  ahead=0; [ "$st" = todo ] && ahead="$(ahead_of "$spine")"
  claimed="$(claimed_at_of "$spine")"; claim_age=-
  if [ "$st" = doin ] && [ -n "$claimed" ]; then claim_age=$(( now - $(iso_epoch "$claimed") )); [ "$claim_age" -ge 0 ] || claim_age=0; fi
  [ "$(decide "$age" "$st" "$ahead" "$claim_age")" = post ] || continue
  bf="$TMP/body-$number"; render "$spine" "$st" "$ahead" "$running" "${claimed:-?}" "$paused" "$number" "$aid" > "$bf"
  if [ "$GARDEN_ISSUE_STATUS_DRY_RUN" != 0 ]; then
    log "issue-status: DRY RUN would post on $REPO#$number for arrival $aid (age=${age}s state=$st ahead=$ahead running=$running claim_age=$claim_age paused=$paused)"
    DONE["$number"]=1; would=$(( would + 1 )); continue
  fi
  # Final re-check immediately before posting.
  recheck_rc=0
  read_comments "$number" "$TMP/comments-$number" "$TMP/comments-$number.err" || recheck_rc=$?
  if [ "$recheck_rc" -eq 124 ] || [ "$recheck_rc" -eq 137 ]; then
    rm -f "$TMP/comments-$number"
    deadline_exit "final comment re-check for #$number"
  elif [ "$recheck_rc" -ne 0 ]; then
    log "issue-status: re-check failed for #$number; not posting"
    continue
  fi
  answered "$number" "$created_epoch" "$aid" && continue
  if post_comment "$number" "$bf"; then
    log "issue-status: posted on $REPO#$number for arrival $aid (age=${age}s state=$st ahead=$ahead)"
    posted=$(( posted + 1 ))
  else
    log "WARN: issue-status: post failed on $REPO#$number; retrying next tick"
  fi
  DONE["$number"]=1
done < "$TMP/source"
[ "$posted" -eq 0 ] && [ "$would" -eq 0 ] || log "issue-status: tick done (posted=$posted dry_run_would=$would)"
exit 0
