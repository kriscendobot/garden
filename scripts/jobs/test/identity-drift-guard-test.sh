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
# SUBTEST 5 — CONTAINMENT: a sink whose override is FORGOTTEN refuses to emit rather
#             than falling through to the real bus, and any unwrapped bus call lands
#             in a throwaway origin (incident 2026-07-28).
#
# Hermetic, in LAYERS rather than by remembering one override per sink — because
# forgetting one is exactly what leaked on 2026-07-28 (the sibling
# tests/checks/test_identity_drift_guard.sh captured the journal sink but not the
# maintainer sink, and posted three synthetic `driftname` kind:error reports into the
# real maintainer inbox on journal2):
#   1. THROWAWAY REMOTE — JOURNAL_REMOTE points at a scratch bare repo, so ANY
#      journal-writing path, wrapped or not, writes to the fixture.
#   2. TEST SENTINEL — GARDEN_TEST=1 arms common.sh's guard_no_production_push_in_test.
#   3. FAIL-CLOSED SINK — the guard's emit_sink refuses a real sink under a test
#      context when its capture override is unset.
#   4. ENV SCRUB — ambient fleet GARDEN_*/JOURNAL_* cannot splice underneath.
# GARDEN_LEADER short-circuits the leader lookup (no network).
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
# Test-context sentinel (set AFTER the scrub, which strips GARDEN_*): common.sh's
# guard_no_production_push_in_test then refuses any push that resolves to the real
# kriskowal/garden journal. This guard's EMIT overrides already capture the sinks
# hermetically, but the sentinel is the backstop for the 2026-07-11 leak class.
export GARDEN_TEST=1

TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-drift-guard.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
HOST_SHORT="$(hostname -s 2>/dev/null || echo host)"
DRIFT="${HOST_SHORT}2"

# Layer 1: a throwaway journal origin, shaped like journal2. Any bus call that
# escapes an EMIT override — a sink added later, a helper invoked directly — lands
# here instead of on production journal2.
BARE="$TR/journal.git"; git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"; git -C "$SEED" checkout -q -b journal2
mkdir -p "$SEED"/{jobs/{todo,doin,tada,index},entries,msgs,hosts,inbox/maintainer/{unread,read}}
find "$SEED" -type d -not -path '*/.git/*' -not -name .git -exec touch {}/.gitkeep \;
git -C "$SEED" add -A
git -C "$SEED" -c user.name=test -c user.email=test@example.invalid commit -q -m seed
git -C "$SEED" push -q "$BARE" HEAD:journal2
GARDEN_ROOT="$(cd "$JOBS/../.." && pwd)"
export GARDEN_ROOT JOURNAL_BRANCH=journal2
export JOURNAL_REMOTE="$BARE"

# Count maintainer messages on the fixture origin (no working tree needed).
bare_inbox_count() {
  git -C "$BARE" ls-tree -r --name-only journal2 2>/dev/null \
    | grep -c '^inbox/maintainer/unread/[^/]*\.md$' || true
}

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
hr; echo "SUBTEST 5 — CONTAINMENT: a FORGOTTEN sink override cannot reach the real bus"; hr
# Stand in for a NEW escalation path added to the guard whose capture override
# nobody remembers to set: run genuine drift with GARDEN_IDENTITY_GUARD_MAINTAINER_EMIT
# UNSET — the exact shape that leaked on 2026-07-28.
S5="$TR/s5"; : > "$MAINT_OUT"; : > "$JRNL_OUT"
INBOX_BEFORE="$(bare_inbox_count)"
env GARDEN="$DRIFT" GARDEN_STATE="$S5" GARDEN_LEADER="$HOST_SHORT" \
    GARDEN_IDENTITY_GUARD_EMIT="$CAP_JRNL" \
    "$JOBS/identity-drift-guard.sh" > "$TR/s5.log" 2>&1 || true
grep -q 'REFUSING to emit the maintainer-inbox report' "$TR/s5.log" \
  && ok "a sink with no capture override REFUSES rather than posting for real" \
  || bad "forgotten sink did not refuse: $(tr '\n' ' ' < "$TR/s5.log" | tail -c 200)"
[ "$(bare_inbox_count)" -eq "$INBOX_BEFORE" ] \
  && ok "and nothing was written to the journal origin at all" \
  || bad "the forgotten sink still wrote to the journal origin"
[ ! -f "$S5/identity-drift-reported" ] \
  && ok "a refused escalation does not arm the dedup marker (it retries next tick)" \
  || bad "dedup marker armed despite a refused escalation"

# The other half of the invariant: containment must not become SUPPRESSION. With no
# test context in effect, the real sink path runs and a genuine drift report reaches
# the maintainer inbox (here, the fixture origin's).
S5B="$TR/s5b"; INBOX_BEFORE="$(bare_inbox_count)"
env GARDEN_TEST=0 GARDEN="$DRIFT" GARDEN_STATE="$S5B" GARDEN_LEADER="$HOST_SHORT" \
    GARDEN_IDENTITY_GUARD_EMIT="$CAP_JRNL" \
    "$JOBS/identity-drift-guard.sh" > "$TR/s5b.log" 2>&1 || true
[ "$(bare_inbox_count)" -gt "$INBOX_BEFORE" ] \
  && ok "outside a test context a REAL drift still posts a maintainer-inbox report" \
  || bad "real drift no longer reports: $(tr '\n' ' ' < "$TR/s5b.log" | tail -c 200)"

# ============================================================================
hr
echo "identity-drift-guard-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
