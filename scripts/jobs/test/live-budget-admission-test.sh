#!/bin/bash
# Hermetic coverage for live pool admission, anchored windows, routing, promotion,
# and proportional worker leveling.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-live-budget-test.XXXXXX")"
# GARDEN_FETCH_CMD stubs are exec'd directly (not via `bash <file>`), so they must
# live on an exec-mounted filesystem — $TMPDIR is commonly noexec — hence a $HOME
# scratch dir like fetch-timeout-test.sh uses.
EXECDIR="$(mktemp -d "$HOME/.garden-live-budget-exec.XXXXXX")"
trap 'rm -rf "$TR" "$EXECDIR"' EXIT
pass=0; fail=0
ok() { echo "PASS: $*"; pass=$((pass+1)); }
bad() { echo "FAIL: $*"; fail=$((fail+1)); }
git_id=(-c user.name=test -c user.email=test@example.invalid)
NOW="$(date -u -d 2026-08-22T12:00:00Z +%s)"

make_log() { # dir id iso tokens
  mkdir -p "$1/p"
  printf '{"type":"assistant","timestamp":"%s","message":{"id":"%s","usage":{"input_tokens":%s,"output_tokens":0,"cache_creation_input_tokens":0,"cache_read_input_tokens":0}}}\n' \
    "$3" "$2" "$4" >> "$1/p/session.jsonl"
}

# Anchored local pool: the pre-reset row is excluded; 900/1000 trips 0.85.
CFG="$TR/budget-pools"
printf '%s\n' 'anthropic:testhost anthropic testhost weekly-tokens 1000' > "$CFG"
LOGS="$TR/logs"
make_log "$LOGS" old 2026-08-22T02:59:59Z 9999
make_log "$LOGS" live 2026-08-22T03:00:01Z 900
status="$(GARDEN=testhost GARDEN_STATE="$TR/state" GARDEN_USAGE_NOW="$NOW" \
  GARDEN_CCUSAGE_LOGDIR="$LOGS" GARDEN_BUDGET_POOLS_FILE="$CFG" \
  bash -c 'source "$1/common.sh"; meter_quota_status anthropic:testhost' _ "$JOBS")"
[ "$status" = backoff ] && ok "Friday-20:00-Pacific anchored pool reaches backoff" || bad "anchored verdict was $status"

# A mid-week seven-day rejection followed by successful usage is a fresh server
# entitlement/account epoch. Pre-boundary history must not leak into its meter.
EPOCH_LOGS="$TR/epoch-logs"
make_log "$EPOCH_LOGS" prior 2026-08-22T04:00:00Z 900
make_log "$EPOCH_LOGS" fresh 2026-08-22T06:00:00Z 100
printf '%s\n' '{"type":"assistant","timestamp":"2026-08-22T05:00:00Z","message":{"id":"rejected","model":"<synthetic>","usage":{"input_tokens":0,"output_tokens":0,"cache_creation_input_tokens":0,"cache_read_input_tokens":0}},"quotaLimits":{"status":"rejected","rateLimitType":"seven_day"}}' >> "$EPOCH_LOGS/p/session.jsonl"
epoch_total="$(GARDEN=testhost GARDEN_STATE="$TR/state-e" GARDEN_USAGE_NOW="$NOW" \
  GARDEN_CCUSAGE_LOGDIR="$EPOCH_LOGS" bash -c 'source "$1/common.sh"; meter_window_total anchor' _ "$JOBS")"
[ "$epoch_total" = 100 ] && ok "mid-week entitlement boundary excludes the prior server epoch" \
  || bad "entitlement boundary total was $epoch_total, expected 100"

unknown="$(GARDEN=testhost GARDEN_STATE="$TR/state-u" GARDEN_USAGE_NOW="$NOW" \
  GARDEN_CCUSAGE_LOGDIR="$TR/missing" GARDEN_USAGE_LEDGER="$TR/no-ledger" GARDEN_BUDGET_POOLS_FILE="$CFG" \
  bash -c 'source "$1/common.sh"; pool_admits anthropic:testhost; echo rc=$?' _ "$JOBS")"
[[ "$unknown" = $'unknown\nrc=0' ]] && ok "unreadable configured meter admits fail-open" || bad "fail-open result: $unknown"

seed_board() { # bare [plan]
  local bare="$1" seed="$1-seed"
  git init -q --bare "$bare"; git init -q "$seed"; git -C "$seed" checkout -q -b journal2
  mkdir -p "$seed"/{jobs/{plan,todo,doin,tada},inbox/maintainer/{unread,read},config,hosts,usage}
  touch "$seed"/jobs/{plan,todo,doin,tada}/.gitkeep "$seed"/inbox/maintainer/{unread,read}/.gitkeep "$seed"/usage/.gitkeep
  cp "$CFG" "$seed/config/budget-pools"
  printf 'gardeners: 2\n' > "$seed/hosts/testhost"
  git -C "$seed" add -A; git -C "$seed" "${git_id[@]}" commit -qm seed
  git -C "$seed" remote add origin "$bare"; git -C "$seed" push -q -u origin journal2
}
view_has() { local bare="$1" path="$2"; git --git-dir="$bare" cat-file -e "journal2:$path" 2>/dev/null; }

# Direct posts park under the reusable budget-hold gate.
BARE="$TR/post.git"; seed_board "$BARE"
printf '# held\n' | env GARDEN_TEST=1 GARDEN=testhost GARDEN_STATE="$TR/post-state" JOURNAL_REMOTE="$BARE" \
  GARDEN_USAGE_NOW="$NOW" GARDEN_CCUSAGE_LOGDIR="$LOGS" "$JOBS/post-job.sh" held >/dev/null
if view_has "$BARE" jobs/plan/held.md && ! view_has "$BARE" jobs/todo/held.md \
   && git --git-dir="$BARE" show journal2:jobs/plan/held.md | grep -q '^budget_hold: true$'; then
  ok "direct post routes to plan/ --budget-hold at fleet backoff"
else bad "direct post did not budget-hold"; fi

env GARDEN_TEST=1 GARDEN=testhost GARDEN_STATE="$TR/publish-state" JOURNAL_REMOTE="$BARE" \
  GARDEN_USAGE_NOW="$NOW" GARDEN_CCUSAGE_LOGDIR="$LOGS" GARDEN_NO_MAINTAINER_ALERT=1 \
  bash -c 'source "$1/common.sh"; d="$2"; ensure_clone "$d"; sync_clone "$d"; budget_publish_local_pool "$d"' \
  _ "$JOBS" "$TR/publish-state/journal"
view_has "$BARE" budget/live/testhost \
  && ok "per-host scaler publisher exports the exact anchored session reading" \
  || bad "live budget snapshot was not published"

# Claim gate leaves todo untouched and returns no-work.
CBARE="$TR/claim.git"; seed_board "$CBARE"
CSEED="$CBARE-seed"; printf '# claim me\n' > "$CSEED/jobs/todo/claim-me.md"
git -C "$CSEED" add jobs/todo/claim-me.md; git -C "$CSEED" "${git_id[@]}" commit -qm todo; git -C "$CSEED" push -q
set +e
COUT="$(env GARDEN_TEST=1 GARDEN=testhost GARDEN_STATE="$TR/claim-state" JOURNAL_REMOTE="$CBARE" \
  GARDEN_WORKER_CLONE="$TR/claim-state/worker/journal" GARDEN_GARDENER_CLONE="$TR/claim-state/worker/journal" \
  GARDEN_USAGE_NOW="$NOW" GARDEN_CCUSAGE_LOGDIR="$LOGS" GARDEN_WORKER_KIND=gardener \
  "$JOBS/claim-job.sh" 1 2>&1)"
crc=$?
set -e
[ "$crc" -eq 3 ] && view_has "$CBARE" jobs/todo/claim-me.md \
  && ok "claim gate declines confirmed-backoff host without moving the job" \
  || bad "claim gate rc=$crc or moved todo: $COUT"

# With provider fallback enabled, the old current-provider pump gate is bypassed;
# this proves the fleet gate itself stops deferred promotion.
FBARE="$TR/foreman.git"; seed_board "$FBARE"
FSEED="$FBARE-seed"
printf '%s\n' '---' 'gate: deferred' 'priority: normal' '---' '# deferred' > "$FSEED/jobs/plan/deferred.md"
git -C "$FSEED" add jobs/plan/deferred.md; git -C "$FSEED" "${git_id[@]}" commit -qm plan; git -C "$FSEED" push -q
mkdir -p "$TR/foreman-state/foreman"; printf '0\n' > "$TR/foreman-state/foreman/idle-since"
env GARDEN_TEST=1 GARDEN=testhost GARDEN_STATE="$TR/foreman-state" JOURNAL_REMOTE="$FBARE" \
  GARDEN_USAGE_NOW="$NOW" GARDEN_FOREMAN_NOW="$NOW" GARDEN_CCUSAGE_LOGDIR="$LOGS" \
  GARDEN_FOREMAN_IDLE_SETTLE=0 GARDEN_FOREMAN_ACTIVE_TARGET=1 \
  GARDEN_FOREMAN_HANDLER="$JOBS/handlers/foreman-claude.sh" GARDEN_FOREMAN_PROVIDER_ORDER=openai \
  "$JOBS/foreman.sh" >/dev/null 2>&1
view_has "$FBARE" jobs/plan/deferred.md && ! view_has "$FBARE" jobs/todo/deferred.md \
  && ok "foreman fleet gate halts deferred batch promotion" || bad "foreman promoted during fleet backoff"

# Leveling lowers the spent local pool and raises the empty remote pool. The
# actuator seams record decisions without changing real worker units or the bus.
LBARE="$TR/level.git"; seed_board "$LBARE"
LSEED="$LBARE-seed"
printf '%s\n' \
  'anthropic:testhost anthropic testhost weekly-tokens 1000' \
  'anthropic:missinghost anthropic missinghost weekly-tokens 1000' \
  'anthropic:failhost anthropic failhost weekly-tokens 1000' \
  'anthropic:otherhost anthropic otherhost weekly-tokens 1000' > "$LSEED/config/budget-pools"
printf 'gardeners: 2\n' > "$LSEED/hosts/failhost"
printf 'gardeners: 2\n' > "$LSEED/hosts/otherhost"
git -C "$LSEED" add config/budget-pools hosts/failhost hosts/otherhost; git -C "$LSEED" "${git_id[@]}" commit -qm pools; git -C "$LSEED" push -q
ACT="$TR/act.log"; : > "$ACT"
printf '#!/bin/bash\nprintf "local %%s %%s\\n" "$1" "$2" >> "$ACT"\nexit 17\n' > "$TR/set"
printf '#!/bin/bash\nprintf "remote %%s %%s %%s %%s\\n" "$1" "$2" "$3" "$4" >> "$ACT"\n[ "$1" != failhost ] || exit 23\n' > "$TR/send"
chmod +x "$TR/set" "$TR/send"
LOUT="$TR/level.out"
env GARDEN_TEST=1 GARDEN=testhost GARDEN_LEADER=testhost GARDEN_STATE="$TR/level-state" JOURNAL_REMOTE="$LBARE" \
  GARDEN_USAGE_NOW="$NOW" GARDEN_CCUSAGE_LOGDIR="$LOGS" GARDEN_NO_MAINTAINER_ALERT=1 ACT="$ACT" \
  GARDEN_BUDGET_LEVEL_SET_WORKERS="$TR/set" GARDEN_BUDGET_LEVEL_SEND_HOST_OP="$TR/send" \
  "$JOBS/budget-level.sh" >"$LOUT" 2>&1
grep -q '^local gardener 1$' "$ACT" && grep -q '^remote otherhost op=set-workers kind=gardener count=4$' "$ACT" \
  && ok "failed local actuation does not prevent later pool actuation" \
  || bad "leveling actions: $(tr '\n' ';' < "$ACT")"
grep -q 'pool=anthropic:testhost host=testhost operation=set-local-workers failed exit_status=17' "$LOUT" \
  && ok "actuation diagnostic identifies pool, host, operation, and exit status" \
  || bad "missing actuation diagnostic: $(tr '\n' ';' < "$LOUT")"
grep -q 'pool=anthropic:missinghost host=missinghost operation=read-host-workers failed exit_status=2' "$LOUT" \
  && ok "read diagnostic identifies pool, host, operation, and exit status" \
  || bad "missing read diagnostic: $(tr '\n' ';' < "$LOUT")"
grep -q 'pool=anthropic:failhost host=failhost operation=send-host-set-workers failed exit_status=23' "$LOUT" \
  && ok "failed remote actuation is isolated and fully diagnosed" \
  || bad "missing remote actuation diagnostic: $(tr '\n' ';' < "$LOUT")"

set +e
env GARDEN_TEST=1 GARDEN=testhost GARDEN_LEADER=testhost GARDEN_STATE="$TR/level-state-scheduled" JOURNAL_REMOTE="$LBARE" \
  GARDEN_USAGE_NOW="$NOW" GARDEN_CCUSAGE_LOGDIR="$LOGS" GARDEN_NO_MAINTAINER_ALERT=1 ACT="$ACT" \
  GARDEN_BUDGET_LEVEL_SET_WORKERS="$TR/set" GARDEN_BUDGET_LEVEL_SEND_HOST_OP="$TR/send" \
  "$JOBS/budget-level.sh" scheduled >/dev/null 2>&1
lrc=$?
set -e
[ "$lrc" -eq 2 ] && ok "per-pool failures preserve scheduled-dispatch exit contract" \
  || bad "scheduled leveler returned $lrc instead of 2"

# A transient journal outage in the clone/sync PREFLIGHT must not collapse into a
# raw controller exit code. ensure_clone succeeds cloning the seeded bare, then an
# injected offline fetch drives sync_clone's `exit GARDEN_OFFLINE_RC`; budget-level
# catches it in its preflight subshell, logs an explicit offline diagnostic, and
# fails open — exit 0 as a controller, 2 as a scheduled preflight — actuating nothing.
OFETCH="$EXECDIR/offline-fetch"
printf '#!/bin/bash\necho "fatal: unable to access '\''origin'\'': Could not resolve host: journal.invalid" >&2\nexit 128\n' > "$OFETCH"
chmod +x "$OFETCH"
: > "$ACT"
POUT="$TR/preflight-offline.out"
set +e
env GARDEN_TEST=1 GARDEN=testhost GARDEN_LEADER=testhost GARDEN_STATE="$TR/preflight-offline-state" JOURNAL_REMOTE="$LBARE" \
  GARDEN_USAGE_NOW="$NOW" GARDEN_CCUSAGE_LOGDIR="$LOGS" GARDEN_NO_MAINTAINER_ALERT=1 ACT="$ACT" \
  GARDEN_FETCH_CMD="$OFETCH" GARDEN_FETCH_RETRIES=1 \
  GARDEN_BUDGET_LEVEL_SET_WORKERS="$TR/set" GARDEN_BUDGET_LEVEL_SEND_HOST_OP="$TR/send" \
  "$JOBS/budget-level.sh" >"$POUT" 2>&1
prc=$?
set -e
# GARDEN_OFFLINE_RC's default (common.sh) is EX_TEMPFAIL 75; the diagnostic echoes it.
if [ "$prc" -eq 0 ] && grep -q 'budget-level preflight offline' "$POUT" && grep -qi 'rc=75' "$POUT" && [ ! -s "$ACT" ]; then
  ok "transient preflight outage fails open (rc=0) with an explicit isolated diagnostic and no actuation"
else
  bad "preflight-offline: rc=$prc act=$(tr '\n' ';' < "$ACT") log=$(tr '\n' ';' < "$POUT")"
fi

set +e
env GARDEN_TEST=1 GARDEN=testhost GARDEN_LEADER=testhost GARDEN_STATE="$TR/preflight-offline-sched-state" JOURNAL_REMOTE="$LBARE" \
  GARDEN_USAGE_NOW="$NOW" GARDEN_CCUSAGE_LOGDIR="$LOGS" GARDEN_NO_MAINTAINER_ALERT=1 ACT="$ACT" \
  GARDEN_FETCH_CMD="$OFETCH" GARDEN_FETCH_RETRIES=1 \
  GARDEN_BUDGET_LEVEL_SET_WORKERS="$TR/set" GARDEN_BUDGET_LEVEL_SEND_HOST_OP="$TR/send" \
  "$JOBS/budget-level.sh" scheduled >/dev/null 2>&1
psrc=$?
set -e
[ "$psrc" -eq 2 ] && ok "transient preflight outage preserves scheduled no-work exit contract (2)" \
  || bad "scheduled preflight-offline returned $psrc instead of 2"

# A HARD (non-offline, non-corrupt) fetch failure drives sync_clone's `die`; the
# preflight subshell isolates it, and budget-level fails open with a distinct
# hard-failure diagnostic rather than crashing on the raw controller exit code.
HFETCH="$EXECDIR/hard-fetch"
printf '#!/bin/bash\necho "fatal: some non-transient repository error" >&2\nexit 1\n' > "$HFETCH"
chmod +x "$HFETCH"
: > "$ACT"
HPOUT="$TR/preflight-hard.out"
set +e
env GARDEN_TEST=1 GARDEN=testhost GARDEN_LEADER=testhost GARDEN_STATE="$TR/preflight-hard-state" JOURNAL_REMOTE="$LBARE" \
  GARDEN_USAGE_NOW="$NOW" GARDEN_CCUSAGE_LOGDIR="$LOGS" GARDEN_NO_MAINTAINER_ALERT=1 ACT="$ACT" \
  GARDEN_FETCH_CMD="$HFETCH" GARDEN_FETCH_RETRIES=1 \
  GARDEN_BUDGET_LEVEL_SET_WORKERS="$TR/set" GARDEN_BUDGET_LEVEL_SEND_HOST_OP="$TR/send" \
  "$JOBS/budget-level.sh" >"$HPOUT" 2>&1
hrc=$?
set -e
if [ "$hrc" -eq 0 ] && grep -q 'budget-level preflight failed' "$HPOUT" && [ ! -s "$ACT" ]; then
  ok "hard preflight failure fails open (rc=0) with a distinct isolated diagnostic and no actuation"
else
  bad "preflight-hard: rc=$hrc act=$(tr '\n' ';' < "$ACT") log=$(tr '\n' ';' < "$HPOUT")"
fi

# The scheduler wrapper preserves the controller's concrete failure evidence and
# pages once under a stable key instead of emitting only a generic warning every
# 15 minutes. alert_maintainer's throttle coalesces the repeated tick; a later
# success closes the episode and re-arms a subsequent failure immediately.
printf '#!/bin/bash\necho "fixture controller exploded: bad pool row" >&2\nexit 37\n' > "$TR/level-controller"
chmod +x "$TR/level-controller"
ALERT_SINK="$HERE/budget-alert-record-stub.sh"
ALERT_LOG="$TR/alerts.log"; : > "$ALERT_LOG"
SCHED_LOG="$TR/scheduler-budget.log"
for tick in 1 2; do
  env GARDEN_TEST=1 GARDEN=testhost GARDEN_STATE="$TR/scheduler-budget-state" JOURNAL_REMOTE="$LBARE" \
    GARDEN_SCHEDULER_CLONE="$TR/scheduler-budget-state/journal" GARDEN_SCHEDULER_NOW=$(( NOW + tick )) \
    GARDEN_BUDGET_LEVEL_CONTROLLER="$TR/level-controller" GARDEN_ALERT_CMD="$ALERT_SINK" GARDEN_ALERT_RECORD="$ALERT_LOG" \
    "$JOBS/scheduler.sh" >>"$SCHED_LOG" 2>&1
done
if [ "$(grep -c '^KEY=' "$ALERT_LOG")" -eq 1 ] \
   && grep -q '^KEY=scheduler-budget-level-failed$' "$ALERT_LOG" \
   && grep -q 'exit_status=37' "$ALERT_LOG" \
   && grep -q 'fixture.*controller.*exploded:.*bad.*pool.*row' "$ALERT_LOG"; then
  ok "scheduler sends one deduplicated budget-level alert with exit status and stderr"
else
  bad "budget-level alert did not preserve/deduplicate diagnostics: $(tr '\n' ';' < "$ALERT_LOG")"
fi
[ "$(grep -c 'fixture controller exploded: bad pool row' "$SCHED_LOG")" -eq 2 ] \
  && ok "scheduler log retains controller stderr on every failed tick" \
  || bad "scheduler log lost controller stderr: $(tr '\n' ';' < "$SCHED_LOG")"
printf '#!/bin/bash\nexit 0\n' > "$TR/level-controller"
env GARDEN_TEST=1 GARDEN=testhost GARDEN_STATE="$TR/scheduler-budget-state" JOURNAL_REMOTE="$LBARE" \
  GARDEN_SCHEDULER_CLONE="$TR/scheduler-budget-state/journal" GARDEN_SCHEDULER_NOW=$(( NOW + 3 )) \
  GARDEN_BUDGET_LEVEL_CONTROLLER="$TR/level-controller" GARDEN_ALERT_CMD="$ALERT_SINK" GARDEN_ALERT_RECORD="$ALERT_LOG" \
  "$JOBS/scheduler.sh" >/dev/null 2>&1
printf '#!/bin/bash\necho "fixture controller exploded: bad pool row" >&2\nexit 37\n' > "$TR/level-controller"
env GARDEN_TEST=1 GARDEN=testhost GARDEN_STATE="$TR/scheduler-budget-state" JOURNAL_REMOTE="$LBARE" \
  GARDEN_SCHEDULER_CLONE="$TR/scheduler-budget-state/journal" GARDEN_SCHEDULER_NOW=$(( NOW + 4 )) \
  GARDEN_BUDGET_LEVEL_CONTROLLER="$TR/level-controller" GARDEN_ALERT_CMD="$ALERT_SINK" GARDEN_ALERT_RECORD="$ALERT_LOG" \
  "$JOBS/scheduler.sh" >/dev/null 2>&1
if [ "$(grep -c '^KEY=' "$ALERT_LOG")" -eq 3 ] \
   && grep -q '^MSG=RECOVERED:' "$ALERT_LOG" \
   && [ "$(grep -c 'exit_status=37' "$ALERT_LOG")" -eq 2 ]; then
  ok "controller recovery closes and re-arms the deduplicated failure episode"
else
  bad "budget-level alert did not recover/re-arm: $(tr '\n' ';' < "$ALERT_LOG")"
fi

echo "RESULT: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
