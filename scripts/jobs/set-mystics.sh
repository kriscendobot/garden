#!/bin/bash
# set-mystics.sh: declare a host's hosted Kimi Code CLI worker count.
#
# Usage: set-mystics.sh <N> [host]
#
# Mystic is explicit-model-only: it can claim only `model: kimi-k3` jobs and has
# no role default. This command is intentionally never invoked by installation or
# routing code, so landing the harness leaves the pool disabled at zero capacity.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$HERE/set-workers.sh" mystic "$@"
