#!/usr/bin/env bash
# inventory.sh <project-root>
#
# Walks the project tree for known Node-version pin surfaces and emits a JSON
# inventory. The recognised surfaces are documented in SKILL.md
# § Pin-surface inventory.
#
# Output shape:
# {
#   "surfaces": [
#     {"kind":"app-bundle","file":"...","line":22,"current":"v20.18.1"},
#     {"kind":"ci-single","file":"...","line":62,"current":"22.x"},
#     {"kind":"ci-matrix","file":"...","line":131,"current":["20.x","22.x","24.x"]},
#     {"kind":"frozen","file":"...","line":239,"current":["20"], "reason":"..."}
#   ]
# }

set -euo pipefail

PROJECT_ROOT="$1"
cd "$PROJECT_ROOT"

# Use a tmp file to assemble entries, then jq them into a single envelope.
TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT
: > "$TMP"

emit() {
  # emit <kind> <file> <line> <current-json> [<reason>]
  local kind="$1" file="$2" line="$3" current="$4" reason="${5:-}"
  if [[ -n "$reason" ]]; then
    jq -nc --arg k "$kind" --arg f "$file" --argjson l "$line" --argjson c "$current" --arg r "$reason" \
      '{kind:$k, file:$f, line:$l, current:$c, reason:$r}' >> "$TMP"
  else
    jq -nc --arg k "$kind" --arg f "$file" --argjson l "$line" --argjson c "$current" \
      '{kind:$k, file:$f, line:$l, current:$c}' >> "$TMP"
  fi
}

# --- App bundle pins ---------------------------------------------------------

# packages/*/scripts/download-node.mjs   process.argv[2] || 'vX.Y.Z'
while IFS= read -r f; do
  [[ -z "$f" ]] && continue
  # Find the literal vX.Y.Z fallback string and its line number.
  line=$(grep -nE "process\.argv\[2\] *\|\| *'v[0-9]+\.[0-9]+\.[0-9]+'" "$f" | head -1 | cut -d: -f1 || true)
  [[ -z "$line" ]] && continue
  ver=$(grep -oE "'v[0-9]+\.[0-9]+\.[0-9]+'" "$f" | head -1 | tr -d "'")
  emit "app-bundle" "$f" "$line" "$(jq -nc --arg v "$ver" '$v')"
done < <(find packages -path '*/scripts/download-node.mjs' 2>/dev/null || true)

# .nvmrc anywhere
while IFS= read -r f; do
  [[ -z "$f" ]] && continue
  ver=$(head -1 "$f" | tr -d '[:space:]')
  emit "app-bundle-nvmrc" "$f" 1 "$(jq -nc --arg v "$ver" '$v')"
done < <(find . -name '.nvmrc' -not -path './node_modules/*' 2>/dev/null || true)

# --- CI workflow pins --------------------------------------------------------
#
# Heuristic parse of .github/workflows/*.yml. We use grep with a YAML-aware
# regex; we are explicitly narrow (sequence of bare <MAJOR>.x strings) and
# treat anything else as frozen. A YAML-true parser is future work.

while IFS= read -r f; do
  [[ -z "$f" ]] && continue

  # ci-single: a top-level `node-version: <MAJOR>.x` (not under matrix:).
  # The cheap heuristic: lines matching `^[[:space:]]+node-version: [0-9]+\.x$`
  # whose enclosing scope is NOT a matrix block. We approximate by excluding
  # lines whose previous non-blank line is `matrix:` or contains `node-version:`
  # within a `strategy:` block. For now we emit all single pins and let the
  # planner ignore false positives via dedup against ci-matrix entries.
  while IFS=: read -r line _; do
    val=$(sed -n "${line}p" "$f" | sed -E 's/.*node-version: *([0-9]+\.x).*/\1/')
    emit "ci-single" "$f" "$line" "$(jq -nc --arg v "$val" '$v')"
  done < <(grep -nE '^[[:space:]]+node-version: [0-9]+\.x[[:space:]]*$' "$f" || true)

  # ci-matrix: a `node-version:` line followed by `[v1.x, v2.x, ...]` inline
  # or a YAML sequence on the following lines.
  #
  # Inline form: `        node-version: [20.x, 22.x, 24.x]`
  while IFS=: read -r line _; do
    raw=$(sed -n "${line}p" "$f")
    inner=$(echo "$raw" | sed -E "s/.*node-version: *\[([^]]+)\].*/\1/")
    # Split on commas, strip whitespace and quotes.
    arr=$(echo "$inner" | tr ',' '\n' | sed -E "s/[[:space:]'\"]+//g" | jq -R . | jq -sc .)
    emit "ci-matrix" "$f" "$line" "$arr"
  done < <(grep -nE '^[[:space:]]+node-version: \[[^]]+\]' "$f" || true)

  # Block form: `        node-version:` followed by `          - 'X.Y'` lines.
  # We look for the anchor line and then walk forward until the indentation
  # decreases or the next non-`- ` line. Any version string that isn't a bare
  # <MAJOR>.x is flagged frozen (annotated matrices are recognised by an
  # adjacent comment containing 'pinned' or 'policy-frozen').
  while IFS=: read -r line _; do
    # Read the immediate preceding 3 lines to look for # pinned / # policy-frozen.
    start=$(( line > 5 ? line - 5 : 1 ))
    pre=$(sed -n "${start},${line}p" "$f")
    # Collect the YAML sequence values that follow on subsequent indented `- ` lines.
    next_block=$(awk -v start="$line" 'NR>start && /^[[:space:]]+- / { print } NR>start && !/^[[:space:]]+- / && !/^[[:space:]]*#/ && NF>0 { exit }' "$f")
    [[ -z "$next_block" ]] && continue
    vals=$(echo "$next_block" | sed -E "s/^[[:space:]]+- *['\"]?([^'\"#[:space:]]+).*$/\1/" | jq -R . | jq -sc .)
    # Frozen if any value isn't <MAJOR>.x, OR an adjacent comment marks the matrix.
    is_frozen=$(echo "$next_block" | grep -cvE "^[[:space:]]+- *['\"]?[0-9]+\.x['\"]?[[:space:]]*$" || true)
    pinned_marker=$(echo "$pre" "$next_block" | grep -cE '# *(pinned|policy-frozen)' || true)
    if [[ "$is_frozen" -gt 0 || "$pinned_marker" -gt 0 ]]; then
      reason="non-uniform versions or # pinned/policy-frozen marker"
      emit "frozen" "$f" "$line" "$vals" "$reason"
    else
      emit "ci-matrix" "$f" "$line" "$vals"
    fi
  done < <(grep -nE '^[[:space:]]+node-version:[[:space:]]*$' "$f" || true)

done < <(find .github/workflows -name '*.yml' 2>/dev/null || true)

# --- engines.node (report-only) ----------------------------------------------

while IFS= read -r f; do
  [[ -z "$f" ]] && continue
  if jq -e '.engines.node' "$f" >/dev/null 2>&1; then
    rng=$(jq -r '.engines.node' "$f")
    line=$(grep -n '"node"' "$f" | head -1 | cut -d: -f1 || echo 1)
    emit "engines-node-report" "$f" "$line" "$(jq -nc --arg v "$rng" '$v')"
  fi
done < <(find . -name 'package.json' -not -path './node_modules/*' 2>/dev/null || true)

# --- Assemble ---------------------------------------------------------------

jq -s '{surfaces: .}' "$TMP"
