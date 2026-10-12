#!/bin/bash
# Fixture for auto-gauntlet-handoff-test.sh's temporary-unavailable paths.
set -euo pipefail
printf 'fixture freshness diagnostic rc=%s\n' "${GARDEN_STUB_FRESHNESS_RC:?}" >&2
exit "$GARDEN_STUB_FRESHNESS_RC"
