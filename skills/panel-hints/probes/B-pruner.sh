#!/bin/bash
# B-pruner — fires when any .md file has >30 added lines.
set -uo pipefail
BASE=${BASE:-origin/master}
files=$(git diff --name-only "$BASE...HEAD" 2>/dev/null | grep -E '\.md$')

for f in $files; do
  added=$(git diff "$BASE...HEAD" -U0 -- "$f" 2>/dev/null | grep -cE '^\+[^+]' || true)
  if [ "$added" -gt 30 ]; then
    echo "fire pruner $f (+$added lines)"
    exit 0
  fi
done

echo "skip pruner"
