#!/bin/bash
# Deterministic Claude stand-in for foreman-provider-order-test.sh.
set -euo pipefail
[ -n "${GARDEN_TEST_PROVIDER_LOG:-}" ] && printf '%s\n' anthropic >> "$GARDEN_TEST_PROVIDER_LOG"
for arg in "$@"; do
  if [ "$arg" = --output-format ]; then
    printf '%s\n' '{"result":"JOB anthropic-step\nanthropic fallback body\nENDJOB","usage":{"input_tokens":1,"output_tokens":1,"cache_creation_input_tokens":0}}'
    exit "${GARDEN_TEST_ANTHROPIC_RC:-0}"
  fi
done
printf 'JOB anthropic-step\nanthropic fallback body\nENDJOB\n'
exit "${GARDEN_TEST_ANTHROPIC_RC:-0}"
