#!/bin/bash
# mystic-kimi-harness-test.sh: offline tests for the official Kimi CLI contract.
# No network call is made. The fake CLI records argument and environment NAMES only,
# never the fixture credential value.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
HANDLER="$JOBS/handlers/mystic-kimi.sh"
DOCKERFILE="$ROOT/Dockerfile"
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS + 1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }
hr() { echo "----------------------------------------------------------------"; }
mkdir -p "$ROOT/scratch"
TR="$(mktemp -d "$ROOT/scratch/garden-mystic-kimi.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
BIN="$TR/bin"; mkdir -p "$BIN"

cat > "$BIN/kimi" <<'EOF'
#!/bin/bash
set -euo pipefail
: "${FAKE_KIMI_RECORD:?}"
printf '%s\n' "$KIMI_CODE_HOME" > "$FAKE_KIMI_RECORD.home"
printf '%s\n' KIMI_CODE_HOME KIMI_MODEL_NAME KIMI_MODEL_API_KEY KIMI_MODEL_BASE_URL > "$FAKE_KIMI_RECORD.env"
printf '%s\n' "$@" > "$FAKE_KIMI_RECORD.args"
[ "$KIMI_MODEL_NAME" = kimi-k3 ]
[ "$KIMI_MODEL_PROVIDER_TYPE" = kimi ]
[ "$KIMI_MODEL_BASE_URL" = https://api.moonshot.ai/v1 ]
[ "$KIMI_MODEL_API_KEY" = "${MOONSHOT_API_KEY:?}" ]
bullet="$(printf '\342\200\242')"
if [ "${FAKE_KIMI_COMPLETE:-0}" = 1 ]; then
  printf '%s %s\n' "$bullet" 'completed by fake Kimi'
  printf '%s %s\n' "$bullet" '<<<GARDEN-JOB-COMPLETE>>>'
else
  printf '%s %s\n' "$bullet" 'unfinished fake Kimi attempt'
fi
EOF
chmod +x "$BIN/kimi"

hr; echo "IMAGE CONTRACT: official Kimi Code CLI is present outside HOME"; hr
grep -q 'https://code.kimi.com/kimi-code/install.sh' "$DOCKERFILE" \
  && grep -q 'KIMI_INSTALL_DIR=/opt/kimi-code' "$DOCKERFILE" \
  && grep -q '/opt/kimi-code/bin/kimi' "$DOCKERFILE" \
  && ok "image installs the official Kimi CLI in an image-owned path" \
  || bad "image does not install the official Kimi CLI"

hr; echo "MISSING CREDENTIAL: fails before Kimi CLI invocation"; hr
missing_record="$TR/missing"
set +e
missing_out="$(env -u MOONSHOT_API_KEY PATH="$BIN:$PATH" FAKE_KIMI_RECORD="$missing_record" \
  bash -c 'source "$1"; kimi_provider_preflight canary' _ "$JOBS/handlers/kimi-provider-common.sh" 2>&1)"
missing_rc=$?
set -e
[ "$missing_rc" -ne 0 ] && ok "missing key rejects Mystic" || bad "missing key was accepted"
[[ "$missing_out" == *'MOONSHOT_API_KEY is not set'* ]] && ok "missing-key diagnostic is actionable" || bad "missing-key diagnostic absent"
[ ! -e "$missing_record.args" ] && ok "missing key never invokes Kimi" || bad "missing key invoked Kimi"

job="$TR/job.md"
printf '%s\n' '---' 'model: kimi-k3' 'role: builder' '---' 'offline Mystic harness job' > "$job"
run_handler() { # <complete 0|1>
  local complete="$1"
  env PATH="$BIN:$PATH" GARDEN_ROOT="$ROOT" GARDEN_STATE="$TR/state" GARDEN_SCRATCH="$TR/scratch" \
    GARDEN_MAIN_BRANCH=main2 GARDEN_WORKER_KIND=mystic GARDEN_COMPLETION_SENTINEL="$TR/sentinel" \
    MOONSHOT_API_KEY='offline-fixture-not-a-credential' FAKE_KIMI_RECORD="$TR/run" FAKE_KIMI_COMPLETE="$complete" \
    "$HANDLER" resume-case "$job" "$TR/report"
}

hr; echo "INVOCATION AND CONFIG ISOLATION: first attempt keeps per-base state"; hr
rm -f "$TR/sentinel"
run_handler 0
home="$TR/state/mystics/kimi/resume-case"
[ "$(cat "$TR/run.home")" = "$home" ] && ok "KIMI_CODE_HOME is private to this base" || bad "unexpected KIMI_CODE_HOME"
grep -qx -- '--model' "$TR/run.args" && grep -qx kimi-k3 "$TR/run.args" && ok "headless invocation pins kimi-k3" || bad "model invocation not explicit"
grep -qx -- '--prompt' "$TR/run.args" && grep -qx -- '--output-format' "$TR/run.args" && ok "uses official prompt headless path" || bad "not a prompt headless invocation"
grep -qx KIMI_MODEL_API_KEY "$TR/run.env" && ok "credential is passed through Kimi's supported temporary-model channel" || bad "missing Kimi model credential channel"
if grep -Rq 'offline-fixture-not-a-credential' "$TR/run."* "$TR/report" 2>/dev/null; then
  bad "fixture credential appeared in captured output"
else
  ok "captured output contains no credential value"
fi
[ -d "$home" ] && [ ! -e "$TR/sentinel" ] && ok "unfinished run retains state and withholds sentinel" || bad "unfinished state/sentinel contract broken"

hr; echo "SENTINEL AND RESUME: second attempt continues and then cleans up"; hr
run_handler 1
grep -qx -- '--continue' "$TR/run.args" && ok "requeue resumes Kimi session state" || bad "resume flag missing"
[ -e "$TR/sentinel" ] && ok "completion marker gates sentinel" || bad "completion sentinel missing"
if grep -q '<<<GARDEN-JOB-COMPLETE>>>' "$TR/report"; then
  bad "machine marker leaked into human report"
else
  ok "completion marker stripped from report"
fi
[ ! -d "$home" ] && [ ! -d "$TR/scratch/gardener-wt-resume-case" ] && ok "completed run cleans private state and worktree" || bad "completed state/worktree not cleaned"

hr
echo "mystic-kimi-harness-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
