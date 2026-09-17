#!/bin/bash
# B-sibling-family — fires the breaker seat when a diff touches a member of a
# KNOWN sibling family (twin packages, duplicated helper copies, or a file
# hosting paired emulation constructors that jointly maintain one invariant).
#
# Senses the review-miss cluster `incomplete-sibling-transformation` (grounding
# PRs #475 and #1099): a change that generalizes an operation across sibling call
# sites converts some sites but silently skips — or diverges on — others.
# Consistency is a CONTENT property, not a path property: the harden/ses and
# hex/base64 misses both had BOTH twins touched but dispatching differently, so a
# probe that fired only when one twin was missing would have missed them. This
# probe therefore fires the breaker on ANY touch of a seeded family and hands the
# seat the family to enumerate; the seat (breaker § Sibling-family enumeration)
# compares each sibling's dispatch/handling and abstains when they already agree.
# A one-sided touch (the twin absent from the diff) is the stronger signal and is
# called out in the reason. Err toward firing — a loose probe is acceptable, a
# missed fire is not.
#
# Seed families:
#   packages/hex ~ packages/base64                      byte-codec twins (#1099/#573)
#   harden/make-hardener.js ~ ses/src/make-hardener.js  duplicated copies (#1099)
#   immutable-arraybuffer/src/lib.js                     paired DataView/TypedArray
#                                                        emulation constructors (#475)
set -uo pipefail
BASE=${BASE:-origin/master}

# Each entry: pair|<path-A>|<path-B>|<reason>  or  host|<path>|<reason>
FAMILIES=(
  "pair|packages/hex/|packages/base64/|hex/base64 byte-codec twins (#1099/#573)"
  "pair|packages/harden/make-hardener.js|packages/ses/src/make-hardener.js|duplicated make-hardener copies (#1099)"
  "host|packages/immutable-arraybuffer/src/lib.js|paired DataView/TypedArray emulation constructors maintaining the reverse buffer-map invariant (#475)"
)

if [ "${1:-}" = "--files-stdin" ]; then
  files=$(cat)
else
  files=$(git diff --name-only "$BASE...HEAD" 2>/dev/null)
fi

has() { printf '%s\n' "$files" | grep -qF -- "$1"; }

for entry in "${FAMILIES[@]}"; do
  IFS='|' read -r kind f1 f2 reason <<<"$entry"
  case "$kind" in
    pair)
      a=false; b=false
      has "$f1" && a=true
      has "$f2" && b=true
      if $a && ! $b; then
        echo "fire breaker $f1 edited without its sibling $f2 — $reason; enumerate the family and verify each sibling was converted"; exit 0
      elif $b && ! $a; then
        echo "fire breaker $f2 edited without its sibling $f1 — $reason; enumerate the family and verify each sibling was converted"; exit 0
      elif $a && $b; then
        echo "fire breaker both siblings $f1 and $f2 edited — $reason; verify each was converted consistently (same dispatch/handling)"; exit 0
      fi
      ;;
    host)
      # host entries carry the reason in the second field ($f2).
      if has "$f1"; then
        echo "fire breaker $f1 touched — $f2; enumerate every paired sibling in it and verify each was converted"; exit 0
      fi
      ;;
  esac
done

echo "skip breaker"
