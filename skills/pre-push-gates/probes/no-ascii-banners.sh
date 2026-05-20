#!/bin/bash
# no-ascii-banners — reject box-drawing chars (U+2500–U+257F) and bare-ASCII
# +--+ / |...| / +==+ banners in changed .md and .js files.
# Provenance: PR #238 inline r3237804603 (mermaid over ASCII), PR #75 r3267751127.

set -uo pipefail

# Resolve the diff's changed paths. Prefer staged; fall back to origin/<base>.
paths=$(git diff --cached --name-only --diff-filter=AM 2>/dev/null | grep -E '\.(md|js|ts)$' || true)
if [ -z "$paths" ]; then
  base=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null | sed 's|^origin/||' || echo master)
  paths=$(git diff "origin/$base...HEAD" --name-only --diff-filter=AM 2>/dev/null | grep -E '\.(md|js|ts)$' || true)
fi

findings=""
for p in $paths; do
  [ -f "$p" ] || continue
  # Box-drawing chars (U+2500–U+257F) — non-ASCII matching via perl is robust.
  if perl -CSD -ne 'exit 0 if /[\x{2500}-\x{257F}]/' "$p" 2>/dev/null; then : ; else
    findings="$findings$p: box-drawing chars
"
  fi
  # Bare ASCII banners: +--+...+--+ or top/bottom lines like +======+
  if grep -E '^\s*\+[-=]{3,}\+' "$p" >/dev/null 2>&1; then
    findings="$findings$p: ASCII +---+ banner
"
  fi
done

if [ -z "$findings" ]; then
  echo "pass"
  exit 0
fi
printf 'fail: %s' "$findings"
exit 1
