#!/bin/bash
# set-kimis.sh — declare a host's bounded hosted Kimi worker count.
#
# Usage: set-kimis.sh <N> [host]
#
# Kimi workers are Moonshot-backed Codex workers. They claim only explicit
# `model: kimi-k3` jobs, so scaling this pool does not make Kimi a default for
# design, build, or other ordinary work.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$HERE/set-workers.sh" kimi "$@"
