#!/bin/bash
# triager-claude-handler-test.sh — regression guard for the triage handler's
# change-summary step (handlers/triager-claude.sh).
#
# Regression: on the FIRST triage of any repo, `old` is empty. The handler used
# to build the git-log revision as "${old:+$old..$new}", which with an empty
# `old` degrades to git log "" → `fatal: ambiguous argument ''` (exit 128). With
# git's stderr swallowed by `2>/dev/null` and the handler under `set -euo
# pipefail`, that aborted the whole handler SILENTLY — wedging garden-triager@
# <slug> into a ~2-minute self-heal restart loop with an EMPTY failure blob.
#
# A second, related trap: the `| head -400` truncation of a large first-triage
# diff makes head close the pipe early, git dies of SIGPIPE (exit 141), and under
# pipefail that ALSO aborts the handler.
#
# The fix: use "${old:+$old..}$new" (empty old → log from $new alone, identical to
# the `range=` line) and cap the summary with `sed -n '1,400p'` instead of
# `head -400` — sed consumes the whole stream, so git reaches a clean exit and no
# SIGPIPE reaches pipefail (no blanket `|| true` masking real git failures). This
# test drives the real handler with a stub `claude` and asserts:
#   1. empty `old` (first triage) → handler exits 0 and the CHANGES block handed
#      to claude is NON-EMPTY.
#   2. a >400-line first-triage diff → handler still exits 0 (SIGPIPE guarded).
#   3. normal old..new range still summarizes the delta.
#
# Usage: triager-claude-handler-test.sh
set -euo pipefail
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
HANDLER="$JOBS/handlers/triager-claude.sh"
TR=/home/kris/.garden-triager-claude-handler-test
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Hermetic baseline: scrub any fleet GARDEN_*/JOURNAL_* the caller exported so a
# live gardener running this test cannot splice its own state underneath us.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true

rm -rf "$TR"; mkdir -p "$TR"
git_id=(-c user.name=test -c user.email=test@localhost)

# --- fixture repo: a bare-usable .git with a few commits ---------------------
REPO="$TR/repo"; git init -q "$REPO"
BARE="$REPO/.git"   # git --git-dir=<this> log works against a normal checkout
echo one > "$REPO/a.txt"; git -C "$REPO" add -A; git -C "$REPO" "${git_id[@]}" commit -q -m "first commit"
SHA1="$(git -C "$REPO" rev-parse HEAD)"
echo two >> "$REPO/a.txt"; git -C "$REPO" add -A; git -C "$REPO" "${git_id[@]}" commit -q -m "second commit"
SHA2="$(git -C "$REPO" rev-parse HEAD)"

# A commit touching >400 FILES, so `git log --stat` emits >400 lines and `head
# -400` closes the pipe early — the exact condition that makes git die of SIGPIPE
# (exit 141) and, under pipefail, would abort the handler unless the pipe is
# guarded. (A single large file yields only a handful of --stat lines, so it must
# be many files.)
mkdir -p "$REPO/many"
for i in $(seq 1 500); do echo "$i" > "$REPO/many/f$i"; done
git -C "$REPO" add -A; git -C "$REPO" "${git_id[@]}" commit -q -m "big commit"
SHABIG="$(git -C "$REPO" rev-parse HEAD)"

# --- stub `claude`: capture the prompt (with the CHANGES block) and emit no jobs
BIN="$TR/bin"; mkdir -p "$BIN"
CAP="$TR/prompt.txt"
cat > "$BIN/claude" <<EOF
#!/bin/bash
# args: -p --dangerously-skip-permissions <prompt>
printf '%s' "\${@: -1}" > "$CAP"
exit 0
EOF
chmod +x "$BIN/claude"

# Environment: real GARDEN_ROOT so common.sh + role_brief resolve; no journal is
# touched because the stub emits zero JOB blocks (post-job.sh never runs).
export GARDEN=testhost
export GARDEN_STATE="$TR/state"

# changes_block <capture-file> — extract the text between the CHANGES markers.
changes_block() { sed -n '/^----- CHANGES -----$/,/^----- END CHANGES -----$/p' "$1" | sed '1d;$d'; }

hr; echo "CASE 1: empty old (first triage) succeeds with a non-empty summary"
rm -f "$CAP"
if PATH="$BIN:$PATH" "$HANDLER" acme/widgets "" "$SHA2" "$BARE" >/dev/null 2>"$TR/err1"; then
  ok "handler exits 0 with empty old"
else
  bad "handler FAILED on empty old (rc=$?): $(cat "$TR/err1")"
fi
if [ -s "$CAP" ] && [ -n "$(changes_block "$CAP")" ]; then
  ok "CHANGES block non-empty on first triage"
else
  bad "CHANGES block EMPTY on first triage (the wedge signature)"
fi
if changes_block "$CAP" | grep -q "second commit"; then
  ok "first-triage summary spans full history (mentions latest commit)"
else
  bad "first-triage summary missing expected commit content"
fi

hr; echo "CASE 2: large (>400-line) first-triage diff — SIGPIPE guard holds"
rm -f "$CAP"
if PATH="$BIN:$PATH" "$HANDLER" acme/widgets "" "$SHABIG" "$BARE" >/dev/null 2>"$TR/err2"; then
  ok "handler exits 0 on a >400-line first-triage diff"
else
  bad "handler FAILED on large diff (rc=$?): $(cat "$TR/err2")"
fi
if [ -s "$CAP" ] && [ -n "$(changes_block "$CAP")" ]; then
  ok "CHANGES block non-empty for large diff"
else
  bad "CHANGES block EMPTY for large diff"
fi

hr; echo "CASE 3: normal old..new range summarizes the delta"
rm -f "$CAP"
if PATH="$BIN:$PATH" "$HANDLER" acme/widgets "$SHA1" "$SHA2" "$BARE" >/dev/null 2>"$TR/err3"; then
  ok "handler exits 0 on a normal range"
else
  bad "handler FAILED on normal range (rc=$?): $(cat "$TR/err3")"
fi
if changes_block "$CAP" | grep -q "second commit" && ! changes_block "$CAP" | grep -q "first commit"; then
  ok "range summary contains only the new delta (second, not first commit)"
else
  bad "range summary wrong: $(changes_block "$CAP" | head -5 | tr '\n' ' ')"
fi

hr
echo "PASS=$PASS FAIL=$FAIL"
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
