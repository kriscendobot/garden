#!/bin/bash
set -euo pipefail
[ -z "${GARDEN_GH_CALL_LOG:-}" ] || printf '%s\n' "$*" >>"$GARDEN_GH_CALL_LOG"
if [ "${1:-}" = pr ] && [ "${2:-}" = view ]; then
  printf '{"url":"https://github.com/endojs/endo-but-for-bots/pull/301","isDraft":true,"state":"OPEN","title":"fix: post-panel delta","body":"","author":{"login":"kriscendobot"},"files":[],"headRefOid":"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"}\n'
  exit 0
fi
exit 64
