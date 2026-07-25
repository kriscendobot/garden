#!/bin/bash
# set-fireworkers.sh: declare a host's explicit Fireworks worker count.
#
# Usage: set-fireworkers.sh <N> [host]
# Fireworker workers are disabled by default.  They accept only explicit
# `model: fireworks/<wire-model-or-deployment-id>` jobs.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$HERE/set-workers.sh" fireworker "$@"
