#!/bin/bash
# set-gardeners.sh — declare a host's concurrent gardener count in the journal.
#
# Usage: set-gardeners.sh <N> [host]   (host defaults to this host)
#
# Back-compat wrapper: the per-host count is now per worker KIND (gardeners: /
# clerics: in hosts/<host>), written by the generic set-workers.sh, which preserves
# the sibling kind's line. This wrapper keeps the historical `set-gardeners.sh <N>`
# entry point working for every caller, doc, and operator muscle-memory that predates
# the cleric — it is exactly `set-workers.sh gardener <N> [host]`.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$HERE/set-workers.sh" gardener "$@"
