#!/bin/bash
# detect-catch-all-swallow-test.sh — validate the deterministic catch-all
# error-swallow detector (gardening/detect-catch-all-swallow.sh).
#
# Asserts the contract:
#   1. HIT: an added `catch (e) { return undefined }` in a code file exits 0
#      (check) and the offending opener is reported by `lines` with its path.
#   2. HIT: a bare `catch {}` (empty body) is a swallow.
#   3. HIT: a multi-line catch that only `return`s is a swallow.
#   4. NO-HIT: a catch that rethrows (`throw err`) is clean.
#   5. NO-HIT: a catch that narrows on class (`instanceof`) is clean.
#   6. NO-HIT: a catch that narrows on `.code` is clean.
#   7. NO-HIT: a catch that logs (`console.error`) is clean.
#   8. ADDED-LINES-ONLY: a REMOVED catch-all swallow is NOT a hit.
#   9. NOT-CODE: a swallow-looking line in a `.md` file is NOT scanned.
#  10. No base ref -> clean & quiet (exit 1).
#
# Hermetic: throwaway git repos, no network, no systemd. The test's own source is
# a `.sh` file (never a scanned CODE extension) and builds every catch fixture as
# a throwaway file, so it stays clean under the very detector it exercises.

# The ok/bad idiom is the intended A && pass || fail (SC2015, safe: ok never
# fails). Deliberate. SC2016: the markdown fixture's backticked `${...}`-free
# swallow text is a literal, no expansion wanted.
# shellcheck disable=SC2015,SC2016
set -uo pipefail
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DET="$(cd "$HERE/../gardening" && pwd)/detect-catch-all-swallow.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/dcas-test.XXXXXX")"
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

# --- 1: HIT — an added single-line swallow with a param --------------------
R1="$TR/hit"; make_repo "$R1" file.js
commit_lines "$R1" file.js 'const base = 1;' 'try { risky(); } catch (e) { return undefined; }'
"$DET" check "$R1" >/dev/null 2>&1 \
  && ok "check: added catch-all swallow exits 0 (swallow found)" || bad "check missed an added swallow"
l1="$("$DET" lines "$R1" 2>/dev/null)"
{ printf '%s' "$l1" | grep -qF 'file.js' && printf '%s' "$l1" | grep -q 'catch'; } \
  && ok "lines: reports the offending path and catch opener" || bad "lines did not report the swallow ($l1)"

# --- 2: HIT — a bare empty catch ------------------------------------------
R2="$TR/empty"; make_repo "$R2" file.ts
commit_lines "$R2" file.ts 'const base = 1;' 'try { risky(); } catch {}'
"$DET" check "$R2" >/dev/null 2>&1 \
  && ok "check: bare 'catch {}' is a swallow" || bad "check missed an empty catch"

# --- 3: HIT — a multi-line catch that only returns -------------------------
R3="$TR/multiline"; make_repo "$R3" file.mjs
commit_lines "$R3" file.mjs 'const base = 1;' 'function f() {' '  try {' '    risky();' \
  '  } catch (err) {' '    return false;' '  }' '}'
"$DET" check "$R3" >/dev/null 2>&1 \
  && ok "check: multi-line return-only catch is a swallow" || bad "check missed a multi-line swallow"

# --- 4: NO-HIT — a catch that rethrows ------------------------------------
R4="$TR/rethrow"; make_repo "$R4" file.js
commit_lines "$R4" file.js 'const base = 1;' 'try { risky(); } catch (err) { cleanup(); throw err; }'
"$DET" check "$R4" >/dev/null 2>&1 \
  && bad "check false-positive on a rethrowing catch" || ok "check: rethrow is NOT a swallow (quiet)"
[ -z "$("$DET" lines "$R4" 2>/dev/null)" ] \
  && ok "lines: rethrowing catch prints nothing" || bad "lines reported a clean rethrow"

# --- 5: NO-HIT — a catch that narrows on class -----------------------------
R5="$TR/instanceof"; make_repo "$R5" file.ts
commit_lines "$R5" file.ts 'const base = 1;' \
  'try { risky(); } catch (e) { if (e instanceof AbortError) return null; throw e; }'
"$DET" check "$R5" >/dev/null 2>&1 \
  && bad "check false-positive on an instanceof-narrowing catch" || ok "check: instanceof narrowing is NOT a swallow"

# --- 6: NO-HIT — a catch that narrows on .code -----------------------------
R6="$TR/code"; make_repo "$R6" file.js
commit_lines "$R6" file.js 'const base = 1;' \
  'try { readFileSync(p); } catch (e) { if (e.code === "ENOENT") return null; throw e; }'
"$DET" check "$R6" >/dev/null 2>&1 \
  && bad "check false-positive on a .code-narrowing catch" || ok "check: .code narrowing is NOT a swallow"

# --- 7: NO-HIT — a catch that logs ----------------------------------------
R7="$TR/logs"; make_repo "$R7" file.jsx
commit_lines "$R7" file.jsx 'const base = 1;' 'try { risky(); } catch (e) { console.error(e); }'
"$DET" check "$R7" >/dev/null 2>&1 \
  && bad "check false-positive on a logging catch" || ok "check: logging catch is NOT a swallow"

# --- 8: ADDED-LINES-ONLY — a REMOVED swallow is NOT a hit ------------------
R8="$TR/removed"; mkdir -p "$R8"; git -C "$R8" init -q
git -C "$R8" config user.email t@l; git -C "$R8" config user.name t
printf 'keep = 1;\ntry { risky(); } catch (e) { return undefined; }\n' > "$R8/file.js"
git -C "$R8" add -A; git -C "$R8" commit -qm base >/dev/null
printf 'keep = 1;\ntry { risky(); } catch (e) { console.error(e); throw e; }\n' > "$R8/file.js"
git -C "$R8" add -A; git -C "$R8" commit -qm narrow >/dev/null
"$DET" check "$R8" >/dev/null 2>&1 \
  && bad "check flagged a REMOVED swallow (not added-lines-only)" \
  || ok "check: removed swallow is NOT a hit (added-lines-only)"

# --- 9: NOT-CODE — a swallow-looking line in a .md file --------------------
R9="$TR/md"; make_repo "$R9" doc.md
commit_lines "$R9" doc.md '# Title' 'Example: `catch (e) { return undefined; }` swallows errors.'
"$DET" check "$R9" >/dev/null 2>&1 \
  && bad "check flagged a swallow inside a markdown file" || ok "check: markdown is NOT scanned (code files only)"

# --- 10: no base -> clean & quiet -----------------------------------------
R10="$TR/nobase"; mkdir -p "$R10"; git -C "$R10" init -q
git -C "$R10" config user.email t@l; git -C "$R10" config user.name t
printf 'first = 1;\ntry { risky(); } catch {}\n' > "$R10/file.js"
git -C "$R10" add -A; git -C "$R10" commit -qm only >/dev/null   # no HEAD~1
"$DET" check "$R10" >/dev/null 2>&1 \
  && bad "check hit with no resolvable base" || ok "check: unresolvable base -> clean & quiet (exit 1)"

echo "----------------------------------------------------------------"
echo "detect-catch-all-swallow: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
