#!/bin/bash
# C-spec-keeper — fires on ECMA-262 / engine-variance signals (Reflect, primordials, polyfills).
set -uo pipefail
BASE=${BASE:-origin/master}
PATTERN='Reflect\.(apply|construct|ownKeys|deleteProperty)|\.call\(|\.apply\(|Number\.(MAX_SAFE_INTEGER|EPSILON|MIN_SAFE_INTEGER)|Symbol\.(iterator|asyncIterator|toPrimitive)|tc39\.es|webidl\.spec|polyfill|\bshim\b'
hit=$(git diff "$BASE...HEAD" -U0 2>/dev/null | grep -E '^\+[^+]' | grep -oE "$PATTERN" | head -1 || true)
if [ -n "$hit" ]; then
  echo "fire spec-keeper matched: $hit"
  exit 0
fi
echo "skip spec-keeper"
