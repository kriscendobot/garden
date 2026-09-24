#!/bin/bash
# C-procurer — fires on any added line in a changed JS/TS source file. A broad
# trigger on purpose: the procurer seat cost-gates itself
# (seat-gate-procurer.sh spends nothing when the build-vs-buy detector finds no
# local copy of an indexed export).
set -uo pipefail
BASE=${BASE:-origin/master}
file=$(git diff "$BASE...HEAD" --name-only --diff-filter=d 2>/dev/null \
  | grep -E '\.(c|m)?jsx?$|\.tsx?$' | grep -vE '\.d\.(c|m)?ts$|(^|/)(node_modules|dist)/' \
  | while IFS= read -r f; do
      git diff "$BASE...HEAD" -U0 -- "$f" 2>/dev/null | grep -qE '^\+[^+]' && { echo "$f"; break; }
    done)
if [ -n "$file" ]; then
  echo "fire procurer matched: $file"
  exit 0
fi
echo "skip procurer"
