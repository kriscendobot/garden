#!/bin/bash
# set-mystics.sh: declare a host's hosted Kimi Code CLI worker count.
#
# Usage: set-mystics.sh <N> [host]
#
# Moonshot Kimi K3 credits are exhausted. Keep this lane at zero until a future,
# explicit quota-posture change lands; rejecting a nonzero request prevents an
# accidental fleet action from reviving Kimi claims during this outage.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[ "${1:-}" = 0 ] || { printf '%s\n' 'mystic workers are disabled while Moonshot Kimi credits are exhausted; only 0 is allowed' >&2; exit 2; }
exec "$HERE/set-workers.sh" mystic "$@"
