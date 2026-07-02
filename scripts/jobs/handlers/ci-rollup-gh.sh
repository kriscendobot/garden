#!/bin/bash
# ci-rollup-gh.sh — default "is this PR's CI red, green, or still running?" probe
# for ci-watcher.sh's auto-shepherd-on-red path.
#
# Invoked as: ci-rollup-gh.sh <owner/name> <pr-number>
#
# Exit code IS the answer (no stdout contract — the watcher reads only $?):
#   0   RED: >=1 completed FAILURE-class check AND 0 pending  → dispatch a shepherd
#   10  GREEN: >=1 check, none failing, none pending          → nothing to do
#   11  NO CHECKS reported at all                              → nothing to do
#   12  IN PROGRESS: >=1 queued/in-progress check             → back off, no shepherd
#   *   any other rc (a die / gh failure)                     → the watcher logs + skips
#
# The RED verdict is DELIBERATELY conservative about the "flake-retry window": a PR
# with a failing check AND a still-pending check returns 12 (in progress), NOT 0 —
# CI has not settled, so a re-run may yet turn it green. Only a COMPLETED red
# (failing present, nothing pending) is the shepherd trigger, matching the "not
# in-progress, not a flake-retry window" requirement.
#
# The check-rollup read is the same shape pr-mergeable-gh.sh uses (statusCheckRollup
# coalesces CheckRun .status/.conclusion and StatusContext .state), kept separate so
# a shepherd trigger never depends on mergeability (a red PR is worth shepherding
# whether or not it also conflicts).
#
# Silent-failure discipline (the 2026-06-24 jq-outage lesson): require_tools fails
# LOUD on a missing binary, and a failed gh call exits nonzero (the watcher then
# skips this PR rather than guessing a state) instead of masquerading as green.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="ci-rollup"

repo="${1:?usage: ci-rollup-gh.sh <owner/name> <pr-number>}"
pr="${2:?usage: ci-rollup-gh.sh <owner/name> <pr-number>}"

require_tools gh jq

# One read. Do NOT swallow the failure into emptiness (the 2026-06-24 jq-outage
# lesson): a failed lookup must surface as a nonzero exit (the watcher skips, never
# guesses), never a false green — AND the *reason* (gh's stderr: rate-limit, expired
# token, network blip) must be visible so a systemic outage is diagnosable instead of
# an opaque rc=1. Capture stderr to a tempfile and fold its first lines into the log.
#
# A single transient TLS/DNS/connection blip must NOT drop a PR's CI verdict for a
# full tick (endojs-endo-but-for-bots#286: one TLS-handshake-timeout left a red PR
# unshepherded). So the read is wrapped in a bounded retry — mirroring
# clone-keeper.sh's bounded_fetch (up to GARDEN_FETCH_RETRIES attempts with backoff)
# — but ONLY when the stderr matches a transient-network class. Rate-limiting is
# DELIBERATELY excluded: ci-watcher.sh already owns throttling with a cascade
# circuit-breaker, and a retry here would only deepen the cooldown. Any other error
# (auth, a real 404, malformed args) is not retried either. On exhausting the budget
# we fall through to the same `exit 1` (the watcher skips, never guesses).
GH_CMD="${GARDEN_CI_ROLLUP_GH:-gh}"

# Transient-network class → worth a retry (a blip that a second attempt clears).
is_transient_network() {
  printf '%s' "$1" | grep -qiE 'TLS handshake timeout|connection reset|i/o timeout|unexpected EOF|Temporary failure in name resolution'
}
# Rate-limiting / throttling → NEVER retried here (ci-watcher.sh's cascade breaker
# owns it; retrying would only deepen the cooldown).
is_rate_limited() {
  printf '%s' "$1" | grep -qiE 'rate limit|API rate limit exceeded|403'
}

gh_err="$(mktemp)"
trap 'rm -f "$gh_err"' EXIT
attempt=1
while :; do
  if json="$("$GH_CMD" pr view "$pr" -R "$repo" --json state,statusCheckRollup 2>"$gh_err")"; then
    break
  fi
  reason="$(tr '\n' ' ' <"$gh_err" | sed -e 's/[[:space:]]\{2,\}/ /g' -e 's/^ *//' -e 's/ *$//')"
  # Retry ONLY a transient-network blip, and NEVER a rate-limit (even if the message
  # happens to also carry a transient-looking token). Everything else falls through.
  if is_rate_limited "$reason" || ! is_transient_network "$reason"; then
    log "gh pr view $repo#$pr failed: ${reason:-<no stderr>} — cannot read CI state (skip, never guess)"
    exit 1
  fi
  if [ "$attempt" -ge "$GARDEN_FETCH_RETRIES" ]; then
    log "gh pr view $repo#$pr failed after $attempt attempt(s) (transient network: ${reason:-<no stderr>}) — cannot read CI state (skip, never guess)"
    exit 1
  fi
  log "gh pr view $repo#$pr transient network error (attempt $attempt): ${reason:-<no stderr>} — retrying"
  backoff "$attempt"; attempt=$((attempt+1))
done
[ -n "$json" ] || { log "empty PR state for $repo#$pr — cannot read CI state"; exit 1; }

# A closed/merged PR is never shepherded (nothing to drive green).
state="$(printf '%s' "$json" | jq -r '.state // ""')"
case "$state" in
  OPEN) : ;;
  *) exit 11 ;;                  # MERGED/CLOSED/unknown → nothing to do
esac

# Count reported checks, failing checks, and pending checks. statusCheckRollup mixes
# CheckRun (.status/.conclusion) and StatusContext (.state) shapes; coalesce both.
total="$(printf '%s' "$json" | jq -r '[ .statusCheckRollup[]? ] | length')"
[ "${total:-0}" = 0 ] && exit 11   # no checks reported at all

pending="$(printf '%s' "$json" | jq -r '
  [ .statusCheckRollup[]?
    | ((.status // .state // "") | ascii_upcase) as $s
    | select($s=="QUEUED" or $s=="IN_PROGRESS" or $s=="PENDING" or $s=="WAITING"
             or $s=="REQUESTED") ]
  | length')"
[ "${pending:-0}" = 0 ] || exit 12   # CI still settling (incl. a retry in flight) → back off

bad="$(printf '%s' "$json" | jq -r '
  [ .statusCheckRollup[]?
    | ((.conclusion // .state // "") | ascii_upcase) as $c
    | select($c=="FAILURE" or $c=="ERROR" or $c=="CANCELLED"
             or $c=="TIMED_OUT" or $c=="ACTION_REQUIRED" or $c=="STARTUP_FAILURE") ]
  | length')"
[ "${bad:-0}" = 0 ] && exit 10   # completed, nothing failing → green

exit 0   # completed with >=1 failing check and nothing pending → RED
