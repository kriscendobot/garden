#!/bin/bash
# mentor-provider-order-test.sh — provider fallback and fail-closed output tests.
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
HANDLER="$JOBS/handlers/mentor-claude.sh"
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS + 1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-mentor-provider.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
BIN="$TR/bin"; mkdir -p "$BIN" "$TR/state" "$TR/clone"
ln -s "$HERE/foreman-provider-fake-codex.sh" "$BIN/codex"
ln -s "$HERE/foreman-provider-fake-curl.sh" "$BIN/curl"
ln -s "$HERE/foreman-provider-fake-claude.sh" "$BIN/claude"
chmod +x "$HERE"/foreman-provider-fake-{codex,curl,claude}.sh "$HANDLER"
SHA=deadbeef
BARE="$TR/journal.git"; SEED="$TR/seed"
git init -q --bare "$BARE"; git init -q "$SEED"; git -C "$SEED" checkout -q -b journal2
mkdir -p "$SEED/jobs/todo" "$SEED/jobs/doin" "$SEED/jobs/tada" "$SEED/jobs/plan" "$SEED/jobs/index"
touch "$SEED/jobs/todo/.gitkeep" "$SEED/jobs/doin/.gitkeep" "$SEED/jobs/tada/.gitkeep" "$SEED/jobs/plan/.gitkeep" "$SEED/jobs/index/.gitkeep"
git -C "$SEED" add -A; git -C "$SEED" -c user.name=test -c user.email=test@localhost commit -q -m seed
git -C "$SEED" remote add origin "$BARE"; git -C "$SEED" push -q -u origin journal2

run_handler() { # <order> [environment assignments...]
  local order="$1"; shift
  env PATH="$BIN:$PATH" HOME="$TR/home" GARDEN_ROOT="$ROOT" GARDEN_STATE="$TR/state" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 GARDEN_NO_MAINTAINER_ALERT=1 GARDEN_TOKEN_WEEKLY_QUOTA=0 \
    GARDEN_MENTOR_PROVIDER_ORDER="$order" "$@" "$HANDLER" "$SHA" "$TR/clone"
}

echo 'SUBTEST 1 — Claude quota advances to Codex/OpenAI'
LOG1="$TR/log1"
if run_handler anthropic,openai GARDEN_TEST_PROVIDER_LOG="$LOG1" GARDEN_TEST_ANTHROPIC_RC=1 \
  GARDEN_TEST_OPENAI_OUTPUT='JOB improve-codex\nscripts/jobs/example.sh\nmake retry bounded\nENDJOB\n'; then
  VERIFY1="$TR/verify1"; git clone -q --branch journal2 "$BARE" "$VERIFY1"
  [ -f "$VERIFY1/jobs/todo/improve-codex.md" ] && ok "Claude failure falls through to a valid Codex response" || bad "Codex job was not posted"
else bad "Claude quota did not fall through to Codex"; fi
[ "$(tr '\n' ' ' < "$LOG1")" = 'anthropic openai ' ] && ok "attempted Claude then OpenAI" || bad "wrong trace: $(tr '\n' ' ' < "$LOG1")"

rm -rf "$TR/state"; mkdir -p "$TR/state"
echo 'SUBTEST 2 — unavailable providers traverse configured order'
LOG2="$TR/log2"
if run_handler openai,local,anthropic GARDEN_TEST_PROVIDER_LOG="$LOG2" GARDEN_TEST_CODEX_LOGIN_RC=1 GARDEN_TEST_LOCAL_CURL_RC=1 \
  GARDEN_TEST_ANTHROPIC_OUTPUT='JOB improve-claude\nscripts/jobs/other.sh\nmake failure visible\nENDJOB\n'; then
  VERIFY2="$TR/verify2"; git clone -q --branch journal2 "$BARE" "$VERIFY2"
  [ -f "$VERIFY2/jobs/todo/improve-claude.md" ] && ok "unavailable Codex/local providers reach Claude" || bad "Claude fallback job was not posted"
else bad "unavailable provider traversal failed"; fi
[ "$(tr '\n' ' ' < "$LOG2")" = 'local-preflight local-preflight anthropic ' ] && ok "unavailable providers were each skipped once" || bad "wrong traversal: $(tr '\n' ' ' < "$LOG2")"

rm -rf "$TR/state"; mkdir -p "$TR/state"
echo 'SUBTEST 3 — all unavailable fails without a decision'
if run_handler openai,local,anthropic GARDEN_TEST_CODEX_LOGIN_RC=1 GARDEN_TEST_LOCAL_CURL_RC=1 GARDEN_TEST_ANTHROPIC_RC=1 >"$TR/all.out" 2>"$TR/all.err"; then
  bad "all unavailable providers unexpectedly succeeded"
else grep -q 'no configured mentor inference provider was available' "$TR/all.err" && ok "all unavailable reports no provider" || bad "missing all-unavailable diagnostic"; fi

rm -rf "$TR/state"; mkdir -p "$TR/state"
echo 'SUBTEST 4 — malformed semantic output never asks another model'
LOG4="$TR/log4"
if run_handler openai,anthropic GARDEN_TEST_PROVIDER_LOG="$LOG4" GARDEN_TEST_OPENAI_OUTPUT='JOB one\nscripts/jobs/a.sh\nreason\nENDJOB\ntrailing prose\n' >"$TR/malformed.out" 2>"$TR/malformed.err"; then
  bad "malformed output was accepted"
else ok "malformed output is rejected"; fi
[ "$(tr '\n' ' ' < "$LOG4")" = 'openai ' ] && ok "semantic rejection did not solicit Claude" || bad "malformed output fanned out: $(tr '\n' ' ' < "$LOG4")"

echo 'SUBTEST 5 — injected handler and stable identity prevent duplicate posting'
for n in 1 2; do
  env PATH="$BIN:$PATH" HOME="$TR/home" GARDEN_ROOT="$ROOT" GARDEN_STATE="$TR/injected-state" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
    GARDEN_MENTOR_PROVIDER_ORDER=anthropic GARDEN_MENTOR_CLAUDE=claude GARDEN_TOKEN_WEEKLY_QUOTA=0 \
    GARDEN_TEST_ANTHROPIC_OUTPUT='JOB improve-injected\nscripts/jobs/stable.sh\nfix it\nENDJOB\n' "$HANDLER" "$SHA" "$TR/clone" >/dev/null
done
VERIFY="$TR/verify"; git clone -q --branch journal2 "$BARE" "$VERIFY"
[ "$(find "$VERIFY/jobs/todo" -name 'improve-injected.md' | wc -l)" -eq 1 ] \
  && ok "injected handler posts one stable mentor identity" || bad "injected handler duplicated a job"

# --- Accepted-shape regression: well-formed replies the old validator wrongly
# rejected (each FATALed a good mentor tick) must now be accepted. A JOB shape
# posts its block; a no-op shape exits 0 and posts nothing. Paths are chosen to
# NOT exist in origin/main2 so already_fixed_pending_deploy never suppresses them.
shape_n=0
run_shape() { # <anthropic-output-with-\n-escapes>  → handler exit code
  shape_n=$((shape_n + 1))
  env PATH="$BIN:$PATH" HOME="$TR/home" GARDEN_ROOT="$ROOT" GARDEN_STATE="$TR/shape-$shape_n" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 GARDEN_NO_MAINTAINER_ALERT=1 GARDEN_TOKEN_WEEKLY_QUOTA=0 \
    GARDEN_MENTOR_PROVIDER_ORDER=anthropic GARDEN_MENTOR_CLAUDE=claude \
    GARDEN_TEST_ANTHROPIC_OUTPUT="$1" "$HANDLER" "$SHA" "$TR/clone" 2>"$TR/shape-$shape_n.err"
}
posted() { # <slug>  → 0 if a job with that base is on the board
  local slug="$1" v="$TR/vshape-$shape_n"
  rm -rf "$v"; git clone -q --branch journal2 "$BARE" "$v"
  find "$v/jobs" -name "$slug.md" 2>/dev/null | grep -q .
}

echo 'SUBTEST 6 — lone trailing newline (codex empty flush) is a no-op, not a FATAL'
if run_shape '\n'; then ok "lone newline accepted as no-op"; else bad "lone newline FATALed"; fi

echo 'SUBTEST 7 — prose refusal is a no-op and is WARN-logged, not a FATAL'
if run_shape 'No clear opportunities.\n'; then ok "prose refusal accepted as no-op"; else bad "prose refusal FATALed"; fi
grep -q 'WARN: mentor reply had no JOB block' "$TR/shape-$shape_n.err" && ok "prose refusal is surfaced at WARN" || bad "prose refusal was not WARN-logged"

echo 'SUBTEST 8 — a valid block followed by a blank line is accepted and posted'
if run_shape 'JOB improve-shape-a\nscripts/jobs/zzz-shape-a.sh\nreason\nENDJOB\n\n' && posted improve-shape-a; then
  ok "trailing blank line after a complete block is tolerated"; else bad "valid block + blank line was rejected"; fi

echo 'SUBTEST 9 — two blocks separated by a blank line are both posted'
if run_shape 'JOB improve-shape-b\nscripts/jobs/zzz-shape-b.sh\nr\nENDJOB\n\nJOB improve-shape-c\nscripts/jobs/zzz-shape-c.sh\nr\nENDJOB\n' \
  && posted improve-shape-b && posted improve-shape-c; then
  ok "blank-separated blocks are both accepted"; else bad "blank-separated blocks were rejected"; fi

echo 'SUBTEST 10 — a prose preamble before a block is skipped and the block posts'
if run_shape 'Here is one clear opportunity.\n\nJOB improve-shape-d\nscripts/jobs/zzz-shape-d.sh\nr\nENDJOB\n' && posted improve-shape-d; then
  ok "preamble sentence before a block is tolerated"; else bad "preamble + block was rejected"; fi

echo 'SUBTEST 11 — a ``` fence wrapping the block is skipped and the block posts'
if run_shape '```\nJOB improve-shape-e\nscripts/jobs/zzz-shape-e.sh\nr\nENDJOB\n```\n' && posted improve-shape-e; then
  ok "surrounding code fence is tolerated"; else bad "fenced block was rejected"; fi

echo 'SUBTEST 12 — a decorated first-line path (- `path`) is normalized and posts'
if run_shape 'JOB improve-shape-f\n- `scripts/jobs/zzz-shape-f.sh`\nr\nENDJOB\n' && posted improve-shape-f; then
  ok "list/backtick-decorated path is accepted"; else bad "decorated path was rejected"; fi

echo 'SUBTEST 13 — a widened first-line extension (.service/.timer/.md) is accepted'
if run_shape 'JOB improve-shape-g\nscripts/systemd/zzz-shape-g.service\nr\nENDJOB\n' && posted improve-shape-g; then
  ok ".service first-line path is accepted"; else bad ".service path was rejected"; fi
if run_shape 'JOB improve-shape-i\nroles/zzz-shape/AGENT.md\nr\nENDJOB\n' && posted improve-shape-i; then
  ok ".md first-line path is accepted"; else bad ".md path was rejected"; fi

echo 'SUBTEST 14 — leading/trailing whitespace on the JOB line is tolerated'
if run_shape '  JOB improve-shape-h  \nscripts/jobs/zzz-shape-h.sh\nr\nENDJOB\n' && posted improve-shape-h; then
  ok "whitespace around the JOB slug is tolerated"; else bad "whitespaced JOB line was rejected"; fi

echo 'SUBTEST 15 — an unterminated block still fails closed and records a diagnostic'
if run_shape 'JOB improve-broken\nscripts/jobs/zzz-broken.sh\nno ENDJOB here\n' >/dev/null 2>&1; then
  bad "unterminated block was accepted"; else ok "unterminated block still FATALs (fail-closed)"; fi
[ -s "$TR/shape-$shape_n/mentor/last-malformed.txt" ] && ok "malformed reply is saved to mentor/last-malformed.txt" || bad "malformed diagnostic was not recorded"

echo 'SUBTEST 16 — three decorated first-line variants normalize to ONE identity (mentor:scripts/jobs/<path>)'
# Backtick-wrapped, list-marker, and trailing-whitespace forms of the SAME path must
# each normalize to `scripts/jobs/zzz-norm.sh`. Each is emitted under a DISTINCT JOB
# slug but resolves to identity mentor:scripts/jobs/zzz-norm.sh, so post-job.sh's
# directive dedup collapses all three onto ONE landed job — proving the shared
# normalizer makes the poster agree with the validator on every decorated form.
norm_ok=1
run_shape 'JOB improve-norm-tick\n`scripts/jobs/zzz-norm.sh`\nr\nENDJOB\n'  || norm_ok=0
run_shape 'JOB improve-norm-dash\n- scripts/jobs/zzz-norm.sh\nr\nENDJOB\n' || norm_ok=0
run_shape 'JOB improve-norm-trail\nscripts/jobs/zzz-norm.sh \nr\nENDJOB\n' || norm_ok=0
[ "$norm_ok" -eq 1 ] && ok "all three decorated variants were accepted (no FATAL)" || bad "a decorated variant FATALed"
NV="$TR/vnorm"; rm -rf "$NV"; git clone -q --branch journal2 "$BARE" "$NV"
landed="$(find "$NV/jobs" \( -name 'improve-norm-tick.md' -o -name 'improve-norm-dash.md' -o -name 'improve-norm-trail.md' \) 2>/dev/null | wc -l)"
[ "$landed" -eq 1 ] && ok "three decorated variants collapse onto one mentor:scripts/jobs/zzz-norm.sh identity" || bad "expected 1 job for the shared identity, found $landed"

echo 'SUBTEST 17 — the FATAL diagnostic names the reject reason and quotes an excerpt of the rejected output'
run_shape 'JOB improve-diag\nscripts/jobs/zzz-diag.sh\nUNIQUEMARKERXYZ trailing garbage that is never closed\n' >/dev/null 2>&1 || true
DIAG_ERR="$TR/shape-$shape_n.err"; DIAG_FILE="$TR/shape-$shape_n/mentor/last-malformed.txt"
grep -qi 'unterminated block' "$DIAG_ERR" && ok "FATAL log names the validator reject reason" || bad "FATAL log lacks the reject reason"
grep -q 'UNIQUEMARKERXYZ' "$DIAG_ERR" && ok "FATAL log quotes an excerpt of the rejected output" || bad "FATAL log lacks a raw-output excerpt"
{ [ -s "$DIAG_FILE" ] && grep -q 'UNIQUEMARKERXYZ' "$DIAG_FILE"; } && ok "last-malformed.txt captures reason + excerpt" || bad "diagnostic file missing the excerpt"

echo 'SUBTEST 18 — a prose-only reply with no JOB line is a no-op that posts nothing'
# Distinct from SUBTEST 7 (which asserts success + the WARN): here we prove the no-op
# path posts NOTHING to the board, so a "no clear opportunities" tick can never mint a
# job. Count job files before and after a fresh no-op run against the shared journal.
count_jobs() { local v="$TR/vcount"; rm -rf "$v"; git clone -q --branch journal2 "$BARE" "$v"; find "$v/jobs" -name '*.md' 2>/dev/null | wc -l; }
noop_before="$(count_jobs)"
if run_shape 'No actionable opportunities this tick.\n'; then ok "prose-only reply succeeds as a no-op"; else bad "prose-only reply FATALed"; fi
noop_after="$(count_jobs)"
[ "$noop_before" = "$noop_after" ] && ok "prose-only no-op posted nothing (board unchanged at $noop_before)" || bad "prose-only no-op posted a job ($noop_before -> $noop_after)"

echo 'SUBTEST 19 — a rejection writes a per-failure raw capture to the durable rejected/ path'
run_shape 'JOB improve-durable\nscripts/jobs/zzz-durable.sh\nDURABLEMARKER unterminated capture\n' >/dev/null 2>&1 || true
REJ_DIR="$TR/shape-$shape_n/mentor/rejected"
DURABLE_CAP="$(find "$REJ_DIR" -name '*-anthropic.txt' 2>/dev/null | head -1)"
{ [ -n "$DURABLE_CAP" ] && grep -q 'DURABLEMARKER' "$DURABLE_CAP"; } \
  && ok "rejection saved a per-failure capture under rejected/ carrying the raw output" \
  || bad "durable rejected/ capture missing or lacking the raw output"

echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
