#!/bin/bash
# set-monks.sh — declare a host's concurrent monk count in the journal.
#
# Usage: set-monks.sh <N> [host]   (the optional host must be this host)
#
# The Anthropic analogue of set-clerics.sh: a thin wrapper over the generic
# set-workers.sh, which writes the `monks: N` line in hosts/<host> and preserves
# every sibling count line. Monk is the sole Anthropic worker kind; the
# gardener-scaler on that host reconciles the local garden-monk@ pool.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$HERE/set-workers.sh" monk "$@"
