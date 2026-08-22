#!/bin/bash
# set-openrouters.sh: declare a host's explicit OpenRouter worker count.
#
# Usage: set-openrouters.sh <N> [host]
# OpenRouter workers are disabled by default.  They accept only explicit
# `model: openrouter/<wire-model-id>` jobs (or a `provider: openrouter` canary);
# no automatic/unpinned board job can reach them.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$HERE/set-workers.sh" openrouter "$@"
