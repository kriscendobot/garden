#!/bin/bash
# set-hermits.sh — declare a host's concurrent hermit (local codex-cleric) count.
#
# Usage: set-hermits.sh <N> [host]   (host defaults to this host)
#
# The local-inference analogue of set-clerics.sh: a thin wrapper over the generic
# set-workers.sh, which writes the `hermits: N` line in hosts/<host> and preserves
# the sibling `gardeners:` / `clerics:` lines. The gardener-scaler on that host
# reconciles the local hermit pool (garden-hermit@1..N) to match. A hermit is a codex
# worker pointed at the on-box Ollama /v1 endpoint (provider: local), so it costs
# near-zero per token (guide §5) — but it needs a running local endpoint and the GPU
# device-node group access the entrypoint grants. Size it only on a host that
# actually serves local inference; on a leader that shares one endpoint, a small
# count (e.g. 2) is enough to accrue reputation data (guide §4).
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$HERE/set-workers.sh" hermit "$@"
