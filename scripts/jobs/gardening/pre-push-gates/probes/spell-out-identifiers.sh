#!/bin/bash
# spell-out-identifiers.sh — pre-push-gate probe (skills/pre-push-gates § probes).
#
# Deterministic (no-LLM) detector for ABBREVIATED IDENTIFIERS in freshly-authored
# code. The maintainer (kriskowal) standing-rejects plainly-abbreviated names and
# asks, review after review, that they be spelled out in full — even when the
# abbreviation is unambiguous. A panelled PR let each of these through because the
# `stylist` seat reads for "crisp and unambiguous" names and the `ergonomist` for
# surface coherence, but NEITHER encodes a mechanical never-abbreviate check, and
# there was no gate. `no-latin-shorthand` governs Latin prose (i.e./e.g.), not
# identifiers; `rename-discipline` governs gratuitous renames. So an
# abbreviated-but-unambiguous identifier slipped every lens. This is the missing
# tier-1 gate that cannot be skipped or forgotten.
#
# Provenance (cluster review-misses/clusters/avoid-name-abbreviations.md):
#   * endojs/endo-but-for-bots#650: `dir` -> `directory`, `makeTempRoot` ->
#     `makeTemporaryRoot` (packages/daemon/test/mount-revocation.test.js) — two
#     panelled misses.
#   * endojs/endo-but-for-bots#609: `makeIntervalSchedulerCmd` ->
#     `makeIntervalScheduler` (packages/daemon/src/host.js): "Avoid
#     abbreviations... It isn't making a command" — the panelled miss that tripped
#     the review-retrospective floor at count=3 across 2 PRs.
#   * earlier confirmations: #592 `Arg` -> `pathComponent`/`segment`; #127
#     `subDir` -> spelled out.
#   * consolidated 2026-08-04 recurrence: #684 `listenAddr` ->
#     `listenAddress`; #806 `pendingIdx` was already covered by `idx`.
#
# HOW IT WORKS: for each ADDED line of a changed source file the probe strips
# string literals and comments (a char scanner that skips `//`, `/* */`, and
# quoted/template strings), extracts identifier tokens from the remaining code,
# splits each identifier into camelCase / PascalCase / snake_case / digit-boundary
# SEGMENTS, lowercases each segment, and fails if a whole segment is on the curated
# abbreviation blocklist. Segment-whole matching (not substring) is what keeps it
# low-false-positive: `directory` is one segment (never matches `dir`); the Node
# platform names `mkdtempSync` (segment `mkdtemp`) and `os.tmpdir()` (`tmpdir`)
# never match `temp`/`tmp`/`dir` because they carry no case boundary at the
# abbreviation; `interval` never matches `val`. Only a name that actually spells a
# segment as the abbreviation — `makeTempRoot` (`temp`), `dir`, `subDir` (`dir`),
# `makeIntervalSchedulerCmd` (`cmd`) — fires.
#
# NARROW BY DESIGN (skills/pre-push-gates § Pitfalls): the blocklist is curated and
# documented, scoped to source-language files, and matched only on whole segments;
# strings and comments are stripped so path literals (`/tmp/x`) and prose (`temp
# file`) do not fire. Per skills/pre-push-gates § Pitfalls the bias is still toward
# firing (a loose flag a human waives beats a silent miss) — the escape hatch for a
# file that legitimately must carry a domain abbreviation is a `spell-out-exempt`
# marker in its first five lines. NON-AUTO-FIXABLE (renaming an identifier is a
# judgment call touching every call site): fails the gate with one line per
# distinct (file, identifier, abbreviation) so the pushing step addresses it.
#
# Subcommands / usage:
#   spell-out-identifiers.sh [<project-root>]
#       Run as a gate probe over the staged diff (or, if nothing is staged, the
#       unstaged working-tree diff) rooted at <project-root> (default: cwd).
#       Prints `pass`, or one `fail: <path> ...` line per finding; exits 0/1.
#   spell-out-identifiers.sh --scan-stdin [<label>]
#       Scan added-code lines on stdin (for tests / demonstration): treat every
#       stdin line as an added line of a file named <label> (default `<stdin>`).
#       Prints `pass` or `fail:` lines; exits 0/1.
#   spell-out-identifiers.sh --segments <identifier>
#       Print the lowercased segments of one identifier (debug), space-separated.

set -uo pipefail

# The classifier: reads `<file>\t<added-line>` records on stdin, prints one
# `fail:` line per distinct (file, identifier, abbreviation), and `pass` with exit
# 0 when it finds nothing. All the abbreviation logic lives here.
classify() {
  awk -F '\t' '
    BEGIN {
      # Curated abbreviation blocklist: segment -> spelled-out suggestion. Start
      # from the observed set plus obvious siblings; keep it documented and
      # low-false-positive. Add here (and to the SKILL table) when a new
      # abbreviation trips a review.
      split("dir:directory cmd:command temp:temporary tmp:temporary arg:argument subdir:subdirectory cfg:configuration ctx:context idx:index msg:message btn:button impl:implementation mgr:manager num:number str:string val:value resp:response req:request addr:address", pairs, " ")
      for (p in pairs) { split(pairs[p], kv, ":"); BLOCK[kv[1]] = kv[2] }
      findings = 0
      sq = sprintf("%c", 39); bt = sprintf("%c", 96)
    }
    # scan_code — strip string literals and comments from a single line, returning
    # only the code text. A char scanner skips `//` line comments, `/* */` block
    # comments, and single/double/backtick string literals (dropping their
    # contents entirely). State resets per line: a `-U0` diff gives non-contiguous
    # added lines, so cross-line block/string state is not tracked (favoring a
    # false NEGATIVE over reading stale context).
    function scan_code(line,   n, i, c, d, out, instr, q, inblock) {
      n = length(line); i = 1; out = ""; instr = 0; q = ""; inblock = 0
      while (i <= n) {
        c = substr(line, i, 1); d = substr(line, i, 2)
        if (inblock) { if (d == "*/") { inblock = 0; i += 2 } else i++; continue }
        if (instr) { if (c == "\\") { i += 2; continue } if (c == q) instr = 0; i++; continue }
        if (d == "//") break
        if (d == "/*") { inblock = 1; i += 2; continue }
        if (c == "\"" || c == sq || c == bt) { instr = 1; q = c; i++; continue }
        out = out c; i++
      }
      return out
    }
    # segment — split an identifier into lowercased segments on `_`/`$`/digit
    # delimiters and lowercase->UPPER case boundaries. Fills arr[1..n], returns n.
    # An uppercase run stays whole (URL -> "url"); only a lower/digit->Upper edge
    # starts a new segment, so no blocklist entry needs acronym splitting.
    function segment(id, arr,   n, i, L, ch, cur, prevlower) {
      delete arr
      n = 0; cur = ""; prevlower = 0; L = length(id)
      for (i = 1; i <= L; i++) {
        ch = substr(id, i, 1)
        if (ch == "_" || ch == "$" || ch ~ /[0-9]/) {
          if (cur != "") { n++; arr[n] = tolower(cur); cur = "" }
          prevlower = 0
          continue
        }
        if (ch ~ /[A-Z]/) {
          if (cur != "" && prevlower) { n++; arr[n] = tolower(cur); cur = "" }
          cur = cur ch; prevlower = 0
        } else {
          cur = cur ch; prevlower = 1
        }
      }
      if (cur != "") { n++; arr[n] = tolower(cur) }
      return n
    }
    function check_ident(id, file,   arr, ns, j, s, key) {
      ns = segment(id, arr)
      for (j = 1; j <= ns; j++) {
        s = arr[j]
        if (s in BLOCK) {
          key = file SUBSEP id SUBSEP s
          if (!(key in seen)) {
            seen[key] = 1
            findings++
            printf "fail: %s adds abbreviated identifier `%s` (`%s` -> spell out, e.g. `%s`)\n", file, id, s, BLOCK[s]
          }
        }
      }
    }
    {
      file = $1
      line = substr($0, index($0, "\t") + 1)
      code = scan_code(line)
      # Extract identifier tokens from the stripped code.
      while (match(code, /[A-Za-z_$][A-Za-z0-9_$]*/)) {
        tok = substr(code, RSTART, RLENGTH)
        code = substr(code, RSTART + RLENGTH)
        check_ident(tok, file)
      }
    }
    END {
      if (findings == 0) { print "pass"; exit 0 }
      exit 1
    }
  '
}

# added_lines_for — emit `<file>\t<added-line>` records for one file's added lines
# in the staged diff (fall back to the unstaged diff when nothing is staged).
added_lines_for() {
  local f="$1"
  local diff
  diff=$(git diff --staged -U0 -- "$f" 2>/dev/null)
  [ -z "$diff" ] && diff=$(git diff -U0 -- "$f" 2>/dev/null)
  printf '%s\n' "$diff" \
    | grep '^+' | grep -v '^+++' | sed 's/^+//' \
    | awk -v f="$f" '{ print f "\t" $0 }'
}

# is_source — whether a path is a source-language file the probe scans.
is_source() {
  case "$1" in
    *.js|*.mjs|*.cjs|*.jsx|*.ts|*.tsx) return 0 ;;
    *) return 1 ;;
  esac
}

# is_exempt — a file that opts out with a `spell-out-exempt` marker in its first
# five lines (mirrors the non-ascii probe's per-file escape hatch).
is_exempt() {
  local f="$1" content
  content=$(git show ":$f" 2>/dev/null) || content=""
  [ -z "$content" ] && content=$(cat "$f" 2>/dev/null)
  printf '%s\n' "$content" | head -5 | grep -q 'spell-out-exempt'
}

run_probe() {
  local root="${1:-.}"
  cd "$root" 2>/dev/null || { echo "fail: cannot enter project root '$root'"; return 1; }

  local files
  files=$(git diff --staged --name-only --diff-filter=d 2>/dev/null)
  [ -z "$files" ] && files=$(git diff --name-only --diff-filter=d 2>/dev/null)

  # Build the combined `<file>\t<line>` stream, then classify once so `seen`
  # dedupes across the whole diff and the exit code is a single verdict.
  local stream
  stream=$(
    while IFS= read -r f; do
      [ -z "$f" ] && continue
      is_source "$f" || continue
      is_exempt "$f" && continue
      added_lines_for "$f"
    done <<EOF
$files
EOF
  )

  if [ -z "$stream" ]; then echo pass; return 0; fi
  printf '%s\n' "$stream" | classify
}

case "${1:-}" in
  --scan-stdin)
    label="${2:-<stdin>}"
    awk -v f="$label" '{ print f "\t" $0 }' | classify
    ;;
  --segments)
    shift
    printf '%s\n' "${1:?usage: --segments <identifier>}" \
      | awk '
          function segment(id, arr,   n, i, L, ch, cur, prevlower) {
            delete arr; n = 0; cur = ""; prevlower = 0; L = length(id)
            for (i = 1; i <= L; i++) {
              ch = substr(id, i, 1)
              if (ch == "_" || ch == "$" || ch ~ /[0-9]/) { if (cur != "") { n++; arr[n] = tolower(cur); cur = "" } prevlower = 0; continue }
              if (ch ~ /[A-Z]/) { if (cur != "" && prevlower) { n++; arr[n] = tolower(cur); cur = "" } cur = cur ch; prevlower = 0 }
              else { cur = cur ch; prevlower = 1 }
            }
            if (cur != "") { n++; arr[n] = tolower(cur) }
            return n
          }
          { ns = segment($0, a); out = ""; for (j = 1; j <= ns; j++) out = out (j > 1 ? " " : "") a[j]; print out }
        '
    ;;
  *)
    run_probe "${1:-.}"
    ;;
esac
