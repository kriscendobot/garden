#!/bin/bash
# pr-maintainer-approval-gh-test.sh -- unit tests for the independent merge gate.
set -euo pipefail
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT="$(cd "$HERE/.." && pwd)/handlers/pr-maintainer-approval-gh.sh"
TR="${HOME:-/home/kris}/.garden-approval-test"
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS + 1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }

rm -rf "$TR"; mkdir -p "$TR"
cat > "$TR/gh" <<'STUB'
#!/bin/bash
if [ "$1" = api ]; then cat "$STUBDIR/reviews"; exit 0; fi
case "$1 $2" in
  "pr view") cat "$STUBDIR/meta" ;;
  *) exit 1 ;;
esac
STUB
chmod +x "$TR/gh"
printf 'kriskowal\nerights\n' > "$TR/maintainers"
export STUBDIR="$TR" GARDEN_GH="$TR/gh" GARDEN_MAINTAINERS_ALLOWLIST="$TR/maintainers"

run() { rc=0; "$SCRIPT" endojs/endo-but-for-bots 792 >/dev/null 2>&1 || rc=$?; }
case_test() {
  printf '%s' "$2" > "$TR/meta"; printf '%s' "$3" > "$TR/reviews"; run
  if [ "$rc" = "$4" ]; then ok "$1 (rc=$rc)"; else bad "$1 (got rc=$rc want $4)"; fi
}

case_test 'no review refuses' '{"reviewDecision":"REVIEW_REQUIRED","headRefOid":"head1"}' '[]' 1
case_test 'dismissed approval refuses' '{"reviewDecision":"APPROVED","headRefOid":"head1"}' '[{"state":"DISMISSED","commit_id":"head1","user":{"login":"kriskowal"}}]' 1
case_test 'approval for older commit refuses as stale' '{"reviewDecision":"APPROVED","headRefOid":"head2"}' '[{"state":"APPROVED","commit_id":"head1","user":{"login":"kriskowal"}}]' 1
case_test 'current maintainer approval allows' '{"reviewDecision":"APPROVED","headRefOid":"head2"}' '[{"state":"APPROVED","commit_id":"head2","user":{"login":"kriskowal"}}]' 0
case_test 'current non-maintainer approval refuses' '{"reviewDecision":"APPROVED","headRefOid":"head2"}' '[{"state":"APPROVED","commit_id":"head2","user":{"login":"drive-by-rando"}}]' 1

# The reviewDecision rollup is a VETO, not the approval authority. GitHub sets it
# only on repos whose branch protection REQUIRES a reviewer; everywhere else it
# stays empty even with an approval on the head commit, which is why reading it as
# the authority made the gate unsatisfiable on endojs/endo-but-for-bots (#656 sat
# green and approved on head 76e6800e with an empty rollup; #708 and #755 hit the
# same wall). These cases pin the empty-rollup branch so that never regresses --
# and pin that letting it through does NOT weaken the individual-review check.
case_test 'empty rollup with current maintainer approval allows' '{"reviewDecision":null,"headRefOid":"head2"}' '[{"state":"APPROVED","commit_id":"head2","user":{"login":"kriskowal"}}]' 0
case_test 'empty rollup with no review still refuses' '{"reviewDecision":null,"headRefOid":"head2"}' '[]' 1
case_test 'empty rollup with stale approval still refuses' '{"reviewDecision":null,"headRefOid":"head2"}' '[{"state":"APPROVED","commit_id":"head1","user":{"login":"kriskowal"}}]' 1
case_test 'empty rollup with non-maintainer approval still refuses' '{"reviewDecision":null,"headRefOid":"head2"}' '[{"state":"APPROVED","commit_id":"head2","user":{"login":"drive-by-rando"}}]' 1
case_test 'changes-requested vetoes a current maintainer approval' '{"reviewDecision":"CHANGES_REQUESTED","headRefOid":"head2"}' '[{"state":"APPROVED","commit_id":"head2","user":{"login":"kriskowal"}}]' 1
case_test 'review-required vetoes a current maintainer approval' '{"reviewDecision":"REVIEW_REQUIRED","headRefOid":"head2"}' '[{"state":"APPROVED","commit_id":"head2","user":{"login":"kriskowal"}}]' 1
# An unreadable head is refused whatever the rollup says: without a head SHA there
# is nothing to pin the approval to, so staleness cannot be judged.
case_test 'missing head refuses' '{"reviewDecision":"APPROVED","headRefOid":""}' '[{"state":"APPROVED","commit_id":"head2","user":{"login":"kriskowal"}}]' 1

rm -rf "$TR"
echo "pr-maintainer-approval: PASS=$PASS FAIL=$FAIL"
[ "$FAIL" -eq 0 ]
