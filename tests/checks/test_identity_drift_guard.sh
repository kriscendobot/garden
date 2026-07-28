#!/bin/bash
# test_identity_drift_guard.sh -- behavior test for identity-drift-guard.sh.
#
# The guard is the deterministic host-identity drift detector run as a
# gardener-scaler preflight. Verifies:
#   - GARDEN == hostname -s  -> no emission (the common case).
#   - GARDEN != hostname -s with NO recorded override -> ONE loud kind:error
#     emission, deduped across ticks (fires on tick 1, quiet after).
#   - a RECORDED override (GARDEN_IDENTITY_OVERRIDE or identity-override file
#     matching GARDEN) -> no emission (legitimate parallel pool).
#   - the emission body surfaces the leader/follower impact when the leader
#     marker names the real host but GARDEN has drifted.
#   - clearing the drift lets a later re-drift emit again.
#   - gardener-scaler.sh invokes the guard as a preflight.
#   - CONTAINMENT (section 6): a NEW escalation path that forgets its capture
#     override cannot reach the real journal.
#
# HERMETIC (incident 2026-07-28). THIS FILE was the leak: it captured only the
# JOURNAL sink (GARDEN_IDENTITY_GUARD_EMIT) and never the MAINTAINER-INBOX sink,
# which was added to the guard after this test was written. Its three drift runs
# therefore fell through to the real inbox-send.sh and posted three synthetic
# `driftname` kind:error reports into the production maintainer inbox on journal2.
# Ambient env made that possible: GARDEN_TEST was unset, so common.sh's
# guard_no_production_push_in_test was inert, and JOURNAL_REMOTE was unset, so the
# remote resolved to the real garden repo. Containment is now structural and
# layered, so no future sink can repeat it:
#   1. THROWAWAY REMOTE — JOURNAL_REMOTE points at a scratch bare repo, so ANY
#      journal-writing path (inbox-send, journal-entry, message-user, post-job),
#      wrapper or not, writes to the fixture and never to production.
#   2. TEST SENTINEL — GARDEN_TEST=1 makes commit_and_push/anchor_blob DIE on any
#      push whose target still resolves to the production journal.
#   3. FAIL-CLOSED SINK — the guard's emit_sink refuses to invoke a real sink under
#      a test context when its capture override is unset.
#   4. ENV SCRUB — ambient fleet GARDEN_*/JOURNAL_* (this test is often run by a
#      live gardener) cannot splice underneath the fixture.

set -uo pipefail

HARNESS_DIR=$(cd "$(dirname "$0")" && pwd)
PROJECT_ROOT=$(cd "$HARNESS_DIR/../.." && pwd)
GUARD="$PROJECT_ROOT/scripts/jobs/identity-drift-guard.sh"

# Layer 4: scrub ambient fleet state BEFORE anything resolves a remote or a clone.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

PASS=0
FAIL=0
ok() { PASS=$((PASS+1)); echo "  PASS: $1"; }
ko() { FAIL=$((FAIL+1)); echo "  FAIL: $1"; }

echo "=== test_identity_drift_guard ==="

[ -f "$GUARD" ] || { echo "missing $GUARD"; exit 2; }

SCRATCH=$(mktemp -d -t idg-XXXXXX)
trap 'rm -rf "$SCRATCH"' EXIT
mkdir -p "$SCRATCH/state"

HOST="$(hostname -s 2>/dev/null || echo host)"
EMITFILE="$SCRATCH/emitted.txt"
MAINTFILE="$SCRATCH/maintainer.txt"

# --- layers 1+2: a throwaway journal origin, and the test-context sentinel ----
# Seed a scratch bare repo shaped like journal2 so a forgotten sink has somewhere
# harmless to land, and export GARDEN_TEST so the push-path guard is armed.
BARE="$SCRATCH/journal.git"
git init -q --bare "$BARE"
SEED="$SCRATCH/seed"
git init -q "$SEED"
git -C "$SEED" checkout -q -b journal2
mkdir -p "$SEED"/{jobs/{todo,doin,tada,index},entries,msgs,hosts,inbox/maintainer/{unread,read}}
find "$SEED" -type d -not -path '*/.git/*' -not -name .git -exec touch {}/.gitkeep \;
git -C "$SEED" add -A
git -C "$SEED" -c user.name=test -c user.email=test@example.invalid commit -q -m seed
git -C "$SEED" push -q "$BARE" HEAD:journal2

export GARDEN_TEST=1
export GARDEN_ROOT="$PROJECT_ROOT"
export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2

# Read the fixture origin's maintainer inbox without a working tree.
bare_inbox_count() {
  git -C "$BARE" ls-tree -r --name-only journal2 2>/dev/null \
    | grep -c '^inbox/maintainer/unread/[^/]*\.md$' || true
}

# Run the guard with BOTH sinks captured and a stubbed leader marker (named the
# REAL host, so a drifted GARDEN reads as follower). $1 overrides GARDEN.
run_guard() {
  local garden="$1"
  rm -f "$EMITFILE" "$MAINTFILE"
  set +e
  GARDEN="$garden" \
  GARDEN_STATE="$SCRATCH/state" \
  GARDEN_LEADER="$HOST" \
  GARDEN_IDENTITY_GUARD_EMIT="cat >> '$EMITFILE'" \
  GARDEN_IDENTITY_GUARD_MAINTAINER_EMIT="cat >> '$MAINTFILE'" \
    bash "$GUARD" >/dev/null 2>&1
  RC=$?
  set -e
}
emitted() { [ -s "$EMITFILE" ]; }

# --- 1. no divergence -> no emission ---
run_guard "$HOST"
if ! emitted; then ok "GARDEN == hostname -s does not emit"; else ko "clean identity emitted"; fi
[ "$RC" -eq 0 ] && ok "guard exits 0 on clean identity" || ko "guard exit $RC on clean identity"

# --- 2. genuine drift -> emits once, then deduped ---
run_guard "driftname"
if emitted; then ok "unrecorded drift emits a kind:error"; else ko "unrecorded drift did not emit"; fi
grep -q 'DRIFT' "$EMITFILE" && ok "body announces DRIFT" || ko "body missing DRIFT"
grep -q 'driftname' "$EMITFILE" && ok "body names the drifted GARDEN" || ko "body missing GARDEN"
grep -q "$HOST" "$EMITFILE" && ok "body names hostname -s" || ko "body missing hostname"
grep -qi 'follower\|leader-only singleton' "$EMITFILE" && ok "body surfaces leader/follower impact" || ko "body missing leader impact"
[ -s "$MAINTFILE" ] && ok "the maintainer-inbox sink is captured, not posted for real" || ko "maintainer sink produced nothing"
grep -q '^kind: error' "$MAINTFILE" && ok "maintainer body is marked kind: error" || ko "maintainer body missing kind: error"
[ -f "$SCRATCH/state/identity-drift-reported" ] && ok "dedup marker written" || ko "dedup marker not written"

# second tick, same drift -> quiet
run_guard "driftname"
if ! emitted; then ok "same drift is deduped (no re-emit)"; else ko "same drift re-emitted"; fi

# --- 3. recorded override -> no emission ---
printf 'driftname\n' > "$SCRATCH/state/identity-override"
run_guard "driftname"
if ! emitted; then ok "recorded identity-override file silences the guard"; else ko "override file still emitted"; fi
rm -f "$SCRATCH/state/identity-override"

# env override
rm -f "$SCRATCH/state/identity-drift-reported"
rm -f "$EMITFILE" "$MAINTFILE"
set +e
GARDEN="driftname" GARDEN_STATE="$SCRATCH/state" GARDEN_LEADER="$HOST" \
  GARDEN_IDENTITY_OVERRIDE="driftname" \
  GARDEN_IDENTITY_GUARD_EMIT="cat >> '$EMITFILE'" \
  GARDEN_IDENTITY_GUARD_MAINTAINER_EMIT="cat >> '$MAINTFILE'" \
  bash "$GUARD" >/dev/null 2>&1
set -e
if [ ! -s "$EMITFILE" ]; then ok "GARDEN_IDENTITY_OVERRIDE env silences the guard"; else ko "override env still emitted"; fi

# --- 4. drift clears, re-drift emits again ---
run_guard "driftname"              # re-arm drift
[ -f "$SCRATCH/state/identity-drift-reported" ] || ko "expected re-armed marker"
run_guard "$HOST"                  # clear
[ ! -f "$SCRATCH/state/identity-drift-reported" ] && ok "marker cleared when drift resolves" || ko "marker survived resolution"
run_guard "driftname"              # re-drift
if emitted; then ok "re-drift after clearing emits again"; else ko "re-drift did not emit"; fi

# --- 5. the scaler wires the guard as a preflight ---
grep -q 'identity-drift-guard.sh' "$PROJECT_ROOT/scripts/jobs/gardener-scaler.sh" \
  && ok "gardener-scaler.sh invokes the guard" || ko "gardener-scaler.sh does not call the guard"

# --- 6. CONTAINMENT: a NEW escalation path that forgets its wrapper -----------
# Regression guard for the 2026-07-28 leak. Each layer is asserted on its own, so
# the containment survives a future sink whose override nobody remembers to set.

# 6a. FAIL-CLOSED SINK. Run the guard on genuine drift with the maintainer sink's
# override deliberately UNSET — exactly the shape that leaked. It must refuse to
# reach the real bus and say so, not fall through to inbox-send.sh.
INBOX_BEFORE="$(bare_inbox_count)"
rm -f "$SCRATCH/state/identity-drift-reported"
LEAKLOG="$SCRATCH/forgotten-sink.log"
set +e
GARDEN="driftname" GARDEN_STATE="$SCRATCH/state" GARDEN_LEADER="$HOST" \
  GARDEN_IDENTITY_GUARD_EMIT="cat >> '$EMITFILE'" \
  bash "$GUARD" > "$LEAKLOG" 2>&1
set -e
grep -q 'REFUSING to emit the maintainer-inbox report' "$LEAKLOG" \
  && ok "a sink with no capture override REFUSES to emit in a test context" \
  || ko "forgotten sink did not refuse: $(tr '\n' ' ' < "$LEAKLOG" | tail -c 300)"
[ ! -f "$SCRATCH/state/identity-drift-reported" ] \
  && ok "a refused escalation does NOT arm the dedup marker (it retries next tick)" \
  || ko "dedup marker armed despite a refused escalation"

# 6b. THROWAWAY REMOTE. Stand in for a future escalation path that bypasses the
# guard's wrappers entirely and calls the bus helper directly. It must land in the
# fixture origin, never in production.
set +e
GARDEN="driftname" GARDEN_STATE="$SCRATCH/state" \
  GARDEN_SKIP_REF_CHECK=1 GARDEN_SENDER="identity-drift-guard:$HOST" \
  bash -c 'printf "kind: error\n\nsimulated NEW escalation path\n" | "$1" maintainer' \
    _ "$PROJECT_ROOT/scripts/jobs/inbox-send.sh" > "$SCRATCH/direct-send.log" 2>&1
set -e
if [ "$(bare_inbox_count)" -gt "$INBOX_BEFORE" ]; then
  ok "an unwrapped escalation lands in the THROWAWAY origin, not production"
else
  ko "unwrapped escalation reached neither the fixture nor a refusal: $(tail -c 300 "$SCRATCH/direct-send.log")"
fi

# 6c. TEST SENTINEL. Even with the throwaway remote gone, a push whose target
# resolves to the production journal must DIE rather than land.
PRODCLONE="$SCRATCH/prod-clone"
git init -q "$PRODCLONE"
git -C "$PRODCLONE" remote add origin "git@github.com:kriscendobot/garden.git"
set +e
GUARDOUT=$(env -u JOURNAL_REMOTE GARDEN_TEST=1 GARDEN_STATE="$SCRATCH/state" bash -c \
  'source "$1"; guard_no_production_push_in_test "$2"' _ "$PROJECT_ROOT/scripts/jobs/common.sh" "$PRODCLONE" 2>&1)
GUARDRC=$?
set -e
if [ "$GUARDRC" -ne 0 ] && printf '%s' "$GUARDOUT" | grep -q 'REFUSING production-journal push'; then
  ok "the push-path guard refuses a production target under GARDEN_TEST=1"
else
  ko "production push was not refused (rc=$GUARDRC): $GUARDOUT"
fi

# 6d. REAL DRIFT STILL REPORTS. The containment must not become suppression: with
# no test context in effect and no override, the guard takes the real sink path and
# a genuine drift report reaches the maintainer inbox (here, the fixture origin's).
INBOX_BEFORE_REAL="$(bare_inbox_count)"
rm -f "$SCRATCH/state/identity-drift-reported"
set +e
env GARDEN_TEST=0 GARDEN="driftname" GARDEN_STATE="$SCRATCH/state" GARDEN_LEADER="$HOST" \
  GARDEN_IDENTITY_GUARD_EMIT="cat >> '$EMITFILE'" \
  bash "$GUARD" > "$SCRATCH/realpath.log" 2>&1
set -e
if [ "$(bare_inbox_count)" -gt "$INBOX_BEFORE_REAL" ]; then
  ok "outside a test context a REAL drift still posts a maintainer-inbox report"
else
  ko "real drift no longer reports (containment became suppression): $(tail -c 300 "$SCRATCH/realpath.log")"
fi

echo "=== test_identity_drift_guard: $PASS passed, $FAIL failed ==="
if [ "$FAIL" -gt 0 ]; then exit 1; fi
exit 0
