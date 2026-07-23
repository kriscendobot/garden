#!/bin/bash
# kimi-provider-test.sh — offline contract tests for the official Kimi Code path.
# The fake `kimi` records flags and environment NAMES only. It never receives a
# usable credential and never makes a network call.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
HANDLER="$JOBS/handlers/mystic-kimi-code.sh"
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS + 1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }
hr() { echo "----------------------------------------------------------------"; }
mkdir -p "$ROOT/scratch"
TR="$(mktemp -d "$ROOT/scratch/garden-kimi-code.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

BIN="$TR/bin"; mkdir -p "$BIN"
cat > "$BIN/kimi" <<'EOF'
#!/bin/bash
set -euo pipefail
: "${KIMI_TEST_RECORD:?}"
printf 'argv:' >> "$KIMI_TEST_RECORD"
printf ' %q' "$@" >> "$KIMI_TEST_RECORD"
printf '\n' >> "$KIMI_TEST_RECORD"
for name in KIMI_CODE_HOME KIMI_DISABLE_TELEMETRY KIMI_MODEL_NAME KIMI_MODEL_API_KEY KIMI_MODEL_PROVIDER_TYPE KIMI_MODEL_BASE_URL KIMI_MODEL_MAX_CONTEXT_SIZE KIMI_MODEL_CAPABILITIES KIMI_MODEL_THINKING_EFFORT; do
  [ -n "${!name+x}" ] && printf 'env:%s\n' "$name" >> "$KIMI_TEST_RECORD"
done
mkdir -p "$KIMI_CODE_HOME/sessions"
printf '{"sessionId":"fake-session"}\n' > "$KIMI_CODE_HOME/session_index.jsonl"
printf 'Kimi Code completed the offline fixture.\n'
if [ "${KIMI_TEST_COMPLETE:-0}" = 1 ]; then
  printf '%s\n' '<<<GARDEN-JOB-COMPLETE>>>'
fi
EOF
chmod +x "$BIN/kimi"

job="$TR/job.md"
printf '%s\n' '# Kimi fixture' 'role: builder' 'model: kimi-k3' > "$job"
run_handler() { # <base> <complete 0|1> <report> <sentinel>
  local base="$1" complete="$2" report="$3" sentinel="$4"
  PATH="$BIN:$PATH" GARDEN_ROOT="$ROOT" GARDEN_STATE="$TR/state" GARDEN_SCRATCH="$TR/scratch" \
    GARDEN_WORKER_KIND=mystic MOONSHOT_API_KEY='fixture-not-a-real-key' \
    KIMI_TEST_RECORD="$TR/kimi-record" KIMI_TEST_COMPLETE="$complete" \
    GARDEN_COMPLETION_SENTINEL="$sentinel" \
    bash "$HANDLER" "$base" "$job" "$report"
}

hr; echo "OFFICIAL CLI — per-job isolation, explicit model channel, no credential disclosure"; hr
: > "$TR/kimi-record"
report1="$TR/report-1"; sentinel1="$TR/sentinel-1"
set +e
run_handler resume-fixture 0 "$report1" "$sentinel1" >"$TR/handler-1.out" 2>"$TR/handler-1.err"
rc1=$?
set -e
[ "$rc1" -eq 0 ] && ok "Kimi Code clean unfinished exit is preserved for requeue" || bad "unexpected first handler rc=$rc1: $(tail -3 "$TR/handler-1.err")"
grep -q -- '--auto' "$TR/kimi-record" && grep -q -- '-p' "$TR/kimi-record" && ok "invokes official Kimi CLI headlessly" || bad "missing --auto/-p invocation: $(cat "$TR/kimi-record")"
grep -q 'env:KIMI_CODE_HOME' "$TR/kimi-record" && grep -q 'env:KIMI_MODEL_API_KEY' "$TR/kimi-record" && ok "passes isolated home and ephemeral model credential channel" || bad "missing KIMI_MODEL/KIMI_CODE_HOME env names"
grep -q 'fixture-not-a-real-key' "$TR/kimi-record" "$TR/handler-1.out" "$TR/handler-1.err" && bad "credential value leaked into captured output" || ok "credential value is not logged"
[ -d "$TR/state/mystics/kimi-code/resume-fixture" ] && ok "per-job KIMI_CODE_HOME persists after unfinished work" || bad "missing persistent per-job KIMI_CODE_HOME"
[ -d "$TR/scratch/gardener-wt-resume-fixture" ] && ok "isolated worktree persists after unfinished work" || bad "unfinished worktree was removed"
[ ! -e "$sentinel1" ] && ok "no completion sentinel without final marker" || bad "unfinished output incorrectly signaled completion"

hr; echo "RESUME + COMPLETION GATE — same home/worktree resumes, marker alone permits cleanup"; hr
report2="$TR/report-2"; sentinel2="$TR/sentinel-2"
set +e
run_handler resume-fixture 1 "$report2" "$sentinel2" >"$TR/handler-2.out" 2>"$TR/handler-2.err"
rc2=$?
set -e
[ "$rc2" -eq 0 ] && ok "resumed Kimi handler exits cleanly" || bad "unexpected resumed handler rc=$rc2: $(tail -3 "$TR/handler-2.err")"
grep -q -- '--continue' "$TR/kimi-record" && ok "requeue resumes Kimi Code's persisted session" || bad "resume invocation omitted --continue: $(cat "$TR/kimi-record")"
[ -e "$sentinel2" ] && ok "final completion marker creates the sentinel" || bad "completion sentinel missing"
[ "$(tail -n 1 "$report2")" != '<<<GARDEN-JOB-COMPLETE>>>' ] && ok "completion marker is stripped from tada report" || bad "marker leaked into report"
[ ! -e "$TR/state/mystics/kimi-code/resume-fixture" ] && ok "completed Kimi session state is cleaned up" || bad "completed Kimi state was retained"
[ ! -e "$TR/scratch/gardener-wt-resume-fixture" ] && ok "completed worktree is cleaned up" || bad "completed worktree was retained"

hr; echo "MISSING CREDENTIAL — fails before any CLI invocation"; hr
record_before="$(wc -l < "$TR/kimi-record")"
set +e
missing_out="$(env -u MOONSHOT_API_KEY PATH="$BIN:$PATH" GARDEN_ROOT="$ROOT" GARDEN_STATE="$TR/missing-state" GARDEN_SCRATCH="$TR/missing-scratch" GARDEN_WORKER_KIND=mystic KIMI_TEST_RECORD="$TR/kimi-record" bash "$HANDLER" missing-key "$job" "$TR/missing-report" 2>&1)"
missing_rc=$?
set -e
[ "$missing_rc" -ne 0 ] && ok "missing key rejects mystic handler" || bad "missing key was accepted"
[[ "$missing_out" == *'MOONSHOT_API_KEY is not set'* ]] && ok "missing-key diagnostic names remediation" || bad "missing-key diagnostic absent"
[ "$(wc -l < "$TR/kimi-record")" -eq "$record_before" ] && ok "credential preflight calls no Kimi CLI" || bad "Kimi CLI ran despite missing key"

hr; echo "LAUNCHER — forwards MOONSHOT_API_KEY without logging its value"; hr
LAUNCH="$TR/garden"; cp "$ROOT/garden" "$LAUNCH"; chmod +x "$LAUNCH"
cat > "$BIN/docker" <<'EOF'
#!/bin/bash
set -euo pipefail
record="${DOCKER_STUB_RECORD:?}"
case "${1:-}" in
  image) exit 0 ;;
  container) exit 1 ;;
  run)
    shift
    while [ "$#" -gt 0 ]; do
      if [ "$1" = -e ]; then printf '%s\n' "${2%%=*}" >> "$record"; shift 2; else shift; fi
    done ;;
esac
EOF
chmod +x "$BIN/docker"
: > "$TR/docker-env-names"
PATH="$BIN:$PATH" DOCKER_STUB_RECORD="$TR/docker-env-names" MOONSHOT_API_KEY='fixture-not-a-real-key' \
  GARDEN_CONTAINER=kimi-test GARDEN_HOSTNAME=kimi-test bash "$LAUNCH" create >/dev/null
grep -qx 'MOONSHOT_API_KEY' "$TR/docker-env-names" && ok "launcher forwards Moonshot key to new container" || bad "launcher did not forward key"
grep -q 'fixture-not-a-real-key' "$TR/docker-env-names" && bad "launcher recorded key value" || ok "launcher test records only env names"

hr
echo "kimi-provider-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
