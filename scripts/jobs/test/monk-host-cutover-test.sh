#!/bin/bash
# monk-host-cutover-test.sh — the per-host gardener@ -> monk@ cutover transaction
# (migrate-host-to-monk.sh; design anthropic-worker-kind-monk.md § stage 1),
# exercised hermetically against test/mock-systemctl.sh (no real systemd, no fleet).
#
# Proves the stage-1 postconditions and refusals:
#   CUTOVER   — drains, disables every garden-gardener@1..N, enables garden-monk@1..N,
#               writes `monks: N` while RETAINING the `gardeners: N` mirror, asserts
#               exactly N monk + 0 legacy units active, and lifts the drain.
#   NEVER-BOTH— no garden-gardener@i and garden-monk@i are ever both active.
#   IDEMPOTENT— a re-run on an already-migrated host is a clean no-op.
#   REFUSE    — a busy legacy worker blocks the cutover and the drain STAYS on.
#   ROLLBACK  — reverses to the legacy pool, drops the monks: line, lifts the drain.
#
# Usage: monk-host-cutover-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_|AUCTION_)' || true) 2>/dev/null || true
export GARDEN_TEST=1 GARDEN_ROOT="$ROOT" GARDEN_NO_MAINTAINER_ALERT=1
git_id=(-c user.name=test -c user.email=test@localhost)

# A throwaway journal whose hosts/<host> declares `gardeners: N`.
seed_journal() {  # seed_journal <tr> <host> <n>
  local tr="$1" host="$2" n="$3" bare="$1/journal.git" seed="$1/seed"
  git init -q --bare "$bare"; git init -q "$seed"; git -C "$seed" checkout -q -b journal2
  ( cd "$seed"; mkdir -p hosts jobs/todo jobs/doin jobs/tada work msgs
    for d in jobs/todo jobs/doin jobs/tada work msgs; do touch "$d/.gitkeep"; done
    printf 'gardeners: %s\n' "$n" > "hosts/$host" )
  git -C "$seed" add -A; git -C "$seed" "${git_id[@]}" commit -q -m seed
  git -C "$seed" remote add origin "$bare"; git -C "$seed" push -q -u origin journal2
  printf '%s\n' "$bare"
}

# Run the migrate command in a fully isolated host env with mocked systemd.
run_migrate() {  # run_migrate <tr> <host> <bare> <mockstate> <args...>
  local tr="$1" host="$2" bare="$3" mock="$4"; shift 4
  env GARDEN="$host" GARDEN_TEST=1 GARDEN_ROOT="$ROOT" \
      GARDEN_STATE="$tr/state" JOURNAL_REMOTE="$bare" JOURNAL_BRANCH=journal2 \
      GARDEN_PRODUCER_CLONE="$tr/state/producer/journal" \
      GARDEN_UNIT_CTL="$HERE/mock-systemctl.sh" GARDEN_MOCK_STATE="$mock" GARDEN_MOCK_LOG="$tr/mock.log" \
      MONK_MIGRATE_SKIP_RENDER=1 MONK_MIGRATE_DRAIN_WAIT=6 MONK_MIGRATE_POLL=1 \
      GARDEN_NO_MAINTAINER_ALERT=1 \
      "$JOBS/migrate-host-to-monk.sh" "$@"
}

active_g() { grep -c '^garden-gardener@[0-9]*\.service$' "$1" 2>/dev/null || true; }
active_m() { grep -c '^garden-monk@[0-9]*\.service$' "$1" 2>/dev/null || true; }
draining() { [ -e "$1/state/draining" ]; }
host_line() { git clone -q --single-branch --branch journal2 "$1" "$2" 2>/dev/null; }

# ============================================================================
hr; echo "CUTOVER — gardener@ pool -> monk@ pool, monks: written, mirror retained"; hr
TR="$(mktemp -d "${TMPDIR:-/tmp}/monk-cut.XXXXXX")"; HOST=fh1; N=3
BARE="$(seed_journal "$TR" "$HOST" "$N")"
MOCK="$TR/armed"; : > "$MOCK"
# pre-arm the legacy pool active (as a running host would be).
for i in 1 2 3; do echo "garden-gardener@$i.service" >> "$MOCK"; done

rc=0; run_migrate "$TR" "$HOST" "$BARE" "$MOCK" cutover > "$TR/cut.log" 2>&1 || rc=$?
[ "$rc" -eq 0 ] && ok "cutover exited 0" || { bad "cutover rc=$rc"; sed 's/^/      /' "$TR/cut.log"; }
[ "$(active_m "$MOCK")" -eq "$N" ] && ok "garden-monk@{1,2,3} active after cutover" || bad "monk active=$(active_m "$MOCK") (want $N)"
[ "$(active_g "$MOCK")" -eq 0 ] && ok "zero legacy garden-gardener@ active after cutover" || bad "legacy still active=$(active_g "$MOCK")"
! draining "$TR" && ok "drain LIFTED on success" || bad "drain marker left on after a successful cutover"
V="$TR/v"; host_line "$BARE" "$V"
grep -q '^monks: 3$' "$V/hosts/$HOST" && ok "monks: 3 written to hosts/$HOST" || bad "monks: not written ($(tr '\n' ' ' <"$V/hosts/$HOST"))"
grep -q '^gardeners: 3$' "$V/hosts/$HOST" && ok "gardeners: 3 mirror RETAINED (never summed away)" || bad "gardeners mirror lost"

# NEVER-BOTH: at no index are both spellings active in the final armed set.
both=0; for i in 1 2 3; do { grep -qx "garden-gardener@$i.service" "$MOCK" && grep -qx "garden-monk@$i.service" "$MOCK"; } && both=1; done
[ "$both" -eq 0 ] && ok "never both pools armed for one slot (exclusivity held)" || bad "a slot had BOTH pools active"

# IDEMPOTENT: a second cutover on the migrated host is a clean no-op.
rc=0; run_migrate "$TR" "$HOST" "$BARE" "$MOCK" cutover > "$TR/cut2.log" 2>&1 || rc=$?
{ [ "$rc" -eq 0 ] && [ "$(active_m "$MOCK")" -eq "$N" ] && [ "$(active_g "$MOCK")" -eq 0 ]; } \
  && ok "re-run cutover is an idempotent no-op (still N monk, 0 legacy)" || bad "re-run not idempotent (rc=$rc monk=$(active_m "$MOCK") legacy=$(active_g "$MOCK"))"
rm -rf "$TR"

# ============================================================================
hr; echo "REFUSE — a busy legacy worker blocks the cutover; the drain STAYS on"; hr
TR="$(mktemp -d "${TMPDIR:-/tmp}/monk-busy.XXXXXX")"; HOST=fh2; N=2
BARE="$(seed_journal "$TR" "$HOST" "$N")"
MOCK="$TR/armed"; : > "$MOCK"; for i in 1 2; do echo "garden-gardener@$i.service" >> "$MOCK"; done
# plant a busy marker for gardener-1 under this host's state namespace.
mkdir -p "$TR/state/gardeners/1"; : > "$TR/state/gardeners/1/busy"
rc=0; run_migrate "$TR" "$HOST" "$BARE" "$MOCK" cutover > "$TR/busy.log" 2>&1 || rc=$?
[ "$rc" -ne 0 ] && ok "cutover REFUSED while a gardener worker is busy (rc=$rc)" || bad "cutover proceeded despite a busy worker"
[ "$(active_m "$MOCK")" -eq 0 ] && ok "no monk unit was enabled on the refused cutover" || bad "monk units enabled despite refusal"
[ "$(active_g "$MOCK")" -eq "$N" ] && ok "legacy pool untouched on refusal" || bad "legacy pool disturbed on refusal"
draining "$TR" && ok "drain STAYS on after a busy-worker refusal (safe halt)" || bad "drain was lifted after a refusal"
V="$TR/v"; host_line "$BARE" "$V"
! grep -q '^monks:' "$V/hosts/$HOST" && ok "monks: NOT written on a pre-step refusal" || bad "monks: written despite refusal"
rm -rf "$TR"

# ============================================================================
hr; echo "ROLLBACK — monk@ pool -> gardener@ pool, monks: line dropped"; hr
TR="$(mktemp -d "${TMPDIR:-/tmp}/monk-rb.XXXXXX")"; HOST=fh3; N=2
BARE="$(seed_journal "$TR" "$HOST" "$N")"
MOCK="$TR/armed"; : > "$MOCK"; for i in 1 2; do echo "garden-gardener@$i.service" >> "$MOCK"; done
run_migrate "$TR" "$HOST" "$BARE" "$MOCK" cutover > "$TR/rc.log" 2>&1 || true
{ [ "$(active_m "$MOCK")" -eq "$N" ] && [ "$(active_g "$MOCK")" -eq 0 ]; } && ok "precondition: host cut over to monk" || bad "cutover precondition failed"
rc=0; run_migrate "$TR" "$HOST" "$BARE" "$MOCK" rollback > "$TR/rb.log" 2>&1 || rc=$?
[ "$rc" -eq 0 ] && ok "rollback exited 0" || { bad "rollback rc=$rc"; sed 's/^/      /' "$TR/rb.log"; }
[ "$(active_g "$MOCK")" -eq "$N" ] && ok "legacy garden-gardener@ pool restored" || bad "legacy not restored (active=$(active_g "$MOCK"))"
[ "$(active_m "$MOCK")" -eq 0 ] && ok "zero garden-monk@ active after rollback" || bad "monk still active=$(active_m "$MOCK")"
! draining "$TR" && ok "drain lifted after rollback" || bad "drain left on after rollback"
V="$TR/v"; host_line "$BARE" "$V"
{ ! grep -q '^monks:' "$V/hosts/$HOST" && grep -q '^gardeners: 2$' "$V/hosts/$HOST"; } \
  && ok "monks: line dropped, gardeners: 2 remains active" || bad "count keys wrong after rollback ($(tr '\n' ' ' <"$V/hosts/$HOST"))"
# after rollback the host's active Anthropic kind is gardener again.
source "$JOBS/common.sh"
[ "$(anthropic_active_kind "$V/hosts/$HOST")" = gardener ] && ok "active Anthropic kind is gardener again post-rollback" || bad "active kind not reverted"
rm -rf "$TR"

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
