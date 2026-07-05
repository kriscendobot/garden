#!/bin/bash
# producer-body-hang-test.sh — the inline-body stdin-hang guard on the producer
# primitives that read a body (journal-entry.sh, post-job.sh, post-plan.sh, and
# the sibling producers inbox-send.sh, send-msg.sh, maintainer-reply.sh,
# set-schedule.sh, set-schedule-once.sh).
#
# Regression for garden-harden-producer-body-read-hang (observed 2026-06-27): the
# body read had the shape
#     if   [ -n "$body_src" ] && [ -f "$body_src" ]; then cat "$body_src"
#     elif [ ! -t 0 ];                                then cat
#     else <placeholder>
# When a caller passes the body as an inline STRING in the body positional (not a
# file path) AND stdin is not a tty (every background / `claude -p` / systemd
# context), $body_src is non-empty but `[ -f "$body_src" ]` is false, so control
# falls to `[ ! -t 0 ]` and `cat` blocks on stdin that never closes. The script
# hangs forever holding the shared per-clone producer lock, wedging EVERY other
# gardener's post against that clone. A scholar idle cycle had to kill the tree
# and rm the stale lock by hand.
#
# The fix mirrors land-journal-edit.sh: a non-empty body arg that is not a file is
# a hard refusal, never a silent stdin fall-through. NEVER read stdin when a
# non-empty body arg was supplied.
#
# Asserts, for each of the three producers:
#   1. An inline non-file body arg with stdin redirected from /dev/null exits
#      PROMPTLY (wrapped in `timeout`; a hang would trip exit 124) and NON-ZERO
#      (the body-source refusal), naming the body-source error.
#   2. The refusal mints NOTHING (the journal head never moves).
# Plus the sibling --help/no-post guarantee the job folds in:
#   3. `journal-entry.sh --help` exits 0 and posts no entry.
#
# Hermetic: a throwaway bare journal; no real garden, journal, or network. The
# body-source guard fires before any clone/push, so even a regression cannot
# touch real state — but the fixture lets us assert the head stayed put.
#
# Usage: producer-body-hang-test.sh

# The ok/bad assertion idiom is the intended A && pass || fail (SC2015, safe
# because ok never fails).
# shellcheck disable=SC2015
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/producer-body-hang-test.XXXXXX")"
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
       GARDEN_STATE="$TR/state" GARDEN_PRODUCER_CLONE="$TR/state/producer/journal" \
       GARDEN=hanghost GARDEN_ROLE=gardener GARDEN_NO_MAINTAINER_ALERT=1
ohead() { git ls-remote "$BARE" refs/heads/journal2 | awk '{print $1}'; }

# --- 1+2: an inline non-file body arg never blocks, refuses, mints nothing ---
# The body positional is an inline STRING (not a path); stdin is /dev/null, so the
# pre-fix `cat`-on-stdin fall-through would block forever. `timeout 10` proves the
# guard fired instead of hanging: a real hang exits 124, the guard exits non-zero
# promptly.
echo "================================================================"
echo "BODY-HANG — inline non-file body arg + /dev/null stdin must not block"
echo "================================================================"
# name: how to invoke each producer with the body in the trailing positional.
run_inline() {  # run_inline <script> [pre-args...] -- ; fills $rc/$out
  local s="$1"; shift
  set +e
  out="$(timeout 10 "$JOBS/$s" "$@" "an inline body string, not a file path" </dev/null 2>&1)"
  rc=$?
  set -e
}
assert_inline() {  # assert_inline <label> <script> [pre-args...]
  local label="$1" s="$2"; shift 2
  local h0; h0="$(ohead)"
  run_inline "$s" "$@"
  [ "$rc" -ne 124 ] && ok "$label did not hang (timeout not tripped)" \
                    || bad "$label HUNG on stdin (timeout 124) — the read-hang regressed: $out"
  [ "$rc" -ne 0 ] && [ "$rc" -ne 124 ] && ok "$label exits non-zero (body refused)" \
                  || bad "$label did not refuse the inline body (rc=$rc): $out"
  grep -qi 'not a readable file' <<<"$out" && ok "$label names the body-source refusal" \
                                           || bad "$label printed no body-source error: $out"
  [ "$(ohead)" = "$h0" ] && ok "$label minted nothing (journal head unmoved)" \
                         || bad "$label moved the journal head ($h0 -> $(ohead))"
}
# journal-entry.sh <kind> <body> ; post-job.sh <basename> <body> ;
# post-plan.sh [opts] <basename> <body> — body is the trailing positional in each.
assert_inline "journal-entry.sh" journal-entry.sh progress
assert_inline "post-job.sh"      post-job.sh      body-hang-job-1
assert_inline "post-plan.sh"     post-plan.sh     body-hang-plan-1
# The sibling producers with the same body-read shape (guard ported 2026-07-05):
# inbox-send.sh <doer> <body> ; send-msg.sh <addr> <body> ;
# maintainer-reply.sh <msgid> <body> ; set-schedule.sh <name> <cadence>
# [prefix] <body> ; set-schedule-once.sh <name> <ISO> [prefix] <body>.
assert_inline "inbox-send.sh"        inbox-send.sh        body-hang-doer-1
assert_inline "send-msg.sh"          send-msg.sh          role/gardener
assert_inline "maintainer-reply.sh"  maintainer-reply.sh  body-hang-msg-1.md
assert_inline "set-schedule.sh"      set-schedule.sh      body-hang-sched-1 weekly body-hang-sched-1
assert_inline "set-schedule-once.sh" set-schedule-once.sh body-hang-once-1 2030-01-01T00:00:00Z body-hang-once-1

# --- 3: journal-entry.sh --help exits 0 and posts no entry -------------------
echo "================================================================"
echo "HELP — journal-entry.sh --help exits 0, posts nothing"
echo "================================================================"
h0="$(ohead)"
set +e; out="$(timeout 10 "$JOBS/journal-entry.sh" --help </dev/null 2>&1)"; rc=$?; set -e
{ [ "$rc" -eq 0 ] && grep -qi 'Usage:' <<<"$out"; } \
  && ok "journal-entry.sh --help prints usage and exits 0" \
  || bad "journal-entry.sh --help (rc=$rc) did not print usage cleanly: $out"
[ "$(ohead)" = "$h0" ] && ok "--help posted no entry (journal head unmoved)" \
                       || bad "--help moved the journal head ($h0 -> $(ohead))"

# ---------------------------------------------------------------------------
echo "----------------------------------------------------------------"
echo "producer-body-hang-test: PASS=$PASS FAIL=$FAIL"
[ "$FAIL" -eq 0 ]
