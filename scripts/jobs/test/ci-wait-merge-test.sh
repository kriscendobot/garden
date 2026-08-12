#!/bin/bash
# ci-wait-merge-test.sh — validate the conductor's CI-wait-then-merge spine on
# throwaway fixtures, with no GitHub. The gh CLI is stubbed (GARDEN_GH) by a
# sequence of canned statusCheckRollup JSONs so the block-until-terminal loop and
# the merge-in-the-same-job behaviour run for real.
#
# The latent bug this guards (endo-but-for-bots #178, bit twice): a merge job that
# finds CI PENDING must NOT complete unmerged — it blocks until CI settles, then
# merges on green / reports on red, and on a watch timeout re-enqueues (exit 4)
# rather than silently landing in tada green-but-unmerged.
#
# Asserts:
#   T1 pending,pending,green   → blocks, then merges (exit 0, merge called)
#   T2 red terminal            → exit 3, merge NEVER called
#   T3 never-terminal pending  → timeout exit 4, merge NEVER called (re-enqueue)
#   T4 already MERGED on entry → exit 0, idempotent (no merge call)
#   T5 green but verify!=MERGED → exit 1 (never reports a merge that didn't happen)
#   T6 --no-merge probe, green → exit 0, merge NEVER called
#   T7 CLOSED on entry         → exit 2
#   T8 stale GARDEN_GH (vanished temp path) → falls back to the durable PATH gh
#      (fleet wrapper) and still merges, never dropping the merge (the #178 fix)
#   T9 frozen base, no sibling → unfreeze base to live trunk, then merge (exit 0,
#      base edited, merge called) — conductor step 2 (the #510 stranding fix)
#   T10 frozen base shared by a sibling stack → alert maintainer, exit 1, NO merge,
#      NO base edit (neither strand silently nor force-fork the shared base)
#   T11 green + reviewDecision=CHANGES_REQUESTED → refuse to merge (exit 1, NO
#      merge): a maintainer review landing mid-wait is never merged over even
#      though GitHub reports the PR mergeable (kriscendobot/minion.town#7)
#   T12 downstream open PR based on the head branch → merge WITHOUT
#      --delete-branch (branch retained; the endo-but-for-bots #800 auto-close)
#   T13 head-branch read fails → fail-RETAIN: merge but keep the branch
#   T14 explicit dependabot mode + human author + no approval → no merge
#   T15 explicit dependabot mode + CHANGES_REQUESTED → no merge
#   T16 explicit dependabot mode + dependabot author + no approval → merge
#   T17 explicit dependabot mode + non-owned repo + no approval → no merge
#   T18 explicit dependabot mode + unreadable author + no approval → no merge
#   T19 explicit dependabot mode + unreadable final review state → no merge
#
# Usage: ci-wait-merge-test.sh
set -euo pipefail
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT="$(cd "$HERE/.." && pwd)/gardening/ci-wait-merge.sh"
# Test root under $HOME: the sandbox refuses to exec stubs placed under /tmp.
TR="${HOME:-/home/kris}/.garden-ciwait-test"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }

rm -rf "$TR"; mkdir -p "$TR"
export STUBDIR="$TR" GARDEN_GH="$TR/gh"
export GARDEN_NO_MAINTAINER_ALERT=1
export GARDEN_CI_POLL_SECS=0 GARDEN_CI_POLL_MAX_SECS=0 GARDEN_CI_DEADLINE_SECS=5
printf 'kriskowal\n' > "$TR/maintainers"
export GARDEN_MAINTAINERS_ALLOWLIST="$TR/maintainers"

cat > "$TR/gh" <<'STUB'
#!/bin/bash
# Stub gh: rollup reads pop the i-th line of $STUBDIR/seq (base64 JSON); the
# verify probe reads $STUBDIR/verify; pr merge appends to $STUBDIR/merge.log.
# Unfreeze (conductor step 2): the `--json state,baseRefName` read returns
# $STUBDIR/basemeta (default: a LIVE base → no unfreeze); `pr list` returns the
# shared-base PR count/numbers; `pr edit --base` appends to $STUBDIR/edit.log.
SEQ="$STUBDIR/seq"; i=$(cat "$STUBDIR/i" 2>/dev/null || echo 0)
if [ "$1" = api ]; then cat "$STUBDIR/reviews" 2>/dev/null || printf '[{"state":"APPROVED","commit_id":"head123","user":{"login":"kriskowal"}}]'; exit 0; fi
case "$1 $2" in
  "pr view")
    if printf ' %s' "$@" | grep -q -- '--json state,autoMergeRequest'; then cat "$STUBDIR/verify"; exit 0; fi
    if printf ' %s' "$@" | grep -q -- '--json author'; then
      [ -f "$STUBDIR/author_fail" ] && exit 1
      cat "$STUBDIR/author" 2>/dev/null || printf '{"author":{"login":"dependabot[bot]"}}'; exit 0; fi
    if printf ' %s' "$@" | grep -q -- '--json reviewDecision$'; then
      [ -f "$STUBDIR/finalreview_fail" ] && exit 1
      cat "$STUBDIR/finalreview" 2>/dev/null || printf '{"reviewDecision":""}'; exit 0; fi
    if printf ' %s' "$@" | grep -q -- '--json reviewDecision,headRefOid'; then
      cat "$STUBDIR/approvalmeta" 2>/dev/null || printf '{"reviewDecision":"APPROVED","headRefOid":"head123"}'; exit 0; fi
    if printf ' %s' "$@" | grep -q -- '--json statusCheckRollup --jq'; then cat "$STUBDIR/failures" 2>/dev/null; exit 0; fi
    if printf ' %s' "$@" | grep -q -- '--json state,baseRefName'; then
      cat "$STUBDIR/basemeta" 2>/dev/null || printf '{"state":"OPEN","baseRefName":"llm"}'; exit 0; fi
    if printf ' %s' "$@" | grep -q -- '--json headRefName'; then
      cat "$STUBDIR/headref" 2>/dev/null || echo "feat-x"; exit 0; fi
    line=$(sed -n "$((i+1))p" "$SEQ"); echo $((i+1)) > "$STUBDIR/i"
    [ -z "$line" ] && line=$(tail -n1 "$SEQ")   # past the script → repeat last
    printf '%s' "$line" | base64 -d; exit 0 ;;
  "pr list")
    # --base flag → the branch-retention downstream check; base:… search → the
    # frozen-base sibling check.
    if printf ' %s' "$@" | grep -q -- ' --base '; then
      cat "$STUBDIR/downstream" 2>/dev/null || echo ""; exit 0; fi
    if printf ' %s' "$@" | grep -q -- 'join'; then cat "$STUBDIR/prnums" 2>/dev/null || echo ""
    else cat "$STUBDIR/prcount" 2>/dev/null || echo 1; fi
    exit 0 ;;
  "pr edit") echo "edit: $*" >> "$STUBDIR/edit.log"; exit 0 ;;
  "pr merge") echo "merge: $*" >> "$STUBDIR/merge.log"; [ -f "$STUBDIR/merge_fail" ] && exit 1; exit 0 ;;
esac
exit 0
STUB
chmod +x "$TR/gh"

b64() { printf '%s' "$1" | base64 | tr -d '\n'; }
PEND='{"state":"OPEN","mergeable":"MERGEABLE","statusCheckRollup":[{"name":"build","status":"IN_PROGRESS","conclusion":null}]}'
GREEN='{"state":"OPEN","mergeable":"MERGEABLE","statusCheckRollup":[{"name":"build","status":"COMPLETED","conclusion":"SUCCESS"}]}'
RED='{"state":"OPEN","mergeable":"MERGEABLE","statusCheckRollup":[{"name":"build","status":"COMPLETED","conclusion":"FAILURE"}]}'
# Green CI but a maintainer requested changes: reviewDecision drives the gate.
GREEN_CR='{"state":"OPEN","mergeable":"MERGEABLE","reviewDecision":"CHANGES_REQUESTED","statusCheckRollup":[{"name":"build","status":"COMPLETED","conclusion":"SUCCESS"}]}'

reset_seq() { : > "$STUBDIR/seq"; echo 0 > "$STUBDIR/i"; rm -f "$STUBDIR/merge.log" "$STUBDIR/edit.log" "$STUBDIR/basemeta" "$STUBDIR/prcount" "$STUBDIR/prnums" "$STUBDIR/downstream" "$STUBDIR/headref" "$STUBDIR/author" "$STUBDIR/author_fail" "$STUBDIR/finalreview" "$STUBDIR/finalreview_fail" "$STUBDIR/reviews" "$STUBDIR/approvalmeta"; }
seq_add()   { b64 "$1" >> "$STUBDIR/seq"; printf '\n' >> "$STUBDIR/seq"; }
chk()       { if [ "$1" = "$2" ]; then ok "$3 (rc=$1)"; else bad "$3 (got rc=$1 want $2)"; fi; }
merged()    { if [ -f "$STUBDIR/merge.log" ]; then ok "$1 merge called"; else bad "$1 merge NOT called"; fi; }
nomerge()   { if [ -f "$STUBDIR/merge.log" ]; then bad "$1 merge WAS called"; else ok "$1 no merge"; fi; }
edited()    { if [ -f "$STUBDIR/edit.log" ]; then ok "$1 base unfrozen"; else bad "$1 base NOT unfrozen"; fi; }
noedit()    { if [ -f "$STUBDIR/edit.log" ]; then bad "$1 base WAS edited"; else ok "$1 no base edit"; fi; }
deleted()   { if grep -q -- '--delete-branch' "$STUBDIR/merge.log" 2>/dev/null; then ok "$1 head branch deleted"; else bad "$1 head branch NOT deleted"; fi; }
retained()  { if grep -q -- '--delete-branch' "$STUBDIR/merge.log" 2>/dev/null; then bad "$1 head branch WAS deleted"; else ok "$1 head branch retained"; fi; }
# set -e-safe invocation: capture the exit code without aborting the suite.
run()       { rc=0; bash "$SCRIPT" "$@" >/dev/null 2>&1 || rc=$?; }

echo "T1 pending,pending,green → blocks then merges"
reset_seq; seq_add "$PEND"; seq_add "$PEND"; seq_add "$GREEN"; printf 'MERGED|false' > "$STUBDIR/verify"
run o/r 178; chk "$rc" 0 T1; merged T1; deleted T1

echo "T2 red terminal → exit 3, no merge"
reset_seq; seq_add "$RED"; printf '  red: build = FAILURE\n' > "$STUBDIR/failures"
run o/r 178; chk "$rc" 3 T2; nomerge T2

echo "T3 never-terminal → timeout exit 4 (re-enqueue), no merge"
reset_seq; seq_add "$PEND"
GARDEN_CI_DEADLINE_SECS=1 run o/r 178; chk "$rc" 4 T3; nomerge T3

echo "T4 already MERGED → exit 0, idempotent"
reset_seq; seq_add '{"state":"MERGED","statusCheckRollup":[]}'
run o/r 178; chk "$rc" 0 T4; nomerge T4

echo "T5 green but verify != MERGED → exit 1 (no false merge report)"
reset_seq; seq_add "$GREEN"; printf 'OPEN|false' > "$STUBDIR/verify"
run o/r 178; chk "$rc" 1 T5

echo "T6 --no-merge probe, green → exit 0, no merge"
reset_seq; seq_add "$GREEN"
run o/r 178 --no-merge; chk "$rc" 0 T6; nomerge T6

echo "T7 CLOSED → exit 2"
reset_seq; seq_add '{"state":"CLOSED","statusCheckRollup":[]}'
run o/r 178; chk "$rc" 2 T7

echo "T8 stale GARDEN_GH (vanished temp path) → falls back to durable PATH gh, still merges"
# The #178 root cause: GARDEN_GH pointed at a mktemp -d wrapper already cleaned up
# by the time the wait's tool check ran, so require_tools fired and the merge was
# dropped. Reproduce: place the stub at the fleet-wrapper location common.sh
# prepends to PATH (via GARDEN_ROOT=$TR), then point GARDEN_GH at a path that does
# NOT exist. The script must IGNORE the stale override, resolve gh via the durable
# PATH wrapper, and complete the merge (exit 0) rather than die on a missing tool.
reset_seq; seq_add "$PEND"; seq_add "$GREEN"; printf 'MERGED|false' > "$STUBDIR/verify"
mkdir -p "$TR/scripts/jobs/bin"; cp "$TR/gh" "$TR/scripts/jobs/bin/gh"; chmod +x "$TR/scripts/jobs/bin/gh"
rc=0
GARDEN_ROOT="$TR" GARDEN_GH="$TR/gone-$$/gh" bash "$SCRIPT" o/r 178 >/dev/null 2>&1 || rc=$?
chk "$rc" 0 T8; merged T8

echo "T9 frozen base, no sibling → unfreeze to live trunk, then merge"
reset_seq; seq_add "$GREEN"; printf 'MERGED|false' > "$STUBDIR/verify"
printf '{"state":"OPEN","baseRefName":"llm-65b0abe"}' > "$STUBDIR/basemeta"
echo 1 > "$STUBDIR/prcount"   # only #510 itself sits on the frozen base
run o/r 510; chk "$rc" 0 T9; edited T9; merged T9

echo "T10 frozen base shared by a sibling stack → alert, exit 1, no merge, no fork"
reset_seq; seq_add "$GREEN"; printf 'MERGED|false' > "$STUBDIR/verify"
printf '{"state":"OPEN","baseRefName":"llm-65b0abe"}' > "$STUBDIR/basemeta"
echo 2 > "$STUBDIR/prcount"; printf '510, #521' > "$STUBDIR/prnums"   # #510 + sibling #521
run o/r 510; chk "$rc" 1 T10; nomerge T10; noedit T10

echo "T11 green + reviewDecision=CHANGES_REQUESTED → refuse to merge (exit 1, no merge)"
reset_seq; seq_add "$GREEN_CR"; printf 'MERGED|false' > "$STUBDIR/verify"
printf '{"reviewDecision":"CHANGES_REQUESTED"}' > "$STUBDIR/finalreview"
run o/r 7; chk "$rc" 1 T11; nomerge T11

echo "T12 green + downstream open PR based on the head branch → merge WITHOUT --delete-branch"
# The endo-but-for-bots #800 auto-close: deleting a merged PR's head branch while
# an open (freshly APPROVED) PR uses it as base makes GitHub close that PR
# (base_ref_deleted) instead of retargeting it. The spine must retain the branch.
reset_seq; seq_add "$GREEN"; printf 'MERGED|false' > "$STUBDIR/verify"
printf '800' > "$STUBDIR/downstream"
run o/r 799; chk "$rc" 0 T12; merged T12; retained T12

echo "T13 green + head-branch read fails → fail-RETAIN (merge, keep the branch)"
reset_seq; seq_add "$GREEN"; printf 'MERGED|false' > "$STUBDIR/verify"
printf '' > "$STUBDIR/headref"   # unreadable/empty head ref → not license to delete
run o/r 799; chk "$rc" 0 T13; merged T13; retained T13

echo "T14 dependabot mode + human author + no approval → keep approval gate, no merge"
reset_seq; seq_add "$GREEN"; printf 'MERGED|false' > "$STUBDIR/verify"
printf '{"author":{"login":"alice"}}' > "$STUBDIR/author"
printf '{"reviewDecision":"REVIEW_REQUIRED","headRefOid":"head123"}' > "$STUBDIR/approvalmeta"
run endojs/endo-but-for-bots 914 --dependabot-auto-merge; chk "$rc" 1 T14; nomerge T14

echo "T15 dependabot mode + CHANGES_REQUESTED → absolute veto, no merge"
reset_seq; seq_add "$GREEN_CR"; printf 'MERGED|false' > "$STUBDIR/verify"
printf '{"author":{"login":"dependabot[bot]"}}' > "$STUBDIR/author"
printf '{"reviewDecision":"CHANGES_REQUESTED"}' > "$STUBDIR/finalreview"
run endojs/endo-but-for-bots 914 --dependabot-auto-merge; chk "$rc" 1 T15; nomerge T15

echo "T16 dependabot mode + dependabot author + no approval → merge"
reset_seq; seq_add "$GREEN"; printf 'MERGED|false' > "$STUBDIR/verify"
printf '{"author":{"login":"dependabot[bot]"}}' > "$STUBDIR/author"
printf '{"reviewDecision":"REVIEW_REQUIRED","headRefOid":"head123"}' > "$STUBDIR/approvalmeta"
run endojs/endo-but-for-bots 914 --dependabot-auto-merge; chk "$rc" 0 T16; merged T16

echo "T17 dependabot mode + non-owned repo + no approval → keep approval gate, no merge"
reset_seq; seq_add "$GREEN"; printf 'MERGED|false' > "$STUBDIR/verify"
printf '{"author":{"login":"dependabot[bot]"}}' > "$STUBDIR/author"
printf '{"reviewDecision":"REVIEW_REQUIRED","headRefOid":"head123"}' > "$STUBDIR/approvalmeta"
run upstream/project 914 --dependabot-auto-merge; chk "$rc" 1 T17; nomerge T17

echo "T18 dependabot mode + unreadable author + no approval → keep approval gate, no merge"
reset_seq; seq_add "$GREEN"; printf 'MERGED|false' > "$STUBDIR/verify"
touch "$STUBDIR/author_fail"
printf '{"reviewDecision":"REVIEW_REQUIRED","headRefOid":"head123"}' > "$STUBDIR/approvalmeta"
run endojs/endo-but-for-bots 914 --dependabot-auto-merge; chk "$rc" 1 T18; nomerge T18

echo "T19 dependabot mode + unreadable final review state → fail closed, no merge"
reset_seq; seq_add "$GREEN"; printf 'MERGED|false' > "$STUBDIR/verify"
printf '{"author":{"login":"dependabot[bot]"}}' > "$STUBDIR/author"
touch "$STUBDIR/finalreview_fail"
run endojs/endo-but-for-bots 914 --dependabot-auto-merge; chk "$rc" 1 T19; nomerge T19

rm -rf "$TR"
echo "----------------------------------------------------------------"
echo "ci-wait-merge: PASS=$PASS FAIL=$FAIL"
[ "$FAIL" -eq 0 ]
