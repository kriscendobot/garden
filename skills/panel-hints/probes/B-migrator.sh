#!/bin/bash
# B-migrator — fires on dependency changes, multi-package diffs, or changeset presence.
set -uo pipefail
BASE=${BASE:-origin/master}
files=$(git diff --name-only "$BASE...HEAD" 2>/dev/null)

# dependencies or peerDependencies changed in any package.json.
if echo "$files" | grep -qE 'package\.json$'; then
  if git diff "$BASE...HEAD" -U0 -- '**/package.json' 'package.json' 2>/dev/null \
     | grep -qE '^\+.*"(peerDependencies|dependencies|devDependencies)"\s*:|^\+\s+"[^"]+"\s*:\s*"[~^]?[0-9*]'; then
    echo "fire migrator dependency/peerDeps change in package.json"
    exit 0
  fi
fi

# Multi-package diff (>1 package touched).
pkg_count=$(echo "$files" | awk -F/ '/^packages\//{print $2}' | sort -u | wc -l)
if [ "$pkg_count" -gt 1 ]; then
  echo "fire migrator $pkg_count packages touched"
  exit 0
fi

# Changeset present (cross-link with the changeset-auditor; both fire).
if echo "$files" | grep -qE '^\.changeset/[^/]+\.md$' | grep -vE 'README\.md|config\.json'; then
  echo "fire migrator changeset present"
  exit 0
fi

echo "skip migrator"
