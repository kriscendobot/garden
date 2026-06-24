#!/bin/bash
# X-copyeditor — design-panel seat that cross-fires on any code PR with substantial markdown.
# Same trigger as X-pedant; the two seats overlap on prose mechanics vs formal style.
set -uo pipefail
BASE=${BASE:-origin/master}
files=$(git diff --name-only "$BASE...HEAD" 2>/dev/null | grep -E '\.md$' | grep -v '^designs/' || true)

for f in $files; do
  added=$(git diff "$BASE...HEAD" -U0 -- "$f" 2>/dev/null | grep -cE '^\+[^+]' || true)
  if [ "$added" -gt 30 ]; then
    echo "fire copyeditor $f (+$added lines outside designs/)"
    exit 0
  fi
done

echo "skip copyeditor"
