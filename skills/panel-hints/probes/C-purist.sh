#!/bin/bash
# C-purist — fires on intrinsic-shaping signals (freeze, defineProperty enumerable, Remotable, M. patterns).
set -uo pipefail
BASE=${BASE:-origin/master}
PATTERN='defineProperty\([^)]*enumerable|Object\.freeze\(|\bharden\b|\bpassStyleOf\b|\bRemotable\w*\b'
hit=$(git diff "$BASE...HEAD" -U0 2>/dev/null | grep -E '^\+[^+]' | grep -oE "$PATTERN" | head -1 || true)
if [ -n "$hit" ]; then
  echo "fire purist matched: $hit"
  exit 0
fi
echo "skip purist"
