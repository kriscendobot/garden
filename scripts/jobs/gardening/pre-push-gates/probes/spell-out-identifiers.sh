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
#   * 2026-09-22 recurrence: #1329 added `openTestDb`/`db` (segment `db`) in
#     packages/daemon/test/registry-endo.test.js — a panelled miss the stylist
#     let through because `db` was on neither the blocklist here nor the stylist
#     brief's example list, and the identifiers mirror an established
#     `openTestDb`/`db` convention in the sibling endo.test.js. Maintainer:
#     "expand the abbreviation to Database". Added `db:database` below. NOTE: a
#     product/platform name whose uppercase run spells DB — `IndexedDB`,
#     `LevelDB`, `MongoDB` — now fires as a segment `db`; that is a rare
#     false-positive in this daemon codebase (its own store is spelled
#     `manager-database`), waivable via the `spell-out-exempt` marker per the
#     probe's documented bias-toward-firing.
#   * 2026-10-23 style-gap sweep: `err` in
#     packages/ses/scripts/generate-test-xs.js and `ctor`, `prop`, `ok`, and `c`
#     in the SES text-codec tests bypassed the curated blocklist. These names
#     have direct spelled-out forms: error, constructor, property, success, and
#     character.
#   * 2026-10-25 false positive: endojs/endo-but-for-bots#1538 shimmed the XS
#     host global `hostReadDir` in a test. That name is the Rust host ABI's
#     (rust/endo/xsnap/src/host_aliases.js), declared ambient in the base's
#     packages/daemon/src/bus-xs-host-globals.d.ts; the PR cannot rename it. An
#     identifier the PRE-CHANGE tree declares ambient in a `.d.ts`
#     (`declare var|let|const|function NAME`) is an external binding, not a
#     freshly-authored name, so it is exempt. Only the pre-change tree counts: a
#     PR that adds its own ambient declaration still has its new names checked.
#     A local helper that merely mirrors an abbreviated sibling (#1329's
#     `openTestDb`) is not an ambient declaration and still fires.
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
#       SPELL_OUT_AMBIENT (space-separated names) stands in for the ambient set.
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
      split("dir:directory cmd:command temp:temporary tmp:temporary arg:argument args:arguments subdir:subdirectory cfg:configuration ctx:context idx:index msg:message btn:button impl:implementation mgr:manager num:number str:string val:value resp:response req:request addr:address db:database err:error ctor:constructor prop:property ok:success c:character", pairs, " ")
      for (p in pairs) { split(pairs[p], kv, ":"); BLOCK[kv[1]] = kv[2] }
      # Ambient host-ABI names the pre-change tree declares (space-separated).
      na = split(ENVIRON["SPELL_OUT_AMBIENT"], amb, " ")
      for (a = 1; a <= na; a++) AMBIENT[amb[a]] = 1
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
      if (id in AMBIENT) return
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
  if [ -n "${PRE_PUSH_BASE_REF:-}" ]; then
    diff=$(git diff -U0 "$PRE_PUSH_BASE_REF"...HEAD -- "$f" 2>/dev/null)
  else
    diff=$(git diff --staged -U0 -- "$f" 2>/dev/null)
    [ -z "$diff" ] && diff=$(git diff -U0 -- "$f" 2>/dev/null)
  fi
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
  # Feed `head` from a here-string, not a `printf` pipe: under `pipefail` a
  # file longer than the head window makes `printf` exit 141 (SIGPIPE) and the
  # pipeline report failure even though `grep -q` matched, silently voiding the
  # exemption for exactly the large files most likely to need it.
  head -5 <<<"$content" | grep -q 'spell-out-exempt'
}

run_probe() {
  local root="${1:-.}"
  cd "$root" 2>/dev/null || { echo "fail: cannot enter project root '$root'"; return 1; }

  local files
  if [ -n "${PRE_PUSH_BASE_REF:-}" ]; then
    files=$(git diff "$PRE_PUSH_BASE_REF"...HEAD --name-only --diff-filter=d 2>/dev/null)
  else
    files=$(git diff --staged --name-only --diff-filter=d 2>/dev/null)
    [ -z "$files" ] && files=$(git diff --name-only --diff-filter=d 2>/dev/null)
  fi

  # Ambient declarations in the PRE-CHANGE tree's `.d.ts` files: the merge
  # base under PRE_PUSH_BASE_REF, else HEAD (staged/unstaged diffs are on top of
  # HEAD). These are external bindings the change did not coin.
  local ambient_tree=HEAD
  if [ -n "${PRE_PUSH_BASE_REF:-}" ]; then
    ambient_tree=$(git merge-base "$PRE_PUSH_BASE_REF" HEAD 2>/dev/null) \
      || ambient_tree="$PRE_PUSH_BASE_REF"
  fi
  SPELL_OUT_AMBIENT=$(
    git grep -h -E '^[[:space:]]*declare[[:space:]]+(var|let|const|function)[[:space:]]' \
      "$ambient_tree" -- '*.d.ts' 2>/dev/null \
      | sed -E 's/^[[:space:]]*declare[[:space:]]+(var|let|const|function)[[:space:]]+([A-Za-z_$][A-Za-z0-9_$]*).*/\2/' \
      | grep -E '^[A-Za-z_$][A-Za-z0-9_$]*$' | sort -u | tr '\n' ' '
  )
  export SPELL_OUT_AMBIENT

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
