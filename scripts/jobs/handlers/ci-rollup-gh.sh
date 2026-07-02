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

require_tools jq "${GARDEN_GH:-gh}"

# One read. Do NOT swallow the failure into emptiness (the 2026-06-24 jq-outage
# lesson): a failed lookup must surface as a nonzero exit (the watcher skips, never
# guesses), never a false green — AND the *reason* (gh's stderr: rate-limit, expired
# token, network blip) must be visible so a systemic outage is diagnosable instead of
# an opaque rc=1.
#
# A single transient TLS/DNS/connection blip must NOT drop a PR's CI verdict for a
# full tick (endojs-endo-but-for-bots#286: one TLS-handshake-timeout left a red PR
# unshepherded; and the recurring `#503/#313/#463 rollup unreadable (TLS handshake
# timeout)` WARNs where one retry would have recovered). So the read routes through
# common.sh's canonical gh_pr_view_retry, which absorbs a transient blip (any
# signature in GARDEN_TRANSIENT_GH_API_SIGNATURES — a 5xx, throttle, DNS/TLS/reset,
# or Go net/http timeout) under a bounded full-jitter backoff (GARDEN_GH_API_ATTEMPTS)
# and surfaces the gh stderr in its own WARN. A DEFINITIVE failure (a 404/401/403/422
# that re-running cannot fix) is NOT retried — it fails fast into the same `exit 1`
# below (the watcher skips, never guesses).
json="$(gh_pr_view_retry "$pr" -R "$repo" --json state,statusCheckRollup 2>/dev/null)" \
  || { log "gh pr view $repo#$pr failed — cannot read CI state (skip, never guess)"; exit 1; }
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
