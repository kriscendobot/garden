#!/bin/bash
# B-changeset-auditor — fires when any .changeset/<slug>.md (excluding README/config) changes.
set -uo pipefail
BASE=${BASE:-origin/master}
files=$(git diff --name-only "$BASE...HEAD" 2>/dev/null)

hit=$(echo "$files" | grep -E '^\.changeset/[^/]+\.md$' \
      | grep -vE 'README\.md$|config\.json$' | head -1 || true)
if [ -n "$hit" ]; then
  echo "fire changeset-auditor $hit"
  exit 0
fi

echo "skip changeset-auditor"
