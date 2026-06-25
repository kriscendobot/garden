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

# Do NOT 2>/dev/null the gh call: a 404 / auth failure / network error must
# surface as a nonzero exit, not as empty output the caller reads as a state.
out="$(gh api "repos/$repo/pulls/$num" --jq '[.state, (.merged_at != null)] | @tsv')" \
  || die "gh api repos/$repo/pulls/$num failed (no usable PR state for the closer)"
[ -n "$out" ] || die "empty PR state for $repo#$num (refusing to guess)"
printf '%s\n' "$out"
