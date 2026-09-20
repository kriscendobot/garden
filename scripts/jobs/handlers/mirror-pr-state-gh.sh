#!/bin/bash
# mirror-pr-state-gh.sh — default PR-state reader for mirror-closer.sh.
#
# Invoked as: mirror-pr-state-gh.sh <owner/repo> <pr-number>
# Prints ONE TSV line: <state>\t<merged>
#   state  ∈ open | closed
#   merged ∈ true | false   (true only when the PR was merged, not just closed)
#
# Pure read. Uses the fleet `gh` (pinned to the bot by scripts/jobs/bin/gh) and
# external jq. Fails LOUD (FATAL) on a missing tool or a definitive/unavailable
# state — a swallowed error must NEVER masquerade as "open" (which would suppress
# a legitimate close) or as "closed" (which would close a mirror whose upstream is
# still open). This is the 2026-06-24 silent-jq-outage discipline applied to the
# close path.
#
# ONE carve-out from the loud rule: a GitHub PRIMARY-QUOTA refusal. It still exits
# NONZERO with empty stdout (the closer's circuit-breaker contract is unchanged),
# but WITHOUT a FATAL line, because mirror-closer.sh classifies the quota trip from
# this handler's stderr and reports the whole window with ONE aggregate degraded
# WARN. A per-mapping FATAL there would double-report a self-resolving throttle at
# error priority — noise a triage misreads as a real outage. See the block below.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="mirror-pr-state"

repo="${1:?usage: mirror-pr-state-gh.sh <owner/repo> <pr-number>}"
num="${2:?usage: mirror-pr-state-gh.sh <owner/repo> <pr-number>}"

require_tools gh jq

owner="${repo%%/*}"
name="${repo#*/}"

# Read the PR state through GraphQL, NOT the REST `repos/$repo/pulls/$num`
# endpoint. The REST pulls endpoint computes the diff/changed-file list to build
# its response and returns a DEFINITIVE HTTP 422 ("too many files changed") for a
# PR with a very large diff (observed permanently on endojs/endo#3137). That 422
# has no transient signature, so gh_api_retry rightly does not retry it — but it
# made this handler die every tick, forcing mirror-closer.sh to exit 1 forever and
# re-triggering garden-mirror-closer self-heal on every run. GraphQL's
# `pullRequest(number:){state merged}` fetches only the typed state fields and
# never computes the diff, so it does not hit the 422.
#
# Do NOT 2>/dev/null the gh call: a 404 / auth failure / network error must
# surface as a nonzero exit, not as empty output the caller reads as a state.
# gh_api_retry absorbs a TRANSIENT blip (a 5xx / 429 / DNS-TLS-reset the next
# probe would have ridden out — as happened on endojs/endo#3137 at 2026-06-29
# 15:26:06, healed one tick later) by retrying under full-jitter backoff, while
# still failing fast on a DEFINITIVE error (a bad node id, an auth failure) and
# failing loud (nonzero, empty) once the retries are exhausted. `gh api graphql`
# returns nonzero when the response carries a top-level `errors` array (a missing
# repo/PR), so a definitive miss still reaches the die below.
#
# GraphQL `state` is one of OPEN | CLOSED | MERGED. Map to the handler's TSV
# contract — OPEN → open,false; CLOSED → closed,false; MERGED → closed,true — in
# jq, so only a recognized state ever prints. An unknown/null state (e.g. a null
# pullRequest when the node does not exist) falls through to `empty`, yielding no
# output, which the empty-output guard below turns into a loud die rather than a
# guessed state. "Never guess a state" is unchanged.
#
# Capture gh_api_retry's stderr rather than letting it stream straight through, so
# a PRIMARY-QUOTA refusal can be told apart from a definitive failure. We always
# re-emit that diagnostic on our own stderr: journald keeps the original cause and
# mirror-closer.sh's count_handler_failure still classifies the quota trip from it
# (is_gh_primary_rate_limit_text reads the handler's stderr).
errf="$(mktemp 2>/dev/null || printf '%s' "${TMPDIR:-/tmp}/mirror_pr_state_gh.$$")"
if out="$(gh_api_retry graphql \
  -f query='query($owner:String!,$name:String!,$number:Int!){repository(owner:$owner,name:$name){pullRequest(number:$number){state merged}}}' \
  -F owner="$owner" -F name="$name" -F number="$num" \
  --jq '.data.repository.pullRequest | if .state=="MERGED" then "closed\ttrue" elif .state=="CLOSED" then "closed\tfalse" elif .state=="OPEN" then "open\tfalse" else empty end' 2>"$errf")"; then
  rc=0
else
  rc=$?
fi
stderr="$(cat "$errf" 2>/dev/null || true)"
rm -f "$errf"
[ -z "$stderr" ] || printf '%s\n' "$stderr" >&2

if [ "$rc" -ne 0 ]; then
  # GitHub primary-quota exhaustion is account-wide and cannot recover before its
  # hourly reset, so mirror-closer.sh's circuit breaker treats it as a degrade and
  # emits ONE aggregate WARN for the whole tick. Do NOT add a FATAL for it: the
  # nonzero exit + empty stdout already satisfies the closer's no-state contract
  # (its break-and-cooldown), and a per-mapping FATAL would double-report the quota
  # window at error priority — noise a triage reads as a real outage. We exit
  # nonzero (preserving the contract) but quiet; the retained stderr above still
  # carries the rate-limit signature the closer classifies on.
  if is_gh_primary_rate_limit_text "$stderr"; then
    exit "$rc"
  fi
  # Any OTHER failure (auth, a bad node id, exhausted transient retries, a null
  # pullRequest surfacing as a top-level errors array) is a definitive or
  # unavailable state: fail LOUD, exactly as before — a swallowed error must never
  # masquerade as "open" or "closed".
  die "gh api graphql pullRequest state for $repo#$num failed (no usable PR state for the closer)"
fi
[ -n "$out" ] || die "empty PR state for $repo#$num (refusing to guess)"
printf '%s\n' "$out"
