#!/bin/bash
# B-breaker — fires when invariant-bearing files are touched (M.interface, makeExo, ## Invariants).
set -uo pipefail
BASE=${BASE:-origin/master}
files=$(git diff --name-only "$BASE...HEAD" 2>/dev/null)

# For each touched file, check whether it contains an invariant-bearing pattern at HEAD.
for f in $files; do
  [ -f "$f" ] || continue
  if grep -qE 'M\.interface\(|\bmakeExo\b|\bdefineExoClass\b|^## Invariants' "$f" 2>/dev/null; then
    echo "fire breaker $f (M.interface / makeExo / ## Invariants)"
    exit 0
  fi
done

echo "skip breaker"
