#!/bin/bash
# set-monks.sh — declare a host's concurrent monk count in the journal.
#
# Usage: set-monks.sh <N> [host]   (the optional host must be this host)
#
# The Anthropic analogue of set-clerics.sh: a thin wrapper over the generic
# set-workers.sh, which writes the `monks: N` line in hosts/<host> and preserves
# every sibling count line. `monk` is the canonical Anthropic worker kind (design
# anthropic-worker-kind-monk.md); the gardener-scaler on that host reconciles the
# local monk pool (garden-monk@1..N) to match once the host has been cut over from
# the legacy garden-gardener@ pool. Before cutover a host still declares `gardeners:
# N` and set-gardeners.sh is the live writer; this command is what the per-host
# cutover uses to declare the monk count (retaining the legacy `gardeners:` mirror).
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$HERE/set-workers.sh" monk "$@"
