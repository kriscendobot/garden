#!/bin/bash
# ci-watcher.sh — per-repo CI-STATUS producer. Watch one gated repo's OWN open
# bot-authored PRs and auto-post a shepherd job the moment CI goes red.
#
# Usage: ci-watcher.sh <repo-slug>      e.g. endojs-endo-but-for-bots
#
# Sibling to triager.sh (watches branch COMMITS) and comment-watcher.sh (watches
# PR/issue COMMENTS). This third producer watches CI STATUS. It closes the loop the
# maintainer named on endojs/endo-but-for-bots #58: a gardener (or maintainer) pushes
# to an open bot PR, CI goes red on a lint/prettier failure, and the failure sits
# unattended until a human types "Shepherd". Before this producer the ONLY path to a
# shepherd was that manual comment (comment-watcher.sh maps `shepherd #N` → a shepherd
# job); NOTHING watched CI status. Now a completed-red CI on a bot PR yields exactly
# one shepherd job with no maintainer comment, deduped across ticks and hosts.
#
# The pipeline is fully DETERMINISTIC — plain-code status reads and a fixed mapping,
# no LLM reasoning over CI logs (the triager's low-discretion spirit):
#
#     enumerate the repo's OWN open PRs (authoritative paginated REST — never a
#       default gh page cap, the #284 surveillance-drop lesson)
#       → keep only PRs AUTHORED by the bot whose head branch lives on a repo the
#         bot can push (so a shepherd can actually drive the branch)
#       → read each PR's check-suite rollup DETERMINISTICALLY (ci-rollup handler)
#       → on a COMPLETED FAILURE (not in-progress, not a flake-retry window) with no
#         shepherd already live for that PR, post <slug>-pr<N>-shepherd
#       → back off on a rollup still QUEUED/IN_PROGRESS; do nothing on green.
#
# ── Idempotency / anti-thrash ────────────────────────────────────────────────
# The basename is the SAME one the manual-shepherd path mints (comment-watcher.sh:
# `<slug>-pr<N>-shepherd`), so the two producers can never double-post: post-job.sh
# is idempotent by basename across todo/doin/tada, and this watcher also pre-checks
# the board and skips a PR whose shepherd is already live (todo/doin) before posting.
# A rollup still settling (a retry in flight) returns "in progress" and is skipped,
# so a transient red never mints a premature shepherd.
#
# ── Leader-only singleton ────────────────────────────────────────────────────
# Like the other watchers this is a leader-only singleton: garden-ci-watcher@.service
# carries the is-main-host.sh ExecCondition, so on a follower the tick is skipped
# cleanly and the shepherd is never double-posted across hosts (CLAUDE.md § Leader
# and follower hosts).
#
# ── Monitoring safety ────────────────────────────────────────────────────────
# This watcher reads only PR CI STATUS and metadata (author, head repo) — NEVER a PR
# body, title, or comment — and feeds NONE of it to an LLM; the job body it writes is
# deterministic and names the PR by URL. So unlike the comment watcher it introduces
# no prompt-injection surface (injection-safe by construction, like the review-queue
# daemon). It is nonetheless gated to the SAME cleared, maintainer-authorized set the
# comment watcher uses — the journal's comment-repos/ directory, armed per-repo by
# repo-watcher.sh — so it only ever looks at repos already cleared for surveillance
# (CLAUDE.md § Monitoring safety constraint), defence in depth over the by-construction
# safety.
#
# The per-PR I/O is indirected so tests substitute deterministic stubs:
#   GARDEN_CI_PR_SOURCE <owner/name> <bot-login>  -> TSV: number author head_repo updated_at
#   GARDEN_CI_ROLLUP    <owner/name> <pr>         -> exit 0 RED / 10 green / 11 none / 12 pending
#   GARDEN_CI_POST      <basename> <body-file>    (post-job.sh)
# The bot-author gate, the head-branch-pushable gate, and the is-bot-repo gate live
# HERE (not in a handler) so the test exercises them directly rather than mocking them.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"

slug="${1:?usage: ci-watcher.sh <repo-slug>}"
GARDEN_TAG="ci-watcher/$slug"
: "${GARDEN_BOT_LOGIN:=kriscendobot}"
: "${GARDEN_CI_PR_SOURCE:=$HERE/handlers/ci-pr-source-gh.sh}"
: "${GARDEN_CI_ROLLUP:=$HERE/handlers/ci-rollup-gh.sh}"
: "${GARDEN_CI_POST:=$HERE/post-job.sh}"
: "${GARDEN_CI_VERIFY_CLONE:=$GARDEN_STATE/ci-watcher/verify}"
VERIFY="$GARDEN_CI_VERIFY_CLONE"
# Bound the PR-source enumeration so a hung gh/git can never outlive the tick.
: "${GARDEN_CI_SOURCE_TIMEOUT_SECS:=180}"
: "${GARDEN_CI_KILL_AFTER:=10s}"
# Rate-limit-cascade hardening (the 03:21 sweep where ~150 bot PRs all returned rc=1):
#   ACTIVITY_WINDOW  — steady-state pressure relief. Skip a PR whose head branch is
#     untouched beyond this window (a `date -d` offset expression) BEFORE its rollup
#     read, so a tick reads a handful of recently-active PRs, not every open bot PR.
#     Empty disables the bound (reads every PR, the pre-hardening behaviour).
#   UNREADABLE_ABORT_THRESHOLD — cascade circuit-breaker. When this many rollup reads
#     fall through as unreadable with NOT ONE successful read yet this tick, the API is
#     throttling every call; abort the rest of the sweep rather than deepen the cooldown.
: "${GARDEN_CI_ACTIVITY_WINDOW:=3 days}"
: "${GARDEN_CI_UNREADABLE_ABORT_THRESHOLD:=3}"

fleet_draining && { log "fleet draining; skipping"; exit 0; }

# slug is <owner>-<name>; owners in our set carry no dash, so split on the first.
owner="${slug%%-*}"; name="${slug#*-}"
repo="$owner/$name"
[ "$owner" != "$slug" ] && [ -n "$name" ] || die "cannot derive owner/name from slug '$slug'"

# --- bot-repo gate ----------------------------------------------------------
# Auto-shepherding drives a PR's branch on its own authority, so it is scoped HARD
# to bot repos: endojs/endo-but-for-bots and the bot's own forks (owner == the bot
# login). agoric/agoric-sdk and the endojs/endo upstream are NEVER autonomously
# driven — those stay the maintainer's (and the boatman's) call. Denylist-by-default:
# anything not provably a bot repo is skipped. A cleared comment-repos/ entry that is
# NOT a bot repo (e.g. kriskowal/garden, watched for comments but not bot-authored
# PR-driven) exits cleanly here before any gh call.
is_bot_repo() {  # is_bot_repo <owner/name>
  case "$1" in
    agoric/agoric-sdk|endojs/endo) return 1 ;;   # explicit out-of-scope upstreams
    endojs/endo-but-for-bots)      return 0 ;;   # the gated bot repo
    "$GARDEN_BOT_LOGIN"/*)         return 0 ;;   # bot-owned forks
    *)                             return 1 ;;
  esac
}
if ! is_bot_repo "$repo"; then
  log "not a bot repo ($repo) — never autonomously shepherd non-bot PRs; skipping"
  exit 0
fi

# rc 0 if the PR's head branch lives on a repo the bot can push (so a shepherd can
# actually drive it): the head repo is bot-owned, OR it is the base repo itself and
# the base repo is a bot repo (a same-repo branch on a bot repo — bot has push).
head_pushable() {  # head_pushable <head-repo-full-name>
  local head="$1"
  [ -n "$head" ] || return 1
  case "$head" in "$GARDEN_BOT_LOGIN"/*) return 0 ;; esac
  [ "$head" = "$repo" ]   # same-repo branch on this (already bot-verified) repo
}

# Reuse a persistent VERIFY clone (under $GARDEN_STATE, never torn down) to confirm a
# just-posted job actually reached origin/journal2 before counting it, and to
# pre-check the live board so a shepherd already in flight is not re-posted.
_VERIFY_FETCHED=""
verify_fetch() {  # verify_fetch [fresh]; ensure+fetch the VERIFY clone (once/tick unless fresh)
  ensure_clone "$VERIFY"
  if [ -n "${1:-}" ] || [ -z "$_VERIFY_FETCHED" ]; then
    journal_fetch "$VERIFY" >/dev/null 2>&1 || return 1
    _VERIFY_FETCHED=1
  fi
  return 0
}
# rc 0 if <base> is LIVE (todo/doin) on origin/journal2. A completed shepherd (tada)
# does NOT count as live — but post-job.sh's own todo/doin/tada idempotency still
# prevents re-minting the identical basename, matching the manual-shepherd path.
shepherd_live() {  # shepherd_live <base> [fresh]
  local base="$1" sub
  verify_fetch "${2:-}" || return 1
  for sub in "$JOBS_TODO" "$JOBS_DOIN"; do
    git -C "$VERIFY" cat-file -e "origin/$JOURNAL_BRANCH:$sub/$base.md" 2>/dev/null && return 0
  done
  return 1
}
# rc 0 if <base> exists anywhere in the lifecycle (todo/doin/tada) — the post landed.
posted_anywhere() {  # posted_anywhere <base> [fresh]
  local base="$1" sub
  verify_fetch "${2:-}" || return 1
  for sub in "$JOBS_TODO" "$JOBS_DOIN" "$JOBS_TADA"; do
    git -C "$VERIFY" cat-file -e "origin/$JOURNAL_BRANCH:$sub/$base.md" 2>/dev/null && return 0
  done
  return 1
}

# --- enumerate the repo's open PRs (bounded, reaped source subtree) ----------
# The source runs `gh --paginate`, which forks git credential helpers; bound it under
# `timeout` and reap the whole process group on signal/exit so a systemd stop mid-tick
# cannot orphan a git child into the unit cgroup (mirrors comment-watcher.sh's reap).
SRC="$(mktemp)"; ERRF="$(mktemp)"
SOURCE_TIMEOUT_PID=""
cleanup() {
  rm -f "$SRC" "$ERRF"
  local pid="$SOURCE_TIMEOUT_PID"
  SOURCE_TIMEOUT_PID=""
  [ -n "$pid" ] || return 0
  kill -TERM "-$pid" 2>/dev/null || kill -TERM "$pid" 2>/dev/null || true
  wait "$pid" 2>/dev/null || true
  kill -KILL "-$pid" 2>/dev/null || true
}
trap 'cleanup' EXIT
trap 'cleanup; exit 143' TERM
trap 'cleanup; exit 130' INT

src_rc=0
if command -v timeout >/dev/null 2>&1; then
  timeout --signal=TERM --kill-after="$GARDEN_CI_KILL_AFTER" "${GARDEN_CI_SOURCE_TIMEOUT_SECS}s" \
    "$GARDEN_CI_PR_SOURCE" "$repo" "$GARDEN_BOT_LOGIN" > "$SRC" 2>"$ERRF" &
  SOURCE_TIMEOUT_PID=$!
  wait "$SOURCE_TIMEOUT_PID" || src_rc=$?
  SOURCE_TIMEOUT_PID=""
else
  "$GARDEN_CI_PR_SOURCE" "$repo" "$GARDEN_BOT_LOGIN" > "$SRC" 2>"$ERRF" || src_rc=$?
fi
if [ "$src_rc" -ne 0 ]; then
  sed 's/^/  source: /' "$ERRF" >&2 || true
  # A transient connectivity failure (GitHub outage, DNS blip, TLS/read timeout)
  # is not a broken enumeration — it is "we couldn't ask right now". Degrade the
  # SAME way the per-PR rollup does on an unreadable state (line ~241): skip this
  # tick rather than die, so a GitHub outage doesn't detonate a ~40-FATAL/100-min
  # systemd restart storm. A structural failure (auth, 404, malformed) still dies
  # loud — that IS a bug to surface, and the "never mistake a broken enumeration
  # for no open PRs" guarantee is preserved (we never proceed on a partial list).
  if is_transient_net_error "$ERRF"; then
    log "WARN: ci PR source unreachable (transient network) — skipping tick (never guess)"
    exit 0
  fi
  die "ci PR source failed for $repo (rc=$src_rc; see source stderr above)"
fi

bot_lc="$(printf '%s' "$GARDEN_BOT_LOGIN" | tr '[:upper:]' '[:lower:]')"
open_prs=0; ours=0; red=0; pending=0; posted=0; unreadable=0; stale=0
reads_ok=0; aborted=0
# Activity-bound cutoff: PRs whose head branch was last touched before this epoch are
# skipped without a rollup read. Computed once/tick from GARDEN_CI_ACTIVITY_WINDOW; 0
# (empty window, or an unparseable expression) means "no bound — read every PR".
activity_cutoff=0
if [ -n "${GARDEN_CI_ACTIVITY_WINDOW:-}" ]; then
  activity_cutoff="$(date -d "-${GARDEN_CI_ACTIVITY_WINDOW}" +%s 2>/dev/null || echo 0)"
fi
# The source's 4th column is updated_at — the PR's last-touched timestamp. We use it to
# activity-bound the sweep: a PR untouched beyond GARDEN_CI_ACTIVITY_WINDOW is skipped
# BEFORE its (GraphQL-heavy) rollup read, so a tick reads a handful of recently-active
# PRs rather than firing `gh pr view` at every open bot PR and tripping the rate limit.
while IFS=$'\t' read -r pr author head updated; do
  [ -n "$pr" ] || continue
  open_prs=$((open_prs+1))

  # Gate 1: our PR — authored by the bot.
  [ "$(printf '%s' "$author" | tr '[:upper:]' '[:lower:]')" = "$bot_lc" ] || continue
  # Gate 2: head branch lives on a repo the bot can push (a shepherd can drive it).
  if ! head_pushable "$head"; then
    log "skip #$pr: head '$head' is not bot-pushable (a shepherd could not drive it)"
    continue
  fi
  ours=$((ours+1))

  # Gate 3 (pressure relief): skip a PR untouched beyond the activity window BEFORE its
  # rollup read — the steady-state fix for the cascade (far fewer GraphQL calls/tick).
  if [ "$activity_cutoff" -gt 0 ] && [ -n "$updated" ]; then
    upd_epoch="$(date -d "$updated" +%s 2>/dev/null || echo 0)"
    if [ "$upd_epoch" -gt 0 ] && [ "$upd_epoch" -lt "$activity_cutoff" ]; then
      stale=$((stale+1)); continue
    fi
  fi

  # Read the CI rollup DETERMINISTICALLY. Exit code IS the verdict.
  # Capture the handler's stderr (it deliberately writes a diagnostic on an
  # unreadable state — "gh pr view failed", "empty PR state", etc.) so a mass
  # failure's actual cause (403 secondary rate limit vs. expired auth vs.
  # network) is visible in journalctl instead of N identical opaque lines.
  rerr="$(mktemp)"
  set +e; "$GARDEN_CI_ROLLUP" "$repo" "$pr" >/dev/null 2>"$rerr"; rrc=$?; set -e
  case "$rrc" in
    0)  rm -f "$rerr"; reads_ok=$((reads_ok+1)) ;;          # RED → shepherd (below)
    10) rm -f "$rerr"; reads_ok=$((reads_ok+1)); log "#$pr green — nothing to do"; continue ;;
    11) rm -f "$rerr"; reads_ok=$((reads_ok+1)); log "#$pr has no checks reported — nothing to do"; continue ;;
    12) rm -f "$rerr"; reads_ok=$((reads_ok+1)); log "#$pr CI still in progress/queued — backing off"; pending=$((pending+1)); continue ;;
    *)  rmsg="$(head -n1 "$rerr" 2>/dev/null)"; rm -f "$rerr"
        log "WARN: #$pr rollup unreadable (rc=$rrc): ${rmsg:-<no stderr>} — skipping (never guess a state)"
        unreadable=$((unreadable+1))
        # Cascade circuit-breaker: consecutive unreadable reads with not one success
        # yet this tick means the API is throttling every call. Abort the remaining
        # sweep instead of firing more GraphQL at an already-throttled, cooling-down API.
        if [ "$reads_ok" -eq 0 ] && [ "$unreadable" -ge "$GARDEN_CI_UNREADABLE_ABORT_THRESHOLD" ]; then
          aborted=1; break
        fi
        continue ;;
  esac
  red=$((red+1))

  base="$slug-pr$pr-shepherd"
  # Anti-thrash: if a shepherd for this PR is already live (todo/doin) OR already
  # anywhere in the lifecycle, do not re-post. post-job.sh is also idempotent by
  # basename, so this is belt-and-suspenders + a clean log line.
  if posted_anywhere "$base"; then
    log "#$pr is red but a shepherd job ($base) already exists — idempotent skip"
    continue
  fi

  jb="$(mktemp)"
  {
    printf '# shepherd (auto: red CI) on %s PR #%s\n\n' "$repo" "$pr"
    printf 'CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).\n'
    printf 'Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status\n'
    printf 'watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.\n\n'
    printf 'PR: https://github.com/%s/pull/%s\n' "$repo" "$pr"
    printf 'Head: %s (bot-pushable)\n\n' "$head"
    printf 'Read the failing checks and drive them green (see roles/shepherd/AGENT.md).\n'
    printf 'If the failure is out of a shepherd''s scope, escalate to a fixer per the\n'
    printf 'shepherd→fixer auto-chain. Re-fetch the live check state before acting;\n'
    printf 'this job was minted from a rollup read at post time.\n'
  } > "$jb"
  "$GARDEN_CI_POST" "$base" "$jb" >/dev/null 2>&1 || true
  rm -f "$jb"

  if posted_anywhere "$base" fresh; then
    log "posted $base (auto-shepherd on red CI for #$pr)"
    posted=$((posted+1))
  else
    log "WARN: post of $base did not reach origin/$JOURNAL_BRANCH — will retry next tick"
  fi
done < "$SRC"

log "scanned $open_prs open PR(s) on $repo: $ours bot-authored, $stale stale-skipped, $red red, $pending in-progress, $unreadable unreadable, $posted shepherd job(s) posted"

# Cascade abort: the circuit-breaker tripped — the first reads all fell through
# unreadable with no success, so the API is throttling every call. Emit ONE loud WARN
# and stop; continuing to fire `gh pr view` GraphQL only deepens the rate-limit cooldown.
if [ "$aborted" -eq 1 ]; then
  log "WARN: $unreadable consecutive rollup reads unreadable — aborting tick, likely GitHub rate limit"
  exit 0
fi

# Systemic-outage detection: when EVERY bot PR we READ this tick was unreadable (and we
# read at least one), it is not that many independent per-PR glitches — it is one shared
# failure (gh auth expiry, rate-limit, or network). Collapse the identical per-PR WARN
# lines into one actionable signal so a total outage cannot read as a healthy "0 red,
# all fine" tick. (Distinct from the abort above: this fires when the reads were spread
# across the tick rather than clustered at the front, e.g. an activity-bounded handful.)
if [ "$unreadable" -gt 0 ] && [ "$unreadable" -eq "$((ours - stale))" ]; then
  log "WARN: $unreadable/$((ours - stale)) read bot PR rollups unreadable this tick — likely a systemic gh outage (auth/rate-limit/network), not per-PR"
fi
