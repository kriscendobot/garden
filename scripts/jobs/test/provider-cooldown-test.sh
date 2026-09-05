#!/bin/bash
# provider-cooldown-test.sh — unit guard for the per-provider health cooldown and
# the exit-0 provider-outage classifier (common.sh).
#
# Motivation (the exit-0-provider-outage-routing directive): the density-triggered
# fleet brake only engages after GARDEN_FLEET_BRAKE_THRESHOLD failures pile up and is
# provider-blind, so a single provider that goes unavailable lets reap-now-requeued
# work (notably panel seats) re-land on the exhausted route and exit-0/fail again,
# cycle after cycle, before the brake ever trips. The fix:
#   (a) is_provider_outage_signature — classify an exit-0/transient DETERMINISTICALLY
#       from captured provider quota/usage/API signatures (outage vs. clean-but-
#       unfinished), and
#   (b) a BOUNDED per-provider health cooldown (start_provider_cooldown /
#       provider_cooldown_active / provider_cooldown_remaining) a worker publishes on
#       observing its provider unavailable and reads pre-claim to pause claiming.
# This test drives the pure helpers directly with a frozen clock
# (GARDEN_PROVIDER_COOLDOWN_NOW) so it needs no sleeps.
#
# Usage: provider-cooldown-test.sh
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener invoking this test cannot splice its
# own GARDEN_* state underneath the fixture (mirrors the sibling classifier tests).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR="$(mktemp -d "${TMPDIR:-/tmp}/provider-cooldown.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
export GARDEN_STATE="$TR/state"
export GARDEN_PROVIDER_COOLDOWN_DIR="$TR/state/provider-cooldown"
export GARDEN_PROVIDER_COOLDOWN_SECS=300
export GARDEN_PROVIDER_COOLDOWN_MAX_SECS=1800
export GARDEN_PROVIDER_COOLDOWN_NOW=1000000000

# shellcheck source=../common.sh
source "$JOBS/common.sh"

hr; echo "SUBTEST 1 — is_provider_outage_signature classifies capture text"; hr
if is_provider_outage_signature "You've hit your weekly limit · resets 4:10pm (UTC)"; then ok "weekly-cap text → outage"; else bad "weekly-cap text NOT classified outage"; fi
if is_provider_outage_signature "quota exceeded"; then ok "quota exceeded → outage"; else bad "quota exceeded NOT outage"; fi
if is_provider_outage_signature "API Error: 529 overloaded_error"; then ok "overload/5xx → outage"; else bad "overload text NOT outage"; fi
if is_provider_outage_signature "econnreset while streaming"; then ok "econnreset → outage"; else bad "econnreset NOT outage"; fi
if is_provider_outage_signature "the run did not reach a satisfying conclusion"; then bad "clean-but-unfinished MISclassified as outage"; else ok "clean-but-unfinished → NOT outage"; fi
if is_provider_outage_signature ""; then bad "empty text MISclassified as outage"; else ok "empty text → NOT outage (fail-open)"; fi

hr; echo "SUBTEST 2 — publishing a cooldown makes the route active with bounded remaining"; hr
if provider_cooldown_active anthropic; then bad "anthropic active before any publish"; else ok "anthropic not active initially"; fi
if start_provider_cooldown anthropic "exit0-provider-outage:panel-x" ""; then ok "start_provider_cooldown opened a fresh window (rc 0)"; else bad "start_provider_cooldown did not open a window"; fi
if provider_cooldown_active anthropic; then ok "anthropic now in cooldown"; else bad "anthropic NOT active after publish"; fi
rem="$(provider_cooldown_remaining anthropic)"
[ "$rem" = 300 ] && ok "remaining = default window (300s)" || bad "remaining='$rem' expected 300"

hr; echo "SUBTEST 3 — an observer NEVER extends a live window"; hr
GARDEN_PROVIDER_COOLDOWN_NOW=$(( 1000000000 + 100 )); export GARDEN_PROVIDER_COOLDOWN_NOW
if start_provider_cooldown anthropic "second-observer" ""; then bad "second start EXTENDED a live window (rc 0)"; else ok "second start declined (rc 1) — live window not extended"; fi
rem="$(provider_cooldown_remaining anthropic)"
[ "$rem" = 200 ] && ok "remaining decayed to 200s (300 − 100 elapsed), NOT reset" || bad "remaining='$rem' expected 200 (window was extended?)"

hr; echo "SUBTEST 4 — the window is BOUNDED: a reset-aligned request is capped"; hr
# A far-future reset (10h out) must be clamped to GARDEN_PROVIDER_COOLDOWN_MAX_SECS.
if start_provider_cooldown openai "huge-reset" 36000; then ok "openai window opened"; else bad "openai window not opened"; fi
rem="$(provider_cooldown_remaining openai)"
[ "$rem" = 1800 ] && ok "36000s request clamped to cap 1800s (bounded blackout)" || bad "remaining='$rem' expected 1800 (cap not applied)"

hr; echo "SUBTEST 5 — per-provider isolation"; hr
if provider_cooldown_active openai; then ok "openai in cooldown"; else bad "openai not active"; fi
# moonshot was never published → must be free even while anthropic/openai cool down.
if provider_cooldown_active moonshot; then bad "moonshot in cooldown without a publish (not isolated)"; else ok "moonshot free — cooldown is per-provider"; fi

hr; echo "SUBTEST 6 — a window EXPIRES and the marker is removed (bounded)"; hr
GARDEN_PROVIDER_COOLDOWN_NOW=$(( 1000000000 + 300 + 1 )); export GARDEN_PROVIDER_COOLDOWN_NOW
if provider_cooldown_active anthropic; then bad "anthropic still active past expiry"; else ok "anthropic released after its window"; fi
[ -e "$GARDEN_PROVIDER_COOLDOWN_DIR/anthropic" ] && bad "expired anthropic marker not removed" || ok "expired marker removed on read"
# A fresh publish after expiry opens a new window (rc 0 again).
if start_provider_cooldown anthropic "post-expiry" ""; then ok "re-publish after expiry opens a fresh window" || true; else bad "could not re-publish after expiry"; fi

hr; echo "SUBTEST 7 — SECS=0 DISABLES the cooldown (escape hatch, cadence-only)"; hr
GARDEN_PROVIDER_COOLDOWN_SECS=0
if start_provider_cooldown fireworks "disabled" ""; then bad "start opened a window with SECS=0"; else ok "SECS=0 → start is a no-op (rc 1)"; fi
if provider_cooldown_active fireworks; then bad "fireworks active with SECS=0 (should be disabled)"; else ok "SECS=0 → active reads false"; fi
GARDEN_PROVIDER_COOLDOWN_SECS=300

hr; echo "SUBTEST 8 — a non-integer requested window falls back to the default"; hr
if start_provider_cooldown local "bad-req" "notanumber"; then ok "local window opened with a bad request" || true; else bad "local window not opened"; fi
rem="$(provider_cooldown_remaining local)"
[ "$rem" = 300 ] && ok "non-integer request → default 300s" || bad "remaining='$rem' expected 300"

hr
echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
