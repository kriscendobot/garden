#!/bin/bash
# Shared PATH-injected command mock for ollama-serve-backoff-test.sh.
set -euo pipefail
case "$(basename "$0")" in
  curl)
    echo "$*" >>"$OLLAMA_TEST_CTL/curl-calls"
    [ -f "$OLLAMA_TEST_CTL/endpoint-up" ] || exit 22
    if [ -f "$OLLAMA_TEST_CTL/endpoint-empty" ]; then
      printf '{"object":"list","data":[]}\n'
    else
      printf '{"object":"list","data":[{"id":"qwen3.6:latest"}]}\n'
    fi
    ;;
  ollama)
    echo "$*" >>"$OLLAMA_TEST_CTL/ollama-calls"
    if [ -n "${OLLAMA_TEST_SERVE_SLEEP:-}" ]; then
      sleep "$OLLAMA_TEST_SERVE_SLEEP"
    fi
    exit "${OLLAMA_TEST_SERVE_STATUS:-1}"
    ;;
  *)
    echo "unexpected mock command: $0" >&2
    exit 2
    ;;
esac
