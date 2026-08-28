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
# The exact-current-head freshness guard is REMOVED: an active maintainer approval on
# an EARLIER commit still authorizes the later head (a rebase or follow-up push no
# longer staleness-dismisses it). GitHub-dismissal and a later CHANGES_REQUESTED are
# the only revocations, tested below.
case_test 'approval for older commit authorizes later head' '{"reviewDecision":"APPROVED","headRefOid":"head2"}' '[{"state":"APPROVED","commit_id":"head1","user":{"login":"kriskowal"}}]' 0
case_test 'current maintainer approval allows' '{"reviewDecision":"APPROVED","headRefOid":"head2"}' '[{"state":"APPROVED","commit_id":"head2","user":{"login":"kriskowal"}}]' 0
case_test 'current non-maintainer approval refuses' '{"reviewDecision":"APPROVED","headRefOid":"head2"}' '[{"state":"APPROVED","commit_id":"head2","user":{"login":"drive-by-rando"}}]' 1
case_test 'earlier-head non-maintainer approval still refuses' '{"reviewDecision":"APPROVED","headRefOid":"head2"}' '[{"state":"APPROVED","commit_id":"head1","user":{"login":"drive-by-rando"}}]' 1
# Effective-state precedence: the LATEST state-bearing review per maintainer wins.
case_test 'later dismissal of an earlier approval refuses' '{"reviewDecision":"APPROVED","headRefOid":"head2"}' '[{"state":"APPROVED","commit_id":"head1","user":{"login":"kriskowal"}},{"state":"DISMISSED","commit_id":"head1","user":{"login":"kriskowal"}}]' 1
case_test 'later changes-requested vetoes an earlier approval' '{"reviewDecision":"APPROVED","headRefOid":"head2"}' '[{"state":"APPROVED","commit_id":"head1","user":{"login":"kriskowal"}},{"state":"CHANGES_REQUESTED","commit_id":"head2","user":{"login":"kriskowal"}}]' 1
case_test 're-approval after a dismissal authorizes' '{"reviewDecision":"APPROVED","headRefOid":"head3"}' '[{"state":"APPROVED","commit_id":"head1","user":{"login":"kriskowal"}},{"state":"DISMISSED","commit_id":"head1","user":{"login":"kriskowal"}},{"state":"APPROVED","commit_id":"head2","user":{"login":"kriskowal"}}]' 0
case_test 'a later COMMENTED review never masks a standing approval' '{"reviewDecision":"APPROVED","headRefOid":"head2"}' '[{"state":"APPROVED","commit_id":"head1","user":{"login":"kriskowal"}},{"state":"COMMENTED","commit_id":"head2","user":{"login":"kriskowal"}}]' 0
case_test 'a maintainer CHANGES_REQUESTED vetoes another maintainer approval' '{"reviewDecision":"APPROVED","headRefOid":"head2"}' '[{"state":"APPROVED","commit_id":"head2","user":{"login":"kriskowal"}},{"state":"CHANGES_REQUESTED","commit_id":"head2","user":{"login":"erights"}}]' 1

# The reviewDecision rollup is a VETO, not the approval authority. GitHub sets it
# only on repos whose branch protection REQUIRES a reviewer; everywhere else it
# stays empty even with an approval on the head commit, which is why reading it as
# the authority made the gate unsatisfiable on endojs/endo-but-for-bots (#656 sat
# green and approved on head 76e6800e with an empty rollup; #708 and #755 hit the
# same wall). These cases pin the empty-rollup branch so that never regresses --
# and pin that letting it through does NOT weaken the individual-review check.
case_test 'empty rollup with current maintainer approval allows' '{"reviewDecision":null,"headRefOid":"head2"}' '[{"state":"APPROVED","commit_id":"head2","user":{"login":"kriskowal"}}]' 0
case_test 'empty rollup with no review still refuses' '{"reviewDecision":null,"headRefOid":"head2"}' '[]' 1
# Empty rollup + an approval on an earlier head: with the freshness guard removed this
# now authorizes (the individual-review gate keys off effective state, not commit_id).
case_test 'empty rollup with earlier-head approval authorizes' '{"reviewDecision":null,"headRefOid":"head2"}' '[{"state":"APPROVED","commit_id":"head1","user":{"login":"kriskowal"}}]' 0
case_test 'empty rollup with non-maintainer approval still refuses' '{"reviewDecision":null,"headRefOid":"head2"}' '[{"state":"APPROVED","commit_id":"head2","user":{"login":"drive-by-rando"}}]' 1
case_test 'empty rollup with a dismissed approval refuses' '{"reviewDecision":null,"headRefOid":"head2"}' '[{"state":"DISMISSED","commit_id":"head1","user":{"login":"kriskowal"}}]' 1
case_test 'changes-requested vetoes a current maintainer approval' '{"reviewDecision":"CHANGES_REQUESTED","headRefOid":"head2"}' '[{"state":"APPROVED","commit_id":"head2","user":{"login":"kriskowal"}}]' 1
case_test 'review-required vetoes a current maintainer approval' '{"reviewDecision":"REVIEW_REQUIRED","headRefOid":"head2"}' '[{"state":"APPROVED","commit_id":"head2","user":{"login":"kriskowal"}}]' 1
# An unreadable head is refused whatever the rollup says: an empty headRefOid signals
# degenerate/broken PR metadata, so the gate fails closed (defensive, not a staleness
# judgement -- staleness is no longer consulted).
case_test 'missing head refuses' '{"reviewDecision":"APPROVED","headRefOid":""}' '[{"state":"APPROVED","commit_id":"head2","user":{"login":"kriskowal"}}]' 1

rm -rf "$TR"
echo "pr-maintainer-approval: PASS=$PASS FAIL=$FAIL"
[ "$FAIL" -eq 0 ]
