#!/bin/bash
# fixer-reentry-pr-test.sh - a completing fixer re-enters ITS OWN PR, never merely
# the first PR its report cites (fix-minion-town-pr180-ocap-key-audit-20261017
# re-entered docs-only draft #203 and failed a finished job).
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
# shellcheck source=../common.sh
source "$JOBS/common.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/fixer-reentry-pr.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
fail() { echo "fixer-reentry-pr-test: FAIL: $*" >&2; exit 1; }
M=https://github.com/kriscendobot/minion.town/pull

printf 'role: fixer\nFix %s/180 per review.\n' "$M" > "$TR/job"
printf 'Opened %s/203 for docs; pushed kriscendobot/minion.town#180.\n' "$M" > "$TR/report"
[ "$(fixer_reentry_pr "$TR/job" "$TR/report" fix-x)" = "$M/180" ] || fail 'did not prefer the job PR over the first report PR'

printf 'Only cites %s/203.\n' "$M" > "$TR/report"
[ "$(fixer_reentry_pr "$TR/job" "$TR/report" fix-x)" = "$M/180" ] || fail 'did not fall back to the job PR'

printf 'role: fixer\nAudit the ocap key handling.\n' > "$TR/job"
printf 'See %s/203 and %s/180.\n' "$M" "$M" > "$TR/report"
[ "$(fixer_reentry_pr "$TR/job" "$TR/report" fix-minion-town-pr180-ocap-key-audit-20261017)" = "$M/180" ] \
  || fail 'did not match the base pr<N> against the report'
[ -z "$(fixer_reentry_pr "$TR/job" "$TR/report" fix-unrelated)" ] || fail 'guessed a PR the job does not own'
printf 'See %s/180 and https://github.com/endojs/endo/pull/180.\n' "$M" > "$TR/report"
[ -z "$(fixer_reentry_pr "$TR/job" "$TR/report" fix-pr180)" ] || fail 'picked one of two ambiguous pr<N> matches'
echo 'fixer-reentry-pr-test: PASS'
