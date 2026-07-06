#!/bin/bash
# enable-services-test.sh — install-units.sh enable-services coverage + drift guard.
#
# Regression for the 2026-06-26 dormant-timers defect: several garden timers
# (foreman, deadmail, follow-up, proxy, mirror-closer) were installed but the
# hand-maintained enable list never enabled them, so the services never ran. The
# fix DERIVES the enable set from the units actually present, so a newly-added
# garden-*.timer / standalone garden-*.service is covered automatically. These
# checks assert the derived set, the documented exclusions (templates +
# monitoring-gated mention-watcher), the retired-unit cleanup, and the drift
# verify — all against a mocked `systemctl --user`, no real systemd required.
#
# Usage: enable-services-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
SRC="$ROOT/scripts/systemd"
INSTALL="$JOBS/install-units.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

TR=/home/kris/.garden-enable-test
rm -rf "$TR"; mkdir -p "$TR"

# Common mocked-systemctl env: the script's unit_ctl routes through this.
export GARDEN_ROOT="$ROOT"
export GARDEN_UNIT_CTL="$HERE/mock-systemctl.sh"
export GARDEN_MOCK_STATE="$TR/armed" GARDEN_MOCK_LOG="$TR/log"
reset_mock() { : > "$GARDEN_MOCK_STATE"; : > "$GARDEN_MOCK_LOG"; }

# Sandbox $DEST (~/.config/systemd/user) into the throwaway tree. prune_retired
# enumerates and `rm`s files under $DEST, so this MUST point at a sandbox or a
# test run would delete the host's real units. install-units.sh derives
# DEST="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user".
export XDG_CONFIG_HOME="$TR/config"
DEST="$XDG_CONFIG_HOME/systemd/user"
# Render the current SRC unit set into the sandbox DEST (what `install` produces),
# plus any extra ORPHAN basenames passed as args (units with no source in $SRC —
# the retired-unit case prune_retired must clean up).
populate_dest() {
  rm -rf "$DEST"; mkdir -p "$DEST"
  local f extra
  for f in "$SRC"/garden-*.service "$SRC"/garden-*.timer; do
    [ -e "$f" ] && cp "$f" "$DEST/$(basename "$f")"
  done
  for extra in "$@"; do : > "$DEST/$extra"; done
}

# ============================================================================
hr; echo "STATIC — the script parses (bash -n)"; hr
bash -n "$INSTALL" && ok "install-units.sh parses" || bad "install-units.sh has a syntax error"
bash -n "$HERE/mock-systemctl.sh" && ok "mock-systemctl.sh parses" || bad "mock-systemctl.sh has a syntax error"

# ============================================================================
hr; echo "ENABLE — derived set covers all intended timers + standalone services"; hr
reset_mock
populate_dest
"$INSTALL" enable-services >/dev/null 2>&1

# Build the EXPECTED set independently of the script: every non-template
# garden-*.timer with WantedBy=timers.target EXCEPT mention-watcher, plus every
# non-template garden-*.service that has NO sibling timer and declares [Install].
expected="$TR/expected"; : > "$expected"
for f in "$SRC"/garden-*.timer; do
  b="$(basename "$f")"; case "$b" in *@*) continue;; esac
  [ "$b" = garden-mention-watcher.timer ] && continue
  grep -q '^WantedBy=timers\.target' "$f" && echo "$b" >> "$expected"
done
for f in "$SRC"/garden-*.service; do
  b="$(basename "$f")"; case "$b" in *@*) continue;; esac
  [ "$b" = garden-mention-watcher.service ] && continue
  base="${b%.service}"; [ -e "$SRC/$base.timer" ] && continue
  grep -q '^WantedBy=' "$f" && echo "$b" >> "$expected"
done
sort -o "$expected" "$expected"
sort "$GARDEN_MOCK_STATE" > "$TR/armed.sorted"
if diff -q "$expected" "$TR/armed.sorted" >/dev/null; then
  ok "enabled set == derived intended set ($(wc -l <"$expected") units)"
else
  bad "enabled set differs from intended set:"; diff "$expected" "$TR/armed.sorted" | sed 's/^/      /'
fi

# Each of the formerly-dormant timers is now present.
for u in garden-foreman.timer garden-deadmail.timer garden-follow-up.timer \
         garden-proxy.timer garden-mirror-closer.timer; do
  grep -qxF "$u" "$GARDEN_MOCK_STATE" && ok "$u enabled (was dormant)" || bad "$u NOT enabled"
done
# Standalone continuous services are enabled as services (the bulletin migration
# case). The design-poller was retired 2026-06-26 (its unit no longer ships), so
# it is no longer asserted here.
for u in garden-bulletin.service; do
  grep -qxF "$u" "$GARDEN_MOCK_STATE" && ok "$u enabled (standalone service)" || bad "$u NOT enabled"
done

# ============================================================================
hr; echo "EXCLUDE — templates and the monitoring-gated watcher stay off"; hr
grep -q '@' "$GARDEN_MOCK_STATE" \
  && bad "a template unit (garden-*@) was enabled" || ok "no template unit enabled (per-instance only)"
grep -q mention-watcher "$GARDEN_MOCK_STATE" \
  && bad "garden-mention-watcher was auto-enabled (monitoring-gated)" \
  || ok "garden-mention-watcher NOT auto-enabled (left for maintainer to arm)"

# ============================================================================
hr; echo "RETIRE — a unit deleted from scripts/systemd/ is self-reconcilingly pruned"; hr
# The deterministic replacement for the hand-maintained RETIRED_UNITS list: an
# installed garden-* unit with NO source under $SRC is stopped, disabled, and its
# rendered file removed — no name needs listing. Regression for the 2026-06-27
# garden-deploy-sync crash loop (a retired unit lingered enabled on a deployed
# host until a reactive agent appended its name).
reset_mock
# DEST = full SRC set + three orphans whose source we no longer ship.
ORPHANS=(garden-deploy-sync.timer garden-deploy-sync.service garden-bulletin.timer)
populate_dest "${ORPHANS[@]}"
# Arm the orphans in the mock so a `disable --now` is observable in the log.
printf '%s\n' "${ORPHANS[@]}" >> "$GARDEN_MOCK_STATE"
"$INSTALL" enable-services >/dev/null 2>&1
for u in "${ORPHANS[@]}"; do
  if [ ! -e "$DEST/$u" ] && grep -q "disable --now $u" "$GARDEN_MOCK_LOG"; then
    ok "$u pruned (file removed + disabled) — no name in RETIRED_UNITS needed"
  else
    bad "$u NOT pruned (file present: $([ -e "$DEST/$u" ] && echo yes || echo no); disable logged: $(grep -q "disable --now $u" "$GARDEN_MOCK_LOG" && echo yes || echo no))"
  fi
done
# A unit that STILL has a source must survive the prune (no false-positive).
[ -e "$DEST/garden-foreman.timer" ] \
  && ok "garden-foreman.timer kept (source still ships)" || bad "garden-foreman.timer wrongly pruned"
# A template file must NEVER be pruned (its source IS the @.service/@.timer).
[ -e "$DEST/garden-gardener@.service" ] \
  && ok "garden-gardener@.service kept (template, never pruned)" || bad "template garden-gardener@.service wrongly pruned"
# The monitoring-gated, excluded unit must survive even though it ships a source.
[ -e "$DEST/garden-mention-watcher.service" ] \
  && ok "garden-mention-watcher.service kept (excluded + sourced)" || bad "garden-mention-watcher.service wrongly pruned"

# ============================================================================
hr; echo "VERIFY — drift check passes when enabled, fails when a unit drops"; hr
reset_mock
populate_dest
"$INSTALL" enable-services >/dev/null 2>&1
set +e
"$INSTALL" enable-services --verify >/dev/null 2>&1; vrc=$?
set -e
[ "$vrc" -eq 0 ] && ok "verify on a fully-enabled host reports no drift (rc=0)" || bad "verify false-positive (rc=$vrc)"
# Drop one intended unit → verify must flag it and exit non-zero.
grep -vxF 'garden-foreman.timer' "$GARDEN_MOCK_STATE" > "$GARDEN_MOCK_STATE.t"; mv "$GARDEN_MOCK_STATE.t" "$GARDEN_MOCK_STATE"
set +e
vout="$("$INSTALL" enable-services --verify 2>&1)"; vrc2=$?
set -e
{ [ "$vrc2" -ne 0 ] && grep -q 'DRIFT: garden-foreman.timer' <<<"$vout"; } \
  && ok "verify flags a dropped unit and exits non-zero (drift visible)" || bad "verify missed the drift (rc=$vrc2)"

# ============================================================================
hr; echo "SCALE — a mid-job extra is deferred (not SIGTERM'd), an idle one stopped"; hr
# Regression for the rc=143 transient-handler outage: scale-down used
# `disable --now` on EVERY higher-numbered gardener, SIGTERMing an in-flight
# `claude -p` mid-call. The fix gates the stop on the same busy marker
# deploy-sync.sh gates its restart on (gardener_busy, common.sh): a mid-job extra
# is left running and skipped, so a later 1-minute scaler tick stops it once idle —
# it stops between claims, never mid-job. The stop is also split into a cheap
# `disable` (symlink) + a non-blocking `stop --no-block` so it never blocks the loop.
reset_mock
SCALE_STATE="$TR/scale-state"; rm -rf "$SCALE_STATE"
# Arm three gardeners; mark @3 mid-job (busy), leave @2 idle.
printf '%s\n' garden-gardener@1.service garden-gardener@2.service garden-gardener@3.service > "$GARDEN_MOCK_STATE"
mkdir -p "$SCALE_STATE/gardeners/3"; : > "$SCALE_STATE/gardeners/3/busy"
sout="$(GARDEN_STATE="$SCALE_STATE" "$INSTALL" scale 1 2>&1)"
# @2 is idle and an extra → disabled (symlink) + stopped non-blockingly.
grep -q 'disable garden-gardener@2.service' "$GARDEN_MOCK_LOG" \
  && ok "idle extra gardener 2 disabled" || bad "idle extra gardener 2 NOT disabled"
grep -q 'stop --no-block garden-gardener@2.service' "$GARDEN_MOCK_LOG" \
  && ok "idle extra gardener 2 stopped non-blockingly (stop --no-block)" || bad "idle extra gardener 2 NOT stopped --no-block"
# @3 is mid-job → must NOT be stopped/disabled (no SIGTERM of an in-flight handler).
grep -Eq '(disable|stop --no-block) garden-gardener@3.service' "$GARDEN_MOCK_LOG" \
  && bad "busy gardener 3 was stopped/disabled (mid-job SIGTERM!)" || ok "busy gardener 3 deferred (not stopped)"
grep -q 'is mid-job; deferring its stop' <<<"$sout" \
  && ok "deferral logged for the busy extra" || bad "deferral not logged"
# @1 stays in the kept set; @3 still armed because its disable was deferred.
grep -qxF 'garden-gardener@1.service' "$GARDEN_MOCK_STATE" \
  && ok "kept gardener 1 still enabled" || bad "gardener 1 not kept"
grep -qxF 'garden-gardener@3.service' "$GARDEN_MOCK_STATE" \
  && ok "busy gardener 3 still armed (disable deferred to a later tick)" || bad "busy gardener 3 was disarmed mid-job"

# ============================================================================
hr; echo "SCALE-TIMEOUT — a hung per-unit stop is bounded, skipped, loop continues"; hr
# Regression for the 2026-07-02 scaler timeout AND the 2026-07-06 SIGKILL storm:
# blocking `--now`/`restart` calls over the ~100 gardener units each waited on a
# start/stop job (>5s on a busy user manager) and were SIGKILLed, so the pool never
# converged. The fix splits the cheap `disable` file op from a non-blocking
# `stop --no-block`, and keeps only that stop wrapped in a bounded `timeout`
# (unit_ctl_bounded) as a wedged-manager backstop; on a per-unit timeout it logs the
# skipped unit and continues to the next, so the pass always completes and a later
# tick retries the skipped one.
reset_mock
SCALE_TO="$TR/scale-timeout"; rm -rf "$SCALE_TO"
# Arm @1,@2,@3 all idle; make @2's stop hang. Scale to 1 → @2 and @3 are extras.
printf '%s\n' garden-gardener@1.service garden-gardener@2.service garden-gardener@3.service > "$GARDEN_MOCK_STATE"
set +e
tout="$(GARDEN_STATE="$SCALE_TO" GARDEN_UNIT_CTL_TIMEOUT=1 \
        GARDEN_MOCK_HANG_UNIT=garden-gardener@2.service \
        "$INSTALL" scale 1 2>&1)"; trc=$?
set -e
[ "$trc" -eq 0 ] && ok "scale returned success despite a hung per-unit stop (rc=0)" \
  || bad "scale did not complete cleanly past the hung unit (rc=$trc)"
grep -q 'exceeded 1s and was killed; skipping this unit' <<<"$tout" \
  && grep -q 'garden-gardener@2.service' <<<"$tout" \
  && ok "hung stop of @2 was bounded, killed, and logged as skipped" \
  || bad "no bounded-timeout skip line for the hung @2. out: $(grep -i 'scale' <<<"$tout" | head -3)"
grep -q 'scaled gardener pool to 1' <<<"$tout" \
  && ok "the scale pass ran to completion (final summary logged)" || bad "scale pass did not complete"
# The loop must have CONTINUED past the hung @2 and stopped the idle @3.
grep -q 'stop --no-block garden-gardener@3.service' "$GARDEN_MOCK_LOG" \
  && ok "loop continued past the hung @2 and stopped @3" || bad "@3 not reached after the hung @2 (loop stalled)"
# @2's cheap disable succeeds (unbounded); only its stop timed out, so a later tick
# retries the stop. The disable of @2 must have been issued before the hung stop.
grep -q 'disable garden-gardener@2.service' "$GARDEN_MOCK_LOG" \
  && ok "@2's cheap disable ran (only its non-blocking stop hit the bound)" || bad "@2's disable not issued"

hr; echo "RESULT: $PASS passed, $FAIL failed"; hr
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
