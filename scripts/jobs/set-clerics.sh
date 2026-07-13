#!/bin/bash
# set-clerics.sh — declare a host's concurrent cleric count in the journal.
#
# Usage: set-clerics.sh <N> [host]   (host defaults to this host)
#
# The cleric analogue of set-gardeners.sh: a thin wrapper over the generic
# set-workers.sh, which writes the `clerics: N` line in hosts/<host> and preserves
# the sibling `gardeners:` line. The gardener-scaler on that host reconciles the
# local cleric pool (garden-cleric@1..N) to match. Recommended initial sizing is
# `clerics: 4` on the leader host (design §1.2) — enough to accrue reputation data
# without materially competing for board throughput.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$HERE/set-workers.sh" cleric "$@"
