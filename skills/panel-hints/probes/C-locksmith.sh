#!/bin/bash
# C-locksmith — fires on capability-flow signals (attenuate, Far, E, Exo, makeCapTP).
set -uo pipefail
BASE=${BASE:-origin/master}
PATTERN='\battenuate\w*\b|\bendowments?\b|\bFar\(|\bpassStyleOf\b|\bmakeCapTP\b|\bExo(Class)?\b|\bgrant\w*\b'
hit=$(git diff "$BASE...HEAD" -U0 2>/dev/null | grep -E '^\+[^+]' | grep -oE "$PATTERN" | head -1 || true)
if [ -n "$hit" ]; then
  echo "fire locksmith matched: $hit"
  exit 0
fi
echo "skip locksmith"
