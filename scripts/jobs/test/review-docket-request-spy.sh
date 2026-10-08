#!/bin/bash
set -euo pipefail
: "${GARDEN_DOCKET_SPY_LOG:?GARDEN_DOCKET_SPY_LOG is required}"
printf '%q ' "$@" >> "$GARDEN_DOCKET_SPY_LOG"
printf '\n' >> "$GARDEN_DOCKET_SPY_LOG"
