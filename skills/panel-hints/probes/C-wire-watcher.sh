#!/bin/bash
# C-wire-watcher — fires on wire-protocol / hash / parser / vat-identifier signals.
set -uo pipefail
BASE=${BASE:-origin/master}
PATTERN='\bsha(256|512)?\b|\bdigest\b|\bJSON\.parse\(|\bretire(Imports|Exports)?\b|\bsyscall\.|\bvref\b|\bkref\b|^\+.*\bv[0-9]+-|\bo[+-][0-9]+\b|\bb1-'
hit=$(git diff "$BASE...HEAD" -U0 2>/dev/null | grep -E '^\+[^+]' | grep -oE "$PATTERN" | head -1 || true)
if [ -n "$hit" ]; then
  echo "fire wire-watcher matched: $hit"
  exit 0
fi
echo "skip wire-watcher"
