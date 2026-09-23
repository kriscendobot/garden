#!/bin/bash
# no-plain-reexport.sh — reject a NEWLY-INTRODUCED plain re-export that is not a
# `@deprecated` compatibility shim. The garden's re-export deprecation policy: a
# plain re-export (`export … from '…'`) must carry a `@deprecated` JSDoc pointing
# importers at the canonical original, and importers must be migrated to the
# original (see skills/re-export-deprecation-policy/SKILL.md). This is the
# AUTHOR-TIME preventive AND the jury seat's deterministic pre-pass — one detector,
# two callers (design § "there is exactly one detector").
#
# DETECTION PIPELINE (@kriskowal's Decision 3):
#   (a) a cheap heuristic grep for `export` as a bare word on the change's ADDED
#       lines, gating —
#   (b) a Babel full-parse (the vendored self-contained parser in the skill dir,
#       via reexport-parse.cjs) of the file BEFORE and AFTER, taking the set
#       difference of qualified value re-exports (after − before) so only NEWLY
#       introduced re-exports are candidates. A candidate not immediately preceded
#       by a `@deprecated` JSDoc block is a finding.
#   The jury seat (seat-gate-reexport-auditor.sh) is stage (c): a `claude -p`
#       adjudicates plain-vs-value-adding and deprecation adequacy on the
#       candidates this probe surfaces.
#
# DECISIONS honored:
#   1. barrels / index.js are NOT exempt — flagged like any other re-export.
#   2. compliant = a `@deprecated` JSDoc immediately preceding the re-export.
#   5. type-only re-exports are SKIPPED (`export type …`, `.d.ts` files).
# The per-file `reexport-policy-exempt` marker in the first five lines is the only
# escape hatch (mirrors no-inline-import-jsdoc's `inline-import-exempt`).
# Non-auto-fixable (complying needs importer migration + a message) — FAILS the gate.
#
# MODES (one script, three entry shapes):
#   no-plain-reexport.sh [<root>]            gate: print findings, exit 0 clean / 1 findings
#   no-plain-reexport.sh check  <wt> <base>  exit 0 candidates / 1 clean|no-base / 2 undetermined
#   no-plain-reexport.sh report <wt> <base>  print findings digest + `summary: …`; exit 0

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
: "${GARDEN_ROOT:=$(cd "$HERE/../../../../.." && pwd)}"
PARSER="${GARDEN_REEXPORT_PARSER:-$GARDEN_ROOT/skills/re-export-deprecation-policy/reexport-parse.cjs}"
NODE_BIN="${GARDEN_NODE_BIN:-node}"

is_source() {
  case "$1" in
    # Decision 5: `.d.ts` declaration files are type-only — never policed.
    *.d.ts) return 1 ;;
    *.js|*.mjs|*.cjs|*.jsx|*.ts|*.tsx|*.mts|*.cts) return 0 ;;
    *) return 1 ;;
  esac
}

have_node() { command -v "$NODE_BIN" >/dev/null 2>&1 && [ -r "$PARSER" ]; }

# --- git plumbing: after / before content + added lines ---------------------
# PRE_PUSH_BASE_REF set  -> compare BASE...HEAD (committed diff), after = worktree.
# else staged            -> compare HEAD vs index, after = staged blob.
# else unstaged          -> compare HEAD vs worktree, after = worktree file.
staged_diff_for() {
  local file="$1"
  if [ -n "${PRE_PUSH_BASE_REF:-}" ]; then
    git diff -U0 "$PRE_PUSH_BASE_REF"...HEAD -- "$file" 2>/dev/null; return
  fi
  if git diff --staged --quiet -- "$file" 2>/dev/null; then
    git diff -U0 -- "$file" 2>/dev/null
  else
    git diff --staged -U0 -- "$file" 2>/dev/null
  fi
}

after_content() {
  local file="$1"
  if [ -n "${PRE_PUSH_BASE_REF:-}" ]; then cat "$file" 2>/dev/null; return; fi
  if git diff --staged --quiet -- "$file" 2>/dev/null; then
    cat "$file" 2>/dev/null
  else
    git show ":$file" 2>/dev/null || cat "$file" 2>/dev/null
  fi
}

before_content() {
  local file="$1"
  if [ -n "${PRE_PUSH_BASE_REF:-}" ]; then
    git show "$PRE_PUSH_BASE_REF:$file" 2>/dev/null; return
  fi
  git show "HEAD:$file" 2>/dev/null   # empty when the file is newly added
}

changed_files() {
  if [ -n "${PRE_PUSH_BASE_REF:-}" ]; then
    git diff "$PRE_PUSH_BASE_REF"...HEAD --name-only --diff-filter=d 2>/dev/null
  else
    local staged
    staged=$(git diff --staged --name-only --diff-filter=d 2>/dev/null)
    if [ -n "$staged" ]; then printf '%s\n' "$staged"
    else git diff --name-only --diff-filter=d 2>/dev/null; fi
  fi
}

is_exempt() {
  local content
  content=$(after_content "$1")
  head -5 <<<"$content" | grep -q 'reexport-policy-exempt'
}

# Stage (a): does the change ADD a line bearing `export` as a bare word? Cheap
# gate — a genuinely new `export … from` always adds such a line, so a file with
# no added `export` word cannot have introduced a re-export and is not parsed.
added_export_word() {
  staged_diff_for "$1" | awk '
    /^\+\+\+/ { next }
    /^\+/     { if ($0 ~ /(^|[^[:alnum:]_$])export([^[:alnum:]_$]|$)/) { found=1 } }
    END { exit(found ? 0 : 1) }
  '
}

# Emit `<key>` lines for a source blob (before/after). Prints nothing on a parse
# failure and signals it via a marker line the caller can detect.
parse_keys() {  # $1=filename (for plugin selection); reads blob on stdin
  "$NODE_BIN" "$PARSER" "$1" 2>/dev/null
}

# Findings for one file, as `fail: <file>:<line> …`. Returns 0 = clean,
# 1 = at least one finding, 2 = undetermined (parse failure on AFTER).
scan_file() {
  local file="$1" after before after_json before_keys rc=0
  after="$(after_content "$file")"

  # AFTER parse. A helper exit 3 (unparseable) => undetermined for this file.
  after_json="$("$NODE_BIN" "$PARSER" "$file" <<<"$after" 2>/dev/null)"
  rc=$?
  [ "$rc" -eq 0 ] || return 2

  # No re-exports at all after the change -> nothing to police.
  [ -n "$after_json" ] || return 0

  before="$(before_content "$file")"
  if [ -n "$before" ]; then
    before_keys="$("$NODE_BIN" "$PARSER" "$file" <<<"$before" 2>/dev/null | sed -n 's/.*"key":"\(\([^"\\]\|\\.\)*\)".*/\1/p')"
  else
    before_keys=""   # newly added file: every re-export is new
  fi

  # For each AFTER descriptor whose key is NOT in the before set and which is NOT
  # a `@deprecated` shim, emit a finding.
  local findings=0 line
  while IFS= read -r line; do
    [ -n "$line" ] || continue
    local key form ln deprecated src
    key="$(sed -n 's/.*"key":"\(\([^"\\]\|\\.\)*\)".*/\1/p' <<<"$line")"
    ln="$(sed -n 's/.*"line":\([0-9]*\).*/\1/p' <<<"$line")"
    form="$(sed -n 's/.*"form":"\([a-z]*\)".*/\1/p' <<<"$line")"
    deprecated="$(grep -q '"deprecated":true' <<<"$line" && echo true || echo false)"
    [ "$deprecated" = true ] && continue
    # set membership: exact-line match against the before key set
    if [ -n "$before_keys" ] && grep -Fxq "$key" <<<"$before_keys"; then
      continue
    fi
    src="$(sed 's/^[a-z]*|//; s/|.*//' <<<"$key")"
    printf 'fail: %s:%s new plain %s re-export from %s%s%s lacks a @deprecated JSDoc pointing importers at the original; make it a deprecated compatibility shim and migrate importers, or mark the file reexport-policy-exempt\n' \
      "$file" "${ln:-0}" "$form" "'" "$src" "'"
    findings=$((findings + 1))
  done <<<"$after_json"

  [ "$findings" -eq 0 ] && return 0
  return 1
}

# Collect findings across the change. Echoes finding lines; sets globals
# COLLECT_FINDINGS (count) and COLLECT_UNDETERMINED (count of unparseable files).
collect() {
  local files file rc
  COLLECT_FINDINGS=0
  COLLECT_UNDETERMINED=0
  files="$(changed_files)"
  while IFS= read -r file; do
    [ -n "$file" ] || continue
    is_source "$file" || continue
    is_exempt "$file" && continue
    added_export_word "$file" || continue      # stage (a) gate
    scan_file "$file"; rc=$?
    case "$rc" in
      1) COLLECT_FINDINGS=$((COLLECT_FINDINGS + 1)) ;;
      2) COLLECT_UNDETERMINED=$((COLLECT_UNDETERMINED + 1)) ;;
    esac
  done <<EOF
$files
EOF
}

# --- gate mode --------------------------------------------------------------
run_gate() {
  local root="${1:-.}"
  cd "$root" 2>/dev/null || { echo "fail: cannot enter project root '$root'"; return 1; }
  if ! have_node; then
    # Never wedge a push on missing tooling: warn and pass. The review-time seat
    # still runs the same detector where node is present.
    echo "no-plain-reexport: node or vendored parser unavailable; skipping (review seat still covers this)" >&2
    echo pass
    return 0
  fi
  # collect runs in this command substitution (a subshell), so read its result
  # from stdout rather than the COLLECT_* globals it cannot export upward.
  local out count
  out="$(collect)"
  [ -n "$out" ] && printf '%s\n' "$out"
  count="$(printf '%s\n' "$out" | grep -c '^fail:' || true)"
  if [ "${count:-0}" -eq 0 ]; then
    echo pass
    return 0
  fi
  return 1
}

# --- seat pre-pass modes ----------------------------------------------------
# check: exit 0 candidate(s) / 1 clean-or-no-base / 2 undetermined (loud).
run_check() {
  local wt="${1:?worktree}" base="${2:-HEAD~1}" counts found undetermined
  have_node || { echo "no-plain-reexport: node or vendored parser unavailable" >&2; return 2; }
  git -C "$wt" rev-parse --verify -q "$base^{commit}" >/dev/null 2>&1 || return 1
  export PRE_PUSH_BASE_REF="$base"
  counts="$(cd "$wt" && collect >/dev/null; printf '%s %s\n' "$COLLECT_FINDINGS" "$COLLECT_UNDETERMINED")"
  found="${counts%% *}"
  undetermined="${counts##* }"
  if [ "${found:-0}" -gt 0 ]; then return 0; fi
  if [ "${undetermined:-0}" -gt 0 ]; then
    echo "no-plain-reexport: ${undetermined} changed file(s) could not be parsed" >&2
    return 2
  fi
  return 1
}

# report: print the findings digest plus a trailing summary count; exit 0.
run_report() {
  local wt="${1:?worktree}" base="${2:-HEAD~1}" out
  have_node || { echo "summary: 0 candidate(s) — parser unavailable"; return 0; }
  git -C "$wt" rev-parse --verify -q "$base^{commit}" >/dev/null 2>&1 || {
    echo "summary: 0 candidate(s) — no resolvable base"; return 0; }
  export PRE_PUSH_BASE_REF="$base"
  out="$(cd "$wt" && collect)"
  [ -n "$out" ] && printf '%s\n' "$out"
  local count files
  count="$(printf '%s\n' "$out" | grep -c '^fail:' || true)"
  [ -z "$out" ] && count=0
  files="$(printf '%s\n' "$out" | grep '^fail:' | sed 's/^fail: //; s/:.*//' | sort -u | grep -c . || true)"
  [ -z "$out" ] && files=0
  printf 'summary: %s candidate(s) across %s file(s)\n' "$count" "$files"
}

case "${1:-}" in
  check)  shift; run_check  "$@" ;;
  report) shift; run_report "$@" ;;
  gate)   shift; run_gate   "$@" ;;
  *)      run_gate "${1:-.}" ;;
esac
