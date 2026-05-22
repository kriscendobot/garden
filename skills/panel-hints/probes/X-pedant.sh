#!/bin/bash
# X-pedant — design-panel seat that cross-fires on any code PR with substantial markdown changes
# outside designs/. The seat catches em-dash discipline, ASCII art, hyphenation, etc.
set -uo pipefail
BASE=${BASE:-origin/master}
files=$(git diff --name-only "$BASE...HEAD" 2>/dev/null | grep -E '\.md$' | grep -v '^designs/' || true)

for f in $files; do
  added=$(git diff "$BASE...HEAD" -U0 -- "$f" 2>/dev/null | grep -cE '^\+[^+]' || true)
  if [ "$added" -gt 30 ]; then
    echo "fire pedant $f (+$added lines outside designs/)"
    exit 0
  fi
done

echo "skip pedant"
