#!/bin/bash
# set-kimis.sh: deprecated compatibility spelling for set-mystics.sh.
#
# Usage: set-kimis.sh <N> [host]
#
# Mystic workers use the official Kimi Code CLI. New operator procedures should
# use set-mystics.sh; this forwarding alias does not restore the retired `kimi`
# worker kind.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$HERE/set-mystics.sh" "$@"
