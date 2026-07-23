#!/bin/bash
# Deterministic Codex stand-in for foreman-provider-order-test.sh.
set -euo pipefail

if [ "${1:-}" = login ] && [ "${2:-}" = status ]; then
  exit "${GARDEN_TEST_CODEX_LOGIN_RC:-0}"
fi
[ "${1:-}" = exec ] || exit 2
shift
model=""; output=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    -m) model="${2:?model}"; shift 2 ;;
    --output-last-message) output="${2:?output}"; shift 2 ;;
    *) shift ;;
  esac
done
[ -n "$output" ] || exit 2
case "$model" in
  qwen*) provider=local; response="${GARDEN_TEST_LOCAL_OUTPUT:-}"; rc="${GARDEN_TEST_LOCAL_CODEX_RC:-0}" ;;
  *)     provider=openai; response="${GARDEN_TEST_OPENAI_OUTPUT:-}"; rc="${GARDEN_TEST_OPENAI_CODEX_RC:-0}" ;;
esac
[ -n "${GARDEN_TEST_PROVIDER_LOG:-}" ] && printf '%s\n' "$provider" >> "$GARDEN_TEST_PROVIDER_LOG"
[ "$rc" -eq 0 ] && printf '%b' "$response" > "$output"
exit "$rc"
