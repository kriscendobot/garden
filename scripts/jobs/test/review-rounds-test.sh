#!/bin/bash
# review-rounds-test.sh — the human half of the issue-cost method
# (scripts/jobs/review-rounds.sh). A fake `gh` on PATH emits a fixed `gh pr list`
# payload so the run is hermetic; asserts the human/bot reviewer classification, the
# round math (mean/median/zero-review), and the illustrative pricing column.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"; ROOT="$(cd "$JOBS/../.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_)' || true) 2>/dev/null || true
command -v jq >/dev/null 2>&1 || { echo "review-rounds-test: jq absent, skipping"; exit 0; }

TR="$(mktemp -d "${TMPDIR:-/tmp}/rr.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
# common.sh resets GARDEN_BIN="$GARDEN_ROOT/scripts/jobs/bin" on source and prepends it
# to PATH — so to make our stub `gh` win (not the real fleet wrapper, which would hang
# retrying a nonexistent repo) we point GARDEN_ROOT at a fake tree and put the stub at
# that exact prepended dir. The stub is a SYMLINK to a committed helper in the repo tree
# (review-rounds-fake-gh.sh), not a file written into $TR: a script under a /tmp mktemp
# dir is not executable under the sandboxed test runner, but exec follows the symlink to
# the exec-capable committed file (the shape mentor-provider-order-test.sh uses).
BIN="$TR/root/scripts/jobs/bin"; mkdir -p "$BIN"
chmod +x "$HERE/review-rounds-fake-gh.sh"
ln -s "$HERE/review-rounds-fake-gh.sh" "$BIN/gh"
export GARDEN_TEST=1 GARDEN_ROOT="$TR/root" GARDEN_NO_MAINTAINER_ALERT=1 GARDEN_BOT_LOGIN=botlogin
export PATH="$BIN:$PATH"

# heuristic human-set (login not ending in bot/[bot]); default --author is the bot.
out="$(bash "$JOBS/review-rounds.sh" -R x/y --json)"
echo "$out" | jq . >/dev/null 2>&1 && ok "emits valid JSON" || { bad "invalid JSON: $out"; exit 1; }

n="$(echo "$out" | jq -r '.merged_prs')"
[ "$n" = 4 ] && ok "author filter kept 4 bot PRs, dropped #9 (someone-else)" || bad "merged_prs=$n (want 4)"

tot="$(echo "$out" | jq -r '.human_rounds.total')"
[ "$tot" = 3 ] && ok "total human rounds = 3 (bot reviews excluded)" || bad "total=$tot (want 3)"

mean="$(echo "$out" | jq -r '.human_rounds.mean')"
awk -v v="$mean" 'BEGIN{exit !(v>0.74 && v<0.76)}' && ok "mean human rounds = 0.75 (3/4)" || bad "mean=$mean (want 0.75)"

med="$(echo "$out" | jq -r '.human_rounds.median')"
awk -v v="$med" 'BEGIN{exit !(v>0.49 && v<0.51)}' && ok "median human rounds = 0.5" || bad "median=$med (want 0.5)"

zero="$(echo "$out" | jq -r '.prs_zero_human_review')"
[ "$zero" = 2 ] && ok "2 PRs with zero human review (bot-only #3, empty #4)" || bad "zero=$zero (want 2)"

multi="$(echo "$out" | jq -r '.prs_multi_reviewer')"
[ "$multi" = 1 ] && ok "1 PR reviewed by >1 human (#1: kriskowal+erights)" || bad "multi=$multi (want 1)"

# explicit --humans overrides the heuristic: only kriskowal counts -> #1 drops to 1.
out2="$(bash "$JOBS/review-rounds.sh" -R x/y --humans kriskowal --json)"
tot2="$(echo "$out2" | jq -r '.human_rounds.total')"
[ "$tot2" = 2 ] && ok "--humans kriskowal: total drops to 2 (erights no longer human)" || bad "total2=$tot2 (want 2)"

# illustrative pricing column: mean 0.75 rounds x (12/60 h x \$150) = 0.75 x \$30 = \$22.50
out3="$(bash "$JOBS/review-rounds.sh" -R x/y --min-per-round 12 --dollars-per-hour 150 --json)"
dpr="$(echo "$out3" | jq -r '.illustrative.dollars_per_round')"
mcost="$(echo "$out3" | jq -r '.illustrative.mean_human_review_cost_per_pr')"
awk -v v="$dpr" 'BEGIN{exit !(v>29.99 && v<30.01)}' && ok "illustrative \$30.00/round" || bad "dollars_per_round=$dpr (want 30)"
awk -v v="$mcost" 'BEGIN{exit !(v>22.49 && v<22.51)}' && ok "illustrative \$22.50 mean human-review cost/PR" || bad "mean cost/pr=$mcost (want 22.50)"

echo "review-rounds-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
