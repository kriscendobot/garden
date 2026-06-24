#!/bin/bash
# B-gateway — fires on repo-root-config changes (tsconfig, eslint, root package.json, CI workflows, etc.).
set -uo pipefail
BASE=${BASE:-origin/master}
files=$(git diff --name-only "$BASE...HEAD" 2>/dev/null)

hit=$(echo "$files" | grep -E '^(tsconfig[^/]*\.json|\.eslintrc[^/]*|eslint\.config\.[^/]+|package\.json|yarn\.lock|package-lock\.json|\.prettierrc[^/]*|\.editorconfig|\.gitattributes)$|^\.github/workflows/[^/]+\.yml$|^packages/tsconfig-base[^/]*\.json$' | head -1 || true)
if [ -n "$hit" ]; then
  echo "fire gateway $hit"
  exit 0
fi

echo "skip gateway"
