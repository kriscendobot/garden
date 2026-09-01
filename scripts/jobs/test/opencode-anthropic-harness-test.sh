#!/bin/bash
# Hermetic OpenCode handler probe: session sidecar/resume, summed USD, and refusal.
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS + 1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }
mkdir -p "$ROOT/scratch"
TR="$(mktemp -d "$ROOT/scratch/garden-opencode-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
mkdir -p "$TR/bin" "$TR/state" "$TR/scratch"

cat > "$TR/bin/opencode" <<'EOF'
#!/bin/bash
set -u
printf '%s\n' "$*" >> "${FAKE_OC_ARGS:?}"
if [ "${1:-}" = export ]; then
  printf '{"sessionID":"%s","messages":[]}\n' "${2:-unknown}"
  exit 0
fi
case "${FAKE_OC_MODE:-success}" in
  killed)
    printf '%s\n' '{"type":"step_start","sessionID":"ses_probe_resume"}'
    kill -TERM $$ ;;
  refused)
    printf '%s\n' '{"type":"error","sessionID":"ses_probe_refused","error":{"name":"APIError","data":{"message":"invalid x-api-key","statusCode":401}}}'
    exit 1 ;;
  success)
    printf '%s\n' \
      '{"type":"step_start","sessionID":"ses_probe_resume"}' \
      '{"type":"step_finish","sessionID":"ses_probe_resume","part":{"cost":0.01,"tokens":{"input":10,"output":2,"cache":{"read":3,"write":4}}}}' \
      '{"type":"step_finish","sessionID":"ses_probe_resume","part":{"cost":0.02,"tokens":{"input":20,"output":5,"cache":{"read":6,"write":7}}}}' \
      '{"type":"text","sessionID":"ses_probe_resume","part":{"text":"canary complete\n<<<GARDEN-JOB-COMPLETE>>>"}}' ;;
esac
EOF
chmod +x "$TR/bin/opencode"

job="$TR/job.md"
printf '%s\n' '---' 'model: opencode-anthropic/haiku' 'role: probe' 'target: main2' '---' \
  'Create and remove a throwaway file.' > "$job"

run_handler() { # mode base
  local mode="$1" base="$2"
  report="$TR/$base.report"; sentinel="$TR/$base.done"; usage="$TR/$base.usage"
  set +e
  env GARDEN_ROOT="$ROOT" GARDEN_STATE="$TR/state" GARDEN_SCRATCH="$TR/scratch" \
    GARDEN_WORKER_KIND=opencode-anthropic GARDEN_OPENCODE_BIN="$TR/bin/opencode" \
    GARDEN_AGENT_BIN_ATTEMPTS=1 ANTHROPIC_API_KEY=fixture-not-a-credential \
    GARDEN_COMPLETION_SENTINEL="$sentinel" GARDEN_USAGE_FILE="$usage" \
    GARDEN_TRANSCRIPTS_SPOOL="$TR/spool" FAKE_OC_ARGS="$TR/args" FAKE_OC_MODE="$mode" \
    bash "$JOBS/handlers/opencode.sh" "$base" "$job" "$report" > "$TR/$base.log" 2>&1
  run_rc=$?
  set -e
}

echo 'SESSION + RESUME'
run_handler killed opencode-canary
[ "$run_rc" -eq 143 ] && ok 'killed CLI preserves signal rc=143' || bad "killed rc=$run_rc"
[ "$(cat "$TR/state/opencode-anthropic/sessions/opencode-canary" 2>/dev/null)" = ses_probe_resume ] \
  && ok 'sessionID parsed into sidecar before requeue' || bad 'session sidecar absent'
run_handler success opencode-canary
[ "$run_rc" -eq 0 ] && [ -e "$sentinel" ] && ok 'resumed run completed' || bad "resume rc=$run_rc/sentinel missing"
grep -q -- '--session ses_probe_resume' "$TR/args" \
  && ok 'second invocation resumed with --session sidecar id' || bad 'resume arg absent'

echo 'USAGE + ARM'
if jq -e '.total_cost_usd == 0.03 and .input_tokens == 30 and .output_tokens == 7 and
          .cache_read_tokens == 9 and .cache_creation_tokens == 11' "$usage" >/dev/null 2>&1; then
  ok 'all step_finish costs and token classes summed'
else
  bad "summed usage wrong: $(cat "$usage" 2>/dev/null)"
fi
source "$JOBS/common.sh"
source "$JOBS/reputation.sh"
mapfile -t oc_arm < <(rep_resolve_arm opencode-anthropic "$job")
native_job="$TR/native-job.md"
sed 's#model: opencode-anthropic/haiku#model: haiku#' "$job" > "$native_job"
mapfile -t native_arm < <(rep_resolve_arm monk "$native_job")
[ "${oc_arm[*]}" = 'anthropic claude-haiku-4-5-20251001 medium' ] \
  && ok 'OpenCode arm resolves Anthropic model' || bad "OpenCode arm: ${oc_arm[*]}"
[ "${oc_arm[*]}" = "${native_arm[*]}" ] \
  && [ "$(canonical_worker_kind opencode-anthropic)" != "$(canonical_worker_kind monk)" ] \
  && ok 'same provider/model/thoughtfulness remains a distinct kind arm' \
  || bad 'OpenCode/native arm identity collapsed or model tuples differ'

echo 'REFUSED KEY'
run_handler refused opencode-refused
[ "$run_rc" -eq 75 ] && ok '401/refused key normalized to environmental EX_TEMPFAIL' \
  || bad "refused key rc=$run_rc"
[[ "$(cat "$TR/opencode-refused.log")" != *fixture-not-a-credential* ]] \
  && ok 'refused-key diagnostic does not leak key' || bad 'key leaked in diagnostic'

echo "opencode-anthropic-harness-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
