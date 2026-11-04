#!/bin/bash
# check-mechanic-role.sh — deterministic mechanic role/skill/schedule contract.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
SCHEDULE_DIR="${1:-$ROOT/journal/schedules}"
ROLE="$ROOT/roles/mechanic/AGENT.md"
SKILL="$ROOT/skills/host-repair/SKILL.md"
fail=0

bad() { printf 'FAIL: %s\n' "$*" >&2; fail=1; }

[ -f "$ROLE" ] || bad "mechanic role is missing"
[ -f "$SKILL" ] || bad "host-repair skill is missing"

# shellcheck source=scripts/jobs/common.sh
source "$HERE/common.sh"
[ "$(role_tier_floor mechanic)" = mentor ] \
  || bad "mechanic is not registered at the mentor tier floor"
grep -qF '[host-repair](../../skills/host-repair/SKILL.md)' "$ROLE" \
  || bad "mechanic role does not reference host-repair"

expected_ops="$(printf '%s\n' \
  'reset-failed|unattested' \
  'refresh-budget-snapshot|unattested' \
  'restore|unattested' \
  'drain|unattested' \
  'set-workers|unattested' \
  'unit|maintainer-attestation' \
  'deploy|maintainer-attestation' \
  'local-model|maintainer-attestation' \
  'maintain|maintainer-attestation')"
actual_ops="$(sed -n '/<!-- mechanic-operation-map:start -->/,/<!-- mechanic-operation-map:end -->/p' "$SKILL" \
  | grep -E '^[a-z-]+\|(unattested|maintainer-attestation)$' || true)"
[ "$actual_ops" = "$expected_ops" ] \
  || bad "host-repair operation map does not exactly match the sysop vocabulary and attestation wall"

check_schedule() {
  local name="$1" require_host="$2" mode="$3" evidence="$4" file body expected
  file="$SCHEDULE_DIR/$name.md"
  [ -f "$file" ] || { bad "missing schedule $name"; return; }
  grep -qx 'cadence: 3h' "$file" || bad "$name cadence changed"
  grep -qx "job_basename_prefix: $name" "$file" || bad "$name prefix changed"
  grep -qx 'handler-timeout: 3600' "$file" || bad "$name recurrence handler budget changed"
  body="$(sed '1,/^---$/d' "$file")"
  expected="$(printf '%s\n' \
    '---' \
    'role: mechanic' \
    "requires: host=$require_host" \
    'handler-timeout: 3600' \
    'tier: mentor' \
    'fallback-tier: minion' \
    'dispatch: automatic' \
    '---' \
    '' \
    'role_brief: [roles/mechanic/AGENT.md](roles/mechanic/AGENT.md)' \
    'target_host: oros-studio-garden-ce242c49' \
    "trigger: schedule/$name" \
    "mode: $mode" \
    "evidence: $evidence" \
    'recurrence_budget: 15 minutes')"
  [ "$body" = "$expected" ] \
    || bad "$name is not the thin mechanic dispatch (or carries independent repair policy)"
}

check_schedule oros-health-checkup oros-studio-garden-ce242c49 local \
  'inspect locally, append one standard host-health record, and exit early for an active roll release or drain'
check_schedule oros-health-watch endolin-garden-ece02cb4 controller \
  'confirm this cycle local run completed, then use the host-repair diagnosis order and operation ladder'

[ "$fail" -eq 0 ] || exit 1
printf 'mechanic role contract: ok\n'
