#!/bin/bash
# C-duality-auditor - fires when added identifiers suggest directional counterparts.
set -uo pipefail
BASE=${BASE:-origin/master}
PATTERN='\b(encode|decode|serialize|deserialize|marshal|unmarshal|wrap|unwrap|freeze|thaw|externalize|internalize|parse|format|to|from)[A-Z][[:alnum:]_$]*\b'
hit=$(git diff "$BASE...HEAD" -U0 2>/dev/null \
  | grep -E '^\+[^+]' \
  | grep -oE "$PATTERN" \
  | head -1 || true)
if [ -n "$hit" ]; then
  echo "fire duality-auditor matched directional identifier: $hit"
  exit 0
fi
echo "skip duality-auditor"
