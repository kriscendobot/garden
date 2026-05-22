#!/bin/bash
# B-benchmarker — fires when BENCH.md or *.bench.* files or benchmark/ dirs change.
set -uo pipefail
BASE=${BASE:-origin/master}
files=$(git diff --name-only "$BASE...HEAD" 2>/dev/null)

hit=$(echo "$files" | grep -E '(^|/)BENCH\.md$|\.bench\.(js|ts|mjs)$|/benchmark/|/bench/' | head -1 || true)
if [ -n "$hit" ]; then
  echo "fire benchmarker $hit"
  exit 0
fi

echo "skip benchmarker"
