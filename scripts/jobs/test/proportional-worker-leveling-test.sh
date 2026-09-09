#!/bin/bash
# Hermetic fleet-level acceptance for proportional monks and demand-split clerics.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-proportional-level.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
pass=0;fail=0;ok(){ echo "PASS: $*";pass=$((pass+1));};bad(){ echo "FAIL: $*";fail=$((fail+1));}
BARE="$TR/journal.git";SEED="$TR/seed";git init -q --bare "$BARE";git init -q "$SEED";git -C "$SEED" checkout -qb journal2
mkdir -p "$SEED"/{config,hosts,usage,jobs/{todo,doin,plan,tada},inbox/maintainer/{unread,read}}
printf 'anthropic:large\tanthropic\tlarge\tweekly-tokens\t143000000\tusage-panel\t2026-09-09\nanthropic:small\tanthropic\tsmall\tweekly-tokens\t64000000\tusage-panel\t2026-09-09\n' >"$SEED/config/budget-pools"
printf 'monk-fleet-ceiling\t6\ncleric-fleet-ceiling\t4\nhost\tlarge\t4\t4\nhost\tsmall\t4\t4\n' >"$SEED/config/worker-leveling"
printf 'monks: 1\nclerics: 0\n' >"$SEED/hosts/large";printf 'monks: 1\nclerics: 0\n' >"$SEED/hosts/small"
now="$(date -u +%FT%TZ)";for h in large small;do printf '{"host":"%s","provider":"anthropic","ts":"%s","input_tokens":1,"output_tokens":0,"cache_creation_tokens":0}\n' "$h" "$now" >"$SEED/usage/$h.jsonl";done
# Three pinned jobs and one shared job make cleric demand 0.5:3.5. K=4, so the
# demand splitter targets large=1, small=3 instead of using Anthropic's cap ratio.
for n in 1 2 3;do printf '%s\n' '---' 'tier: minion' 'requires: host=small' '---' work >"$SEED/jobs/todo/pinned$n.md";done
printf '%s\n' '---' 'tier: minion' '---' work >"$SEED/jobs/todo/shared.md"
touch "$SEED/jobs/plan/.gitkeep" "$SEED/jobs/doin/.gitkeep" "$SEED/jobs/tada/.gitkeep" "$SEED/inbox/maintainer/unread/.gitkeep" "$SEED/inbox/maintainer/read/.gitkeep"
git -C "$SEED" add -A;git -C "$SEED" -c user.name=test -c user.email=test@example.invalid commit -qm seed;git -C "$SEED" remote add origin "$BARE";git -C "$SEED" push -qu origin journal2
ACT="$TR/actions";printf '#!/bin/bash\nprintf "%%s %%s %%s %%s\n" "$1" "$2" "$3" "$4" >>"%s"\n' "$ACT" >"$TR/send";chmod +x "$TR/send"
env GARDEN_TEST=1 GARDEN=leader GARDEN_LEADER=leader JOURNAL_REMOTE="$BARE" GARDEN_STATE="$TR/state" GARDEN_NO_MAINTAINER_ALERT=1 \
 GARDEN_USAGE_NOW="$(date -u +%s)" GARDEN_BUDGET_LEVEL_UP_CONFIRM=1 GARDEN_BUDGET_LEVEL_STEP=10 \
 GARDEN_BUDGET_LEVEL_SEND_HOST_OP="$TR/send" "$JOBS/budget-level.sh" >"$TR/out" 2>&1
if grep -q '^large op=set-workers kind=monk count=4$' "$ACT"&&grep -q '^small op=set-workers kind=monk count=2$' "$ACT";then ok "143M:64M caps apportion the six-monk ceiling as 4:2";else bad "monk allocation: $(tr '\n' ';'<"$ACT")";fi
if grep -q '^large op=set-workers kind=cleric count=1$' "$ACT"&&grep -q '^small op=set-workers kind=cleric count=3$' "$ACT";then ok "clerics split 1:3 from host-eligible demand, independently of Anthropic caps";else bad "cleric split: $(tr '\n' ';'<"$ACT")";fi

# Row order is not an input to either allocation; bytewise ids break exact ties.
git -C "$SEED" pull -q --rebase; tac "$SEED/config/budget-pools" >"$TR/reversed";mv "$TR/reversed" "$SEED/config/budget-pools";git -C "$SEED" add config/budget-pools;git -C "$SEED" -c user.name=test -c user.email=test@example.invalid commit -qm reorder;git -C "$SEED" push -q
: >"$ACT";rm -rf "$TR/state/budget-level"
env GARDEN_TEST=1 GARDEN=leader GARDEN_LEADER=leader JOURNAL_REMOTE="$BARE" GARDEN_STATE="$TR/state" GARDEN_NO_MAINTAINER_ALERT=1 GARDEN_USAGE_NOW="$(date -u +%s)" GARDEN_BUDGET_LEVEL_UP_CONFIRM=1 GARDEN_BUDGET_LEVEL_STEP=10 GARDEN_BUDGET_LEVEL_SEND_HOST_OP="$TR/send" "$JOBS/budget-level.sh" >/dev/null 2>&1
grep -q '^large op=set-workers kind=monk count=4$' "$ACT"&&grep -q '^small op=set-workers kind=monk count=2$' "$ACT"&&ok "pool row order does not change apportionment"||bad "row order changed allocation"

# One bad provenance row freezes every proportional share. The calibrated host at
# its own high-water mark retains only the reviewed denominator-free down carve-out.
git -C "$SEED" pull -q --rebase
sed -i 's/small\tweekly-tokens\t64000000\tusage-panel/small\tweekly-tokens\t64000000\tuncalibrated/' "$SEED/config/budget-pools"
printf 'monks: 3\nclerics: 0\n' >"$SEED/hosts/large";printf 'monks: 3\nclerics: 0\n' >"$SEED/hosts/small"
printf '{"host":"large","provider":"anthropic","ts":"%s","input_tokens":143000000,"output_tokens":0,"cache_creation_tokens":0}\n' "$now" >"$SEED/usage/large.jsonl"
git -C "$SEED" add config/budget-pools hosts usage;git -C "$SEED" -c user.name=test -c user.email=test@example.invalid commit -qm provenance;git -C "$SEED" push -q
: >"$ACT";rm -rf "$TR/state/budget-level"
env GARDEN_TEST=1 GARDEN=leader GARDEN_LEADER=leader JOURNAL_REMOTE="$BARE" GARDEN_STATE="$TR/state" GARDEN_NO_MAINTAINER_ALERT=1 GARDEN_USAGE_NOW="$(date -u +%s)" GARDEN_BUDGET_LEVEL_DOWN_CONFIRM=1 GARDEN_BUDGET_LEVEL_STEP=10 GARDEN_BUDGET_LEVEL_SEND_HOST_OP="$TR/send" "$JOBS/budget-level.sh" >"$TR/frozen.out" 2>&1
if grep -q '^large op=set-workers kind=monk count=1$' "$ACT"&&! grep -q '^small op=set-workers kind=monk' "$ACT"&&grep -q 'fleet monk allocation frozen' "$TR/frozen.out";then ok "fleet provenance gate freezes shares but permits exhaustion-floor down-only motion";else bad "provenance freeze: act=$(tr '\n' ';'<"$ACT") log=$(tr '\n' ';'<"$TR/frozen.out")";fi
echo "RESULT: $pass passed, $fail failed";[ "$fail" -eq 0 ]
