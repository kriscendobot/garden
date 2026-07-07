#!/bin/bash
# mirror-pr-state-gh.sh — default PR-state reader for mirror-closer.sh.
#
# Invoked as: mirror-pr-state-gh.sh <owner/repo> <pr-number>
# Prints ONE TSV line: <state>\t<merged>
#   state  ∈ open | closed
#   merged ∈ true | false   (true only when the PR was merged, not just closed)
#
# Pure read. Uses the fleet `gh` (pinned to the bot by scripts/jobs/bin/gh) and
# external jq. Fails LOUD on a missing tool or a failed call — a swallowed error
# must NEVER masquerade as "open" (which would suppress a legitimate close) or as
# "closed" (which would close a mirror whose upstream is still open). This is the
# 2026-06-24 silent-jq-outage discipline applied to the close path.

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
out="$(gh_api_retry graphql \
  -f query='query($owner:String!,$name:String!,$number:Int!){repository(owner:$owner,name:$name){pullRequest(number:$number){state merged}}}' \
  -F owner="$owner" -F name="$name" -F number="$num" \
  --jq '.data.repository.pullRequest | if .state=="MERGED" then "closed\ttrue" elif .state=="CLOSED" then "closed\tfalse" elif .state=="OPEN" then "open\tfalse" else empty end')" \
  || die "gh api graphql pullRequest state for $repo#$num failed (no usable PR state for the closer)"
[ -n "$out" ] || die "empty PR state for $repo#$num (refusing to guess)"
printf '%s\n' "$out"
