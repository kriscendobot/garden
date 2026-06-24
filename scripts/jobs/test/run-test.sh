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
# inbox-list surfaces the live doer (peer discovery) and excludes maintainer/dead
ilout="$("$JOBS/inbox-list.sh" 2>/dev/null)"
{ grep -qx 'inbox-demo' <<<"$ilout" && ! grep -qx 'maintainer' <<<"$ilout" && ! grep -qx 'dead' <<<"$ilout"; } \
  && ok "inbox-list surfaces the live doer 'inbox-demo' (peer discovery), excludes maintainer/dead" \
  || bad "inbox-list output wrong: $ilout"
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
# a message to a torn-down/absent inbox is DEAD-LETTERED (not dropped, not a hard
# error) so garden-deadmail can later promote its intent into a job.
set +e; echo "carry this intent" | "$JOBS/inbox-send.sh" no-such-doer >/dev/null 2>&1; sndrc=$?; set -e
rm -rf "$I"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$I"
ndead=$(ls -1 "$I/inbox/dead" 2>/dev/null | grep -vxc '.gitkeep' || true)
{ [ "$sndrc" -eq 0 ] && [ "$ndead" -ge 1 ]; } \
  && ok "send to torn-down doer dead-lettered (not dropped, not a hard error)" \
  || bad "send to inactive doer not dead-lettered (rc=$sndrc dead=$ndead)"
# the legacy hard-fail is still available behind GARDEN_NO_DEADLETTER=1
set +e; echo x | GARDEN_NO_DEADLETTER=1 "$JOBS/inbox-send.sh" no-such-doer-2 >/dev/null 2>&1; sndrc2=$?; set -e
[ "$sndrc2" -ne 0 ] && ok "GARDEN_NO_DEADLETTER=1 restores the legacy hard failure" || bad "opt-out did not hard-fail (rc=$sndrc2)"
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
hr; echo "SUBTEST 10 — BULLETIN: continuous loop, cost gate, degradation, cursor"; hr
export GARDEN_STATE="$TR/state-bul" GARDEN_HOST=bhost
CURSOR_FILE="$GARDEN_STATE/bulletin/cursor"
CALLS="$TR/bul-calls"; CAP="$TR/bul-digest"
# run ONE pass of the continuous loop with the journalist stubbed
run_bul() {
  : > "$CALLS"
  env GARDEN_BULLETIN_ONCE=1 GARDEN_BULLETIN_IDLE_SLEEP=0 \
      GARDEN_BULLETIN_HANDLER="${1:-$HERE/bulletin-stub.sh}" \
      GARDEN_BULLETIN_STUB_CALLS="$CALLS" GARDEN_BULLETIN_STUB_CAPTURE="$CAP" \
      "$JOBS/bulletin.sh" >/dev/null 2>&1
}
ohead() { git ls-remote "$BARE" "refs/heads/$BRANCH" | awk '{print $1}'; }

# (1) cold pass: deterministic dashboard + journalist `## Latest`, cursor written
run_bul
BV="$TR/bv"; rm -rf "$BV"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$BV"
{ [ -f "$BV/README.md" ] && grep -q '^# Garden bulletin' "$BV/README.md" \
  && grep -q '^## Board' "$BV/README.md" && grep -q '^## Latest$' "$BV/README.md"; } \
  && ok "bulletin assembled with deterministic board + journalist ## Latest" || bad "bulletin missing board or ## Latest"
[ -s "$CALLS" ] && ok "journalist invoked on a changed board" || bad "journalist not invoked on change"
{ [ -f "$CURSOR_FILE" ] && [ -s "$CURSOR_FILE" ]; } && ok "durable cursor written after post" || bad "cursor not written"
h1="$(ohead)"; cur1="$(cat "$CURSOR_FILE")"
[ "$cur1" = "$h1" ] && ok "cursor advanced to the posted journal head" || bad "cursor ($cur1) != posted head ($h1)"

# (2) cost gate: unchanged board makes NO commit and NO journalist call
run_bul
h2="$(ohead)"
{ [ "$h1" = "$h2" ] && [ ! -s "$CALLS" ]; } \
  && ok "unchanged board: no commit AND no journalist call (cost gate)" || bad "cost gate leaked (head $h1->$h2, calls=$(wc -l <"$CALLS"))"
[ "$(cat "$CURSOR_FILE")" = "$h2" ] && ok "restart on unchanged board neither re-narrates nor skips (cursor stable)" || bad "cursor drifted on unchanged restart"

# (3) board change: fresh bulletin, journalist called, digest is the delta only
push_change "jobs/todo/bul-newjob.md" "# new" "add a job to change board state"
run_bul
rm -rf "$BV"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$BV"
h3="$(ohead)"
{ [ "$h3" != "$h2" ] && grep -q '^## Latest$' "$BV/README.md" && [ -s "$CALLS" ]; } \
  && ok "board change → fresh bulletin, journalist re-narrates" || bad "board change did not refresh"
# the transitions section (not the dashboard, which may mention old jobs in
# Recent progress) must carry only the since-cursor delta
btrans="$(awk '/BOARD TRANSITIONS SINCE/{f=1} f' "$CAP")"
{ grep -q 'bul-newjob' <<<"$btrans" && ! grep -q 'job-001' <<<"$btrans"; } \
  && ok "digest narrates the since-cursor delta only (resume, not the whole history)" || bad "digest is not the delta"
[ "$(cat "$CURSOR_FILE")" = "$h3" ] && ok "cursor advanced only after the successful post" || bad "cursor not at new head"

# (4) graceful degradation: journalist fails → deterministic bulletin still ships,
#     prior `## Latest` preserved, cursor still advances
push_change "jobs/todo/bul-newjob2.md" "# new2" "another board change"
run_bul "$HERE/bulletin-fail-stub.sh"
rm -rf "$BV"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$BV"
h4="$(ohead)"
{ [ "$h4" != "$h3" ] && grep -q '^## Board' "$BV/README.md" && grep -q '^## Latest$' "$BV/README.md"; } \
  && ok "journalist failure still ships deterministic bulletin (prior ## Latest preserved)" || bad "degradation broke the bulletin"
[ "$(cat "$CURSOR_FILE")" = "$h4" ] && ok "cursor advances even on degraded post" || bad "cursor stalled on degraded post"
rm -rf "$BV"

# (5) maintainer messages are FOLLOWABLE: each entry links the message blob AND
#     inlines the full body as a blockquote (not a one-line teaser), and a
#     Markdown/fence-containing body does not break the bulletin's rendering.
mmsg="$(printf 'from_host: testhost\nfrom: gardener:demo-doer\nreply_to: demo-doer\nsent_at: t0\n---\nNeed a call on the rebase direction.\n\n```\nconflicting hunk in byteArray.js\n```\n\n## Recommend\nport onto the Uint8Array model\n')"
push_change "inbox/maintainer/unread/bul-maint-1.md" "$mmsg" "seed maintainer message for bulletin"
run_bul
rm -rf "$BV"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$BV"
grep -qF 'blob/journal2/inbox/maintainer/unread/bul-maint-1.md' "$BV/README.md" \
  && ok "maintainer entry links the message blob on journal2" || bad "no blob link to the maintainer message"
{ grep -qF '> Need a call on the rebase direction.' "$BV/README.md" \
  && grep -qF '> ## Recommend' "$BV/README.md" \
  && grep -qF '> port onto the Uint8Array model' "$BV/README.md"; } \
  && ok "maintainer entry inlines the FULL body as a blockquote (not a teaser)" || bad "full body not inlined as blockquote"
# fences stay balanced: the body fence is quoted (`> ```\`) so the count of
# blockquoted fence lines is even — the bulletin's own Markdown is not broken.
nfence=$(grep -cE '^> ```' "$BV/README.md" || true)
{ [ "$nfence" -ge 2 ] && [ $((nfence % 2)) -eq 0 ]; } \
  && ok "fence-containing body stays balanced inside the blockquote (no broken Markdown)" || bad "body fence unbalanced ($nfence)"
rm -rf "$BV"

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
hr; echo "SUBTEST 14 — FOREMAN: idle-pump, settle window, cost gate, anti-flap"; hr
# Dedicated empty board on its own origin so idle state is fully controllable.
FBARE="$TR/foreman.git"; git init -q --bare "$FBARE"
FSEED="$TR/foreman-seed"; git init -q "$FSEED"; git -C "$FSEED" checkout -q -b "$BRANCH"
( cd "$FSEED"
  mkdir -p jobs/todo jobs/doin jobs/tada inbox/maintainer/unread inbox/maintainer/read entries
  for d in jobs/todo jobs/doin jobs/tada inbox/maintainer/unread inbox/maintainer/read entries; do touch "$d/.gitkeep"; done )
git -C "$FSEED" add -A; git -C "$FSEED" "${git_id[@]}" commit -q -m "seed empty foreman board"
git -C "$FSEED" remote add origin "$FBARE"; git -C "$FSEED" push -q -u origin "$BRANCH"

export GARDEN_STATE="$TR/state-fm" GARDEN_HOST=fmhost
FCALLS="$TR/fm-calls"; : > "$FCALLS"
fboard() {  # fboard <job-base> | @CLEAR  → set todo/ on the foreman origin
  local wt; wt="$(mktemp -d "$TR/fedit.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$FBARE" "$wt"
  if [ "$1" = "@CLEAR" ]; then git -C "$wt" rm -q --ignore-unmatch jobs/todo/*.md >/dev/null 2>&1 || true
  else printf '# %s\n' "$1" > "$wt/jobs/todo/$1.md"; git -C "$wt" add "jobs/todo/$1.md"; fi
  git -C "$wt" "${git_id[@]}" commit -q -m "board: $1" >/dev/null 2>&1 || true
  git -C "$wt" push -q origin "HEAD:$BRANCH" >/dev/null 2>&1 || true
  rm -rf "$wt"
}
fcount() {  # fcount <subdir>  → non-gitkeep entries in a fresh clone of the foreman origin
  local v n; v="$(mktemp -d "$TR/fv.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$FBARE" "$v" 2>/dev/null
  n=$(ls -1 "$v/$1" 2>/dev/null | grep -vxc '.gitkeep' || true); rm -rf "$v"; printf '%s' "$n"
}
run_fm() {  # run_fm <now-epoch>
  : > "$FCALLS"
  env JOURNAL_REMOTE="$FBARE" GARDEN_FOREMAN_HANDLER="$HERE/foreman-stub.sh" \
      GARDEN_FOREMAN_STUB_CALLS="$FCALLS" GARDEN_FOREMAN_NOW="$1" GARDEN_FOREMAN_IDLE_SETTLE=240 \
      "$JOBS/foreman.sh" >/dev/null 2>&1
}

# (1) busy board → NO claude call and NO post (cost gate)
fboard busywork
run_fm 1000
{ [ ! -s "$FCALLS" ] && [ "$(fcount jobs/todo)" -eq 1 ]; } \
  && ok "busy board: no claude call and nothing posted (cost gate)" || bad "busy board leaked (calls=$(wc -l <"$FCALLS") todo=$(fcount jobs/todo))"

# (2) idle but within the settle window → start the clock, then do nothing
fboard @CLEAR
run_fm 2000   # first idle observation: writes idle-since=2000, no pump
{ [ ! -s "$FCALLS" ] && [ "$(fcount jobs/todo)" -eq 0 ]; } \
  && ok "idle first-seen: settle clock started, no pump" || bad "first idle pumped early"
run_fm 2100   # 100s < 240 settle → still nothing
{ [ ! -s "$FCALLS" ] && [ "$(fcount jobs/todo)" -eq 0 ]; } \
  && ok "idle within settle window: no claude call, no pump" || bad "within-settle leaked"

# (3) sustained idle past the settle window → posts exactly ONE job
run_fm 2300   # 300s since idle-since(2000) ≥ 240 → pump
{ [ -s "$FCALLS" ] && [ "$(fcount jobs/todo)" -eq 1 ]; } \
  && ok "sustained idle past settle: pumped exactly one job" || bad "pump (calls=$(wc -l <"$FCALLS") todo=$(fcount jobs/todo))"
FV="$TR/fmv"; git clone -q --single-branch --branch "$BRANCH" "$FBARE" "$FV"
[ -f "$FV/jobs/todo/foreman-next-step.md" ] && ok "posted the foreman's chosen next step" || bad "expected next-step job missing"
rm -rf "$FV"

# (4) anti-flap: board redrains, same step recurs → NOT re-posted, surfaced to maintainer
fboard @CLEAR   # remove the just-posted job → board idle again
run_fm 2400     # 100s since idle-since(2300) < 240 → within settle, no pump
[ ! -s "$FCALLS" ] && ok "post-pump settle window re-armed (no immediate re-pump)" || bad "re-pumped within settle"
run_fm 2600     # 300s ≥ 240 → pump; stub proposes the same base as last posted
{ [ "$(fcount jobs/todo)" -eq 0 ] && [ "$(fcount inbox/maintainer/unread)" -ge 1 ]; } \
  && ok "redrained board: identical step not duplicated (anti-flap), repeat surfaced to maintainer" \
  || bad "anti-flap (todo=$(fcount jobs/todo) maint=$(fcount inbox/maintainer/unread))"

# ============================================================================
hr; echo "SUBTEST 15 — PROXY: stand in for the absent maintainer on gating questions"; hr
export GARDEN_STATE="$TR/state-proxy" GARDEN_HOST=pxhost
PXCALLS="$TR/proxy-calls"; : > "$PXCALLS"
run_proxy() {  # run_proxy <grace-seconds>
  env GARDEN_PROXY_GRACE="${1:?grace}" \
      GARDEN_PROXY_HANDLER="$HERE/proxy-stub.sh" \
      GARDEN_PROXY_STUB_CALLS="$PXCALLS" \
      "$JOBS/proxy.sh" >/dev/null 2>&1
}
# count maintainer-unread messages matching BOTH patterns (no xargs → no hang on
# an empty match set)
count_unread_matching() {  # <clone> <pat1> <pat2>
  local c=0 f
  for f in "$1"/inbox/maintainer/unread/*.md; do
    [ -e "$f" ] || continue
    grep -q "$2" "$f" 2>/dev/null && grep -q "$3" "$f" 2>/dev/null && c=$((c+1))
  done
  echo "$c"
}
# two LIVE doers (inbox present) and one DEAD doer (no inbox); each posts a
# gating question to the maintainer inbox via message-user.sh (reply_to=<doer>).
push_change "inbox/px-live-a/unread/.gitkeep" "" "live doer px-live-a"
push_change "inbox/px-live-b/unread/.gitkeep" "" "live doer px-live-b"
qa="$(mktemp)"; echo "Two refactors are possible for the parser; which should I try first?" > "$qa"
qb="$(mktemp)"; echo "CI is green — should I ferry this PR upstream now?"                    > "$qb"
qd="$(mktemp)"; echo "Is this job considered complete?"                                       > "$qd"
"$JOBS/message-user.sh" px-live-a "$qa" >/dev/null
"$JOBS/message-user.sh" px-live-b "$qb" >/dev/null
"$JOBS/message-user.sh" px-dead   "$qd" >/dev/null

# (1) within grace: a present maintainer gets first crack — proxy does NOTHING
run_proxy 3600
[ ! -s "$PXCALLS" ] && ok "within grace: proxy leaves gating questions alone (no race, no handler call)" || bad "proxy raced inside grace ($(grep -c . "$PXCALLS") calls)"

# (2) past grace: in-bounds ANSWERED, out-of-bounds DEFERRED, dead doer IGNORED
run_proxy 0
set +e; pra="$("$JOBS/inbox-read.sh" px-live-a)"; prc=$?; set -e
{ [ "$prc" -ge 1 ] && grep -qi 'tentative' <<<"$pra"; } && ok "in-bounds gating question answered: tentative reply routed to the gardener" || bad "px-live-a got no tentative reply (count=$prc)"
PV="$TR/pxv"; rm -rf "$PV"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$PV"
amsg_un=$(grep -rl '^reply_to: px-live-a$' "$PV/inbox/maintainer/unread" 2>/dev/null | grep -c . || true)
amsg_rd=$(grep -rl '^reply_to: px-live-a$' "$PV/inbox/maintainer/read"   2>/dev/null | grep -c . || true)
{ [ "$amsg_un" -eq 0 ] && [ "$amsg_rd" -ge 1 ]; } && ok "answered question's maintainer message archived (unread→read)" || bad "px-live-a message not archived (unread=$amsg_un read=$amsg_rd)"
[ "$(count_unread_matching "$PV" 'proxy answered' 'px-live-a')" -ge 1 ] && ok "answered question reported back to the maintainer inbox" || bad "no maintainer report for px-live-a"
set +e; "$JOBS/inbox-read.sh" px-live-b >/dev/null; prbc=$?; set -e
[ "$prbc" -eq 0 ] && ok "out-of-bounds question NOT answered (no reply to the gardener)" || bad "px-live-b wrongly answered (count=$prbc)"
bmsg_un=$(grep -rl '^reply_to: px-live-b$' "$PV/inbox/maintainer/unread" 2>/dev/null | grep -c . || true)
[ "$bmsg_un" -ge 1 ] && ok "out-of-bounds question left UNREAD for the maintainer" || bad "px-live-b message not left unread ($bmsg_un)"
[ "$(count_unread_matching "$PV" 'beyond proxy authority' 'px-live-b')" -eq 1 ] && ok "deferred question noted to the maintainer ('beyond proxy authority')" || bad "defer note count wrong"
dmsg_un=$(grep -rl '^reply_to: px-dead$' "$PV/inbox/maintainer/unread" 2>/dev/null | grep -c . || true)
{ [ "$dmsg_un" -ge 1 ] && [ "$(count_unread_matching "$PV" 'beyond proxy authority' 'px-dead')" -eq 0 ]; } && ok "non-gating completion report (dead doer) ignored" || bad "px-dead handled (unread=$dmsg_un)"
[ "$(grep -c . "$PXCALLS")" -eq 2 ] && ok "handler invoked on exactly the 2 eligible gating questions" || bad "handler call count=$(grep -c . "$PXCALLS") (want 2)"
rm -rf "$PV"

# (3) second tick: no re-answer, no re-note, no duplicate handler call (idempotent)
prev_calls="$(grep -c . "$PXCALLS")"
run_proxy 0
[ "$(grep -c . "$PXCALLS")" -eq "$prev_calls" ] && ok "second tick: no duplicate handler call (cost gate + seen-marker)" || bad "handler re-invoked (calls $prev_calls→$(grep -c . "$PXCALLS"))"
PV="$TR/pxv"; rm -rf "$PV"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$PV"
[ "$(count_unread_matching "$PV" 'beyond proxy authority' 'px-live-b')" -eq 1 ] && ok "second tick: deferred question not re-noted (single note)" || bad "defer note duplicated"
rm -rf "$PV"; rm -f "$qa" "$qb" "$qd"

# ============================================================================
hr; echo "SUBTEST 16 — DEADMAIL: dead-letter undeliverable mail, promote to a job"; hr
# Dedicated bare so the dead-mail count is fully controllable (other subtests
# dead-letter into $BARE).
DBARE="$TR/deadmail.git"; git init -q --bare "$DBARE"
DSEED="$TR/deadmail-seed"; git init -q "$DSEED"; git -C "$DSEED" checkout -q -b "$BRANCH"
( cd "$DSEED"
  mkdir -p jobs/todo jobs/doin jobs/tada inbox/dead inbox/maintainer/unread inbox/maintainer/read entries
  for d in jobs/todo jobs/doin jobs/tada inbox/dead inbox/maintainer/unread inbox/maintainer/read entries; do touch "$d/.gitkeep"; done )
git -C "$DSEED" add -A; git -C "$DSEED" "${git_id[@]}" commit -q -m "seed deadmail board"
git -C "$DSEED" remote add origin "$DBARE"; git -C "$DSEED" push -q -u origin "$BRANCH"

export GARDEN_STATE="$TR/state-dm" GARDEN_HOST=dmhost
dm_env() { env JOURNAL_REMOTE="$DBARE" "$@"; }

# (1) a message to an absent doer is dead-lettered (not dropped, not a hard error)
set +e; echo "rebase prune-v1-legacy on master before ferrying" \
  | dm_env "$JOBS/inbox-send.sh" prune-v1-legacy >/dev/null 2>&1; dmrc=$?; set -e
DV="$TR/dmv"; git clone -q --single-branch --branch "$BRANCH" "$DBARE" "$DV"
ndead=$(ls -1 "$DV/inbox/dead" | grep -vxc '.gitkeep' || true)
{ [ "$dmrc" -eq 0 ] && [ "$ndead" -eq 1 ]; } && ok "undeliverable message dead-lettered to inbox/dead" || bad "dead-letter (rc=$dmrc dead=$ndead)"
deadid="$(ls -1 "$DV/inbox/dead" | grep -vx '.gitkeep' | head -1)"; deadid="${deadid%.md}"
grep -q '^to: prune-v1-legacy$' "$DV/inbox/dead/$deadid.md" && ok "dead-mail records the intended recipient" || bad "dead-mail missing 'to:'"
rm -rf "$DV"

# (2) the promoter turns the dead-mail entry into exactly one job and retires it
dm_env "$JOBS/deadmail.sh" >/dev/null 2>&1
git clone -q --single-branch --branch "$BRANCH" "$DBARE" "$DV"
njob=$(ls -1 "$DV/jobs/todo" | grep -c "^deadmail-${deadid}\.md$" || true)
ndead2=$(ls -1 "$DV/inbox/dead" | grep -vxc '.gitkeep' || true)
[ "$njob" -eq 1 ] && ok "dead-mail promoted to exactly one job (deadmail-$deadid)" || bad "promotion job count=$njob"
[ "$ndead2" -eq 0 ] && ok "dead-mail entry retired after promotion" || bad "dead-mail not retired ($ndead2)"
grep -q 'prune-v1-legacy' "$DV/jobs/todo/deadmail-$deadid.md" && grep -qi 'pick up' "$DV/jobs/todo/deadmail-$deadid.md" \
  && ok "promoted job carries the original message + intended recipient + pick-up-its-intent" || bad "promoted job body missing context"
rm -rf "$DV"

# (3) idempotent on re-scan: no second job, nothing new
hb=$(git ls-remote "$DBARE" "refs/heads/$BRANCH" | awk '{print $1}')
dm_env "$JOBS/deadmail.sh" >/dev/null 2>&1
ha=$(git ls-remote "$DBARE" "refs/heads/$BRANCH" | awk '{print $1}')
git clone -q --single-branch --branch "$BRANCH" "$DBARE" "$DV"
njob2=$(ls -1 "$DV/jobs/todo" | grep -c "^deadmail-${deadid}\.md$" || true)
{ [ "$hb" = "$ha" ] && [ "$njob2" -eq 1 ]; } && ok "re-scan is idempotent (no duplicate job, no new commit)" || bad "re-scan not idempotent (head $hb→$ha job=$njob2)"
rm -rf "$DV"
unset JOURNAL_REMOTE

# ============================================================================
hr; echo "SUBTEST 17 — GH IDENTITY: fleet gh pins to the bot, boatman override preserved"; hr
# Hermetic: a fake gh (test/fake-gh.sh) is the "real" gh the wrapper exec's, and
# a file simulates the mutable global active account. No network, no ~/.config/gh.
GHWRAP_DIR="$JOBS/bin"
FAKE_DIR="$TR/fake-gh"; mkdir -p "$FAKE_DIR"
cp "$HERE/fake-gh.sh" "$FAKE_DIR/gh"; chmod +x "$FAKE_DIR/gh"
ACTIVE="$TR/gh-active"
# The leak condition: the global active account is the maintainer.
echo "kriskowal" > "$ACTIVE"
# Minimal PATH: wrapper first, fake gh second, plus the basics the wrapper needs
# (it runs bash/cd/dirname/printf via its shebang interpreter only).
gh_path="$GHWRAP_DIR:$FAKE_DIR:/usr/bin:/bin"

# Baseline (NO wrapper): proves the leak is real — bare gh resolves to the active
# account, which is kriskowal.
base_id="$(env -i PATH="$FAKE_DIR:/usr/bin:/bin" FAKE_GH_ACTIVE="$ACTIVE" gh api user)"
[ "$base_id" = "kriskowal" ] && ok "baseline leak reproduced: bare gh acts as the global active account (kriskowal)" \
  || bad "baseline did not reproduce the leak (got '$base_id')"

# With the wrapper on PATH: the fleet gh resolves to the bot DESPITE active=kriskowal.
wrap_id="$(env -i PATH="$gh_path" FAKE_GH_ACTIVE="$ACTIVE" gh api user)"
[ "$wrap_id" = "kriscendobot" ] && ok "wrapper pins fleet gh to kriscendobot even when active account is kriskowal" \
  || bad "wrapper did not pin to the bot (got '$wrap_id')"

# Boatman override: an explicit GARDEN_GH_IDENTITY=kriskowal reaches the maintainer.
boat_id="$(env -i PATH="$gh_path" FAKE_GH_ACTIVE="$ACTIVE" GARDEN_GH_IDENTITY=kriskowal gh api user)"
[ "$boat_id" = "kriskowal" ] && ok "explicit GARDEN_GH_IDENTITY=kriskowal override reaches the maintainer (boatman path)" \
  || bad "override did not reach kriskowal (got '$boat_id')"

# A caller that pre-sets GH_TOKEN is honored untouched (the other override form).
pass_id="$(env -i PATH="$gh_path" FAKE_GH_ACTIVE="$ACTIVE" GH_TOKEN=token-for-kriscendobot gh api user)"
[ "$pass_id" = "kriscendobot" ] && ok "pre-set GH_TOKEN passes through untouched" \
  || bad "pre-set GH_TOKEN not honored (got '$pass_id')"

# Direction check: with NO override, even an active=kriskowal world stays the bot —
# routine fleet work can never silently become kriskowal.
echo "kriskowal" > "$ACTIVE"
default_id="$(env -i PATH="$gh_path" FAKE_GH_ACTIVE="$ACTIVE" gh api user)"
[ "$default_id" = "kriscendobot" ] && ok "default is one-directional: bot is the floor, kriskowal only via explicit signal" \
  || bad "default drifted off the bot (got '$default_id')"

# Static checks on the wrapper itself.
bash -n "$GHWRAP_DIR/gh" && ok "wrapper: bash -n clean" || bad "wrapper: bash -n failed"
if command -v shellcheck >/dev/null 2>&1; then
  shellcheck -x "$GHWRAP_DIR/gh" >/dev/null 2>&1 && ok "wrapper: shellcheck clean" || bad "wrapper: shellcheck reported issues"
else
  echo "  SKIP: shellcheck not installed"
fi

# ============================================================================
hr; echo "SUBTEST 18 — PRODUCER PUSH PATH: shared-clone serialization + verify-after-push"; hr
# Dedicated bare so the landed-count is fully controllable.
PBARE="$TR/producer.git"; git init -q --bare "$PBARE"
PSEED="$TR/producer-seed"; git init -q "$PSEED"; git -C "$PSEED" checkout -q -b "$BRANCH"
( cd "$PSEED"; mkdir -p jobs/todo; touch jobs/todo/.gitkeep )
git -C "$PSEED" add -A; git -C "$PSEED" "${git_id[@]}" commit -q -m "seed producer board"
git -C "$PSEED" remote add origin "$PBARE"; git -C "$PSEED" push -q -u origin "$BRANCH"

# (1) CONCURRENCY: N concurrent post-job calls SHARE one producer clone (same
# GARDEN_STATE). Without the flock serialization, at least one is silently lost
# (reset --hard wipes a peer's staged job; index/HEAD/config lock collisions).
export GARDEN_STATE="$TR/state-push" GARDEN_HOST=pushhost
PN=8; ppids=()
for i in $(seq 1 "$PN"); do
  ( echo "# concurrent post $i" | env JOURNAL_REMOTE="$PBARE" "$JOBS/post-job.sh" "push-$i" ) \
      >"$TR/logs/push-$i.log" 2>&1 &
  ppids+=($!)
done
pfail=0; for p in "${ppids[@]}"; do wait "$p" || pfail=$((pfail+1)); done
PV="$TR/pv"; git clone -q --single-branch --branch "$BRANCH" "$PBARE" "$PV"
landed=$(ls -1 "$PV/jobs/todo" | grep -c '^push-' || true)
{ [ "$landed" -eq "$PN" ] && [ "$pfail" -eq 0 ]; } \
  && ok "all $PN concurrent posts landed on origin/$BRANCH (no silent loss under shared clone)" \
  || bad "concurrency: landed=$landed/$PN nonzero-exits=$pfail"
rm -rf "$PV"

# (2) SILENT-LOSS (unit): a push that "succeeds" without advancing the remote must
# make commit_and_push RETURN FAILURE (verify-after-push), not a false success.
export GARDEN_STATE="$TR/state-push2" GARDEN_HOST=pushhost2
sl_rc=$(
  cd "$JOBS"
  JOURNAL_REMOTE="$PBARE" JOURNAL_BRANCH="$BRANCH" GARDEN_STATE="$TR/state-push2" \
  GARDEN_HOST=pushhost2 bash -c '
    set -uo pipefail
    source ./common.sh
    DIR="$GARDEN_STATE/producer/journal"
    ensure_clone "$DIR"; sync_clone "$DIR"
    printf "x\n" > "$DIR/jobs/todo/silent-loss.md"
    git -C "$DIR" add jobs/todo/silent-loss.md
    # inject a push that reports success but never advances the remote, and
    # capture the verdict without set -e swallowing the non-zero return.
    if GARDEN_PUSH_CMD=/bin/true commit_and_push "$DIR" "todo(silent-loss) injected"; then
      echo landed
    else
      echo "rejected:$?"
    fi
  ' 2>/dev/null | tail -1
)
case "${sl_rc:-}" in
  rejected:*) ok "commit_and_push returns failure when push does not advance the remote (verify-after-push)" ;;
  *)          bad "commit_and_push did not signal a lost push (verdict='$sl_rc')" ;;
esac
SLV="$TR/slv"; git clone -q --single-branch --branch "$BRANCH" "$PBARE" "$SLV"
[ ! -e "$SLV/jobs/todo/silent-loss.md" ] && ok "the lost post is NOT on the remote (no phantom landing)" \
  || bad "silent-loss job unexpectedly present on remote"
rm -rf "$SLV"

# (3) CALLER RETRY + loud give-up: post-job with a no-op push retries (bounded for
# the test) and FAILS loudly — it must NOT print a false "posted".
export GARDEN_STATE="$TR/state-push3" GARDEN_HOST=pushhost3
set +e
env JOURNAL_REMOTE="$PBARE" GARDEN_PUSH_CMD=/bin/true GARDEN_POST_ATTEMPTS=3 \
    "$JOBS/post-job.sh" never-lands </dev/null >"$TR/logs/never-lands.log" 2>&1
nl_rc=$?
set -e
{ [ "$nl_rc" -ne 0 ] && grep -q "could not post" "$TR/logs/never-lands.log" \
  && ! grep -q "posted 'never-lands'" "$TR/logs/never-lands.log"; } \
  && ok "caller retries then gives up loudly (non-zero exit, 'could not post', never a false 'posted')" \
  || bad "give-up not loud (rc=$nl_rc log: $(tr '\n' '|' <"$TR/logs/never-lands.log"))"

# ============================================================================
hr; echo "RESULT: $PASS passed, $FAIL failed"; hr
[ "$FAIL" -eq 0 ]
