#!/bin/bash
# set-mystics.sh: declare a host's hosted Kimi Code CLI worker count.
#
# Usage: set-mystics.sh <N> [host]
#
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Mystic is explicit-model-only in claim eligibility. Operators may scale it for
# a bounded canary, but must return it to zero unless a maintainer authorizes a
# larger trial; the count remains the immediate reversible kill switch.
exec "$HERE/set-workers.sh" mystic "$@"
