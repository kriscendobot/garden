#!/bin/bash
# filename-no-stutter — a file at packages/<P>/.../<P>-foo.<ext> stutters
# the package name in its basename. The package's directory already names <P>;
# the basename should not repeat it.
# Provenance: PR #75 r3223811705 ("Don't stutter. This is fill-random-bytes.bench.js").

set -uo pipefail

paths=$(git diff --cached --name-only --diff-filter=AM 2>/dev/null \
        | grep -E '^packages/' || true)
if [ -z "$paths" ]; then
  base=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null | sed 's|^origin/||' || echo master)
  paths=$(git diff "origin/$base...HEAD" --name-only --diff-filter=AM 2>/dev/null \
          | grep -E '^packages/' || true)
fi

findings=""
for p in $paths; do
  [ -f "$p" ] || continue
  # Extract <P> = first directory component under packages/.
  pkg=$(echo "$p" | awk -F/ '{print $2}')
  base=$(basename "$p")
  # Strip a leading underscore (private helpers like _xorshift.js).
  stripped=${base#_}
  # Stutter cases:
  #   1) basename starts with <P>- (e.g. chacha12-fill-bytes.bench.js)
  #   2) basename contains _<P>_ or -<P>- in the middle
  if [ "${stripped#${pkg}-}" != "$stripped" ] && [ "$stripped" != "$pkg.js" ] && [ "$stripped" != "$pkg.ts" ]; then
    findings="$findings$p: basename starts with package name '$pkg'
"
  fi
done

if [ -z "$findings" ]; then
  echo "pass"
  exit 0
fi
printf 'fail: %s' "$findings"
exit 1
