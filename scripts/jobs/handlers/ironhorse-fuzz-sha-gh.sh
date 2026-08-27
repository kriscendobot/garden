#!/bin/bash
# ironhorse-fuzz-sha-gh.sh — default PROJECT-SHA seam for ironhorse-fuzz.sh.
#
# Echoes the git SHA of the pinned project checkout currently under fuzz, for finding
# provenance. Empty output (the service falls back to "unknown") on any failure.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"

: "${GARDEN_IRONHORSE_FUZZ_STATE:=$GARDEN_STATE/ironhorse-fuzz}"
: "${GARDEN_IRONHORSE_FUZZ_PROJECT_DIR:=$GARDEN_IRONHORSE_FUZZ_STATE/project}"

git -C "$GARDEN_IRONHORSE_FUZZ_PROJECT_DIR" rev-parse HEAD 2>/dev/null || true
