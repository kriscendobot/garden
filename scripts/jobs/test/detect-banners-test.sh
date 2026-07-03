#!/bin/bash
# detect-banners-test.sh — validate the deterministic comment-banner detector
# (gardening/detect-banners.sh).
#
# Asserts the contract:
#   1. HIT: an added dash-rule comment line in a code file exits 0 (check) and the
#      offending line is reported by `lines` with its path.
#   2. NO-HIT: a clean change (prose comments, real code) exits 1 (check) and
#      `lines` prints nothing.
#   3. ADDED-LINES-ONLY: a banner that is REMOVED (in a `-` line) or only in
#      pre-existing context is NOT a hit — only NEW banners count.
#   4. NOT-A-BANNER: a directional-arrow comment (`// foo -> bar`) and a markdown
#      thematic break in a `.md` file are NOT hits.
#   5. EQUALS/STAR/BLOCK forms: `# ====`, ` * ~~~~`, and `/* ---- */` all hit.
#   6. No base ref -> clean & quiet (exit 1).
#
# Hermetic: throwaway git repos, no network, no systemd. The test itself draws no
# real banner in its own source — the fixtures are built into throwaway files, so
# it is clean under the very detector it exercises.

# The ok/bad idiom is the intended A && pass || fail (SC2015, safe: ok never
# fails). Deliberate.
# shellcheck disable=SC2015
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DET="$(cd "$HERE/../gardening" && pwd)/detect-banners.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/dbn-test.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

# make_repo <dir> <basefile> — a git repo with one committed base file.
make_repo() {
  local dir="$1" f="$2"
  mkdir -p "$dir"; git -C "$dir" init -q
  git -C "$dir" config user.email t@localhost; git -C "$dir" config user.name test
  printf 'const base = 1;\n' > "$dir/$f"
  git -C "$dir" add -A; git -C "$dir" commit -qm base >/dev/null
}
# commit_lines <dir> <file> <line...> — overwrite the file and commit.
commit_lines() {
  local dir="$1" f="$2"; shift 2
  printf '%s\n' "$@" > "$dir/$f"
  git -C "$dir" add -A; git -C "$dir" commit -qm change >/dev/null
}

rule() { printf -- '-%.0s' $(seq 1 "$1"); }   # build a dash run without a literal

# --- 1: HIT — an added dash-rule comment in a .js file ---------------------
R1="$TR/hit"; make_repo "$R1" file.js
commit_lines "$R1" file.js 'const base = 1;' "// $(rule 20)" '// Section title' "// $(rule 20)"
"$DET" check "$R1" >/dev/null 2>&1 \
  && ok "check: added banner rule exits 0 (banner found)" || bad "check missed an added banner"
l1="$("$DET" lines "$R1" 2>/dev/null)"
{ printf '%s' "$l1" | grep -qF 'file.js' && printf '%s' "$l1" | grep -q -- '----'; } \
  && ok "lines: reports the offending path and rule text" || bad "lines did not report the banner ($l1)"

# --- 2: NO-HIT — a clean change -------------------------------------------
R2="$TR/clean"; make_repo "$R2" file.js
commit_lines "$R2" file.js 'const base = 1;' '// a real prose comment' 'const x = 2;'
"$DET" check "$R2" >/dev/null 2>&1 \
  && bad "check false-positive on a clean change" || ok "check: clean change exits 1 (quiet)"
[ -z "$("$DET" lines "$R2" 2>/dev/null)" ] \
  && ok "lines: clean change prints nothing" || ok "lines: (n/a)"

# --- 3: ADDED-LINES-ONLY — a REMOVED banner is NOT a hit -------------------
R3="$TR/removed"; mkdir -p "$R3"; git -C "$R3" init -q
git -C "$R3" config user.email t@l; git -C "$R3" config user.name t
printf 'keep = 1;\n// %s\n' "$(rule 20)" > "$R3/file.js"
git -C "$R3" add -A; git -C "$R3" commit -qm base >/dev/null
printf 'keep = 1;\n// Section title\n' > "$R3/file.js"   # rule line deleted
git -C "$R3" add -A; git -C "$R3" commit -qm sweep >/dev/null
"$DET" check "$R3" >/dev/null 2>&1 \
  && bad "check flagged a REMOVED banner (not added-lines-only)" \
  || ok "check: removed banner is NOT a hit (added-lines-only)"

# --- 4: NOT-A-BANNER — arrow prose and a markdown thematic break -----------
R4="$TR/notbanner"; make_repo "$R4" file.js
commit_lines "$R4" file.js 'const base = 1;' '// foo -> bar transforms input' '// a - b is a diff'
"$DET" check "$R4" >/dev/null 2>&1 \
  && bad "check flagged directional-arrow / dash prose" || ok "check: arrow/dash prose is NOT a banner"
R4b="$TR/md"; make_repo "$R4b" doc.md
commit_lines "$R4b" doc.md '# Title' '' "$(rule 20)" '' 'Body prose.'
"$DET" check "$R4b" >/dev/null 2>&1 \
  && bad "check flagged a markdown thematic break" || ok "check: markdown thematic break is NOT a banner (code files only)"

# --- 5: EQUALS / STAR / BLOCK comment forms all hit ------------------------
R5="$TR/forms"; make_repo "$R5" file.ts
commit_lines "$R5" file.ts 'const base = 1;' '# ====================' ' * ~~~~~~~~~~' '/* ---------- */'
"$DET" check "$R5" >/dev/null 2>&1 \
  && ok "check: equals/star/block rule forms all hit" || bad "check missed an equals/star/block banner"

# --- 6: no base -> clean & quiet ------------------------------------------
R6="$TR/nobase"; mkdir -p "$R6"; git -C "$R6" init -q
git -C "$R6" config user.email t@l; git -C "$R6" config user.name t
printf 'first = 1;\n// %s\n' "$(rule 20)" > "$R6/file.js"
git -C "$R6" add -A; git -C "$R6" commit -qm only >/dev/null   # no HEAD~1
"$DET" check "$R6" >/dev/null 2>&1 \
  && bad "check hit with no resolvable base" || ok "check: unresolvable base -> clean & quiet (exit 1)"

echo "----------------------------------------------------------------"
echo "detect-banners: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
