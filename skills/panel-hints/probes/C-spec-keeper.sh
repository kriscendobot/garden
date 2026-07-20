#!/bin/bash
# C-spec-keeper — fires on ECMA-262 / engine-variance and exo guard-tightness signals.
set -uo pipefail
BASE=${BASE:-origin/master}
SPEC_PATTERN='Reflect\.(apply|construct|ownKeys|deleteProperty)|\.call\(|\.apply\(|Number\.(MAX_SAFE_INTEGER|EPSILON|MIN_SAFE_INTEGER)|Symbol\.(iterator|asyncIterator|toPrimitive)|tc39\.es|webidl\.spec|polyfill|\bshim\b'
spec_hit=$(git diff "$BASE...HEAD" -U0 2>/dev/null | grep -E '^\+[^+]' | grep -oE "$SPEC_PATTERN" | head -1 || true)

# This detects the mechanically visible half of the TypedPatterns convention.
# The seat decides whether a nearby, reasoned compatibility-boundary exception
# justifies the looseness; false-positive dispatch is preferable to a missed check.
guard_hit=$(
  while IFS= read -r path; do
    case "$path" in
      *.ts|*.js) ;;
      *) continue ;;
    esac

    file_diff=$(git diff "$BASE...HEAD" -U20 -- "$path" 2>/dev/null)
    case "$path" in
      *.exo.ts|*.exo.js) is_exo_file=true ;;
      *) is_exo_file=false ;;
    esac
    if [ "$is_exo_file" = false ] && ! printf '%s\n' "$file_diff" | grep -Eq '^[ +][^+].*M\.interface[[:space:]]*\('; then
      continue
    fi

    loose_line=$(printf '%s\n' "$file_diff" | grep -E '^\+[^+].*(M\.any\(\)|M\.record\(\))' | head -1 || true)
    if [ -n "$loose_line" ]; then
      printf '%s: %s\n' "$path" "${loose_line#+}"
      break
    fi
  done < <(git diff --name-only "$BASE...HEAD" -- '*.ts' '*.js' 2>/dev/null)
)

if [ -n "$guard_hit" ]; then
  echo "fire spec-keeper exo guard may be looser than known static type: $guard_hit"
  exit 0
fi
if [ -n "$spec_hit" ]; then
  echo "fire spec-keeper matched: $spec_hit"
  exit 0
fi
echo "skip spec-keeper"
