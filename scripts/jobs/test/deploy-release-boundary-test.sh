#!/bin/bash
# deploy-release-boundary-test.sh — direct coverage for the coherent-release
# boundary helpers (deploy-release-boundary.sh): freeze_timers / thaw_timers /
# verify_coherent_release. The deploy-garden suite exercises them end-to-end; this
# suite hits the edge cases integration cannot reach with the armed-set mock — a
# stop that fails (boundary not established), a thaw straggler, and a verify miss.
#
# Hermetic: a tiny inline unit_ctl stub backed by an "active set" file models
# systemctl is-active / list-units / stop / start, so freeze→thaw→verify can be
# driven deterministically without real systemd.
#
# Usage: deploy-release-boundary-test.sh
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-release-boundary-test
rm -rf "$TR"; mkdir -p "$TR"
ACTIVE="$TR/active"       # one active unit per line
FAILSTOP="$TR/failstop"   # units whose `stop` returns non-zero
: > "$ACTIVE"; : > "$FAILSTOP"

# Inline stub for `systemctl --user`. Models the verbs the boundary lib uses.
STUB="$TR/unit_ctl.sh"
cat > "$STUB" <<'STUBEOF'
#!/bin/bash
ACTIVE="${STUB_ACTIVE:?}"; FAILSTOP="${STUB_FAILSTOP:?}"
cmd="${1:-}"; shift || true
unit_of() { for a in "$@"; do case "$a" in *.service|*.timer|*@*) printf '%s' "$a"; return;; esac; done; }
case "$cmd" in
  list-units)
    pat=""; for a in "$@"; do case "$a" in --*) ;; *) pat="$a";; esac; done
    while read -r u; do [ -n "$u" ] || continue; case "$u" in $pat) printf '%s active\n' "$u";; esac; done < "$ACTIVE" ;;
  is-active)
    u="$(unit_of "$@")"; if grep -qxF "$u" "$ACTIVE" 2>/dev/null; then echo active; else echo inactive; exit 3; fi ;;
  stop)
    u="$(unit_of "$@")"; if grep -qxF "$u" "$FAILSTOP" 2>/dev/null; then exit 1; fi
    grep -vxF "$u" "$ACTIVE" > "$ACTIVE.t" 2>/dev/null || true; mv "$ACTIVE.t" "$ACTIVE" ;;
  start)
    u="$(unit_of "$@")"; grep -qxF "$u" "$ACTIVE" 2>/dev/null || echo "$u" >> "$ACTIVE" ;;
  *) : ;;
esac
STUBEOF
chmod +x "$STUB"

export GARDEN_UNIT_CTL="$STUB" STUB_ACTIVE="$ACTIVE" STUB_FAILSTOP="$FAILSTOP" GARDEN_UNIT_CTL_TIMEOUT=3
# Silence log() output from the lib during the suite (it goes to stderr via common.sh).
export GARDEN_QUIET=1

# shellcheck source=../common.sh
source "$JOBS/common.sh" 2>/dev/null || source "$JOBS/common.sh"
# shellcheck source=../deploy-release-boundary.sh
source "$JOBS/deploy-release-boundary.sh"

reset_active() { printf '%s\n' "$@" > "$ACTIVE"; }

# ============================================================================
hr; echo "STATIC"; hr
bash -n "$JOBS/deploy-release-boundary.sh" && ok "deploy-release-boundary.sh parses" || bad "syntax error"

# ============================================================================
hr; echo "freeze_timers — no active timers is a trivial (established) boundary"; hr
: > "$FAILSTOP"; reset_active garden-gardener@1.service garden-bulletin.service
if freeze_timers >/dev/null 2>&1; then ok "returns 0 with no timers"; else bad "returned non-zero with no timers"; fi
[ "${#FROZEN_TIMERS[@]}" -eq 0 ] && ok "FROZEN_TIMERS empty when no timers" || bad "FROZEN_TIMERS not empty: ${FROZEN_TIMERS[*]}"

# ============================================================================
hr; echo "freeze_timers — stops every active timer and records the set"; hr
: > "$FAILSTOP"; reset_active garden-gardener@1.service garden-reaper.timer garden-scheduler.timer
freeze_timers >/dev/null 2>&1 && ok "returns 0 when every stop succeeds" || bad "returned non-zero"
[ "${#FROZEN_TIMERS[@]}" -eq 2 ] && ok "FROZEN_TIMERS holds both timers" || bad "FROZEN_TIMERS=${FROZEN_TIMERS[*]}"
grep -qxF garden-reaper.timer "$ACTIVE" && bad "reaper timer still active after freeze" || ok "reaper timer stopped"
grep -qxF garden-scheduler.timer "$ACTIVE" && bad "scheduler timer still active" || ok "scheduler timer stopped"
grep -qxF garden-gardener@1.service "$ACTIVE" && ok "the gardener service is left running (only timers freeze)" || bad "gardener was stopped"

# ============================================================================
hr; echo "freeze_timers — an unstoppable timer means the boundary is NOT established"; hr
printf '%s\n' garden-reaper.timer > "$FAILSTOP"    # its stop returns non-zero
reset_active garden-reaper.timer garden-scheduler.timer
if freeze_timers >/dev/null 2>&1; then bad "returned 0 despite a failed stop"; else ok "returns non-zero (boundary not established)"; fi
[ "${#FROZEN_TIMERS[@]}" -eq 2 ] && ok "FROZEN_TIMERS still records both (thaw restores what WAS stopped)" || bad "FROZEN_TIMERS=${FROZEN_TIMERS[*]}"

# ============================================================================
hr; echo "thaw_timers — restarts the frozen set, records it, clears FROZEN_TIMERS"; hr
: > "$FAILSTOP"; reset_active garden-gardener@1.service garden-reaper.timer garden-scheduler.timer
freeze_timers >/dev/null 2>&1
thaw_timers >/dev/null 2>&1 && ok "returns 0 when every start succeeds" || bad "thaw returned non-zero"
grep -qxF garden-reaper.timer "$ACTIVE" && ok "reaper timer active again after thaw" || bad "reaper not restarted"
grep -qxF garden-scheduler.timer "$ACTIVE" && ok "scheduler timer active again after thaw" || bad "scheduler not restarted"
[ "${#FROZEN_TIMERS[@]}" -eq 0 ] && ok "FROZEN_TIMERS cleared after thaw (trap belt no-ops)" || bad "FROZEN_TIMERS not cleared"
[ "${#THAWED_TIMERS[@]}" -eq 2 ] && ok "THAWED_TIMERS records the round-trip for verify" || bad "THAWED_TIMERS=${THAWED_TIMERS[*]}"

# ============================================================================
hr; echo "verify_coherent_release — all active + matching sha verifies clean"; hr
: > "$FAILSTOP"; reset_active garden-gardener@1.service garden-bulletin.service garden-reaper.timer
freeze_timers >/dev/null 2>&1; thaw_timers >/dev/null 2>&1   # reaper re-added; THAWED_TIMERS set
if verify_coherent_release deadbeef deadbeef >/dev/null 2>&1; then ok "verify passes when all units active and sha matches"; else bad "verify failed a coherent fleet"; fi

# ============================================================================
hr; echo "verify_coherent_release — a recorded-sha mismatch is a straggler"; hr
if verify_coherent_release deadbeef c0ffee >/dev/null 2>&1; then bad "verify passed on a sha mismatch"; else ok "verify fails when recorded sha != new sha"; fi

# ============================================================================
hr; echo "verify_coherent_release — an inactive thawed timer is a straggler"; hr
: > "$FAILSTOP"; reset_active garden-gardener@1.service garden-reaper.timer
freeze_timers >/dev/null 2>&1; thaw_timers >/dev/null 2>&1
# Simulate the thawed timer dying right after: remove it from the active set.
grep -vxF garden-reaper.timer "$ACTIVE" > "$ACTIVE.t"; mv "$ACTIVE.t" "$ACTIVE"
if verify_coherent_release deadbeef deadbeef >/dev/null 2>&1; then bad "verify passed with an inactive thawed timer"; else ok "verify fails when a thawed timer is not active"; fi

# ============================================================================
hr; echo "RESULT: $PASS passed, $FAIL failed"; hr
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
