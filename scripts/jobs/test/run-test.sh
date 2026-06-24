#!/bin/bash
# run-test.sh — validate the garden job system on throwaway fixtures.
#
# Subtests:
#   1. CONCURRENCY  — N gardeners race a git-backed board of M jobs; assert
#      every job is completed exactly once (no double-claim) and that multiple
#      gardeners made overlapping (concurrent) progress.
#   2. MESSAGE BUS  — a message sent to role/gardener and to job/<base> is
#      delivered once to a monitoring agent and not redelivered.
#   3. REPO WATCHER — adding/removing a repo file in the journal arms/disarms
#      the matching triager unit (via a mocked systemctl).
#
# systemd is not required: gardeners run as concurrent background processes,
# exercising the identical claim/complete code that a garden-gardener@N.service
# would run. The coordination being tested lives in the scripts, not in systemd.
#
# Usage: run-test.sh [num-jobs] [num-gardeners]

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
NJOBS="${1:-12}"
G="${2:-4}"
BRANCH=journal2
TR=/home/kris/.garden-test
PASS=0; FAIL=0
ok()   { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad()  { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()   { echo "----------------------------------------------------------------"; }

rm -rf "$TR"; mkdir -p "$TR/logs"
BARE="$TR/journal.git"

# --- helpers ----------------------------------------------------------------
git_id=(-c user.name=test -c user.email=test@localhost)
push_change() {  # push_change <subdir-relative-path> <content|@DELETE>  <msg>
  local path="$1" content="$2" msg="$3" wt; wt="$(mktemp -d "$TR/edit.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  if [ "$content" = "@DELETE" ]; then git -C "$wt" rm -q "$path"
  else mkdir -p "$(dirname "$wt/$path")"; printf '%s\n' "$content" > "$wt/$path"; git -C "$wt" add "$path"; fi
  git -C "$wt" "${git_id[@]}" commit -q -m "$msg"
  git -C "$wt" push -q origin "HEAD:$BRANCH"
  rm -rf "$wt"
}

# --- seed the shared origin -------------------------------------------------
git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
( cd "$SEED"
  mkdir -p jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors \
           inbox/maintainer/unread inbox/maintainer/read
  for d in jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors \
           inbox/maintainer/unread inbox/maintainer/read; do touch "$d/.gitkeep"; done
  for n in $(seq 1 "$NJOBS"); do
    b="$(printf 'job-%03d' "$n")"
    printf '# %s\n\ndo the work for %s\n' "$b" "$b" > "jobs/todo/$b.md"
  done )
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m "seed: $NJOBS jobs + structure"
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

# common env for the scripts (point them at the throwaway journal)
export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH"

# ============================================================================
hr; echo "SUBTEST 1 — CONCURRENCY: $G gardeners vs $NJOBS jobs"; hr
START="$(date +%s.%N)"
pids=()
for i in $(seq 1 "$G"); do
  env GARDEN_HOST="host-$i" GARDEN_STATE="$TR/state" \
      GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 \
      GARDEN_JOB_HANDLER="$HERE/stub-handler.sh" \
      "$JOBS/gardener.sh" "$i" > "$TR/logs/gardener-$i.log" 2>&1 &
  pids+=($!)
done
# wait with a safety timeout
( sleep 180; kill "${pids[@]}" 2>/dev/null ) & WD=$!
wait "${pids[@]}" 2>/dev/null || true
kill "$WD" 2>/dev/null || true
END="$(date +%s.%N)"
echo "  gardeners finished in $(awk "BEGIN{printf \"%.1f\", $END-$START}")s"

V="$TR/verify"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"
ntada=$(ls -1 "$V/jobs/tada" | grep -vxc '.gitkeep' || true)
ntodo=$(ls -1 "$V/jobs/todo" | grep -vxc '.gitkeep' || true)
ndoin=$(ls -1 "$V/jobs/doin" | grep -vxc '.gitkeep' || true)
nwork=$(ls -1 "$V/work"      | grep -vxc '.gitkeep' || true)
[ "$ntada" -eq "$NJOBS" ] && ok "all $NJOBS jobs reached tada"            || bad "tada=$ntada (want $NJOBS)"
[ "$ntodo" -eq 0 ]        && ok "todo drained"                            || bad "todo not empty ($ntodo)"
[ "$ndoin" -eq 0 ]        && ok "doin empty (no stuck claims)"            || bad "doin not empty ($ndoin)"
[ "$nwork" -eq 0 ]        && ok "work/ empty (worktree state cleaned)"    || bad "work not empty ($nwork)"

# exactly-once: one accepted claim commit per distinct basename
nclaim=$(git -C "$V" log --pretty=%s | grep -c '^claim(' || true)
nclaim_u=$(git -C "$V" log --pretty=%s | grep -oE '^claim\([^)]+\)' | sort -u | grep -c . || true)
[ "$nclaim" -eq "$NJOBS" ] && [ "$nclaim_u" -eq "$NJOBS" ] \
  && ok "exactly $NJOBS claims, all distinct (no double-claim won)" \
  || bad "claims=$nclaim distinct=$nclaim_u (want $NJOBS/$NJOBS)"

# concurrency evidence: >1 gardener completed work, and intervals overlap
ngard=$(grep -h '^gardener:' "$V"/jobs/tada/job-* | awk '{print $2}' | sort -u | grep -c . || true)
[ "$ngard" -gt 1 ] && ok "$ngard distinct gardeners contributed" || bad "only $ngard gardener(s) contributed"

overlap=$(
  for f in "$V"/jobs/tada/job-*; do
    g=$(awk '/^gardener:/{print $2}' "$f"); s=$(awk '/^start_epoch:/{print $2}' "$f"); e=$(awk '/^end_epoch:/{print $2}' "$f")
    echo "$g $s $e"
  done | awk '
    {g[NR]=$1; s[NR]=$2; e[NR]=$3; n=NR}
    END{c=0; for(i=1;i<=n;i++)for(j=i+1;j<=n;j++) if(g[i]!=g[j] && s[i]<e[j] && s[j]<e[i]) c++; print c}'
)
[ "${overlap:-0}" -gt 0 ] && ok "$overlap overlapping job pairs across gardeners (true concurrency)" \
                          || bad "no overlapping processing windows (no concurrency observed)"

# ============================================================================
hr; echo "SUBTEST 2 — MESSAGE BUS: role + job addressed delivery"; hr
export GARDEN_STATE="$TR/state-msg"
echo "hello gardeners" | "$JOBS/send-msg.sh" role/gardener >/dev/null
set +e
out1="$("$JOBS/read-msgs.sh" probe-agent role/gardener broadcast)"; c1=$?
out2="$("$JOBS/read-msgs.sh" probe-agent role/gardener broadcast)"; c2=$?
set -e
{ [ "$c1" -eq 1 ] && grep -q "hello gardeners" <<<"$out1"; } && ok "role/gardener message delivered once" || bad "role delivery (count=$c1)"
[ "$c2" -eq 0 ] && ok "message not redelivered (seen-marker works)" || bad "message redelivered (count=$c2)"

# ============================================================================
hr; echo "SUBTEST 4 — GARDENER-SCALER: reconcile pool to journal host count"; hr
export GARDEN_STATE="$TR/state-scale" GARDEN_HOST=testhost
export GARDEN_MOCK_STATE="$TR/armed-g" GARDEN_MOCK_LOG="$TR/unitlog-g" GARDEN_UNIT_CTL="$HERE/mock-systemctl.sh"
: > "$GARDEN_MOCK_STATE"; : > "$GARDEN_MOCK_LOG"
"$JOBS/set-gardeners.sh" 3 testhost >/dev/null
"$JOBS/gardener-scaler.sh" >/dev/null 2>&1
armed3=$(grep -c '^garden-gardener@[123]\.service$' "$GARDEN_MOCK_STATE" || true)
has4=$(grep -c '^garden-gardener@4\.service$' "$GARDEN_MOCK_STATE" || true)
{ [ "$armed3" -eq 3 ] && [ "$has4" -eq 0 ]; } && ok "host count 3 → gardener@{1,2,3} armed" || bad "scale-up (armed @1-3=$armed3, @4=$has4)"
"$JOBS/set-gardeners.sh" 1 testhost >/dev/null
"$JOBS/gardener-scaler.sh" >/dev/null 2>&1
armed_after=$(grep -c '^garden-gardener@1\.service$' "$GARDEN_MOCK_STATE" || true)
extra_after=$(grep -c '^garden-gardener@[23]\.service$' "$GARDEN_MOCK_STATE" || true)
{ [ "$armed_after" -eq 1 ] && [ "$extra_after" -eq 0 ]; } && ok "host count 1 → scaled down to gardener@1" || bad "scale-down (@1=$armed_after, @2-3=$extra_after)"
unset GARDEN_UNIT_CTL GARDEN_MOCK_STATE GARDEN_MOCK_LOG

# ============================================================================
hr; echo "SUBTEST 5 — INBOX: per-doer unread→read CAS + lifecycle"; hr
export GARDEN_STATE="$TR/state-inbox" GARDEN_HOST=ibhost
push_change "jobs/todo/inbox-demo.md" "# inbox-demo" "seed inbox-demo job"
ibclaim="$("$JOBS/claim-job.sh" 9)"
[ "$ibclaim" = "inbox-demo" ] && ok "claim created job doer 'inbox-demo'" || bad "claim returned '$ibclaim'"
I="$TR/iv"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$I"
[ -d "$I/inbox/inbox-demo/unread" ] && ok "inbox created at claim" || bad "inbox dir missing after claim"
echo "hello doer 1" | "$JOBS/inbox-send.sh" inbox-demo >/dev/null
echo "hello doer 2" | "$JOBS/inbox-send.sh" inbox-demo >/dev/null
set +e; ibout="$("$JOBS/inbox-read.sh" inbox-demo)"; ibc=$?; set -e
{ [ "$ibc" -eq 2 ] && grep -q "hello doer 1" <<<"$ibout" && grep -q "hello doer 2" <<<"$ibout"; } \
  && ok "2 messages read (unread→read CAS)" || bad "inbox read (count=$ibc)"
rm -rf "$I"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$I"
nun=$(ls -1 "$I/inbox/inbox-demo/unread" | grep -vxc '.gitkeep' || true)
nrd=$(ls -1 "$I/inbox/inbox-demo/read"   | grep -vxc '.gitkeep' || true)
{ [ "$nun" -eq 0 ] && [ "$nrd" -eq 2 ]; } && ok "after read: unread=0 read=2" || bad "states (unread=$nun read=$nrd)"
set +e; "$JOBS/inbox-read.sh" inbox-demo >/dev/null; ibc2=$?; set -e
[ "$ibc2" -eq 0 ] && ok "re-read yields 0 (no redelivery)" || bad "re-read count=$ibc2"
set +e; echo x | "$JOBS/inbox-send.sh" no-such-doer >/dev/null 2>&1; sndrc=$?; set -e
[ "$sndrc" -ne 0 ] && ok "send to inactive doer refused" || bad "send to inactive doer succeeded"
rpt="$(mktemp)"; echo "done" > "$rpt"; "$JOBS/complete-job.sh" 9 inbox-demo "$rpt" >/dev/null
rm -rf "$I"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$I"
[ -d "$I/inbox/inbox-demo" ] && bad "inbox not destroyed at completion" || ok "inbox destroyed at completion"

# ============================================================================
hr; echo "SUBTEST 3 — REPO WATCHER: watch-set reconciliation"; hr
export GARDEN_STATE="$TR/state-rw"
export GARDEN_MOCK_STATE="$TR/armed" GARDEN_MOCK_LOG="$TR/unitlog"
export GARDEN_UNIT_CTL="$HERE/mock-systemctl.sh"
: > "$GARDEN_MOCK_STATE"; : > "$GARDEN_MOCK_LOG"
push_change "repos/kriscendobot-endo" "watch" "watch: kriscendobot-endo"
"$JOBS/repo-watcher.sh" >/dev/null 2>&1
grep -qxF "garden-triager@kriscendobot-endo.timer" "$GARDEN_MOCK_STATE" \
  && ok "watch → armed garden-triager@kriscendobot-endo.timer" || bad "triager not armed on watch"
push_change "repos/kriscendobot-endo" "@DELETE" "unwatch: kriscendobot-endo"
"$JOBS/repo-watcher.sh" >/dev/null 2>&1
grep -qxF "garden-triager@kriscendobot-endo.timer" "$GARDEN_MOCK_STATE" \
  && bad "triager still armed after unwatch" || ok "unwatch → disarmed triager unit"

# ============================================================================
hr; echo "SUBTEST 6 — MAINTAINER CHANNEL: gardener↔user via liaison, in-flight"; hr
export GARDEN_STATE="$TR/state-maint" GARDEN_HOST=mhost
push_change "jobs/todo/maint-demo.md" "# maint-demo" "seed maint-demo job"
mbase="$("$JOBS/claim-job.sh" 7)"      # doer becomes active, inbox created
[ "$mbase" = "maint-demo" ] && ok "doer 'maint-demo' active (working)" || bad "claim returned '$mbase'"
echo "need a decision on X" | "$JOBS/message-user.sh" maint-demo >/dev/null
watch="$("$JOBS/maintainer-watch.sh")"
{ grep -q "need a decision on X" <<<"$watch" && grep -q "reply_to: maint-demo" <<<"$watch"; } \
  && ok "liaison watch surfaces user-addressed message with reply_to" || bad "maintainer-watch missed the message"
# maintainer replies (routes to the doer's inbox, archives the maintainer msg)
MV="$TR/mv"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$MV"
mid="$(ls -1 "$MV/inbox/maintainer/unread" | grep -vx '.gitkeep' | head -1)"
echo "decision: do Y" | "$JOBS/maintainer-reply.sh" "$mid" >/dev/null
# the still-working doer receives the reply via its own inbox monitor
set +e; mr="$("$JOBS/inbox-read.sh" maint-demo)"; mrc=$?; set -e
{ [ "$mrc" -ge 1 ] && grep -q "decision: do Y" <<<"$mr"; } \
  && ok "working gardener received maintainer reply in its inbox" || bad "doer did not receive reply (count=$mrc)"
rm -rf "$MV"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$MV"
mun=$(ls -1 "$MV/inbox/maintainer/unread" | grep -vxc '.gitkeep' || true)
[ "$mun" -eq 0 ] && ok "maintainer message archived after reply" || bad "maintainer unread not archived ($mun)"
rpt2="$(mktemp)"; echo done > "$rpt2"; "$JOBS/complete-job.sh" 7 maint-demo "$rpt2" >/dev/null

# ============================================================================
hr; echo "SUBTEST 7 — SENSE: heuristic automation gating"; hr
SENSE="$JOBS/gardening/sense.sh"
SW="$TR/sense-wt"; rm -rf "$SW"; git init -q "$SW"
git -C "$SW" config user.email t@l; git -C "$SW" config user.name t
mkdir -p "$SW/src"; echo "x=1" > "$SW/src/a.py"; echo "# doc" > "$SW/README.md"
git -C "$SW" add -A; git -C "$SW" commit -q -m base
echo "more" >> "$SW/README.md"; printf 'import os\nx=2\n' > "$SW/src/a.py"
git -C "$SW" add -A; git -C "$SW" commit -q -m change
"$SENSE" changed-md "$SW"            && ok "changed-md detects a Markdown change"        || bad "changed-md missed md"
"$SENSE" diff-keyword "$SW" import   && ok "diff-keyword detects 'import' in the diff"   || bad "diff-keyword missed import"
"$SENSE" changed-glob "$SW" '*.go'   && bad "changed-glob false positive on *.go"        || ok "changed-glob says no for *.go (no false positive)"
"$SENSE" changed-md "$SW" HEAD~9     && ok "unknown base → assume YES (false-positive bias)" || bad "should assume yes on bad base"

# ============================================================================
hr; echo "SUBTEST 8 — SCHEDULER: cadence dispatch + last-dispatched stamp"; hr
export GARDEN_STATE="$TR/state-sched" GARDEN_HOST=shost
echo "# tick task"   | "$JOBS/set-schedule.sh" tick   1s     tickjob >/dev/null
echo "# weekly task" | "$JOBS/set-schedule.sh" report weekly wrjob   >/dev/null
count_pref() { git clone -q --single-branch --branch "$BRANCH" "$BARE" "$TR/sv.$1" 2>/dev/null; \
  ls -1 "$TR/sv.$1/jobs/todo" | grep -c "^$2" || true; rm -rf "$TR/sv.$1"; }
"$JOBS/scheduler.sh" >/dev/null 2>&1
t1=$(count_pref a tickjob); w1=$(count_pref b wrjob)
{ [ "$t1" -ge 1 ] && [ "$w1" -ge 1 ]; } && ok "first tick dispatched both due schedules" || bad "first dispatch (tick=$t1 weekly=$w1)"
"$JOBS/scheduler.sh" >/dev/null 2>&1
t2=$(count_pref c tickjob); w2=$(count_pref d wrjob)
{ [ "$t2" -eq "$t1" ] && [ "$w2" -eq "$w1" ]; } && ok "immediate re-run dispatches nothing (cadence not elapsed)" || bad "re-run dispatched (tick $t1→$t2, weekly $w1→$w2)"
sleep 1.2
"$JOBS/scheduler.sh" >/dev/null 2>&1
t3=$(count_pref e tickjob); w3=$(count_pref f wrjob)
{ [ "$t3" -gt "$t2" ] && [ "$w3" -eq "$w2" ]; } && ok "after 1s only the 1s-cadence tick re-dispatches" || bad "cadence (tick $t2→$t3, weekly $w2→$w3)"

# ============================================================================
hr; echo "SUBTEST 9 — WATCHMAN: aggressive main2 checkout + reread broadcast"; hr
export GARDEN_STATE="$TR/state-wm" GARDEN_HOST=wmhost
GBARE="$TR/garden.git"; git init -q --bare "$GBARE"
GW="$TR/garden-wt"; git init -q "$GW"; git -C "$GW" checkout -q -b main2
git -C "$GW" config user.email t@l; git -C "$GW" config user.name t
mkdir -p "$GW/roles"; echo "v1" > "$GW/roles/x.md"
git -C "$GW" add -A; git -C "$GW" commit -q -m base; git -C "$GW" remote add origin "$GBARE"; git -C "$GW" push -q -u origin main2
G2="$TR/garden-up"; git clone -q "$GBARE" "$G2"; git -C "$G2" checkout -q main2
echo "v2" > "$G2/roles/x.md"; git -C "$G2" "${git_id[@]}" commit -qam evolve; git -C "$G2" push -q origin main2
upsha="$(git -C "$G2" rev-parse HEAD)"
env GARDEN_ROOT="$GW" GARDEN_MAIN_BRANCH=main2 GARDEN_WATCH_HANDLER=/bin/true \
    "$JOBS/watchman.sh" >/dev/null 2>&1
locsha="$(git -C "$GW" rev-parse main2)"
[ "$locsha" = "$upsha" ] && ok "aggressively fast-forwarded local main2 to upstream" || bad "main2 not updated ($locsha != $upsha)"
set +e; wmout="$("$JOBS/read-msgs.sh" probe-wm broadcast)"; wmc=$?; set -e
{ [ "$wmc" -ge 1 ] && grep -qi "reread" <<<"$wmout"; } && ok "broadcast told gardeners to reread roles/skills" || bad "no reread broadcast (count=$wmc)"

# ============================================================================
hr; echo "SUBTEST 10 — BULLETIN: reliable regenerate + idempotency"; hr
export GARDEN_STATE="$TR/state-bul" GARDEN_HOST=bhost
"$JOBS/bulletin.sh" >/dev/null 2>&1
BV="$TR/bv"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$BV"
{ [ -f "$BV/bulletin.md" ] && grep -q '^# Garden bulletin' "$BV/bulletin.md" && grep -q '^## Board' "$BV/bulletin.md"; } \
  && ok "bulletin.md generated with board section" || bad "bulletin not generated"
h1="$(git -C "$BV" rev-parse HEAD)"; rm -rf "$BV"
"$JOBS/bulletin.sh" >/dev/null 2>&1
git clone -q --single-branch --branch "$BRANCH" "$BARE" "$BV"; h2="$(git -C "$BV" rev-parse HEAD)"
[ "$h1" = "$h2" ] && ok "re-run with no change makes no commit (idempotent)" || bad "bulletin churned a commit"
rm -rf "$BV"
push_change "jobs/todo/bul-newjob.md" "# new" "add a job to change board state"
"$JOBS/bulletin.sh" >/dev/null 2>&1
git clone -q --single-branch --branch "$BRANCH" "$BARE" "$BV"
grep -q '^- todo: ' "$BV/bulletin.md" && [ "$(git -C "$BV" rev-parse HEAD)" != "$h2" ] \
  && ok "board change triggers a fresh bulletin" || bad "bulletin did not refresh on change"

# ============================================================================
hr; echo "SUBTEST 11 — MENTOR: log → improvement job (self-healing)"; hr
export GARDEN_STATE="$TR/state-imp" GARDEN_HOST=ihost
printf 'a connection error occurred during push\n' | GARDEN_ROLE=gardener "$JOBS/journal-entry.sh" error >/dev/null
env GARDEN_MENTOR_HANDLER="$HERE/mentor-stub.sh" "$JOBS/mentor.sh" >/dev/null 2>&1
IV="$TR/imv"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$IV"
nimp=$(ls -1 "$IV/jobs/todo" | grep -c '^improve-' || true)
[ "$nimp" -ge 1 ] && ok "error entry → improvement job posted" || bad "no improvement job ($nimp)"
rm -rf "$IV"
env GARDEN_MENTOR_HANDLER="$HERE/mentor-stub.sh" "$JOBS/mentor.sh" >/dev/null 2>&1
git clone -q --single-branch --branch "$BRANCH" "$BARE" "$IV"
nimp2=$(ls -1 "$IV/jobs/todo" | grep -c '^improve-' || true)
[ "$nimp2" -eq "$nimp" ] && ok "no new entries → silent, no duplicate job" || bad "re-run changed jobs ($nimp→$nimp2)"

# ============================================================================
hr; echo "SUBTEST 12 — CURSORS: durable poll position survives a restart"; hr
export GARDEN_HOST=curhost
printf 'last_event_id: 12345\nlast_polled_at: t0\n' \
  | GARDEN_STATE="$TR/state-cur-a" "$JOBS/cursor-set.sh" activity/kriscendobot-endo >/dev/null
# read back from a FRESH host-local state (simulates a restarted/recreated container)
got="$(GARDEN_STATE="$TR/state-cur-b" "$JOBS/cursor-get.sh" activity/kriscendobot-endo)"
grep -q 'last_event_id: 12345' <<<"$got" && ok "cursor survives wiped host-local state (resume after restart)" || bad "cursor lost across restart"
# advance, then a third fresh state still sees the new value
printf 'last_event_id: 67890\nlast_polled_at: t1\n' \
  | GARDEN_STATE="$TR/state-cur-a" "$JOBS/cursor-set.sh" activity/kriscendobot-endo >/dev/null
got2="$(GARDEN_STATE="$TR/state-cur-c" "$JOBS/cursor-get.sh" activity/kriscendobot-endo)"
grep -q 'last_event_id: 67890' <<<"$got2" && ok "advanced cursor is the shared resume point" || bad "cursor did not advance"

# ============================================================================
hr; echo "SUBTEST 13 — FOLLOW-UP: tada follow-ups → job/one-shot-schedule/maintainer"; hr
export GARDEN_STATE="$TR/state-fu" GARDEN_HOST=fuhost
# a report present at COLD START must NOT be acted on (only marked seen)
push_change "jobs/tada/fu-old.md" "$(printf '# old\n## Follow-ups\n- weaver rebase on endo-but-for-bots\n')" "seed pre-existing tada report"
env GARDEN_FOLLOWUP_HANDLER="$HERE/follow-up-stub.sh" "$JOBS/follow-up.sh" >/dev/null 2>&1
FV="$TR/fuv"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$FV"
nfu_cold=$(ls -1 "$FV/jobs/todo" | grep -c '^fu-' || true)
[ "$nfu_cold" -eq 0 ] && ok "cold start acts on nothing (existing reports marked seen)" || bad "cold start posted $nfu_cold job(s)"
rm -rf "$FV"
# a NEW report (produced after install) with an actionable follow-up section
push_change "jobs/tada/fu-new.md" "$(printf '# new\n## Follow-ups (escalated to liaison)\n- weaver rebase #197 then re-botany\n- confirm with the maintainer whether to continue #197\n')" "seed new tada report"
env GARDEN_FOLLOWUP_HANDLER="$HERE/follow-up-stub.sh" "$JOBS/follow-up.sh" >/dev/null 2>&1
git clone -q --single-branch --branch "$BRANCH" "$BARE" "$FV"
job1=$(ls -1 "$FV/jobs/todo" | grep -c '^fu-fu-new-1\.md$' || true)
sch1=0; [ -f "$FV/schedules/fu-fu-new-2.md" ] && sch1=$(grep -c '^once:' "$FV/schedules/fu-fu-new-2.md" || true)
mm1=$(ls -1 "$FV/inbox/maintainer/unread" | grep -vxc '.gitkeep' || true)
[ "$job1" -eq 1 ] && ok "new report → one-time job fu-fu-new-1 posted"            || bad "job not posted ($job1)"
[ "$sch1" -ge 1 ] && ok "new report → one-time future schedule written (once:)"  || bad "one-shot schedule missing"
[ "$mm1" -ge 1 ] && ok "maintainer-judgment follow-up delivered to inbox"        || bad "no maintainer message ($mm1)"
rm -rf "$FV"
# second tick: no commit (quiet-on-success) and no duplicate (seen advanced)
hb=$(git ls-remote "$BARE" "refs/heads/$BRANCH" | awk '{print $1}')
env GARDEN_FOLLOWUP_HANDLER="$HERE/follow-up-stub.sh" "$JOBS/follow-up.sh" >/dev/null 2>&1
ha=$(git ls-remote "$BARE" "refs/heads/$BRANCH" | awk '{print $1}')
git clone -q --single-branch --branch "$BRANCH" "$BARE" "$FV"
job1b=$(ls -1 "$FV/jobs/todo" | grep -c '^fu-fu-new-1\.md$' || true)
{ [ "$hb" = "$ha" ] && [ "$job1b" -eq 1 ]; } && ok "second tick: no commit, no duplicate job (idempotent)" || bad "second tick not idempotent (commit $hb→$ha job=$job1b)"
rm -rf "$FV"
# the one-shot schedule (a past `once:`) fires exactly once, then is deleted
"$JOBS/scheduler.sh" >/dev/null 2>&1
git clone -q --single-branch --branch "$BRANCH" "$BARE" "$FV"
disp=$(ls -1 "$FV/jobs/todo" | grep -c '^fu-fu-new-2\.md$' || true)
gone=0; [ -f "$FV/schedules/fu-fu-new-2.md" ] && gone=1
{ [ "$disp" -eq 1 ] && [ "$gone" -eq 0 ]; } && ok "one-shot schedule dispatched fu-fu-new-2 then deleted" || bad "one-shot dispatch/delete (disp=$disp present=$gone)"
rm -rf "$FV"
"$JOBS/scheduler.sh" >/dev/null 2>&1   # re-run: must not re-dispatch
git clone -q --single-branch --branch "$BRANCH" "$BARE" "$FV"
disp2=$(ls -1 "$FV/jobs/todo" | grep -c '^fu-fu-new-2\.md$' || true)
[ "$disp2" -eq 1 ] && ok "one-shot does not re-dispatch (fired exactly once)" || bad "one-shot re-dispatched ($disp2)"
rm -rf "$FV"

# ============================================================================
hr; echo "RESULT: $PASS passed, $FAIL failed"; hr
[ "$FAIL" -eq 0 ]
