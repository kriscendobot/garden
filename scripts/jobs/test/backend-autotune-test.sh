#!/bin/bash
# backend-autotune-test.sh — the backend-verified provisioning + auth auto-tune.
#
# Covers designs/gnome-backend-verified-autotune.md:
#   1. claude_auth_ok           — the ONE new probe (software + credential PRESENCE).
#   2. worker_backend_probe     — anthropic dispatch + the GARDEN_BACKEND_PROBE_CMD seam.
#   3. backend_effective_count  — the ramp-up/ramp-down hysteresis, the gardener
#      floor living on DECLARED (effective may be 0), no-journal-write, transition
#      logging, and the sustained-degradation alert.
#   4. set-workers declare-gate — a non-gardener kind is refused until its probe
#      passes; allowed after it passes / under GARDEN_FORCE_DECLARE=1; gardener exempt.
#
# The probe is driven deterministically through the GARDEN_BACKEND_PROBE_CMD seam
# (a stub that reads a control file), so the effective-count and gate logic are
# exercised with NO real backend and NO tokens.
#
# Usage: backend-autotune-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1 GARDEN=testhost
# shellcheck source=../common.sh
source "$JOBS/common.sh"

# $TMPDIR (/tmp) is mounted noexec in the container, but this test EXECUTES probe
# stubs (GARDEN_BACKEND_PROBE_CMD is exec'd directly), so root the scratch tree in
# $HOME (exec-capable), mirroring run-test.sh's /home/…/.garden-test convention.
TD="$(mktemp -d "$HOME/.garden-test-backend.XXXXXX")"
trap 'rm -rf "$TD"' EXIT
export GARDEN_STATE="$TD/state"
export GARDEN_NO_MAINTAINER_ALERT=0

# A deterministic probe stub controlled by a per-kind control file: "pass" -> exit 0,
# anything else -> a diagnostic on stderr + exit 1.
STUB="$TD/probe-stub.sh"
cat > "$STUB" <<'EOF'
#!/bin/bash
kind="${1:?kind}"
ctl="${PROBE_CTL:-/dev/null}"
if [ "$(cat "$ctl" 2>/dev/null)" = pass ]; then exit 0; fi
echo "stub: $kind backend unavailable" >&2
exit 1
EOF
chmod +x "$STUB"
CTL="$TD/probe-ctl"; echo pass > "$CTL"

# ============================================================================
hr; echo "1. claude_auth_ok — software + credential PRESENCE"; hr
BIN="$TD/bin"; mkdir -p "$BIN"; printf '#!/bin/bash\nexit 0\n' > "$BIN/claude"; chmod +x "$BIN/claude"
CFG="$TD/claude-config"; mkdir -p "$CFG"

# claude absent from PATH → fail (empty PATH but keep coreutils via absolute calls in fn)
( PATH="/nonexistent" CLAUDE_CONFIG_DIR="$CFG" ANTHROPIC_API_KEY="" claude_auth_ok ) 2>/dev/null \
  && bad "claude_auth_ok passed with no claude on PATH" \
  || ok "no claude on PATH → fail"

# claude present + ANTHROPIC_API_KEY set → pass (no credential file needed)
( PATH="$BIN:$PATH" CLAUDE_CONFIG_DIR="$CFG" ANTHROPIC_API_KEY="sk-test" claude_auth_ok ) 2>/dev/null \
  && ok "claude on PATH + ANTHROPIC_API_KEY → pass" \
  || bad "api-key path did not pass"

# claude present + no key + credential file present (non-empty) → pass
printf '{"claudeAiOauth":{"expiresAt":1}}' > "$CFG/.credentials.json"
( PATH="$BIN:$PATH" CLAUDE_CONFIG_DIR="$CFG" ANTHROPIC_API_KEY="" claude_auth_ok ) 2>/dev/null \
  && ok "claude on PATH + OAuth credential file → pass (presence, not freshness)" \
  || bad "credential-file path did not pass"

# claude present + no key + credential file ABSENT → fail (the human-logout loss)
rm -f "$CFG/.credentials.json"
( PATH="$BIN:$PATH" CLAUDE_CONFIG_DIR="$CFG" ANTHROPIC_API_KEY="" claude_auth_ok ) 2>/dev/null \
  && bad "claude_auth_ok passed with neither key nor credential" \
  || ok "no key and no credential file → fail (logout is caught)"

# ============================================================================
hr; echo "2. worker_backend_probe — anthropic dispatch + override seam"; hr
# Real anthropic dispatch routes through claude_auth_ok.
( PATH="$BIN:$PATH" CLAUDE_CONFIG_DIR="$CFG" ANTHROPIC_API_KEY="sk-test" worker_backend_probe gardener ) 2>/dev/null \
  && ok "worker_backend_probe gardener → pass when Claude is authed" \
  || bad "gardener probe failed when authed"
( PATH="$BIN:$PATH" CLAUDE_CONFIG_DIR="$CFG" ANTHROPIC_API_KEY="" worker_backend_probe gardener ) 2>/dev/null \
  && bad "gardener probe passed when Claude is unauthed" \
  || ok "worker_backend_probe gardener → fail when Claude is unauthed"
# Unknown kind → fail with a diagnostic.
worker_backend_probe nonesuch 2>/dev/null \
  && bad "unknown kind probed as pass" \
  || ok "unknown kind → fail"
# The GARDEN_BACKEND_PROBE_CMD seam short-circuits the whole probe.
echo pass > "$CTL"; GARDEN_BACKEND_PROBE_CMD="$STUB" PROBE_CTL="$CTL" worker_backend_probe cleric \
  && ok "probe seam pass honored" || bad "probe seam pass not honored"
echo fail > "$CTL"; GARDEN_BACKEND_PROBE_CMD="$STUB" PROBE_CTL="$CTL" worker_backend_probe cleric 2>/dev/null \
  && bad "probe seam fail not honored" || ok "probe seam fail honored"

# ============================================================================
hr; echo "3. backend_effective_count — hysteresis (RAMP_UP=1, RAMP_DOWN=2)"; hr
# Drive the probe via the stub seam and a control file. GARDEN_STATE is per-kind
# namespaced, so use a distinct kind's state for clarity — cleric here.
eff() { # eff <declared> -> effective (probe result from $CTL)
  GARDEN_BACKEND_PROBE_CMD="$STUB" PROBE_CTL="$CTL" \
    backend_effective_count cleric "$1" 2>/dev/null
}
rm -rf "$GARDEN_STATE/clerics/backend"

# Cold start: no record → seed 0, first PASS confirms up to declared (RAMP_UP_CONFIRM=1).
echo pass > "$CTL"
[ "$(eff 5)" = 5 ] && ok "cold start + first PASS → effective = declared (5)" || bad "cold-start ramp-up ($(eff 5))"
# Still passing → stays at declared.
[ "$(eff 5)" = 5 ] && ok "sustained PASS → holds at declared" || bad "sustained pass drifted"

# First FAIL → HOLD (RAMP_DOWN_CONFIRM=2 not yet met); still declared.
echo fail > "$CTL"
[ "$(eff 5)" = 5 ] && ok "one FAIL → hold at declared (no single-blip teardown)" || bad "single fail tore down ($(eff 5))"
# Second consecutive FAIL → drop to 0.
[ "$(eff 5)" = 0 ] && ok "two consecutive FAILs → effective 0 (ramp down)" || bad "double fail did not drop to 0"
# Still failing → stays 0.
[ "$(eff 5)" = 0 ] && ok "sustained FAIL → holds at 0" || bad "sustained fail drifted off 0"

# Recovery: one PASS ramps straight back to declared.
echo pass > "$CTL"
[ "$(eff 5)" = 5 ] && ok "recovery: one PASS → back to declared (5)" || bad "recovery ramp-up failed"

# A single transient blip inside a passing run must NOT drop the pool.
[ "$(eff 5)" = 5 ] && : # settle at declared
echo fail > "$CTL"; b1="$(eff 5)"           # 1 fail → hold
echo pass > "$CTL"; b2="$(eff 5)"           # pass resets the fail streak
{ [ "$b1" = 5 ] && [ "$b2" = 5 ]; } && ok "isolated blip absorbed (fail then pass never hit ramp-down)" || bad "blip not absorbed ($b1,$b2)"

# ============================================================================
hr; echo "3b. gardener floor lives on DECLARED — effective may be 0"; hr
# backend_effective_count applies NO gardener floor: a failed Claude probe yields
# effective 0 even for gardener with declared >= 1 (the scaler floors DECLARED, not
# this value). § 5.
rm -rf "$GARDEN_STATE/gardeners/backend"
echo fail > "$CTL"
GARDEN_BACKEND_PROBE_CMD="$STUB" PROBE_CTL="$CTL" backend_effective_count gardener 1 >/dev/null 2>&1
g="$(GARDEN_BACKEND_PROBE_CMD="$STUB" PROBE_CTL="$CTL" backend_effective_count gardener 1 2>/dev/null)"
[ "$g" = 0 ] && ok "gardener declared 1 + failing probe → effective 0 (floor is on declared, not effective)" || bad "gardener effective not 0 ($g)"

# ============================================================================
hr; echo "3c. no journal write; transition logged; degradation alert deduped"; hr
# The function writes ONLY under $GARDEN_STATE/<ns>/backend/ — never the journal.
rm -rf "$GARDEN_STATE/clerics/backend"
echo pass > "$CTL"
logline="$(GARDEN_BACKEND_PROBE_CMD="$STUB" PROBE_CTL="$CTL" backend_effective_count cleric 4 2>&1 1>/dev/null)"
grep -q 'auto-tune cleric: effective 0->4' <<<"$logline" && ok "effective transition logged (0->4)" || bad "transition not logged: $logline"
[ -f "$GARDEN_STATE/clerics/backend/state" ] && ok "runtime record written under GARDEN_STATE (not the journal)" || bad "no runtime record written"
# A hold logs at DEBUG, not as a transition.
hold="$(GARDEN_BACKEND_PROBE_CMD="$STUB" PROBE_CTL="$CTL" backend_effective_count cleric 4 2>&1 1>/dev/null)"
grep -q 'DEBUG auto-tune cleric: hold effective 4' <<<"$hold" && ok "a hold is a quiet DEBUG (no spurious transition)" || bad "hold not DEBUG: $hold"

# Sustained degradation raises ONE deduped alert after GARDEN_BACKEND_DEGRADED_TICKS.
rm -rf "$GARDEN_STATE/clerics/backend" "$GARDEN_STATE/alerts"
export GARDEN_ALERT_CMD="$TD/alert.sh" GARDEN_ALERT_LOG="$TD/alerts.log"; : > "$GARDEN_ALERT_LOG"
cat > "$TD/alert.sh" <<'EOF'
#!/bin/bash
printf '%s\n' "$1" >> "$GARDEN_ALERT_LOG"
EOF
chmod +x "$TD/alert.sh"
echo fail > "$CTL"
for _ in 1 2 3 4; do
  GARDEN_RAMP_DOWN_CONFIRM=1 GARDEN_BACKEND_DEGRADED_TICKS=3 \
  GARDEN_BACKEND_PROBE_CMD="$STUB" PROBE_CTL="$CTL" \
    backend_effective_count cleric 2 >/dev/null 2>&1
done
nalerts="$(grep -c 'backend-degraded-testhost-cleric' "$GARDEN_ALERT_LOG" 2>/dev/null || true)"
[ "${nalerts:-0}" -eq 1 ] && ok "sustained degradation raises exactly ONE deduped alert" || bad "degradation alert count=$nalerts (want 1)"
# Recovery clears the alert episode (dedup key resets).
echo pass > "$CTL"
GARDEN_BACKEND_PROBE_CMD="$STUB" PROBE_CTL="$CTL" backend_effective_count cleric 2 >/dev/null 2>&1
[ ! -f "$GARDEN_STATE/alerts/backend-degraded-testhost-cleric.last" ] \
  && ok "recovery clears the degradation alert marker" || bad "alert marker not cleared on recovery"
unset GARDEN_ALERT_CMD GARDEN_ALERT_LOG

# ============================================================================
hr; echo "3d. clear-on-zero — a class throttled to zero RETIRES the notice"; hr
# The degraded notice is CORRECT while declared>0 and the backend is down. But
# when the class is stood DOWN to declared=0 there is nothing left to run, so the
# outstanding notice must CLEAR (a recorded resolution) rather than fall silent-
# but-outstanding — the $degraded reset stops the alert branch firing, and the
# recovery clear (gated eff>=declared with declared>0) can never retire it either,
# so the notice would sit forever. Regression for the clear-on-zero fix, on the
# worker-kind abstraction (mystic here; fireworker is only the motivating case).
export GARDEN_ALERT_CMD="$TD/alert3d.sh" GARDEN_ALERT_LOG="$TD/alerts3d.log"; : > "$GARDEN_ALERT_LOG"
cat > "$TD/alert3d.sh" <<'EOF'
#!/bin/bash
# key then message on one line. A clear prefixes its message with "RECOVERED:".
printf '%s %s\n' "$1" "$2" >> "$GARDEN_ALERT_LOG"
EOF
chmod +x "$TD/alert3d.sh"
akey='backend-degraded-testhost-mystic'
z() { # z <declared> — one auto-tune tick, ramp-down and degraded threshold at 1.
  GARDEN_RAMP_DOWN_CONFIRM=1 GARDEN_BACKEND_DEGRADED_TICKS=1 \
  GARDEN_BACKEND_PROBE_CMD="$STUB" PROBE_CTL="$CTL" \
    backend_effective_count mystic "$1" >/dev/null 2>&1
}

# Case 1: declared>0, backend failing, ticks exceeded → alert fires (unchanged).
rm -rf "$GARDEN_STATE/mystics/backend" "$GARDEN_STATE/alerts"; : > "$GARDEN_ALERT_LOG"
echo fail > "$CTL"; z 2
grep -qF "host testhost declares mystics=2" "$GARDEN_ALERT_LOG" \
  && ok "case 1: declared>0 + backend down → alert fires" || bad "case 1: alert did not fire"
[ -f "$GARDEN_STATE/alerts/$akey.last" ] && ok "case 1: alert marker outstanding" || bad "case 1: no marker"

# Case 2: declared>0, backend recovers → clear fires, recovery wording (unchanged).
: > "$GARDEN_ALERT_LOG"; echo pass > "$CTL"; z 2
grep -qF "RECOVERED: mystic backend on testhost recovered" "$GARDEN_ALERT_LOG" \
  && ok "case 2: backend recovers → clear fires (recovery wording)" || bad "case 2: recovery clear did not fire"
[ ! -f "$GARDEN_STATE/alerts/$akey.last" ] && ok "case 2: marker cleared on recovery" || bad "case 2: marker not cleared"

# Case 3 (THE BUG): declared drops to 0 with an alert outstanding → clear fires,
# stand-down wording (distinct from recovery). Goes RED without the fix.
rm -rf "$GARDEN_STATE/mystics/backend" "$GARDEN_STATE/alerts"; : > "$GARDEN_ALERT_LOG"
echo fail > "$CTL"; z 2                        # raise the alert (declared 2, down)
[ -f "$GARDEN_STATE/alerts/$akey.last" ] || bad "case 3 setup: alert not raised"
: > "$GARDEN_ALERT_LOG"; z 0                    # stand the class down to zero
grep -qF "RECOVERED: mystic on testhost stood down to mystics=0" "$GARDEN_ALERT_LOG" \
  && ok "case 3: declared→0 with alert outstanding → clear fires (stand-down wording)" \
  || bad "case 3: clear-on-zero did NOT fire (the bug)"
grep -qiF "recovered" "$GARDEN_ALERT_LOG" && ! grep -qF "backend on testhost recovered" "$GARDEN_ALERT_LOG" \
  && ok "case 3: wording is stand-down, NOT a backend recovery (facts not conflated)" \
  || bad "case 3: wording conflated stand-down with recovery"
[ ! -f "$GARDEN_STATE/alerts/$akey.last" ] && ok "case 3: marker retired after stand-down" || bad "case 3: marker still outstanding"

# Case 4: declared==0 with nothing outstanding → no alert, no spurious clear.
rm -rf "$GARDEN_STATE/mystics/backend" "$GARDEN_STATE/alerts"; : > "$GARDEN_ALERT_LOG"
echo fail > "$CTL"; z 0
[ ! -s "$GARDEN_ALERT_LOG" ] \
  && ok "case 4: declared==0, nothing outstanding → no alert, no spurious clear" \
  || bad "case 4: spurious inbox activity: $(cat "$GARDEN_ALERT_LOG")"
unset GARDEN_ALERT_CMD GARDEN_ALERT_LOG

# ============================================================================
hr; echo "4. set-workers declare-gate"; hr
# Stand up a throwaway journal so the ALLOW path fully succeeds (a push).
BARE="$TD/journal.git"; git init -q --bare "$BARE"
SEED="$TD/seed"; git init -q "$SEED"; git -C "$SEED" checkout -q -b journal2
( cd "$SEED"; mkdir -p hosts; touch hosts/.gitkeep )
git -C "$SEED" -c user.name=t -c user.email=t@l add -A
git -C "$SEED" -c user.name=t -c user.email=t@l commit -q -m seed
git -C "$SEED" push -q "$BARE" journal2
export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2
export GARDEN_PRODUCER_CLONE="$TD/producer/journal"

sw() { GARDEN_BACKEND_PROBE_CMD="$STUB" PROBE_CTL="$CTL" "$JOBS/set-workers.sh" "$@"; }

# Non-gardener declare > 0 REFUSED when the probe fails.
echo fail > "$CTL"
set +e; out="$(sw cleric 3 2>&1)"; rc=$?; set -e
{ [ "$rc" -ne 0 ] && grep -q 'backend probe failed' <<<"$out"; } \
  && ok "cleric declare > 0 refused when probe fails" || bad "declare-gate did not refuse (rc=$rc): $out"

# Same declare ALLOWED once the probe passes.
echo pass > "$CTL"
set +e; out="$(sw cleric 3 2>&1)"; rc=$?; set -e
[ "$rc" -eq 0 ] && ok "cleric declare allowed after probe passes" || bad "declare not allowed on pass (rc=$rc): $out"
# ...and it actually wrote the journal line.
V="$TD/verify"; git clone -q --single-branch --branch journal2 "$BARE" "$V"
grep -q '^clerics: 3$' "$V/hosts/testhost" && ok "clerics: 3 written to the journal after gate passed" || bad "clerics line not written"
rm -rf "$V"

# GARDEN_FORCE_DECLARE=1 stages a declaration AHEAD of a credential (probe failing).
echo fail > "$CTL"
set +e; out="$(GARDEN_FORCE_DECLARE=1 sw cleric 5 2>&1)"; rc=$?; set -e
[ "$rc" -eq 0 ] && ok "GARDEN_FORCE_DECLARE=1 stages a declaration despite a failing probe" || bad "force-declare refused (rc=$rc): $out"

# Gardener is EXEMPT from the declare-gate (probe failing, still allowed).
echo fail > "$CTL"
set +e; out="$(sw gardener 2 2>&1)"; rc=$?; set -e
[ "$rc" -eq 0 ] && ok "gardener declare NOT gated by the probe (baseline kind, exempt)" || bad "gardener wrongly gated (rc=$rc): $out"
# Withdrawal (n=0) is always allowed regardless of probe.
echo fail > "$CTL"
set +e; out="$(sw cleric 0 2>&1)"; rc=$?; set -e
[ "$rc" -eq 0 ] && ok "cleric 0 (withdrawal) allowed regardless of probe" || bad "withdrawal refused (rc=$rc): $out"

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
