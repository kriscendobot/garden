#!/bin/bash
# C-warden — fires on SES/hardened-JS signals in added lines.
set -uo pipefail
BASE=${BASE:-origin/master}
PATTERN='\bharden\(|\bglobalThis\b|__proto__|Object\.(prototype|defineProperty)|from\s+["'"'"']ses["'"'"']|@endo/(init|lockdown|exo|pass-style)|\bProxy\b'
hit=$(git diff "$BASE...HEAD" -U0 2>/dev/null | grep -E '^\+[^+]' | grep -oE "$PATTERN" | head -1 || true)
if [ -n "$hit" ]; then
  echo "fire warden matched: $hit"
  exit 0
fi
echo "skip warden"
