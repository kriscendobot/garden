#!/bin/bash
# C-engine-realist — fires on V8/XS engine-variance and vat-lifecycle signals.
set -uo pipefail
BASE=${BASE:-origin/master}
PATTERN='\bWeakMap\b|\bWeakRef\b|\bWeakSet\b|FinalizationRegistry|\bcrank\b|\b(durable|virtual|ephemeral)\b|\bvatstore\b|Float16Array|\basync_hooks\b|\bmakeKindHandle\b'
hit=$(git diff "$BASE...HEAD" -U0 2>/dev/null | grep -E '^\+[^+]' | grep -oE "$PATTERN" | head -1 || true)
if [ -n "$hit" ]; then
  echo "fire engine-realist matched: $hit"
  exit 0
fi
echo "skip engine-realist"
