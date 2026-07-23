#!/bin/bash
# set-kimis.sh — retired compatibility entry point for mystic Kimi workers.
#
# Usage: set-kimis.sh <N> [host]
#
# Kept for an operator who used the short-lived pre-deployment `kimi` name. New
# automation and documentation use set-mystics.sh / `mystics:`. The worker itself
# uses the official Kimi Code CLI, not Codex.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$HERE/set-workers.sh" mystic "$@"
