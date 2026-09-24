#!/bin/bash
# build-vs-buy.sh — reject a locally re-authored copy of a function another
# workspace package already exports (the name pass of the build-vs-buy detector).
# design: designs/export-index-build-vs-buy.md § 4; rule: skills/build-vs-buy/SKILL.md.
#
# The probe indexes the export surface at the base it checks against
# (PRE_PUSH_BASE_REF, else HEAD) through the per-commit cache
# (scripts/jobs/export-index/ensure-export-index.sh), runs the detector, and FAILS
# on each unwaived `strong` hit: a distinctive name, exported by exactly one
# reachable package, whose body matches the export's shape (or token Jaccard >= 0.6,
# or an idioms.tsv row names it). `weak` and `blocked` hits are silent here; the
# `procurer` jury seat judges them. Nameless idioms are reported by the sibling
# prefer-endo-primitives probe, not here.
#
# Waivers: `// build-not-buy: <reason>` on the line above the declaration, or
# `build-vs-buy-exempt` in a file's first five lines. When the index cannot be
# built (no node, an unresolvable base) the probe passes with a note: pre-push
# never blocks on missing infrastructure; the seat surfaces that case instead.

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GARDEN_CODE_ROOT="$(cd "$HERE/../../../../.." && pwd)"
DETECT="${GARDEN_BUILD_VS_BUY_DETECT:-$GARDEN_CODE_ROOT/skills/build-vs-buy/detect.cjs}"
ENSURE="${GARDEN_EXPORT_INDEX_ENSURE:-$GARDEN_CODE_ROOT/scripts/jobs/export-index/ensure-export-index.sh}"
NODE_BIN="${GARDEN_NODE_BIN:-node}"

root="${1:-.}"
cd "$root" 2>/dev/null || { echo "fail: cannot enter project root '$root'"; exit 1; }
command -v "$NODE_BIN" >/dev/null 2>&1 || { echo "pass (build-vs-buy skipped: node unavailable)"; exit 0; }

base="${PRE_PUSH_BASE_REF:-HEAD}"
index="$("$ENSURE" . "$base" 2>/dev/null)" || {
  echo "pass (build-vs-buy skipped: no export index for $base)"; exit 0; }
index_args=(--index "$index")
slug="$(sed -n '1s/^# repo=\([^ ]*\) .*/\1/p' "$index")"
while IFS= read -r provider; do
  [ -n "$provider" ] && index_args+=(--index "$provider=$(dirname "$(dirname "$provider")")")
done < <("$ENSURE" --providers . "$slug" 2>/dev/null)

mode=()
[ -n "${PRE_PUSH_BASE_REF:-}" ] && mode=(--base "$PRE_PUSH_BASE_REF")
hits="$("$NODE_BIN" "$DETECT" --repo . "${mode[@]}" "${index_args[@]}" --passes name)" \
  || { echo "pass (build-vs-buy skipped: detector errored)"; exit 0; }

failures="$(printf '%s\n' "$hits" | jq -r 'select(.strength == "strong" and .waiver == null)
  | "fail: \(.file):\(.line) \(.name) -> import { \(.provider.export) } from '"'"'\(.provider.specifier)'"'"' (def \(.provider.def)); or waive with // build-not-buy: <reason>"' 2>/dev/null)"
if [ -z "$failures" ]; then echo pass; exit 0; fi
printf '%s\n' "$failures"
exit 1
