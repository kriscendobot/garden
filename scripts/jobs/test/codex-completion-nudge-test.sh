#!/bin/bash
# codex-completion-nudge-test.sh — the cleric handler's bounded in-process
# completion nudge (designs/non-claude-completion-nudge-parity.md): a codex run
# that exits 0 WITHOUT the completion marker is resumed ONCE in the same handler
# process via `codex exec resume <sid>` with the honest continue framing; a failed
# nudge restores the first report and the ordinary requeue; the unfinished
# end-turn marker gives the next same-host claim the continue framing.
# Hermetic: a throwaway git garden root, a fake `codex` on PATH, no network.
# shellcheck disable=SC2015
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PROJECT_ROOT="$(cd "$JOBS/../.." && pwd)"
HANDLER="$JOBS/handlers/cleric-codex.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS + 1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }

# Scrub a live worker's exports so the fixture cannot touch a deployed clone.
# shellcheck disable=SC2046
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1
mkdir -p "$PROJECT_ROOT/scratch"
TR="$(mktemp -d "$PROJECT_ROOT/scratch/garden-codex-nudge.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
BIN="$TR/bin"; mkdir -p "$BIN"

# The fake codex speaks just enough of the 0.156.0 surface the handler drives:
# `login status`, `exec` (fresh) and `exec resume <sid> <...>` — both of which
# parse --output-last-message for the report path, emit a session id and a
# terminal token_count event on the --json stream, and take the prompt as the
# final positional argument. FAKE_CODEX_MARKER_FROM_CALL=N makes every call
# before the Nth end cleanly WITHOUT the marker (the stopped-not-finished shape);
# FAKE_CODEX_NUDGE_FAIL=1 makes any `exec resume` call fail hard.
cat > "$BIN/codex" <<'EOF'
#!/bin/bash
set -euo pipefail
: "${FAKE_CODEX_RECORD:?}"
if [ "${1:-}" = login ] && [ "${2:-}" = status ]; then
  printf '%s\n' login >> "$FAKE_CODEX_RECORD"
  exit 0
fi
calls=0; [ -f "$FAKE_CODEX_RECORD.calls" ] && calls="$(cat "$FAKE_CODEX_RECORD.calls" 2>/dev/null || echo 0)"
calls=$((calls + 1)); printf '%s\n' "$calls" > "$FAKE_CODEX_RECORD.calls"
out=""; prev=""
for a in "$@"; do
  [ "$prev" = --output-last-message ] && out="$a"
  prev="$a"
done
args=("$@")
printf '%s' "${args[-1]}" > "$FAKE_CODEX_RECORD.prompt.$calls"
if [ "${1:-}" = exec ] && [ "${2:-}" = resume ]; then
  printf 'resume %s\n' "${3:-}" >> "$FAKE_CODEX_RECORD"
  if [ "${FAKE_CODEX_NUDGE_FAIL:-0}" = 1 ]; then
    printf '%s\n' '{"type":"error","message":"resume exploded"}'
    exit 9
  fi
else
  printf '%s\n' fresh >> "$FAKE_CODEX_RECORD"
fi
printf '%s\n' '{"type":"session.created","session_id":"11111111-2222-4333-8444-555555555555"}'
printf '%s\n' '{"payload":{"type":"token_count","info":{"last_token_usage":{"input_tokens":100,"cached_input_tokens":40,"output_tokens":10}}}}'
if [ -n "$out" ]; then
  if [ "$calls" -ge "${FAKE_CODEX_MARKER_FROM_CALL:-1}" ]; then
    printf 'codex did the work\n%s\n' '<<<GARDEN-JOB-COMPLETE>>>' > "$out"
  else
    printf 'codex did the work but stopped\n' > "$out"
  fi
fi
exit 0
EOF
chmod +x "$BIN/codex"

# A REAL throwaway git garden root, so worker_ensure_worktree can create genuine
# per-job git worktrees (the unfinished-end-turn marker lives in the worktree's
# private git admin dir and needs one).
FAKE_ROOT="$TR/root"
mkdir -p "$FAKE_ROOT/roles/gardener"
printf '%s\n' '# Gardener fixture role' > "$FAKE_ROOT/roles/gardener/AGENT.md"
git -C "$FAKE_ROOT" init -q
git -C "$FAKE_ROOT" -c user.name=test -c user.email=t@localhost add -A
git -C "$FAKE_ROOT" -c user.name=test -c user.email=t@localhost commit -qm init
git -C "$FAKE_ROOT" branch -M main2
JOB="$TR/job.md"
printf '%s\n' '---' 'role: gardener' '---' 'exercise the codex completion nudge' > "$JOB"

run_handler() { # <base>
  local base="$1"
  rm -f "$TR/calls" "$TR/calls.calls" "$TR"/calls.prompt.* 2>/dev/null
  set +e
  PATH="$BIN:$PATH" GARDEN=testhost GARDEN_ROOT="$FAKE_ROOT" GARDEN_STATE="$TR/state" \
    GARDEN_SCRATCH="$TR/scratch" GARDEN_MAIN_BRANCH=main2 GARDEN_WORKER_KIND=cleric \
    GARDEN_COMPLETION_SENTINEL="$TR/$base.sentinel" GARDEN_USAGE_FILE="$TR/$base.usage" \
    FAKE_CODEX_RECORD="$TR/calls" \
    FAKE_CODEX_MARKER_FROM_CALL="${FAKE_CODEX_MARKER_FROM_CALL:-}" \
    FAKE_CODEX_NUDGE_FAIL="${FAKE_CODEX_NUDGE_FAIL:-}" \
    GARDEN_COMPLETION_NUDGES="${GARDEN_COMPLETION_NUDGES:-}" \
    GARDEN_APPLIED_HANDLER_BUDGET="${GARDEN_APPLIED_HANDLER_BUDGET:-}" \
    "$HANDLER" "$base" "$JOB" "$TR/$base.report" > "$TR/$base.capture" 2>&1
  RUN_RC=$?
  set -e
}

echo 'NUDGE COMPLETES: markerless end-turn resumes the same session and finishes'
FAKE_CODEX_MARKER_FROM_CALL=2 run_handler nudge-done
[ "$RUN_RC" -eq 0 ] && ok "handler exits 0" || bad "handler exited $RUN_RC: $(tail -3 "$TR/nudge-done.capture")"
[ "$(cat "$TR/calls.calls" 2>/dev/null)" = 2 ] && ok "exactly ONE in-process nudge call" \
  || bad "expected 2 codex calls, saw $(cat "$TR/calls.calls" 2>/dev/null)"
grep -q '^resume 11111111-2222-4333-8444-555555555555$' "$TR/calls" \
  && ok "nudge resumed the parsed session id via codex exec resume" || bad "resume call/sid missing: $(cat "$TR/calls")"
grep -q 'CONTINUING garden job' "$TR/calls.prompt.2" 2>/dev/null && ok "nudge carries the honest continue framing" \
  || bad "nudge prompt lacks continue framing"
[ -e "$TR/nudge-done.sentinel" ] && ok "nudge completion gates the sentinel" || bad "sentinel missing"
grep -q '<<<GARDEN-JOB-COMPLETE>>>' "$TR/nudge-done.report" \
  && bad "marker leaked into human report" || ok "marker stripped from report"
if jq -e '.input_tokens==120 and .output_tokens==20 and .cache_read_tokens==80 and .completion_nudges==1' \
    "$TR/nudge-done.usage" >/dev/null 2>&1; then
  ok "both calls' measured token rows summed into one handoff"
else
  bad "summed usage wrong: $(cat "$TR/nudge-done.usage" 2>/dev/null || echo MISSING)"
fi
[ ! -e "$TR/state/clerics/sessions/nudge-done" ] && ok "completion retires the session sidecar" \
  || bad "sidecar survived completion"

echo 'NUDGES DISABLED: GARDEN_COMPLETION_NUDGES=0 preserves the plain requeue'
GARDEN_COMPLETION_NUDGES=0 FAKE_CODEX_MARKER_FROM_CALL=99 run_handler nudge-off
[ "$RUN_RC" -eq 0 ] && [ "$(cat "$TR/calls.calls" 2>/dev/null)" = 1 ] \
  && ok "nudge disabled: exactly one codex call, rc=0" || bad "rc=$RUN_RC calls=$(cat "$TR/calls.calls" 2>/dev/null)"
[ ! -e "$TR/nudge-off.sentinel" ] && ok "markerless run withholds sentinel (requeue)" || bad "sentinel forged"
off_marker="$(git -C "$TR/scratch/gardener-wt-nudge-off" rev-parse --absolute-git-dir 2>/dev/null)/garden-unfinished-end-turn"
[ -e "$off_marker" ] && ok "unfinished-end-turn marker recorded" || bad "unfinished marker absent"

echo 'WALL FLOOR: insufficient remaining handler time skips the nudge'
GARDEN_APPLIED_HANDLER_BUDGET=5 FAKE_CODEX_MARKER_FROM_CALL=99 run_handler nudge-time
[ "$(cat "$TR/calls.calls" 2>/dev/null)" = 1 ] && ok "under the wall-time floor: one codex call" \
  || bad "nudge ran despite insufficient remaining wall time"
grep -q 'remaining handler wall time under' "$TR/nudge-time.capture" \
  && ok "wall-floor skip is logged" || bad "wall-floor log missing"

echo 'FAILED NUDGE: first report restored, ordinary requeue, continue framing next'
FAKE_CODEX_NUDGE_FAIL=1 FAKE_CODEX_MARKER_FROM_CALL=99 run_handler nudge-fail
[ "$RUN_RC" -eq 0 ] && ok "failed nudge restores the clean-markerless outcome (rc=0 requeue)" \
  || bad "failed nudge leaked rc=$RUN_RC"
grep -q 'codex did the work but stopped' "$TR/nudge-fail.report" && ok "first session's report preserved" \
  || bad "first report lost"
grep -q 'completion nudge failed: rc=9' "$TR/nudge-fail.report" && ok "failed nudge annotated in report" \
  || bad "failed-nudge annotation missing"
[ ! -e "$TR/nudge-fail.sentinel" ] && [ -s "$TR/state/clerics/sessions/nudge-fail" ] \
  && ok "failed nudge retains resumable sidecar and withholds sentinel" \
  || bad "failed nudge broke sidecar/sentinel contract"
if grep -qx fresh "$TR/calls" && [ "$(grep -cx fresh "$TR/calls")" -gt 1 ]; then
  bad "failed nudge fell back to a fresh session"
else
  ok "failed nudge never falls back to a fresh session"
fi
# The next same-host claim (sidecar + worktree + marker survive) is framed continue.
FAKE_CODEX_MARKER_FROM_CALL=1 run_handler nudge-fail
[ "$RUN_RC" -eq 0 ] && [ -e "$TR/nudge-fail.sentinel" ] && ok "continued claim completes" \
  || bad "continued claim rc=$RUN_RC / sentinel missing"
grep -q 'CONTINUING garden job' "$TR/calls.prompt.1" 2>/dev/null \
  && ok "requeued claim after a clean stop is framed as continue" || bad "continue framing missing on requeue"
grep -q '^resume ' "$TR/calls" && ok "requeued claim resumes the session" || bad "requeue did not resume"

echo "codex-completion-nudge-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
