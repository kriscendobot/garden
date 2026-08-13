#!/bin/bash
# deadline-nudge-test.sh - deterministic claimed-job deadline-warning coverage.
#
# Uses a throwaway journal2 origin. It exercises the real scanner, inbox reader,
# shared budget helper, journal-backed operator switch, and unit wiring without
# touching the deployed garden or its journal.

set -uo pipefail
export GARDEN_TEST=1
export GARDEN_CLAIM_TTL=14400 GARDEN_HANDLER_KILL_AFTER=60
export GARDEN_HANDLER_TIMEOUT=2400 GARDEN_BUILD_HANDLER_TIMEOUT=7200
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
NUDGE="$JOBS/deadline-nudge.sh"
SETTER="$JOBS/set-deadline-nudge.sh"
BRANCH=journal2
NOW=2000000000

pass=0
fail=0
ok() { printf '  ok   %s\n' "$1"; pass=$((pass + 1)); }
bad() { printf '  FAIL %s\n' "$1"; fail=$((fail + 1)); }
hr() { printf '%s\n' '---------------------------------------------------------------'; }

TEST_ROOT="$(mktemp -d "$HOME/.garden-deadline-nudge-test.XXXXXXXX")"
trap 'rm -rf "$TEST_ROOT"' EXIT
BARE="$TEST_ROOT/journal.git"
SEED="$TEST_ROOT/seed"
STATE="$TEST_ROOT/state"
git_identity=(-c user.name=test -c user.email=test@localhost)

write_claim() {
  local tree="$1" base="$2" role="$3" handler_timeout="$4"
  local budget="$5" remaining="$6" markers="${7:-}" claimed_epoch claimed_at
  claimed_epoch=$(( NOW + remaining - budget ))
  claimed_at="$(date -u -d "@$claimed_epoch" +%FT%TZ)"
  mkdir -p "$tree/jobs/doin" "$tree/inbox/$base/unread" "$tree/inbox/$base/read"
  {
    printf '%s\n' '---'
    [ -n "$role" ] && printf 'role: %s\n' "$role"
    [ -n "$handler_timeout" ] && printf 'handler-timeout: %s\n' "$handler_timeout"
    printf '%s\n' '---' "work for $base"
    [ -n "$markers" ] && printf '%b\n' "$markers"
    printf '%s\n' '---' 'claim:'
    printf '  host: worker-host\n'
    printf '  gardener: 3\n'
    printf '  worker_kind: cleric\n'
    printf '  claimed_at: %s\n' "$claimed_at"
  } > "$tree/jobs/doin/$base.md"
  touch "$tree/inbox/$base/unread/.gitkeep" "$tree/inbox/$base/read/.gitkeep"
}

run_nudge() {
  local clone_name="$1"
  shift
  env JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" GARDEN_ROOT="$ROOT" \
      GARDEN_STATE="$STATE" GARDEN=leader-one GARDEN_NO_MAINTAINER_ALERT=1 \
      GARDEN_DEADLINE_NUDGE_CLONE="$STATE/$clone_name/journal" \
      GARDEN_DEADLINE_NUDGE_NOW="$NOW" "$@" "$NUDGE"
}

tip_has() { git -C "$BARE" cat-file -e "$BRANCH:$1" 2>/dev/null; }
tip_show() { git -C "$BARE" show "$BRANCH:$1" 2>/dev/null; }
nudge_paths() { git -C "$BARE" ls-tree -r --name-only "$BRANCH" -- "inbox/$1" 2>/dev/null | grep 'deadline-nudge-' || true; }
add_claim_at_tip() {
  local base="$1" remaining="$2" update
  update="$TEST_ROOT/add-$base"
  git clone -q --branch "$BRANCH" "$BARE" "$update"
  write_claim "$update" "$base" "fixer" "" 2400 "$remaining"
  git -C "$update" add -A
  git -C "$update" "${git_identity[@]}" commit -q -m "add $base fixture"
  git -C "$update" push -q origin "HEAD:$BRANCH"
}

git init -q --bare "$BARE"
git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"

# Default ordinary lead is 600s; builder is capped at 900s. A 100s explicit
# budget is shorter than the 120s two-tick floor and therefore warns immediately.
write_claim "$SEED" above "fixer" "" 2400 601
write_claim "$SEED" due "fixer" "" 2400 600 \
  '<!-- garden-reaped: 4 -->\n<!-- garden-deadline-overrun: 2 -->\n<!-- garden-productive-cycle -->\n<!-- garden-outage-cycle -->'
sed -i '2a token-budget: 10000' "$SEED/jobs/doin/due.md"
write_claim "$SEED" exact "fixer" "" 2400 0
write_claim "$SEED" expired "fixer" "" 2400 -1
write_claim "$SEED" short "fixer" 100 100 90 \
  '<!-- garden-provider-quota-backoff: type=session reset-at=2033-05-18T04:00:00Z -->'
write_claim "$SEED" builder "builder" "" 7200 900
write_claim "$SEED" reapnow "fixer" "" 2400 300 \
  '<!-- garden-reaped: 1 -->\n<!-- garden-deadline-overrun: 1 -->\n<!-- garden-reap-now -->'
write_claim "$SEED" badtime "fixer" "" 2400 300
sed -i 's/^  claimed_at:.*/  claimed_at: not-a-time/' "$SEED/jobs/doin/badtime.md"
mkdir -p "$SEED/jobs/todo" "$SEED/jobs/plan" "$SEED/jobs/tada" "$SEED/jobs/orch" "$SEED/usage" "$SEED/work" "$SEED/inbox/dead"
touch "$SEED/jobs/todo/.gitkeep" "$SEED/jobs/plan/.gitkeep" "$SEED/jobs/tada/.gitkeep" "$SEED/work/.gitkeep" "$SEED/inbox/dead/.gitkeep"
usage_ts="$(date -u -d "@$((NOW - 1000))" +%FT%TZ)"
printf '{"ts":"%s","source":"provider","input_tokens":150,"output_tokens":50,"cache_creation_tokens":25,"cache_read_tokens":500}\n' "$usage_ts" > "$SEED/usage/due.jsonl"
cat > "$SEED/jobs/orch/nudge-campaign.md" <<EOF
---
order: serial
children: due
budget_tokens: 1000
created_at: $(date -u -d "@$((NOW - 2000))" +%FT%TZ)
---
deadline nudge budget fixture
EOF
git -C "$SEED" add -A
git -C "$SEED" "${git_identity[@]}" commit -q -m seed
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

hr
printf '%s\n' 'BUDGET TABLE AND SHARED CONSUMERS'
hr
# shellcheck source=../common.sh
source "$JOBS/common.sh"
budget_tree="$TEST_ROOT/budgets"
mkdir -p "$budget_tree"
make_budget_job() { printf -- '---\n%s\n---\n' "$2" > "$budget_tree/$1.md"; }
make_budget_job ordinary 'role: fixer'
make_budget_job builder 'role: builder'
make_budget_job shorter 'role: builder
handler-timeout: 600'
make_budget_job longer 'role: builder
handler-timeout: 10800'
make_budget_job invalid 'role: builder
handler-timeout: 60oops'
make_budget_job clamped 'role: builder
handler-timeout: 20000'
[ "$(applied_handler_budget "$budget_tree/ordinary.md")" = 2400 ] && ok 'ordinary budget = 2400' || bad 'ordinary budget mismatch'
[ "$(applied_handler_budget "$budget_tree/builder.md")" = 7200 ] && ok 'builder budget = 7200' || bad 'builder budget mismatch'
[ "$(applied_handler_budget "$budget_tree/shorter.md")" = 600 ] && ok 'valid shorter override = 600' || bad 'shorter override mismatch'
[ "$(applied_handler_budget "$budget_tree/longer.md")" = 10800 ] && ok 'valid longer override = 10800' || bad 'longer override mismatch'
[ "$(applied_handler_budget "$budget_tree/invalid.md")" = 7200 ] && ok 'invalid override falls back to builder base' || bad 'invalid override changed budget'
[ "$(applied_handler_budget "$budget_tree/clamped.md")" = 14339 ] && ok 'overlarge override clamps to claim ceiling' || bad 'claim ceiling mismatch'
for consumer in gardener.sh reaper.sh deadline-nudge.sh; do
  grep -q 'applied_handler_budget' "$JOBS/$consumer" && ok "$consumer uses shared applied budget" || bad "$consumer bypasses shared applied budget"
done

hr
printf '%s\n' 'BOUNDARIES, MARKER HYGIENE, AND MESSAGE SHAPE'
hr
before_job_hash="$(tip_show jobs/doin/due.md | sha256sum | cut -d' ' -f1)"
run_nudge first > "$TEST_ROOT/first.out" 2>&1
after_job_hash="$(tip_show jobs/doin/due.md | sha256sum | cut -d' ' -f1)"
[ "$before_job_hash" = "$after_job_hash" ] && ok 'due claim body is byte-identical after delivery' || bad 'scanner changed the claim body or cycle markers'
[ "$(nudge_paths due | wc -l)" -eq 1 ] && ok 'claim inside lead window receives one nudge' || bad 'inside-window nudge missing or duplicated'
[ -z "$(nudge_paths above)" ] && ok 'claim above lead window receives no nudge' || bad 'above-window claim was nudged'
[ -z "$(nudge_paths exact)" ] && [ -z "$(nudge_paths expired)" ] && ok 'claim at or after deadline receives no first nudge' || bad 'late claim was nudged'
[ "$(nudge_paths short | wc -l)" -eq 1 ] && ok 'budget shorter than two-tick floor warns immediately' || bad 'short-budget warning missing'
[ "$(git -C "$BARE" ls-tree -r --name-only "$BRANCH" -- inbox/short | grep -c 'deadline-checkpoint-' || true)" -eq 1 ] \
  && ok 'final checkpoint nudge asks for durable WIP near the wall' || bad 'final checkpoint warning missing'
short_message="$(nudge_paths short | head -1)"
if tip_show "$short_message" | grep -q '^quota_window_status: provider-session-exhausted$' \
  && tip_show "$short_message" | grep -q '^provider_quota_resets_at: 2033-05-18T04:00:00Z$'; then
  ok 'known provider quota exhaustion and reset are explicit in the nudge'
else
  bad 'provider quota backoff facts are missing from the nudge'
fi
[ "$(nudge_paths builder | wc -l)" -eq 1 ] && ok 'builder warns at the 900s cap' || bad 'builder cap warning missing'
[ -z "$(nudge_paths reapnow)" ] && ok 'reap-now claim is skipped' || bad 'reap-now claim was nudged'
[ -z "$(nudge_paths badtime)" ] && ok 'malformed claim time is skipped' || bad 'malformed claim time was nudged'
due_message="$(nudge_paths due | head -1)"
if tip_show "$due_message" | grep -q '^kind: deadline-nudge$' \
  && tip_show "$due_message" | grep -q '^remaining_seconds: 600$' \
  && tip_show "$due_message" | grep -q '^deadline_at:' \
  && tip_show "$due_message" | grep -q '^claim_attempt: [0-9a-f]\{16\}$' \
  && tip_show "$due_message" | grep -q '^Deadline nudge: about 10 minutes remain'; then
  ok 'message carries deterministic attempt, deadline, remaining time, and action text'
else
  bad 'message shape is incomplete'
fi
if tip_show "$due_message" | grep -q '^attempt_billable_tokens: 225$' \
  && tip_show "$due_message" | grep -q '^job_billable_tokens_spent: 225$' \
  && tip_show "$due_message" | grep -q '^job_token_budget: 10000$' \
  && tip_show "$due_message" | grep -q '^job_token_budget_remaining: 9950$' \
  && tip_show "$due_message" | grep -q '^campaign: nudge-campaign$' \
  && tip_show "$due_message" | grep -q '^campaign_budget_tokens: 1000$' \
  && tip_show "$due_message" | grep -q '^campaign_budget_remaining: 775$' \
  && tip_show "$due_message" | grep -q '^quota_window_status:'; then
  ok 'message carries attempt, job, campaign, and quota-window budget facts'
else
  bad 'message budget facts are incomplete'
fi
for primitive in 'post-job.sh' 'post-plan.sh --budget-hold' 'post-plan.sh --go-ahead' 'post-plan.sh --orchestrated' 'post-orchestration.sh' 'GARDEN-JOB-HANDED-OFF'; do
  tip_show "$due_message" | grep -q "$primitive" || bad "nudge omits handoff primitive/disposition: $primitive"
done
for marker in 'garden-reaped: 4' 'garden-deadline-overrun: 2' 'garden-productive-cycle' 'garden-outage-cycle'; do
  tip_show jobs/doin/due.md | grep -q "$marker" || bad "marker disappeared: $marker"
done

hr
printf '%s\n' 'IDEMPOTENCY, CHECKPOINT DELIVERY, AND LEADER OVERLAP'
hr
run_nudge second > "$TEST_ROOT/second.out" 2>&1
[ "$(nudge_paths due | wc -l)" -eq 1 ] && ok 'repeated timer tick leaves one message' || bad 'repeated tick duplicated message'
set +e
read_output="$(env JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" GARDEN_ROOT="$ROOT" \
  GARDEN_STATE="$STATE" GARDEN=worker-host GARDEN_NO_MAINTAINER_ALERT=1 \
  GARDEN_INBOX_CLONE="$STATE/read/journal" "$JOBS/inbox-read.sh" due 2>&1)"
read_rc=$?
set -e
[ "$read_rc" -eq 1 ] && printf '%s' "$read_output" | grep -q 'Deadline nudge:' \
  && ok 'explicit inbox checkpoint prints the warning and moves it to read' \
  || bad "inbox checkpoint did not deliver the warning (rc=$read_rc)"
run_nudge third env GARDEN=leader-two > "$TEST_ROOT/third.out" 2>&1
[ "$(nudge_paths due | wc -l)" -eq 1 ] \
  && tip_has "${due_message/unread/read}" \
  && ok 'read move, later tick, and overlapping leader keep one deterministic ID' \
  || bad 'read/leader overlap duplicated or lost the message'

hr
printf '%s\n' 'REQUEUE IDENTITY AND GLOBAL OPERATOR SWITCH'
hr
old_id="$(basename "$due_message")"
UPDATE="$TEST_ROOT/update"
git clone -q --branch "$BRANCH" "$BARE" "$UPDATE"
rm -rf "$UPDATE/inbox/due"
write_claim "$UPDATE" due "fixer" "" 2400 500
git -C "$UPDATE" add -A
git -C "$UPDATE" "${git_identity[@]}" commit -q -m 'requeue and reclaim due'
git -C "$UPDATE" push -q origin "HEAD:$BRANCH"
run_nudge reclaim > "$TEST_ROOT/reclaim.out" 2>&1
new_path="$(nudge_paths due | head -1)"
new_id="$(basename "$new_path")"
[ -n "$new_id" ] && [ "$new_id" != "$old_id" ] && ok 'new claimed_at receives a new attempt ID' || bad 'reclaim reused the old attempt ID'
if tip_has "inbox/due/unread/$old_id" || tip_has "inbox/due/read/$old_id"; then
  bad 'old attempt warning survived requeue'
else
  ok 'old attempt inbox does not survive requeue'
fi

git clone -q --branch "$BRANCH" "$BARE" "$TEST_ROOT/toggle-add"
write_claim "$TEST_ROOT/toggle-add" toggle "fixer" "" 2400 300
git -C "$TEST_ROOT/toggle-add" add -A
git -C "$TEST_ROOT/toggle-add" "${git_identity[@]}" commit -q -m 'add toggle fixture'
git -C "$TEST_ROOT/toggle-add" push -q origin "HEAD:$BRANCH"
env JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" GARDEN_ROOT="$ROOT" \
  GARDEN_STATE="$STATE" GARDEN=operator GARDEN_PRODUCER_CLONE="$STATE/setter/journal" \
  "$SETTER" off > "$TEST_ROOT/off.out" 2>&1
run_nudge disabled > "$TEST_ROOT/disabled.out" 2>&1
[ -z "$(nudge_paths toggle)" ] && ok 'journal-backed off switch disables delivery globally' || bad 'off switch did not suppress delivery'
env JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" GARDEN_ROOT="$ROOT" \
  GARDEN_STATE="$STATE" GARDEN=operator GARDEN_PRODUCER_CLONE="$STATE/setter/journal" \
  "$SETTER" on > "$TEST_ROOT/on.out" 2>&1
run_nudge enabled > "$TEST_ROOT/enabled.out" 2>&1
[ "$(nudge_paths toggle | wc -l)" -eq 1 ] && ok 'on switch restores delivery' || bad 'on switch did not restore delivery'

hr
printf '%s\n' 'CONDITIONAL DELIVERY RACES AND FAIL-OPEN'
hr
race_stub="$HERE/deadline-nudge-race-push-stub.sh"
add_claim_at_tip claim-race 300
old_claimed_at="$(tip_show jobs/doin/claim-race.md | sed -n 's/^  claimed_at: //p')"
old_race_digest="$(printf '%s\037%s\037%s\037%s\037%s' claim-race "$old_claimed_at" worker-host cleric 3 | sha256sum | cut -c1-16)"
new_claimed_at="$(date -u -d "@$(( NOW + 400 - 2400 ))" +%FT%TZ)"
run_nudge claim-race-scan env GARDEN_DEADLINE_NUDGE_PUSH_ATTEMPTS=2 \
  GARDEN_NUDGE_RACE_BARE="$BARE" GARDEN_NUDGE_RACE_MARKER="$TEST_ROOT/claim-race.marker" \
  GARDEN_NUDGE_RACE_BASE=claim-race GARDEN_NUDGE_RACE_ACTION=reclaim \
  GARDEN_NUDGE_RACE_CLAIMED_AT="$new_claimed_at" GARDEN_PUSH_CMD="$race_stub" \
  > "$TEST_ROOT/claim-race.out" 2>&1
claim_race_path="$(nudge_paths claim-race | head -1)"
if [ -n "$claim_race_path" ] && [[ "$claim_race_path" != *"deadline-nudge-$old_race_digest.md" ]]; then
  ok 'stale sender cannot append the old warning after a reclaim race'
else
  bad 'old-attempt warning crossed into the reclaimed inbox'
fi

add_claim_at_tip complete-race 300
run_nudge complete-race-scan env GARDEN_DEADLINE_NUDGE_PUSH_ATTEMPTS=2 \
  GARDEN_NUDGE_RACE_BARE="$BARE" GARDEN_NUDGE_RACE_MARKER="$TEST_ROOT/complete-race.marker" \
  GARDEN_NUDGE_RACE_BASE=complete-race GARDEN_NUDGE_RACE_ACTION=complete \
  GARDEN_PUSH_CMD="$race_stub" > "$TEST_ROOT/complete-race.out" 2>&1
if [ -z "$(nudge_paths complete-race)" ] \
  && ! tip_has jobs/doin/complete-race.md \
  && [ "$(git -C "$BARE" ls-tree -r --name-only "$BRANCH" -- inbox/dead | grep -cv '\.gitkeep' || true)" -eq 0 ]; then
  ok 'completion race is a quiet no-op with no dead mail'
else
  bad 'completion race created a warning or dead mail'
fi

add_claim_at_tip pushfail 300
run_nudge pushfail-scan env GARDEN_DEADLINE_NUDGE_PUSH_ATTEMPTS=1 \
  GARDEN_PUSH_CMD=/bin/false > "$TEST_ROOT/pushfail.out" 2>&1
[ -z "$(nudge_paths pushfail)" ] && grep -q 'failed locally' "$TEST_ROOT/pushfail.out" \
  && ok 'exhausted push retry fails open without changing the board' \
  || bad 'push exhaustion changed the board or escaped fail-open handling'

run_nudge invalid env GARDEN_DEADLINE_NUDGE_INTERVAL=oops > "$TEST_ROOT/invalid.out" 2>&1
[ "$?" -eq 0 ] && grep -q 'disabling this tick' "$TEST_ROOT/invalid.out" && ok 'invalid timing knob disables one tick cleanly' || bad 'invalid timing knob did not fail open'
set +e
env JOURNAL_REMOTE="$TEST_ROOT/missing.git" JOURNAL_BRANCH="$BRANCH" GARDEN_ROOT="$ROOT" \
  GARDEN_STATE="$TEST_ROOT/dead-state" GARDEN=leader-one GARDEN_NO_MAINTAINER_ALERT=1 \
  GARDEN_DEADLINE_NUDGE_CLONE="$TEST_ROOT/dead-state/journal" "$NUDGE" \
  > "$TEST_ROOT/dead-origin.out" 2>&1
dead_rc=$?
set -e
[ "$dead_rc" -eq 0 ] && ok 'unavailable journal origin exits successfully' || bad "unavailable origin escaped rc=$dead_rc"

hr
printf '%s\n' 'HONEST HANDOFF AND BUDGET PARK/REFRESH'
hr
handoff_update="$TEST_ROOT/handoff-update"
git clone -q --branch "$BRANCH" "$BARE" "$handoff_update"
write_claim "$handoff_update" handoff "fixer" "" 2400 300
printf '%s\n' 'successor work' > "$handoff_update/jobs/todo/handoff-successor.md"
git -C "$handoff_update" add -A
git -C "$handoff_update" "${git_identity[@]}" commit -q -m 'add handoff fixtures'
git -C "$handoff_update" push -q origin "HEAD:$BRANCH"
handoff_report="$TEST_ROOT/handoff-report"
printf 'partial work committed and successor posted\n%s\n' '<<<GARDEN-JOB-HANDED-OFF: handoff-successor>>>' > "$handoff_report"
env JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" GARDEN_ROOT="$ROOT" \
  GARDEN_STATE="$STATE" GARDEN=worker-host GARDEN_GARDENER_CLONE="$STATE/handoff/journal" \
  "$JOBS/complete-job.sh" --handed-off handoff-successor 3 handoff "$handoff_report" \
  > "$TEST_ROOT/handoff.out" 2>&1
if tip_show jobs/tada/handoff.md | grep -q '^handed-off: handoff-successor$' \
  && tip_show jobs/tada/handoff.md | grep -q '^deliverable-complete: false$' \
  && ! tip_show jobs/tada/handoff.md | grep -qF '<<<GARDEN-JOB-HANDED-OFF:'; then
  ok 'declared handoff is mechanically distinct from clean completion'
else
  bad 'handoff disposition was not stamped or signal leaked into the report'
fi

park_update="$TEST_ROOT/park-update"
git clone -q --branch "$BRANCH" "$BARE" "$park_update"
write_claim "$park_update" budgetpark "fixer" "" 2400 300 \
  '<!-- garden-deadline-overrun: 1 -->\n<!-- garden-reap-now -->'
sed -i '2a token-budget: 10' "$park_update/jobs/doin/budgetpark.md"
printf '{"ts":"2026-08-13T00:00:00Z","source":"provider","input_tokens":1,"output_tokens":20,"cache_creation_tokens":0}\n' > "$park_update/usage/budgetpark.jsonl"
write_claim "$park_update" liveprogress "fixer" "" 2400 300 \
  '<!-- garden-deadline-overrun: 1 -->\n<!-- garden-reap-now -->'
sed -i '2a token-budget: 10000' "$park_update/jobs/doin/liveprogress.md"
printf '{"ts":"%s","source":"provider","input_tokens":10,"output_tokens":3000,"cache_creation_tokens":0}\n' "$usage_ts" > "$park_update/usage/liveprogress.jsonl"
git -C "$park_update" add -A
git -C "$park_update" "${git_identity[@]}" commit -q -m 'add budget park fixture'
git -C "$park_update" push -q origin "HEAD:$BRANCH"
env JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" GARDEN_ROOT="$ROOT" \
  GARDEN_STATE="$STATE/reaper" GARDEN=reaper-host GARDEN_NO_MAINTAINER_ALERT=1 \
  GARDEN_REAPER_CLONE="$STATE/reaper/journal" GARDEN_PROGRESS_DOOM=on \
  "$JOBS/reaper.sh" > "$TEST_ROOT/reaper.out" 2>&1
if tip_has jobs/plan/budgetpark.md \
  && tip_show jobs/plan/budgetpark.md | grep -q '^budget_hold: true$' \
  && tip_show jobs/plan/budgetpark.md | grep -q '^park_reason: over-token-budget$' \
  && tip_show jobs/plan/budgetpark.md | grep -q '^gate: go-ahead$'; then
  ok 'over-budget progress disposition creates a held go-ahead plan'
else
  bad 'reaper did not create the expected budget hold'
fi
if tip_has jobs/todo/liveprogress.md && ! tip_has jobs/plan/liveprogress.md; then
  ok 'token-live work below budget requeues instead of elapsed-only doom'
else
  bad 'progress-aware reaper did not keep live under-budget work moving'
fi
park_body="$TEST_ROOT/selfpark-body"
printf 'resume this work after quota refresh\n' > "$park_body"
env JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" GARDEN_ROOT="$ROOT" \
  GARDEN_STATE="$STATE/selfpark" GARDEN=worker-host GARDEN_PRODUCER_CLONE="$STATE/selfpark/journal" \
  "$JOBS/post-plan.sh" --budget-hold --budget-resets-at 2030-01-01T00:00:00Z selfpark "$park_body" \
  > "$TEST_ROOT/selfpark.out" 2>&1
if tip_has jobs/plan/selfpark.md \
  && tip_show jobs/plan/selfpark.md | grep -q '^gate: go-ahead$' \
  && tip_show jobs/plan/selfpark.md | grep -q '^budget_hold: true$'; then
  ok 'nudged worker can explicitly post a quota-refresh-held successor'
else
  bad 'post-plan --budget-hold did not create a refresh-held successor'
fi
env JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" GARDEN_ROOT="$ROOT" \
  GARDEN_STATE="$STATE/refresh" GARDEN=leader-one GARDEN_BUDGET_REFRESH_CLONE="$STATE/refresh/journal" \
  GARDEN_BUDGET_REFRESH_NOW="$NOW" GARDEN_TOKEN_WINDOW_SECS=1 \
  "$JOBS/budget-refresh.sh" > "$TEST_ROOT/refresh.out" 2>&1
if tip_has jobs/todo/budgetpark.md && ! tip_has jobs/plan/budgetpark.md \
  && tip_show jobs/todo/budgetpark.md | grep -q '^token-budget: 10$' \
  && tip_show jobs/todo/budgetpark.md | grep -q '^token-budget-epoch:' \
  && tip_has jobs/todo/selfpark.md && ! tip_has jobs/plan/selfpark.md; then
  ok 'quota-window refresh promotes reaper and worker-created budget holds'
else
  bad 'budget refresh did not promote the held plan'
fi

hr
printf '%s\n' 'UNIT WIRING'
hr
service="$ROOT/scripts/systemd/garden-deadline-nudge.service"
timer="$ROOT/scripts/systemd/garden-deadline-nudge.timer"
grep -q '^ExecCondition=/bin/bash .*is-main-host.sh' "$service" \
  && ok 'service is leader-gated' || bad 'service lacks leader gate'
grep -q 'deadline-nudge.sh' "$service" && ok 'service invokes scanner' || bad 'service does not invoke scanner'
grep -q '^OnCalendar=\*:\*:00$' "$timer" && grep -q '^AccuracySec=1s$' "$timer" \
  && ok 'timer uses an absolute one-minute cadence' || bad 'timer cadence is not one minute'
grep -q '^WantedBy=timers.target$' "$timer" && ok 'timer is auto-enable discoverable' || bad 'timer is not installable'
grep -q 'budget-refresh.sh' "$ROOT/scripts/systemd/garden-budget-refresh.service" \
  && grep -q '^WantedBy=timers.target$' "$ROOT/scripts/systemd/garden-budget-refresh.timer" \
  && ok 'budget refresh promoter is leader-timer wired' || bad 'budget refresh unit wiring is incomplete'

hr
printf 'passed %d, failed %d\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
