#!/bin/bash
# identity-drift-guard-test.sh — regression guard for the gardener-scaler
# host-identity DRIFT preflight (scripts/jobs/identity-drift-guard.sh).
#
# THE GAP THIS CLOSES: the per-spawn identity check in gardener.sh used to WARN and
# escalate from every one of the ~100 gardeners on every spawn — ~100 identical
# lines per wake that buried unrelated warnings and never self-resolved (the scaler
# inherits the same drifted env). The escalation moved OFF that per-spawn path into
# this once-per-tick, host-level guard, which on a genuine unrecorded divergence
# raises ONE actionable escalation — a kind:error maintainer-inbox report (plus a
# greppable journal entry) — deduped by a $GARDEN_STATE marker so it fires on tick 1
# of a regression and stays quiet until the drift changes or clears.
#
# SUBTEST 1 — GARDEN == hostname -s → NO emission; any stale marker cleared.
# SUBTEST 2 — divergence, no override → ONE maintainer report + ONE journal entry;
#             marker written; the maintainer body carries the `kind: error` marker.
# SUBTEST 3 — same drift on a second tick → DEDUPED (no new emission).
# SUBTEST 4 — divergence + recorded override → NO emission (deliberate parallel pool).
#
# Hermetic: the reporting sinks are captured via the guard's EMIT overrides (no real
# journal push); GARDEN_LEADER short-circuits the leader lookup (no network).
#
# Usage: identity-drift-guard-test.sh
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener running this as a board job cannot
# splice its own GARDEN_*/JOURNAL_* state underneath the fixture.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-drift-guard.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
HOST_SHORT="$(hostname -s 2>/dev/null || echo host)"
DRIFT="${HOST_SHORT}2"

MAINT_OUT="$TR/maint.out"; JRNL_OUT="$TR/jrnl.out"
export MAINT_OUT JRNL_OUT
# Each override consumes the piped body and appends a per-emission sentinel so the
# test can count invocations and inspect the captured body.
CAP_MAINT='cat >> "$MAINT_OUT"; printf "\n===MAINT-EMIT===\n" >> "$MAINT_OUT"'
CAP_JRNL='cat >> "$JRNL_OUT"; printf "\n===JRNL-EMIT===\n" >> "$JRNL_OUT"'

# run_guard <state-dir> <garden> [extra env KEY=VAL ...] — run the REAL guard with
# both sinks captured and the leader lookup short-circuited. Echoes the log path.
run_guard() {
  local state="$1" garden="$2"; shift 2
  env GARDEN="$garden" GARDEN_STATE="$state" GARDEN_LEADER="$HOST_SHORT" \
      GARDEN_IDENTITY_GUARD_MAINTAINER_EMIT="$CAP_MAINT" \
      GARDEN_IDENTITY_GUARD_EMIT="$CAP_JRNL" \
      "$@" "$JOBS/identity-drift-guard.sh" > "$state.log" 2>&1 || true
  printf '%s\n' "$state.log"
}
# grep -c already prints a count (0 on no match); `|| true` only swallows its exit.
n_emit() { grep -c "===$1-EMIT===" "$2" 2>/dev/null || true; }

# ============================================================================
hr; echo "SUBTEST 1 — GARDEN == hostname -s: no emission, stale marker cleared"; hr
S1="$TR/s1"; mkdir -p "$S1"
printf 'stale-sig\n' > "$S1/identity-drift-reported"   # pretend a prior drift was reported
: > "$MAINT_OUT"; : > "$JRNL_OUT"
run_guard "$S1" "$HOST_SHORT" >/dev/null
if [ "$(n_emit MAINT "$MAINT_OUT")" -eq 0 ] && [ "$(n_emit JRNL "$JRNL_OUT")" -eq 0 ]; then
  ok "matching identity emits nothing"
else
  bad "matching identity should not emit (maint=$(n_emit MAINT "$MAINT_OUT") jrnl=$(n_emit JRNL "$JRNL_OUT"))"
fi
if [ ! -f "$S1/identity-drift-reported" ]; then
  ok "a stale drift marker is cleared when identity is healthy again"
else
  bad "stale drift marker was not cleared: $(cat "$S1/identity-drift-reported")"
fi

# ============================================================================
hr; echo "SUBTEST 2 — divergence, no override: ONE maintainer report + ONE journal entry"; hr
S2="$TR/s2"; : > "$MAINT_OUT"; : > "$JRNL_OUT"
L2="$(run_guard "$S2" "$DRIFT")"
if [ "$(n_emit MAINT "$MAINT_OUT")" -eq 1 ]; then
  ok "unrecorded divergence posts exactly ONE maintainer-inbox report"
else
  bad "expected exactly 1 maintainer report, got $(n_emit MAINT "$MAINT_OUT")"
fi
if [ "$(n_emit JRNL "$JRNL_OUT")" -eq 1 ]; then
  ok "and exactly ONE journal entry"
else
  bad "expected exactly 1 journal entry, got $(n_emit JRNL "$JRNL_OUT")"
fi
grep -q "^kind: error" "$MAINT_OUT" \
  && ok "the maintainer body is marked kind: error" \
  || bad "maintainer body missing the kind: error marker"
grep -qF "GARDEN=\`$DRIFT\`" "$MAINT_OUT" \
  && ok "the report names the drifted GARDEN" \
  || bad "report did not name the drifted GARDEN"
if [ "$(head -1 "$S2/identity-drift-reported" 2>/dev/null)" = "GARDEN=$DRIFT|host=$HOST_SHORT|leader=$HOST_SHORT" ]; then
  ok "the dedup marker records the drift signature"
else
  bad "dedup marker missing/wrong: '$(head -1 "$S2/identity-drift-reported" 2>/dev/null)'"
fi
grep -q "WARN\|ERROR identity DRIFT" "$L2" \
  && ok "the guard logs loudly on the scaler's own journal each tick" \
  || bad "expected a loud drift log line"

# ============================================================================
hr; echo "SUBTEST 3 — same drift, second tick: DEDUPED (no new emission)"; hr
: > "$MAINT_OUT"; : > "$JRNL_OUT"
run_guard "$S2" "$DRIFT" >/dev/null    # reuse S2 → marker already present
if [ "$(n_emit MAINT "$MAINT_OUT")" -eq 0 ] && [ "$(n_emit JRNL "$JRNL_OUT")" -eq 0 ]; then
  ok "an unchanged drift signature is not re-posted on the next tick"
else
  bad "re-post on unchanged drift (maint=$(n_emit MAINT "$MAINT_OUT") jrnl=$(n_emit JRNL "$JRNL_OUT"))"
fi

# ============================================================================
hr; echo "SUBTEST 4 — divergence + recorded override: NO emission"; hr
S4="$TR/s4"; : > "$MAINT_OUT"; : > "$JRNL_OUT"
run_guard "$S4" "$DRIFT" GARDEN_IDENTITY_OVERRIDE="$DRIFT" >/dev/null
if [ "$(n_emit MAINT "$MAINT_OUT")" -eq 0 ] && [ "$(n_emit JRNL "$JRNL_OUT")" -eq 0 ]; then
  ok "a recorded parallel-pool override silences the escalation"
else
  bad "override should silence (maint=$(n_emit MAINT "$MAINT_OUT") jrnl=$(n_emit JRNL "$JRNL_OUT"))"
fi

# ============================================================================
hr
echo "identity-drift-guard-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
