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
# A second per-tick pass — the STALE-SHEPHERD RE-VALIDATION SWEEP — closes the
# false-positive-wedge loop: a shepherd minted from a point-in-time red whose CI
# self-heals BEFORE the job is claimed (a flake that later passes, or an in-progress
# check that later goes green) would be claimed, re-fetch a no-longer-red CI, exit 0
# without the completion marker, and get requeued+escalated as a phantom "WEDGED
# child" (endojs-endo-but-for-bots-pr693, journal 2026-07-11T18:34Z). So each tick,
# every auto-shepherd base still UNCLAIMED in todo/ has its rollup re-read; a verdict
# no longer RED (green/none/pending) retires the shepherd deterministically
# (todo→tada, completion marker carried) so it is never claimed to begin with.
# doin/ claims are never touched — retirement is unclaimed-todo/-only.
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
#   GARDEN_CI_PR_SOURCE <owner/name> <bot-login>  -> TSV: number author head_repo updated_at title
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
# A write clone for the stale-shepherd re-validation sweep (below): it moves a stale
# auto-shepherd todo/→tada/ with a CAS push, so it needs a working tree of its own,
# distinct from the read-only VERIFY clone and from post-job.sh's producer clone.
: "${GARDEN_CI_RETIRE_CLONE:=$GARDEN_STATE/ci-watcher/retire}"
RETIRE="$GARDEN_CI_RETIRE_CLONE"
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
# NOT a bot repo (e.g. an upstream watched for comments but not bot-authored
# PR-driven) exits cleanly here before any gh call.
#
# The garden's OWN repo is denied ahead of the bot-fork rule, and the ordering is
# load-bearing. The garden runs no PR workflow on itself — main2 and journal2 are
# pushed direct (CLAUDE.md § Conventions) — so its only open PRs are long-lived
# review vessels a shepherd must never drive. That used to hold by accident: the
# repo was kriskowal/garden, which simply is not bot-owned. The 2026-07-28 transfer
# moved it to kriscendobot/garden, putting it INSIDE the "$GARDEN_BOT_LOGIN"/* arm
# and making every auto-shepherd gate pass for PR #28 ("main2 review vessel —
# feedback only, do not merge"). State the rule where it cannot be re-acquired by
# accident, keyed to the canonical repo and its migration aliases so it follows any
# future transfer.
is_bot_repo() {  # is_bot_repo <owner/name>
  local r
  for r in "$GARDEN_PRODUCTION_JOURNAL_REPO" $GARDEN_PRODUCTION_JOURNAL_REPO_ALIASES; do
    [ "$1" = "$r" ] && return 1                 # the garden's own repo — never self-shepherd
  done
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
  for sub in "$JOBS_TODO" "$JOBS_DOIN"; do
    git -C "$VERIFY" cat-file -e "origin/$JOURNAL_BRANCH:$sub/$base.md" 2>/dev/null && return 0
  done
  tada_find_tree "$VERIFY" "origin/$JOURNAL_BRANCH" "$base" >/dev/null && return 0
  return 1
}

# --- retire a stale auto-shepherd (todo/ → tada/, CAS) -----------------------
# Deterministically retire an UNCLAIMED auto-shepherd whose red self-healed before
# the job was claimed: move jobs/todo/<base>.md → jobs/tada/<base>.md with an auto
# completion report carrying the completion marker, so the board records it as
# genuinely done rather than leaving it to be claimed, re-fetch a no-longer-red CI,
# and exit-0-unsatisfying (the endojs-endo-but-for-bots-pr693 phantom-wedge loop,
# journal 2026-07-11T18:34Z). CAS-pushed on a dedicated write clone exactly like a
# post; the doin/-only guard (never touch a claim) is re-checked inside the retry
# loop so a gardener that claims between our rollup read and our push is never raced.
# rc 0 retired (or already gone), 2 no-longer-unclaimed (left in place), 1 gave up.
retire_stale_shepherd() {  # retire_stale_shepherd <base> <verdict-phrase>
  local base="$1" phrase="$2" attempt rc
  ensure_clone "$RETIRE"
  for attempt in $(seq 1 "${GARDEN_CI_RETIRE_ATTEMPTS:-50}"); do
    sync_clone "$RETIRE"
    # UNCLAIMED-only: if the job is no longer in todo/ (a gardener claimed it into
    # doin/, or it already drained to tada/), never touch it — we must not race an
    # in-flight gardener's claim (the "todo/ only" restriction the job specifies).
    if [ ! -e "$RETIRE/$JOBS_TODO/$base.md" ]; then
      log "stale-shepherd $base no longer unclaimed in todo/ (claimed or completed) — leaving it"
      return 2
    fi
    mkdir -p "$RETIRE/$JOBS_TADA"
    {
      printf '# shepherd (auto) retired: CI recovered/settled before claim\n\n'
      printf 'CI recovered/settled before claim — nothing to shepherd; ci-watcher retired\n'
      printf 'this stale auto-shepherd. The CI-status watcher minted `%s`\n' "$base"
      printf 'from a point-in-time RED rollup read; on a later tick the live rollup was\n'
      printf '%s (no longer red), so this stale auto-shepherd was retired\n' "$phrase"
      printf 'deterministically (todo -> tada) rather than left to be claimed, re-fetch a\n'
      printf 'no-longer-red CI, and exit-0-unsatisfying.\n\n'
      printf 'Retired by: ci-watcher stale-shepherd re-validation sweep on %s.\n\n' "$GARDEN"
      printf '%s\n' "$GARDEN_COMPLETION_MARKER"
    } > "$RETIRE/$JOBS_TADA/$base.md"
    git -C "$RETIRE" add "$JOBS_TADA/$base.md"
    git -C "$RETIRE" rm -q "$JOBS_TODO/$base.md"
    rc=0; commit_and_push "$RETIRE" "tada($base) retired stale auto-shepherd by $GARDEN (CI $phrase)" || rc=$?
    [ "$rc" -eq 0 ] && return 0
    [ "$rc" -eq 2 ] && return 0   # nothing to commit — already retired/settled
    log "retire of '$base' lost a push race (attempt $attempt); re-syncing"
    backoff "$attempt"
  done
  log "WARN: could not retire stale shepherd '$base' after retries"
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

# A source failure normally must remain loud: proceeding with a partial or absent
# PR list would silently stop CI surveillance.  A repository that has been deleted,
# renamed, transferred, or made unreadable is the one exception.  It will fail the
# source on every tick forever, so confirm that narrow condition with an authoritative
# repo probe, alert once, and deactivate cleanly rather than crash-looping the unit.
# This mirrors comment-source-gh.sh's repo-gone guard.  The probe is paid only after
# a failed source; transient probe failures are never mistaken for a gone repository.
REPO_GONE_REASON=""
repo_is_definitively_gone() {
  local probe_err stderr
  probe_err="$(mktemp 2>/dev/null || printf '%s' "${TMPDIR:-/tmp}/ci-watcher-repo-probe.$$")"
  if gh_api_retry "repos/$repo" --jq '.full_name' >/dev/null 2>"$probe_err"; then
    rm -f "$probe_err"; return 1                # repo answers: retain source failure
  fi
  stderr="$(cat "$probe_err" 2>/dev/null || true)"
  rm -f "$probe_err"
  _gh_api_stderr_is_transient "$stderr" && return 1
  case "$stderr" in
    *"Not Found"*|*"HTTP 404"*|*'"status":"404"'*|*"HTTP 403"*|*"Must have admin rights"*)
      REPO_GONE_REASON="$stderr"; return 0 ;;
  esac
  return 1
}

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
  # GitHub overloaded → an HTML gateway/5xx/rate-limit page instead of JSON, so
  # `gh pr list … | jq` fails rc=1 with a Go-decoder/HTTP-5NN/rate-limit signature
  # that is_transient_net_error doesn't catch. Absorb it the same way (WARN + skip)
  # via the shared GARDEN_TRANSIENT_GH_API_SIGNATURES gate, so an overload page
  # doesn't detonate the restart storm. A structural failure still dies loud below.
  if is_transient_gh_source_error "$ERRF"; then
    log "WARN: ci PR source hit a transient gh-api blip (5xx/HTML/rate-limit) — skipping tick (never guess)"
    exit 0
  fi
  if repo_is_definitively_gone; then
    log "REPO GONE: $repo returns a definitive repo-level error (${REPO_GONE_REASON:-<no stderr>}) — the repo does not exist or is no longer readable. Deactivating this watch gracefully (exit 0) instead of failing the tick forever."
    alert_maintainer "ci-watch-repo-gone-${slug//[^A-Za-z0-9._-]/_}" \
      "ci-watcher: $repo no longer exists (or is unreadable) on GitHub — gh api repos/$repo returns a definitive error: ${REPO_GONE_REASON:-<no stderr>}. The watcher is armed by journal comment-repos/$slug, so every tick would otherwise fail forever; it now exits 0 and watches nothing. To close this out: delete journal comment-repos/$slug (and any repos/$slug sibling), add a journal watch-optout/$slug tombstone so fork-watch-provisioner.sh never re-arms it, and remove the stale bare clone worktrees/$slug.git that likely triggered the arming. If instead the repo was RENAMED or TRANSFERRED, re-key the arming record to the new <owner>-<name> slug rather than dropping the watch."
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
# The source's trailing `title` column exists for the dependabot-watcher's supersession
# preflight; read it into a throwaway so it can never be appended onto `updated` and
# corrupt the activity-window comparison below.
while IFS=$'\t' read -r pr author head updated _title; do
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
    printf 'handler-timeout: %s\n\n' "$GARDEN_SHEPHERD_HANDLER_TIMEOUT"
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

# ── Stale-shepherd re-validation sweep ───────────────────────────────────────
# Close the false-positive-wedge loop (the endojs-endo-but-for-bots-pr693
# exit-0-unsatisfying escalation, journal 2026-07-11T18:34Z). An auto-shepherd is
# minted from a POINT-IN-TIME red rollup; if that red self-heals before the job is
# claimed — a flake that later passes, or a check still IN_PROGRESS that later goes
# green — the shepherd agent re-fetches, finds CI no-longer-red, has nothing to do,
# and exits 0 WITHOUT the completion marker. gardener.sh classifies that
# exit-0-unsatisfying, requeues doin→todo, and the elapsed-constancy detector
# escalates a phantom `kind:error` "WEDGED child". So each tick, for every
# auto-shepherd base this watcher owns that is still UNCLAIMED in todo/, re-read the
# rollup: if it is no longer RED (green/none/pending), the shepherd is stale — retire
# it deterministically (todo → tada) so it is never claimed to begin with, breaking
# the requeue/escalation cycle. Board-driven (enumerate todo/, not the PR source), so
# a stale shepherd for a PR now beyond the activity window is still caught. Skipped
# when the cascade breaker tripped above (that `exit 0`s before here), so the sweep
# never fires more rollup reads at an already-throttled API. Leader-only comes free:
# this runs inside the same is-main-host.sh-gated unit as the post path (header
# § Leader-only singleton), so a follower never double-retires.
retired=0; revalidated=0
if verify_fetch fresh; then
  # Enumerate THIS watcher's shepherd jobs currently in todo/ on the live board.
  todo_shepherds="$(git -C "$VERIFY" ls-tree --name-only "origin/$JOURNAL_BRANCH:$JOBS_TODO" 2>/dev/null \
                      | sed -n 's/\.md$//p' | grep -E "^${slug}-pr[0-9]+-shepherd$" || true)"
  for base in $todo_shepherds; do
    pr="${base#"$slug"-pr}"; pr="${pr%-shepherd}"
    case "$pr" in ''|*[!0-9]*) continue ;; esac   # defensive: numeric PR ids only
    revalidated=$((revalidated+1))
    # Re-read the rollup DETERMINISTICALLY — same handler, same verdict codes as the
    # post pass. Only a definitive no-longer-red verdict retires; an unreadable state
    # leaves the shepherd untouched (never guess a state).
    rerr="$(mktemp)"
    set +e; "$GARDEN_CI_ROLLUP" "$repo" "$pr" >/dev/null 2>"$rerr"; srrc=$?; set -e
    case "$srrc" in
      0)  rm -f "$rerr"; log "stale-check #$pr still RED — auto-shepherd $base stands"; continue ;;
      10) rm -f "$rerr"; phrase="green" ;;
      11) rm -f "$rerr"; phrase="reporting no checks" ;;
      12) rm -f "$rerr"; phrase="in progress/queued (settling)" ;;
      *)  smsg="$(head -n1 "$rerr" 2>/dev/null)"; rm -f "$rerr"
          log "WARN: stale-check #$pr rollup unreadable (rc=$srrc): ${smsg:-<no stderr>} — leaving $base (never guess a state)"
          continue ;;
    esac
    if retire_stale_shepherd "$base" "$phrase"; then
      log "retired stale auto-shepherd $base (#$pr CI $phrase, no longer red — nothing to shepherd)"
      retired=$((retired+1))
    fi
  done
else
  log "WARN: stale-shepherd sweep skipped this tick — journal fetch failed (never guess board state)"
fi
if [ "$revalidated" -gt 0 ]; then
  log "stale-shepherd sweep on $repo: re-validated $revalidated unclaimed auto-shepherd(s), retired $retired"
fi
