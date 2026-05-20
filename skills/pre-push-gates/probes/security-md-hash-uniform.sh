#!/bin/bash
# security-md-hash-uniform — every packages/*/SECURITY.md hashes equal.
# Provenance: PR #75 r3223750050 ("dispatch a builder to create a CI rule
# that verifies that every package has this file and all these files are
# identical").

set -o pipefail

# Collect the SHA-256 of every packages/*/SECURITY.md.
declare -A hashes=()
findings=""
canonical=""
for f in packages/*/SECURITY.md; do
  [ -f "$f" ] || continue
  h=$(sha256sum "$f" | cut -d' ' -f1)
  if [ -z "$canonical" ]; then
    canonical=$h
  fi
  hashes[$h]+="$f "
done

# Guard against empty-array under set -u (some bash versions error on
# ${!hashes[@]} when the array has zero keys). The pass below also handles
# the no-SECURITY.md-anywhere case silently.
if [ "${#hashes[@]}" -gt 1 ]; then
  for h in "${!hashes[@]}"; do
    if [ "$h" != "$canonical" ]; then
      findings="${findings}divergent SECURITY.md ($h): ${hashes[$h]}
"
    fi
  done
fi

# Also flag packages without a SECURITY.md (only when there is at least one
# in the repo; an empty set is silent).
if [ -n "$canonical" ]; then
  for d in packages/*/; do
    [ -d "$d" ] || continue
    if [ ! -f "${d}SECURITY.md" ]; then
      findings="${findings}missing: ${d}SECURITY.md
"
    fi
  done
fi

if [ -z "$findings" ]; then
  echo "pass"
  exit 0
fi
printf 'fail: %s' "$findings"
exit 1
