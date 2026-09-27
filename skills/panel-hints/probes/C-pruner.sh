#!/bin/bash
# C-pruner — fires the pruner on an added multi-line prose comment in code.
# The shape is intentionally only a candidate signal: the pruner decides whether
# the comment contributes a non-obvious invariant/rationale or merely narrates the
# adjacent operation. Markdown additions remain B-pruner's path signal.
set -uo pipefail

BASE=${BASE:-origin/master}
scan_mode="diff"
if [ "${1:-}" = "--scan-stdin" ]; then
  scan_mode=stdin
elif [ "${1:-}" = "--staged" ]; then
  scan_mode=staged
elif [ "$#" -gt 0 ]; then
  echo "C-pruner: unknown option: $1" >&2
  exit 64
fi

# Avoid listing the same seat twice when a substantial Markdown change already
# fires B-pruner. The comment signal is still inspected by the dispatched seat.
if [ "$scan_mode" = diff ] && [ "${PRUNER_SKIP_IF_MARKDOWN:-1}" = 1 ]; then
  markdown_probe="$(cd "$(dirname "$0")" && pwd)/B-pruner.sh"
  if [ -x "$markdown_probe" ] && [[ "$(BASE="$BASE" "$markdown_probe" 2>/dev/null)" == fire\ pruner* ]]; then
    echo "skip pruner"
    exit 0
  fi
fi

added_lines() {
  case "$scan_mode" in
    stdin)
      awk '{ print "<stdin>\t" NR "\t" $0 }'
      ;;
    staged)
      git diff --staged -U0 -- \
        '*.js' '*.mjs' '*.cjs' '*.jsx' '*.ts' '*.tsx' \
        '*.rs' '*.c' '*.cc' '*.cpp' '*.h' '*.hpp' '*.java' '*.go' '*.py' '*.sh' 2>/dev/null |
        diff_added_lines
      ;;
    diff)
      git diff "$BASE...HEAD" -U0 -- \
        '*.js' '*.mjs' '*.cjs' '*.jsx' '*.ts' '*.tsx' \
        '*.rs' '*.c' '*.cc' '*.cpp' '*.h' '*.hpp' '*.java' '*.go' '*.py' '*.sh' 2>/dev/null |
        diff_added_lines
      ;;
  esac
}

diff_added_lines() {
  awk '
    /^\+\+\+ / {
      path=$0
      sub(/^\+\+\+ b\//, "", path)
      sub(/^\+\+\+ /, "", path)
      print "<break>\t0\t"
      next
    }
    /^@@/ {
      h=$0
      sub(/^@@ -[0-9,]+ \+/, "", h)
      sub(/[, ].*/, "", h)
      newline=h+0
      print "<break>\t0\t"
      next
    }
    /^\+[^+]/ {
      print path "\t" newline "\t" substr($0, 2)
      newline++
      next
    }
    /^ / { newline++; print "<break>\t0\t"; next }
    /^-/ { print "<break>\t0\t"; next }
  '
}

# Three prose-bearing lines is a deliberately loose signal for a comment that
# deserves a concision read. Blank separators, tag-only JSDoc lines, lint/tool
# directives, and shebangs do not contribute to the threshold.
added_lines | awk -F '\t' '
  function reset_group() {
    count=0
    start=0
    group_path=""
    scan_mode=""
  }
  function emit_if_candidate() {
    if (count >= 3) {
      printf "fire pruner %s:%d (+%d-line prose comment) — decide whether it adds a non-obvious invariant or rationale; require deletion if it only narrates adjacent code\n", group_path, start, count
      found=1
      exit
    }
    reset_group()
  }
  function prose(text, cleaned) {
    cleaned=text
    sub(/^[[:space:]]*(\/\/\/?|\/\*+|\*+|#)[[:space:]]*/, "", cleaned)
    sub(/[[:space:]]*\*\/[[:space:]]*$/, "", cleaned)
    if (cleaned !~ /[[:alpha:]]/) return 0
    if (cleaned ~ /^(@[[:alpha:]]|eslint-|prettier-|ts-(ignore|expect-error)|istanbul |c8 |spell-out-)/) return 0
    if (cleaned ~ /^!\//) return 0
    return 1
  }
  function begin(path, line, kind) {
    count=0
    start=line
    group_path=path
    scan_mode=kind
  }
  {
    path=$1
    line=$2+0
    text=$3
    if (path == "<break>") {
      emit_if_candidate()
      next
    }
    trimmed=text
    sub(/^[[:space:]]*/, "", trimmed)

    if (scan_mode == "block") {
      if (prose(text)) count++
      if (text ~ /\*\//) emit_if_candidate()
      next
    }

    if (trimmed ~ /^\/\// || trimmed ~ /^#[^!]/) {
      if (scan_mode != "line" || path != group_path) {
        emit_if_candidate()
        begin(path, line, "line")
      }
      if (prose(text)) count++
      next
    }

    if (trimmed ~ /^\/\*/) {
      emit_if_candidate()
      begin(path, line, "block")
      if (prose(text)) count++
      if (text ~ /\*\//) emit_if_candidate()
      next
    }

    emit_if_candidate()
  }
  END {
    if (!found && count >= 3) {
      printf "fire pruner %s:%d (+%d-line prose comment) — decide whether it adds a non-obvious invariant or rationale; require deletion if it only narrates adjacent code\n", group_path, start, count
      found=1
    }
    if (!found) print "skip pruner"
  }
'
