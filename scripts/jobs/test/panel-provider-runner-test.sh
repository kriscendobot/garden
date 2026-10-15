#!/bin/bash
# Provider selection and Codex foreperson schema enforcement, without model calls.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../../.." && pwd)"
PANEL="$ROOT/scripts/jobs/gardening/panel.sh"
LIB="$ROOT/scripts/jobs/gardening/panel-llm.sh"
PASS=0; FAIL=0
ok() { echo "PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "FAIL: $*"; FAIL=$((FAIL+1)); }

TR="$(mktemp -d "${TMPDIR:-/tmp}/panel-provider-runner.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
mkdir -p "$TR/bin" "$TR/wt"
ln -s "$HERE/panel-codex-stub.sh" "$TR/bin/codex"

# Direct runner selection: Anthropic keeps claude, OpenAI selects codex with the
# handler-equivalent sandbox/model/effort flags and stdin prompt transport.
# shellcheck source=../gardening/panel-llm.sh
source "$LIB"
cat >"$TR/bin/claude" <<'EOF'
#!/bin/bash
printf '%s\n' "$*" >>"${PANEL_CLAUDE_CALLS:?}"
printf '%s\n' 'anthropic-ok'
EOF
chmod +x "$TR/bin/claude"
export PATH="$TR/bin:$PATH" PANEL_CLAUDE_CALLS="$TR/claude.calls"
GARDEN_PANEL_PROVIDER=anthropic panel_llm sonnet '' prompt >/dev/null
grep -q -- '-p --model sonnet --dangerously-skip-permissions prompt' "$TR/claude.calls" \
  && ok 'Anthropic runner selects claude with historical argv shape' \
  || bad "Anthropic runner argv: $(cat "$TR/claude.calls" 2>/dev/null)"

export GARDEN_PANEL_PROVIDER=openai GARDEN_JOB_MODEL=gpt-5.6-sol GARDEN_JOB_EFFORT=high
export PANEL_CODEX_CALLS="$TR/codex.calls" PANEL_CODEX_PROMPTS="$TR/codex.prompts" PANEL_CODEX_SCHEMA_COPY="$TR/schema.copy"
panel_llm gpt-5.6-terra '' 'codex seat prompt' >/dev/null
grep -q -- 'exec --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check -m gpt-5.6-terra -c model_reasoning_effort=high -' "$TR/codex.calls" \
  && grep -q '^codex seat prompt$' "$TR/codex.prompts" \
  && ok 'OpenAI runner selects codex with model, effort, sandbox, and stdin prompt' \
  || bad "Codex runner call/prompt mismatch"

export GARDEN_JOB_EFFORT=ultra
panel_llm gpt-5.6-luna '' 'codex myrmidon prompt' >/dev/null
grep -q -- '-m gpt-5.6-luna -c model_reasoning_effort=max' "$TR/codex.calls" \
  && ok 'OpenAI runner clamps inherited effort to the seat model ladder' \
  || bad "Codex myrmidon effort was not clamped: $(tail -1 "$TR/codex.calls")"
export GARDEN_JOB_EFFORT=high

if PATH=/nonexistent GARDEN_PANEL_PROVIDER=openai panel_llm gpt-5.6-terra '' prompt >/dev/null 2>&1; then
  bad 'OpenAI runner did not fail closed without codex'
else
  ok 'OpenAI runner fails closed when codex is unavailable'
fi
if PATH=/nonexistent GARDEN_PANEL_PROVIDER=anthropic panel_llm sonnet '' prompt >/dev/null 2>&1; then
  bad 'Anthropic runner did not fail closed without claude'
else
  ok 'Anthropic runner fails closed when claude is unavailable'
fi

gate_failure=0
for gate in coverage-auditor orthographer procurer reexport-auditor thesaurus; do
  gate_file="$ROOT/scripts/jobs/gardening/seat-gate-$gate.sh"
  grep -q 'panel_llm ' "$gate_file" || gate_failure=1
  grep -v '^[[:space:]]*#' "$gate_file" | grep -Eq '(^|[[:space:]])claude([[:space:]]|$)' && gate_failure=1
done
[ "$gate_failure" -eq 0 ] \
  && ok 'Every cost-gated LLM seat routes through the shared provider runner' \
  || bad 'A cost-gated seat bypasses panel_llm'

# Drive the real foreperson path. Seat output is hooked, but the decider must call
# stub Codex with --output-schema and accept only schema-shaped JSON.
git init -q "$TR/wt"
printf 'base\n' >"$TR/wt/a"
git -C "$TR/wt" add a && git -C "$TR/wt" -c user.name=t -c user.email=t@t commit -qm base
printf 'change\n' >>"$TR/wt/a"
git -C "$TR/wt" add a && git -C "$TR/wt" -c user.name=t -c user.email=t@t commit -qm change

run_panel() {
  GARDEN_PANEL_PROVIDER=openai GARDEN_WORKER_KIND=cleric GARDEN_JOB_PROVIDER=openai \
  GARDEN_JOB_MODEL=gpt-5.6-sol GARDEN_CODE_SEATS=typist \
  GARDEN_PANEL_SEAT="$HERE/panel-parallel-fanout-stub.sh" \
  GARDEN_PANEL_APPELLATE=: GARDEN_PANEL_UNDRAFT=true GARDEN_PANEL_RECORD=: \
  GARDEN_PANEL_RELATED_DESIGN=: GARDEN_PANEL_PHASE_EVIDENCE=: \
  GARDEN_PANEL_PR_BODY_TEMPLATE=: GARDEN_PANEL_PR_BODY_CONCISION_PROBE=: \
  GARDEN_PANEL_BANNER_DETECT=: GARDEN_PANEL_DECOMPLECTOR_PROBE=: \
  GARDEN_PANEL_RUNDIR="$TR/run-$1" FAN_DIR="$TR/fan-$1" FAN_SLEEP=0 \
  bash "$PANEL" "$TR/wt" 42 HEAD~1
}

export PANEL_CODEX_STRUCTURED_OUTPUT='{"disposition":"pass"}'
out="$(run_panel good 2>"$TR/good.err")"; rc=$?
[ "$rc" -eq 0 ] && printf '%s' "$out" | grep -q 'PASSED' \
  && jq -e '.required == ["disposition"] and .additionalProperties == false' "$TR/schema.copy" >/dev/null \
  && grep -q -- '--output-schema ' "$TR/codex.calls" \
  && ok 'Codex foreperson receives and satisfies the disposition schema' \
  || bad "Codex schema path failed (rc=$rc, out=$out, err=$(tail -2 "$TR/good.err"))"

export PANEL_CODEX_STRUCTURED_OUTPUT='{"answer":"pass"}'
run_panel bad >"$TR/bad.out" 2>"$TR/bad.err"; rc=$?
[ "$rc" -ne 0 ] && ok 'Codex foreperson rejects output outside the disposition schema' \
  || bad 'Codex foreperson accepted invalid structured output'

echo "panel-provider-runner-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
