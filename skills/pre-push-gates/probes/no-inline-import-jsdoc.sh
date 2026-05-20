#!/bin/bash
# no-inline-import-jsdoc — reject inline `@type {import('...').X}` JSDoc forms
# in changed .js/.ts files. The garden's per-repo CLAUDE.md (and the
# maintainer's recurring ask on PR #75 r3223741240) prefers the `@import`
# form at the top of the file.
# Provenance: PR #75 r3223741240 ("Recall we prefer @import jsdoc").

set -uo pipefail

paths=$(git diff --cached --name-only --diff-filter=AM 2>/dev/null \
        | grep -E '\.(js|ts)$' || true)
if [ -z "$paths" ]; then
  base=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null | sed 's|^origin/||' || echo master)
  paths=$(git diff "origin/$base...HEAD" --name-only --diff-filter=AM 2>/dev/null \
          | grep -E '\.(js|ts)$' || true)
fi

findings=""
for p in $paths; do
  [ -f "$p" ] || continue
  # Match @type {import('...').X} or @type {import("...").X} or
  # @type {import('...')} alone (no member). Allow @typedef ... that
  # legitimately uses import() in a typedef declaration.
  if grep -nE '@(type|param|returns|property)[[:space:]]*\{[^}]*\bimport\(' "$p" \
       | grep -v '@typedef' >/dev/null 2>&1; then
    matches=$(grep -nE '@(type|param|returns|property)[[:space:]]*\{[^}]*\bimport\(' "$p" \
              | grep -v '@typedef' | head -3 | cut -d: -f1 | tr '\n' ',')
    findings="$findings$p: inline import() at line ${matches%,}
"
  fi
done

if [ -z "$findings" ]; then
  echo "pass"
  exit 0
fi
printf 'fail: %s' "$findings"
exit 1
