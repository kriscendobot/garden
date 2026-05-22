#!/bin/bash
# B-curator — fires when package.json exports/main/types, index.*, or .d.ts change.
set -uo pipefail
BASE=${BASE:-origin/master}
files=$(git diff --name-only "$BASE...HEAD" 2>/dev/null)

# package.json exports field change (modified package.json with exports key in the diff).
if echo "$files" | grep -qE '/package\.json$|^package\.json$'; then
  if git diff "$BASE...HEAD" -U0 -- '**/package.json' 'package.json' 2>/dev/null \
     | grep -qE '^\+.*"(exports|main|module|types)"\s*:'; then
    pj=$(echo "$files" | grep -E '/package\.json$|^package\.json$' | head -1)
    echo "fire curator $pj (exports/main/types field)"
    exit 0
  fi
fi

# index.* or .d.ts touched.
hit=$(echo "$files" | grep -E '(^|/)index\.(js|ts|mjs|cjs)$|\.d\.ts$' | head -1 || true)
if [ -n "$hit" ]; then
  echo "fire curator $hit"
  exit 0
fi

echo "skip curator"
