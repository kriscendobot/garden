#!/bin/bash
# set-gardeners.sh — declare a host's concurrent gardener count in the journal.
#
# Usage: set-gardeners.sh <N> [host]   (the optional host must be this host)
#
# Back-compat wrapper: the per-host count is now per worker KIND (gardeners: /
# clerics: in hosts/<host>), written by the generic set-workers.sh, which preserves
# the sibling kind's line. This wrapper keeps the historical `set-gardeners.sh <N>`
# entry point working for every caller, doc, and operator muscle-memory that predates
# the cleric. Gardeners have a floor of one on every active host; use
# `drain-fleet.sh` to pause work instead of setting the pool to zero.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$HERE/set-workers.sh" gardener "$@"
