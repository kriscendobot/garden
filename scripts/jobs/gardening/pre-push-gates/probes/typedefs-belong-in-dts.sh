#!/bin/bash
# typedefs-belong-in-dts.sh — pre-push-gate probe (skills/pre-push-gates § probes).
#
# Deterministic (no-LLM) detector for the `types.js` MASQUERADE: a changed
# `**/src/**/*.js` file that is a TYPES-ONLY MODULE — its meaningful content is
# `@typedef` / `@callback` JSDoc blocks and, once comments are stripped, it
# carries no runtime code beyond the empty `export {}` module marker. Per Endo
# house style such a module belongs in a HAND-WRITTEN `.d.ts` (the package's
# dedicated type-definition module, repointed via the `types` export condition),
# not a `.js` file. Converting it is a judgment call (move + repoint the export
# condition + track the `.d.ts` past a `.gitignore` negation), so this is a
# NON-AUTO-FIXABLE finding: the probe fails the gate with a one-line summary the
# pushing step addresses; it never rewrites the tree.
#
# Provenance: kriskowal asked for this twice, two days apart —
#   * endojs/endo-but-for-bots#58 review 4612637233 (2026-07-02,
#     packages/daemon/src/trace-aggregator.js:41): "Typedefs in .d.ts, please.
#     Adjust the garden to avoid this in the future with builder directives and
#     a reviewer."
#   * endojs/endo-but-for-bots#442 review 4629047816
#     (pull/442#discussion_r3522728825, packages/platform/src/fs/types.js): the
#     same ask, on a whole typedef-only `types.js` module.
# The #58 round delivered only prose (a builder directive) + a panel seat
# (typist); neither bound on #442 (its gauntlet never ran) and the maintainer
# had to repeat himself. This is the missing tier-1 gate that cannot be skipped
# or forgotten. Cluster: review-misses/clusters/typedef-location-dts.md.
#
# NARROW BY DESIGN (skills/pre-push-gates § Pitfalls, "too aggressive blocks a
# legitimate diff"): the probe fires ONLY on the clear whole-file-of-typedefs
# shape — a file with zero runtime code once comments and the empty-module
# marker are removed. The escape hatch for a genuinely module-private, single-use
# `@typedef` inline in an IMPLEMENTATION `.js` is honored automatically: an
# implementation file has runtime code, so it never matches. The judgment case
# (an inline exported typedef in a file that also carries runtime code) is left
# to the always-on typist seat and the builder/fixer directive, not the gate.
#
# Subcommands / usage:
#   typedefs-belong-in-dts.sh [<project-root>]
#       Run as a gate probe over the staged diff (or, if nothing is staged, the
#       unstaged working-tree diff) rooted at <project-root> (default: cwd).
#       Prints `pass`, or one `fail: <path> ...` line per finding; exits 0/1.
#   typedefs-belong-in-dts.sh --check-file <path>
#       Classify a single file on disk (for tests / demonstration). Prints
#       `types-only` (exit 0) or `not-types-only` (exit 1).
#   typedefs-belong-in-dts.sh --classify-stdin
#       Classify file content on stdin. Exit 0 = types-only module, 1 = not.

set -uo pipefail

# is_types_only_module — reads a JS file's content on stdin. Exit 0 when the file
# is a types-only module (>=1 @typedef/@callback and no runtime code once comments
# and the empty `export {}` marker are stripped); exit 1 otherwise. A character
# scanner strips `//` line comments and `/* */` (incl. JSDoc) block comments while
# skipping string/template literals, so a `//` or `/*` inside a string is not
# mistaken for a comment. When in doubt it leaves text as code (favoring a false
# NEGATIVE over blocking a legitimate diff).
is_types_only_module() {
  awk '
    BEGIN { inblock=0; code=""; hastypedef=0; sq=sprintf("%c",39); bt=sprintf("%c",96) }
    {
      line=$0
      if (line ~ /@typedef|@callback/) hastypedef=1
      out=""
      n=length(line)
      i=1
      instr=0; q=""
      while (i<=n) {
        c=substr(line,i,1); d=substr(line,i,2)
        if (inblock) {
          if (d=="*/") { inblock=0; i+=2 } else { i++ }
          continue
        }
        if (instr) {
          out=out c
          if (c==q) instr=0
          i++
          continue
        }
        if (d=="//") { break }              # rest of the line is a line comment
        if (d=="/*") { inblock=1; i+=2; continue }
        if (c=="\"" || c==sq || c==bt) { instr=1; q=c; out=out c; i++; continue }
        out=out c
        i++
      }
      code=code out
    }
    END {
      gsub(/[ \t\r\n;]/,"",code)            # whitespace + statement terminators
      gsub(/export\{\}/,"",code)            # the empty-module marker is not runtime code
      if (hastypedef && code=="") exit 0
      exit 1
    }
  '
}

check_file() {
  local path="$1"
  if [ ! -f "$path" ]; then echo "not-types-only" >&2; return 1; fi
  if is_types_only_module <"$path"; then echo "types-only"; return 0; fi
  echo "not-types-only"; return 1
}

run_probe() {
  local root="${1:-.}"
  cd "$root" 2>/dev/null || { echo "fail: cannot enter project root '$root'"; return 1; }

  # Prefer the staged diff (the gate's normal input); fall back to the unstaged
  # working-tree diff when nothing is staged. --diff-filter=d drops deletions.
  local files
  files=$(git diff --staged --name-only --diff-filter=d 2>/dev/null)
  [ -z "$files" ] && files=$(git diff --name-only --diff-filter=d 2>/dev/null)

  local findings=0
  while IFS= read -r f; do
    [ -z "$f" ] && continue
    # Only `**/src/**/*.js`. `*` in a bash case pattern spans '/', so this
    # matches any path with a `/src/` segment ending in `.js`.
    case "$f" in
      */src/*.js) : ;;
      *) continue ;;
    esac
    local content
    content=$(git show ":$f" 2>/dev/null) || content=""
    [ -z "$content" ] && content=$(cat "$f" 2>/dev/null)
    if printf '%s\n' "$content" | is_types_only_module; then
      echo "fail: $f is a types-only module (@typedef/@callback, no runtime exports) — author it as a hand-written .d.ts and repoint the \`types\` export condition, not a .js"
      findings=$((findings+1))
    fi
  done <<EOF
$files
EOF

  if [ "$findings" -eq 0 ]; then echo pass; return 0; fi
  return 1
}

case "${1:-}" in
  --check-file)     shift; check_file "${1:?usage: --check-file <path>}";;
  --classify-stdin) is_types_only_module;;
  *)                run_probe "${1:-.}";;
esac
