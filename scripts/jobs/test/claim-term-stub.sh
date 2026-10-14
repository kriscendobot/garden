#!/bin/bash
# claim-term-stub.sh — a GARDEN_CLAIM_JOB_CMD wrapper for claim-stop-race-test.sh.
# It SIGTERMs the gardener.sh that invoked it (the nearest ancestor running
# gardener.sh), as a systemd restart would mid-claim, then runs the real claim.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pid=$PPID
while [ -n "$pid" ] && [ "$pid" -gt 1 ]; do
  if ps -o args= -p "$pid" 2>/dev/null | grep -q 'gardener\.sh'; then
    kill -TERM "$pid"
    break
  fi
  pid="$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')"
done
exec "$HERE/../claim-job.sh" "$@"
