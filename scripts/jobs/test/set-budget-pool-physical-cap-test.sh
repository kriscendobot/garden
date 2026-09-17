#!/bin/bash
# Hermetic coverage for set-budget-pool.sh's worker-leveling physical-cap coupling:
# enabling a calibrated Anthropic weekly-tokens pool must validate/upsert the host's
# config/worker-leveling monk physical cap in the SAME atomic commit, or reject, so the
# monk fleet can never be frozen by a pool whose host lacks a physical-cap row
# (proportional-worker-leveling.md § 1.4; the oros-studio-garden-ce242c49 incident).
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/var/tmp}/garden-set-budget-pool-physcap.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
pass=0; fail=0
ok() { echo "PASS: $*"; pass=$((pass+1)); }
bad() { echo "FAIL: $*"; fail=$((fail+1)); }
git_id=(-c user.name=test -c user.email=test@example.invalid)

BARE="$TR/journal.git"; SEED="$TR/seed"; WORK="$TR/work"
git init -q --bare "$BARE"
git init -q "$SEED"; git -C "$SEED" checkout -q -b journal2
mkdir -p "$SEED/config"
git -C "$SEED" add -A; git -C "$SEED" "${git_id[@]}" commit -q --allow-empty -m seed
git -C "$SEED" remote add origin "$BARE"; git -C "$SEED" push -q -u origin journal2
git clone -q --single-branch --branch journal2 "$BARE" "$WORK"
git -C "$WORK" config user.name test; git -C "$WORK" config user.email test@example.invalid

export GARDEN_TEST=1 GARDEN=test-garden GARDEN_ROOT="$ROOT"
export GARDEN_STATE="$TR/state" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2
export GARDEN_PRODUCER_CLONE="$WORK"

resync() { git -C "$WORK" fetch -q origin journal2; git -C "$WORK" reset -q --hard origin/journal2; }

# Rewrite both config files to a known baseline and publish them, so each case starts
# from a deterministic committed state (set-budget-pool re-syncs the clone, wiping any
# uncommitted fixture).
seed_state() { # <budget-pools-content> <worker-leveling-content-or-EMPTY>
  resync
  mkdir -p "$WORK/config"
  printf '%s' "$1" > "$WORK/config/budget-pools"
  if [ "$2" = EMPTY ]; then rm -f "$WORK/config/worker-leveling"; else printf '%s' "$2" > "$WORK/config/worker-leveling"; fi
  git -C "$WORK" add -A
  git -C "$WORK" commit -q -m fixture --allow-empty
  git -C "$WORK" push -q origin HEAD:journal2
}

run_setter() { set +e; "$JOBS/set-budget-pool.sh" "$@" >/dev/null 2>&1; local rc=$?; set -e; echo "$rc"; }
lv_row() { awk -v h="$1" '$1=="host" && $2==h { print $3, $4; f=1 } END{ if(!f) print "ABSENT" }' "$WORK/config/worker-leveling" 2>/dev/null; }
bp_has() { awk -v p="$1" '$1==p { f=1 } END{ exit !f }' "$WORK/config/budget-pools"; }

LV_BASE=$'monk-fleet-ceiling\t2\ncleric-fleet-ceiling\t2\nhost\tlarge\t4\t4\n'
BP_BASE=$'anthropic:large\tanthropic\tlarge\tweekly-tokens\t143000000\tmanual-fit\t2026-09-01\n'

# 1. Calibrated Anthropic pool, worker-leveling configured, host row ABSENT, no --monk-cap:
#    HARD REJECT (exit 2), and NEITHER file mutated.
seed_state "$BP_BASE" "$LV_BASE"
rc="$(run_setter anthropic:newhost 100000000 manual-fit 2026-09-17)"
resync
if [ "$rc" = 2 ] && ! bp_has anthropic:newhost && [ "$(lv_row newhost)" = ABSENT ]; then
  ok "missing physical-cap row rejects promotion and lands neither file"
else
  bad "expected reject with no mutation (rc=$rc, lv=$(lv_row newhost))"
fi

# 2. Same, but --monk-cap (and --cleric-cap) supplied: atomic upsert of both files.
seed_state "$BP_BASE" "$LV_BASE"
rc="$(run_setter anthropic:newhost 100000000 manual-fit 2026-09-17 --monk-cap 3 --cleric-cap 1)"
resync
last_files="$(git -C "$WORK" show --name-only --format= HEAD)"
if [ "$rc" = 0 ] && bp_has anthropic:newhost && [ "$(lv_row newhost)" = "3 1" ] \
   && grep -qx 'config/budget-pools' <<<"$last_files" && grep -qx 'config/worker-leveling' <<<"$last_files"; then
  ok "--monk-cap upserts the host row and pool row in one atomic commit"
else
  bad "atomic upsert failed (rc=$rc, lv=$(lv_row newhost), files=$(tr '\n' ',' <<<"$last_files"))"
fi

# 3. Host row already present and valid, no --monk-cap: validate-only, row untouched.
seed_state "$BP_BASE" "$LV_BASE"
rc="$(run_setter anthropic:large 150000000 manual-fit 2026-09-17)"
resync
if [ "$rc" = 0 ] && [ "$(lv_row large)" = "4 4" ] && bp_has anthropic:large; then
  ok "an existing valid physical-cap row is validated and left unchanged"
else
  bad "validate-only path mutated or failed (rc=$rc, lv=$(lv_row large))"
fi

# 3b. --monk-cap overrides an existing row (update path).
seed_state "$BP_BASE" "$LV_BASE"
rc="$(run_setter anthropic:large 150000000 manual-fit 2026-09-17 --monk-cap 5)"
resync
if [ "$rc" = 0 ] && [ "$(lv_row large)" = "5 4" ]; then
  ok "--monk-cap updates an existing physical-cap row, preserving the cleric cap"
else
  bad "update path failed (rc=$rc, lv=$(lv_row large))"
fi

# 4. A supplied cap that still leaves physical capacity below the fleet ceiling REJECTS,
#    instead of trading the missing-row freeze for a capacity freeze.
seed_state "$BP_BASE" $'monk-fleet-ceiling\t10\ncleric-fleet-ceiling\t2\nhost\tlarge\t4\t4\n'
rc="$(run_setter anthropic:newhost 100000000 manual-fit 2026-09-17 --monk-cap 2)"
resync
if [ "$rc" = 2 ] && [ "$(lv_row newhost)" = ABSENT ] && ! bp_has anthropic:newhost; then
  ok "upsert that keeps capacity below the fleet ceiling is rejected, not written"
else
  bad "capacity-vs-ceiling reject failed (rc=$rc, lv=$(lv_row newhost))"
fi

# 5. An upsert that would push the host count above the one-per-host floor REJECTS.
seed_state "$BP_BASE" $'monk-fleet-ceiling\t1\ncleric-fleet-ceiling\t2\nhost\tlarge\t4\t4\n'
rc="$(run_setter anthropic:newhost 100000000 manual-fit 2026-09-17 --monk-cap 4)"
resync
if [ "$rc" = 2 ] && [ "$(lv_row newhost)" = ABSENT ]; then
  ok "upsert below the one-per-host floor is rejected"
else
  bad "one-per-host floor reject failed (rc=$rc, lv=$(lv_row newhost))"
fi

# 6. No worker-leveling configured at all: leveling is off, no freeze possible, so no cap
#    is required and the calibrated pool still promotes (existing behavior preserved).
seed_state "$BP_BASE" EMPTY
rc="$(run_setter anthropic:newhost 100000000 manual-fit 2026-09-17)"
resync
if [ "$rc" = 0 ] && bp_has anthropic:newhost && [ ! -f "$WORK/config/worker-leveling" ]; then
  ok "with leveling unconfigured, promotion needs no physical cap"
else
  bad "unconfigured-leveling promotion failed (rc=$rc)"
fi

# 6b. --monk-cap with no worker-leveling file has nowhere valid to land: REJECT.
seed_state "$BP_BASE" EMPTY
rc="$(run_setter anthropic:newhost 100000000 manual-fit 2026-09-17 --monk-cap 3)"
resync
if [ "$rc" = 2 ] && ! bp_has anthropic:newhost && [ ! -f "$WORK/config/worker-leveling" ]; then
  ok "--monk-cap against unconfigured leveling is rejected"
else
  bad "unconfigured-leveling + --monk-cap should reject (rc=$rc)"
fi

# 7. Uncalibrated provenance does NOT require a physical cap even with leveling configured:
#    the pool is not yet an enabled denominator, so it cannot freeze the fleet.
seed_state "$BP_BASE" "$LV_BASE"
rc="$(run_setter anthropic:seedhost 5000000 placeholder)"
resync
if [ "$rc" = 0 ] && bp_has anthropic:seedhost && [ "$(lv_row seedhost)" = ABSENT ]; then
  ok "an uncalibrated (placeholder) pool needs no physical cap"
else
  bad "uncalibrated pool wrongly required a cap (rc=$rc)"
fi

# 8. Non-Anthropic and unmetered pools are outside the monk denominator: no cap required.
seed_state "$BP_BASE" "$LV_BASE"
rc="$(run_setter openai:codexhost 100000000 manual-fit 2026-09-17)"
resync
rc2="$(run_setter anthropic:tempkey - temporary-key 2026-09-17 --kind unmetered)"
resync
if [ "$rc" = 0 ] && bp_has openai:codexhost && [ "$rc2" = 0 ] && bp_has anthropic:tempkey; then
  ok "non-Anthropic and unmetered pools require no physical cap"
else
  bad "non-Anthropic/unmetered wrongly gated (rc=$rc, rc2=$rc2)"
fi

echo "set-budget-pool-physical-cap-test: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
