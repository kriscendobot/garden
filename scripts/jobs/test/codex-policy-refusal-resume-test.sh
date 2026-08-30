#!/bin/bash
# codex-policy-refusal-resume-test.sh -- a terminal provider policy refusal from
# `codex exec resume` must reach gardener.sh unchanged. It must NOT be overwritten
# by the handler's ordinary fresh-session fallback for an unusable resume id.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PROJECT_ROOT="$(cd "$JOBS/../.." && pwd)"
HANDLER="$JOBS/handlers/cleric-codex.sh"
FIXTURE="$HERE/fixtures/codex-policy-refusal-resume.jsonl"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS + 1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }

# A live worker exports these. Scrub them so the fixture cannot touch a deployed
# clone or inherit a real provider credential/configuration.
# shellcheck disable=SC2046
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1
mkdir -p "$PROJECT_ROOT/scratch"
TR="$(mktemp -d "$PROJECT_ROOT/scratch/garden-codex-policy-resume.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
BIN="$TR/bin"; mkdir -p "$BIN"
cat > "$BIN/codex" <<'EOF'
#!/bin/bash
set -euo pipefail
: "${FAKE_CODEX_RECORD:?}"
if [ "${1:-}" = login ] && [ "${2:-}" = status ]; then
  printf '%s\n' login >> "$FAKE_CODEX_RECORD"
  exit 0
fi
if [ "${1:-}" = exec ] && [ "${2:-}" = resume ]; then
  printf '%s\n' resume >> "$FAKE_CODEX_RECORD"
  if [ "${FAKE_CODEX_MODE:-policy}" = policy ]; then
    cat "${FAKE_CODEX_FIXTURE:?}"
  else
    printf '%s\n' '{"type":"error","message":"session id expired"}'
  fi
  exit 1
fi
if [ "${1:-}" = exec ]; then
  printf '%s\n' fresh >> "$FAKE_CODEX_RECORD"
  printf '%s\n' '{"type":"error","message":"fresh fallback reached"}'
  exit 23
fi
printf 'unexpected fake codex argv: %q\n' "$*" >&2
exit 64
EOF
chmod +x "$BIN/codex"

# The handler only needs an existing directory to preserve a resumed worktree. A
# minimal fake garden root supplies the role brief used to construct the prompt;
# no network, production journal, or real garden checkout is involved.
FAKE_ROOT="$TR/root"
mkdir -p "$FAKE_ROOT/roles/gardener" "$TR/state/clerics/sessions" "$TR/scratch"
printf '%s\n' '# Gardener fixture role' > "$FAKE_ROOT/roles/gardener/AGENT.md"
JOB="$TR/job.md"
printf '%s\n' '---' 'role: gardener' '---' 'exercise Codex resume handling' > "$JOB"

run_handler() { # <base> <mode>
  local base="$1" mode="$2" worktree
  worktree="$TR/scratch/gardener-wt-$base"
  mkdir -p "$worktree"
  printf '%s\n' '019c5e64-ec43-70c3-bdbd-653a9f60c250' > "$TR/state/clerics/sessions/$base"
  : > "$TR/$base.calls"
  set +e
  PATH="$BIN:$PATH" GARDEN=testhost GARDEN_ROOT="$FAKE_ROOT" GARDEN_STATE="$TR/state" \
    GARDEN_SCRATCH="$TR/scratch" GARDEN_MAIN_BRANCH=main2 GARDEN_WORKER_KIND=cleric \
    GARDEN_COMPLETION_SENTINEL="$TR/$base.sentinel" FAKE_CODEX_RECORD="$TR/$base.calls" \
    FAKE_CODEX_FIXTURE="$FIXTURE" FAKE_CODEX_MODE="$mode" \
    "$HANDLER" "$base" "$JOB" "$TR/$base.report" > "$TR/$base.capture" 2>&1
  RUN_RC=$?
  set -e
}

run_handler policy-resume policy
[ "$RUN_RC" -eq 1 ] && ok "terminal resume refusal retains the Codex failure status" || bad "terminal resume refusal exited $RUN_RC"
[ "$(grep -cx resume "$TR/policy-resume.calls" || true)" -eq 1 ] \
  && ok "policy fixture invoked exactly one resume" || bad "unexpected resume count: $(cat "$TR/policy-resume.calls")"
if grep -qx fresh "$TR/policy-resume.calls"; then
  bad "policy refusal wasted a fresh-session retry"
else
  ok "policy refusal skipped the fresh-session retry"
fi
if grep -qF 'flagged for possible cybersecurity risk' "$TR/policy-resume.capture" \
   && grep -qF 'Trusted Access for Cyber program' "$TR/policy-resume.capture"; then
  ok "failed resume diagnostic was preserved for gardener capture classification"
else
  bad "failed resume diagnostic was lost: $(tail -5 "$TR/policy-resume.capture")"
fi
grep -qF 'preserving the diagnostic and skipping the fresh-session retry' "$TR/policy-resume.capture" \
  && ok "handler names the terminal disposition" || bad "terminal disposition log missing"

# Control: only policy refusals are terminal. An ordinary expired/pruned session
# still takes the existing fresh-session fallback path.
run_handler expired-resume expired
[ "$RUN_RC" -eq 23 ] && ok "ordinary resume failure returns the fresh attempt status" || bad "ordinary resume fallback exited $RUN_RC"
[ "$(grep -cx fresh "$TR/expired-resume.calls" || true)" -eq 1 ] \
  && ok "ordinary resume failure still retries once in a fresh session" || bad "ordinary resume failure did not reach fresh fallback: $(cat "$TR/expired-resume.calls")"

echo "codex-policy-refusal-resume-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
