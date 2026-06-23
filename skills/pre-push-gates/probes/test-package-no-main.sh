#!/bin/bash
# test-package-no-main — packages whose name ends in -test (or whose only
# code is under test/) must have an empty package.json with no main, module,
# or exports field.
# Provenance: PR #75 r3223667088 ("There should be no main nor module on a
# test package").
#
# Exception: exports may contain a sole "./package.json" entry. All packages
# must expose "./package.json" so that tools can import package metadata.
# Provenance: PR #475 r4554572514 (kriskowal): "all packages must have an
# exports directive, and that must always include package.json because some
# tools rely on `import` to get package metadata."

set -uo pipefail

findings=""
for pjson in packages/*-test/package.json; do
  [ -f "$pjson" ] || continue
  # Reject main or module.
  for key in main module; do
    val=$(jq -r ".${key} // empty" "$pjson" 2>/dev/null)
    if [ -n "$val" ] && [ "$val" != "null" ]; then
      findings="$findings$pjson: has \"$key\": $val
"
    fi
  done
  # Reject exports unless it is empty ({}) or contains only "./package.json".
  val=$(jq -r '.exports // empty' "$pjson" 2>/dev/null)
  if [ -n "$val" ] && [ "$val" != "null" ] && [ "$val" != "{}" ]; then
    # Allow a sole "./package.json" entry.
    non_pkgjson=$(jq -r '.exports | to_entries | map(select(.key != "./package.json")) | length' "$pjson" 2>/dev/null)
    if [ "$non_pkgjson" != "0" ]; then
      findings="$findings$pjson: has \"exports\": $val
"
    fi
  fi
done

if [ -z "$findings" ]; then
  echo "pass"
  exit 0
fi
printf 'fail: %s' "$findings"
exit 1
