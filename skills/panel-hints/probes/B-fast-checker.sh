#!/bin/bash
# B-fast-checker — fires on test-file touches; also when fast-check is already a devDep.
set -uo pipefail
BASE=${BASE:-origin/master}
files=$(git diff --name-only "$BASE...HEAD" 2>/dev/null)

hit=$(echo "$files" | grep -E '/test/|/__tests__/|\.test\.(js|ts|mjs)$|\.spec\.(js|ts|mjs)$|/tests/' | head -1 || true)
if [ -n "$hit" ]; then
  echo "fire fast-checker $hit"
  exit 0
fi

# fast-check present anywhere in the tree's package.json devDependencies.
if grep -rqE '"fast-check"\s*:' --include='package.json' . 2>/dev/null; then
  echo "fire fast-checker fast-check already in devDeps (codebase signal)"
  exit 0
fi

echo "skip fast-checker"
