#!/bin/bash
# The rendered worker unit's systemd SIGKILL deadline must not undercut the
# largest handler wall one claim can hold, its TERM-to-KILL grace, and a bounded
# five-minute margin.
set -uo pipefail

HERE=$(cd "$(dirname "$0")" && pwd)
ROOT=$(cd "$HERE/../.." && pwd)
TEMPLATE="$ROOT/scripts/systemd/garden-worker@.service.in"
GARDENER="$ROOT/scripts/jobs/gardener.sh"

TR=$(mktemp -d "${TMPDIR:-/tmp}/garden-worker-stop-timeout.XXXXXX")
trap 'rm -rf "$TR"' EXIT
rendered="$TR/garden-monk@.service"
sed -e "s#@GARDEN_ROOT@#$ROOT#g" -e 's#@WORKER_KIND@#monk#g' \
  "$TEMPLATE" > "$rendered"

# shellcheck disable=SC2016  # parameter syntax is matched literally in gardener.sh
claim_ttl=$(sed -n 's/^: "${GARDEN_CLAIM_TTL:=\([0-9][0-9]*\)}"$/\1/p' "$GARDENER")
# shellcheck disable=SC2016  # parameter syntax is matched literally in gardener.sh
kill_after=$(sed -n 's/^: "${GARDEN_HANDLER_KILL_AFTER:=\([0-9][0-9]*\)}"$/\1/p' "$GARDENER")
stop_timeout=$(sed -n 's/^TimeoutStopSec=\([0-9][0-9]*\)$/\1/p' "$rendered")

if ! [[ "$claim_ttl" =~ ^[0-9]+$ && "$kill_after" =~ ^[0-9]+$ && "$stop_timeout" =~ ^[0-9]+$ ]]; then
  echo "FAIL: could not read numeric shipped bounds from gardener.sh and rendered unit"
  exit 1
fi

maximum_handler_wall=$(( claim_ttl - kill_after - 1 ))
minimum_stop_timeout=$(( maximum_handler_wall + kill_after + 300 ))
if [ "$stop_timeout" -lt "$minimum_stop_timeout" ]; then
  echo "FAIL: rendered TimeoutStopSec=${stop_timeout}s undercuts ${maximum_handler_wall}s handler wall + ${kill_after}s kill grace + 300s margin"
  exit 1
fi

echo "PASS: rendered TimeoutStopSec=${stop_timeout}s covers ${maximum_handler_wall}s handler wall + ${kill_after}s kill grace + 300s margin"
