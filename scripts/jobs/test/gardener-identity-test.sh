#!/bin/bash
# gardener-identity-test.sh — regression guard for the gardener's host-identity
# assertion at spawn (gardener.sh § host-identity assertion at spawn).
#
# THE GAP THIS CLOSES: gardener.sh never surfaced or validated its resolved GARDEN
# at boot, so an inherited-env drift (the endolinbot2 case: an environment.d /
# manager-env GARDEN that no longer matches this host) stayed invisible until it had
# already corrupted per-host journal/index state — the claim key, the hosts/<host>
# worker count, and the leader predicate all hang off GARDEN.
#
# THE FIX: at spawn, gardener.sh (1) LOGS the resolved GARDEN once; (2) compares it
# to `hostname -s` and, when they differ without a recorded deliberate override,
# notes it in a single low-volume INFO line — NOT a WARN, and NOT a per-spawn
# escalation. The per-spawn path runs from every one of the ~100 gardeners on every
# spawn, so a WARN + report here is ~100 identical lines per wake; the once-per-tick,
# host-level escalation (one WARN + one deduped kind:error maintainer-inbox report)
# lives in the gardener-scaler identity-drift guard (identity-drift-guard.sh). And
# (3) writes a per-instance identity marker $GARDEN_STATE/gardeners/<id>.garden
# holding the resolved name, so the scaler's drift check can read it without /proc.
#
# SUBTEST 1 — GARDEN == hostname -s → identity logged, NO WARN, marker == GARDEN.
# SUBTEST 2 — GARDEN != hostname -s, no override → NO per-spawn WARN, one info line,
#             marker == GARDEN (escalation now lives in the gardener-scaler guard).
# SUBTEST 3 — divergence + GARDEN_IDENTITY_OVERRIDE == GARDEN → NO WARN (deliberate).
# SUBTEST 4 — divergence + $GARDEN_STATE/identity-override == GARDEN → NO WARN.
#
# Hermetic: a throwaway git origin with an EMPTY board; gardener runs ONESHOT and
# exits after two clean idle passes, exercising only the startup path. No network,
# no systemd, no `claude`.
#
# Usage: gardener-identity-test.sh
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env (a live gardener running this as a board job would
# otherwise splice its own GARDEN_*/JOURNAL_* state underneath the fixture).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-identity.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
BARE="$TR/journal.git"; BRANCH=journal2
git_id=(-c user.name=test -c user.email=test@localhost)

# Seed a throwaway origin with the board structure and NO jobs (empty board).
git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BRANCH"
( cd "$SEED"
  mkdir -p jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors
  for d in jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors; do touch "$d/.gitkeep"; done )
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m "seed: empty board + structure"
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH"

HOST_SHORT="$(hostname -s 2>/dev/null || echo host)"

# run_gardener <state-dir> <garden> [extra env KEY=VAL ...] — boot the REAL
# gardener.sh oneshot against the empty board; echoes the log path.
run_gardener() {
  local state="$1" garden="$2"; shift 2
  env GARDEN="$garden" GARDEN_STATE="$state" \
      GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 "$@" \
      "$JOBS/gardener.sh" 1 > "$state.log" 2>&1 || true
  printf '%s\n' "$state.log"
}

# ============================================================================
hr; echo "SUBTEST 1 — GARDEN == hostname -s: logged, no WARN, marker matches"; hr
S1="$TR/s1"; L1="$(run_gardener "$S1" "$HOST_SHORT")"
grep -q "identity: GARDEN=$HOST_SHORT (hostname -s=$HOST_SHORT)" "$L1" \
  && ok "resolved GARDEN logged once at startup" \
  || bad "startup identity line missing. log: $(grep -i identity "$L1" | head -2)"
if grep -q "WARN identity" "$L1"; then
  bad "a matching identity should NOT warn"
else
  ok "GARDEN == hostname -s → no divergence WARN"
fi
if [ "$(cat "$S1/gardeners/1.garden" 2>/dev/null)" = "$HOST_SHORT" ]; then
  ok "per-instance marker written with the resolved GARDEN"
else
  bad "marker $S1/gardeners/1.garden missing or wrong: '$(cat "$S1/gardeners/1.garden" 2>/dev/null)'"
fi

# ============================================================================
hr; echo "SUBTEST 2 — GARDEN != hostname -s, no override: info-only, NO per-spawn WARN"; hr
DRIFT="${HOST_SHORT}2"
S2="$TR/s2"; L2="$(run_gardener "$S2" "$DRIFT")"
# The per-spawn WARN + escalation MOVED off this ~100×/spawn path into the
# gardener-scaler identity-drift guard (once per tick, deduped). Here only a
# low-volume info line remains, so the spammy WARN must be GONE.
if grep -q "WARN identity" "$L2"; then
  bad "the per-spawn identity WARN should have moved to the gardener-scaler guard; found: $(grep 'WARN identity' "$L2" | head -1)"
else
  ok "divergence without a recorded override no longer WARNs on the per-spawn path"
fi
grep -q "identity: GARDEN=$DRIFT diverges from hostname -s=$HOST_SHORT with no recorded override" "$L2" \
  && ok "a single low-volume info line still notes the divergence" \
  || bad "expected an info divergence line. log: $(grep -i identity "$L2" | head -3)"
if [ "$(cat "$S2/gardeners/1.garden" 2>/dev/null)" = "$DRIFT" ]; then
  ok "marker records the (drifted) resolved GARDEN for the scaler's drift check"
else
  bad "marker did not record the drifted GARDEN: '$(cat "$S2/gardeners/1.garden" 2>/dev/null)'"
fi

# ============================================================================
hr; echo "SUBTEST 3 — divergence + GARDEN_IDENTITY_OVERRIDE == GARDEN: no WARN"; hr
S3="$TR/s3"; L3="$(run_gardener "$S3" "$DRIFT" GARDEN_IDENTITY_OVERRIDE="$DRIFT")"
if grep -q "WARN identity" "$L3"; then
  bad "a recorded env override should silence the WARN"
else
  ok "GARDEN_IDENTITY_OVERRIDE matching GARDEN silences the WARN"
fi
grep -q "RECORDED deliberate override" "$L3" \
  && ok "the deliberate-override path is logged (still visible, just not a WARN)" \
  || bad "expected a RECORDED deliberate override log line"

# ============================================================================
hr; echo "SUBTEST 4 — divergence + \$GARDEN_STATE/identity-override file: no WARN"; hr
S4="$TR/s4"; mkdir -p "$S4"; printf '%s\n' "$DRIFT" > "$S4/identity-override"
L4="$(run_gardener "$S4" "$DRIFT")"
if grep -q "WARN identity" "$L4"; then
  bad "a recorded identity-override file should silence the WARN"
else
  ok "\$GARDEN_STATE/identity-override matching GARDEN silences the WARN"
fi

# ============================================================================
hr
echo "gardener-identity-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
