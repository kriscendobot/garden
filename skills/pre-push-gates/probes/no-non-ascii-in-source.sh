#!/bin/bash
# no-non-ascii-in-source — reject non-ASCII characters introduced in newly-added
# lines of source code under packages/<pkg>/src/ and packages/<pkg>/lib/. Test
# paths and fixture paths are excluded by glob; individual files that
# legitimately carry non-ASCII (UTF-8 round-trip tests living under src/, etc.)
# opt out via a `/* ascii-exempt */` marker on a line within the first 5.
#
# Provenance: PR endojs/endo-but-for-bots#417 inline r3353301111
# (kriskowal 2026-06-04T04:21Z): "Avoid non-ASCII. This is in the guide.
# Dispatch a gardener to revise the driver to have deterministic automation
# to keep source generally in the ASCII range."

set -uo pipefail

base=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null | sed 's|^origin/||' || echo master)

paths=$(git diff --cached --name-only --diff-filter=AM 2>/dev/null \
        | grep -E '^packages/[^/]+/(src|lib)/.*\.(js|ts|mjs|cjs)$' || true)
if [ -z "$paths" ]; then
  paths=$(git diff "origin/$base...HEAD" --name-only --diff-filter=AM 2>/dev/null \
          | grep -E '^packages/[^/]+/(src|lib)/.*\.(js|ts|mjs|cjs)$' || true)
fi

findings=""
for p in $paths; do
  [ -f "$p" ] || continue
  # Opt-out marker for files that legitimately carry non-ASCII (rare under
  # src/lib; the path glob above already excludes test/ and fixtures/).
  if head -5 "$p" 2>/dev/null | grep -qE '/\*[[:space:]]*ascii-exempt[[:space:]]*\*/'; then
    continue
  fi
  diff=$(git diff --cached -U0 -- "$p" 2>/dev/null)
  if [ -z "$diff" ]; then
    diff=$(git diff "origin/$base...HEAD" -U0 -- "$p" 2>/dev/null)
  fi
  hits=$(printf '%s\n' "$diff" | perl -CSAD -ne '
    BEGIN { our $line = 0; }
    if (/^\+\+\+/) { next; }
    if (/^@@.*?\+(\d+)/) { $line = $1 - 1; next; }
    if (/^\+/) {
      $line++;
      my $content = substr($_, 1);
      if ($content =~ /([^\x00-\x7F])/) {
        printf "%d: non-ASCII U+%04X (\x27%s\x27)\n", $line, ord($1), $1;
      }
    }
  ')
  if [ -n "$hits" ]; then
    while IFS= read -r hit; do
      findings="$findings$p:$hit
"
    done <<< "$hits"
  fi
done

if [ -n "$findings" ]; then
  printf 'fail: non-ASCII characters in added source lines\n'
  printf '  %s' "$findings"
  exit 1
fi
echo pass
exit 0
