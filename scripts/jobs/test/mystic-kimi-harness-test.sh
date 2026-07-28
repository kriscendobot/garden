#!/bin/bash
# mystic-kimi-harness-test.sh: offline tests for the official Kimi CLI contract.
# No network call is made. The fake CLI records argument and environment NAMES only,
# never the fixture credential value. The final subtest drives the selected Mystic
# handler through the real gardener spine, so a missing shared-spine helper cannot
# be hidden by a sourced-handler fixture.
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
# A live worker exports its own clone and state paths. The real-spine subtest must
# use only its throwaway journal, never inherit a production clone.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1
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
[ -z "${GARDEN_USAGE_FILE+x}" ] && printf '%s\n' absent > "$FAKE_KIMI_RECORD.usage" || printf '%s\n' present > "$FAKE_KIMI_RECORD.usage"
printf '%s\n' "$@" > "$FAKE_KIMI_RECORD.args"
has_prompt=0
has_auto=0
has_yolo=0
for arg in "$@"; do
  case "$arg" in
    --prompt) has_prompt=1 ;;
    --auto) has_auto=1 ;;
    --yolo) has_yolo=1 ;;
  esac
done
if [ "$has_prompt" -eq 1 ] && { [ "$has_auto" -eq 1 ] || [ "$has_yolo" -eq 1 ]; }; then
  echo 'fake Kimi rejects --prompt combined with --auto or --yolo' >&2
  exit 64
fi
[ "$KIMI_MODEL_NAME" = kimi-k3 ]
[ "$KIMI_MODEL_PROVIDER_TYPE" = kimi ]
[ "$KIMI_MODEL_BASE_URL" = https://api.moonshot.ai/v1 ]
[ "$KIMI_CODE_AGENT_SWARM_MAX_CONCURRENCY" = 1 ]
[ "$KIMI_SUBAGENT_TIMEOUT_MS" = 600000 ]
[ "$KIMI_MODEL_API_KEY" = "${MOONSHOT_API_KEY:?}" ]
bullet="$(printf '\342\200\242')"
if [ "${FAKE_KIMI_COMPLETE:-0}" = 1 ]; then
  printf '%s %s\n' "$bullet" 'completed by fake Kimi'
  case "${FAKE_KIMI_MARKER_FORM:-bullet}" in
    bullet) printf '%s %s\n' "$bullet" '<<<GARDEN-JOB-COMPLETE>>>' ;;
    two-space) printf '  %s\n' '<<<GARDEN-JOB-COMPLETE>>>' ;;
    embedded)
      printf '  %s\n' '<<<GARDEN-JOB-COMPLETE>>>'
      printf '%s %s\n' "$bullet" 'continued fake Kimi report'
      ;;
    suffixed) printf '  %s suffixed\n' '<<<GARDEN-JOB-COMPLETE>>>' ;;
    *) echo "unknown fake marker form: ${FAKE_KIMI_MARKER_FORM}" >&2; exit 65 ;;
  esac
  if [ "${FAKE_KIMI_TRAILING_BLANKS:-0}" = 1 ]; then
    printf '\n\n'
  fi
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
[[ "$missing_out" == *'MOONSHOT_API_KEY: absent'* ]] && ok "missing-key diagnostic is deterministic and presence-only" || bad "missing-key diagnostic absent"
[[ "$missing_out" == *'secret-safe recreation'* ]] && ok "missing-key diagnostic requires secret-safe container recreation" || bad "missing-key recreation guidance absent"
[ ! -e "$missing_record.args" ] && ok "missing key never invokes Kimi" || bad "missing key invoked Kimi"

job="$TR/job.md"
printf '%s\n' '---' 'model: kimi-k3' 'role: builder' '---' 'offline Mystic harness job' > "$job"
run_handler() { # <base> <complete 0|1> [marker-form] [trailing-blanks 0|1]
  local base="$1" complete="$2" marker_form="${3:-bullet}" trailing_blanks="${4:-0}"
  env PATH="$BIN:$PATH" GARDEN_ROOT="$ROOT" GARDEN_STATE="$TR/state" GARDEN_SCRATCH="$TR/scratch" \
    GARDEN_MAIN_BRANCH=main2 GARDEN_WORKER_KIND=mystic GARDEN_COMPLETION_SENTINEL="$TR/sentinel" \
    MOONSHOT_API_KEY='offline-fixture-not-a-credential' FAKE_KIMI_RECORD="$TR/run" FAKE_KIMI_COMPLETE="$complete" \
    FAKE_KIMI_MARKER_FORM="$marker_form" FAKE_KIMI_TRAILING_BLANKS="$trailing_blanks" \
    "$HANDLER" "$base" "$job" "$TR/report"
}

hr; echo "INVOCATION AND CONFIG ISOLATION: first attempt keeps per-base state"; hr
rm -f "$TR/sentinel"
run_handler resume-case 0
home="$TR/state/mystics/kimi/resume-case"
[ "$(cat "$TR/run.home")" = "$home" ] && ok "KIMI_CODE_HOME is private to this base" || bad "unexpected KIMI_CODE_HOME"
[ "$(cat "$TR/run.usage")" = absent ] && ok "Kimi cannot see the private usage handoff" || bad "Kimi inherited GARDEN_USAGE_FILE and could forge accounting"
if grep -Eqx -- '--model|k3|kimi-k3' "$TR/run.args"; then
  bad "headless invocation overrides the temporary KIMI_MODEL_NAME selection"
else
  ok "headless invocation preserves temporary kimi-k3 model selection without --model"
fi
grep -qx -- '--prompt' "$TR/run.args" && grep -qx -- '--output-format' "$TR/run.args" && ok "uses official prompt headless path" || bad "not a prompt headless invocation"
if grep -Eqx -- '--(auto|yolo)' "$TR/run.args"; then
  bad "prompt invocation included an incompatible auto/yolo flag"
else
  ok "prompt invocation omits incompatible auto/yolo flags"
fi
grep -qx KIMI_MODEL_API_KEY "$TR/run.env" && ok "credential is passed through Kimi's supported temporary-model channel" || bad "missing Kimi model credential channel"
if grep -Rq 'offline-fixture-not-a-credential' "$TR/run."* "$TR/report" 2>/dev/null; then
  bad "fixture credential appeared in captured output"
else
  ok "captured output contains no credential value"
fi
[ -d "$home" ] && [ ! -e "$TR/sentinel" ] && ok "unfinished run retains state and withholds sentinel" || bad "unfinished state/sentinel contract broken"

hr; echo "SENTINEL AND RESUME: second attempt continues and then cleans up"; hr
run_handler resume-case 1
grep -qx -- '--continue' "$TR/run.args" && ok "requeue resumes Kimi session state" || bad "resume flag missing"
if grep -Eqx -- '--model|k3|kimi-k3' "$TR/run.args"; then
  bad "resume invocation overrides the temporary KIMI_MODEL_NAME selection"
else
  ok "resume preserves temporary kimi-k3 model selection without --model"
fi
[ -e "$TR/sentinel" ] && ok "completion marker gates sentinel" || bad "completion sentinel missing"
if grep -q '<<<GARDEN-JOB-COMPLETE>>>' "$TR/report"; then
  bad "machine marker leaked into human report"
else
  ok "completion marker stripped from report"
fi
[ ! -d "$home" ] && [ ! -d "$TR/scratch/gardener-wt-resume-case" ] && ok "completed run cleans private state and worktree" || bad "completed state/worktree not cleaned"

hr; echo "COMPLETION MARKER NORMALIZATION: accepts Kimi renderer decoration only at report end"; hr
rm -f "$TR/sentinel"
run_handler two-space-case 1 two-space
[ -e "$TR/sentinel" ] && ok "two-space continuation marker gates sentinel" || bad "two-space continuation marker did not gate sentinel"
if grep -q '<<<GARDEN-JOB-COMPLETE>>>' "$TR/report"; then
  bad "two-space marker leaked into human report"
else
  ok "two-space marker is normalized and stripped from report"
fi

rm -f "$TR/sentinel"
run_handler bullet-case 1 bullet
[ -e "$TR/sentinel" ] && ok "bullet marker gates sentinel" || bad "bullet marker did not gate sentinel"

rm -f "$TR/sentinel"
run_handler trailing-blanks-case 1 two-space 1
[ -e "$TR/sentinel" ] && ok "trailing blanks after two-space marker preserve completion" || bad "trailing blanks prevented completion"

rm -f "$TR/sentinel"
run_handler embedded-marker-case 1 embedded
[ ! -e "$TR/sentinel" ] && ok "embedded marker does not gate sentinel" || bad "embedded marker forged completion"
[ -d "$TR/state/mystics/kimi/embedded-marker-case" ] && ok "embedded marker retains state for requeue" || bad "embedded marker incorrectly cleaned state"

rm -f "$TR/sentinel"
run_handler suffixed-marker-case 1 suffixed
[ ! -e "$TR/sentinel" ] && ok "suffixed marker does not gate sentinel" || bad "suffixed marker forged completion"
[ -d "$TR/state/mystics/kimi/suffixed-marker-case" ] && ok "suffixed marker retains state for requeue" || bad "suffixed marker incorrectly cleaned state"

hr; echo "REAL SPINE: gardener selects Mystic, reaps its handler group, and completes"; hr
# This is intentionally not a direct handler invocation. gardener.sh sources the
# shared common library, chooses handlers/mystic-kimi.sh from the worker registry,
# starts its isolated handler process group, then calls reap_process_group before
# completing the board job. A missing helper therefore fails this deployed call path.
SPINE="$TR/spine"; mkdir -p "$SPINE"
git init -q --bare "$SPINE/journal.git"
git init -q "$SPINE/seed"; git -C "$SPINE/seed" checkout -q -b journal2
(
  cd "$SPINE/seed"
  mkdir -p jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors
  for d in jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors; do touch "$d/.gitkeep"; done
  printf '%s\n' '---' 'model: kimi-k3' 'role: gardener' '---' 'complete the offline Mystic spine canary' > jobs/todo/mystic-spine.md
)
git -C "$SPINE/seed" add -A
git -C "$SPINE/seed" -c user.name=test -c user.email=test@localhost commit -q -m seed
git -C "$SPINE/seed" remote add origin "$SPINE/journal.git"
git -C "$SPINE/seed" push -q -u origin journal2

set +e
env PATH="$BIN:$PATH" GARDEN_TEST=1 GARDEN="mystic-test" GARDEN_ROOT="$ROOT" \
  GARDEN_STATE="$SPINE/state" GARDEN_SCRATCH="$SPINE/scratch" GARDEN_MAIN_BRANCH=main2 \
  JOURNAL_REMOTE="$SPINE/journal.git" JOURNAL_BRANCH=journal2 \
  GARDEN_WORKER_KIND=mystic GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 \
  MOONSHOT_API_KEY='offline-fixture-not-a-credential' FAKE_KIMI_RECORD="$SPINE/kimi" FAKE_KIMI_COMPLETE=1 \
  "$JOBS/gardener.sh" 1 > "$SPINE/gardener.log" 2>&1
spine_rc=$?
set -e
[ "$spine_rc" -eq 0 ] && ok "real gardener Mystic call path exited cleanly" || bad "real gardener Mystic call path exited rc=$spine_rc ($(tail -3 "$SPINE/gardener.log"))"
git clone -q --single-branch --branch journal2 "$SPINE/journal.git" "$SPINE/verify"
[ -f "$SPINE/verify/jobs/tada/mystic-spine.md" ] && ok "real gardener completed the Mystic canary to tada" || bad "real gardener did not complete Mystic canary (see $SPINE/gardener.log)"
if grep -q 'reap_process_group: command not found' "$SPINE/gardener.log"; then
  bad "real gardener could not find reap_process_group in the shared worker spine"
else
  ok "real gardener resolved reap_process_group from the shared worker spine"
fi
if grep -Rq 'offline-fixture-not-a-credential' "$SPINE/kimi."* "$SPINE/gardener.log" "$SPINE/verify" 2>/dev/null; then
  bad "real spine capture persisted the fixture credential"
else
  ok "real spine capture contains no fixture credential"
fi

hr
echo "mystic-kimi-harness-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
