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
#   T10 frozen base shared by SIBLINGS (no dependent stacks on this PR) → unfreeze
#      and merge anyway (exit 0, base edited, merge called): sharing a pin is not a
#      stack, retargeting this PR leaves the siblings untouched (endojs/endo-but-for-bots#1304)
#   T10b genuine dependent stack (an open PR based on THIS PR's head) → alert
#      maintainer, exit 1, NO merge, NO base edit (do not orphan the dependent)
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
#   T20 post-rebase head whose CI is red → exit 3 / shepherd, no merge
#   T21 approval on the pre-rebase head still authorizes (freshness guard removed) → merge
#   T21b a later maintainer dismissal on the pre-rebase head still blocks → no merge
#   T22 ordinary approval on the post-rebase head → merge
#   T23 base moves during CI → old green invalidated; new-head red → shepherd
#   T24 safe-rebase conflict refusal → needs-weave, no CI merge
#   T25 explicit dependabot mode + gh 'app/dependabot' rendering → merge
#   T26 CONFLICTING head + empty rollup (twice) → exit 3 terminal, no merge
#   T27 one transient CONFLICTING read then green → still merges
#   T28 authorized concurrent force-push after rebase → immediate explicit
#      head-changed exit 4 / re-enqueue, no merge
#   T29 every failed check is an Actions job refused for account billing → exit 5
#      (billing-blocked), no merge, named in the terminal line
#   T30 billing refusal on one job but an ordinary failure on another → exit 3
#   T31 annotation read fails → ordinary red exit 3 (never guess billing)
#   T32 failed commit status with no Actions job URL → ordinary red exit 3
#   T33 stale CANCELLED run superseded by a green rerun of the same check → merge
#   T34 stale green run superseded by a red rerun of the same check → exit 3
#   T35 stale red run superseded by a still-queued rerun → keeps waiting (exit 4)
#   T36 base is a snapshot of a live NON-trunk branch (endo-but-for-bots#1343's
#      feat/…-5feadae) → refuse with reason=nontrunk-frozen-base, exit 1, no merge,
#      no base edit (the #621 stranding class)
#   T37 non-trunk snapshot whose tip moved past the suffix commit → still refuse
#   T38 ordinary `release-2024` base (suffix names no commit) → merge
#   T39 `<name>-<hex>` base with no live `<name>` → merge
#   T40 live-branch read fails → fail closed, no merge
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
export GARDEN_REBASE_PR="$TR/rebase-pr"
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
# Check-run annotations (the Actions billing classifier): $STUBDIR/ann_<job-id>
# holds the messages; a missing file is a failed read.
if [ "$1" = api ] && [[ "$2" =~ check-runs/([0-9]+)/annotations ]]; then
  cat "$STUBDIR/ann_${BASH_REMATCH[1]}" 2>/dev/null || exit 1; exit 0; fi
# Branch tips (the non-trunk snapshot check): $STUBDIR/refs holds `<branch> <sha>`
# lines; an absent branch is a 404, and $STUBDIR/refs_fail makes every read fail.
if [ "$1" = api ] && [[ "$2" =~ /git/ref/heads/(.+)$ ]]; then
  [ -f "$STUBDIR/refs_fail" ] && { echo "gh: Server Error (HTTP 502)" >&2; exit 1; }
  sha="$(awk -v b="${BASH_REMATCH[1]}" '$1==b {print $2}' "$STUBDIR/refs" 2>/dev/null)"
  [ -n "$sha" ] || { echo "gh: Not Found (HTTP 404)" >&2; exit 1; }
  echo "$sha"; exit 0; fi
# Compare (is the snapshot suffix an ancestor of the base tip?): $STUBDIR/compare
# holds the status; absent → 404 (the suffix names no commit).
if [ "$1" = api ] && [[ "$2" =~ /compare/ ]]; then
  [ -f "$STUBDIR/compare" ] || { echo "gh: Not Found (HTTP 404)" >&2; exit 1; }
  cat "$STUBDIR/compare"; exit 0; fi
if [ "$1" = api ]; then cat "$STUBDIR/reviews" 2>/dev/null || printf '[{"state":"APPROVED","commit_id":"123abc123abc123abc123abc123abc123abc123a","user":{"login":"kriskowal"}}]'; exit 0; fi
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
      cat "$STUBDIR/approvalmeta" 2>/dev/null || printf '{"reviewDecision":"APPROVED","headRefOid":"123abc123abc123abc123abc123abc123abc123a"}'; exit 0; fi
    if printf ' %s' "$@" | grep -q -- '--json statusCheckRollup --jq'; then cat "$STUBDIR/failures" 2>/dev/null; exit 0; fi
    # The billing classifier's bare rollup re-read: the last rollup served, unadvanced.
    if printf ' %s' "$@" | grep -q -- '--json statusCheckRollup$'; then
      line=$(sed -n "${i}p" "$SEQ"); [ -z "$line" ] && line=$(tail -n1 "$SEQ")
      printf '%s' "$line" | base64 -d; exit 0; fi
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

cat > "$TR/rebase-pr" <<'STUB'
#!/bin/bash
echo "rebase: $*" >> "$STUBDIR/rebase.log"
[ -f "$STUBDIR/rebase_rc" ] && exit "$(cat "$STUBDIR/rebase_rc")"
if [ -f "$STUBDIR/rebase_seq" ]; then
  i="$(cat "$STUBDIR/rebase_i" 2>/dev/null || echo 0)"
  line="$(sed -n "$((i+1))p" "$STUBDIR/rebase_seq")"
  [ -z "$line" ] && line="$(tail -n1 "$STUBDIR/rebase_seq")"
  echo $((i+1)) > "$STUBDIR/rebase_i"
  printf '%s\n' "$line"
  exit 0
fi
cat "$STUBDIR/rebase_head" 2>/dev/null || printf '123abc123abc123abc123abc123abc123abc123a\n'
STUB
chmod +x "$TR/rebase-pr"

b64() { printf '%s' "$1" | base64 | tr -d '\n'; }
HEAD='123abc123abc123abc123abc123abc123abc123a'
PEND="{\"state\":\"OPEN\",\"mergeable\":\"MERGEABLE\",\"headRefOid\":\"$HEAD\",\"statusCheckRollup\":[{\"name\":\"build\",\"status\":\"IN_PROGRESS\",\"conclusion\":null}]}"
GREEN="{\"state\":\"OPEN\",\"mergeable\":\"MERGEABLE\",\"headRefOid\":\"$HEAD\",\"statusCheckRollup\":[{\"name\":\"build\",\"status\":\"COMPLETED\",\"conclusion\":\"SUCCESS\"}]}"
RED="{\"state\":\"OPEN\",\"mergeable\":\"MERGEABLE\",\"headRefOid\":\"$HEAD\",\"statusCheckRollup\":[{\"name\":\"build\",\"status\":\"COMPLETED\",\"conclusion\":\"FAILURE\"}]}"
# A CONFLICTING head: GitHub cannot compute refs/pull/N/merge, so `pull_request`
# workflows never dispatch and the rollup stays [] forever, not just briefly.
CONFLICT_EMPTY="{\"state\":\"OPEN\",\"mergeable\":\"CONFLICTING\",\"headRefOid\":\"$HEAD\",\"statusCheckRollup\":[]}"
# Green CI but a maintainer requested changes: reviewDecision drives the gate.
GREEN_CR="{\"state\":\"OPEN\",\"mergeable\":\"MERGEABLE\",\"headRefOid\":\"$HEAD\",\"reviewDecision\":\"CHANGES_REQUESTED\",\"statusCheckRollup\":[{\"name\":\"build\",\"status\":\"COMPLETED\",\"conclusion\":\"SUCCESS\"}]}"

reset_seq() { : > "$STUBDIR/seq"; echo 0 > "$STUBDIR/i"; rm -f "$STUBDIR"/ann_* "$STUBDIR/merge.log" "$STUBDIR/edit.log" "$STUBDIR/rebase.log" "$STUBDIR/rebase_head" "$STUBDIR/rebase_rc" "$STUBDIR/rebase_seq" "$STUBDIR/rebase_i" "$STUBDIR/basemeta" "$STUBDIR/prcount" "$STUBDIR/prnums" "$STUBDIR/downstream" "$STUBDIR/headref" "$STUBDIR/author" "$STUBDIR/author_fail" "$STUBDIR/finalreview" "$STUBDIR/finalreview_fail" "$STUBDIR/reviews" "$STUBDIR/approvalmeta" "$STUBDIR/refs" "$STUBDIR/refs_fail" "$STUBDIR/compare"; }
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
run_capture() { rc=0; bash "$SCRIPT" "$@" >"$STUBDIR/output" 2>&1 || rc=$?; }

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
printf '{"state":"OPEN","baseRefName":"llm-65b0abe","headRefName":"feat-510"}' > "$STUBDIR/basemeta"
echo 1 > "$STUBDIR/prcount"   # only #510 itself sits on the frozen base
run o/r 510; chk "$rc" 0 T9; edited T9; merged T9

echo "T10 frozen base shared by SIBLINGS (none stacks on this PR) → unfreeze + merge"
# The maintainer's ruling (kriskowal 2026-09-18, endojs/endo-but-for-bots#1304):
# siblings on a shared pin are NOT a stack. Retargeting THIS PR touches only THIS
# PR; the 6 siblings keep their base byte-for-byte. Sharing a base must NOT block.
reset_seq; seq_add "$GREEN"; printf 'MERGED|false' > "$STUBDIR/verify"
printf '{"state":"OPEN","baseRefName":"llm-65b0abe","headRefName":"feat-510"}' > "$STUBDIR/basemeta"
echo 7 > "$STUBDIR/prcount"   # 7 PRs share the pin, but none bases on #510's head
: > "$STUBDIR/downstream"     # no open PR stacks on feat-510 → siblings, not a stack
run o/r 510; chk "$rc" 0 T10; edited T10; merged T10

echo "T10b genuine dependent stack (open PR based on this PR's head) → alert, exit 1, no merge, no fork"
# The case that STILL blocks: an open PR (#521) bases on #510's HEAD ref (feat-510),
# so forwarding #510 to live and merging it would orphan #521 off the shared base.
reset_seq; seq_add "$GREEN"; printf 'MERGED|false' > "$STUBDIR/verify"
printf '{"state":"OPEN","baseRefName":"llm-65b0abe","headRefName":"feat-510"}' > "$STUBDIR/basemeta"
echo 2 > "$STUBDIR/prcount"
printf '521' > "$STUBDIR/downstream"   # #521 bases on feat-510 → a real dependent
run o/r 510; chk "$rc" 1 T10b; nomerge T10b; noedit T10b

SNAP='5feadae0123456789abcdef0123456789abcdef0'
echo "T36 base is a snapshot of a live NON-trunk branch → refuse (exit 1, no merge, no base edit)"
# endojs/endo-but-for-bots#1343: base feat/daemon-provisioning-grants-5feadae, a
# snapshot of draft #1042's head. No trunk to unfreeze to; merging strands it.
reset_seq; seq_add "$GREEN"; printf 'MERGED|false' > "$STUBDIR/verify"
printf '{"state":"OPEN","baseRefName":"feat/daemon-provisioning-grants-5feadae","headRefName":"feat-1343"}' > "$STUBDIR/basemeta"
printf 'feat/daemon-provisioning-grants %s\nfeat/daemon-provisioning-grants-5feadae %s\n' "$HEAD" "$SNAP" > "$STUBDIR/refs"
run_capture o/r 1343; chk "$rc" 1 T36; nomerge T36; noedit T36
if grep -q 'reason=nontrunk-frozen-base' "$STUBDIR/output"; then ok "T36 distinct reason"; else bad "T36 reason missing"; fi

echo "T37 non-trunk snapshot whose tip moved (suffix is an ancestor) → still refuse"
reset_seq; seq_add "$GREEN"; printf 'MERGED|false' > "$STUBDIR/verify"
printf '{"state":"OPEN","baseRefName":"feat/x-5feadae","headRefName":"feat-y"}' > "$STUBDIR/basemeta"
printf 'feat/x %s\nfeat/x-5feadae %s\n' "$SNAP" "$HEAD" > "$STUBDIR/refs"
echo ahead > "$STUBDIR/compare"
run o/r 1343; chk "$rc" 1 T37; nomerge T37; noedit T37

echo "T38 ordinary branch ending in hex digits (release-2024; suffix names no commit) → merge"
reset_seq; seq_add "$GREEN"; printf 'MERGED|false' > "$STUBDIR/verify"
printf '{"state":"OPEN","baseRefName":"release-2024","headRefName":"feat-y"}' > "$STUBDIR/basemeta"
printf 'release %s\nrelease-2024 %s\n' "$SNAP" "$HEAD" > "$STUBDIR/refs"
run o/r 42; chk "$rc" 0 T38; merged T38; noedit T38

echo "T39 <name>-<hex> base with no live <name> branch → merge"
reset_seq; seq_add "$GREEN"; printf 'MERGED|false' > "$STUBDIR/verify"
printf '{"state":"OPEN","baseRefName":"feat-cafe","headRefName":"feat-y"}' > "$STUBDIR/basemeta"
printf 'feat-cafe %s\n' "$HEAD" > "$STUBDIR/refs"
run o/r 42; chk "$rc" 0 T39; merged T39

echo "T40 live-branch read fails → fail closed (exit 1, no merge)"
reset_seq; seq_add "$GREEN"; printf 'MERGED|false' > "$STUBDIR/verify"
printf '{"state":"OPEN","baseRefName":"feat/x-5feadae","headRefName":"feat-y"}' > "$STUBDIR/basemeta"
: > "$STUBDIR/refs_fail"
run o/r 1343; chk "$rc" 1 T40; nomerge T40

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

echo "T20 post-rebase head whose CI goes red → shepherd outcome, no merge"
reset_seq; seq_add "$RED"; printf '  red: build = FAILURE\n' > "$STUBDIR/failures"
run o/r 178; chk "$rc" 3 T20; nomerge T20
if [ -f "$STUBDIR/rebase.log" ]; then ok "T20 rebase stage ran before red CI"; else bad "T20 rebase stage did not run"; fi

echo "T21 approval on pre-rebase head still authorizes (freshness guard removed) → merge"
# The garden rebases the PR before merging, moving the head past the reviewed commit.
# The maintainer's approval on the pre-rebase head (def456) must remain effective and
# authorize the merge — this is the exact stranding the guard removal fixes. CI
# freshness (green belongs to the post-rebase head) is a separate gate, still enforced.
reset_seq; seq_add "$GREEN"; printf 'MERGED|false' > "$STUBDIR/verify"
printf '{"reviewDecision":"APPROVED","headRefOid":"%s"}' "$HEAD" > "$STUBDIR/approvalmeta"
printf '[{"state":"APPROVED","commit_id":"def456def456def456def456def456def456def4","user":{"login":"kriskowal"}}]' > "$STUBDIR/reviews"
run o/r 178; chk "$rc" 0 T21; merged T21

echo "T21b a later maintainer dismissal on the pre-rebase head still blocks the merge"
reset_seq; seq_add "$GREEN"; printf 'MERGED|false' > "$STUBDIR/verify"
printf '{"reviewDecision":"APPROVED","headRefOid":"%s"}' "$HEAD" > "$STUBDIR/approvalmeta"
printf '[{"state":"APPROVED","commit_id":"def456def456def456def456def456def456def4","user":{"login":"kriskowal"}},{"state":"DISMISSED","commit_id":"def456def456def456def456def456def456def4","user":{"login":"kriskowal"}}]' > "$STUBDIR/reviews"
run o/r 178; chk "$rc" 1 T21b; nomerge T21b

echo "T22 approval on post-rebase head is current → merge"
reset_seq; seq_add "$GREEN"; printf 'MERGED|false' > "$STUBDIR/verify"
printf '{"reviewDecision":"APPROVED","headRefOid":"%s"}' "$HEAD" > "$STUBDIR/approvalmeta"
printf '[{"state":"APPROVED","commit_id":"%s","user":{"login":"kriskowal"}}]' "$HEAD" > "$STUBDIR/reviews"
run o/r 178; chk "$rc" 0 T22; merged T22

echo "T23 base moves during CI → old green invalidated; new-head red → shepherd"
reset_seq
HEAD2='456def456def456def456def456def456def456d'
GREEN1="{\"state\":\"OPEN\",\"mergeable\":\"MERGEABLE\",\"headRefOid\":\"$HEAD\",\"statusCheckRollup\":[{\"name\":\"build\",\"status\":\"COMPLETED\",\"conclusion\":\"SUCCESS\"}]}"
RED2="{\"state\":\"OPEN\",\"mergeable\":\"MERGEABLE\",\"headRefOid\":\"$HEAD2\",\"statusCheckRollup\":[{\"name\":\"build\",\"status\":\"COMPLETED\",\"conclusion\":\"FAILURE\"}]}"
printf '%s\n%s\n%s\n' "$HEAD" "$HEAD2" "$HEAD2" > "$STUBDIR/rebase_seq"
seq_add "$GREEN1"; seq_add "$RED2"
printf '  red: build = FAILURE\n' > "$STUBDIR/failures"
run o/r 178; chk "$rc" 3 T23; nomerge T23

echo "T24 safe-rebase conflict refusal → needs-weave, no merge"
reset_seq; seq_add "$GREEN"; printf '3\n' > "$STUBDIR/rebase_rc"
run o/r 178; chk "$rc" 1 T24; nomerge T24

echo "T25 dependabot mode + gh GraphQL 'app/dependabot' rendering + no approval → merge"
# gh 2.97.0 renders the dependabot App author as app/dependabot via --json author,
# not the REST dependabot[bot]; canonical_bot_login must normalize both to the bare
# slug or every dependabot MERGE-NOW stalls on a maintainer approval that never
# comes (endojs/endo-but-for-bots#1004, 2026-08-16).
reset_seq; seq_add "$GREEN"; printf 'MERGED|false' > "$STUBDIR/verify"
printf '{"author":{"login":"app/dependabot"}}' > "$STUBDIR/author"
printf '{"reviewDecision":"REVIEW_REQUIRED","headRefOid":"head123"}' > "$STUBDIR/approvalmeta"
run endojs/endo-but-for-bots 914 --dependabot-auto-merge; chk "$rc" 0 T25; merged T25

echo "T26 CONFLICTING head + empty rollup → terminal exit 3, no merge (not a re-enqueue)"
# endojs/endo-but-for-bots#891: a conflicted head attaches NO checks at all, so
# the empty-rollup branch used to spin to the deadline and exit 4, re-posting the
# same gauntlet stage forever (two reaper cycles, 13 hours, zero runs). Two
# consecutive CONFLICTING reads make it terminal.
reset_seq; seq_add "$CONFLICT_EMPTY"; seq_add "$CONFLICT_EMPTY"
run o/r 891; chk "$rc" 3 T26; nomerge T26

echo "T27 one transient CONFLICTING read, then checks attach green → merges"
# `mergeable` is computed asynchronously and reads UNKNOWN/CONFLICTING right after
# a push; a SINGLE such read must never be terminal.
reset_seq; seq_add "$CONFLICT_EMPTY"; seq_add "$GREEN"; printf 'MERGED|false' > "$STUBDIR/verify"
run o/r 178; chk "$rc" 0 T27; merged T27

echo "T28 authorized concurrent force-push after rebase → immediate head-changed re-enqueue"
# The rebase helper publishes HEAD, then an authorized concurrent actor replaces
# the PR head with HEAD2 before the first rollup read. HEAD can no longer become
# live again, so waiting for it until the deadline is both unreachable and slow.
reset_seq
HEAD2='456def456def456def456def456def456def456d'
PUSHED="{\"state\":\"OPEN\",\"mergeable\":\"MERGEABLE\",\"headRefOid\":\"$HEAD2\",\"statusCheckRollup\":[{\"name\":\"build\",\"status\":\"IN_PROGRESS\",\"conclusion\":null}]}"
seq_add "$PUSHED"
GARDEN_CI_DEADLINE_SECS=999 run_capture o/r 178
chk "$rc" 4 T28; nomerge T28
if grep -q "ci-head-changed repo=o/r pr=178 post-rebase=${HEAD:0:11} live=${HEAD2:0:11} .*re-enqueue" "$STUBDIR/output"; then
  ok "T28 names both heads and the re-enqueue outcome"
else
  bad "T28 missing explicit head-changed outcome: $(cat "$STUBDIR/output")"
fi

# The 2026-09-30 kriscendobot/minion.town#144 shape: every job failed ~2s after
# starting, with no runner and no log; only the annotation names the cause.
BILLING_MSG='The job was not started because recent account payments have failed or your spending limit needs to be increased. Please check the '"'"'Billing & plans'"'"' section of your settings'
job() { printf '{"name":"%s","status":"COMPLETED","conclusion":"%s","detailsUrl":"https://github.com/o/r/actions/runs/36691445004/job/%s"}' "$1" "$2" "$3"; }
BILLING_RED="{\"state\":\"OPEN\",\"mergeable\":\"MERGEABLE\",\"headRefOid\":\"$HEAD\",\"statusCheckRollup\":[$(job test FAILURE 101),$(job 'Claude harness (amd64)' FAILURE 102),$(job lint SUCCESS 103)]}"

echo "T29 all failed jobs refused for account billing → exit 5, no merge"
reset_seq; seq_add "$BILLING_RED"
printf '%s\n' "$BILLING_MSG" > "$STUBDIR/ann_101"; printf '%s\n' "$BILLING_MSG" > "$STUBDIR/ann_102"
run_capture o/r 144; chk "$rc" 5 T29; nomerge T29
if grep -q "CI BILLING-BLOCKED .*test, Claude harness (amd64)" "$STUBDIR/output"; then
  ok "T29 terminal line names the billing block and the refused checks"
else
  bad "T29 missing billing-blocked terminal line: $(cat "$STUBDIR/output")"
fi
run o/r 144 --no-merge; chk "$rc" 5 "T29 --no-merge probe"

echo "T30 billing refusal on one job, ordinary failure on another → exit 3"
reset_seq; seq_add "$BILLING_RED"
printf '%s\n' "$BILLING_MSG" > "$STUBDIR/ann_101"; printf 'Process completed with exit code 1.\n' > "$STUBDIR/ann_102"
run o/r 144; chk "$rc" 3 T30; nomerge T30

echo "T31 annotation read fails → ordinary red exit 3"
reset_seq; seq_add "$BILLING_RED"; printf '%s\n' "$BILLING_MSG" > "$STUBDIR/ann_101"
run o/r 144; chk "$rc" 3 T31; nomerge T31

echo "T32 failed commit status without an Actions job URL → ordinary red exit 3"
reset_seq
seq_add "{\"state\":\"OPEN\",\"mergeable\":\"MERGEABLE\",\"headRefOid\":\"$HEAD\",\"statusCheckRollup\":[$(job test FAILURE 101),{\"context\":\"ext/ci\",\"state\":\"FAILURE\",\"targetUrl\":\"https://ci.example/1\"}]}"
printf '%s\n' "$BILLING_MSG" > "$STUBDIR/ann_101"
run o/r 144; chk "$rc" 3 T32; nomerge T32

# A rerun leaves the superseded run in the rollup under the same check name.
run_at() { printf '{"__typename":"CheckRun","name":"%s","workflowName":"CI","status":"%s","conclusion":%s,"startedAt":"%s","detailsUrl":"https://github.com/o/r/actions/runs/1/job/%s"}' "$1" "$2" "$3" "$4" "$5"; }
rerun_rollup() { printf '{"state":"OPEN","mergeable":"MERGEABLE","headRefOid":"%s","statusCheckRollup":[%s,%s,%s]}' "$HEAD" "$1" "$(run_at lint COMPLETED '"SUCCESS"' 2026-09-30T01:00:00Z 201)" "$2"; }

echo "T33 stale CANCELLED run + green rerun of the same check → merge"
reset_seq; seq_add "$(rerun_rollup "$(run_at test COMPLETED '"CANCELLED"' 2026-09-30T01:00:00Z 202)" "$(run_at test COMPLETED '"SUCCESS"' 2026-09-30T02:00:00Z 203)")"
printf 'MERGED|false' > "$STUBDIR/verify"
run o/r 178; chk "$rc" 0 T33; merged T33

echo "T34 stale green run + red rerun of the same check → exit 3"
reset_seq; seq_add "$(rerun_rollup "$(run_at test COMPLETED '"FAILURE"' 2026-09-30T02:00:00Z 205)" "$(run_at test COMPLETED '"SUCCESS"' 2026-09-30T01:00:00Z 204)")"
run o/r 178; chk "$rc" 3 T34; nomerge T34

echo "T35 stale red run + still-queued rerun → keeps waiting, no merge"
reset_seq; seq_add "$(rerun_rollup "$(run_at test COMPLETED '"FAILURE"' 2026-09-30T01:00:00Z 206)" "$(run_at test QUEUED null 0001-01-01T00:00:00Z 207)")"
GARDEN_CI_DEADLINE_SECS=1 run o/r 178; chk "$rc" 4 T35; nomerge T35

rm -rf "$TR"
echo "----------------------------------------------------------------"
echo "ci-wait-merge: PASS=$PASS FAIL=$FAIL"
[ "$FAIL" -eq 0 ]
