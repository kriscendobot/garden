#!/bin/bash
# A manual Codex deadline is repaired from provider rollout telemetry before the
# leveler freezes on its 0.95 fallback. Missing, expired, and malformed readings
# remain fail-open and share the existing edge-latched fallback alert.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-codex-reset-ingest.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
BARE="$TR/journal.git"; SEED="$TR/seed"; STATE="$TR/state"; LOGS="$TR/codex/sessions"
git init -q --bare "$BARE"
git init -q "$SEED"; git -C "$SEED" checkout -qb journal2
git -C "$SEED" config user.name test; git -C "$SEED" config user.email test@example.invalid
mkdir -p "$SEED/config" "$SEED/budget/reset-events" "$SEED/hosts" "$LOGS"
printf 'codex-test\topenai\tpercent\t95\tfixture\t2026-11-11\n' >"$SEED/config/budget-pools"
printf 'codex-test\tleader\tcleric\n' >"$SEED/config/subscription-mapping"
printf 'monk-fleet-ceiling\t1\ncleric-fleet-ceiling\t1\nhost\tleader\t1\t1\n' >"$SEED/config/worker-leveling"
printf 'monks: 0\nclerics: 0\n' >"$SEED/hosts/leader"
printf '%s\n' \
  '{"subscription_id":"codex-test","event_type":"manual-reset","cadence":"manual","reset_at":"2026-11-01T00:00:00Z","reset_at_precision":"exact","recorded_at":"2026-11-01T00:00:00Z","timezone":"UTC"}' \
  '{"subscription_id":"codex-test","event_type":"expected-next-scheduled","cadence":"observed","reset_at":"2026-11-10T00:00:00Z","reset_at_precision":"scheduled","recorded_at":"2026-11-01T00:01:00Z","timezone":"UTC"}' \
  >"$SEED/budget/reset-events/codex-test.jsonl"
git -C "$SEED" add -A; git -C "$SEED" commit -qm seed
git -C "$SEED" remote add origin "$BARE"; git -C "$SEED" push -qu origin journal2

NOW="$(date -u -d '2026-11-11T18:00:00Z' +%s)"
run_level() {
  env GARDEN_TEST=1 GARDEN=leader GARDEN_LEADER=leader JOURNAL_REMOTE="$BARE" \
    GARDEN_STATE="$STATE" GARDEN_NO_MAINTAINER_ALERT=1 GARDEN_USAGE_NOW="$NOW" \
    GARDEN_CODEX_LOGDIR="$LOGS" "$JOBS/budget-level.sh"
}
fail() { echo "FAIL: $*" >&2; exit 1; }

# No telemetry: fallback remains, but the edge warning appears only once.
{ run_level; run_level; } >"$TR/absent.out" 2>&1
[ "$(grep -c 'token backoff for codex-test is on the 0.95 fallback' "$TR/absent.out")" -eq 1 ] \
  || fail "absent telemetry did not produce one coalesced fallback warning"

# The newest provider row is decisive. A non-numeric deadline cannot be
# laundered through date parsing or replaced by an older usable row.
ROLLOUT="$LOGS/rollout.jsonl"
printf '%s\n' \
  '{"timestamp":"2026-11-11T17:00:00Z","type":"event_msg","payload":{"type":"token_count","rate_limits":{"primary":{"resets_at":1794506400}}}}' \
  '{"timestamp":"2026-11-11T17:30:00Z","type":"event_msg","payload":{"type":"token_count","rate_limits":{"primary":{"resets_at":"tomorrow"}}}}' >"$ROLLOUT"
run_level >"$TR/malformed.out" 2>&1
git -C "$SEED" pull -q --rebase
[ "$(wc -l <"$SEED/budget/reset-events/codex-test.jsonl")" -eq 2 ] \
  || fail "malformed freshest telemetry was appended"

# A syntactically valid but elapsed provider deadline is not a future plan.
printf '%s\n' \
  '{"timestamp":"2026-11-11T17:40:00Z","type":"event_msg","payload":{"type":"token_count","rate_limits":{"primary":{"resets_at":1794416400}}}}' >"$ROLLOUT"
run_level >"$TR/expired.out" 2>&1
git -C "$SEED" pull -q --rebase
[ "$(wc -l <"$SEED/budget/reset-events/codex-test.jsonl")" -eq 2 ] \
  || fail "expired telemetry was appended"

# A refreshed future deadline is recorded through append-reset-event.sh and the
# ramp is re-read in the same tick, clearing rather than emitting the freeze.
FUTURE=$((NOW + 7200)); FUTURE_ISO="$(date -u -d "@$FUTURE" +%FT%TZ)"
printf '{"timestamp":"2026-11-11T17:50:00Z","type":"event_msg","payload":{"type":"token_count","rate_limits":{"primary":{"resets_at":%s}}}}\n' "$FUTURE" >"$ROLLOUT"
run_level >"$TR/refreshed.out" 2>&1
git -C "$SEED" pull -q --rebase
jq -e --arg at "$FUTURE_ISO" --arg key "codex-primary-reset-$FUTURE" \
  'select(.event_type=="expected-next-scheduled" and .reset_at==$at and .reset_at_precision=="scheduled" and .detector_key==$key)' \
  "$SEED/budget/reset-events/codex-test.jsonl" >/dev/null \
  || fail "future Codex provider deadline was not durably appended: $(tail -n 2 "$SEED/budget/reset-events/codex-test.jsonl" | tr '\n' ';') log=$(tr '\n' ';' <"$TR/refreshed.out")"
grep -q "ingested Codex provider reset deadline for codex-test" "$TR/refreshed.out" \
  || fail "successful telemetry ingestion was not reported"
! grep -q 'is on the 0.95 fallback' "$TR/refreshed.out" \
  || fail "repaired tick still emitted the fallback warning"

echo "PASS: budget-level ingests refreshed Codex deadlines and coalesces absent, expired, or malformed telemetry fallback"
