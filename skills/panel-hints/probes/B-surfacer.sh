#!/bin/bash
# B-surfacer — fires when >=2 of {package.json, index.*, .d.ts, README.md} change in one package,
# or a new package is added.
set -uo pipefail
BASE=${BASE:-origin/master}
files=$(git diff --name-only "$BASE...HEAD" 2>/dev/null)

# Count per-package touches across the four surface files.
declare -A surface_count
for f in $files; do
  case "$f" in
    packages/*/package.json|packages/*/index.js|packages/*/index.ts|packages/*/index.mjs|packages/*/*.d.ts|packages/*/README.md|packages/*/src/index.js|packages/*/src/index.ts)
      pkg=$(echo "$f" | awk -F/ '{print $2}')
      surface_count[$pkg]=$(( ${surface_count[$pkg]:-0} + 1 ))
      ;;
  esac
done

for pkg in "${!surface_count[@]}"; do
  if [ "${surface_count[$pkg]}" -ge 2 ]; then
    echo "fire surfacer packages/$pkg (${surface_count[$pkg]} surface files touched)"
    exit 0
  fi
done

# New-package signal: a new packages/<X>/package.json appeared.
new_pkg=$(git diff --name-only --diff-filter=A "$BASE...HEAD" 2>/dev/null \
          | grep -E '^packages/[^/]+/package\.json$' | head -1 || true)
if [ -n "$new_pkg" ]; then
  echo "fire surfacer $new_pkg (new package)"
  exit 0
fi

echo "skip surfacer"
