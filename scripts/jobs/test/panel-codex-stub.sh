#!/bin/bash
# Codex CLI spy for panel-provider-runner-test.sh.
set -euo pipefail
printf '%s\n' "$*" >>"${PANEL_CODEX_CALLS:?}"
schema=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --output-schema) schema="$2"; shift 2 ;;
    *) shift ;;
  esac
done
prompt="$(cat)"
printf '%s\n' "$prompt" >>"${PANEL_CODEX_PROMPTS:?}"
if [ -n "$schema" ]; then
  cp "$schema" "${PANEL_CODEX_SCHEMA_COPY:?}"
  printf '%s\n' "${PANEL_CODEX_STRUCTURED_OUTPUT:-{\"disposition\":\"pass\"}}"
else
  printf '%s\n' '**Verdict:** approve'
  printf '%s\n' '**Findings:** none.'
fi
