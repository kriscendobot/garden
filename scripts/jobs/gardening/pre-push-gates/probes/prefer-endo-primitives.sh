#!/bin/bash
# prefer-endo-primitives.sh — reject recognizable hand-rolled Endo primitives.
#
# A thin shim over the build-vs-buy detector (skills/build-vs-buy/detect.cjs) in
# IDIOM-ONLY mode: the signature catalog now lives as data in
# skills/build-vs-buy/idioms.tsv, and this probe keeps its name, its
# `prefer-endo-primitives-exempt` marker (first five lines), and its output shape
# so existing callers and regression cases keep working. A copied NAMED export
# (a local `makePromiseKit`, say) is the name pass's job and is reported by the
# sibling `build-vs-buy` probe; only a nameless inline idiom earns an idioms.tsv row.
# design: designs/export-index-build-vs-buy.md § 4.
#
#   prefer-endo-primitives.sh [<root>]          pre-push: PRE_PUSH_BASE_REF...HEAD,
#                                                else the staged, else the worktree diff
#   prefer-endo-primitives.sh --scan-stdin <label>   every stdin line is an added line

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DETECT="${GARDEN_BUILD_VS_BUY_DETECT:-$HERE/../../../../../skills/build-vs-buy/detect.cjs}"
NODE_BIN="${GARDEN_NODE_BIN:-node}"

if ! command -v "$NODE_BIN" >/dev/null 2>&1; then
  echo "pass (prefer-endo-primitives skipped: node unavailable)"; exit 0
fi

case "${1:-}" in
  --scan-stdin) hits="$("$NODE_BIN" "$DETECT" --stdin "${2:-<stdin>}" --passes idiom)"; rc=$? ;;
  *)
    root="${1:-.}"
    cd "$root" 2>/dev/null || { echo "fail: cannot enter project root '$root'"; exit 1; }
    mode=()
    [ -n "${PRE_PUSH_BASE_REF:-}" ] && mode=(--base "$PRE_PUSH_BASE_REF")
    hits="$("$NODE_BIN" "$DETECT" --repo . "${mode[@]}" --passes idiom)"; rc=$? ;;
esac
[ "$rc" -eq 0 ] || { echo "fail: build-vs-buy detector errored (rc=$rc)"; exit 1; }
if [ -z "$hits" ]; then echo pass; exit 0; fi
printf '%s\n' "$hits" | jq -r \
  '"fail: \(.file) adds \(.description); use \(.advice) (or mark a justified prefer-endo-primitives-exempt file)"'
exit 1
