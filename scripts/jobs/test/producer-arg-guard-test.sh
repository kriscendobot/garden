#!/bin/bash
# producer-arg-guard-test.sh — the help + flag-shape guard on the producer
# primitives that take a leading positional (journal-entry.sh, post-job.sh,
# post-plan.sh).
#
# Regression for the malformed-entry bug: `journal-entry.sh --help` took the
# first positional verbatim as <kind> and committed an entry with `kind: --help`
# and an empty body to the add-only journal (observed:
# entries/2026/06/27/104604Z---help-gardener-f5074e.md). The fix intercepts
# -h/--help BEFORE consuming the positional and rejects a <kind>/<basename> that
# begins with '-' (and, for journal-entry, constrains the charset) so a flag typo
# can never become a committed entry/job. The same -h/--help + flag-shape guard is
# applied to the sibling producers post-job.sh and post-plan.sh.
#
# Asserts:
#   1. -h/--help on each script prints usage and exits 0, WITHOUT touching the
#      journal (no clone, no commit — the journal head never moves).
#   2. A flag-shaped leading positional ('--bogus') is rejected with a non-zero
#      exit and never minted as an entry/job.
#   3. journal-entry rejects an out-of-charset <kind> (uppercase / slash).
#   4. The happy path still works: a valid kind/basename posts exactly one entry/
#      job with well-formed frontmatter.
#
# Hermetic: a throwaway bare journal; no real garden, journal, or network.
#
# Usage: producer-arg-guard-test.sh

# The ok/bad assertion idiom is the intended A && pass || fail (SC2015, safe
# because ok never fails).
# shellcheck disable=SC2015
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/producer-guard-test.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

# Scrub any ambient fleet GARDEN_*/JOURNAL_* so a live gardener invoking this test
# cannot splice the real journal under it (the run-test.sh isolation rationale).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_)' || true) 2>/dev/null || true

# --- throwaway journal ------------------------------------------------------
BARE="$TR/journal.git"; git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"; git -C "$SEED" checkout -q -b journal2
( cd "$SEED"
  mkdir -p jobs/todo jobs/plan entries
  touch jobs/todo/.gitkeep jobs/plan/.gitkeep entries/.gitkeep
  git add -A
  git -c user.name=test -c user.email=test@localhost commit -q -m seed
  git remote add origin "$BARE"
  git push -q -u origin journal2 )

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
       GARDEN_STATE="$TR/state" GARDEN_HOST=guardhost GARDEN_NO_MAINTAINER_ALERT=1
ohead() { git ls-remote "$BARE" refs/heads/journal2 | awk '{print $1}'; }

# --- 1: -h/--help prints usage, exits 0, and does NOT touch the journal ------
H0="$(ohead)"
for spec in "journal-entry.sh:<kind>" "post-job.sh:<basename>" "post-plan.sh:plan/"; do
  s="${spec%%:*}"; needle="${spec##*:}"
  for flag in -h --help; do
    set +e; out="$("$JOBS/$s" "$flag" 2>&1)"; rc=$?; set -e
    { [ "$rc" -eq 0 ] && grep -qF "Usage:" <<<"$out" && grep -qF "$needle" <<<"$out"; } \
      && ok "$s $flag prints usage and exits 0" \
      || bad "$s $flag (rc=$rc) did not print usage cleanly: $out"
  done
done
[ "$(ohead)" = "$H0" ] && ok "help on all producers left the journal head unmoved (no clone/commit)" \
                       || bad "help moved the journal head ($H0 -> $(ohead))"

# --- 2: a flag-shaped leading positional is rejected, mints nothing ----------
H1="$(ohead)"
set +e; "$JOBS/journal-entry.sh" --bogus </dev/null >/dev/null 2>&1; je=$?
        "$JOBS/post-job.sh"      --bogus </dev/null >/dev/null 2>&1; pj=$?
        "$JOBS/post-plan.sh"     --bogus </dev/null >/dev/null 2>&1; pp=$?
set -e
{ [ "$je" -ne 0 ] && [ "$pj" -ne 0 ] && [ "$pp" -ne 0 ]; } \
  && ok "flag-shaped positional rejected (non-zero) on all three producers" \
  || bad "flag-shaped positional not rejected (je=$je pj=$pj pp=$pp)"
[ "$(ohead)" = "$H1" ] && ok "rejected flag args minted nothing (journal head unmoved)" \
                       || bad "a rejected flag arg still moved the head ($H1 -> $(ohead))"

# --- 3: journal-entry rejects an out-of-charset kind -------------------------
set +e; "$JOBS/journal-entry.sh" Progress </dev/null >/dev/null 2>&1; up=$?
        "$JOBS/journal-entry.sh" foo/bar  </dev/null >/dev/null 2>&1; sl=$?
        "$JOBS/journal-entry.sh" ''       </dev/null >/dev/null 2>&1; em=$?
set -e
{ [ "$up" -ne 0 ] && [ "$sl" -ne 0 ] && [ "$em" -ne 0 ]; } \
  && ok "journal-entry rejects uppercase/slash/empty kind" \
  || bad "out-of-charset kind not rejected (upper=$up slash=$sl empty=$em)"

# --- 4: the happy path still posts a well-formed entry/job/plan --------------
echo "test body"  | GARDEN_ROLE=gardener "$JOBS/journal-entry.sh" progress >/dev/null 2>&1 && je_ok=1 || je_ok=0
echo "job body"   |                       "$JOBS/post-job.sh" guard-job-1  >/dev/null 2>&1 && pj_ok=1 || pj_ok=0
echo "plan body"  |                       "$JOBS/post-plan.sh" --priority high guard-plan-1 >/dev/null 2>&1 && pp_ok=1 || pp_ok=0
V="$TR/v"; git clone -q --single-branch --branch journal2 "$BARE" "$V"
nentry=$(find "$V/entries" -name '*-progress-*.md' | wc -l | tr -d ' ')
kind="$(grep -h '^kind:' "$V"/entries/*/*/*/*.md 2>/dev/null | head -1)"
{ [ "$je_ok" -eq 1 ] && [ "$nentry" -eq 1 ] && [ "$kind" = "kind: progress" ]; } \
  && ok "valid kind 'progress' posts exactly one well-formed entry" \
  || bad "happy-path entry wrong (ok=$je_ok n=$nentry kind='$kind')"
{ [ "$pj_ok" -eq 1 ] && [ -f "$V/jobs/todo/guard-job-1.md" ]; } \
  && ok "valid basename posts a todo job" || bad "happy-path post-job failed (ok=$pj_ok)"
{ [ "$pp_ok" -eq 1 ] && [ -f "$V/jobs/plan/guard-plan-1.md" ]; } \
  && ok "valid basename posts a plan job" || bad "happy-path post-plan failed (ok=$pp_ok)"

# ---------------------------------------------------------------------------
echo "----------------------------------------------------------------"
echo "producer-arg-guard-test: PASS=$PASS FAIL=$FAIL"
[ "$FAIL" -eq 0 ]
