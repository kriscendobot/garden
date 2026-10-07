#!/bin/bash
# X-decomplector — cross-fires the design-panel decomplector onto a CODE panel when
# the diff adds a new channel, formula type, or per-entity resource, or edits a
# design doc. The seat then asks its code-panel questions
# (roles/jurors/decomplector/AGENT.md § Code-panel mode): does an existing
# repository path already provide this access or boundary, and has a maintainer
# already rejected this mechanism on an earlier PR for the same design doc?
#
# Senses the review-miss cluster `design-bespoke-mechanism-over-existing-path`
# (process; endojs/endo-but-for-bots #1226, #1407) and the related
# `vestigial-mechanism-unquestioned` (#1125):
#   #1407 added a per-guest Unix socket (`servePrivatePath` reuse in a new
#         `serve-guest-path.js`, `guestBootstrapPath`, `socketPath`) that the
#         maintainer had already rejected on design #1226; six code-panel rounds
#         patched its lifecycle with no decomplector seated.
#   #1125 added a `readable-directory` formula type (eval + readOnly() already
#         covered it) and a `@pins/guest-*` retention pin with no remaining consumer.
#
# Signal groups, fire on ANY (err toward firing; the seat decides whether the
# mechanism is warranted):
#   DESIGN  — a changed designs/*.md or DESIGN*.md path in a mixed code PR.
#   CHANNEL — an added socket/listener/endpoint/serve-path call or prose.
#   FORMULA — an added daemon formula type (a formula-type.js entry, a
#             `formulate<Name>` definition, a `type: '<kebab>'` in a packages/daemon
#             type declaration file).
#   RETAIN  — an added per-entity retention resource (`@pins`, `*PinName`,
#             `*PinsDirectoryId`).
#
# Usage: BASE=<ref> X-decomplector.sh            (reads git diff BASE...HEAD in cwd)
#        X-decomplector.sh --scan-stdin [--path P] (added lines on stdin, as file P)
set -uo pipefail
BASE=${BASE:-origin/master}

CHANNEL='\bservePrivatePath\b|\bservePath\b|\bserve[A-Z][A-Za-z]*(Path|Socket|Endpoint)\b|\bcreateServer[[:space:]]*\(|\.listen[[:space:]]*\(|\bnet\.(connect|createConnection)\b|[Ss]ocketPath\b|\b[A-Za-z]+(Socket|Endpoint|Listener)Path\b|[Uu]nix[- ](domain[- ])?socket|[Nn]amed pipe|SO_PEERCRED|\bWebSocketServer\b'
FORMULA_DEF='\bformulate[A-Z][A-Za-z]*\b[[:space:]]*[:=(]|DaemonCore\[.formulate[A-Z]'
FORMULA_TYPE="type:[[:space:]]*'[a-z][a-z0-9-]*'"
FORMULA_ENTRY="^[[:space:]]*'[a-z][a-z0-9-]*',[[:space:]]*\$"
RETAIN='@pins\b|\b[A-Za-z]+PinName\b|\b[a-z][A-Za-z]*Pins(Directory)?Id\b'

# Emit "<path>\t<added line>" records.
added_lines() {
  if [ "${1:-}" = "--scan-stdin" ]; then
    local path="stdin"
    [ "${2:-}" = "--path" ] && path="${3:-stdin}"
    awk -v p="$path" '{ print p "\t" $0 }'
  else
    git diff "$BASE...HEAD" -U0 2>/dev/null | awk '
      /^\+\+\+ / { p = $2; sub(/^b\//, "", p); next }
      /^\+/ { sub(/^\+/, ""); print p "\t" $0 }'
  fi
}

if [ "${1:-}" != "--scan-stdin" ]; then
  while IFS= read -r f; do
    case "$f" in
      designs/*.md|*/designs/*.md|DESIGN*.md|*/DESIGN*.md)
        echo "fire decomplector design doc touched ($f) — check the doc's history and linked PR reviews for a maintainer decision this change re-opens"
        exit 0 ;;
    esac
  done < <(git diff --name-only "$BASE...HEAD" 2>/dev/null)
fi

while IFS=$'\t' read -r path line; do
  [ -n "$line" ] || continue
  if hit=$(printf '%s' "$line" | grep -oE "$CHANNEL" | head -1) && [ -n "$hit" ]; then
    echo "fire decomplector new channel/endpoint ($path: $hit) — does an existing connection path (root bootstrap + lookup) already provide this access?"
    exit 0
  fi
  if hit=$(printf '%s' "$line" | grep -oE "$FORMULA_DEF" | head -1) && [ -n "$hit" ]; then
    echo "fire decomplector new formula maker ($path: $hit) — would composing existing formulas (eval + an existing attenuator) cover it?"
    exit 0
  fi
  case "$path" in
    *formula-type*)
      if printf '%s' "$line" | grep -qE "$FORMULA_ENTRY"; then
        echo "fire decomplector new formula type ($path: $(printf '%s' "$line" | tr -d ' ,')) — would composing existing formulas cover it?"
        exit 0
      fi ;;
  esac
  case "$path" in
    packages/daemon/*.d.ts|packages/daemon/*types.ts|stdin)
      if hit=$(printf '%s' "$line" | grep -oE "$FORMULA_TYPE" | head -1) && [ -n "$hit" ]; then
        echo "fire decomplector formula type literal ($path: $hit) — would composing existing formulas cover it?"
        exit 0
      fi ;;
  esac
  if hit=$(printf '%s' "$line" | grep -oE "$RETAIN" | head -1) && [ -n "$hit" ]; then
    echo "fire decomplector per-entity retention resource ($path: $hit) — what still consumes what this retains?"
    exit 0
  fi
done < <(added_lines "$@")

echo "skip decomplector"
