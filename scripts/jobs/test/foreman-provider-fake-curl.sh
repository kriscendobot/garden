#!/bin/bash
# Deterministic Ollama reachability stand-in for foreman-provider-order-test.sh.
set -euo pipefail
[ -n "${GARDEN_TEST_PROVIDER_LOG:-}" ] && printf '%s\n' local-preflight >> "$GARDEN_TEST_PROVIDER_LOG"
[ "${GARDEN_TEST_LOCAL_CURL_RC:-0}" -eq 0 ] || exit "${GARDEN_TEST_LOCAL_CURL_RC}"
models_json="${GARDEN_TEST_LOCAL_MODELS_JSON:-}"
[ -n "$models_json" ] || models_json='{"object":"list","data":[{"id":"qwen3:0.6b"}]}'
printf '%b' "$models_json"
