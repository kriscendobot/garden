#!/bin/bash
# test-package-no-main — packages whose name ends in -test (or whose only
# code is under test/) must have an empty package.json with no main, module,
# or exports field.
# Provenance: PR #75 r3223667088 ("There should be no main nor module on a
# test package").

set -uo pipefail

findings=""
for pjson in packages/*-test/package.json; do
  [ -f "$pjson" ] || continue
  # Reject any of main / module / exports being non-empty.
  for key in main module exports; do
    val=$(jq -r ".${key} // empty" "$pjson" 2>/dev/null)
    if [ -n "$val" ] && [ "$val" != "null" ] && [ "$val" != "{}" ]; then
      findings="$findings$pjson: has \"$key\": $val
"
    fi
  done
done

if [ -z "$findings" ]; then
  echo "pass"
  exit 0
fi
printf 'fail: %s' "$findings"
exit 1
