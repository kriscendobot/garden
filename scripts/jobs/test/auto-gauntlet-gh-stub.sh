#!/bin/bash
set -euo pipefail
if [ "${1:-}" = pr ] && [ "${2:-}" = view ]; then
  printf '%s\n' "${FAKE_PR_JSON:?}"
  exit 0
fi
exit 64
