#!/bin/bash
# Hermetic coverage for set-worker-leveling.sh's calibrated-pool host gate.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/var/tmp}/garden-set-worker-leveling-pool-host.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
pass=0; fail=0
ok() { echo "PASS: $*"; pass=$((pass+1)); }
bad() { echo "FAIL: $*"; fail=$((fail+1)); }
git_id=(-c user.name=test -c user.email=test@example.invalid)

BARE="$TR/journal.git"; SEED="$TR/seed"; WORK="$TR/work"
git init -q --bare "$BARE"
git init -q "$SEED"; git -C "$SEED" checkout -q -b journal2
mkdir -p "$SEED/config"
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q --allow-empty -m seed
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin journal2
git clone -q --single-branch --branch journal2 "$BARE" "$WORK"
git -C "$WORK" config user.name test
git -C "$WORK" config user.email test@example.invalid

export GARDEN_TEST=1 GARDEN=test-garden GARDEN_ROOT="$ROOT"
export GARDEN_STATE="$TR/state" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2
export GARDEN_PRODUCER_CLONE="$WORK"

resync() {
  git -C "$WORK" fetch -q origin journal2
  git -C "$WORK" reset -q --hard origin/journal2
}
seed_state() { # budget-pools-content
  resync
  mkdir -p "$WORK/config"
  printf '%s' "$1" >"$WORK/config/budget-pools"
  printf 'monk-fleet-ceiling\t1\ncleric-fleet-ceiling\t1\nhost\toriginal\t1\t1\n' >"$WORK/config/worker-leveling"
  git -C "$WORK" add config/budget-pools config/worker-leveling
  git -C "$WORK" commit -q -m fixture --allow-empty
  git -C "$WORK" push -q origin HEAD:journal2
}
run_setter() {
  set +e
  "$JOBS/set-worker-leveling.sh" "$@" >"$TR/stdout" 2>"$TR/stderr"
  local rc=$?
  set -e
  echo "$rc"
}
has_host() {
  awk -v h="$1" '$1=="host"&&$2==h{found=1}END{exit !found}' "$WORK/config/worker-leveling"
}

CALIBRATED=$'anthropic:oros-studio-garden-ce242c49\tanthropic\toros-studio-garden-ce242c49\tweekly-tokens\t100000000\tmanual-fit\t2026-09-17\n'

# Omitting an enabled calibrated pool host must reject without replacing the config.
seed_state "$CALIBRATED"
before="$(git -C "$WORK" rev-parse HEAD)"
rc="$(run_setter 2 2 other-host:2:2)"
resync
after="$(git -C "$WORK" rev-parse HEAD)"
if [ "$rc" = 2 ] && [ "$before" = "$after" ] && has_host original \
   && grep -q "calibrated pool anthropic:oros-studio-garden-ce242c49" "$TR/stderr"; then
  ok "an omitted calibrated pool host rejects the replacement without a commit"
else
  bad "omitted pool host was not rejected atomically (rc=$rc)"
fi

# Supplying the pool host with a positive monk cap permits the replacement.
seed_state "$CALIBRATED"
rc="$(run_setter 3 2 oros-studio-garden-ce242c49:3:2)"
resync
if [ "$rc" = 0 ] && has_host oros-studio-garden-ce242c49 && ! has_host original; then
  ok "a calibrated pool host with a positive monk cap is accepted"
else
  bad "valid calibrated pool host replacement failed (rc=$rc)"
fi

# Zero is not a valid monk cap and must never replace the current configuration.
seed_state "$CALIBRATED"
before="$(git -C "$WORK" rev-parse HEAD)"
rc="$(run_setter 1 1 oros-studio-garden-ce242c49:0:1)"
resync
after="$(git -C "$WORK" rev-parse HEAD)"
if [ "$rc" = 2 ] && [ "$before" = "$after" ] && has_host original; then
  ok "an invalid pool-host monk cap is rejected without a commit"
else
  bad "invalid monk cap changed worker-leveling (rc=$rc)"
fi

# Pools outside the enabled calibrated Anthropic weekly-token set need no host row.
IGNORED=$'anthropic:placeholder\tanthropic\tplaceholder\tweekly-tokens\t5000000\tplaceholder\t-\n'
IGNORED+=$'anthropic:temporary\tanthropic\ttemporary\tunmetered\t-\ttemporary-key\t2026-09-17\n'
IGNORED+=$'openai:shared\topenai\tshared\tweekly-tokens\t100000000\tmanual-fit\t2026-09-17\n'
seed_state "$IGNORED"
rc="$(run_setter 2 2 other-host:2:2)"
resync
if [ "$rc" = 0 ] && has_host other-host; then
  ok "uncalibrated, unmetered, and non-Anthropic pools do not require host rows"
else
  bad "a pool outside the leveling denominator blocked replacement (rc=$rc)"
fi

echo "set-worker-leveling-pool-host-test: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
