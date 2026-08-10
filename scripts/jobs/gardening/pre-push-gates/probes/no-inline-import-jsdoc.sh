#!/bin/bash
# no-inline-import-jsdoc.sh -- reject inline import() JSDoc type references.
#
# Endo JSDoc imports belong in a top-of-file `@import` tag. A type annotation
# then uses its imported name rather than spelling `import('./types.js').Foo`
# inline. Moving the import can touch a file-wide import block, so this finding
# is deliberately non-auto-fixable.
#
# The probe examines only added lines of changed source files. It reads the
# complete post-change file to identify JSDoc blocks, which keeps source strings
# and ordinary comments out of scope while still reporting the added line.
# A file may opt out with `inline-import-exempt` in its first five lines.

set -uo pipefail

is_source() {
  case "$1" in
    *.js|*.mjs|*.cjs|*.jsx|*.ts|*.tsx) return 0 ;;
    *) return 1 ;;
  esac
}

staged_diff_for() {
  local file="$1"
  if [ -n "${PRE_PUSH_BASE_REF:-}" ]; then
    git diff -U0 "$PRE_PUSH_BASE_REF"...HEAD -- "$file" 2>/dev/null
    return
  fi
  if git diff --staged --quiet -- "$file" 2>/dev/null; then
    git diff -U0 -- "$file" 2>/dev/null
  else
    git diff --staged -U0 -- "$file" 2>/dev/null
  fi
}

file_content() {
  local file="$1"
  if [ -n "${PRE_PUSH_BASE_REF:-}" ]; then cat "$file" 2>/dev/null; return; fi
  if git diff --staged --quiet -- "$file" 2>/dev/null; then
    cat "$file" 2>/dev/null
  else
    git show ":$file" 2>/dev/null || cat "$file" 2>/dev/null
  fi
}

is_exempt() {
  local file="$1"
  file_content "$file" | head -5 | grep -q 'inline-import-exempt'
}

added_line_numbers() {
  local file="$1"
  staged_diff_for "$file" | awk '
    /^@@ / {
      split($3, range, ",")
      line = range[1]
      sub(/^\+/, "", line)
      next
    }
    /^\+[^+]/ { print line; line++ }
  '
}

scan_file() {
  local file="$1" added_lines
  added_lines=$(added_line_numbers "$file")
  [ -n "$added_lines" ] || return 0

  file_content "$file" | awk -v file="$file" -v added_lines="$added_lines" '
    BEGIN {
      split(added_lines, numbers, "\n")
      for (entry in numbers) if (numbers[entry] != "") added[numbers[entry]] = 1
      in_jsdoc = 0
      single_quote = sprintf("%c", 39)
      double_quote = sprintf("%c", 34)
      findings = 0
    }
    function report_imports(text, tag, line,   type, position, rest, quote, end, specifier) {
      # A type reference begins inside braces. This deliberately ignores prose
      # such as an @remarks string that happens to quote import("...").
      position = index(text, "{")
      if (position == 0) return
      type = substr(text, position + 1)
      while (match(type, /import[ \t]*\([ \t]*/)) {
        rest = substr(type, RSTART + RLENGTH)
        quote = substr(rest, 1, 1)
        if (quote != single_quote && quote != double_quote) {
          type = substr(rest, 2)
          continue
        }
        rest = substr(rest, 2)
        end = index(rest, quote)
        if (end == 0) return
        specifier = substr(rest, 1, end - 1)
        printf "fail: %s:%d %s uses inline import(%s%s%s); add a top-of-file @import tag and use a bare type reference\n", file, line, tag, quote, specifier, quote
        findings++
        type = substr(rest, end + 1)
      }
    }
    {
      text = $0
      if (!in_jsdoc) {
        start = index(text, "/**")
        if (start == 0) next
        in_jsdoc = 1
        text = substr(text, start + 3)
      }

      stop = index(text, "*/")
      if (stop > 0) {
        text = substr(text, 1, stop - 1)
        closes = 1
      } else {
        closes = 0
      }

      if (added[NR]) {
        tag = "bare JSDoc type"
        if (match(text, /@[[:alpha:]][[:alnum:]_-]*/)) tag = substr(text, RSTART, RLENGTH)
        report_imports(text, tag, NR)
      }
      if (closes) in_jsdoc = 0
    }
    END { exit(findings == 0 ? 0 : 1) }
  '
}

run_probe() {
  local root="${1:-.}"
  cd "$root" 2>/dev/null || { echo "fail: cannot enter project root '$root'"; return 1; }

  local files findings=0
  if [ -n "${PRE_PUSH_BASE_REF:-}" ]; then
    files=$(git diff "$PRE_PUSH_BASE_REF"...HEAD --name-only --diff-filter=d 2>/dev/null)
  else
    files=$(git diff --staged --name-only --diff-filter=d 2>/dev/null)
    [ -z "$files" ] && files=$(git diff --name-only --diff-filter=d 2>/dev/null)
  fi

  while IFS= read -r file; do
    [ -n "$file" ] || continue
    is_source "$file" || continue
    is_exempt "$file" && continue
    scan_file "$file" || findings=$((findings + 1))
  done <<EOF
$files
EOF

  if [ "$findings" -eq 0 ]; then
    echo pass
    return 0
  fi
  return 1
}

run_probe "${1:-.}"
