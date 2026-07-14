#!/bin/bash
# Deterministic Ollama reachability stand-in for foreman-provider-order-test.sh.
set -euo pipefail
[ -n "${GARDEN_TEST_PROVIDER_LOG:-}" ] && printf '%s\n' local-preflight >> "$GARDEN_TEST_PROVIDER_LOG"
exit "${GARDEN_TEST_LOCAL_CURL_RC:-0}"
