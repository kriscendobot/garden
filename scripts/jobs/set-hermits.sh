#!/bin/bash
# set-hermits.sh — RETIRED. Declare a host's concurrent hermit (local codex-cleric)
# count — now pinned to 0.
#
# Usage: set-hermits.sh <N> [host]   (the optional host must be this host)
#
# RETIRED LANE (2026-09-13 maintainer decision, job retire-local-qwen-hermit-lane).
# The local-qwen `hermit` lane is dropped — accepted at `hermits: 0`. A NONZERO count
# is refused here so the journal never records a misleading hermit pool; the scaler
# additionally clamps hermit to 0 (install-units.sh scale()), so even a stale count
# arms nothing. `set-hermits.sh 0` is still allowed for idempotent withdrawal.
#
# Historical: the local-inference analogue of set-clerics.sh — a thin wrapper over the
# generic set-workers.sh, which writes the `hermits: N` line in hosts/<host>. A hermit
# was a codex worker pointed at the on-box Ollama /v1 endpoint (provider: local).
set -euo pipefail
n="${1:-}"
if [ "$n" != 0 ]; then
  echo "set-hermits.sh: the local-qwen hermit lane is RETIRED (2026-09-13); count is pinned to 0." >&2
  echo "  Only 'set-hermits.sh 0 [host]' is accepted (idempotent withdrawal). Requested: '${n:-<none>}'." >&2
  exit 1
fi
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$HERE/set-workers.sh" hermit "$@"
