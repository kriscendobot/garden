#!/bin/bash
# detect-home-coupling-test.sh — validate the deterministic workstation-coupling
# detector (gardening/detect-home-coupling.sh).
#
# Asserts the contract:
#   1. HIT: an added line containing the current $HOME exits 0 (check) and the
#      offending line is reported by `lines`.
#   2. NO-HIT: a clean change exits 1 (check) and `lines` prints nothing.
#   3. ADDED-LINES-ONLY: a home path that is REMOVED (in a `-` line) or only in
#      pre-existing/context lines is NOT a hit — only NEW coupling counts.
#   4. $HOME IS DYNAMIC: the same fixture that hits under one $HOME is CLEAN under
#      a different $HOME (the detector keys off the live environment, never a
#      hardcoded literal), and hits again under that other $HOME's own path.
#   5. A `$HOME` VARIABLE reference (the portable form) is NOT a hit — only the
#      EXPANDED literal path is.
#   6. No base ref → clean & quiet (exit 1); empty $HOME → clean & quiet.
#
# Hermetic: throwaway git repos, a synthetic $HOME, no network, no systemd. The
# test itself hardcodes no real home path — it builds every fixture from the
# synthetic $HOME it sets, so it is clean under the very detector it exercises.

# The ok/bad idiom is the intended A && pass || fail (SC2015, safe: ok never
# fails); the single-quoted $HOME fixtures must NOT expand (SC2016) — they are the
# portable-form lines the detector must treat as clean. Both are deliberate.
# shellcheck disable=SC2015,SC2016
set -uo pipefail
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DET="$(cd "$HERE/../gardening" && pwd)/detect-home-coupling.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/dhc-test.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

# Two synthetic homes — neither is the real machine's $HOME, so this test adds no
# real-home literal of its own.
HOME_A="$TR/home/devalice"
HOME_B="$TR/home/devbob"

# make_repo <dir> — a git repo with one committed base file.
make_repo() {
  local dir="$1"
  mkdir -p "$dir"; git -C "$dir" init -q
  git -C "$dir" config user.email t@localhost; git -C "$dir" config user.name test
  printf 'base line\n' > "$dir/file.sh"
  git -C "$dir" add -A; git -C "$dir" commit -qm base >/dev/null
}
# commit_change <dir> <new-file-contents...> — overwrite file.sh and commit.
commit_change() {
  local dir="$1"; shift
  printf '%s\n' "$@" > "$dir/file.sh"
  git -C "$dir" add -A; git -C "$dir" commit -qm change >/dev/null
}

# --- 1: HIT — an added line hardcoding $HOME -------------------------------
R1="$TR/hit"; make_repo "$R1"
commit_change "$R1" "base line" "clone_dir=$HOME_A/journal"
HOME="$HOME_A" "$DET" check "$R1" >/dev/null 2>&1 \
  && ok "check: added line with \$HOME exits 0 (coupling found)" || bad "check missed an added home-coupling line"
l1="$(HOME="$HOME_A" "$DET" lines "$R1" 2>/dev/null)"
{ printf '%s' "$l1" | grep -qF "$HOME_A/journal" && printf '%s' "$l1" | grep -qF 'file.sh'; } \
  && ok "lines: reports the offending path and added text" || bad "lines did not report the offending line ($l1)"

# --- 2: NO-HIT — a clean change -------------------------------------------
R2="$TR/clean"; make_repo "$R2"
commit_change "$R2" "base line" 'clone_dir="$HOME/journal"'
HOME="$HOME_A" "$DET" check "$R2" >/dev/null 2>&1 \
  && bad "check false-positive on a clean change" || ok "check: clean change exits 1 (quiet)"
[ -z "$(HOME="$HOME_A" "$DET" lines "$R2" 2>/dev/null)" ] \
  && ok "lines: clean change prints nothing" || bad "lines leaked on a clean change"

# --- 3: ADDED-LINES-ONLY — pre-existing / removed coupling is NOT a hit ----
# Base already contains the home literal; the change REMOVES it. A `-` line and a
# surviving context line must not be flagged — only NEW (`+`) coupling counts.
R3="$TR/removed"; mkdir -p "$R3"; git -C "$R3" init -q
git -C "$R3" config user.email t@l; git -C "$R3" config user.name t
printf 'keep me\nclone_dir=%s/old\n' "$HOME_A" > "$R3/file.sh"
git -C "$R3" add -A; git -C "$R3" commit -qm base >/dev/null
printf 'keep me\nclone_dir="$HOME/old"\n' > "$R3/file.sh"   # rewrite to portable form
git -C "$R3" add -A; git -C "$R3" commit -qm port >/dev/null
HOME="$HOME_A" "$DET" check "$R3" >/dev/null 2>&1 \
  && bad "check flagged a REMOVED home literal (not added-lines-only)" \
  || ok "check: removed/context home literal is NOT a hit (added-lines-only)"

# --- 4: $HOME IS DYNAMIC ---------------------------------------------------
# R1's added line hardcodes HOME_A. Under HOME_B it must be CLEAN; HOME_B's own
# path added to a fresh repo must hit. Proves the key is the live $HOME, not a
# baked-in literal.
HOME="$HOME_B" "$DET" check "$R1" >/dev/null 2>&1 \
  && bad "HOME_A fixture wrongly hit under HOME_B (detector not dynamic)" \
  || ok "dynamic: HOME_A coupling is CLEAN under a different \$HOME"
R4="$TR/hit-b"; make_repo "$R4"
commit_change "$R4" "base line" "state=$HOME_B/.garden-state"
HOME="$HOME_B" "$DET" check "$R4" >/dev/null 2>&1 \
  && ok "dynamic: HOME_B coupling hits under HOME_B (keys off the live \$HOME)" \
  || bad "detector did not key off the alternate \$HOME"

# --- 5: the $HOME VARIABLE form is portable, not a hit ---------------------
R5="$TR/varform"; make_repo "$R5"
commit_change "$R5" "base line" 'p="$HOME/journal"' 'q=${HOME}/state'
HOME="$HOME_A" "$DET" check "$R5" >/dev/null 2>&1 \
  && bad "check flagged the portable \$HOME variable form" \
  || ok "check: \$HOME variable reference (portable) is NOT a hit"

# --- 6: no base / empty HOME → clean & quiet -------------------------------
R6="$TR/nobase"; mkdir -p "$R6"; git -C "$R6" init -q
git -C "$R6" config user.email t@l; git -C "$R6" config user.name t
printf 'only commit %s\n' "$HOME_A" > "$R6/file.sh"
git -C "$R6" add -A; git -C "$R6" commit -qm only >/dev/null   # no HEAD~1
HOME="$HOME_A" "$DET" check "$R6" >/dev/null 2>&1 \
  && bad "check hit with no resolvable base" || ok "check: unresolvable base → clean & quiet (exit 1)"
HOME="" "$DET" check "$R1" >/dev/null 2>&1 \
  && bad "check hit with empty \$HOME" || ok "check: empty \$HOME → clean & quiet (exit 1)"

echo "----------------------------------------------------------------"
echo "detect-home-coupling: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
