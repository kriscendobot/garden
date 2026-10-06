#!/bin/bash
# Hermetic contract for the standing token-backoff ramp
# (designs/standing-token-backoff-ramp.md): per-subscription linear ramp
# computed when read, the configurable initial reserve, the 0.95 unresolved
# fallback, intervention overrides with an optional until gate, env precedence,
# passed planned resets, Claude (phase-preserving) and Codex (phase-shifting)
# manual resets, and per-pool admission verdicts.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/garden-token-backoff-ramp.XXXXXX")"
trap 'rm -rf "$TEST_ROOT"' EXIT
export GARDEN=endolin-garden-ece02cb4 GARDEN_STATE="$TEST_ROOT/state"
unset GARDEN_TOKEN_BACKOFF_FRACTION GARDEN_BUDGET_POOLS_FILE
# shellcheck source=../common.sh
source "$JOBS/common.sh"

fail=0
ok()  { printf 'ok   %s\n' "$1"; }
bad() { printf 'FAIL %s\n' "$1"; fail=1; }
at()  { date -u -d "$1" +%s; }
J="$TEST_ROOT/journal"
mkdir -p "$J/config" "$J/budget/reset-events"
printf '%s\n' \
  $'claude-endolin1\tanthropic\tweekly-tokens\t100\tfixture\t2026-09-20' \
  $'claude-endolin2\tanthropic\tweekly-tokens\t100\tfixture\t2026-09-20' \
  $'claude-oros\tanthropic\tweekly-tokens\t100\tfixture\t2026-09-20' \
  $'codex-endolin\topenai\tpercent\t95\tfixture\t2026-09-20' \
  $'codex-nofuture\topenai\tpercent\t95\tfixture\t2026-09-20' \
  > "$J/config/budget-pools"
printf '%s\n' \
  $'claude-endolin1\tendolin-garden-ece02cb4\tmonk' \
  $'claude-endolin2\tendolin-garden2-5bcdff64\tmonk' \
  $'claude-oros\toros-studio-garden-ce242c49\tmonk' \
  $'codex-endolin\tendolin-garden-ece02cb4\tcleric' \
  > "$J/config/subscription-mapping"

FRI='"event_type":"declared-schedule","cadence":"calendar","schedule_weekday":5,"schedule_time":"20:00","timezone":"America/Los_Angeles","reset_at_precision":"exact","reset_at":"2026-09-19T03:00:00Z"'
plan() { # <subscription> <reset_at> <recorded_at>
  printf '{"subscription_id":"%s","event_type":"expected-next-scheduled","cadence":"observed","reset_at":"%s","reset_at_precision":"scheduled","recorded_at":"%s","timezone":"UTC"}\n' "$1" "$2" "$3"
}
observed() { # <subscription> <cadence> <reset_at>
  printf '{"subscription_id":"%s","event_type":"manual-reset","cadence":"%s","reset_at":"%s","reset_at_precision":"exact","recorded_at":"%s","timezone":"UTC"}\n' "$1" "$2" "$3" "$3"
}
printf '{"subscription_id":"claude-endolin1",%s}\n' "$FRI" > "$J/budget/reset-events/claude-endolin1.jsonl"
{ printf '{"subscription_id":"claude-endolin2",%s}\n' "$FRI"
  plan claude-endolin2 2026-09-30T03:00:00Z 2026-09-27T00:00:00Z
} > "$J/budget/reset-events/claude-endolin2.jsonl"
printf '%s\n' '{"subscription_id":"claude-oros","event_type":"declared-schedule","cadence":"calendar","schedule_weekday":2,"schedule_time":"04:00","timezone":"America/Denver","reset_at_precision":"exact","reset_at":null}' \
  > "$J/budget/reset-events/claude-oros.jsonl"
{ observed codex-endolin manual 2026-09-20T05:00:00Z
  plan codex-endolin 2026-09-27T05:00:00Z 2026-09-20T05:01:00Z
  observed codex-endolin observed 2026-09-24T12:00:00Z
  plan codex-endolin 2026-10-01T12:00:00Z 2026-09-24T12:01:00Z
} > "$J/budget/reset-events/codex-endolin.jsonl"
{ observed codex-nofuture manual 2026-09-20T05:00:00Z
  plan codex-nofuture 2026-09-27T05:00:00Z 2026-09-20T05:01:00Z
  observed codex-nofuture observed 2026-09-24T12:00:00Z
} > "$J/budget/reset-events/codex-nofuture.jsonl"

field() { cut -f"$1"; }
frac_at() { token_backoff_fraction_for "$1" "$J" "$(at "$2")"; }
near() { awk -v a="$1" -v b="$2" -v e="${3:-0.0005}" 'BEGIN { d = a - b; if (d < 0) d = -d; exit !(d <= e) }'; }
expect() { # <label> <pool> <instant> <fraction> <source> [detail-substring]
  local out f s
  out="$(frac_at "$2" "$3" 2>&1)"; f="$(printf '%s\n' "$out" | tail -1 | field 1)"; s="$(printf '%s\n' "$out" | tail -1 | field 2)"
  if near "$f" "$4" && [ "$s" = "$5" ] && { [ -z "${6:-}" ] || [[ "$out" == *"$6"* ]]; }; then ok "$1 ($f $s)"
  else bad "$1: expected $4 $5 ${6:-}, got: $out"; fi
}

# Calendar pool (Friday 20:00 PT = 03:00Z): 2026-09-26T03:00Z -> 2026-10-03T03:00Z.
expect "calendar ramp at window start is the initial reserve" claude-endolin1 2026-09-26T03:00:00Z 0.50 ramp "(calendar)->2026-10-03T03:00Z(calendar)"
expect "calendar ramp at midpoint" claude-endolin1 2026-09-29T15:00:00Z 0.75 ramp
expect "calendar ramp just before the deadline is nearly 1" claude-endolin1 2026-10-03T02:59:00Z 0.9999 ramp

# A pending planned reset shortens the window: 09-26T03:00Z -> 09-30T03:00Z.
expect "pending planned reset shortens the window" claude-endolin2 2026-09-28T03:00:00Z 0.75 ramp "->2026-09-30T03:00Z(planned)"
# Once it passes with no observed reset, the ramp snaps back to the reserve.
expect "passed planned reset snaps back to the reserve" claude-endolin2 2026-09-30T04:00:00Z 0.5069 ramp "window=2026-09-30T03:00Z(planned-passed)->2026-10-03T03:00Z(calendar)"
# ...without moving the meter cutoff.
[ "$(subscription_window_start_epoch claude-endolin2 "$J" "$(at 2026-09-30T04:00:00Z)")" = "$(at 2026-09-26T03:00:00Z)" ] \
  && ok "passed planned reset leaves the meter cutoff alone" || bad "passed planned reset moved the meter cutoff"

# Claude manual reset PRESERVES phase: new start, same Friday deadline, and a plan
# recorded before the reset is superseded by it (neither deadline nor start).
cp "$J/budget/reset-events/claude-endolin1.jsonl" "$TEST_ROOT/e1.saved"
{ plan claude-endolin1 2026-10-01T03:00:00Z 2026-09-27T00:00:00Z
  observed claude-endolin1 observed 2026-09-29T15:00:00Z
} >> "$J/budget/reset-events/claude-endolin1.jsonl"
expect "Claude manual reset restarts at the reserve" claude-endolin1 2026-09-29T15:00:00Z 0.50 ramp "(observed)->2026-10-03T03:00Z(calendar)"
expect "Claude manual reset keeps the calendar deadline (phase preserved)" claude-endolin1 2026-10-01T09:00:00Z 0.75 ramp "window=2026-09-29T15:00Z(observed)->2026-10-03T03:00Z(calendar)"
cp "$TEST_ROOT/e1.saved" "$J/budget/reset-events/claude-endolin1.jsonl"

# Codex manual reset SHIFTS phase: the reset starts the window and only the next
# reset time supplied after it is the deadline; the pre-reset plan is stale.
expect "Codex manual reset shifts phase to the supplied next reset" codex-endolin 2026-09-27T12:00:00Z 0.7143 ramp "window=2026-09-24T12:00Z(observed)->2026-10-01T12:00Z(planned)"
expect "manual pool without a pending plan falls back to 0.95" codex-nofuture 2026-09-27T12:00:00Z 0.95 fallback "append-reset-event.sh codex-nofuture"
expect "manual pool whose plan passed with no new time falls back" codex-endolin 2026-10-01T13:00:00Z 0.95 fallback "unclear"

# Unknown window.
expect "pool with no reset facts falls back to 0.95" claude-unknown 2026-09-27T12:00:00Z 0.95 fallback "no reset facts"
out="$(token_backoff_fraction_for "" "$J" "$(at 2026-09-27T12:00:00Z)")"
[ "$(printf '%s' "$out" | field 2)" = fallback ] && ok "no pool resolved falls back" || bad "no pool: $out"

# Initial reserve: configurable, malformed warns and uses 0.50.
printf '0.30\n' > "$J/config/token-backoff-initial"
expect "configured initial reserve sets the start" claude-endolin1 2026-09-26T03:00:00Z 0.30 ramp "r0=0.30"
expect "configured initial reserve still reaches the midpoint linearly" claude-endolin1 2026-09-29T15:00:00Z 0.65 ramp
printf 'half\n' > "$J/config/token-backoff-initial"
out="$(frac_at claude-endolin1 2026-09-26T03:00:00Z 2>&1)"
{ [[ "$out" == *"WARN: invalid token backoff initial reserve"* ]] && near "$(printf '%s\n' "$out" | tail -1 | field 1)" 0.50; } \
  && ok "malformed initial reserve warns and uses 0.50" || bad "malformed initial reserve: $out"
rm -f "$J/config/token-backoff-initial"

# Intervention overrides.
printf '0.65\n' > "$J/config/token-backoff-fraction"
expect "bare override pins every pool indefinitely" claude-oros 2026-09-26T03:00:00Z 0.65 override indefinite
expect "bare override pins a manual pool too" codex-endolin 2026-09-27T12:00:00Z 0.65 override
printf 'fraction: 0.55\nuntil: 2026-09-27T00:00:00Z\n' > "$J/config/token-backoff-fraction"
expect "until-gated override holds before its instant" claude-oros 2026-09-26T23:59:00Z 0.55 override "until=2026-09-27T00:00:00Z"
expect "until-gated override is ignored at its instant" claude-endolin1 2026-09-27T00:00:00Z 0.5625 ramp
printf 'fraction: lots\n' > "$J/config/token-backoff-fraction"
out="$(frac_at claude-endolin1 2026-09-26T03:00:00Z 2>&1)"
{ [[ "$out" == *"WARN: invalid token backoff override"* ]] && [ "$(printf '%s\n' "$out" | tail -1 | field 2)" = ramp ]; } \
  && ok "malformed override warns and leaves the ramp in charge" || bad "malformed override: $out"

# Env precedence over an override.
printf '0.65\n' > "$J/config/token-backoff-fraction"
out="$(cd "$JOBS" && GARDEN_TOKEN_BACKOFF_FRACTION=0.91 bash -c 'source ./common.sh; token_backoff_fraction_for claude-oros "$1"' _ "$J")"
[ "$(printf '%s' "$out" | cut -f1-2)" = $'0.91\tenv' ] && ok "explicit environment beats the override" || bad "env precedence: $out"
rm -f "$J/config/token-backoff-fraction"

# resolve_token_backoff_fraction: the local host's Anthropic pool.
GARDEN_USAGE_NOW="$(at 2026-09-29T15:00:00Z)" resolve_token_backoff_fraction "$J"
{ near "$GARDEN_TOKEN_BACKOFF_FRACTION" 0.75 && [ "$GARDEN_TOKEN_BACKOFF_SOURCE" = ramp ] && [ "$GARDEN_TOKEN_BACKOFF_POOL" = claude-endolin1 ]; } \
  && ok "resolve sets the local host pool's fraction and source" \
  || bad "resolve: $GARDEN_TOKEN_BACKOFF_FRACTION $GARDEN_TOKEN_BACKOFF_SOURCE $GARDEN_TOKEN_BACKOFF_POOL"

# Re-sourcing after a resolve must not reclassify the computed value as an env pin.
# shellcheck source=../common.sh
source "$JOBS/common.sh"
[ "$(frac_at claude-endolin1 2026-09-26T03:00:00Z | field 2)" = ramp ] \
  && ok "re-sourcing common.sh keeps the ramp (no false env pin)" || bad "re-source turned the resolved value into an env pin"

# Two pools at different points in their windows give different verdicts for the
# same used percentage. Endolin is at its reset (0.50), oros (Tue 04:00 MT) is
# 89h into its week (~0.765).
subscription_used_percent() { printf '60\n'; }
export GARDEN_USAGE_NOW; GARDEN_USAGE_NOW="$(at 2026-09-26T03:00:00Z)"
e1="$(meter_quota_status claude-endolin1 "$J")"; oros="$(meter_quota_status claude-oros "$J")"
{ [ "$e1" = backoff ] && [ "$oros" = ok ]; } && ok "same 60% use: endolin1 backoff, oros ok" || bad "per-pool verdicts: endolin1=$e1 oros=$oros"
# A gated pin holds even though quota is available, until its instant only.
printf 'fraction: 0.55\nuntil: 2026-09-27T00:00:00Z\n' > "$J/config/token-backoff-fraction"
[ "$(meter_quota_status claude-oros "$J")" = backoff ] && ok "until-gated pin holds oros back while quota is available" || bad "pin did not hold"
GARDEN_USAGE_NOW="$(at 2026-09-27T00:00:00Z)"
[ "$(meter_quota_status claude-oros "$J")" = ok ] && ok "at the until instant the ramp resumes" || bad "pin outlived its until"
rm -f "$J/config/token-backoff-fraction"
unset -f subscription_used_percent

# Writers validate their arguments before touching any journal.
for args in "" "1.5" "0" "0.5 --clear" "--clear 0.5" "0.5 --until" "0.5 --until not-a-time" "0.5 --until 2000-01-01T00:00:00Z"; do
  # shellcheck disable=SC2086  # deliberate word splitting of the argument list
  if GARDEN_PRODUCER_CLONE=/nonexistent bash "$JOBS/set-token-backoff-fraction.sh" $args >/dev/null 2>&1; then
    bad "set-token-backoff-fraction.sh accepted '$args'"
  else ok "set-token-backoff-fraction.sh rejects '$args'"; fi
done
for args in "" "0" "1.2" "0.5 0.6"; do
  # shellcheck disable=SC2086
  if GARDEN_PRODUCER_CLONE=/nonexistent bash "$JOBS/set-token-backoff-initial.sh" $args >/dev/null 2>&1; then
    bad "set-token-backoff-initial.sh accepted '$args'"
  else ok "set-token-backoff-initial.sh rejects '$args'"; fi
done

[ "$fail" -eq 0 ] && echo "token-backoff-ramp: all passed" || { echo "token-backoff-ramp: FAILURES" >&2; exit 1; }
