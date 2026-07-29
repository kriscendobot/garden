#!/bin/bash
# set-gardeners.sh — declare a host's concurrent gardener count in the journal.
#
# Usage: set-gardeners.sh <N> [host]   (the optional host must be this host)
#
# Back-compat wrapper: the per-host count is now per worker KIND (gardeners: /
# clerics: in hosts/<host>), written by the generic set-workers.sh, which preserves
# the sibling kind's line. This wrapper keeps the historical `set-gardeners.sh <N>`
# entry point working for every caller, doc, and operator muscle-memory that predates
# the cleric. Gardeners accept zero only during the temporary quota route and
# only with another configured, probe-qualified non-Claude worker class; this
# preserves the fail-closed floor against zero qualified claimers.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$HERE/set-workers.sh" gardener "$@"
