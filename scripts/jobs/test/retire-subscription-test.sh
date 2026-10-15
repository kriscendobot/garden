#!/bin/bash
# Hermetic coverage for retire-subscription.sh: one atomic commit removes a dead
# subscription and its retired host from the live budget registries, keeps history,
# tombstones both so the setters refuse to re-add them, and refuses any result that
# would fail closed (a host mapped to a missing pool, a living host or shared pool
# left unmapped, a worker-leveling envelope that no longer fits).
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/var/tmp}/garden-retire-subscription.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
pass=0; fail=0
ok() { echo "PASS: $*"; pass=$((pass+1)); }
bad() { echo "FAIL: $*"; fail=$((fail+1)); }
git_id=(-c user.name=test -c user.email=test@example.invalid)

BARE="$TR/journal.git"; SEED="$TR/seed"; WORK="$TR/work"
git init -q --bare "$BARE"
git init -q "$SEED"; git -C "$SEED" checkout -q -b journal2
git -C "$SEED" "${git_id[@]}" commit -q --allow-empty -m seed
git -C "$SEED" remote add origin "$BARE"; git -C "$SEED" push -q -u origin journal2
git clone -q --single-branch --branch journal2 "$BARE" "$WORK"
git -C "$WORK" config user.name test; git -C "$WORK" config user.email test@example.invalid

export GARDEN_TEST=1 GARDEN=test-garden GARDEN_ROOT="$ROOT"
export GARDEN_STATE="$TR/state" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2
export GARDEN_PRODUCER_CLONE="$WORK"
# shellcheck source=../common.sh
source "$JOBS/common.sh"

E1=endolin-garden-ece02cb4 E2=endolin-garden2-5bcdff64 OR=oros-studio-garden-ce242c49
resync() { git -C "$WORK" fetch -q origin journal2; git -C "$WORK" reset -q --hard origin/journal2; }

# The live registry as of 2026-10-15, before endolin2's retirement.
seed_state() {
  resync
  git -C "$WORK" rm -q -r --ignore-unmatch -- . >/dev/null
  mkdir -p "$WORK/config" "$WORK/hosts" "$WORK/worker-derotate" "$WORK/maintainers" \
    "$WORK/budget/reset-events" "$WORK/fleet/health"
  for d in "claude-endolin1/$E1" "claude-endolin2/$E2" "claude-oros/$OR" "codex-endolin/$E1" "codex-endolin/$E2"; do
    mkdir -p "$WORK/budget/live/${d%/*}"; printf 'subscription: %s\n' "${d%/*}" > "$WORK/budget/live/$d"
  done
  printf '# Columns, tab-separated:\n# subscription_id\tprovider\tceiling_kind\tceiling\tcalibrated_from\tcalibrated_at\n' > "$WORK/config/budget-pools"
  printf '%s\tanthropic\tweekly-tokens\t%s\tmanual\t2026-10-06\n' claude-endolin1 271000000 claude-endolin2 168000000 claude-oros 180000000 >> "$WORK/config/budget-pools"
  printf 'codex-endolin\topenai\tpercent\t95\tmanual\t2026-10-06\n' >> "$WORK/config/budget-pools"
  printf '# subscription_id\thost\tworker_kind\n' > "$WORK/config/subscription-mapping"
  printf '%s\t%s\t%s\n' claude-endolin1 $E1 monk claude-endolin1 $E1 gardener claude-endolin2 $E2 monk \
    claude-endolin2 $E2 gardener claude-oros $OR monk claude-oros $OR gardener codex-endolin $E1 cleric \
    codex-endolin $E2 cleric >> "$WORK/config/subscription-mapping"
  printf 'monk-fleet-ceiling\t10\ncleric-fleet-ceiling\t4\nhost\t%s\t4\t4\nhost\t%s\t0\t0\nhost\t%s\t8\t0\n' $E1 $E2 $OR > "$WORK/config/worker-leveling"
  for h in $E1 $E2 $OR; do printf 'monks: 1\n' > "$WORK/hosts/$h"; printf 'status: ok\n' > "$WORK/fleet/health/$h"; done
  printf 'host: %s\nprior_monk: 4\n' $E2 > "$WORK/worker-derotate/$E2"
  printf 'kriskowal\n' > "$WORK/maintainers/allowlist"
  printf '{"subscription_id":"claude-endolin2"}\n' > "$WORK/budget/reset-events/claude-endolin2.jsonl"
  [ -z "${1:-}" ] || printf '%s' "$1" > "$WORK/config/retired-budget-sources"
  git -C "$WORK" add -A; git -C "$WORK" commit -q -m fixture; git -C "$WORK" push -q origin HEAD:journal2
}
run() { set +e; "$@" >"$TR/stdout" 2>"$TR/stderr"; local rc=$?; set -e; echo "$rc"; }
retire() { run "$JOBS/retire-subscription.sh" "$@"; }
has() { [ -e "$WORK/$1" ]; }
head_sha() { git -C "$WORK" rev-parse HEAD; }

# 1. The endolin2 retirement: one commit, live config cleaned, history kept.
seed_state
before="$(head_sha)"
rc="$(retire claude-endolin2 --retire-host $E2 --authorized-by kriskowal --message-id m1 --reason 'account retired')"
resync
commits="$(git -C "$WORK" rev-list --count "$before"..HEAD)"
if [ "$rc" = 0 ] && [ "$commits" = 1 ] \
   && ! grep -q endolin2 "$WORK/config/budget-pools" \
   && ! grep -q "$E2" "$WORK/config/subscription-mapping" "$WORK/config/worker-leveling" \
   && grep -q "^codex-endolin" "$WORK/config/budget-pools" \
   && grep -qP "^codex-endolin\t$E1\tcleric$" "$WORK/config/subscription-mapping" \
   && ! has "hosts/$E2" && has "hosts/.archived-$E2" && ! has "worker-derotate/$E2" \
   && ! has budget/live/claude-endolin2 && ! has "budget/live/codex-endolin/$E2" && has "budget/live/codex-endolin/$E1" \
   && has budget/reset-events/claude-endolin2.jsonl && has "fleet/health/$E2" \
   && grep -qP "^subscription\tclaude-endolin2\t.*\tkriskowal\tm1\taccount retired$" "$WORK/config/retired-budget-sources" \
   && grep -qP "^host\t$E2\t" "$WORK/config/retired-budget-sources"; then
  ok "retirement removes the pool, mappings, leveling row, live snapshots; archives the host; keeps history; one commit"
else
  bad "retirement result wrong (rc=$rc commits=$commits): $(cat "$TR/stderr")"
fi

# Every surviving mapping names a surviving pool, and every living host still resolves.
orphans="$(awk 'NR==FNR{if(!/^#/)p[$1]=1;next} !/^#/ && !($1 in p)' "$WORK/config/budget-pools" "$WORK/config/subscription-mapping")"
if [ -z "$orphans" ] \
   && [ "$(budget_subscription_for_host_kind $E1 cleric "$WORK")" = codex-endolin ] \
   && [ "$(budget_subscription_for_host_kind $E1 monk "$WORK")" = claude-endolin1 ] \
   && [ "$(budget_subscription_for_host_kind $OR monk "$WORK")" = claude-oros ] \
   && ! budget_subscription_for_host_kind $E2 cleric "$WORK" >/dev/null 2>&1; then
  ok "no host maps to a missing pool and no living host loses its mapping"
else
  bad "mapping integrity after retirement (orphans=$orphans)"
fi

# 2. Tombstones: a second retirement and every setter refuse the retired ids.
before="$(head_sha)"
rc="$(retire claude-endolin2 --authorized-by kriskowal --reason again)"
rc2="$(run "$JOBS/set-budget-pool.sh" claude-endolin2 168000000 manual)"
rc3="$(run "$JOBS/set-worker-leveling.sh" 10 4 $E1:4:4 $E2:1:1 $OR:8:0)"
resync
if [ "$rc" = 2 ] && [ "$rc2" = 2 ] && [ "$rc3" = 2 ] && grep -q tombstoned "$TR/stderr" && [ "$before" = "$(head_sha)" ]; then
  ok "retired subscription and host are refused by retire, set-budget-pool, and set-worker-leveling"
else
  bad "tombstone refusal (retire=$rc set-budget-pool=$rc2 set-worker-leveling=$rc3)"
fi

# set-budget-pool consults the tombstone generically, not only its closed case list.
seed_state $'subscription\tclaude-oros\t2026-10-15T00:00:00Z\tkriskowal\t-\ttest\n'
before="$(head_sha)"
rc="$(run "$JOBS/set-budget-pool.sh" claude-oros 180000000 manual)"
resync
if [ "$rc" = 2 ] && grep -q tombstoned "$TR/stderr" && [ "$before" = "$(head_sha)" ]; then
  ok "set-budget-pool refuses any tombstoned subscription"
else
  bad "set-budget-pool accepted a tombstoned subscription (rc=$rc)"
fi

# 3. Fail-closed guards refuse without a commit.
seed_state
before="$(head_sha)"
rc_auth="$(retire claude-endolin2 --retire-host $E2 --authorized-by mallory --reason x)"
rc_living="$(retire claude-oros --authorized-by kriskowal --reason x)"
living_err="$(cat "$TR/stderr")"
rc_shared="$(retire claude-endolin2 --retire-host $E2 --retire-host $E1 --authorized-by kriskowal --reason x)"
shared_err="$(cat "$TR/stderr")"
rc_cap="$(retire claude-oros --retire-host $OR --authorized-by kriskowal --reason x)"
cap_err="$(cat "$TR/stderr")"
resync
if [ "$rc_auth" = 2 ] && [ "$rc_living" = 2 ] && [ "$rc_shared" = 2 ] && [ "$rc_cap" = 2 ] \
   && [[ "$living_err" == *"living host $OR would lose its last subscription mapping"* ]] \
   && [[ "$shared_err" == *"pool codex-endolin would lose its last mapped host"* ]] \
   && [[ "$cap_err" == *"physical monk capacity (4)"* ]] \
   && [ "$before" = "$(head_sha)" ]; then
  ok "unauthorized, orphaning, shared-pool-stranding, and envelope-breaking retirements are refused"
else
  bad "guards (auth=$rc_auth living=$rc_living shared=$rc_shared cap=$rc_cap): $living_err / $shared_err / $cap_err"
fi

# 4. Dry run shows the change and writes nothing.
rc="$(retire claude-endolin2 --retire-host $E2 --authorized-by kriskowal --reason x --dry-run)"
resync
if [ "$rc" = 0 ] && grep -q 'claude-endolin2' "$TR/stdout" && [ "$before" = "$(head_sha)" ] && has "hosts/$E2"; then
  ok "dry run prints the diff without committing"
else
  bad "dry run (rc=$rc)"
fi

echo "retire-subscription-test: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
