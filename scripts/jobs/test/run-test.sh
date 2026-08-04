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
# --- private per-invocation test root ----------------------------------------
# The root used to be a single shared path (/home/kris/.garden-test), which two
# concurrent runs CLOBBER: the fleet runs ~20 gardeners per host and any two that
# claim a `run-…` board job (or a maintainer running the suite by hand next to a
# gardener) share one $TR — and the very first thing the harness does is
# `rm -rf "$TR"`, deleting the other run's bare journal, clones and state mid-flight.
# So each invocation gets its OWN root under $TMPDIR. The leaf component stays
# literally `.garden-test` because common.sh's `_in_test_context` heuristic matches
# GARDEN_STATE paths of the form `*/.garden-test/*` — the secondary backstop behind
# the GARDEN_TEST=1 sentinel exported below.
#
# Overrides (read HERE, before the GARDEN_* scrub below strips them):
#   GARDEN_TEST_ROOT=<dir>  use <dir> as the root (wiped first) instead of a
#                           fresh temp dir — for inspecting a run at a fixed path.
#   GARDEN_TEST_TMPDIR=<d>  first candidate base to mktemp the root under (then
#                           $TMPDIR, /tmp, $HOME; see the exec probe below).
#   GARDEN_TEST_KEEP=1      keep the root after a passing run (a failing run always
#                           keeps it, and prints where).
TR_KEEP="${GARDEN_TEST_KEEP:-0}"
# The base filesystem must permit EXECUTION: several subtests write a fixture
# script (a preflight gate, a fake `claude`/`gh`) and hand its path to a script
# under test, and `[ -x … ]`/execve fail with EACCES on a `noexec` mount — this
# container's /tmp is exactly that. Probe each candidate by running a throwaway
# script there and take the first that works, ending at $HOME (the filesystem the
# old shared root lived on, so the fallback is the historical behavior).
tr_base=""
for cand in "${GARDEN_TEST_TMPDIR:-}" "${TMPDIR:-}" /var/tmp /tmp "$HOME"; do
  { [ -n "$cand" ] && [ -d "$cand" ] && [ -w "$cand" ]; } || continue
  probe="$(mktemp -d "$cand/.garden-test-probe.XXXXXX" 2>/dev/null)" || continue
  printf '#!/bin/sh\nexit 0\n' > "$probe/x"; chmod +x "$probe/x" 2>/dev/null || true
  if [ -x "$probe/x" ] && "$probe/x" 2>/dev/null; then rm -rf "$probe"; tr_base="$cand"; break; fi
  rm -rf "$probe"
done
[ -n "$tr_base" ] || tr_base="$HOME"
if [ -n "${GARDEN_TEST_ROOT:-}" ]; then
  TR="$GARDEN_TEST_ROOT"; TR_OWNED="$TR"
else
  # Dot-prefixed: on the $HOME fallback the garden root's .gitignore excludes
  # every top-level dotfile (`/.[!.]*`), so a run never dirties `git status`.
  TR_OWNED="$(mktemp -d "$tr_base/.garden-test-run.XXXXXXXX")"; TR="$TR_OWNED/.garden-test"
fi
tr_cleanup() {  # keep the evidence on failure; sweep the temp root on success
  local rc=$?
  if [ "$rc" -ne 0 ] || [ "$TR_KEEP" = 1 ]; then echo "  (test root kept: $TR)"
  else rm -rf "$TR_OWNED"; fi
  return "$rc"
}
trap tr_cleanup EXIT
PASS=0; FAIL=0
ok()   { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad()  { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()   { echo "----------------------------------------------------------------"; }

# --- hermetic environment baseline (the fleet-load isolation) ----------------
# run-test.sh is frequently invoked BY a live gardener (a `run-…` board job),
# whose process EXPORTS the fleet's own GARDEN_*/JOURNAL_*/SELF_HEAL_* — e.g.
# GARDEN_GARDENER_CLONE=…/.garden-state/gardeners/18/journal, GARDEN_STATE, and
# GARDEN_ROOT=/home/kris (whose journal/ origin is the LIVE shared journal2).
# Those ambient values leak THROUGH a subtest's per-case `env`/`export` overrides
# into the scripts under test: claim-job/gardener honor GARDEN_GARDENER_CLONE, and
# ensure_clone/capture_blob derive the remote from GARDEN_ROOT/journal whenever a
# subtest leaves JOURNAL_REMOTE unset. The result is that the busy ~100-gardener
# fleet's live clone, state, and journal pushes are spliced underneath the test —
# the "flakes under fleet load" the self-heal subtests showed (rc=1 calls=0 in the
# shared-clone capture path; live job names claimed in the inbox/concurrency
# subtests). Scrub every GARDEN_*/JOURNAL_*/SELF_HEAL_* now so ONLY the test's own
# throwaway $TR settings are authoritative and concurrent fleet activity is
# invisible. Each subtest re-exports exactly what it needs against $TR below.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true

# Test-context sentinel, exported from THIS one place AFTER the scrub (the scrub
# strips GARDEN_*). Every subtest's `env …`/`export` inherits it, so common.sh's
# guard_no_production_push_in_test refuses any push whose remote resolves to the
# real kriskowal/garden journal even if a future subtest forgets to override the
# remote — the durable backstop for the 2026-07-11 production-journal leak.
export GARDEN_TEST=1

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
  env GARDEN="host-$i" GARDEN_STATE="$TR/state" \
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
export GARDEN_STATE="$TR/state-scale" GARDEN=testhost
# This subtest exercises SIZE reconciliation, not the backend auth auto-tune. Pin the
# per-kind backend probe to always-pass (/bin/true ignores the kind arg, exits 0) so
# the scaler's effective count equals the declared count and the size assertions below
# are deterministic regardless of whether this test host has a live Claude/codex auth.
# The auto-tune's own hysteresis is covered by backend-autotune-test.sh.
export GARDEN_BACKEND_PROBE_CMD=/bin/true
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
# A host owns only its own hosts/<host> record. This is the direct regression for
# a follower clobbering the leader's count during its deploy: an explicit foreign
# host argument must fail before touching the journal.
set +e
foreign_out="$(GARDEN=testhost "$JOBS/set-gardeners.sh" 7 leaderhost 2>&1)"; foreign_rc=$?
zero_out="$(GARDEN=testhost "$JOBS/set-gardeners.sh" 0 2>&1)"; zero_rc=$?
set -e
git -C "$V" fetch -q origin "$BRANCH"; git -C "$V" reset -q --hard "origin/$BRANCH"
{ [ "$foreign_rc" -ne 0 ] && grep -q 'may set only its own worker counts' <<<"$foreign_out" && ! [ -e "$V/hosts/leaderhost" ]; } \
  && ok "foreign host worker write refused without creating hosts/leaderhost" \
  || bad "foreign host write guard failed (rc=$foreign_rc, output=$foreign_out)"
{ [ "$zero_rc" -ne 0 ] && grep -q 'refusing gardeners: 0' <<<"$zero_out"; } \
  && ok "gardeners: 0 writer request refused without a qualified alternative" \
  || bad "gardeners zero floor failed (rc=$zero_rc, output=$zero_out)"
push_change "hosts/testhost" $'gardeners: 0\nupdated_by: testhost' "seed invalid gardener zero"
: > "$GARDEN_MOCK_LOG"
zero_scale_out="$(GARDEN=testhost "$JOBS/gardener-scaler.sh" 2>&1)"
zero_disables=$(grep -c '^systemctl --user disable' "$GARDEN_MOCK_LOG" || true)
{ grep -q "declares gardeners: 0.*refusing" <<<"$zero_scale_out" && [ "$zero_disables" -eq 0 ]; } \
  && ok "legacy gardeners: 0 is refused by scaler without disabling the pool" \
  || bad "scaler zero floor failed (disables=$zero_disables, output=$zero_scale_out)"
GARDEN_QUOTA_ROUTING=race "$JOBS/set-workers.sh" cleric 1 testhost >/dev/null
set +e
qualified_zero_out="$(GARDEN=testhost GARDEN_QUOTA_ROUTING=race "$JOBS/set-gardeners.sh" 0 2>&1)"; qualified_zero_rc=$?
set -e
: > "$GARDEN_MOCK_LOG"
GARDEN=testhost GARDEN_QUOTA_ROUTING=race "$JOBS/gardener-scaler.sh" >/dev/null 2>&1
qualified_gardeners=$(grep -c '^garden-gardener@.*\.service$' "$GARDEN_MOCK_STATE" || true)
qualified_clerics=$(grep -c '^garden-cleric@1\.service$' "$GARDEN_MOCK_STATE" || true)
{ [ "$qualified_zero_rc" -eq 0 ] && [ "$qualified_gardeners" -eq 0 ] && [ "$qualified_clerics" -eq 1 ]; } \
  && ok "qualified cleric allows gardeners: 0 and scaler retains a live non-Claude pool" \
  || bad "qualified zero-floor route failed (rc=$qualified_zero_rc gardeners=$qualified_gardeners clerics=$qualified_clerics output=$qualified_zero_out)"
push_change "hosts/testhost" $'gardeners: 1\nupdated_by: testhost' "restore one-gardener fixture"
GARDEN=testhost "$JOBS/gardener-scaler.sh" >/dev/null 2>&1
# A structurally-absent desired count (no hosts/<host> file) is a NO-OP, never a
# scale-to-0: point the scaler at a host that was never declared and the gardener@1
# pool above must survive untouched (no install-units.sh scale → zero disable calls).
# Guards the regression where want=0 default tore the whole local fleet down at once.
: > "$GARDEN_MOCK_LOG"
GARDEN=undeclaredhost "$JOBS/gardener-scaler.sh" >/dev/null 2>&1
noop_armed=$(grep -c '^garden-gardener@1\.service$' "$GARDEN_MOCK_STATE" || true)
noop_disables=$(grep -c '^systemctl --user disable' "$GARDEN_MOCK_LOG" || true)
{ [ "$noop_armed" -eq 1 ] && [ "$noop_disables" -eq 0 ]; } \
  && ok "absent hosts/<host> → no-op (pool unchanged, no disable)" \
  || bad "no-op-on-undeterminable-count (@1=$noop_armed, disables=$noop_disables)"

# --- ABSENT KIND LINE is a QUIET no-op, NOT a per-tick WARN ------------------
# testhost declares `gardeners: 1` (set-gardeners above) but no `clerics:` line — a
# legitimate steady state for a host that runs one kind and not the other. The
# undeclared kind must log at a QUIET level (DEBUG), not spam WARN every ~60s tick
# and bury real scaler signal. Distinct from a wholly-absent hosts/<host> file,
# which stays a WARN (genuine can't-determine). Capture the scaler's own stderr.
sclog="$TR/scaler-absentkind.err"
GARDEN=testhost "$JOBS/gardener-scaler.sh" >/dev/null 2>"$sclog"
{ grep -q "declares no clerics line" "$sclog" && ! grep -q "WARN host 'testhost' desired clerics" "$sclog"; } \
  && ok "declared-gardeners/absent-clerics host → clerics DEBUG, no WARN (spam removed)" \
  || bad "absent clerics line did not go quiet: $(grep -E 'clerics' "$sclog" | tr '\n' '|')"
sclog2="$TR/scaler-nofile.err"
GARDEN=undeclaredhost "$JOBS/gardener-scaler.sh" >/dev/null 2>"$sclog2"
grep -q "WARN host 'undeclaredhost' desired gardeners undeterminable" "$sclog2" \
  && ok "wholly-absent hosts/<host> file → gardeners WARN preserved (real signal intact)" \
  || bad "missing hosts file did not WARN: $(grep -E 'gardeners' "$sclog2" | tr '\n' '|')"

# --- IDENTITY RECONCILE: a worker whose in-process GARDEN drifted is restarted ---
# A long-lived garden-gardener@N inherits GARDEN once, at spawn; if the host
# identity is later corrected (e.g. a stale GARDEN=endolinbot2 override removed),
# the already-running worker keeps the STALE value and keeps keying phantom
# hosts/<stale> state. The scaler's identity-reconcile step reads each running
# instance's live GARDEN from /proc/<MainPID>/environ (via GARDEN_PROC, overridable
# here) and restarts a drifted one — gated on the SAME busy marker as scale-down so
# a mid-job worker defers to a later tick, restarting between claims not mid-flight.
GARDEN=testhost "$JOBS/set-gardeners.sh" 3 testhost >/dev/null   # size no-op: @1..@3 stay enabled
printf '%s\n' garden-gardener@1.service garden-gardener@2.service garden-gardener@3.service > "$GARDEN_MOCK_STATE"
PROC="$TR/proc"; PIDS="$TR/mockpids"; rm -rf "$PROC" "$PIDS"; mkdir -p "$PROC/101" "$PROC/102" "$PROC/103" "$PIDS"
# @1 drifted (idle), @2 matches, @3 drifted BUT mid-job (busy) → deferred. @4 not running.
printf 'GARDEN=otherhost\0PATH=/x\0' > "$PROC/101/environ"    # @1 stale identity
printf 'GARDEN=testhost\0PATH=/x\0'  > "$PROC/102/environ"    # @2 correct identity
printf 'GARDEN=otherhost\0PATH=/x\0' > "$PROC/103/environ"    # @3 stale identity
echo 101 > "$PIDS/garden-gardener@1.service"
echo 102 > "$PIDS/garden-gardener@2.service"
echo 103 > "$PIDS/garden-gardener@3.service"
mkdir -p "$GARDEN_STATE/gardeners/3"; : > "$GARDEN_STATE/gardeners/3/busy"   # @3 mid-job
: > "$GARDEN_MOCK_LOG"
idout="$(GARDEN=testhost GARDEN_PROC="$PROC" GARDEN_MOCK_PIDS="$PIDS" "$JOBS/gardener-scaler.sh" 2>&1)"
grep -q 'restart --no-block garden-gardener@1.service' "$GARDEN_MOCK_LOG" \
  && ok "drifted idle gardener 1 restarted --no-block (adopts corrected identity)" || bad "drifted gardener 1 NOT restarted"
grep -q 'restart --no-block garden-gardener@2.service' "$GARDEN_MOCK_LOG" \
  && bad "matching gardener 2 was restarted (spurious)" || ok "matching gardener 2 left alone (no spurious restart)"
grep -q 'restart --no-block garden-gardener@3.service' "$GARDEN_MOCK_LOG" \
  && bad "busy drifted gardener 3 was restarted (mid-job SIGTERM!)" || ok "busy drifted gardener 3 deferred (not restarted)"
grep -q "gardener 3 identity 'otherhost' != host 'testhost' but mid-job; deferring" <<<"$idout" \
  && ok "deferral logged for the busy drifted worker" || bad "deferral not logged"
rm -rf "$PROC" "$PIDS"; rm -f "$GARDEN_STATE/gardeners/3/busy"
unset GARDEN_UNIT_CTL GARDEN_MOCK_STATE GARDEN_MOCK_LOG GARDEN_BACKEND_PROBE_CMD

# ============================================================================
hr; echo "SUBTEST 5 — INBOX: per-doer unread→read CAS + lifecycle"; hr
export GARDEN_STATE="$TR/state-inbox" GARDEN=ibhost
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
# Point install-units' render destination ($DEST = XDG_CONFIG_HOME/systemd/user)
# at a throwaway dir and pre-seed the triager template there, so the pure
# arm/disarm cases below exercise the no-drift path (template present → no
# self-heal install). The self-heal case below uses a FRESH empty $DEST instead.
export XDG_CONFIG_HOME="$TR/xdg-rw"; mkdir -p "$XDG_CONFIG_HOME/systemd/user"
touch "$XDG_CONFIG_HOME/systemd/user/garden-triager@.service"
push_change "repos/kriscendobot-endo" "watch" "watch: kriscendobot-endo"
"$JOBS/repo-watcher.sh" >/dev/null 2>&1
grep -qxF "garden-triager@kriscendobot-endo.timer" "$GARDEN_MOCK_STATE" \
  && ok "watch → armed garden-triager@kriscendobot-endo.timer" || bad "triager not armed on watch"
push_change "repos/kriscendobot-endo" "@DELETE" "unwatch: kriscendobot-endo"
"$JOBS/repo-watcher.sh" >/dev/null 2>&1
grep -qxF "garden-triager@kriscendobot-endo.timer" "$GARDEN_MOCK_STATE" \
  && bad "triager still armed after unwatch" || ok "unwatch → disarmed triager unit"
grep -qxF "systemctl --user disable --now garden-triager@kriscendobot-endo.timer" "$GARDEN_MOCK_LOG" \
  && ok "unwatch issued disable --now for the triager timer" \
  || bad "unwatch did not issue disable --now for the triager timer"

# --- self-heal a missing template unit ---------------------------------------
# A comment-repo wants garden-comment-watcher@ AND garden-ci-watcher@. With a
# FRESH empty $DEST (neither template rendered), the pre-fix behavior armed the
# instance timers against absent templates and logged "could not arm …" every
# tick forever. The fix renders the missing templates via install-units.sh —
# once per tick — before arming. Real systemd is not needed: install-units
# render is pure file I/O into $DEST, and daemon-reload is a mock no-op.
export XDG_CONFIG_HOME="$TR/xdg-selfheal"; SHDEST="$XDG_CONFIG_HOME/systemd/user"
rm -rf "$XDG_CONFIG_HOME"; mkdir -p "$SHDEST"
: > "$GARDEN_MOCK_STATE"
rwerr="$TR/rw-selfheal.err"
push_change "comment-repos/kriscendobot-endo" "watch" "watch comment-repo"
"$JOBS/repo-watcher.sh" >/dev/null 2>"$rwerr"
[ -e "$SHDEST/garden-ci-watcher@.service" ] \
  && ok "self-heal rendered the missing garden-ci-watcher@ template" \
  || bad "missing ci-watcher template not self-healed"
[ -e "$SHDEST/garden-comment-watcher@.service" ] \
  && ok "self-heal rendered the missing garden-comment-watcher@ template" \
  || bad "missing comment-watcher template not self-healed"
grep -qxF "garden-ci-watcher@kriscendobot-endo.timer" "$GARDEN_MOCK_STATE" \
  && ok "ci-watcher instance armed after template self-heal" \
  || bad "ci-watcher instance not armed after self-heal"
[ "$(grep -c 'running install-units.sh install' "$rwerr")" -eq 1 ] \
  && ok "install-units invoked at most once per tick despite two missing templates" \
  || bad "install-units not invoked exactly once per tick (self-heal guard)"
# A second tick, templates now present, must NOT re-run the heavy install.
rwerr2="$TR/rw-selfheal2.err"
"$JOBS/repo-watcher.sh" >/dev/null 2>"$rwerr2"
grep -q 'self-heal template drift' "$rwerr2" \
  && bad "self-heal install re-ran on the no-drift tick" \
  || ok "no-drift tick did not re-run install (templates already present)"

# --- template STILL absent after the self-heal install -----------------------
# If the source template is genuinely gone from scripts/systemd/, the install
# renders nothing and the template stays absent. The pre-fix behavior then armed
# the instance against an absent template and re-logged "could not arm …" every
# tick forever. The fix instead logs a single WARN and SKIPS arming that set this
# tick. Drive it by pointing repo-watcher's install seam at a no-op (/bin/true),
# so the once-per-tick self-heal install renders nothing and the template stays
# absent — no real render can un-break this branch.
export XDG_CONFIG_HOME="$TR/xdg-noheal"; NHDEST="$XDG_CONFIG_HOME/systemd/user"
rm -rf "$XDG_CONFIG_HOME"; mkdir -p "$NHDEST"
: > "$GARDEN_MOCK_STATE"
rwerr3="$TR/rw-noheal.err"
GARDEN_INSTALL_UNITS=/bin/true "$JOBS/repo-watcher.sh" >/dev/null 2>"$rwerr3"
grep -qxF "garden-ci-watcher@kriscendobot-endo.timer" "$GARDEN_MOCK_STATE" \
  && bad "ci-watcher armed against a still-absent template (should skip)" \
  || ok "arming skipped when template still absent after self-heal install"
grep -q 'could not arm' "$rwerr3" \
  && bad "per-slug 'could not arm' WARN looped despite skip" \
  || ok "no per-slug 'could not arm' spam on a still-absent template"
grep -q 'still absent after install-units.sh install' "$rwerr3" \
  && ok "single WARN logged for the genuinely-missing template" \
  || bad "missing-template WARN not logged"
grep -q 'armed 0 of' "$rwerr3" \
  && ok "reconcile summary reports 0 armed for the absent-template set" \
  || bad "reconcile summary did not report the skipped arming"

# --- transient arm failure is retried WITHIN the tick ------------------------
# A transient systemctl/XDG_RUNTIME_DIR hiccup makes the FIRST `enable --now`
# fail; the pre-fix code WARNed "could not arm" and left the slug disarmed until
# the next full tick. arm_timer must instead retry within the tick and succeed.
# Template present (no self-heal), delay driven to 0 so the test does not sleep.
export XDG_CONFIG_HOME="$TR/xdg-armretry"; ARDEST="$XDG_CONFIG_HOME/systemd/user"
rm -rf "$XDG_CONFIG_HOME"; mkdir -p "$ARDEST"
touch "$ARDEST/garden-triager@.service"
: > "$GARDEN_MOCK_STATE"
rwerr4="$TR/rw-armretry.err"; rm -f "$TR/armed.enfail"
push_change "repos/kriscendobot-endo" "watch" "watch for arm-retry"
GARDEN_ARM_RETRY_DELAY=0 \
GARDEN_MOCK_FAIL_ENABLE_UNIT="garden-triager@kriscendobot-endo.timer" \
GARDEN_MOCK_FAIL_ENABLE_COUNT=1 \
  "$JOBS/repo-watcher.sh" >/dev/null 2>"$rwerr4"
grep -qxF "garden-triager@kriscendobot-endo.timer" "$GARDEN_MOCK_STATE" \
  && ok "transient arm failure retried and armed within the tick" \
  || bad "triager not armed after a transient arm failure"
grep -q 'systemctl rc=1' "$rwerr4" \
  && ok "transient arm failure logged the systemctl rc+stderr" \
  || bad "arm failure did not surface the underlying systemctl rc"
grep -q 'WARN: could not arm' "$rwerr4" \
  && bad "WARNed 'could not arm' despite retry succeeding" \
  || ok "no persistent-failure WARN when the retry succeeds"

# --- arm failure that persists across every attempt WARNs with rc+stderr -----
# When the hiccup does not clear, arm_timer exhausts its bounded retries and
# WARNs ONCE with the underlying rc+stderr — no per-tick swallow-and-forget.
: > "$GARDEN_MOCK_STATE"; rm -f "$TR/armed.enfail"
rwerr5="$TR/rw-armpersist.err"
GARDEN_ARM_RETRY_DELAY=0 GARDEN_ARM_RETRIES=3 \
GARDEN_MOCK_FAIL_ENABLE_UNIT="garden-triager@kriscendobot-endo.timer" \
  "$JOBS/repo-watcher.sh" >/dev/null 2>"$rwerr5"
grep -q 'WARN: could not arm garden-triager@kriscendobot-endo after 3 attempt' "$rwerr5" \
  && ok "persistent arm failure WARNs once after exhausting retries" \
  || bad "persistent arm failure did not WARN with the attempt count"
grep -q 'WARN: could not arm .*systemctl rc=1:.*XDG_RUNTIME_DIR' "$rwerr5" \
  && ok "persistent-failure WARN carries the systemctl rc and stderr" \
  || bad "persistent-failure WARN omitted the rc/stderr detail"
[ "$(grep -c '^systemctl --user enable --now garden-triager@kriscendobot-endo.timer' "$GARDEN_MOCK_LOG")" -ge 3 ] \
  && ok "arm retried the bounded number of attempts" \
  || bad "arm did not retry the expected number of attempts"
# clean up the repo file so it does not leak into later subtests
push_change "repos/kriscendobot-endo" "@DELETE" "unwatch after arm-retry test"
unset GARDEN_MOCK_FAIL_ENABLE_UNIT GARDEN_MOCK_FAIL_ENABLE_COUNT
unset XDG_CONFIG_HOME

# ============================================================================
hr; echo "SUBTEST 6 — MAINTAINER CHANNEL: gardener↔user via liaison, in-flight"; hr
export GARDEN_STATE="$TR/state-maint" GARDEN=mhost
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
export GARDEN_STATE="$TR/state-sched" GARDEN=shost
echo "# tick task"   | "$JOBS/set-schedule.sh" tick   1s     tickjob >/dev/null
echo "# weekly task" | "$JOBS/set-schedule.sh" report weekly wrjob   >/dev/null
count_pref() { git clone -q --single-branch --branch "$BRANCH" "$BARE" "$TR/sv.$1" 2>/dev/null; \
  ls -1 "$TR/sv.$1/jobs/todo" | grep -c "^$2" || true; rm -rf "$TR/sv.$1"; }
# Drive the cadence with GARDEN_SCHEDULER_NOW (a fixed epoch-second override,
# mirroring GARDEN_FOREMAN_NOW / GARDEN_USAGE_NOW) instead of real date/sleep, so
# the "immediate re-run dispatches nothing" assertion is clock-deterministic: on a
# loaded host the wall-clock gap between two real scheduler runs can exceed the 1s
# cadence and make the schedule legitimately re-fire. T0 is a large epoch so the
# weekly schedule (last_dispatched=0) is due on the first tick.
T0=2000000000   # 2033-05-18; well past one weekly cadence from epoch 0
GARDEN_SCHEDULER_NOW=$T0 "$JOBS/scheduler.sh" >/dev/null 2>&1
t1=$(count_pref a tickjob); w1=$(count_pref b wrjob)
{ [ "$t1" -ge 1 ] && [ "$w1" -ge 1 ]; } && ok "first tick dispatched both due schedules" || bad "first dispatch (tick=$t1 weekly=$w1)"
GARDEN_SCHEDULER_NOW=$T0 "$JOBS/scheduler.sh" >/dev/null 2>&1
t2=$(count_pref c tickjob); w2=$(count_pref d wrjob)
{ [ "$t2" -eq "$t1" ] && [ "$w2" -eq "$w1" ]; } && ok "immediate re-run dispatches nothing (cadence not elapsed)" || bad "re-run dispatched (tick $t1→$t2, weekly $w1→$w2)"
GARDEN_SCHEDULER_NOW=$(( T0 + 2 )) "$JOBS/scheduler.sh" >/dev/null 2>&1
t3=$(count_pref e tickjob); w3=$(count_pref f wrjob)
{ [ "$t3" -gt "$t2" ] && [ "$w3" -eq "$w2" ]; } && ok "after 1s only the 1s-cadence tick re-dispatches" || bad "cadence (tick $t2→$t3, weekly $w2→$w3)"

# ============================================================================
hr; echo "SUBTEST 8b — SCHEDULER PREFLIGHT: set-time guard, not-found vs error, escalate-once-first-tick"; hr
# GARDEN_ROOT points at the repo root (which CONTAINS scripts/jobs/) so
# alert_maintainer can deliver the one-shot escalation — it posts via
# $GARDEN_ROOT/scripts/jobs/inbox-send.sh.
export GARDEN_STATE="$TR/state-sched-pf" GARDEN=spfhost GARDEN_ROOT="$JOBS/../.."
# Count maintainer-inbox messages that mention a given schedule name.
maint_pf_msgs() { # maint_pf_msgs <schedule-name>
  local d; d="$(mktemp -d "$TR/mp.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$d" 2>/dev/null
  grep -rl "preflight gate for schedule \"$1" "$d/inbox/maintainer/unread" 2>/dev/null | grep -c . || true
  rm -rf "$d"
}

# (0) set-time GUARD: set-schedule.sh rejects a nonexistent/typo'd preflight gate
# outright, BEFORE the schedule is ever written to the board (commit "set-schedule:
# reject a nonexistent preflight gate at set time"). So a dangling gate can never be
# REGISTERED — it can only arise LATER via deploy-lag, exactly the (a) case below.
# The `if` conditions are exempt from set -e, so the expected-nonzero reject is safe.
if echo "# bogus" | GARDEN_SCHEDULE_PREFLIGHT="gardening/nope-does-not-exist.sh" \
     "$JOBS/set-schedule.sh" bogusgate 1s bogusjob >/dev/null 2>&1
then bad "set-schedule accepted a nonexistent preflight gate (want reject at set time)"
else ok "set-schedule rejects a nonexistent preflight gate at set time"; fi
OKGATE="$TR/okgate.sh"; printf '#!/bin/bash\nexit 0\n' > "$OKGATE"; chmod +x "$OKGATE"
if echo "# ok" | GARDEN_SCHEDULE_PREFLIGHT="$OKGATE" \
     "$JOBS/set-schedule.sh" okgate 1s okjob >/dev/null 2>&1
then ok "set-schedule accepts a preflight resolving to an executable"
else bad "set-schedule rejected a valid executable preflight gate"; fi

# (0b) set-time GUARD on the PRESERVE path: a schedule registered with a valid
# gate whose script LATER vanishes (deploy-lag / a removed gate) must not be able
# to carry that now-dangling reference forward on a plain cadence change. Register
# 'presvgate' with a real executable gate, delete the script, then re-run
# set-schedule WITHOUT GARDEN_SCHEDULE_PREFLIGHT (the preserve path). The preserved
# gate is re-validated and the write is refused, so the dangling line never
# re-commits. The `if` condition is exempt from set -e, so the expected reject is safe.
PRESVGATE="$TR/presvgate.sh"; printf '#!/bin/bash\nexit 0\n' > "$PRESVGATE"; chmod +x "$PRESVGATE"
echo "# preserve task" | GARDEN_SCHEDULE_PREFLIGHT="$PRESVGATE" \
  "$JOBS/set-schedule.sh" presvgate 1s presvjob >/dev/null
rm -f "$PRESVGATE"   # the gate script vanishes from the tree after registration
if echo "# preserve task" | "$JOBS/set-schedule.sh" presvgate hourly presvjob >/dev/null 2>&1
then bad "set-schedule preserved a now-dangling preflight gate (want reject on the preserve path)"
else ok "set-schedule rejects a preserved-but-dangling preflight gate on cadence change"; fi

# (a) A gate that is ABSENT AT DISPATCH TIME (deploy-lag): the preflight: path was
# valid when the schedule was set — set-schedule.sh now GUARDS the set-time case,
# rejecting a nonexistent gate outright — but the script is missing from THIS
# deploy tree by dispatch. Register with a real (exit-2) gate so set-schedule's
# guard passes, then delete it so the scheduler resolves it as not-found.
MISSGATE="$TR/missgate.sh"; printf '#!/bin/bash\nexit 2\n' > "$MISSGATE"; chmod +x "$MISSGATE"
echo "# missing-gate task" | GARDEN_SCHEDULE_PREFLIGHT="$MISSGATE" \
  "$JOBS/set-schedule.sh" missgate 1s missjob >/dev/null
rm -f "$MISSGATE"   # deploy-lag: the gate vanished from the tree after the schedule was set
# (b) A gate that EXISTS but ERRORS (exit 1) — transient, must NOT be counted.
ERRGATE="$TR/errgate.sh"; printf '#!/bin/bash\nexit 1\n' > "$ERRGATE"; chmod +x "$ERRGATE"
echo "# error-gate task" | GARDEN_SCHEDULE_PREFLIGHT="$ERRGATE" \
  "$JOBS/set-schedule.sh" errgate 1s errjob >/dev/null

SPT=2100000000  # a fresh epoch base, well past one weekly cadence
# Tick 1: both fail open and dispatch; the NOT-FOUND gate escalates ONCE on this
# very first tick (deduped on the schedule name via alert_maintainer + the
# per-breakage marker). The erroring-but-present gate never escalates.
GARDEN_SCHEDULER_NOW=$SPT           "$JOBS/scheduler.sh" >/dev/null 2>&1
mj1=$(count_pref pa missjob); ej1=$(count_pref pb errjob)
{ [ "$mj1" -ge 1 ] && [ "$ej1" -ge 1 ]; } && ok "not-found AND erroring gates both fail open (dispatched)" || bad "fail-open dispatch (miss=$mj1 err=$ej1)"
em1=$(maint_pf_msgs missgate); [ "$em1" -eq 1 ] && ok "not-found gate escalates ONCE on the first tick" || bad "first-tick escalation count=$em1 (want 1)"
ee1=$(maint_pf_msgs errgate); [ "$ee1" -eq 0 ] && ok "erroring (but present) gate does NOT escalate" || bad "errgate escalated ($ee1, want 0)"

# Tick 2 (cadence elapsed): fail-open dispatch continues, but NO second escalation
# — the missing gate is deduped on its schedule name for the whole breakage window.
GARDEN_SCHEDULER_NOW=$(( SPT + 2 )) "$JOBS/scheduler.sh" >/dev/null 2>&1
mj2=$(count_pref pc missjob)
[ "$mj2" -gt "$mj1" ] && ok "not-found gate still fails open next tick (schedule not starved)" || bad "second tick did not re-dispatch (miss=$mj2 vs $mj1)"
em2=$(maint_pf_msgs missgate); [ "$em2" -eq 1 ] && ok "escalation fires exactly once, not every tick (deduped)" || bad "escalation re-fired ($em2, want 1)"
unset GARDEN_ROOT

# ============================================================================
hr; echo "SUBTEST 8c — XS2RUST PRESS PREFLIGHT: stall bar (HEAD tracking + child ownership)"; hr
# The Fable press-driver's observe-and-defer judgment, moved into plain code:
# dispatch (exit 0) ONLY when the chain has stalled (HEAD unchanged across two
# ticks AND no live/queued build child AND the finish line unmet); defer (exit 2)
# whenever the chain is advancing (HEAD moved), owned (a stage child in doin/ or
# on the bus), mid-handoff (a successor queued in todo/), or DONE/HANDED-OFF (PR
# #600 merged/closed/left-DRAFT). Ambiguity (unreadable HEAD) and the first
# observation fail toward not-starving / establishing a baseline.
PF="$JOBS/gardening/xs2rust-endor-press-preflight.sh"
export GARDEN_STATE="$TR/state-press"
export GARDEN_XS2RUST_PRESS_PREFLIGHT_CLONE="$TR/press-clone/journal"
PHF="$GARDEN_STATE/xs2rust-endor-press-preflight/last-head"
mkdir -p "$(dirname "$PHF")"
DOIN_CHILD="jobs/doin/xs2rust-endor-build-stage3-arrays.md"
TODO_SUCC="jobs/todo/xs2rust-endor-build-stage3-strings.md"
BUS_INBOX="inbox/xs2rust-endor-build-stage3-arrays/unread/.gitkeep"
pf() { local rc; set +e; "$PF" xs2rust-endor-press >/dev/null 2>&1; rc=$?; set -e; printf '%s' "$rc"; }
# Default the finish-line read to `draft` (the PR is an OPEN DRAFT, still being
# pressed = finish line UNMET) for every case that is not about the finish line,
# so Cases 1-7 exercise the stall/ownership logic exactly as before and the guard
# never hits the network. The finish-line cases (8-10) override it per-case.
export GARDEN_PRESS_STATE_CMD='echo draft'

# Case 1 — a live stage3 child in doin/ OWNS the branch → defer (exit 2),
# regardless of HEAD (HEAD reads a fresh sha here).
push_change "$DOIN_CHILD" "# arrays" "fixture: stage3 child in doin"
export GARDEN_PRESS_HEAD_CMD='echo sha-1'
[ "$(pf)" = "2" ] && ok "live stage3 child in doin/ → defer (exit 2)" || bad "owned-in-doin did not defer"
push_change "$DOIN_CHILD" @DELETE "fixture: remove doin child"

# Case 2 — arrays gone from doin/ but a SUCCESSOR queued in todo/ (orchestration
# mid-handoff) → defer (exit 2), not a stall.
push_change "$TODO_SUCC" "# strings" "fixture: successor in todo"
rm -f "$PHF"; export GARDEN_PRESS_HEAD_CMD='echo sha-2'   # even with a fresh HEAD baseline
[ "$(pf)" = "2" ] && ok "successor build child queued in todo/ → defer (exit 2)" || bad "successor-in-todo did not defer"
push_change "$TODO_SUCC" @DELETE "fixture: remove todo successor"

# Case 3 — a build child alive on the message bus (an inbox exists) → defer.
push_change "$BUS_INBOX" "x" "fixture: build child inbox on the bus"
export GARDEN_PRESS_HEAD_CMD='echo sha-3'
[ "$(pf)" = "2" ] && ok "build child live on the bus → defer (exit 2)" || bad "bus-child did not defer"
push_change "$BUS_INBOX" @DELETE "fixture: remove bus inbox"

# From here on the board carries NO xs2rust child — only the HEAD tracker decides.
# Case 4 — first observation (no prior HEAD): establish a baseline, defer.
rm -f "$PHF"; export GARDEN_PRESS_HEAD_CMD='echo sha-base'
[ "$(pf)" = "2" ] && ok "first HEAD observation → defer to establish baseline (exit 2)" || bad "first observation did not defer"
[ "$(tr -d '[:space:]' < "$PHF" 2>/dev/null)" = "sha-base" ] && ok "baseline HEAD persisted to \$GARDEN_STATE" || bad "baseline HEAD not persisted"

# Case 5 — HEAD advanced since the previous tick → chain advancing, defer.
printf 'sha-old\n' > "$PHF"; export GARDEN_PRESS_HEAD_CMD='echo sha-new'
[ "$(pf)" = "2" ] && ok "HEAD advanced across ticks → defer (exit 2)" || bad "advancing HEAD did not defer"
[ "$(tr -d '[:space:]' < "$PHF" 2>/dev/null)" = "sha-new" ] && ok "advanced HEAD recorded for the next tick" || bad "advanced HEAD not recorded"

# Case 6 — HEAD UNCHANGED across two consecutive ticks, no child, no successor →
# the stall bar is met → take the wheel (exit 0).
printf 'sha-stall\n' > "$PHF"; export GARDEN_PRESS_HEAD_CMD='echo sha-stall'
[ "$(pf)" = "0" ] && ok "HEAD stalled two ticks + no live/queued child → dispatch (exit 0)" || bad "stall bar met but did not dispatch"

# Case 7 — HEAD unreadable (a gh/network blip) → fail open, dispatch, never starve.
printf 'sha-stall\n' > "$PHF"; export GARDEN_PRESS_HEAD_CMD='true'   # prints nothing
[ "$(pf)" = "0" ] && ok "unreadable HEAD → fail open, dispatch (exit 0)" || bad "unreadable HEAD did not fail open"

# --- finish-line guard (d): a terminal PR state OVERRIDES a stall -------------
# Each of these arms the exact stall condition that Case 6 proved dispatches
# (exit 0) — HEAD unchanged across two ticks, no child, no successor — so the
# ONLY thing that can flip it to defer is the finish-line guard reading the PR
# state. That isolates the guard from the stall logic.
armstall() { printf 'sha-stall\n' > "$PHF"; export GARDEN_PRESS_HEAD_CMD='echo sha-stall'; }

# Case 8 — PR #600 MERGED → campaign complete → defer (exit 2) despite the stall.
armstall; export GARDEN_PRESS_STATE_CMD='echo merged'
[ "$(pf)" = "2" ] && ok "MERGED PR → finish line met, defer (exit 2) even while stalled" || bad "merged PR did not defer"

# Case 9 — PR #600 CLOSED (unmerged) → no branch to press → defer (exit 2).
armstall; export GARDEN_PRESS_STATE_CMD='echo closed'
[ "$(pf)" = "2" ] && ok "CLOSED PR → defer (exit 2) even while stalled" || bad "closed PR did not defer"

# Case 10 — PR #600 left DRAFT (ready for review → judge chain) → defer (exit 2).
armstall; export GARDEN_PRESS_STATE_CMD='echo ready'
[ "$(pf)" = "2" ] && ok "PR left DRAFT (ready) → finish line met, defer (exit 2)" || bad "ready PR did not defer"

# Case 11 — PR state UNREADABLE under a stall → guard falls through to the stall
# logic (fail open), so the stall still dispatches (exit 0); a blip never skips a
# live campaign.
armstall; export GARDEN_PRESS_STATE_CMD='true'   # prints nothing
[ "$(pf)" = "0" ] && ok "unreadable PR state → fall through, stall still dispatches (exit 0)" || bad "unreadable PR state wrongly deferred"

# Case 12 — DRAFT (still being pressed) under a stall → finish line UNMET, so the
# stall dispatches (exit 0): the guard must not defer an open, in-flight draft.
armstall; export GARDEN_PRESS_STATE_CMD='echo draft'
[ "$(pf)" = "0" ] && ok "open DRAFT under a stall → finish line unmet, dispatch (exit 0)" || bad "open draft wrongly deferred"

# --- circuit breaker (overrun wedge): stop re-arming a doomed press-driver ------
# A chronically-overrunning driver stalls (HEAD unchanged) every tick but never
# advances HEAD. The consecutive-stall-dispatch counter counts those dispatches;
# once it reaches GARDEN_XS2RUST_PRESS_MAX_STALL_DISPATCHES the gate DEFERS (exit 2)
# and escalates ONE maintainer alert instead of burning another Fable budget. The
# counter resets the moment the chain advances (HEAD moves) or the PR goes terminal.
SCF="$GARDEN_STATE/xs2rust-endor-press-preflight/consecutive-stall-dispatches"
ALOG="$TR/press-alerts.log"; : > "$ALOG"
ACMD="$TR/press-alert-cmd.sh"
printf '#!/bin/bash\nprintf "%%s\\n" "$1" >> "%s"\n' "$ALOG" > "$ACMD"; chmod +x "$ACMD"
export GARDEN_ALERT_CMD="$ACMD"

# Case 13 — with threshold=2, two consecutive stalls still dispatch (exit 0) and
# each bumps the counter; the THIRD tick, at the threshold, trips the breaker →
# defer (exit 2) AND raise exactly one maintainer alert about the wedged campaign.
export GARDEN_XS2RUST_PRESS_MAX_STALL_DISPATCHES=2
rm -f "$SCF"; armstall
r13a="$(pf)"; r13b="$(pf)"
{ [ "$r13a" = "0" ] && [ "$r13b" = "0" ]; } && ok "under threshold: consecutive stalls still dispatch (exit 0)" || bad "under-threshold stalls did not dispatch ($r13a,$r13b)"
[ "$(tr -d '[:space:]' < "$SCF" 2>/dev/null)" = "2" ] && ok "consecutive-stall counter increments per dispatch" || bad "counter not 2 (got $(tr -d '[:space:]' < "$SCF" 2>/dev/null))"
: > "$ALOG"
[ "$(pf)" = "2" ] && ok "counter reaches threshold → CIRCUIT BREAKER defers (exit 2)" || bad "breaker did not defer at threshold"
[ "$(grep -c 'xs2rust-endor-press-wedged' "$ALOG" 2>/dev/null || echo 0)" -eq 1 ] && ok "breaker raises exactly one wedged-campaign maintainer alert" || bad "breaker alert count wrong ($(grep -c 'xs2rust-endor-press-wedged' "$ALOG" 2>/dev/null || echo 0))"

# Case 14 — a HEAD advance RESETS the counter, so the breaker re-arms and a later
# fresh stall dispatches again rather than staying latched off.
printf 'sha-stall\n' > "$PHF"; export GARDEN_PRESS_HEAD_CMD='echo sha-moved'
[ "$(pf)" = "2" ] && ok "HEAD advance defers (exit 2)" || bad "advancing HEAD did not defer (breaker case)"
[ "$(tr -d '[:space:]' < "$SCF" 2>/dev/null)" = "0" ] && ok "HEAD advance RESETS the stall counter to 0" || bad "HEAD advance did not reset counter (got $(tr -d '[:space:]' < "$SCF" 2>/dev/null))"
armstall
[ "$(pf)" = "0" ] && ok "after reset, a fresh stall dispatches again (breaker re-armed)" || bad "breaker stayed latched off after reset"

# Case 15 — a terminal PR state RESETS the counter even when it sat at/over the
# threshold (the campaign is over; the streak is meaningless).
printf '5\n' > "$SCF"; armstall; export GARDEN_PRESS_STATE_CMD='echo merged'
[ "$(pf)" = "2" ] && ok "merged PR defers (exit 2)" || bad "merged PR did not defer (breaker case)"
[ "$(tr -d '[:space:]' < "$SCF" 2>/dev/null)" = "0" ] && ok "terminal PR state RESETS the stall counter to 0" || bad "terminal state did not reset counter (got $(tr -d '[:space:]' < "$SCF" 2>/dev/null))"
export GARDEN_PRESS_STATE_CMD='echo draft'

# Case 16 — an UNREADABLE HEAD fails open (exit 0) even with the counter parked
# over the threshold: the breaker only fires on a positively-read stall, never on
# ambiguity, and the fail-open path leaves the counter untouched.
printf '9\n' > "$SCF"; printf 'sha-stall\n' > "$PHF"; export GARDEN_PRESS_HEAD_CMD='true'
[ "$(pf)" = "0" ] && ok "unreadable HEAD fails open (exit 0) even with a high stall count — breaker never fires on ambiguity" || bad "unreadable HEAD did not fail open under a high counter"
[ "$(tr -d '[:space:]' < "$SCF" 2>/dev/null)" = "9" ] && ok "fail-open (ambiguous) path leaves the stall counter untouched" || bad "fail-open path mutated the counter (got $(tr -d '[:space:]' < "$SCF" 2>/dev/null))"

unset GARDEN_PRESS_HEAD_CMD GARDEN_PRESS_STATE_CMD GARDEN_XS2RUST_PRESS_PREFLIGHT_CLONE \
      GARDEN_ALERT_CMD GARDEN_XS2RUST_PRESS_MAX_STALL_DISPATCHES

# ============================================================================
hr; echo "SUBTEST 9 — WATCHMAN: aggressive main2 checkout + reread broadcast"; hr
export GARDEN_STATE="$TR/state-wm" GARDEN=wmhost
GBARE="$TR/garden.git"; git init -q --bare "$GBARE"
GW="$TR/garden-wt"; git init -q "$GW"; git -C "$GW" checkout -q -b main2
git -C "$GW" config user.email t@l; git -C "$GW" config user.name t
mkdir -p "$GW/roles"; echo "v1" > "$GW/roles/x.md"
git -C "$GW" add -A; git -C "$GW" commit -q -m base; git -C "$GW" remote add origin "$GBARE"; git -C "$GW" push -q -u origin main2
G2="$TR/garden-up"; git clone -q "$GBARE" "$G2"; git -C "$G2" checkout -q main2
echo "v2" > "$G2/roles/x.md"; git -C "$G2" "${git_id[@]}" commit -qam evolve; git -C "$G2" push -q origin main2
upsha="$(git -C "$G2" rev-parse HEAD)"
# GARDEN_AGGRESSIVE_CHECKOUT=1 opts into the LEGACY aggressive fast-forward this
# subtest exercises by name. The deliberate-deploy cutover retired that path to
# OFF by default (watchman.sh sets GARDEN_AGGRESSIVE_CHECKOUT=0), so without the
# explicit opt-in the watchman no longer touches the root tree and this assertion
# would fail spuriously — it is the legacy path, not the default, that is verified.
env GARDEN_ROOT="$GW" GARDEN_MAIN_BRANCH=main2 GARDEN_WATCH_HANDLER=/bin/true \
    GARDEN_AGGRESSIVE_CHECKOUT=1 \
    "$JOBS/watchman.sh" >/dev/null 2>&1
locsha="$(git -C "$GW" rev-parse main2)"
[ "$locsha" = "$upsha" ] && ok "aggressively fast-forwarded local main2 to upstream" || bad "main2 not updated ($locsha != $upsha)"
set +e; wmout="$("$JOBS/read-msgs.sh" probe-wm broadcast)"; wmc=$?; set -e
{ [ "$wmc" -ge 1 ] && grep -qi "reread" <<<"$wmout"; } && ok "broadcast told gardeners to reread roles/skills" || bad "no reread broadcast (count=$wmc)"

# ============================================================================
hr; echo "SUBTEST 10 — BULLETIN: continuous loop, cost gate, degradation, cursor"; hr
export GARDEN_STATE="$TR/state-bul" GARDEN=bhost
CURSOR_FILE="$GARDEN_STATE/bulletin/cursor"
CALLS="$TR/bul-calls"; CAP="$TR/bul-digest"
# The parked-PR gh query is stubbed (GARDEN_BULLETIN_PARKED_CMD) and its calls are
# recorded in PCALLS — NOT reset between ticks — so the cross-tick throttle can be
# asserted. A generous TTL keeps every tick in this subtest inside one refresh
# window, so the stub must be invoked exactly once across all the run_bul passes.
PCALLS="$TR/bul-parked-calls"; : > "$PCALLS"
# Fake worktrees dir so a bare `#N` in a maintainer message resolves to the
# originating fork's repo (worktrees/<owner>-<repo>.git) deterministically, not
# against the host's real clones.
BWT="$TR/bul-worktrees"; mkdir -p "$BWT/endojs-endo-but-for-bots.git"
# run ONE pass of the continuous loop with the journalist + parked query stubbed
run_bul() {
  : > "$CALLS"
  env GARDEN_BULLETIN_ONCE=1 GARDEN_BULLETIN_IDLE_SLEEP=0 \
      GARDEN_BULLETIN_HANDLER="${1:-$HERE/bulletin-stub.sh}" \
      GARDEN_BULLETIN_STUB_CALLS="$CALLS" GARDEN_BULLETIN_STUB_CAPTURE="$CAP" \
      GARDEN_BULLETIN_PARKED_CMD="$HERE/bulletin-parked-stub.sh" \
      GARDEN_BULLETIN_PARKED_CALLS="$PCALLS" GARDEN_BULLETIN_PARKED_TTL=600 \
      GARDEN_WORKTREES="$BWT" \
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
# the transitions section (not the dashboard, whose Board section may mention
# other jobs) must carry only the since-cursor delta
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

# (5b) issue/PR references in the maintainer inbox render as WORKING hyperlinks.
#      A message from a doer whose base resolves to endojs/endo-but-for-bots links
#      owner/repo#N, a full issue/PR URL, and a bare #N (to the RESOLVED repo);
#      references inside a fenced code block stay plain. A second message from an
#      UNRESOLVABLE doer (foreman) leaves its bare #N as plain text (no mislink).
lmsg="$(printf 'from_host: h\nfrom: gardener:endojs-endo-but-for-bots-linktest\nreply_to: endojs-endo-but-for-bots-linktest\nsent_at: t1\n---\nOpened endojs/endo-but-for-bots#650 (CLI follow-up for #652). Run `rebase #650` first.\nSee https://github.com/endojs/endo-but-for-bots/pull/653.\n\n```\nleave #999 and endojs/endo-but-for-bots#111 plain in a fence\n```\n')"
push_change "inbox/maintainer/unread/bul-maint-2.md" "$lmsg" "seed maintainer message with issue refs"
umsg="$(printf 'from_host: h\nfrom: foreman\nreply_to:\nsent_at: t2\n---\nUnresolvable doer note mentioning #4242 which must stay plain text.\n')"
push_change "inbox/maintainer/unread/bul-maint-3.md" "$umsg" "seed unresolvable maintainer message"
run_bul
rm -rf "$BV"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$BV"
{ grep -qF '[endojs/endo-but-for-bots#650](https://github.com/endojs/endo-but-for-bots/issues/650)' "$BV/README.md" \
  && grep -qF '[#652](https://github.com/endojs/endo-but-for-bots/issues/652)' "$BV/README.md" \
  && grep -qF '[https://github.com/endojs/endo-but-for-bots/pull/653](https://github.com/endojs/endo-but-for-bots/pull/653)' "$BV/README.md"; } \
  && ok "maintainer inbox links owner/repo#N, bare #N (resolved repo), and a full issue/PR URL" || bad "issue/PR references not linked in the maintainer inbox"
# fenced references stay plain (no link markup applied inside the code fence)
{ grep -qF '> leave #999 and endojs/endo-but-for-bots#111 plain in a fence' "$BV/README.md" \
  && ! grep -qF '[#999](' "$BV/README.md"; } \
  && ok "references inside a fenced code block stay plain (not autolinked)" || bad "fenced references were autolinked"
# references inside an inline `code` span stay plain (a link inside backticks
# would render as literal text) — the `#650` in `rebase #650` must NOT be linked
grep -qF '`rebase #650`' "$BV/README.md" \
  && ok "reference inside an inline code span stays plain (not autolinked)" || bad "inline-code-span reference was autolinked"
# unresolvable bare #N is left plain — present as text, but never turned into a link
{ grep -qF '#4242 which must stay plain text' "$BV/README.md" \
  && ! grep -qF '[#4242](' "$BV/README.md"; } \
  && ok "bare #N with an unresolvable repo stays plain text (no mislink)" || bad "unresolvable bare #N was linked"
rm -rf "$BV"

# (6) restructured layout: `## Latest` LEADS, a deterministic parked-for-maintainer
#     section lists the review-requested PRs with hyperlinks, `## Recent progress`
#     is gone, and the gh query was throttled (fetched once across all the ticks).
rm -rf "$BV"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$BV"
README="$BV/README.md"
lp=$(grep -n '^## Latest$' "$README" | head -1 | cut -d: -f1)
pk=$(grep -n '^## Parked for maintainer feedback$' "$README" | head -1 | cut -d: -f1)
bd=$(grep -n '^## Board$' "$README" | head -1 | cut -d: -f1)
{ [ -n "$lp" ] && [ -n "$pk" ] && [ -n "$bd" ] && [ "$lp" -lt "$pk" ] && [ "$pk" -lt "$bd" ]; } \
  && ok "layout leads with ## Latest, then Parked, then Board" || bad "section order wrong (Latest=$lp Parked=$pk Board=$bd)"
! grep -q '^## Recent progress' "$README" \
  && ok "## Recent progress removed" || bad "## Recent progress still present"
{ grep -qF '[endojs/endo-but-for-bots#513](https://github.com/endojs/endo-but-for-bots/pull/513)' "$README" \
  && grep -qF '[kriskowal/garden#474](https://github.com/kriskowal/garden/pull/474)' "$README" \
  && grep -qE 'waiting [0-9]+[dhms]\)$' "$README"; } \
  && ok "parked section lists review-requested PRs as hyperlinks with a waiting age" || bad "parked PRs not rendered with links/age"
pn=$(grep -c . "$PCALLS" || true)
[ "$pn" -eq 1 ] \
  && ok "parked gh query throttled: fetched once across all ticks (not per-tick)" || bad "parked query not throttled (calls=$pn)"
rm -rf "$BV"

# (7) PUSH-GATE: with NOTHING pushed to journal2 since the last bulletin, a tick
#     makes NO update — no commit, no journalist — even when external GitHub state
#     (the parked-PR set) could have drifted AND its throttle window is forced open
#     (TTL=0). The gate short-circuits BEFORE the parked query is even reached, so
#     the bulletin tracks journal2 pushes, not external drift.
rm -rf "$BV"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$BV"
pre_head="$(ohead)"; pre_readme="$(cat "$BV/README.md")"; rm -rf "$BV"
GATECALLS="$TR/bul-gate-parked-calls"; : > "$GATECALLS"; : > "$CALLS"
# TTL=0 would force a fresh parked re-query absent the gate; assert it is NOT
# reached (GATECALLS stays empty) because the push-gate returns first.
env GARDEN_BULLETIN_ONCE=1 GARDEN_BULLETIN_IDLE_SLEEP=0 \
    GARDEN_BULLETIN_HANDLER="$HERE/bulletin-stub.sh" \
    GARDEN_BULLETIN_STUB_CALLS="$CALLS" GARDEN_BULLETIN_STUB_CAPTURE="$CAP" \
    GARDEN_BULLETIN_PARKED_CMD="$HERE/bulletin-parked-stub.sh" \
    GARDEN_BULLETIN_PARKED_CALLS="$GATECALLS" GARDEN_BULLETIN_PARKED_TTL=0 \
    "$JOBS/bulletin.sh" >/dev/null 2>&1
post_head="$(ohead)"
{ [ "$pre_head" = "$post_head" ] && [ ! -s "$CALLS" ] && [ ! -s "$GATECALLS" ]; } \
  && ok "push-gate: no journal2 push → no commit, no journalist, parked query not reached" \
  || bad "push-gate leaked (head $pre_head->$post_head, journalist=$(wc -l <"$CALLS"), parked=$(wc -l <"$GATECALLS"))"
rm -rf "$BV"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$BV"
[ "$(cat "$BV/README.md")" = "$pre_readme" ] \
  && ok "push-gate: bulletin content unchanged despite an open parked-query window" || bad "bulletin changed with no journal2 push"
rm -rf "$BV"

# ============================================================================
hr; echo "SUBTEST 10b — PARKED FUZZY RANK: recency + roadmap, top-N cap, fallback"; hr
# Unit-test the parked-PR scorer directly (the exact functions the bulletin loop
# calls): extract humanize_age + roadmap_index + render_parked from bulletin.sh,
# source them, and assert ranking semantics deterministically. Ages are computed
# relative to run time so the fixture stays stable across days.
PF="$TR/parked-funcs"; mkdir -p "$PF"
extract_fn() { awk -v fn="$1" 'index($0, fn"() {")==1{f=1} f{print} f && /^}/{exit}' "$JOBS/bulletin.sh"; }
{ extract_fn humanize_age; echo; extract_fn roadmap_index; echo; extract_fn render_parked; } > "$PF/funcs.sh"
bash -n "$PF/funcs.sh" && ok "extracted parked functions parse" || bad "parked functions do not parse"
# Plan fixture: PR 100 is a 450-day-stale but TOP-of-roadmap design (priority 1 →
# relevance 100); PR 200 is mid-roadmap (explicit relevance 30). Everything else
# is unmapped (peripheral).
PLAN="$PF/journal/plan/designs/proj"; mkdir -p "$PLAN"
printf -- '---\nrepository: endojs/endo-but-for-bots\npr: 100\npriority: 1\n---\n# critical\n' > "$PLAN/crit.md"
printf -- '---\npr: https://github.com/endojs/endo-but-for-bots/pull/200\nroadmap_relevance: 30\n---\n# mid\n' > "$PLAN/mid.md"
PARKED_OUT="$(
  DIR="$PF/journal" \
  GARDEN_BULLETIN_PARKED_TOPN=3 GARDEN_BULLETIN_PARKED_HALFLIFE_DAYS=14 \
  GARDEN_BULLETIN_PARKED_WEIGHT_RECENCY=50 GARDEN_BULLETIN_PARKED_WEIGHT_ROADMAP=50 \
  GARDEN_BULLETIN_PARKED_ROADMAP_CMD= \
  bash -c '
    source "'"$PF"'/funcs.sh"
    NOW=$(date -u +%FT%TZ); D2=$(date -u -d "2 days ago" +%FT%TZ)
    OLD=$(date -u -d "450 days ago" +%FT%TZ); MID=$(date -u -d "20 days ago" +%FT%TZ)
    rows=$(printf "%s\t%s\t%s\t%s\t%s\n" \
      endojs/endo-but-for-bots 100 https://x/100 "$OLD" "stale-but-critical" \
      endojs/endo-but-for-bots 999 https://x/999 "$NOW" "fresh-peripheral" \
      endojs/endo-but-for-bots 200 https://x/200 "$MID" "mid-roadmap" \
      endojs/endo-but-for-bots 555 https://x/555 "$OLD" "ancient-peripheral" \
      endojs/endo-but-for-bots 777 https://x/777 "$D2" "recent-peripheral")
    render_parked "$rows"
  '
)"
# roadmap index parsed both mappings (number form + pull-URL form)
ridx="$(DIR="$PF/journal" GARDEN_BULLETIN_PARKED_ROADMAP_CMD= bash -c 'source "'"$PF"'/funcs.sh"; roadmap_index')"
{ grep -qP 'endojs/endo-but-for-bots\t100\t100' <<<"$ridx" \
  && grep -qP 'endojs/endo-but-for-bots\t200\t30' <<<"$ridx"; } \
  && ok "roadmap_index parses pr-number and pull-URL frontmatter forms" || bad "roadmap_index parse wrong ($ridx)"
# stale-but-critical surfaces (roadmap lifts it above ancient peripheral)
grep -qF 'stale-but-critical' <<<"$PARKED_OUT" \
  && ok "stale-but-high-roadmap PR surfaces in the top N" || bad "critical PR did not surface"
# fresh peripheral also surfaces
grep -qF 'fresh-peripheral' <<<"$PARKED_OUT" \
  && ok "fresh-but-peripheral PR surfaces in the top N" || bad "fresh peripheral did not surface"
# ancient peripheral falls off the top-3
! grep -qF 'ancient-peripheral' <<<"$PARKED_OUT" \
  && ok "ancient peripheral PR drops off below the cap" || bad "ancient peripheral did not drop"
# cap + count note
{ [ "$(grep -c '^- \[' <<<"$PARKED_OUT")" -eq 3 ] && grep -qF 'Showing top 3 of 5 parked PRs' <<<"$PARKED_OUT"; } \
  && ok "output capped at TOPN with a 'showing N of M' note" || bad "cap/note wrong ($PARKED_OUT)"
# recency-only fallback: with NO roadmap mapping, the 450-day critical PR drops and
# the ranking is pure recency (fresh > recent > mid).
PARKED_REC="$(
  DIR="$PF/journal" GARDEN_BULLETIN_PARKED_TOPN=3 GARDEN_BULLETIN_PARKED_HALFLIFE_DAYS=14 \
  GARDEN_BULLETIN_PARKED_WEIGHT_RECENCY=50 GARDEN_BULLETIN_PARKED_WEIGHT_ROADMAP=50 \
  GARDEN_BULLETIN_PARKED_ROADMAP_CMD=true bash -c '
    source "'"$PF"'/funcs.sh"
    NOW=$(date -u +%FT%TZ); D2=$(date -u -d "2 days ago" +%FT%TZ)
    OLD=$(date -u -d "450 days ago" +%FT%TZ); MID=$(date -u -d "20 days ago" +%FT%TZ)
    rows=$(printf "%s\t%s\t%s\t%s\t%s\n" \
      endojs/endo-but-for-bots 100 https://x/100 "$OLD" "stale-but-critical" \
      endojs/endo-but-for-bots 999 https://x/999 "$NOW" "fresh-peripheral" \
      endojs/endo-but-for-bots 200 https://x/200 "$MID" "mid-roadmap" \
      endojs/endo-but-for-bots 777 https://x/777 "$D2" "recent-peripheral")
    render_parked "$rows"
  '
)"
{ ! grep -qF 'stale-but-critical' <<<"$PARKED_REC" && grep -qF 'fresh-peripheral' <<<"$PARKED_REC"; } \
  && ok "recency-only fallback (no roadmap data): stale PR drops, recency ranks" || bad "recency fallback wrong ($PARKED_REC)"
rm -rf "$PF"

# ============================================================================
hr; echo "SUBTEST 10c — PLAN QUEUE: jobs/plan/ rendered (go-ahead + deferred)"; hr
# Unit-test render_plan_queue directly — the deterministic "## Plan queue" section
# that surfaces the parked jobs/plan/ category (NOT the design-plan render_plan).
# Extract the renderer + its job_desc helper from bulletin.sh and the plan-metadata
# helpers from common.sh, source them over a throwaway jobs/plan/ fixture, and
# assert each parked job lands under the right group with its description+priority.
QF="$TR/plan-queue"; mkdir -p "$QF/journal/jobs/plan"
# extract_fn (defined in SUBTEST 10b) pulls a function body from a given file; the
# renderer spans two source files, so name them explicitly here.
qextract() { awk -v fn="$1" 'index($0, fn"() {")==1{f=1} f{print} f && /^}/{exit}' "$2"; }
{
  for fn in list_jobs plan_field plan_gate plan_priority plan_blocked_on plan_rank plan_deferred_ranked; do qextract "$fn" "$JOBS/common.sh"; echo; done
  for fn in job_desc render_plan_queue; do qextract "$fn" "$JOBS/bulletin.sh"; echo; done
  echo 'JOBS_PLAN="jobs/plan"'
} > "$QF/funcs.sh"
bash -n "$QF/funcs.sh" && ok "extracted plan-queue functions parse" || bad "plan-queue functions do not parse"
# Fixture: one go-ahead job (needs maintainer authorization) and two deferred jobs
# at different priorities (high should rank above low).
printf -- '---\ngate: go-ahead\npriority: high\n---\n# authorize the ocap import\n' > "$QF/journal/jobs/plan/needs-authz.md"
printf -- '---\ngate: deferred\npriority: high\n---\n# refactor the widget\n'        > "$QF/journal/jobs/plan/defer-high.md"
printf -- '---\ngate: deferred\npriority: low\n---\n# tidy the docs\n'               > "$QF/journal/jobs/plan/defer-low.md"
PQ_OUT="$(DIR="$QF/journal" bash -c 'source "'"$QF"'/funcs.sh"; render_plan_queue')"
# go-ahead group lists the authz job with its description; deferred jobs do NOT appear there
goahead_block="$(awk '/^### awaiting go-ahead/{f=1;next} /^### deferred/{f=0} f' <<<"$PQ_OUT")"
defer_block="$(awk '/^### deferred/{f=1} f' <<<"$PQ_OUT")"
{ grep -qF 'needs-authz' <<<"$goahead_block" && grep -qF 'authorize the ocap import' <<<"$goahead_block" \
  && ! grep -qF 'defer-high' <<<"$goahead_block"; } \
  && ok "go-ahead group lists gate=go-ahead jobs with description (deferred excluded)" || bad "go-ahead group wrong ($goahead_block)"
# deferred group lists both deferred jobs, high before low, with descriptions; not the go-ahead one
{ grep -qF 'defer-high' <<<"$defer_block" && grep -qF 'refactor the widget' <<<"$defer_block" \
  && grep -qF 'defer-low' <<<"$defer_block" && ! grep -qF 'needs-authz' <<<"$defer_block"; } \
  && ok "deferred group lists gate=deferred jobs with description (go-ahead excluded)" || bad "deferred group wrong ($defer_block)"
# priority order: high ranks before low in the deferred group
hi_ln="$(grep -n 'defer-high' <<<"$defer_block" | head -1 | cut -d: -f1)"
lo_ln="$(grep -n 'defer-low'  <<<"$defer_block" | head -1 | cut -d: -f1)"
{ [ -n "$hi_ln" ] && [ -n "$lo_ln" ] && [ "$hi_ln" -lt "$lo_ln" ]; } \
  && ok "deferred group sorted by priority (high before low)" || bad "deferred not priority-sorted (hi=$hi_ln lo=$lo_ln)"
# empty jobs/plan/ → all three groups render "(none)", never an empty section
rm -f "$QF"/journal/jobs/plan/*.md
PQ_EMPTY="$(DIR="$QF/journal" bash -c 'source "'"$QF"'/funcs.sh"; render_plan_queue')"
{ [ "$(grep -c '^(none)$' <<<"$PQ_EMPTY")" -eq 3 ]; } \
  && ok "empty jobs/plan/ → all three groups render (none)" || bad "empty plan queue not (none) ($PQ_EMPTY)"
rm -rf "$QF"

# ============================================================================
hr; echo "SUBTEST 11 — MENTOR: log → improvement job (self-healing)"; hr
export GARDEN_STATE="$TR/state-imp" GARDEN=ihost
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

# A TRANSIENT inner-handler outage (claude quota/overload/5xx, or a github/network
# blip) must NOT mark the service Failed: mentor.sh WARNs and exits 0, leaving the
# $SEEN marker unadvanced so the next tick retries. A GENUINE (non-transient)
# handler defect still dies (exit 1 → self-heal). Regression guard for the
# 2026-07-02 quota-cut cascade that fired self-heal into the same dead outage.
SEENF="$GARDEN_STATE/mentor/seen"
# Handler that fails with a transient-claude signature.
cat > "$TR/mentor-transient.sh" <<'EOF'
#!/bin/bash
echo "API Error: Overloaded (529) — please retry" >&2
exit 1
EOF
# Handler that fails with a genuine, non-transient defect (no known signature).
cat > "$TR/mentor-real.sh" <<'EOF'
#!/bin/bash
echo "TypeError: cannot read property of undefined at line 42" >&2
exit 1
EOF
chmod +x "$TR/mentor-transient.sh" "$TR/mentor-real.sh"
# Fresh error entry so `new` is non-empty and the handler path is reached.
printf 'a fresh failure to feed the mentor handler\n' | GARDEN_ROLE=gardener "$JOBS/journal-entry.sh" error >/dev/null
seen_before="$(wc -l < "$SEENF" 2>/dev/null || echo 0)"
trc=0; env GARDEN_MENTOR_HANDLER="$TR/mentor-transient.sh" "$JOBS/mentor.sh" >/dev/null 2>&1 || trc=$?
seen_after="$(wc -l < "$SEENF" 2>/dev/null || echo 0)"
{ [ "$trc" -eq 0 ] && [ "$seen_after" -eq "$seen_before" ]; } \
  && ok "transient handler outage → exit 0, markers unadvanced (retry next tick)" \
  || bad "transient outage not absorbed (rc=$trc seen $seen_before→$seen_after)"
# The same still-unseen entry now hits a real defect → mentor must die (exit 1).
rrc=0; env GARDEN_MENTOR_HANDLER="$TR/mentor-real.sh" "$JOBS/mentor.sh" >/dev/null 2>&1 || rrc=$?
[ "$rrc" -ne 0 ] && ok "genuine handler defect → non-zero exit (self-heal path)" \
  || bad "real defect did not die (rc=$rrc)"
# An EMPTY-output SIGKILL/OOM (rc=137) — a `claude -p` handler killed mid-call
# leaving nothing in $capture — matches no transient SIGNATURE (the capture is
# empty), so before the empty-capture-transient branch it fell through to `die`
# and fired self-heal into the same outage (the 2026-07-05 30-min FATAL loop on
# endolinbot). It must be absorbed: WARN + exit 0, markers unadvanced.
cat > "$TR/mentor-emptykill.sh" <<'EOF'
#!/bin/bash
exit 137
EOF
chmod +x "$TR/mentor-emptykill.sh"
seen_before_k="$(wc -l < "$SEENF" 2>/dev/null || echo 0)"
krc=0; env GARDEN_MENTOR_HANDLER="$TR/mentor-emptykill.sh" "$JOBS/mentor.sh" >/dev/null 2>&1 || krc=$?
seen_after_k="$(wc -l < "$SEENF" 2>/dev/null || echo 0)"
{ [ "$krc" -eq 0 ] && [ "$seen_after_k" -eq "$seen_before_k" ]; } \
  && ok "empty-output kill (rc=137) → exit 0, markers unadvanced (retry next tick)" \
  || bad "empty-output kill not absorbed (rc=$krc seen $seen_before_k→$seen_after_k)"

# The REAL mentor-claude.sh handler must PROPAGATE a transient inner-`claude`
# failure (a quota/usage cut, an Anthropic overload/5xx, an api/network blip) — a
# non-zero exit with its output RE-EMITTED — not swallow it. Before the fix the
# `claude` call ran under `set -euo pipefail`, so a non-zero exit aborted the
# handler at rc=1 with claude's stdout trapped in a discarded `$out` and NOTHING
# re-emitted; mentor.sh then saw an empty capture + rc=1, matched no transient
# classifier, and fell through to `die`/self-heal — the 2026-07-06 FATAL loop.
# Drive the real handler with the deterministic fake-claude stub (via the
# GARDEN_MENTOR_CLAUDE seam — a differently-named binary because the fleet sandbox
# pins the literal `claude`, so a PATH shim named `claude` cannot execute) failing
# with a transient signature; the handler must re-emit that signature AND exit
# non-zero so mentor.sh's classifier can absorb it.
mc_rc=0
mc_out="$(env GARDEN_MENTOR_CLAUDE="$HERE/fake-claude.sh" FAKE_CLAUDE_FAIL=1 \
  FAKE_CLAUDE_STDERR="API Error: Overloaded (529) — please retry" \
  GARDEN_MENTOR_PROVIDER_ORDER=anthropic \
  GARDEN_ROOT="$JOBS/../.." "$JOBS/handlers/mentor-claude.sh" deadbeef "$TR" 2>&1)" || mc_rc=$?
{ [ "$mc_rc" -ne 0 ] && printf '%s' "$mc_out" | grep -q 'Overloaded (529)'; } \
  && ok "mentor-claude propagates transient claude failure (rc≠0, output re-emitted)" \
  || bad "mentor-claude swallowed transient claude failure (rc=$mc_rc out='$mc_out')"

# ============================================================================
hr; echo "SUBTEST 12 — CURSORS: durable poll position survives a restart"; hr
export GARDEN=curhost
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
export GARDEN_STATE="$TR/state-fu" GARDEN=fuhost
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
hr; echo "SUBTEST 13b — FOLLOW-UP HANDLER: producer failure classification"; hr
# The default follow-up handler (follow-up-claude.sh) is driven here directly —
# GARDEN_FOLLOWUP_HANDLER is left at its default so the REAL handler runs — with
# the inner `claude -p` replaced by a deterministic stub (GARDEN_FOLLOWUP_CLAUDE)
# that emits chosen action blocks. We assert the split the 2026-06-27 wedge
# required: a block whose producer rejects it DETERMINISTICALLY (an illegal
# derived name) is logged-and-skipped (tick succeeds, seen-marker advances, so a
# non-deterministic re-roll can never re-wedge), while a TRANSIENT producer
# failure (push-retry exhaustion) fails the tick (marker NOT advanced, so the
# digest is retried next cadence).
export GARDEN_STATE="$TR/state-fuh" GARDEN=fuhhost
SEEN_FUH="$GARDEN_STATE/follow-up/seen"
# Prime the cold-start marker so subsequent ticks ACT (cold start never calls the
# handler — it only records existing reports seen).
push_change "jobs/tada/fuh-prime.md" "$(printf '# prime\n## Follow-ups\n- None\n')" "seed prime tada (cold start)"
env GARDEN_FOLLOWUP_CLAUDE="$HERE/fake-claude.sh" "$JOBS/follow-up.sh" >/dev/null 2>&1

# (A) deterministic rejection — illegal derived name → post-job `die "illegal
# basename"`. Handler must SKIP (continue), the tick must SUCCEED, the marker
# must advance, no job may leak to todo, and the dropped block is routed to the
# maintainer inbox so it is not silently lost.
push_change "jobs/tada/fuh-detrej.md" \
  "$(printf '# detrej\n## Follow-ups (escalated to liaison)\n- post a follow-up job on endo-but-for-bots\n')" \
  "seed deterministic-reject report"
printf 'JOB fuh-detrej/bad-1\nendojs/endo-but-for-bots: a follow-up task\nENDJOB\n' > "$TR/blocks-detrej"
mm_before=$(git clone -q --single-branch --branch "$BRANCH" "$BARE" "$TR/fuhv0" && \
  ls -1 "$TR/fuhv0/inbox/maintainer/unread" | grep -vxc '.gitkeep' || true); rm -rf "$TR/fuhv0"
rcA=0
env GARDEN_FOLLOWUP_CLAUDE="$HERE/fake-claude.sh" FAKE_CLAUDE_BLOCKS="$TR/blocks-detrej" \
    "$JOBS/follow-up.sh" >/dev/null 2>&1 || rcA=$?
seenA=0; grep -qxF "jobs/tada/fuh-detrej.md" "$SEEN_FUH" 2>/dev/null && seenA=1
git clone -q --single-branch --branch "$BRANCH" "$BARE" "$TR/fuhv1"
leakA=$(ls -1 "$TR/fuhv1/jobs/todo" | grep -c '^fuh-detrej' || true)
mm_after=$(ls -1 "$TR/fuhv1/inbox/maintainer/unread" | grep -vxc '.gitkeep' || true); rm -rf "$TR/fuhv1"
{ [ "$rcA" -eq 0 ] && [ "$seenA" -eq 1 ] && [ "$leakA" -eq 0 ]; } \
  && ok "deterministic rejection: logged-and-skipped, tick succeeds, marker advanced, no job leaked" \
  || bad "deterministic case wrong (rc=$rcA seen=$seenA leak=$leakA)"
[ "$mm_after" -gt "$mm_before" ] \
  && ok "rejected block routed to maintainer inbox (not silently dropped)" \
  || bad "rejected block not routed to maintainer ($mm_before→$mm_after)"

# (B) transient failure — a VALID block whose producer's push is forced to fail
# (GARDEN_PUSH_CMD=/bin/false) so post-job exhausts its retries and dies "could
# not post … after retries". Handler must FAIL the tick; the marker must NOT
# advance, so follow-up.sh retries the digest next cadence.
push_change "jobs/tada/fuh-trans.md" \
  "$(printf '# trans\n## Follow-ups (escalated to liaison)\n- post a follow-up job on endo-but-for-bots\n')" \
  "seed transient-fail report"
printf 'JOB fuh-trans-1\nendojs/endo-but-for-bots: a valid follow-up task\nENDJOB\n' > "$TR/blocks-trans"
rcB=0
env GARDEN_FOLLOWUP_CLAUDE="$HERE/fake-claude.sh" FAKE_CLAUDE_BLOCKS="$TR/blocks-trans" \
    GARDEN_PUSH_CMD=/bin/false GARDEN_POST_ATTEMPTS=2 \
    "$JOBS/follow-up.sh" >/dev/null 2>&1 || rcB=$?
seenB=0; grep -qxF "jobs/tada/fuh-trans.md" "$SEEN_FUH" 2>/dev/null && seenB=1
{ [ "$rcB" -ne 0 ] && [ "$seenB" -eq 0 ]; } \
  && ok "transient producer failure: tick fails, marker NOT advanced (digest retried)" \
  || bad "transient case wrong (rc=$rcB seen=$seenB — want rc!=0, seen=0)"

# (C) inner `claude -p` fails with a TRANSIENT signature (an API overload). The
# handler must classify it as a self-resolving blip and FAIL the tick (die) so the
# marker is NOT advanced and follow-up.sh retries the SAME digest next cadence —
# the historical behavior, preserved only for transient signatures now.
push_change "jobs/tada/fuh-ctrans.md" \
  "$(printf '# ctrans\n## Follow-ups (escalated to liaison)\n- post a follow-up job on endo-but-for-bots\n')" \
  "seed inner-claude transient-failure report"
rcC=0
env GARDEN_FOLLOWUP_CLAUDE="$HERE/fake-claude.sh" FAKE_CLAUDE_FAIL=1 \
    FAKE_CLAUDE_STDERR="API error: Overloaded (529); please retry" \
    "$JOBS/follow-up.sh" >/dev/null 2>&1 || rcC=$?
seenC=0; grep -qxF "jobs/tada/fuh-ctrans.md" "$SEEN_FUH" 2>/dev/null && seenC=1
{ [ "$rcC" -ne 0 ] && [ "$seenC" -eq 0 ]; } \
  && ok "inner claude transient failure: tick fails, marker NOT advanced (digest retried)" \
  || bad "inner-claude transient case wrong (rc=$rcC seen=$seenC — want rc!=0, seen=0)"

# (D) inner `claude -p` fails with a NON-transient signature (a genuine crash).
# Re-rolling the same digest would only reproduce it (the 2026-06-27 ~6x re-roll
# loop), so the handler must route stderr+stdout to the maintainer inbox and EXIT
# 0 — advancing the marker so the bad digest stops wedging the service.
push_change "jobs/tada/fuh-dcrash.md" \
  "$(printf '# dcrash\n## Follow-ups (escalated to liaison)\n- post a follow-up job on endo-but-for-bots\n')" \
  "seed inner-claude crash report"
mm_before2=$(git clone -q --single-branch --branch "$BRANCH" "$BARE" "$TR/fuhv2" && \
  ls -1 "$TR/fuhv2/inbox/maintainer/unread" | grep -vxc '.gitkeep' || true); rm -rf "$TR/fuhv2"
rcD=0
env GARDEN_FOLLOWUP_CLAUDE="$HERE/fake-claude.sh" FAKE_CLAUDE_FAIL=1 \
    FAKE_CLAUDE_STDERR="TypeError: undefined is not a function (a genuine inner-agent crash)" \
    "$JOBS/follow-up.sh" >/dev/null 2>&1 || rcD=$?
seenD=0; grep -qxF "jobs/tada/fuh-dcrash.md" "$SEEN_FUH" 2>/dev/null && seenD=1
git clone -q --single-branch --branch "$BRANCH" "$BARE" "$TR/fuhv3"
mm_after2=$(ls -1 "$TR/fuhv3/inbox/maintainer/unread" | grep -vxc '.gitkeep' || true); rm -rf "$TR/fuhv3"
{ [ "$rcD" -eq 0 ] && [ "$seenD" -eq 1 ]; } \
  && ok "inner claude non-transient failure: routed + exit 0, marker advanced (no re-roll)" \
  || bad "inner-claude non-transient case wrong (rc=$rcD seen=$seenD — want rc=0, seen=1)"
[ "$mm_after2" -gt "$mm_before2" ] \
  && ok "inner-claude failure routed to maintainer inbox (not silently retried)" \
  || bad "inner-claude failure not routed to maintainer ($mm_before2→$mm_after2)"

# ============================================================================
hr; echo "SUBTEST 13c — FOLLOW-UP: bounded retry + quarantine of a wedged digest"; hr
# A handler that NEVER succeeds on the same pending set must not re-run forever
# (the 2026-06-27 07:53–08:44 episode). With the handler forced to fail
# (/bin/false) and the ceiling lowered to 3: ticks below the ceiling FAIL and
# grow the streak (marker not advanced, so a transient window self-resolves);
# the tick AT the ceiling quarantines the reports (advances the marker, clears
# the streak, escalates to the maintainer) and EXITS 0 so the burn stops.
export GARDEN_STATE="$TR/state-fuq" GARDEN=fuqhost
SEEN_FUQ="$GARDEN_STATE/follow-up/seen"; FC_FUQ="$GARDEN_STATE/follow-up/fail-count"
# prime cold-start so subsequent ticks ACT (cold start never calls the handler)
push_change "jobs/tada/fuq-prime.md" "$(printf '# prime\n## Follow-ups\n- None\n')" "seed prime tada (cold start, q)"
env GARDEN_FOLLOWUP_HANDLER=/bin/true "$JOBS/follow-up.sh" >/dev/null 2>&1
# a NEW report with an actionable follow-up; the handler is wedged (always fails)
push_change "jobs/tada/fuq-wedge.md" "$(printf '# wedge\n## Follow-ups (escalated to liaison)\n- do an impossible thing\n')" "seed wedged report"
mm_q0=$(git clone -q --single-branch --branch "$BRANCH" "$BARE" "$TR/fuqv0" && \
  ls -1 "$TR/fuqv0/inbox/maintainer/unread" | grep -vxc '.gitkeep' || true); rm -rf "$TR/fuqv0"
# ticks 1..2 are below the ceiling: each FAILS, marker NOT advanced, streak 1→2
rc1=0; env GARDEN_FOLLOWUP_HANDLER=/bin/false GARDEN_FOLLOWUP_MAX_RETRIES=3 "$JOBS/follow-up.sh" >/dev/null 2>&1 || rc1=$?
c1=$(awk '{print $1}' "$FC_FUQ" 2>/dev/null || echo NONE)
rc2=0; env GARDEN_FOLLOWUP_HANDLER=/bin/false GARDEN_FOLLOWUP_MAX_RETRIES=3 "$JOBS/follow-up.sh" >/dev/null 2>&1 || rc2=$?
c2=$(awk '{print $1}' "$FC_FUQ" 2>/dev/null || echo NONE)
seen_pre=0; grep -qxF "jobs/tada/fuq-wedge.md" "$SEEN_FUQ" 2>/dev/null && seen_pre=1
{ [ "$rc1" -ne 0 ] && [ "$rc2" -ne 0 ] && [ "$c1" = 1 ] && [ "$c2" = 2 ] && [ "$seen_pre" -eq 0 ]; } \
  && ok "below ceiling: each tick fails, streak increments (1→2), marker NOT advanced" \
  || bad "below-ceiling wrong (rc1=$rc1 rc2=$rc2 c1=$c1 c2=$c2 seen=$seen_pre)"
# tick 3 hits the ceiling → quarantine: exit 0, marker advanced, streak cleared, escalated
rc3=0; env GARDEN_FOLLOWUP_HANDLER=/bin/false GARDEN_FOLLOWUP_MAX_RETRIES=3 "$JOBS/follow-up.sh" >/dev/null 2>&1 || rc3=$?
seen_post=0; grep -qxF "jobs/tada/fuq-wedge.md" "$SEEN_FUQ" 2>/dev/null && seen_post=1
fc_gone=0; [ -f "$FC_FUQ" ] || fc_gone=1
mm_q1=$(git clone -q --single-branch --branch "$BRANCH" "$BARE" "$TR/fuqv1" && \
  ls -1 "$TR/fuqv1/inbox/maintainer/unread" | grep -vxc '.gitkeep' || true); rm -rf "$TR/fuqv1"
{ [ "$rc3" -eq 0 ] && [ "$seen_post" -eq 1 ] && [ "$fc_gone" -eq 1 ] && [ "$mm_q1" -gt "$mm_q0" ]; } \
  && ok "at ceiling: tick exits 0, report quarantined (seen), streak cleared, maintainer escalated" \
  || bad "quarantine wrong (rc3=$rc3 seen=$seen_post fc_gone=$fc_gone mm:$mm_q0→$mm_q1)"
# a subsequent tick is a quiet no-op (the wedged report is now seen → never re-run)
hbq=$(git ls-remote "$BARE" "refs/heads/$BRANCH" | awk '{print $1}')
rc4=0; env GARDEN_FOLLOWUP_HANDLER=/bin/false GARDEN_FOLLOWUP_MAX_RETRIES=3 "$JOBS/follow-up.sh" >/dev/null 2>&1 || rc4=$?
haq=$(git ls-remote "$BARE" "refs/heads/$BRANCH" | awk '{print $1}')
{ [ "$rc4" -eq 0 ] && [ "$hbq" = "$haq" ]; } \
  && ok "post-quarantine tick is a quiet no-op (wedged report no longer re-run)" \
  || bad "post-quarantine not quiet (rc4=$rc4 commit $hbq→$haq)"
# a CHANGED pending set resets the streak: a failure on set {a}, then a NEW
# report makes the set {a,b} so the next failure restarts the streak at 1.
export GARDEN_STATE="$TR/state-fur" GARDEN=furhost
FC_FUR="$GARDEN_STATE/follow-up/fail-count"
push_change "jobs/tada/fur-prime.md" "$(printf '# prime\n## Follow-ups\n- None\n')" "seed prime tada (cold start, r)"
env GARDEN_FOLLOWUP_HANDLER=/bin/true "$JOBS/follow-up.sh" >/dev/null 2>&1
push_change "jobs/tada/fur-a.md" "$(printf '# a\n## Follow-ups (escalated to liaison)\n- task a\n')" "seed report a"
env GARDEN_FOLLOWUP_HANDLER=/bin/false GARDEN_FOLLOWUP_MAX_RETRIES=5 "$JOBS/follow-up.sh" >/dev/null 2>&1 || true
cA=$(awk '{print $1}' "$FC_FUR" 2>/dev/null || echo NONE)
push_change "jobs/tada/fur-b.md" "$(printf '# b\n## Follow-ups (escalated to liaison)\n- task b\n')" "seed report b"
env GARDEN_FOLLOWUP_HANDLER=/bin/false GARDEN_FOLLOWUP_MAX_RETRIES=5 "$JOBS/follow-up.sh" >/dev/null 2>&1 || true
cB=$(awk '{print $1}' "$FC_FUR" 2>/dev/null || echo NONE)
{ [ "$cA" = 1 ] && [ "$cB" = 1 ]; } \
  && ok "changed pending set resets the failure streak (1 then 1, not 2)" \
  || bad "streak reset wrong (cA=$cA cB=$cB)"

# ============================================================================
hr; echo "SUBTEST 13d — FOLLOW-UP: an OUTAGE must not spend the quarantine budget"; hr
# Quarantine DISCARDS work, so only a failure ATTRIBUTABLE to the digest may be
# charged to the retry budget. The 2026-07-28 storm failed four consecutive ticks
# (one short of the ceiling) for a reason that had nothing to do with the pending
# reports. Assert each not-attributable cause leaves the streak UNCHANGED, the
# marker un-advanced, and the tick exiting EX_TEMPFAIL (which self-heal-run.sh
# normalizes to clean) — while a genuinely attributable failure still counts.
export GARDEN_STATE="$TR/state-fut" GARDEN=futhost
SEEN_FUT="$GARDEN_STATE/follow-up/seen"; FC_FUT="$GARDEN_STATE/follow-up/fail-count"
TS_FUT="$GARDEN_STATE/follow-up/transient"
push_change "jobs/tada/fut-prime.md" "$(printf '# prime\n## Follow-ups\n- None\n')" "seed prime tada (cold start, t)"
env GARDEN_FOLLOWUP_HANDLER=/bin/true "$JOBS/follow-up.sh" >/dev/null 2>&1
push_change "jobs/tada/fut-wedge.md" "$(printf '# wedge\n## Follow-ups (escalated to liaison)\n- do a thing\n')" "seed outage-tick report"
# one ATTRIBUTABLE failure first (bare rc=1, no output, no storm) → streak 1
env GARDEN_FOLLOWUP_HANDLER=/bin/false GARDEN_FOLLOWUP_MAX_RETRIES=3 "$JOBS/follow-up.sh" >/dev/null 2>&1 || true
cT0=$(awk '{print $1}' "$FC_FUT" 2>/dev/null || echo NONE)
# (i) the handler SIGNALS transient by exit code (die_transient's EX_TEMPFAIL)
rcT1=0
env GARDEN_FOLLOWUP_HANDLER="$HERE/follow-up-outage-stub.sh" GARDEN_FOLLOWUP_MAX_RETRIES=3 \
    "$JOBS/follow-up.sh" >/dev/null 2>&1 || rcT1=$?
cT1=$(awk '{print $1}' "$FC_FUT" 2>/dev/null || echo NONE)
# (ii) an rc=1 handler whose OUTPUT carries a transient claude signature
rcT2=0
env GARDEN_FOLLOWUP_HANDLER="$HERE/follow-up-outage-stub.sh" GARDEN_FOLLOWUP_MAX_RETRIES=3 \
    STUB_FOLLOWUP_RC=1 STUB_FOLLOWUP_OUT="API error: Overloaded (529)" \
    "$JOBS/follow-up.sh" >/dev/null 2>&1 || rcT2=$?
cT2=$(awk '{print $1}' "$FC_FUT" 2>/dev/null || echo NONE)
# (iii) a bare rc=1 handler while the FLEET BRAKE is engaged (host-wide storm)
BRAKE_FUT="$TR/fut-brake"; : > "$BRAKE_FUT"
for _i in $(seq 1 12); do date +%s >> "$BRAKE_FUT"; done
rcT3=0
env GARDEN_FOLLOWUP_HANDLER=/bin/false GARDEN_FOLLOWUP_MAX_RETRIES=3 \
    GARDEN_FLEET_BRAKE_LEDGER="$BRAKE_FUT" "$JOBS/follow-up.sh" >/dev/null 2>&1 || rcT3=$?
cT3=$(awk '{print $1}' "$FC_FUT" 2>/dev/null || echo NONE)
seenT=0; grep -qxF "jobs/tada/fut-wedge.md" "$SEEN_FUT" 2>/dev/null && seenT=1
{ [ "$cT0" = 1 ] && [ "$cT1" = 1 ] && [ "$cT2" = 1 ] && [ "$cT3" = 1 ] && [ "$seenT" -eq 0 ]; } \
  && ok "not-attributable ticks (rc signal / transient signature / fleet brake) leave the streak at 1, nothing quarantined" \
  || bad "outage spent the budget (streak $cT0→$cT1→$cT2→$cT3, seen=$seenT)"
{ [ "$rcT1" -eq "${GARDEN_TRANSIENT_RC:-75}" ] && [ "$rcT2" -eq 75 ] && [ "$rcT3" -eq 75 ]; } \
  && ok "an uncounted tick exits EX_TEMPFAIL (self-heal-run normalizes it to clean)" \
  || bad "uncounted tick rc wrong (rc1=$rcT1 rc2=$rcT2 rc3=$rcT3 — want 75)"
# the budget is still live for a genuinely attributable failure: 1 → 2
env GARDEN_FOLLOWUP_HANDLER=/bin/false GARDEN_FOLLOWUP_MAX_RETRIES=3 "$JOBS/follow-up.sh" >/dev/null 2>&1 || true
cT4=$(awk '{print $1}' "$FC_FUT" 2>/dev/null || echo NONE)
ts_gone=0; [ -f "$TS_FUT" ] || ts_gone=1
{ [ "$cT4" = 2 ] && [ "$ts_gone" -eq 1 ]; } \
  && ok "an attributable failure still counts (1→2) and clears the uncounted-stretch marker" \
  || bad "attributable failure not counted (cT4=$cT4 stretch-marker-cleared=$ts_gone)"
# UNCOUNTED IS NOT UNBOUNDED: backdate the stretch past the wall-clock bound and
# assert ONE maintainer notice, no quarantine, and no repeat notice.
sha_fut="$(printf '%s\n' "jobs/tada/fut-wedge.md" | git hash-object --stdin)"
printf '%s %s 0\n' "$(( $(date +%s) - 90000 ))" "$sha_fut" > "$TS_FUT"
mm_t0=$(git clone -q --single-branch --branch "$BRANCH" "$BARE" "$TR/futv0" && \
  ls -1 "$TR/futv0/inbox/maintainer/unread" | grep -vxc '.gitkeep' || true); rm -rf "$TR/futv0"
env GARDEN_FOLLOWUP_HANDLER="$HERE/follow-up-outage-stub.sh" GARDEN_FOLLOWUP_MAX_RETRIES=3 \
    "$JOBS/follow-up.sh" >/dev/null 2>&1 || true
mm_t1=$(git clone -q --single-branch --branch "$BRANCH" "$BARE" "$TR/futv1" && \
  ls -1 "$TR/futv1/inbox/maintainer/unread" | grep -vxc '.gitkeep' || true); rm -rf "$TR/futv1"
env GARDEN_FOLLOWUP_HANDLER="$HERE/follow-up-outage-stub.sh" GARDEN_FOLLOWUP_MAX_RETRIES=3 \
    "$JOBS/follow-up.sh" >/dev/null 2>&1 || true
mm_t2=$(git clone -q --single-branch --branch "$BRANCH" "$BARE" "$TR/futv2" && \
  ls -1 "$TR/futv2/inbox/maintainer/unread" | grep -vxc '.gitkeep' || true); rm -rf "$TR/futv2"
seenT2=0; grep -qxF "jobs/tada/fut-wedge.md" "$SEEN_FUT" 2>/dev/null && seenT2=1
{ [ "$mm_t1" -gt "$mm_t0" ] && [ "$mm_t2" -eq "$mm_t1" ] && [ "$seenT2" -eq 0 ]; } \
  && ok "a long uncounted stretch tells the maintainer ONCE and still does not quarantine" \
  || bad "stretch bound wrong (mm:$mm_t0→$mm_t1→$mm_t2 seen=$seenT2 — want one notice, no quarantine)"

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

export GARDEN_STATE="$TR/state-fm" GARDEN=fmhost
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
  # Pin the active-job target to 1 so this subtest exercises the single-slot
  # (pump-only-when-fully-idle) configuration: busy-board cost gate, settle
  # window, and anti-flap. The fill-to-target batch behavior is covered by
  # SUBTEST 14d with the default target of 3.
  : > "$FCALLS"
  env JOURNAL_REMOTE="$FBARE" GARDEN_FOREMAN_HANDLER="$HERE/foreman-stub.sh" \
      GARDEN_FOREMAN_STUB_CALLS="$FCALLS" GARDEN_FOREMAN_NOW="$1" GARDEN_FOREMAN_IDLE_SETTLE=240 \
      GARDEN_FOREMAN_ACTIVE_TARGET=1 \
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
hr; echo "SUBTEST 14a — FOREMAN GENERATED-STEP PACING: top up to a target of 3 via the handler (deprecated GARDEN_FOREMAN_WIP alias)"; hr
# With a target of 3 and NO deferred plan jobs queued, the foreman generates one
# new step per settle window via the handler, climbing 0→1→2→3, then goes quiet
# once at capacity. This proves the handler (claude -p) path stays paced at ONE
# per tick even when several slots are open. Uses a counting stub so successive
# pumps propose DISTINCT bases (anti-flap only holds on a repeat of the last
# base). Sets the target via GARDEN_FOREMAN_WIP so this also covers the deprecated
# alias resolving to GARDEN_FOREMAN_ACTIVE_TARGET. Fresh GARDEN_STATE so the settle
# clock is clean.
fboard @CLEAR
FWSTATE="$TR/state-fm-wip"; rm -rf "$FWSTATE"
FWCOUNTER="$TR/fm-wip-counter"; rm -f "$FWCOUNTER"
run_fm_wip() {  # run_fm_wip <now-epoch>
  : > "$FCALLS"
  env GARDEN_STATE="$FWSTATE" JOURNAL_REMOTE="$FBARE" \
      GARDEN_FOREMAN_HANDLER="$HERE/foreman-stub-counter.sh" GARDEN_FOREMAN_STUB_CALLS="$FCALLS" \
      GARDEN_FOREMAN_STUB_COUNTER="$FWCOUNTER" GARDEN_FOREMAN_WIP=3 \
      GARDEN_FOREMAN_NOW="$1" GARDEN_FOREMAN_IDLE_SETTLE=240 \
      "$JOBS/foreman.sh" >/dev/null 2>&1
}
# below target (0<3): first observation starts the clock, no pump.
run_fm_wip 3000
{ [ ! -s "$FCALLS" ] && [ "$(fcount jobs/todo)" -eq 0 ]; } \
  && ok "WIP: first below-target tick starts the clock, no pump" || bad "WIP first-seen pumped early"
# three successive settle windows top the board up 1→2→3.
run_fm_wip 3300; run_fm_wip 3600; run_fm_wip 3900
[ "$(fcount jobs/todo)" -eq 3 ] \
  && ok "WIP: board topped up to the target of 3 (one step per settle window)" \
  || bad "WIP top-up wrong (todo=$(fcount jobs/todo))"
FWV="$TR/fmwv"; rm -rf "$FWV"; git clone -q --single-branch --branch "$BRANCH" "$FBARE" "$FWV"
{ [ -f "$FWV/jobs/todo/foreman-step-1.md" ] && [ -f "$FWV/jobs/todo/foreman-step-2.md" ] && [ -f "$FWV/jobs/todo/foreman-step-3.md" ]; } \
  && ok "WIP: the three jobs are DISTINCT milestone steps (no anti-flap on advancing bases)" \
  || bad "WIP steps not distinct ($(ls -1 "$FWV/jobs/todo" 2>/dev/null | tr '\n' ' '))"
rm -rf "$FWV"
# at capacity (3>=3): the pump goes quiet — no handler call, nothing posted.
run_fm_wip 4200
{ [ ! -s "$FCALLS" ] && [ "$(fcount jobs/todo)" -eq 3 ]; } \
  && ok "WIP: at capacity the foreman is silent (no claude call, no over-pump)" \
  || bad "WIP over-pumped past target (calls=$(wc -l <"$FCALLS") todo=$(fcount jobs/todo))"
fboard @CLEAR

# ============================================================================
hr; echo "SUBTEST 14b — FOREMAN TOKEN QUOTA: deterministic weekly back-off (session logs)"; hr
# The foreman gates BOTH pump paths on a deterministic, no-LLM weekly token meter
# sourced from Claude Code's own session logs (~/.claude/projects/**/*.jsonl). Each
# case points GARDEN_CCUSAGE_LOGDIR at a synthetic JSONL fixture (NOT the real
# ~/.claude) and uses a FRESH GARDEN_STATE so each starts with a clean settle clock.
export GARDEN=fmqhost
# Use a small rolling window for these cases so synthetic small-epoch timestamps
# fall inside/outside it predictably; restored to the default after the block.
export GARDEN_TOKEN_WINDOW_SECS=1000
# fxlog <logdir> <msg-id> <epoch> <input> <output> <cache_creation> [<cache_read>]
# — append one synthetic Claude Code assistant-turn line to <logdir>'s project tree.
fxlog() {
  local d="$1/proj" id="$2" ep="$3" in_t="$4" out_t="$5" cc="$6" cr="${7:-0}" iso
  mkdir -p "$d"; iso="$(date -u -d "@$ep" +%Y-%m-%dT%H:%M:%S.000Z)"
  printf '{"type":"assistant","timestamp":"%s","message":{"id":"%s","usage":{"input_tokens":%s,"output_tokens":%s,"cache_creation_input_tokens":%s,"cache_read_input_tokens":%s}}}\n' \
    "$iso" "$id" "$in_t" "$out_t" "$cc" "$cr" >> "$d/${id}.jsonl"
}
run_fmq() {  # run_fmq <now-epoch> <weekly-quota> <state-dir> [<ccusage-logdir>]
  : > "$FCALLS"
  env GARDEN_STATE="$3" JOURNAL_REMOTE="$FBARE" \
      GARDEN_FOREMAN_HANDLER="$HERE/foreman-stub.sh" GARDEN_FOREMAN_STUB_CALLS="$FCALLS" \
      GARDEN_FOREMAN_NOW="$1" GARDEN_USAGE_NOW="$1" GARDEN_FOREMAN_IDLE_SETTLE=240 \
      GARDEN_TOKEN_WEEKLY_QUOTA="$2" GARDEN_TOKEN_WINDOW_SECS=1000 \
      GARDEN_CCUSAGE_LOGDIR="${4:-$TR/fmq-no-such-logdir}" \
      "$JOBS/foreman.sh" >/dev/null 2>&1
}
# (1) UNDER quota → pumps as today. quota=1000, high-water=850; session-log total
# is 500 (one in-window turn 300+100+100; an OLD turn worth 9999 is out of window
# and must be ignored; cache_read is excluded from billable).
SA="$TR/state-fmq-under"; LA="$TR/log-fmq-under"; rm -rf "$LA"
fboard @CLEAR
fxlog "$LA" u1 5290 300 100 100 88888   # in-window: billable 500 (cache_read excluded)
fxlog "$LA" u0 100  9999 0 0 0          # far out of the 1000s window → ignored
run_fmq 5000 1000 "$SA" "$LA"   # first idle observation: start the clock
run_fmq 5300 1000 "$SA" "$LA"   # 300s ≥ 240 settle, under high-water → pump
{ [ -s "$FCALLS" ] && [ "$(fcount jobs/todo)" -eq 1 ]; } \
  && ok "under quota: foreman pumps as normal (handler ran, one job posted)" \
  || bad "under-quota pump (calls=$(wc -l <"$FCALLS") todo=$(fcount jobs/todo))"

# (2) AT/OVER quota → promotes nothing, runs NO handler; ONE throttled note.
# session-log total is 900 (500 + 400). A DUPLICATE of the 500 turn (same message
# id, as a streamed content block emits) must NOT inflate the sum to 1400.
SB="$TR/state-fmq-over"; LB="$TR/log-fmq-over"; rm -rf "$LB"
fboard @CLEAR
fxlog "$LB" o1 6290 500 0 0 0   # in-window: 500
fxlog "$LB" o1 6290 500 0 0 0   # DUPLICATE message id → deduped, not double-counted
fxlog "$LB" o2 6291 400 0 0 0   # in-window: 400  → total 900 ≥ 850 high-water
run_fmq 6000 1000 "$SB" "$LB"   # first idle observation: start the clock
run_fmq 6300 1000 "$SB" "$LB"   # sustained idle, but over high-water → back off
M1="$(fcount inbox/maintainer/unread)"
{ [ ! -s "$FCALLS" ] && [ "$(fcount jobs/todo)" -eq 0 ] && [ "$M1" -ge 1 ]; } \
  && ok "over quota: no handler call, nothing posted, back-off note sent" \
  || bad "over-quota back-off (calls=$(wc -l <"$FCALLS") todo=$(fcount jobs/todo) maint=$M1)"
run_fmq 6600 1000 "$SB" "$LB"   # still over quota, still sustained → must NOT re-note
M2="$(fcount inbox/maintainer/unread)"
{ [ ! -s "$FCALLS" ] && [ "$M2" -eq "$M1" ]; } \
  && ok "over quota: back-off note throttled (no duplicate across ticks)" \
  || bad "back-off note not throttled (M1=$M1 M2=$M2 calls=$(wc -l <"$FCALLS"))"

# (3) BROKEN/MISSING meter with a quota set → FAIL OPEN (pump, with warning).
# A non-existent log dir AND no fallback ledger makes the read fail (→ 'unknown').
SC="$TR/state-fmq-broken"
fboard @CLEAR
run_fmq 7000 1000 "$SC" "$TR/log-fmq-does-not-exist"   # first idle observation
run_fmq 7300 1000 "$SC" "$TR/log-fmq-does-not-exist"   # meter unreadable → fail open → pump
{ [ -s "$FCALLS" ] && [ "$(fcount jobs/todo)" -eq 1 ]; } \
  && ok "broken meter: fails open (handler ran, one job posted) despite quota set" \
  || bad "broken-meter fail-open (calls=$(wc -l <"$FCALLS") todo=$(fcount jobs/todo))"

# (4) LEDGER FALLBACK: the session-log dir is missing but the legacy ledger exists
# → the meter falls back to the ledger (total 500 under quota) and pumps.
SD="$TR/state-fmq-fallback"
fboard @CLEAR
mkdir -p "$SD/usage"; { printf '%s\t%s\n' 7290 500; printf '%s\t%s\n' 100 9999; } > "$SD/usage/ledger"
run_fmq 7000 1000 "$SD" "$TR/log-fmq-does-not-exist"   # first idle observation
run_fmq 7300 1000 "$SD" "$TR/log-fmq-does-not-exist"   # logdir missing → ledger fallback → under → pump
{ [ -s "$FCALLS" ] && [ "$(fcount jobs/todo)" -eq 1 ]; } \
  && ok "ledger fallback: missing session logs fall back to the legacy ledger (under quota → pump)" \
  || bad "ledger-fallback pump (calls=$(wc -l <"$FCALLS") todo=$(fcount jobs/todo))"
fboard @CLEAR
unset GARDEN_TOKEN_WINDOW_SECS

# ============================================================================
hr; echo "SUBTEST 14c — TOKEN METER (unit): session-log sum, dedup, window, fail-open"; hr
# Direct unit tests of meter_window_total over a synthetic session-log fixture.
export GARDEN=meterhost
MLOG="$TR/meter-unit-log"; rm -rf "$MLOG"
fxlog "$MLOG" a1 9500 100 10 5 70000   # in-window (cutoff 9000): billable 115
fxlog "$MLOG" a1 9500 100 10 5 70000   # duplicate id → deduped
fxlog "$MLOG" a2 9600 200 0 0 0        # in-window: 200  → in-window total 315
fxlog "$MLOG" a3 8000 999 0 0 0        # OLD (< cutoff 9000) → ignored
# a non-assistant line and a garbled line in the same file → skipped, not fatal
mkdir -p "$MLOG/proj"
printf '{"type":"user","timestamp":"1970-01-01T02:40:00.000Z","message":{}}\n' >> "$MLOG/proj/a2.jsonl"
printf 'this is not json {{{\n' >> "$MLOG/proj/a2.jsonl"
meter_unit() {  # meter_unit <logdir> <now> <window> [<count-cache-read>] [<ledger>]
  ( cd "$JOBS"
    GARDEN_STATE="$TR/state-meter-unit" GARDEN=meterhost \
    GARDEN_CCUSAGE_LOGDIR="$1" GARDEN_USAGE_NOW="$2" GARDEN_TOKEN_WINDOW_SECS="$3" \
    GARDEN_TOKEN_COUNT_CACHE_READ="${4:-0}" GARDEN_USAGE_LEDGER="${5:-$TR/meter-unit-no-ledger}" \
    bash -c 'set -uo pipefail; source ./common.sh; meter_window_total && echo "RC=$?" >&2' 2>/dev/null )
}
U1="$(meter_unit "$MLOG" 10000 1000)"
[ "$U1" = "315" ] && ok "session-log sum: in-window deduped billable total (expected 315)" \
  || bad "session-log sum wrong (got '$U1', expected 315)"
U2="$(meter_unit "$MLOG" 10000 1000 1)"
[ "$U2" = "70315" ] && ok "cache_read toggle: GARDEN_TOKEN_COUNT_CACHE_READ folds in cache_read (expected 70315)" \
  || bad "cache_read toggle wrong (got '$U2', expected 70315)"
# missing log dir, no ledger → meter_window_total returns non-zero (→ unknown/fail-open)
mrc=$( cd "$JOBS"
  GARDEN_STATE="$TR/state-meter-unit2" GARDEN=meterhost \
  GARDEN_CCUSAGE_LOGDIR="$TR/meter-unit-missing" GARDEN_USAGE_NOW=10000 \
  GARDEN_USAGE_LEDGER="$TR/meter-unit-missing-ledger" \
  bash -c 'set -uo pipefail; source ./common.sh; meter_window_total >/dev/null 2>&1; echo $?' )
[ "$mrc" = "1" ] && ok "fail-open: missing log dir + no ledger → meter_window_total returns non-zero (unknown)" \
  || bad "missing-source did not signal unknown (rc=$mrc)"
# quota status verdicts over the same fixture
ST_OK="$( cd "$JOBS"; GARDEN_STATE="$TR/sm3" GARDEN=meterhost GARDEN_CCUSAGE_LOGDIR="$MLOG" \
  GARDEN_USAGE_NOW=10000 GARDEN_TOKEN_WINDOW_SECS=1000 GARDEN_TOKEN_WEEKLY_QUOTA=1000 \
  GARDEN_USAGE_LEDGER="$TR/sm3-noledger" bash -c 'source ./common.sh; meter_quota_status' 2>/dev/null )"
[ "$ST_OK" = "ok" ] && ok "quota status: under high-water → ok" || bad "quota status ok wrong (got '$ST_OK')"
ST_BO="$( cd "$JOBS"; GARDEN_STATE="$TR/sm4" GARDEN=meterhost GARDEN_CCUSAGE_LOGDIR="$MLOG" \
  GARDEN_USAGE_NOW=10000 GARDEN_TOKEN_WINDOW_SECS=1000 GARDEN_TOKEN_WEEKLY_QUOTA=300 \
  GARDEN_USAGE_LEDGER="$TR/sm4-noledger" bash -c 'source ./common.sh; meter_quota_status' 2>/dev/null )"
[ "$ST_BO" = "backoff" ] && ok "quota status: at/over high-water (315 ≥ 0.85·300) → backoff" || bad "quota status backoff wrong (got '$ST_BO')"

# ============================================================================
hr; echo "SUBTEST 14d — FOREMAN FILL-TO-TARGET: batch-promote deferred plans up to GARDEN_FOREMAN_ACTIVE_TARGET=3, then stop"; hr
# The core of kriskowal/garden#… (2026-07-03): the foreman keeps ~3 jobs ACTIVELY
# progressing, not just refilling a fully-idle board. With a target of 3 and ONE
# job already in doin/, a sustained under-subscribed tick batch-promotes the top
# TWO deferred plan jobs (2 = target 3 − in-flight 1) in a SINGLE tick, by
# priority, and STOPS at the target. go-ahead and blocked plan jobs are never
# touched. Dedicated bare so the board is fully controllable. The target is PINNED
# to 3 here (GARDEN_FOREMAN_ACTIVE_TARGET=3) so the batch arithmetic under test is
# fixed: the SHIPPED default is a separate, maintainer-tunable policy number
# (raised 3 → 5 on kriskowal's instruction, 2026-07-03, commit 90ec626131) and is
# asserted on its own below — so re-tuning it never re-reds this fill logic.
DFBARE="$TR/deferfill.git"; git init -q --bare "$DFBARE"
DFSEED="$TR/deferfill-seed"; git init -q "$DFSEED"; git -C "$DFSEED" checkout -q -b "$BRANCH"
( cd "$DFSEED"
  mkdir -p jobs/todo jobs/doin jobs/tada jobs/plan inbox/maintainer/unread inbox/maintainer/read entries
  for d in jobs/todo jobs/doin jobs/tada jobs/plan inbox/maintainer/unread inbox/maintainer/read entries; do touch "$d/.gitkeep"; done
  # One job already in flight (doin/): the board is under-subscribed by 2, not idle.
  printf '# already-running\nan in-flight job.\n' > jobs/doin/already-running.md )
git -C "$DFSEED" add -A; git -C "$DFSEED" "${git_id[@]}" commit -q -m "seed defer-fill board (1 in doin)"
git -C "$DFSEED" remote add origin "$DFBARE"; git -C "$DFSEED" push -q -u origin "$BRANCH"

export GARDEN_STATE="$TR/state-deferfill" GARDEN=dffill
DFCALLS="$TR/deferfill-calls"; : > "$DFCALLS"
dfcount() { local v n; v="$(mktemp -d "$TR/dfv.XXXXXX")"; git clone -q --single-branch --branch "$BRANCH" "$DFBARE" "$v" 2>/dev/null; n=$(ls -1 "$v/$1" 2>/dev/null | grep -vxc '.gitkeep' || true); rm -rf "$v"; printf '%s' "$n"; }
dfhas()   { local v r; v="$(mktemp -d "$TR/dfh.XXXXXX")"; git clone -q --single-branch --branch "$BRANCH" "$DFBARE" "$v" 2>/dev/null; [ -e "$v/$1" ]; r=$?; rm -rf "$v"; return $r; }
run_dffm() {  # run_dffm <now-epoch>  — target pinned to 3 (see the header)
  : > "$DFCALLS"
  env JOURNAL_REMOTE="$DFBARE" GARDEN_FOREMAN_HANDLER="$HERE/foreman-stub.sh" \
      GARDEN_FOREMAN_STUB_CALLS="$DFCALLS" GARDEN_FOREMAN_NOW="$1" GARDEN_FOREMAN_IDLE_SETTLE=240 \
      GARDEN_FOREMAN_ACTIVE_TARGET=3 \
      "$JOBS/foreman.sh" >/dev/null 2>&1
}
# The shipped default, asserted in ONE place: foreman.sh's own parameter default.
grep -qE '^: "\$\{GARDEN_FOREMAN_ACTIVE_TARGET:=\$\{GARDEN_FOREMAN_WIP:-5\}\}"' "$JOBS/foreman.sh" \
  && ok "foreman ships active-job target default 5 (WIP alias preserved)" \
  || bad "foreman active-job target default changed: $(grep -m1 'GARDEN_FOREMAN_ACTIVE_TARGET:=' "$JOBS/foreman.sh")"
# Four deferred plans (distinct priorities → deterministic promotion order), one
# go-ahead, one blocked. Top two by priority are urgent then high.
echo 'urgent body' | env JOURNAL_REMOTE="$DFBARE" "$JOBS/post-plan.sh" --deferred --priority urgent df-urgent >/dev/null 2>&1
echo 'high body'   | env JOURNAL_REMOTE="$DFBARE" "$JOBS/post-plan.sh" --deferred --priority high   df-high   >/dev/null 2>&1
echo 'normal body' | env JOURNAL_REMOTE="$DFBARE" "$JOBS/post-plan.sh" --deferred --priority normal df-normal >/dev/null 2>&1
echo 'low body'    | env JOURNAL_REMOTE="$DFBARE" "$JOBS/post-plan.sh" --deferred --priority low    df-low    >/dev/null 2>&1
echo 'authz body'  | env JOURNAL_REMOTE="$DFBARE" "$JOBS/post-plan.sh" --go-ahead                    df-authz  >/dev/null 2>&1
echo 'blocked body'| env JOURNAL_REMOTE="$DFBARE" "$JOBS/post-plan.sh" --blocked --blocked-on some-pr df-blocked >/dev/null 2>&1

# below target (in-flight 1 < 3): first observation starts the settle clock, no pump.
run_dffm 5000
{ [ ! -s "$DFCALLS" ] && [ "$(dfcount jobs/todo)" -eq 0 ] && [ "$(dfcount jobs/doin)" -eq 1 ]; } \
  && ok "fill-to-target: first below-target tick starts the clock, no pump" \
  || bad "fill first-seen pumped early (calls=$(wc -l <"$DFCALLS") todo=$(dfcount jobs/todo))"
# sustained past the settle window: batch-promote 2 (to reach target 3), NO handler call.
run_dffm 5300
{ [ ! -s "$DFCALLS" ] && [ "$(dfcount jobs/todo)" -eq 2 ] && [ "$(dfcount jobs/doin)" -eq 1 ]; } \
  && ok "fill-to-target: batch-promoted exactly 2 deferred plans in one tick (in-flight 1 → target 3), no claude call" \
  || bad "fill batch wrong (calls=$(wc -l <"$DFCALLS") todo=$(dfcount jobs/todo) doin=$(dfcount jobs/doin))"
{ dfhas jobs/todo/df-urgent.md && dfhas jobs/todo/df-high.md; } \
  && ok "fill-to-target: the two promoted are the TOP-priority deferred jobs (urgent, high)" \
  || bad "fill promoted the wrong jobs (todo=$(dfcount jobs/todo))"
{ dfhas jobs/plan/df-normal.md && dfhas jobs/plan/df-low.md; } \
  && ok "fill-to-target: lower-priority deferred jobs (normal, low) stay parked below the target" \
  || bad "fill over-promoted lower-priority deferred (normal parked=$(dfhas jobs/plan/df-normal.md && echo y||echo n) low parked=$(dfhas jobs/plan/df-low.md && echo y||echo n))"
{ dfhas jobs/plan/df-authz.md && dfhas jobs/plan/df-blocked.md; } \
  && ok "fill-to-target: go-ahead and blocked plan jobs are NEVER auto-promoted" \
  || bad "fill touched a go-ahead/blocked job (authz parked=$(dfhas jobs/plan/df-authz.md && echo y||echo n) blocked parked=$(dfhas jobs/plan/df-blocked.md && echo y||echo n))"
# now AT the target (in-flight 3): a further sustained tick promotes 0, no handler call.
run_dffm 5600
{ [ ! -s "$DFCALLS" ] && [ "$(dfcount jobs/todo)" -eq 2 ] && [ "$(dfcount jobs/doin)" -eq 1 ]; } \
  && ok "fill-to-target: at the target the foreman promotes 0 and runs no handler (no over-subscription)" \
  || bad "fill over-promoted past target (calls=$(wc -l <"$DFCALLS") todo=$(dfcount jobs/todo))"
# RESTORE the throwaway remote (not `unset`): the PROXY subtests below call
# message-user.sh / proxy.sh directly with no per-invocation JOURNAL_REMOTE, so an
# unset here made them derive the REAL kriskowal/garden journal from $GARDEN_ROOT
# and push synthetic pxhost/ferry traffic onto production journal2 (incident
# 2026-07-11). Re-export the shared throwaway $BARE so every path routes to it.
export JOURNAL_REMOTE="$BARE"

# ============================================================================
hr; echo "SUBTEST 15 — PROXY: stand in for the absent maintainer on gating questions"; hr
export GARDEN_STATE="$TR/state-proxy" GARDEN=pxhost
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

# watchdog auto-clear fixture: two watchdog-class anomaly reports from ONE monitor
# + one from a DISTINCT monitor (none carry reply_to — never gating), plus a
# gardener completion report (no reply_to) that MUST be left for the maintainer.
wd1="$(printf 'from_host: pxhost\nfrom: watchdog:comment-watcher/kriskowal-garden\nsent_at: 2026-06-27T00:00:00Z\n---\nself-test failed to observe a known comment.')"
wd2="$(printf 'from_host: pxhost\nfrom: watchdog:comment-watcher/kriskowal-garden\nsent_at: 2026-06-27T00:01:00Z\n---\nanother comment-watcher anomaly.')"
wd3="$(printf 'from_host: pxhost\nfrom: watchdog:self-heal-claude\nsent_at: 2026-06-27T00:02:00Z\n---\nself-heal could not classify a failure.')"
grp="$(printf 'from_host: pxhost\nfrom: gardener:px-rep\nsent_at: 2026-06-27T00:03:00Z\n---\nJob complete; here is my report.')"
push_change "inbox/maintainer/unread/px-wd-1.md" "$wd1" "seed watchdog message (comment-watcher) 1"
push_change "inbox/maintainer/unread/px-wd-2.md" "$wd2" "seed watchdog message (comment-watcher) 2"
push_change "inbox/maintainer/unread/px-wd-3.md" "$wd3" "seed watchdog message (self-heal-claude)"
push_change "inbox/maintainer/unread/px-rep.md"  "$grp" "seed gardener completion report (non-watchdog)"

# (0) WATCHDOG PRE-PASS: deterministic, runs EVERY tick regardless of grace and
# WITHOUT the handler. Even inside the grace window the watchdog messages are
# archived, the gardener report is left unread, and a deduplicated tally is logged.
WDLOG="$TR/proxy-wd.log"
env GARDEN_PROXY_GRACE=3600 GARDEN_PROXY_HANDLER="$HERE/proxy-stub.sh" \
    GARDEN_PROXY_STUB_CALLS="$PXCALLS" "$JOBS/proxy.sh" >/dev/null 2>"$WDLOG"
[ ! -s "$PXCALLS" ] && ok "watchdog pre-pass: no handler / claude -p call (deterministic)" || bad "watchdog pre-pass invoked the handler ($(grep -c . "$PXCALLS") calls)"
PW="$TR/pxw"; rm -rf "$PW"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$PW"
wd_un=$(ls -1 "$PW/inbox/maintainer/unread" 2>/dev/null | grep -c '^px-wd-' || true)
wd_rd=$(ls -1 "$PW/inbox/maintainer/read"   2>/dev/null | grep -c '^px-wd-' || true)
{ [ "$wd_un" -eq 0 ] && [ "$wd_rd" -eq 3 ]; } && ok "watchdog:* messages archived unread→read (3 cleared)" || bad "watchdog archive wrong (unread=$wd_un read=$wd_rd)"
rep_un=$(ls -1 "$PW/inbox/maintainer/unread" 2>/dev/null | grep -c '^px-rep' || true)
[ "$rep_un" -eq 1 ] && ok "gardener completion report left UNREAD for the maintainer (not watchdog)" || bad "gardener report not left unread (unread=$rep_un)"
# Tally is deduplicated per sender: our two comment-watcher reports collapse to
# ×2 and the self-heal report to ×1. The total count is NOT hardcoded — the
# shared test journal can carry genuine watchdog noise from earlier subtests, and
# clearing that too is the feature working, not a failure.
{ grep -qE 'cleared [0-9]+ watchdog messages' "$WDLOG" \
  && grep -q 'comment-watcher/kriskowal-garden×2' "$WDLOG" \
  && grep -q 'self-heal-claude×1' "$WDLOG"; } \
  && ok "deduplicated tally logged (auditable suppression)" || bad "tally line missing/wrong: $(grep -i 'watchdog' "$WDLOG" | tr '\n' '|')"
rm -rf "$PW"

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
hr; echo "SUBTEST 15b — PROXY PR-COMMENT AUTO-CLEAR: acknowledge PR messages, keep live gating + non-PR"; hr
# Standing deterministic pre-pass (maintainer directive 2026-07-11): archive every
# unread NON-GATING maintainer message that references a pull request; preserve live
# gating questions (even PR ones) and all non-PR infra/progress traffic.
#
# THREE eligible (non-gating, real PR reference): a PR URL, a "PR #n", and a
# shepherd-*-pr<n>-* sender. ONE live gating question that names a PR (preserve). FIVE
# non-PR senders (preserve): self-heal, finbot-progress, garden#33-only, README #2.
pc_url="$(printf 'from_host: pxhost\nfrom: gardener:shipit\nsent_at: 2026-07-11T00:00:00Z\n---\nCompleted work on https://github.com/kriskowal/garden/pull/42 — merged.')"
pc_prn="$(printf 'from_host: pxhost\nfrom: gardener:notice\nsent_at: 2026-07-11T00:01:00Z\n---\nHeads up: PR #5 is ready for your review.')"
pc_shep="$(printf 'from_host: pxhost\nfrom: gardener:shepherd-foo-pr58-bar\nsent_at: 2026-07-11T00:02:00Z\n---\nShepherd run finished; all checks green.')"
pc_sh="$(printf 'from_host: pxhost\nfrom: gardener:self-heal-fix-xyz\nsent_at: 2026-07-11T00:03:00Z\n---\nSelf-heal applied a fix for the wedged handler.')"
pc_fin="$(printf 'from_host: pxhost\nfrom: gardener:finbot-progress-7\nsent_at: 2026-07-11T00:04:00Z\n---\nfinbot progress: 3 of 10 steps done.')"
pc_gh="$(printf 'from_host: pxhost\nfrom: gardener:notice2\nsent_at: 2026-07-11T00:05:00Z\n---\nReminder about garden#33 — still open.')"
pc_rm="$(printf 'from_host: pxhost\nfrom: gardener:notice3\nsent_at: 2026-07-11T00:06:00Z\n---\nSee README item #2 for the checklist.')"
push_change "inbox/maintainer/unread/px-pc-url.md"  "$pc_url"  "seed PR-URL completion report"
push_change "inbox/maintainer/unread/px-pc-prn.md"  "$pc_prn"  "seed 'PR #5' notice"
push_change "inbox/maintainer/unread/px-pc-shep.md" "$pc_shep" "seed shepherd-*-pr58-* report"
push_change "inbox/maintainer/unread/px-pc-sh.md"   "$pc_sh"   "seed self-heal (non-PR)"
push_change "inbox/maintainer/unread/px-pc-fin.md"  "$pc_fin"  "seed finbot-progress (non-PR)"
push_change "inbox/maintainer/unread/px-pc-gh.md"   "$pc_gh"   "seed garden#33-only (non-PR)"
push_change "inbox/maintainer/unread/px-pc-rm.md"   "$pc_rm"   "seed README #2 (non-PR)"
# a LIVE gating question that references a PR — must be PRESERVED for the handler
push_change "inbox/px-live-pr/unread/.gitkeep" "" "live doer px-live-pr"
# full PR URL (a fully-qualified ref check-issue-refs accepts, and a strong PR signal)
qpr="$(mktemp)"; echo "Should I merge https://github.com/kriskowal/garden/pull/77 now, or wait for review?" > "$qpr"
"$JOBS/message-user.sh" px-live-pr "$qpr" >/dev/null

PCLOG="$TR/proxy-pc.log"; : > "$PXCALLS"
env GARDEN_PROXY_GRACE=3600 GARDEN_PROXY_HANDLER="$HERE/proxy-stub.sh" \
    GARDEN_PROXY_STUB_CALLS="$PXCALLS" "$JOBS/proxy.sh" >/dev/null 2>"$PCLOG"
[ ! -s "$PXCALLS" ] && ok "PR-comment pre-pass: no handler / claude -p call (deterministic)" || bad "PR-comment pre-pass invoked the handler ($(grep -c . "$PXCALLS") calls)"
PC="$TR/pxc"; rm -rf "$PC"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$PC"
# (a) the three eligible PR messages are archived unread→read
pc_arch=0
for m in px-pc-url px-pc-prn px-pc-shep; do
  { [ ! -e "$PC/inbox/maintainer/unread/$m.md" ] && [ -e "$PC/inbox/maintainer/read/$m.md" ]; } && pc_arch=$((pc_arch+1))
done
[ "$pc_arch" -eq 3 ] && ok "PR-URL + 'PR #n' + shepherd-*-pr<n>-* messages archived (3)" || bad "PR messages not all archived (archived=$pc_arch)"
# (b) the live gating question that names a PR is PRESERVED (unread)
pcl_un=$(grep -rl '^reply_to: px-live-pr$' "$PC/inbox/maintainer/unread" 2>/dev/null | grep -c . || true)
[ "$pcl_un" -ge 1 ] && ok "live gating question referencing a PR PRESERVED (guardrail 1)" || bad "live PR gating question wrongly cleared (unread=$pcl_un)"
# (c) non-PR infra/progress senders + garden#33 + README #2 are PRESERVED (unread)
pc_keep=0
for m in px-pc-sh px-pc-fin px-pc-gh px-pc-rm; do
  [ -e "$PC/inbox/maintainer/unread/$m.md" ] && pc_keep=$((pc_keep+1))
done
[ "$pc_keep" -eq 4 ] && ok "self-heal + finbot-progress + garden#33 + README #2 PRESERVED (guardrail 2)" || bad "non-PR message wrongly cleared (kept=$pc_keep)"
# (d) a deduplicated tally line is logged (auditable) and nothing re-posted
{ grep -qE 'cleared [0-9]+ PR-comment messages' "$PCLOG" \
  && grep -q 'kriskowal/garden#42×1' "$PCLOG" \
  && grep -q 'pr5×1' "$PCLOG" \
  && grep -q 'pr58×1' "$PCLOG"; } \
  && ok "deduplicated PR-comment tally logged (auditable suppression)" || bad "tally line missing/wrong: $(grep -i 'pr-comment' "$PCLOG" | tr '\n' '|')"
# nothing re-posted to the maintainer about these clears
pc_repost=$(grep -rl 'from: proxy' "$PC/inbox/maintainer/unread" 2>/dev/null | xargs -r grep -l 'px-pc-' 2>/dev/null | grep -c . || true)
[ "$pc_repost" -eq 0 ] && ok "no re-post to the maintainer about the auto-cleared PR messages" || bad "proxy re-posted about cleared PR messages ($pc_repost)"
rm -rf "$PC"; rm -f "$qpr"

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

export GARDEN_STATE="$TR/state-dm" GARDEN=dmhost
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
  # -P SCRIPTDIR resolves the wrapper's `# shellcheck source=../comment-provenance.sh`
  # directive relative to the WRAPPER, not the caller's cwd. Without it shellcheck
  # 0.9.0 reads the path relative to cwd, so this check passed from scripts/jobs/bin
  # and failed (SC1091) from the repo root -- a cwd-dependent red suite, not a
  # wrapper defect.
  shellcheck -x -P SCRIPTDIR "$GHWRAP_DIR/gh" >/dev/null 2>&1 && ok "wrapper: shellcheck clean" || bad "wrapper: shellcheck reported issues"
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
export GARDEN_STATE="$TR/state-push" GARDEN=pushhost
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
export GARDEN_STATE="$TR/state-push2" GARDEN=pushhost2
sl_rc=$(
  cd "$JOBS"
  JOURNAL_REMOTE="$PBARE" JOURNAL_BRANCH="$BRANCH" GARDEN_STATE="$TR/state-push2" \
  GARDEN=pushhost2 bash -c '
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
export GARDEN_STATE="$TR/state-push3" GARDEN=pushhost3
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
hr; echo "SUBTEST 19 — REAPER: requeue lands under contention, claim-strip safe, doom"; hr
# Dedicated bare so the reaped/doomed counts are fully controllable.
RBARE="$TR/reaper.git"; git init -q --bare "$RBARE"
RSEED="$TR/reaper-seed"; git init -q "$RSEED"; git -C "$RSEED" checkout -q -b "$BRANCH"
( cd "$RSEED"
  mkdir -p jobs/todo jobs/doin jobs/tada work inbox/maintainer/unread inbox/maintainer/read
  for d in jobs/todo jobs/doin jobs/tada work inbox/maintainer/unread inbox/maintainer/read; do touch "$d/.gitkeep"; done
  # (a) a stale claim whose BODY contains an internal '---' (a Markdown rule).
  #     The old `sed '/^---$/,$d'` would truncate the body at the FIRST '---';
  #     the hardened strip must cut only the trailing claim block.
  {
    printf '# reap-strip\n\nIntro paragraph.\n\n---\n\nText AFTER an internal horizontal rule.\n'
    printf '\n---\nclaim:\n  host: deadhost\n  gardener: 99\n  claimed_at: 2020-01-01T00:00:00Z\n'
  } > jobs/doin/reap-strip.md
  printf 'host: deadhost\ngardener: 99\nclaimed_at: 2020-01-01T00:00:00Z\nworktree_dir: /nonexistent/reap-strip\n' > work/reap-strip
  # (b) a stale claim already requeued twice (doom once count reaches threshold 3).
  {
    printf '# reap-doom\n\nThis handler fails every time.\n\n<!-- garden-reaped: 2 -->\n'
    printf '\n---\nclaim:\n  host: deadhost\n  gardener: 98\n  claimed_at: 2020-01-01T00:00:00Z\n'
  } > jobs/doin/reap-doom.md
  printf 'host: deadhost\ngardener: 98\nclaimed_at: 2020-01-01T00:00:00Z\nworktree_dir: /nonexistent/reap-doom\n' > work/reap-doom )
git -C "$RSEED" add -A; git -C "$RSEED" "${git_id[@]}" commit -q -m "seed reaper board (2 stale claims)"
git -C "$RSEED" remote add origin "$RBARE"; git -C "$RSEED" push -q -u origin "$BRANCH"

export GARDEN_STATE="$TR/state-reap" GARDEN=reaphost
# A competing pusher: lose the CAS race the first TWO times the reaper pushes its
# batch (a competitor lands a commit, making the reaper's push non-fast-forward),
# then let it land. Proves the reaper RETRIES within the tick instead of conceding
# the first race and stranding the claims (the 2026-06-25 failure).
RCOUNT="$TR/reap-pushcount"; : > "$RCOUNT"
RPUSH="$TR/reap-push.sh"
cat > "$RPUSH" <<EOF
#!/bin/bash
c=\$(cat "$RCOUNT" 2>/dev/null || echo 0); c=\$((c+1)); printf '%s' "\$c" > "$RCOUNT"
dir="\$GARDEN_PUSH_DIR"
if [ "\$c" -le 2 ]; then
  wt=\$(mktemp -d "$TR/rcomp.XXXXXX")
  git clone -q --single-branch --branch "$BRANCH" "$RBARE" "\$wt"
  printf '# competitor %s\n' "\$c" > "\$wt/jobs/todo/competitor-\$c.md"
  git -C "\$wt" add -A; git -C "\$wt" -c user.name=c -c user.email=c@l commit -q -m "competitor \$c"
  git -C "\$wt" push -q origin "HEAD:$BRANCH"; rm -rf "\$wt"
  git -C "\$dir" push -q origin "HEAD:$BRANCH" 2>/dev/null   # now non-ff → fails
  exit \$?
fi
git -C "\$dir" push -q origin "HEAD:$BRANCH" 2>/dev/null
EOF
chmod +x "$RPUSH"

set +e
env JOURNAL_REMOTE="$RBARE" GARDEN_REAP_DOOM_THRESHOLD=3 GARDEN_PUSH_CMD="$RPUSH" \
    "$JOBS/reaper.sh" >"$TR/logs/reaper.log" 2>&1
reap_rc=$?
set -e
[ "$reap_rc" -eq 0 ] && ok "reaper exited 0 after losing 2 push races (landed within the tick)" \
  || bad "reaper exited $reap_rc (log: $(tr '\n' '|' <"$TR/logs/reaper.log"))"
[ "$(cat "$RCOUNT")" -ge 3 ] && ok "reaper retried its requeue push (≥3 push attempts, not one-and-done)" \
  || bad "reaper did not retry (push attempts=$(cat "$RCOUNT"))"

RV="$TR/rv"; git clone -q --single-branch --branch "$BRANCH" "$RBARE" "$RV"
# (a) reap-strip: requeued to todo, claim block stripped, internal '---' preserved
{ [ -f "$RV/jobs/todo/reap-strip.md" ] && [ ! -e "$RV/jobs/doin/reap-strip.md" ]; } \
  && ok "stale claim 'reap-strip' requeued doin→todo under contention" \
  || bad "reap-strip not requeued (todo=$([ -f "$RV/jobs/todo/reap-strip.md" ] && echo y || echo n) doin=$([ -e "$RV/jobs/doin/reap-strip.md" ] && echo y || echo n))"
if [ -f "$RV/jobs/todo/reap-strip.md" ]; then
  { grep -qxF -- '---' "$RV/jobs/todo/reap-strip.md" \
    && grep -qF 'Text AFTER an internal horizontal rule.' "$RV/jobs/todo/reap-strip.md" \
    && ! grep -q '^claim:' "$RV/jobs/todo/reap-strip.md"; } \
    && ok "claim-strip preserved the body's internal '---' and dropped the claim block" \
    || bad "claim-strip damaged the body or left the claim block ($(tr '\n' '|' <"$RV/jobs/todo/reap-strip.md"))"
  grep -qx '<!-- garden-reaped: 1 -->' "$RV/jobs/todo/reap-strip.md" \
    && ok "requeued job stamped with reap-count 1" || bad "reap-count marker missing/wrong"
fi
# batching: both stale claims moved in ONE commit
git -C "$RV" log --pretty=%s | grep -q 'reaped 2 stale claim' \
  && ok "both stale claims reaped in a single batched commit" || bad "reaps not batched into one commit"
# (b) reap-doom: PARKED in plan/ under a held go-ahead gate (not requeued, not
# dropped), surfaced to maintainer. The work survives for a human to resume; the
# held gate keeps any auto-promoter from re-running it.
{ [ ! -e "$RV/jobs/todo/reap-doom.md" ] && [ ! -e "$RV/jobs/doin/reap-doom.md" ] \
  && [ -f "$RV/jobs/plan/reap-doom.md" ]; } \
  && ok "doom job 'reap-doom' parked in plan/ (held, not requeued, not dropped)" \
  || bad "reap-doom not parked in plan/ (todo=$([ -e "$RV/jobs/todo/reap-doom.md" ] && echo y || echo n) doin=$([ -e "$RV/jobs/doin/reap-doom.md" ] && echo y || echo n) plan=$([ -f "$RV/jobs/plan/reap-doom.md" ] && echo y || echo n))"
{ [ -f "$RV/jobs/plan/reap-doom.md" ] && grep -qx 'gate: go-ahead' "$RV/jobs/plan/reap-doom.md" \
  && grep -qx 'doomed: true' "$RV/jobs/plan/reap-doom.md"; } \
  && ok "parked doom plan carries a held go-ahead gate and doom provenance" \
  || bad "parked doom plan missing held gate / provenance"
pmsg=$(grep -rl 'reap-doom' "$RV/inbox/maintainer/unread" 2>/dev/null | head -1)
{ [ -n "$pmsg" ] && grep -qi 'DOOM' "$pmsg"; } \
  && ok "doom job surfaced to the maintainer inbox with its body" || bad "no doom alert to maintainer"
rm -rf "$RV"
unset JOURNAL_REMOTE

# ============================================================================
hr; echo "SUBTEST 20 — PLAN: park (unclaimable) → promote → claimable; foreman deferred-promotion; reaper ignores plan/"; hr
# Dedicated bare with a jobs/plan/ category so plan state is fully controllable.
PLBARE="$TR/plan.git"; git init -q --bare "$PLBARE"
PLSEED="$TR/plan-seed"; git init -q "$PLSEED"; git -C "$PLSEED" checkout -q -b "$BRANCH"
( cd "$PLSEED"
  mkdir -p jobs/todo jobs/doin jobs/tada jobs/plan inbox/maintainer/unread inbox/maintainer/read entries
  for d in jobs/todo jobs/doin jobs/tada jobs/plan inbox/maintainer/unread inbox/maintainer/read entries; do touch "$d/.gitkeep"; done )
git -C "$PLSEED" add -A; git -C "$PLSEED" "${git_id[@]}" commit -q -m "seed plan board"
git -C "$PLSEED" remote add origin "$PLBARE"; git -C "$PLSEED" push -q -u origin "$BRANCH"

export GARDEN_STATE="$TR/state-plan" GARDEN=planhost
pl_env() { env JOURNAL_REMOTE="$PLBARE" "$@"; }
plcount() {  # plcount <subdir> → non-gitkeep entries in a fresh clone
  local v n; v="$(mktemp -d "$TR/plv.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$PLBARE" "$v" 2>/dev/null
  n=$(ls -1 "$v/$1" 2>/dev/null | grep -vxc '.gitkeep' || true); rm -rf "$v"; printf '%s' "$n"
}
plhas() {  # plhas <relpath> → exit 0 if present in a fresh clone
  local v r; v="$(mktemp -d "$TR/plh.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$PLBARE" "$v" 2>/dev/null
  [ -e "$v/$1" ]; r=$?; rm -rf "$v"; return $r
}
plcat() {  # plcat <relpath> → contents from a fresh clone
  local v; v="$(mktemp -d "$TR/plc.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$PLBARE" "$v" 2>/dev/null
  cat "$v/$1" 2>/dev/null; rm -rf "$v"
}

# (1) post-plan parks in plan/, NOT todo/
echo "the deferred work body" | pl_env "$JOBS/post-plan.sh" --deferred --priority normal plan-deferred-a >/dev/null 2>&1
{ [ "$(plcount jobs/plan)" -eq 1 ] && [ "$(plcount jobs/todo)" -eq 0 ] && plhas jobs/plan/plan-deferred-a.md; } \
  && ok "post-plan parked 'plan-deferred-a' in plan/, not todo/" \
  || bad "post-plan misfiled (plan=$(plcount jobs/plan) todo=$(plcount jobs/todo))"

# idempotency: a second post-plan on the same base is a no-op
echo "second body" | pl_env "$JOBS/post-plan.sh" --deferred plan-deferred-a >/dev/null 2>&1
[ "$(plcount jobs/plan)" -eq 1 ] && ok "post-plan idempotent on basename (no duplicate)" || bad "post-plan duplicated (plan=$(plcount jobs/plan))"

# (2) a gardener does NOT claim a plan job (empty todo → no-work exit 3, plan/ untouched)
set +e
claimout="$(pl_env "$JOBS/claim-job.sh" 1 2>/dev/null)"; claimrc=$?
set -e
{ [ "$claimrc" -eq 3 ] && [ -z "$claimout" ] && [ "$(plcount jobs/plan)" -eq 1 ] && [ "$(plcount jobs/doin)" -eq 0 ]; } \
  && ok "gardener did NOT claim the plan job (no-work exit 3; plan/ untouched)" \
  || bad "plan job was claimable (rc=$claimrc out='$claimout' plan=$(plcount jobs/plan) doin=$(plcount jobs/doin))"

# (3) promote-plan moves plan→todo, strips frontmatter, stamps provenance
pl_env "$JOBS/promote-plan.sh" plan-deferred-a >/dev/null 2>&1
{ [ "$(plcount jobs/plan)" -eq 0 ] && [ "$(plcount jobs/todo)" -eq 1 ] && plhas jobs/todo/plan-deferred-a.md; } \
  && ok "promote-plan moved 'plan-deferred-a' plan→todo" \
  || bad "promote-plan failed (plan=$(plcount jobs/plan) todo=$(plcount jobs/todo))"
pbody="$(plcat jobs/todo/plan-deferred-a.md)"
{ printf '%s' "$pbody" | grep -q 'garden-promoted-from-plan' \
  && ! printf '%s\n' "$pbody" | grep -q '^gate:' \
  && printf '%s' "$pbody" | grep -q 'the deferred work body'; } \
  && ok "promoted todo body: frontmatter stripped, provenance stamped, work body preserved" \
  || bad "promoted body wrong ($(printf '%s' "$pbody" | tr '\n' '|'))"

# (4) the promoted job IS now claimable by a gardener
set +e
claimout="$(pl_env "$JOBS/claim-job.sh" 2 2>/dev/null)"; claimrc=$?
set -e
{ [ "$claimrc" -eq 0 ] && [ "$claimout" = "plan-deferred-a" ] && [ "$(plcount jobs/doin)" -eq 1 ]; } \
  && ok "promoted job IS claimable (gardener claimed it normally)" \
  || bad "promoted job not claimable (rc=$claimrc out='$claimout' doin=$(plcount jobs/doin))"

# (5) foreman prefers promoting the top DEFERRED plan job; never the go-ahead one.
# Fresh bare so the board is genuinely idle (todo=0 doin=0) with three parked plan jobs.
PFBARE="$TR/plan-fm.git"; git init -q --bare "$PFBARE"
PFSEED="$TR/plan-fm-seed"; git init -q "$PFSEED"; git -C "$PFSEED" checkout -q -b "$BRANCH"
( cd "$PFSEED"
  mkdir -p jobs/todo jobs/doin jobs/tada jobs/plan inbox/maintainer/unread inbox/maintainer/read entries
  for d in jobs/todo jobs/doin jobs/tada jobs/plan inbox/maintainer/unread inbox/maintainer/read entries; do touch "$d/.gitkeep"; done )
git -C "$PFSEED" add -A; git -C "$PFSEED" "${git_id[@]}" commit -q -m "seed plan-fm board"
git -C "$PFSEED" remote add origin "$PFBARE"; git -C "$PFSEED" push -q -u origin "$BRANCH"

export GARDEN_STATE="$TR/state-plan-fm" GARDEN=plfmhost
echo 'authz body' | env JOURNAL_REMOTE="$PFBARE" "$JOBS/post-plan.sh" --go-ahead              plan-needs-authz >/dev/null 2>&1
echo 'low body'   | env JOURNAL_REMOTE="$PFBARE" "$JOBS/post-plan.sh" --deferred --priority low  plan-defer-low  >/dev/null 2>&1
echo 'high body'  | env JOURNAL_REMOTE="$PFBARE" "$JOBS/post-plan.sh" --deferred --priority high plan-defer-high >/dev/null 2>&1

PFCALLS="$TR/plan-fm-calls"; : > "$PFCALLS"
pfcount() { local v n; v="$(mktemp -d "$TR/pfv.XXXXXX")"; git clone -q --single-branch --branch "$BRANCH" "$PFBARE" "$v" 2>/dev/null; n=$(ls -1 "$v/$1" 2>/dev/null | grep -vxc '.gitkeep' || true); rm -rf "$v"; printf '%s' "$n"; }
pfhas()   { local v r; v="$(mktemp -d "$TR/pfh.XXXXXX")"; git clone -q --single-branch --branch "$BRANCH" "$PFBARE" "$v" 2>/dev/null; [ -e "$v/$1" ]; r=$?; rm -rf "$v"; return $r; }
run_plfm() {  # run_plfm <now-epoch>
  # Pin the target to 1 so this case asserts the ORDERING invariant in isolation:
  # a single slot promotes exactly the top-priority deferred job and leaves the
  # rest — the lower-priority deferred AND the go-ahead — parked. Filling MORE
  # than one open slot in a tick is covered by SUBTEST 14d.
  : > "$PFCALLS"
  env JOURNAL_REMOTE="$PFBARE" GARDEN_FOREMAN_HANDLER="$HERE/foreman-stub.sh" \
      GARDEN_FOREMAN_STUB_CALLS="$PFCALLS" GARDEN_FOREMAN_NOW="$1" GARDEN_FOREMAN_IDLE_SETTLE=240 \
      GARDEN_FOREMAN_ACTIVE_TARGET=1 \
      "$JOBS/foreman.sh" >/dev/null 2>&1
}
run_plfm 1000   # idle (todo=0 doin=0): first idle observation, start the settle clock
run_plfm 1300   # 300s ≥ 240 settle → sustained idle → prefer promoting a deferred plan job
{ [ ! -s "$PFCALLS" ] && pfhas jobs/todo/plan-defer-high.md && [ "$(pfcount jobs/todo)" -eq 1 ]; } \
  && ok "foreman promoted the HIGH-priority deferred plan job (NO claude call — handler cost saved)" \
  || bad "foreman deferred-promotion wrong (calls=$(wc -l <"$PFCALLS") todo=$(pfcount jobs/todo) high=$(pfhas jobs/todo/plan-defer-high.md && echo y || echo n))"
{ pfhas jobs/plan/plan-needs-authz.md && pfhas jobs/plan/plan-defer-low.md && ! pfhas jobs/plan/plan-defer-high.md; } \
  && ok "go-ahead job left parked (never auto-promoted); lower-priority deferred still parked behind high" \
  || bad "foreman over-promoted (authz parked=$(pfhas jobs/plan/plan-needs-authz.md && echo y||echo n) low parked=$(pfhas jobs/plan/plan-defer-low.md && echo y||echo n))"

# (6) the reaper ignores plan/ entirely (parked jobs never go stale, even at TTL 0)
plan_before="$(pfcount jobs/plan)"
env JOURNAL_REMOTE="$PFBARE" GARDEN_CLAIM_TTL=0 "$JOBS/reaper.sh" >/dev/null 2>&1 || true
{ [ "$(pfcount jobs/plan)" -eq "$plan_before" ] && pfhas jobs/plan/plan-needs-authz.md; } \
  && ok "reaper left plan/ untouched (parked jobs are never reaped)" \
  || bad "reaper disturbed plan/ (before=$plan_before after=$(pfcount jobs/plan))"
unset JOURNAL_REMOTE

# ============================================================================
hr; echo "SUBTEST 20b — BLOCKED PARKING: proxy parks → no-auto-promote → unblock-on-completion"; hr
# Dedicated bare with the full board so blocked-state is fully controllable.
BLBARE="$TR/blocked.git"; git init -q --bare "$BLBARE"
BLSEED="$TR/blocked-seed"; git init -q "$BLSEED"; git -C "$BLSEED" checkout -q -b "$BRANCH"
( cd "$BLSEED"
  mkdir -p jobs/todo jobs/doin jobs/tada jobs/plan inbox/maintainer/unread inbox/maintainer/read \
           inbox/blk-job-a/unread inbox/blk-job-b/unread entries
  for d in jobs/todo jobs/doin jobs/tada jobs/plan inbox/maintainer/unread inbox/maintainer/read \
           inbox/blk-job-a/unread inbox/blk-job-b/unread entries; do touch "$d/.gitkeep"; done
  # Two in-flight jobs whose gardeners are about to signal a block.
  printf '# blk-job-a\n\ndo the PR-dependent work\n' > jobs/doin/blk-job-a.md
  printf '# blk-job-b\n\ndo the job-dependent work\n' > jobs/doin/blk-job-b.md )
git -C "$BLSEED" add -A; git -C "$BLSEED" "${git_id[@]}" commit -q -m "seed blocked board"
git -C "$BLSEED" remote add origin "$BLBARE"; git -C "$BLSEED" push -q -u origin "$BRANCH"

export GARDEN_STATE="$TR/state-blocked" GARDEN=blkhost
bl_env() { env JOURNAL_REMOTE="$BLBARE" "$@"; }
blcount() { local v n; v="$(mktemp -d "$TR/blv.XXXXXX")"; git clone -q --single-branch --branch "$BRANCH" "$BLBARE" "$v" 2>/dev/null; n=$(ls -1 "$v/$1" 2>/dev/null | grep -vxc '.gitkeep' || true); rm -rf "$v"; printf '%s' "$n"; }
blhas()   { local v r; v="$(mktemp -d "$TR/blh.XXXXXX")"; git clone -q --single-branch --branch "$BRANCH" "$BLBARE" "$v" 2>/dev/null; [ -e "$v/$1" ]; r=$?; rm -rf "$v"; return $r; }
blcat()   { local v; v="$(mktemp -d "$TR/blc.XXXXXX")"; git clone -q --single-branch --branch "$BRANCH" "$BLBARE" "$v" 2>/dev/null; cat "$v/$1" 2>/dev/null; rm -rf "$v"; }

PR_URL="https://github.com/endojs/endo-but-for-bots/pull/42"
# The gardeners signal their blocks via the structured convention (block-job.sh).
ba="$(mktemp)"; echo "Cannot finish until the upstream PR lands." > "$ba"
bb="$(mktemp)"; echo "Cannot finish until the prerequisite job completes." > "$bb"
bl_env "$JOBS/block-job.sh" blk-job-a "$PR_URL"          "$ba" >/dev/null
bl_env "$JOBS/block-job.sh" blk-job-b some-blocker-job   "$bb" >/dev/null

# (1) PROXY PARK PRE-PASS: deterministic (no handler call even within grace).
BPCALLS="$TR/block-pr-comment-calls"; : > "$BPCALLS"
PXBLOG="$TR/proxy-blocked.log"; : > "$PXCALLS"
bl_env GARDEN_PROXY_GRACE=3600 GARDEN_PROXY_HANDLER="$HERE/proxy-stub.sh" \
       GARDEN_PROXY_STUB_CALLS="$PXCALLS" \
       GARDEN_BLOCK_PR_COMMENT="$HERE/block-pr-comment-stub.sh" BLOCK_PR_COMMENT_CALLS="$BPCALLS" \
       "$JOBS/proxy.sh" >/dev/null 2>"$PXBLOG"
[ ! -s "$PXCALLS" ] && ok "blocked pre-pass: no handler / claude -p call (deterministic, even within grace)" || bad "blocked pre-pass invoked the handler ($(grep -c . "$PXCALLS") calls)"

# (2) both jobs parked as gate: blocked plans carrying blocked_on; moved out of doin/
{ blhas jobs/plan/blk-job-a.md && ! blhas jobs/doin/blk-job-a.md \
  && blcat jobs/plan/blk-job-a.md | grep -q '^gate: blocked' \
  && blcat jobs/plan/blk-job-a.md | grep -qF "blocked_on: $PR_URL"; } \
  && ok "PR-blocked job parked plan/<base> [gate: blocked + blocked_on], removed from doin/" \
  || bad "blk-job-a not parked correctly (plan=$(blhas jobs/plan/blk-job-a.md&&echo y||echo n) doin=$(blhas jobs/doin/blk-job-a.md&&echo y||echo n))"
{ blhas jobs/plan/blk-job-b.md && ! blhas jobs/doin/blk-job-b.md \
  && blcat jobs/plan/blk-job-b.md | grep -q '^gate: blocked' \
  && blcat jobs/plan/blk-job-b.md | grep -q '^blocked_on: some-blocker-job'; } \
  && ok "job-blocked job parked plan/<base> [gate: blocked + blocked_on], removed from doin/" \
  || bad "blk-job-b not parked correctly"

# (3) the blocked notifications were archived from the maintainer inbox (unread→read)
blread="$(mktemp -d "$TR/blrd.XXXXXX")"; git clone -q --single-branch --branch "$BRANCH" "$BLBARE" "$blread" 2>/dev/null
arch_n=$(grep -rl '^blocked_on:' "$blread/inbox/maintainer/read" 2>/dev/null | grep -c . || true)
unread_n=$(grep -rl '^blocked_on:' "$blread/inbox/maintainer/unread" 2>/dev/null | grep -c . || true); rm -rf "$blread"
{ [ "$unread_n" -eq 0 ] && [ "$arch_n" -eq 2 ]; } \
  && ok "both blocked notifications archived from the maintainer inbox (unread→read)" \
  || bad "blocked notifications not archived (unread=$unread_n read=$arch_n)"

# (4) the PR blocker got EXACTLY ONE courtesy comment (repo/num/base); the job blocker got none
{ [ "$(grep -c . "$BPCALLS")" -eq 1 ] \
  && grep -qF "endojs/endo-but-for-bots	42	blk-job-a" "$BPCALLS"; } \
  && ok "PR-blocker courtesy comment fired exactly once with (repo, num, base); job-blocker got none" \
  || bad "courtesy comment wrong (calls=$(cat "$BPCALLS" | tr '\n' '|'))"

# (5) NO-AUTO-PROMOTE: plan_deferred_ranked NEVER selects a blocked plan (regression
# guard). Unit-test the selector directly over a hermetic clone of the live board,
# which now holds two gate: blocked plans plus (we add) one gate: deferred plan.
BLFUNCS="$TR/blocked-funcs.sh"
{ echo 'GARDEN_BLOB_BASE=https://example/blob'; echo 'JOBS_PLAN="jobs/plan"'
  for fn in list_jobs plan_field plan_gate plan_priority plan_blocked_on plan_rank plan_deferred_ranked; do qextract "$fn" "$JOBS/common.sh"; echo; done
  for fn in job_desc render_plan_queue; do qextract "$fn" "$JOBS/bulletin.sh"; echo; done
} > "$BLFUNCS"
push_change_bare2() {  # like push_change but against $BLBARE (defined early; reused below)
  local path="$1" content="$2" msg="$3" wt; wt="$(mktemp -d "$TR/bledit.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BLBARE" "$wt"
  mkdir -p "$(dirname "$wt/$path")"; printf '%s\n' "$content" > "$wt/$path"; git -C "$wt" add "$path"
  git -C "$wt" "${git_id[@]}" commit -q -m "$msg"; git -C "$wt" push -q origin "HEAD:$BRANCH"; rm -rf "$wt"
}
push_change_bare2 "jobs/plan/plan-defer-ctl.md" "$(printf -- '---\ngate: deferred\npriority: high\n---\n# a normal deferred control')" "add deferred control plan"
PDRDIR="$(mktemp -d "$TR/pdr.XXXXXX")"; git clone -q --single-branch --branch "$BRANCH" "$BLBARE" "$PDRDIR" 2>/dev/null
PDR_OUT="$(DIR="$PDRDIR" bash -c 'source "'"$BLFUNCS"'"; plan_deferred_ranked "$DIR"')"; rm -rf "$PDRDIR"
{ ! printf '%s\n' "$PDR_OUT" | grep -qx 'blk-job-a' && ! printf '%s\n' "$PDR_OUT" | grep -qx 'blk-job-b' \
  && printf '%s\n' "$PDR_OUT" | grep -qx 'plan-defer-ctl'; } \
  && ok "plan_deferred_ranked selects gate: deferred but NEVER a gate: blocked plan (foreman can't auto-promote blocked)" \
  || bad "plan_deferred_ranked selection wrong (got: $(printf '%s' "$PDR_OUT" | tr '\n' ' '))"

# (6) UNBLOCK on PR: still parked while the PR is OPEN; promoted once it is CLOSED/merged.
PRSTATE="$TR/pr-state"; printf 'open\tfalse\n' > "$PRSTATE"
run_unblock() {
  bl_env GARDEN_UNBLOCK_PR_STATE="$HERE/unblock-pr-state-stub.sh" UNBLOCK_PR_STATE_FILE="$PRSTATE" \
         "$JOBS/unblock.sh" >/dev/null 2>&1
}
run_unblock
{ blhas jobs/plan/blk-job-a.md && ! blhas jobs/todo/blk-job-a.md; } \
  && ok "unblock leaves the job parked while its PR is still open" \
  || bad "blk-job-a promoted prematurely (PR open)"
printf 'closed\ttrue\n' > "$PRSTATE"; run_unblock
{ ! blhas jobs/plan/blk-job-a.md && blhas jobs/todo/blk-job-a.md; } \
  && ok "unblock promotes plan→todo once the PR is merged/closed" \
  || bad "blk-job-a not promoted after PR closed (plan=$(blhas jobs/plan/blk-job-a.md&&echo y||echo n) todo=$(blhas jobs/todo/blk-job-a.md&&echo y||echo n))"
# the promoted todo job is the clean work body (blocked frontmatter stripped)
{ blcat jobs/todo/blk-job-a.md | grep -q 'do the PR-dependent work' \
  && ! blcat jobs/todo/blk-job-a.md | grep -q '^gate:' \
  && ! blcat jobs/todo/blk-job-a.md | grep -q '^blocked_on:'; } \
  && ok "promoted job is the clean work body (blocked frontmatter / edge record cleaned up)" \
  || bad "promoted blk-job-a body wrong"

# (7) UNBLOCK on JOB: still parked until the blocking job lands in tada/.
run_unblock
{ blhas jobs/plan/blk-job-b.md && ! blhas jobs/todo/blk-job-b.md; } \
  && ok "unblock leaves the job parked while its blocking job is not yet in tada/" \
  || bad "blk-job-b promoted prematurely (blocker not complete)"
push_change_bare2 "jobs/tada/some-blocker-job.md" "# done" "complete the blocking job"
run_unblock
{ ! blhas jobs/plan/blk-job-b.md && blhas jobs/todo/blk-job-b.md; } \
  && ok "unblock promotes the job once its blocking job completes (lands in tada/)" \
  || bad "blk-job-b not promoted after blocker reached tada/ (plan=$(blhas jobs/plan/blk-job-b.md&&echo y||echo n) todo=$(blhas jobs/todo/blk-job-b.md&&echo y||echo n))"

# (8) BULLETIN: the blocked group renders the parked jobs and their blockers.
# Unit-test render_plan_queue (reusing BLFUNCS) over a fixture with one blocked plan.
BQF="$TR/blocked-bulletin"; rm -rf "$BQF"; mkdir -p "$BQF/journal/jobs/plan"
printf -- '---\ngate: blocked\nblocked_on: %s\npriority: normal\n---\n# widget awaits the upstream PR\n' "$PR_URL" > "$BQF/journal/jobs/plan/blk-widget.md"
BQ_OUT="$(DIR="$BQF/journal" bash -c 'source "'"$BLFUNCS"'"; render_plan_queue')"
blocked_block="$(awk '/^### blocked/{f=1} f' <<<"$BQ_OUT")"
{ printf '%s' "$blocked_block" | grep -q 'blk-widget' \
  && printf '%s' "$blocked_block" | grep -qF "$PR_URL"; } \
  && ok "bulletin renders the blocked group with the parked job and its awaited artifact" \
  || bad "bulletin blocked group wrong ($blocked_block)"

# (9) DECLINED-BLOCKER: a blocker JOB that reaches tada/ but marks its report
# `orchestration-failed: true` (a conductor that refused to merge) does NOT
# satisfy the gate. The dependent is HELD (gate blocked → blocked-failed, stays
# in plan/, never promoted to todo/) and the stalled dependency surfaces to the
# maintainer. Regression guard for the conductor-decline-tada-gate gap.
push_change_bare2 "jobs/plan/blk-job-d.md" \
  "$(printf -- '---\ngate: blocked\nblocked_on: some-declined-merge\npriority: normal\n---\n# depends on the merge actually landing')" \
  "park a job blocked on a merge that will be declined"
push_change_bare2 "jobs/tada/some-declined-merge.md" \
  "$(printf -- 'orchestration-failed: true\n# conductor DECLINED: ci red: needs shepherd\n')" \
  "complete the blocker as a DECLINE (did not merge)"
run_unblock
{ blhas jobs/plan/blk-job-d.md && ! blhas jobs/todo/blk-job-d.md \
  && blcat jobs/plan/blk-job-d.md | grep -q '^gate: blocked-failed' \
  && blcat jobs/plan/blk-job-d.md | grep -q '^blocked_failed_reason:'; } \
  && ok "unblock does NOT promote off a DECLINED (orchestration-failed) blocker; holds plan gate=blocked-failed" \
  || bad "declined-blocker dependent mishandled (plan=$(blhas jobs/plan/blk-job-d.md&&echo y||echo n) todo=$(blhas jobs/todo/blk-job-d.md&&echo y||echo n) gate=$(blcat jobs/plan/blk-job-d.md | sed -n 's/^gate:[[:space:]]*//p' | head -1))"
# the stalled dependency surfaced to the maintainer inbox (unread), naming the held job
mtread="$(mktemp -d "$TR/mtrd.XXXXXX")"; git clone -q --single-branch --branch "$BRANCH" "$BLBARE" "$mtread" 2>/dev/null
held_notice_n=$(grep -rl 'blk-job-d' "$mtread/inbox/maintainer/unread" 2>/dev/null | grep -c . || true); rm -rf "$mtread"
[ "$held_notice_n" -ge 1 ] \
  && ok "declined-blocker hold surfaced to the maintainer inbox (names the held job)" \
  || bad "no maintainer notice for the held declined-blocker dependent (found=$held_notice_n)"
# idempotent: a second tick must NOT re-promote and must NOT re-notify (gate is held)
run_unblock
held_notice_n2=$(git clone -q --single-branch --branch "$BRANCH" "$BLBARE" "$TR/mtrd2" 2>/dev/null; grep -rl 'blk-job-d' "$TR/mtrd2/inbox/maintainer/unread" 2>/dev/null | grep -c . || true); rm -rf "$TR/mtrd2"
{ ! blhas jobs/todo/blk-job-d.md && [ "$held_notice_n2" -eq "$held_notice_n" ]; } \
  && ok "held declined-blocker stays held on re-tick (no re-promote, no re-notify)" \
  || bad "held declined-blocker not idempotent (todo=$(blhas jobs/todo/blk-job-d.md&&echo y||echo n) notices=$held_notice_n2 was=$held_notice_n)"
rm -f "$ba" "$bb"
unset JOURNAL_REMOTE

# ============================================================================
hr; echo "SUBTEST 21 — SELF-HEAL WRAPPER: capture, throttle, signal-clean, rc"; hr
# The reusable self-heal runner (scripts/jobs/self-heal-run.sh) wraps a service
# command so a failure is captured by SHA and handed to a task-specific responder
# exactly ONCE per (context, exit-code) signature per window — never on a clean
# exit, and never on a systemd stop. The responder is stubbed (records calls) so
# no real `claude -p` runs; the wrapper's own behavior is what we assert.
# Dedicated throwaway journal so self-heal's ensure_clone/capture_blob hash into a
# clone of OUR bare — never a clone derived from GARDEN_ROOT/journal (the live,
# fleet-busy journal). SUBTEST 20 unset JOURNAL_REMOTE, so without this the capture
# path would clone/derive the host's shared journal and flake under fleet load
# (rc=1 calls=0 when the derived clone races or the derived path is absent).
SHBARE="$TR/selfheal.git"; git init -q --bare "$SHBARE"
SHSEED="$TR/selfheal-seed"; git init -q "$SHSEED"; git -C "$SHSEED" checkout -q -b "$BRANCH"
( cd "$SHSEED"; mkdir -p entries; touch entries/.gitkeep )
git -C "$SHSEED" add -A; git -C "$SHSEED" "${git_id[@]}" commit -q -m "seed self-heal journal"
git -C "$SHSEED" remote add origin "$SHBARE"; git -C "$SHSEED" push -q -u origin "$BRANCH"
export JOURNAL_REMOTE="$SHBARE"
export GARDEN_STATE="$TR/state-selfheal" GARDEN=shhost GARDEN_ROOT="$JOBS/.."
SHRUN="$JOBS/self-heal-run.sh"
SHCALLS="$TR/selfheal-calls"; : > "$SHCALLS"
export SELF_HEAL_STUB_CALLS="$SHCALLS" SELF_HEAL_HANDLER="$HERE/self-heal-stub.sh"
shcalls() { grep -c RESPONDER "$SHCALLS" 2>/dev/null || true; }  # grep -c already prints 0 on no match

# (1) clean exit → silent, no responder, rc 0 preserved
: > "$SHCALLS"
set +e; "$SHRUN" garden-probe -- bash -c 'echo ok; exit 0' >/dev/null 2>&1; r0=$?; set -e
{ [ "$r0" -eq 0 ] && [ "$(shcalls)" -eq 0 ]; } \
  && ok "clean exit: silent, no responder fired (rc preserved)" || bad "clean exit fired responder (rc=$r0 calls=$(shcalls))"

# (2) failure WITH output → responder fires once, exit code preserved, blob captured
: > "$SHCALLS"
set +e; "$SHRUN" garden-probe --work-id PR42 -- bash -c 'echo line; echo boom >&2; exit 3' >/dev/null 2>&1; r3=$?; set -e
sha="$(sed -n 's/.*sha=\([0-9a-f]\{40\}\).*/\1/p' "$SHCALLS" | head -1)"
{ [ "$r3" -eq 3 ] && [ "$(shcalls)" -eq 1 ] && grep -q 'rc=3' "$SHCALLS" && grep -q 'workid=PR42' "$SHCALLS"; } \
  && ok "failure: responder fired ONCE with rc=3 and work-id (exit code preserved)" || bad "failure handling wrong (rc=$r3 calls=$(shcalls))"
{ [ -n "$sha" ] && git -C "$GARDEN_STATE/self-heal/journal" cat-file -p "$sha" 2>/dev/null | grep -q boom; } \
  && ok "failure output captured as a content-addressed blob (responder gets the SHA, not the log)" || bad "capture blob missing or wrong (sha=$sha)"

# (3) immediate re-failure, SAME (context, rc) signature → THROTTLED (no 2nd responder)
set +e; "$SHRUN" garden-probe -- bash -c 'echo again; exit 3' >/dev/null 2>&1; set -e
[ "$(shcalls)" -eq 1 ] && ok "same-signature re-failure THROTTLED (no token-burn on a crash loop)" || bad "throttle leaked ($(shcalls) calls)"

# (4) distinct exit code is a distinct signature → fires
set +e; SELF_HEAL_THROTTLE_SECS=1800 "$SHRUN" garden-probe -- bash -c 'echo seven; exit 7' >/dev/null 2>&1; set -e
{ [ "$(shcalls)" -eq 2 ] && grep -q 'rc=7' "$SHCALLS"; } \
  && ok "distinct exit code → distinct signature, responder fires for the new failure" || bad "rc=7 not treated as new signature ($(shcalls))"

# (5) daily cap caps a same-signature flood even with a zero window
: > "$SHCALLS"
for _ in 1 2 3 4; do
  set +e; SELF_HEAL_THROTTLE_SECS=0 SELF_HEAL_DAILY_CAP=2 "$SHRUN" garden-flood -- bash -c 'echo f; exit 9' >/dev/null 2>&1; set -e
done
[ "$(shcalls)" -eq 2 ] && ok "daily cap holds: 4 same-signature failures → at most 2 responders" || bad "daily cap not enforced ($(shcalls) of cap 2)"

# (6) a TERM mid-run (systemd stop) is a CLEAN shutdown → no responder AND exit 0.
# The wrapper must NOT return the signal code (143): systemd records `exit 143`
# as "Main process exited, code=exited, status=143" → "Failed with result
# 'exit-code'" on EVERY stop/restart of a continuous unit, flapping it to a
# false Failed state. A signalled shutdown is clean, so the wrapper exits 0.
: > "$SHCALLS"
SELF_HEAL_THROTTLE_SECS=0 "$SHRUN" garden-sleeper -- bash -c 'sleep 30' >/dev/null 2>&1 & shpid=$!
sleep 1; kill -TERM "$shpid"; set +e; wait "$shpid"; rterm=$?; set -e
{ [ "$(shcalls)" -eq 0 ] && [ "$rterm" -eq 0 ]; } \
  && ok "SIGTERM mid-run → clean shutdown: no diagnosis AND exit 0 (no false Failed)" \
  || bad "systemd stop wrongly handled (rc=$rterm calls=$(shcalls); expect rc=0 calls=0)"

# (7) PRODUCER-classified transient outage: sync_clone exits GARDEN_OFFLINE_RC (75)
# on a DNS/connectivity blip. The wrapper must normalize that to a CLEAN exit 0 and
# fire NO responder — a self-resolving network outage is not a unit failure and
# must not burn a `claude -p`. This exercises block 1 of the decision (the RC path,
# whose producer side lives in common.sh sync_clone via _fetch_stderr_is_offline).
: > "$SHCALLS"
set +e; SELF_HEAL_THROTTLE_SECS=0 "$SHRUN" garden-net -- \
  bash -c "exit ${GARDEN_OFFLINE_RC:-75}" >/dev/null 2>&1; rnet=$?; set -e
{ [ "$rnet" -eq 0 ] && [ "$(shcalls)" -eq 0 ]; } \
  && ok "producer-classified outage (rc=75) → clean exit 0, no responder" \
  || bad "offline-rc not normalized to clean (rc=$rnet calls=$(shcalls))"

# (8) BELT-AND-SUSPENDERS: an outage hit OUTSIDE sync_clone (e.g. a raw `git fetch`
# that exits 128 with a connectivity diagnostic in its output, not GARDEN_OFFLINE_RC)
# must still be recognized from the captured tail and skipped — clean exit 0, no
# responder. A genuine failure that exits the same code WITHOUT an outage signature
# must STILL diagnose, proving the grep gates on the signature and not just the rc.
: > "$SHCALLS"
set +e; SELF_HEAL_THROTTLE_SECS=0 "$SHRUN" garden-net -- \
  bash -c 'echo "fatal: Could not resolve hostname github.com" >&2; exit 128' >/dev/null 2>&1; rblip=$?; set -e
{ [ "$rblip" -eq 0 ] && [ "$(shcalls)" -eq 0 ]; } \
  && ok "outage signature in tail (rc=128) → clean exit 0, no responder (belt-and-suspenders)" \
  || bad "connectivity signature not short-circuited (rc=$rblip calls=$(shcalls))"

: > "$SHCALLS"
set +e; SELF_HEAL_THROTTLE_SECS=0 "$SHRUN" garden-net -- \
  bash -c 'echo "fatal: bad object HEAD" >&2; exit 128' >/dev/null 2>&1; rreal=$?; set -e
{ [ "$rreal" -eq 128 ] && [ "$(shcalls)" -eq 1 ]; } \
  && ok "genuine rc=128 failure (no outage signature) STILL diagnoses (rc preserved)" \
  || bad "real failure wrongly treated as outage (rc=$rreal calls=$(shcalls))"
unset SELF_HEAL_STUB_CALLS SELF_HEAL_HANDLER JOURNAL_REMOTE

# ============================================================================
hr; echo "SUBTEST 22 — GARDENER OFFLINE CLAIM: a transient outage skips, never crashes"; hr
# A DNS/connectivity blip during the claim's sync_clone fetch makes claim-job.sh
# exit GARDEN_OFFLINE_RC (75, EX_TEMPFAIL). gardener.sh must treat that like the
# empty-board case — log "offline; skipping claim tick", sleep, and retry next
# cadence — NOT die (which crash-loops the worker and burns a self-heal
# responder on a self-resolving blip). Drive it with an injected offline fetch:
# ensure_clone's initial `git clone` is real (so the clone exists), but every
# subsequent sync_clone routes through GARDEN_FETCH_CMD → exit 128 with a
# resolver diagnostic → sync_clone exits 75 → claim-job.sh exits 75.
export JOURNAL_REMOTE="$BARE"
OFFBIN="$TR/bin"; mkdir -p "$OFFBIN"
cat > "$OFFBIN/offline-fetch" <<'EOF'
#!/bin/bash
echo "ssh: Could not resolve hostname github.com: Temporary failure in name resolution" >&2
echo "fatal: Could not read from remote repository." >&2
exit 128
EOF
chmod +x "$OFFBIN/offline-fetch"
OFFLOG="$TR/logs/gardener-offline.log"
# Permanently-offline board under ONESHOT: the offline branch never increments
# idle_rounds (an outage is not a drained board), so a CORRECT gardener loops
# forever skipping — we give it a few ticks, assert it stayed ALIVE (the buggy
# `die` exits ~immediately), then kill it. GARDEN_FETCH_RETRIES=1 keeps each
# offline classification fast.
env GARDEN=offhost GARDEN_STATE="$TR/state-offline" \
    GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 \
    GARDEN_FETCH_CMD="$OFFBIN/offline-fetch" GARDEN_FETCH_RETRIES=1 \
    GARDEN_JOB_HANDLER="$HERE/stub-handler.sh" \
    "$JOBS/gardener.sh" off > "$OFFLOG" 2>&1 &
offpid=$!
sleep 4
if kill -0 "$offpid" 2>/dev/null; then
  ok "gardener survived a persistent claim outage (did not die on rc=75)"
else
  set +e; wait "$offpid"; offrc=$?; set -e
  bad "gardener exited on an offline claim tick (rc=$offrc; expected it to keep skipping)"
fi
kill "$offpid" 2>/dev/null || true; wait "$offpid" 2>/dev/null || true
grep -q 'claim transiently offline' "$OFFLOG" \
  && ok "gardener logged the offline skip-and-retry" \
  || bad "gardener did not log an offline skip ($(tail -1 "$OFFLOG" 2>/dev/null))"
grep -q 'claim failed' "$OFFLOG" \
  && bad "gardener treated the outage as a fatal claim failure" \
  || ok "gardener did not escalate the outage to a fatal claim failure"
# RESTORE the throwaway remote (not `unset`), for the same reason SUBTEST 14d
# spells out: SUBTEST 24's corruption cases let sync_clone re-clone through
# ensure_clone, which resolves journal_remote itself. With JOURNAL_REMOTE unset it
# derived the REAL kriskowal/garden journal from $GARDEN_ROOT and re-cloned ~20s of
# PRODUCTION history over the fixture — so the restored clone's tip was never the
# fixture's seed sha and both cases failed. Re-export the throwaway $BARE.
export JOURNAL_REMOTE="$BARE"

# ============================================================================
hr; echo "SUBTEST 23 — OFFLINE CLASSIFIER: transient signatures → EX_TEMPFAIL"; hr
# _fetch_stderr_is_offline (common.sh) is the producer-side gate that decides
# whether a failed fetch is a self-resolving network/DNS/TLS blip (classify as
# offline → sync_clone exits EX_TEMPFAIL, the fleet skips the tick) or a real
# repository error (fall through to `die`). The set was broadened beyond the
# original four DNS/SSH literals to the full HTTPS/TLS transient surface; an
# unmatched signature means a momentary GitHub 5xx or reset-by-peer kills every
# caller running through sync_clone (complete-job, post-job, bulletin,
# scheduler). Feed each signature string straight through the classifier and
# assert it classifies offline, case-insensitively; then assert a genuine repo
# error does NOT (so the gate still lets real failures die).
(
  set +e
  # shellcheck source=/dev/null
  . "$JOBS/common.sh"   # defines _fetch_stderr_is_offline + GARDEN_OFFLINE_SIGNATURES
  cpass=0; cfail=0
  expect_offline() {  # <description> <stderr-text>
    if _fetch_stderr_is_offline "$2"; then echo "  PASS: offline classified: $1"; cpass=$((cpass+1))
    else echo "  FAIL: classifier missed offline signature: $1"; cfail=$((cfail+1)); fi
  }
  expect_online() {   # <description> <stderr-text>
    if _fetch_stderr_is_offline "$2"; then echo "  FAIL: classifier wrongly flagged as offline: $1"; cfail=$((cfail+1))
    else echo "  PASS: real error not classified offline: $1"; cpass=$((cpass+1)); fi
  }
  expect_corrupt() {  # <description> <stderr-text>
    if _fetch_stderr_is_corrupt "$2"; then echo "  PASS: corruption classified: $1"; cpass=$((cpass+1))
    else echo "  FAIL: classifier missed corruption signature: $1"; cfail=$((cfail+1)); fi
  }
  # DNS / resolver
  expect_offline "git HTTPS resolver"   "fatal: unable to access 'https://github.com/': Could not resolve host: github.com"
  expect_offline "SSH resolver"         "ssh: Could not resolve hostname github.com: Name or service not known"
  expect_offline "getaddrinfo"          "ssh: connect to host github.com: Temporary failure in name resolution"
  # remote / SSH
  expect_offline "ssh remote read"      "fatal: Could not read from remote repository."
  # timeouts
  expect_offline "connection timeout"   "ssh: connect to host github.com port 22: Connection timed out"
  expect_offline "operation timeout"    "fatal: unable to access 'https://github.com/': Operation timed out after 45001 ms"
  # HTTPS transport blips
  expect_offline "reset by peer"        "fatal: unable to access 'https://github.com/': Connection reset by peer"
  expect_offline "recv failure"         "error: RPC failed; curl 56 Recv failure: Connection reset by peer"
  expect_offline "early eof"            "fatal: the remote end hung up unexpectedly\nfatal: early EOF"
  expect_offline "unexpected disconnect" "fatal: early EOF\nremote: unexpected disconnect while reading sideband packet"
  expect_offline "rpc failed"           "error: RPC failed; HTTP 502 curl 22 The requested URL returned error: 502"
  expect_offline "http 5xx"             "fatal: unable to access 'https://github.com/': The requested URL returned error: 503"
  expect_offline "http 500 numeric"     "error: RPC failed; HTTP 500 curl 22"
  # TLS / SSL
  expect_offline "gnutls handshake"     "fatal: unable to access 'https://github.com/': gnutls_handshake() failed: The TLS connection was non-properly terminated."
  expect_offline "openssl error"        "fatal: unable to access 'https://github.com/': OpenSSL SSL_read: Connection was reset, errno 10054"
  # case-insensitivity: a lower-cased diagnostic still classifies
  expect_offline "lowercased dns"       "could not resolve host: github.com"
  expect_offline "uppercased reset"     "CONNECTION RESET BY PEER"
  # genuine repository errors must NOT classify as offline
  expect_online  "bad object"           "fatal: bad object HEAD"
  expect_corrupt "bad object"           "fatal: bad object HEAD"
  expect_corrupt "missing objects"      "error: github.com:kriskowal/garden.git did not send all necessary objects"
  expect_online  "non-fast-forward"     "! [rejected]        journal2 -> journal2 (non-fast-forward)"
  expect_online  "no such ref"          "fatal: couldn't find remote ref refs/heads/nope"
  expect_online  "merge conflict"       "error: could not apply abc1234... commit"

  # --- LOCAL-CORRUPTION classifier (_fetch_stderr_is_corrupt) ----------------
  # A corrupt local clone is NOT a network outage: it is a permanent-until-repaired
  # fault sync_clone must self-heal (targeted repair or re-clone) rather than die
  # on every tick. Feed each corruption signature through the classifier and assert
  # it flags corrupt; then assert a genuine outage is NOT flagged corrupt (so the
  # offline path, which runs ahead, still owns it). The garden-cleric item-7
  # incident — a null-sha refs/remotes/origin/journal2 → `bad object refs/…` +
  # `did not send all necessary objects` (fetch) / `invalid sha1 pointer` (fsck) —
  # is the headline fixture.
  expect_corrupt() {  # <description> <stderr-text>
    if _fetch_stderr_is_corrupt "$2"; then echo "  PASS: corrupt classified: $1"; cpass=$((cpass+1))
    else echo "  FAIL: classifier missed corruption signature: $1"; cfail=$((cfail+1)); fi
  }
  expect_not_corrupt() {  # <description> <stderr-text>
    if _fetch_stderr_is_corrupt "$2"; then echo "  FAIL: classifier wrongly flagged as corrupt: $1"; cfail=$((cfail+1))
    else echo "  PASS: non-corruption not classified corrupt: $1"; cpass=$((cpass+1)); fi
  }
  # the garden-cleric item-7 incident: a null-sha remote-tracking ref
  expect_corrupt "null-sha remote ref"   "fatal: bad object refs/remotes/origin/journal2
error: /root/.garden-state/clerics/7/journal did not send all necessary objects"
  expect_corrupt "did not send objects"  "error: remote did not send all necessary objects"
  expect_corrupt "fsck null pointer"     "error: refs/remotes/origin/journal2: invalid sha1 pointer 0000000000000000000000000000000000000000"
  expect_corrupt "bad ref for"           "fatal: bad ref for refs/remotes/origin/journal2"
  expect_corrupt "broken ref"            "error: refs/remotes/origin/journal2 does not point to a valid object!\nbroken ref"
  expect_corrupt "unable to read sha1"   "error: unable to read sha1 file of jobs/todo/x (deadbeef...)"
  expect_corrupt "loose object corrupt"  "error: loose object 0d5645f4298ba42b49e45f951ae711c129c87618 is corrupt"
  expect_corrupt "empty object file"     "fatal: object file .git/objects/0d/5645... is empty"
  # the second cleric item-7 shape: a stale gc.log blocks repack, so fetch's
  # implicit gc/maintenance fails with `failed to run repack` and git names
  # `.git/gc.log` — with NO `bad object` line of its own. Both must classify
  # corrupt on their own so this state re-clones instead of crash-looping the unit.
  expect_corrupt "failed to run repack"  "error: Could not read 0d5645f4298ba42b49e45f951ae711c129c87618
fatal: failed to run repack"
  expect_corrupt "gc.log present"        "warning: The last gc run reported the following. Please correct the root cause
and remove .git/gc.log.
Automatic cleanup will not be performed until the file is removed."
  # a bare `does not point to a valid object` (no accompanying `broken ref`)
  expect_corrupt "dangling ref only"     "error: refs/remotes/origin/journal2 does not point to a valid object!"
  # case-insensitivity: an upper-cased corruption diagnostic still classifies
  expect_corrupt "uppercased corrupt"    "FATAL: BAD OBJECT REFS/REMOTES/ORIGIN/JOURNAL2"
  # a genuine connectivity outage is NOT corruption (offline path owns it)
  expect_not_corrupt "dns outage"        "fatal: unable to access 'https://github.com/': Could not resolve host: github.com"
  expect_not_corrupt "connection reset"  "error: RPC failed; curl 56 Recv failure: Connection reset by peer"

  echo "$cpass $cfail" > "$TR/classifier-counts"
)
# The cases ran in a subshell (to source common.sh in isolation), so reconcile
# its per-case tallies into the harness PASS/FAIL totals here in the parent.
read -r cp cf < "$TR/classifier-counts"
PASS=$((PASS+cp)); FAIL=$((FAIL+cf))

# ============================================================================
hr; echo "SUBTEST 24 — SYNC_CLONE FETCH OUTAGE → EX_TEMPFAIL (rc=124 timeout; signature-gated rc=128)"; hr
# sync_clone (common.sh) is the producer-side fetch gate every board op runs
# through. Two transient shapes must classify as a self-resolving outage and exit
# GARDEN_OFFLINE_RC (75, EX_TEMPFAIL) — NOT die(1) — so the fleet skips the tick
# instead of recording one `Failed with result 'exit-code'` per worker (and
# burning a self-heal responder) on ordinary git-fetch flakiness under
# ~100-gardener contention:
#   (a) rc=124: journal_fetch's `timeout` killed a stalled half-open fetch after
#       bounded retries (it already logged the timeout).
#   (b) any rc whose stderr matches an outage signature — here rc=128 with "the
#       remote end hung up unexpectedly" (a smart-HTTP cut) — proving the gate is
#       on the SIGNATURE, not a hard rc==128. The injected fetch never touches a
#       real remote, so clone_lock + the classifier are exercised in isolation.
S24="$TR/sync24"; mkdir -p "$S24/bin"
cat > "$S24/bin/timeout-fetch" <<'EOF'
#!/bin/bash
exit 124   # emulate `timeout` killing a stalled fetch (journal_fetch logged it)
EOF
cat > "$S24/bin/hangup-fetch" <<'EOF'
#!/bin/bash
echo "fatal: the remote end hung up unexpectedly" >&2
echo "fatal: early EOF" >&2
exit 128
EOF
chmod +x "$S24/bin/timeout-fetch" "$S24/bin/hangup-fetch"
run_sync() {  # <fetch-cmd> -> echoes sync_clone's exit code (it exits the subshell)
  local d rc; d="$(mktemp -d "$S24/clone.XXXXXX")"
  set +e
  ( . "$JOBS/common.sh"
    export GARDEN_FETCH_RETRIES=1 GARDEN_FETCH_CMD="$1"
    sync_clone "$d" >/dev/null 2>&1 )
  rc=$?; set -e
  echo "$rc"
}
r124="$(run_sync "$S24/bin/timeout-fetch")"
[ "$r124" -eq "${GARDEN_OFFLINE_RC:-75}" ] \
  && ok "sync_clone fetch timeout (rc=124) → EX_TEMPFAIL ($r124), not die(1)" \
  || bad "sync_clone exited $r124 on a fetch timeout (expected ${GARDEN_OFFLINE_RC:-75})"
rhang="$(run_sync "$S24/bin/hangup-fetch")"
[ "$rhang" -eq "${GARDEN_OFFLINE_RC:-75}" ] \
  && ok "sync_clone 'remote end hung up' (rc=128) → EX_TEMPFAIL ($rhang), signature-gated not rc-gated" \
  || bad "sync_clone exited $rhang on a hung-up fetch (expected ${GARDEN_OFFLINE_RC:-75})"
# End-to-end: the self-heal wrapper normalizes that producer rc to a CLEAN exit 0
# with NO responder — the actual "stop recording Failed / stop burning a
# responder" goal this job is about.
cat > "$S24/bin/wrap-sync" <<EOF
#!/bin/bash
. "$JOBS/common.sh"
export GARDEN_FETCH_RETRIES=1 GARDEN_FETCH_CMD="$S24/bin/timeout-fetch"
sync_clone "\$(mktemp -d "$S24/clone.XXXXXX")"
EOF
chmod +x "$S24/bin/wrap-sync"
: > "$SHCALLS"
export SELF_HEAL_STUB_CALLS="$SHCALLS" SELF_HEAL_HANDLER="$HERE/self-heal-stub.sh"
set +e; SELF_HEAL_THROTTLE_SECS=0 "$SHRUN" garden-sync -- "$S24/bin/wrap-sync" >/dev/null 2>&1; rwrap=$?; set -e
unset SELF_HEAL_STUB_CALLS SELF_HEAL_HANDLER
{ [ "$rwrap" -eq 0 ] && [ "$(shcalls)" -eq 0 ]; } \
  && ok "self-heal normalizes the sync_clone outage rc to clean exit 0, no responder" \
  || bad "self-heal did not normalize the sync_clone outage (rc=$rwrap calls=$(shcalls))"

# A deterministic local corruption is neither an offline skip nor an immediate
# fatal. sync_clone replaces the affected clone through ensure_clone's atomic
# re-clone path under the held lock, then makes one fetch attempt against the
# fresh clone. A second failure must surface rather than loop.

# (A) The reported shape: a REAL zero-byte ref corruption against the REAL bare remote
# (default git fetch, no stub), plus a stale gc.log. refs/remotes/origin/$BRANCH is overwritten with the null sha (an
# interrupted ref update) shadowing the valid packed-refs entry, so the first fetch
# aborts `bad object refs/…` / `did not send all necessary objects` and must be
# replaced rather than retried in place.
CORRUPT_A="$S24/corrupt-clone-a"; CORRUPT_A_LOG="$S24/corrupt-a.log"
git clone -q --single-branch --branch "$BRANCH" "$BARE" "$CORRUPT_A"
seed_sha="$(git -C "$CORRUPT_A" rev-parse "origin/$BRANCH")"
printf 'repaired in place, not replaced\n' > "$CORRUPT_A/stale-sentinel"
mkdir -p "$CORRUPT_A/.git/refs/remotes/origin"
: > "$CORRUPT_A/.git/refs/remotes/origin/$BRANCH"
printf 'stale gc failure\n' > "$CORRUPT_A/.git/gc.log"
set +e
(
  . "$JOBS/common.sh"
  export GARDEN_FETCH_RETRIES=1
  sync_clone "$CORRUPT_A"
) >"$CORRUPT_A_LOG" 2>&1
rca=$?
set -e
{ [ "$rca" -eq 0 ] \
  && [ "$(git -C "$CORRUPT_A" rev-parse "origin/$BRANCH" 2>/dev/null)" = "$seed_sha" ] \
  && [ ! -e "$CORRUPT_A/stale-sentinel" ] \
  && [ ! -e "$CORRUPT_A/.git/gc.log" ] \
  && grep -q 'WARN: .* corrupt (bad object); self-healing by re-cloning' "$CORRUPT_A_LOG" \
  && grep -q 'REPAIRED: re-cloned corrupt journal clone' "$CORRUPT_A_LOG" \
  && ! grep -q 'offline; skipping tick' "$CORRUPT_A_LOG"; } \
  && ok "sync_clone re-clones the zeroed origin ref + stale gc.log via a real fetch" \
  || bad "sync_clone did not re-clone the null-sha + gc.log corruption (rc=$rca ref=$(git -C "$CORRUPT_A" rev-parse "origin/$BRANCH" 2>/dev/null) log: $(tr '\n' '|' <"$CORRUPT_A_LOG"))"

# (B) An injected corrupt fetch followed by success after re-cloning. The sentinel
# proves the corrupt clone was replaced, rather than skipped as offline or retried.
cat > "$S24/bin/corrupt-twice-then-ok-fetch" <<'EOF'
#!/bin/bash
n="$(cat "$GARDEN_FETCH_COUNT" 2>/dev/null || echo 0)"
n=$((n + 1))
printf '%s\n' "$n" > "$GARDEN_FETCH_COUNT"
if [ "$n" -le 1 ]; then
  echo "fatal: bad object refs/remotes/origin/journal2" >&2
  echo "error: github.com:kriskowal/garden.git did not send all necessary objects" >&2
  exit 128
fi
exit 0
EOF
chmod +x "$S24/bin/corrupt-twice-then-ok-fetch"
CORRUPT_B="$S24/corrupt-clone-b"
GARDEN_FETCH_COUNT="$S24/corrupt-fetch-count"
CORRUPT_B_LOG="$S24/corrupt-b.log"
rm -f "$GARDEN_FETCH_COUNT"
git clone -q --single-branch --branch "$BRANCH" "$BARE" "$CORRUPT_B"
printf 'old clone must be replaced\n' > "$CORRUPT_B/stale-sentinel"
set +e
(
  . "$JOBS/common.sh"
  export GARDEN_FETCH_RETRIES=1 GARDEN_FETCH_CMD="$S24/bin/corrupt-twice-then-ok-fetch" GARDEN_FETCH_COUNT
  sync_clone "$CORRUPT_B"
) >"$CORRUPT_B_LOG" 2>&1
rcorrupt=$?
set -e
{ [ "$rcorrupt" -eq 0 ] && [ "$(cat "$GARDEN_FETCH_COUNT")" -eq 2 ] \
  && [ ! -e "$CORRUPT_B/stale-sentinel" ] \
  && git -C "$CORRUPT_B" rev-parse -q --verify "origin/$BRANCH" >/dev/null \
  && grep -q 'WARN: .* corrupt (bad object); self-healing by re-cloning' "$CORRUPT_B_LOG" \
  && grep -q 'REPAIRED: re-cloned corrupt journal clone' "$CORRUPT_B_LOG" \
  && ! grep -q 'offline; skipping tick' "$CORRUPT_B_LOG"; } \
  && ok "sync_clone re-clones and recovers on its one post-reclone fetch (fetches=2)" \
  || bad "sync_clone did not re-clone+recover injected corruption (rc=$rcorrupt fetches=$(cat "$GARDEN_FETCH_COUNT" 2>/dev/null || echo 0) log: $(tr '\n' '|' <"$CORRUPT_B_LOG"))"

# (B2) The SECOND cleric-item-7 shape as an INJECTED reclone-success case: a stale
# .git/gc.log blocks the fetch's implicit gc/maintenance, so fetch fails with
# `failed to run repack` and names `.git/gc.log` — emitting NO `bad object` line of
# its own. This shape only classifies corrupt because `failed to run repack`/`gc\.log`
# are in GARDEN_CORRUPT_SIGNATURES; without them it slips past the classifier and
# crash-loops the unit (the observed cleric-7 wedge). (B) proves the `bad object`
# path re-clones; this proves the gc.log/repack path does too, end-to-end through
# the injected fetch — a regression guard for that half of the signature set.
cat > "$S24/bin/repack-fail-then-ok-fetch" <<'EOF'
#!/bin/bash
n="$(cat "$GARDEN_FETCH_COUNT" 2>/dev/null || echo 0)"
n=$((n + 1))
printf '%s\n' "$n" > "$GARDEN_FETCH_COUNT"
if [ "$n" -le 1 ]; then
  echo "warning: The last gc run reported the following. Please correct the root cause" >&2
  echo "and remove .git/gc.log." >&2
  echo "fatal: failed to run repack" >&2
  exit 128
fi
exit 0
EOF
chmod +x "$S24/bin/repack-fail-then-ok-fetch"
CORRUPT_B2="$S24/corrupt-clone-b2"
CORRUPT_B2_COUNT="$S24/corrupt-fetch-count-b2"
CORRUPT_B2_LOG="$S24/corrupt-b2.log"
rm -f "$CORRUPT_B2_COUNT"
git clone -q --single-branch --branch "$BRANCH" "$BARE" "$CORRUPT_B2"
printf 'old clone must be replaced\n' > "$CORRUPT_B2/stale-sentinel"
set +e
(
  . "$JOBS/common.sh"
  export GARDEN_FETCH_RETRIES=1 GARDEN_FETCH_CMD="$S24/bin/repack-fail-then-ok-fetch" GARDEN_FETCH_COUNT="$CORRUPT_B2_COUNT"
  sync_clone "$CORRUPT_B2"
) >"$CORRUPT_B2_LOG" 2>&1
rcorrupt2=$?
set -e
{ [ "$rcorrupt2" -eq 0 ] && [ "$(cat "$CORRUPT_B2_COUNT")" -eq 2 ] \
  && [ ! -e "$CORRUPT_B2/stale-sentinel" ] \
  && git -C "$CORRUPT_B2" rev-parse -q --verify "origin/$BRANCH" >/dev/null \
  && grep -qE 'WARN: .* corrupt \((gc\.log|failed to run repack)\); self-healing by re-cloning' "$CORRUPT_B2_LOG" \
  && grep -q 'REPAIRED: re-cloned corrupt journal clone' "$CORRUPT_B2_LOG" \
  && ! grep -q 'offline; skipping tick' "$CORRUPT_B2_LOG"; } \
  && ok "sync_clone re-clones the injected 'failed to run repack'/gc.log shape (no bad-object line) and recovers (fetches=2)" \
  || bad "sync_clone did not re-clone+recover injected repack/gc.log corruption (rc=$rcorrupt2 fetches=$(cat "$CORRUPT_B2_COUNT" 2>/dev/null || echo 0) log: $(tr '\n' '|' <"$CORRUPT_B2_LOG"))"

# (C) Corruption that OUTLASTS the re-clone: an ALWAYS-corrupt injected fetch.
# sync_clone must re-clone AT MOST ONCE (the initial and one post-reclone fetch),
# then `die` loud — never spin a
# reclone-per-tick loop. This exercises the heal-once guard: a genuinely
# unrecoverable remote still dies rather than looping.
cat > "$S24/bin/always-corrupt-fetch" <<'EOF'
#!/bin/bash
n="$(cat "$GARDEN_FETCH_COUNT" 2>/dev/null || echo 0)"
n=$((n + 1))
printf '%s\n' "$n" > "$GARDEN_FETCH_COUNT"
echo "fatal: bad object refs/remotes/origin/journal2" >&2
echo "error: github.com:kriskowal/garden.git did not send all necessary objects" >&2
exit 128
EOF
chmod +x "$S24/bin/always-corrupt-fetch"
CORRUPT_C="$S24/corrupt-clone-c"
CORRUPT_C_COUNT="$S24/corrupt-fetch-count-c"
CORRUPT_C_LOG="$S24/corrupt-c.log"
rm -f "$CORRUPT_C_COUNT"
git clone -q --single-branch --branch "$BRANCH" "$BARE" "$CORRUPT_C"
set +e
(
  . "$JOBS/common.sh"
  export GARDEN_FETCH_RETRIES=1 GARDEN_FETCH_CMD="$S24/bin/always-corrupt-fetch" GARDEN_FETCH_COUNT="$CORRUPT_C_COUNT"
  sync_clone "$CORRUPT_C"
) >"$CORRUPT_C_LOG" 2>&1
rcc=$?
set -e
{ [ "$rcc" -ne 0 ] && [ "$rcc" -ne "${GARDEN_OFFLINE_RC:-75}" ] \
  && [ "$(cat "$CORRUPT_C_COUNT")" -eq 2 ] \
  && grep -q 'fetch failed in .* after re-cloning corrupt journal clone' "$CORRUPT_C_LOG" \
  && ! grep -q 'offline; skipping tick' "$CORRUPT_C_LOG"; } \
  && ok "sync_clone re-clones at most once on unhealable corruption, then dies loud (fetches=2)" \
  || bad "sync_clone did not bound the re-clone to once on unhealable corruption (rc=$rcc fetches=$(cat "$CORRUPT_C_COUNT" 2>/dev/null || echo 0) log: $(tr '\n' '|' <"$CORRUPT_C_LOG"))"

# (D) The REPORTED garden-repo-watcher shape reproduced against the REAL bare
# remote with the DEFAULT git fetch (no stub): a ZERO-LENGTH refs/heads/$BRANCH
# LOOSE ref shadowing the valid packed-refs entry (an auto-`git gc` crashed with a
# glibc malloc assertion mid-ref-write and truncated the loose ref to 0 bytes), a
# bad .git/logs reflog for it, and the stale .git/gc.log.lock the crashed gc left
# behind. The first real fetch aborts `fatal: bad object refs/heads/$BRANCH` /
# `did not send all necessary objects` — the exact incident signature. sync_clone
# atomically re-clones, healing to a working clone (refs/heads restored,
# origin/$BRANCH back at the seed sha). A sentinel in
# the old clone must be GONE (proving the wipe/re-clone) and the stale gc.log.lock
# must be cleared by the rm -rf. Proves the reported wedge heals end-to-end from a
# genuinely corrupt on-disk clone, not just an injected fetch stub.
CORRUPT_D="$S24/corrupt-clone-d"; CORRUPT_D_LOG="$S24/corrupt-d.log"
git clone -q --single-branch --branch "$BRANCH" "$BARE" "$CORRUPT_D"
d_seed_sha="$(git -C "$CORRUPT_D" rev-parse "origin/$BRANCH")"
# Fold the valid tip into packed-refs, then truncate the shadowing loose ref to
# zero bytes (the crashed-gc corruption) and plant a bad reflog + stale gc.log.lock.
git -C "$CORRUPT_D" pack-refs --all
printf 'old clone must be replaced\n' > "$CORRUPT_D/stale-sentinel"
mkdir -p "$CORRUPT_D/.git/refs/heads" "$CORRUPT_D/.git/logs/refs/heads"
: > "$CORRUPT_D/.git/refs/heads/$BRANCH"                                          # zero-length loose ref
printf '%s\n' 0000000000000000000000000000000000000000 > "$CORRUPT_D/.git/logs/refs/heads/$BRANCH"  # bad reflog
: > "$CORRUPT_D/.git/gc.log.lock"                                                 # stale crashed-gc lock
set +e
(
  . "$JOBS/common.sh"
  export GARDEN_FETCH_RETRIES=1
  sync_clone "$CORRUPT_D"
) >"$CORRUPT_D_LOG" 2>&1
rcd=$?
set -e
{ [ "$rcd" -eq 0 ] \
  && [ "$(git -C "$CORRUPT_D" rev-parse "origin/$BRANCH" 2>/dev/null)" = "$d_seed_sha" ] \
  && git -C "$CORRUPT_D" show-ref --verify -q "refs/heads/$BRANCH" \
  && [ ! -e "$CORRUPT_D/stale-sentinel" ] \
  && [ ! -e "$CORRUPT_D/.git/gc.log.lock" ] \
  && grep -q 'REPAIRED: re-cloned corrupt journal clone' "$CORRUPT_D_LOG" \
  && ! grep -q 'offline; skipping tick' "$CORRUPT_D_LOG"; } \
  && ok "sync_clone heals a REAL zeroed refs/heads/$BRANCH + stale gc.log.lock (garden-repo-watcher shape) via re-clone → exit 0, refs restored, lock cleared" \
  || bad "sync_clone did not heal the real repo-watcher corrupt-clone shape (rcd=$rcd ref=$(git -C "$CORRUPT_D" rev-parse "origin/$BRANCH" 2>/dev/null) sentinel=$([ -e "$CORRUPT_D/stale-sentinel" ] && echo present || echo gone) lock=$([ -e "$CORRUPT_D/.git/gc.log.lock" ] && echo present || echo gone) log: $(tr '\n' '|' <"$CORRUPT_D_LOG"))"

# ============================================================================
hr; echo "SUBTEST 25 — DRAINING MARKER: fleet_draining predicate + drain-fleet helper"; hr
# The fleet pauses gracefully when a host-local marker file EXISTS. The predicate
# keys on existence only (empty or prose-filled), honors BOTH the new draining
# marker and the deprecated legacy NOPE marker (compat), and is false when neither
# is present. drain-fleet.sh on writes self-describing prose; off clears it.
DRST="$TR/drain-state"; rm -rf "$DRST"; mkdir -p "$DRST"
pred() {  # echo "yes"/"no" for fleet_draining under a given GARDEN_STATE
  ( export GARDEN_STATE="$DRST"
    source "$JOBS/common.sh" >/dev/null 2>&1
    if fleet_draining; then echo yes; else echo no; fi )
}
# (a) neither marker → not draining
rm -f "$DRST/draining" "$DRST/NOPE"
[ "$(pred)" = "no" ] && ok "no marker → fleet_draining false" || bad "false-positive with no marker"
# (b) empty new marker → draining (existence, not content)
: > "$DRST/draining"
[ "$(pred)" = "yes" ] && ok "empty draining marker → fleet_draining true (keys on existence)" || bad "empty marker not detected"
rm -f "$DRST/draining"
# (c) prose-filled new marker via the helper → draining, and the body is prose
GARDEN_STATE="$DRST" GARDEN=drainhost "$JOBS/drain-fleet.sh" on "scheduled maintenance" >/dev/null 2>&1
{ [ -s "$DRST/draining" ] && grep -qi "DRAINING" "$DRST/draining" \
  && grep -qi "remove this file" "$DRST/draining" && grep -q "set_by: drainhost" "$DRST/draining"; } \
  && ok "drain-fleet.sh on writes a self-describing prose body (what/who/how-to-clear)" || bad "helper did not write prose"
[ "$(pred)" = "yes" ] && ok "prose-filled draining marker → fleet_draining true" || bad "prose marker not detected"
# (d) helper off clears the new marker → not draining
GARDEN_STATE="$DRST" "$JOBS/drain-fleet.sh" off >/dev/null 2>&1
{ [ ! -e "$DRST/draining" ] && [ "$(pred)" = "no" ]; } && ok "drain-fleet.sh off removes the marker, fleet resumes" || bad "off did not clear the marker"
# (e) legacy NOPE marker alone still drains (backward compatibility)
: > "$DRST/NOPE"
[ "$(pred)" = "yes" ] && ok "legacy NOPE marker → fleet_draining true (backward compat)" || bad "legacy marker not honored"
rm -f "$DRST/NOPE"
# (f) the deprecated killswitch_engaged alias still resolves to fleet_draining
: > "$DRST/draining"
alias_yes="$( export GARDEN_STATE="$DRST"; source "$JOBS/common.sh" >/dev/null 2>&1; if killswitch_engaged; then echo yes; else echo no; fi )"
[ "$alias_yes" = "yes" ] && ok "deprecated killswitch_engaged alias still works" || bad "alias broke"
rm -rf "$DRST"

# ============================================================================
hr; echo "SUBTEST 26 — ISSUE INBOX: maintainer-gated issue→job / comment→message"; hr
# The garden-issue-inbox watcher turns the garden's OWN repo issues into a
# maintainer-interaction inbox. The injection defense is a DETERMINISTIC
# maintainer-trust gate (allowlist-only, NO LLM) that runs BEFORE any body is read.
# Here the issue SOURCE is stubbed (a fixture TSV), the maintainer set is a file
# override, and the repo is overridden — the gate, dispatch rules, issue-note, and
# closing etiquette under test run for real against a throwaway journal.
II_TR="$TR/issue-inbox"; rm -rf "$II_TR"; mkdir -p "$II_TR"
ii_seed() {  # ii_seed <bare>  — seed a throwaway journal with the board structure
  local bare="$1" seed; seed="$(mktemp -d "$II_TR/seed.XXXXXX")"
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$BRANCH"
  ( cd "$seed"
    mkdir -p jobs/todo jobs/doin jobs/tada work cursors config maintainers \
             inbox/dead msgs entries
    for d in jobs/todo jobs/doin jobs/tada work cursors inbox/dead msgs entries; do touch "$d/.gitkeep"; done )
  git -C "$seed" add -A; git -C "$seed" "${git_id[@]}" commit -q -m seed
  git -C "$seed" remote add origin "$bare"; git -C "$seed" push -q -u origin "$BRANCH"
  rm -rf "$seed"
}
II_ALLOW="$II_TR/maintainers"; printf '# maintainer set\nkriskowal\n' > "$II_ALLOW"
II_SRCSTUB="$II_TR/src-stub.sh"
cat > "$II_SRCSTUB" <<'EOF'
#!/bin/bash
# emit the fixture TSV verbatim (ignores repo/since); the watcher gates+dispatches.
cat "${II_FIXTURE:?set II_FIXTURE}"
EOF
chmod +x "$II_SRCSTUB"
# The source contract is ELEVEN columns (issue-inbox-watcher.sh § TSV columns):
# kind created id number author submitter state closed_by closed_at url body.
# closed_at was added after this helper was written and the fixtures were not
# widened with it, so every row silently shifted left by one — `url` landed in
# `closed_at` and the BODY landed in `url` (the issue note then carried the body
# text as its issue_url). Keep the arity assertion here so a future column change
# fails loudly at the fixture rather than shifting the fields under the tests.
ii_row() {  # ii_row kind created id number author submitter state closed_by closed_at url body
  # `bad` on STDERR: this function's stdout IS the fixture file.
  [ "$#" -eq 11 ] || { bad "ii_row needs 11 columns, got $#: $*" >&2; return 0; }
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$@"
}
ii_run() {  # ii_run <state> <bare> <fixture> [repo]
  env GARDEN_STATE="$1" JOURNAL_REMOTE="$2" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_GARDEN_REPO="${4:-kriskowal/garden}" \
      GARDEN_MAINTAINERS_ALLOWLIST="$II_ALLOW" \
      II_FIXTURE="$3" \
      GARDEN_ISSUE_SOURCE="$II_SRCSTUB" \
      "$JOBS/issue-inbox-watcher.sh" >/dev/null 2>&1
}
ii_board_has() {  # ii_board_has <bare> <base>
  local v rc=1; v="$(mktemp -d "$II_TR/bh.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$1" "$v" 2>/dev/null
  for s in todo doin tada; do [ -e "$v/jobs/$s/$2.md" ] && rc=0; done
  rm -rf "$v"; return $rc
}
ii_todo_count() {  # ii_todo_count <bare>
  local v n; v="$(mktemp -d "$II_TR/tc.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$1" "$v" 2>/dev/null
  n=$(ls -1 "$v/jobs/todo" | grep -vxc '.gitkeep' || true); rm -rf "$v"; printf '%s' "$n"
}
ii_cursor() {  # ii_cursor <state> <bare> <slug>
  env GARDEN_STATE="$1" JOURNAL_REMOTE="$2" JOURNAL_BRANCH="$BRANCH" \
    "$JOBS/cursor-get.sh" "issues/$3" | sed -n 's/^last_seen:[[:space:]]*//p' | head -1
}
ii_job_body() {  # ii_job_body <bare> <base>
  local v; v="$(mktemp -d "$II_TR/jb.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$1" "$v" 2>/dev/null
  [ -f "$v/jobs/todo/$2.md" ] && cat "$v/jobs/todo/$2.md"; rm -rf "$v"
}

# A — a maintainer's NEW ISSUE → a job keyed to the spine, carrying the issue note
BARE_II_A="$II_TR/a.git"; ii_seed "$BARE_II_A"
FIX_II_A="$II_TR/fix-a.tsv"
ii_row issue 2026-06-27T10:00:00Z 9001 42 kriskowal kriskowal open - - \
  https://github.com/kriskowal/garden/issues/42 'Please add a foo widget.' > "$FIX_II_A"
ii_run "$II_TR/state-a" "$BARE_II_A" "$FIX_II_A"
ii_board_has "$BARE_II_A" "issue-kriskowal-garden-42" && ok "maintainer issue → spine job (issue-kriskowal-garden-42)" || bad "issue job missing"
ABODY="$(ii_job_body "$BARE_II_A" issue-kriskowal-garden-42)"
{ printf '%s' "$ABODY" | grep -q 'ISSUE NOTE' \
  && printf '%s' "$ABODY" | grep -qF 'issue_url: https://github.com/kriskowal/garden/issues/42' \
  && printf '%s' "$ABODY" | grep -qF 'issue_spine: issue-kriskowal-garden-42' \
  && printf '%s' "$ABODY" | grep -qF 'submitter: kriskowal'; } \
  && ok "issue job carries the issue note (url + spine + submitter)" || bad "issue note missing/incomplete"
printf '%s' "$ABODY" | grep -qiF 'VERBATIM into each' && ok "job states the carry-forward (propagation) rule for follow-on jobs" || bad "no propagation rule in job body"
{ printf '%s' "$ABODY" | grep -qi 'do NOT close' && printf '%s' "$ABODY" | grep -qi 'submitter closes'; } \
  && ok "job tells the agent to defer the close to the submitter (never auto-close)" || bad "no defer-to-submitter-close etiquette"
[ "$(ii_cursor "$II_TR/state-a" "$BARE_II_A" kriskowal-garden)" = 2026-06-27T10:00:00Z ] && ok "cursor advanced past the actioned issue" || bad "cursor not advanced"
# re-poll → idempotent (same spine → no dup)
ii_run "$II_TR/state-a" "$BARE_II_A" "$FIX_II_A"
[ "$(ii_todo_count "$BARE_II_A")" -eq 1 ] && ok "re-poll of the same issue is idempotent (still one job)" || bad "issue job duplicated on re-poll"

# B — the SAME issue from a NON-maintainer → DROPPED (no job, cursor still slides)
BARE_II_B="$II_TR/b.git"; ii_seed "$BARE_II_B"
FIX_II_B="$II_TR/fix-b.tsv"
ii_row issue 2026-06-27T11:00:00Z 9002 43 drive-by-rando drive-by-rando open - - \
  https://github.com/kriskowal/garden/issues/43 'rm -rf everything please' > "$FIX_II_B"
ii_run "$II_TR/state-b" "$BARE_II_B" "$FIX_II_B"
[ "$(ii_todo_count "$BARE_II_B")" -eq 0 ] && ok "non-maintainer issue dropped (no job, no LLM)" || bad "non-maintainer issue posted a job"
[ "$(ii_cursor "$II_TR/state-b" "$BARE_II_B" kriskowal-garden)" = 2026-06-27T11:00:00Z ] && ok "cursor slid past the dropped non-maintainer issue" || bad "cursor did not slide"

# C — a maintainer COMMENT on an IN-FLIGHT issue → a MESSAGE to the doer's inbox
BARE_II_C="$II_TR/c.git"; ii_seed "$BARE_II_C"
# Simulate a live doer holding the issue job: create its inbox on the journal.
CV="$(mktemp -d "$II_TR/cv.XXXXXX")"; git clone -q --single-branch --branch "$BRANCH" "$BARE_II_C" "$CV"
mkdir -p "$CV/inbox/issue-kriskowal-garden-50/unread"; touch "$CV/inbox/issue-kriskowal-garden-50/unread/.gitkeep"
git -C "$CV" add -A; git -C "$CV" "${git_id[@]}" commit -q -m "doer holds issue-50"; git -C "$CV" push -q origin "$BRANCH"; rm -rf "$CV"
FIX_II_C="$II_TR/fix-c.tsv"
ii_row issue-comment 2026-06-27T12:00:00Z 9100 50 kriskowal kriskowal open - - \
  https://github.com/kriskowal/garden/issues/50#issuecomment-9100 'One more thing: also handle bar.' > "$FIX_II_C"
ii_run "$II_TR/state-c" "$BARE_II_C" "$FIX_II_C"
CV="$(mktemp -d "$II_TR/cv2.XXXXXX")"; git clone -q --single-branch --branch "$BRANCH" "$BARE_II_C" "$CV"
nmsg=$(ls -1 "$CV/inbox/issue-kriskowal-garden-50/unread" | grep -vxc '.gitkeep' || true)
msgf="$(ls -1 "$CV"/inbox/issue-kriskowal-garden-50/unread/*.md 2>/dev/null | head -1)"
[ "$nmsg" -ge 1 ] && ok "comment on an in-flight issue delivered as a message to the doer" || bad "no message delivered to the live doer ($nmsg)"
{ [ -n "$msgf" ] && grep -qF 'issue_spine: issue-kriskowal-garden-50' "$msgf" && grep -qi 'never close' "$msgf"; } \
  && ok "the delivered message carries the issue note + defer-to-close etiquette" || bad "message missing issue note/etiquette"
[ "$(ii_todo_count "$BARE_II_C")" -eq 0 ] && ok "a comment posts NO job when the doer is alive (message, not job)" || bad "comment wrongly posted a job for a live doer"
rm -rf "$CV"

# D — a maintainer COMMENT on a DEAD doer → dead-lettered, then garden-deadmail
#     promotes it to a JOB that CARRIES THE ISSUE NOTE.
BARE_II_D="$II_TR/d.git"; ii_seed "$BARE_II_D"   # no inbox/issue-…-60 → doer is gone
FIX_II_D="$II_TR/fix-d.tsv"
ii_row issue-comment 2026-06-27T13:00:00Z 9200 60 kriskowal kriskowal open - - \
  https://github.com/kriskowal/garden/issues/60#issuecomment-9200 'Following up on issue 60.' > "$FIX_II_D"
ii_run "$II_TR/state-d" "$BARE_II_D" "$FIX_II_D"
DV="$(mktemp -d "$II_TR/dv.XXXXXX")"; git clone -q --single-branch --branch "$BRANCH" "$BARE_II_D" "$DV"
ndead=$(ls -1 "$DV/inbox/dead" | grep -vxc '.gitkeep' || true); rm -rf "$DV"
[ "$ndead" -ge 1 ] && ok "comment to a finished doer is dead-lettered (not dropped)" || bad "comment not dead-lettered ($ndead)"
env GARDEN_STATE="$II_TR/state-d" JOURNAL_REMOTE="$BARE_II_D" JOURNAL_BRANCH="$BRANCH" GARDEN=iihost \
  "$JOBS/deadmail.sh" >/dev/null 2>&1
DV="$(mktemp -d "$II_TR/dv2.XXXXXX")"; git clone -q --single-branch --branch "$BRANCH" "$BARE_II_D" "$DV"
promoted="$(ls -1 "$DV/jobs/todo"/deadmail-*.md 2>/dev/null | head -1)"
{ [ -n "$promoted" ] && grep -qF 'issue_spine: issue-kriskowal-garden-60' "$promoted" \
  && grep -qF 'issue_url: https://github.com/kriskowal/garden/issues/60' "$promoted"; } \
  && ok "deadmail-promoted job carries the issue note forward (url + spine)" || bad "promoted job missing the issue note"
rm -rf "$DV"

# E — an issue CLOSED BY THE SUBMITTER is terminal → dispatch nothing
BARE_II_E="$II_TR/e.git"; ii_seed "$BARE_II_E"
FIX_II_E="$II_TR/fix-e.tsv"
ii_row issue 2026-06-27T14:00:00Z 9300 70 kriskowal kriskowal closed kriskowal 2026-06-27T14:00:00Z \
  https://github.com/kriskowal/garden/issues/70 'Did the thing, closing.' > "$FIX_II_E"
ii_run "$II_TR/state-e" "$BARE_II_E" "$FIX_II_E"
[ "$(ii_todo_count "$BARE_II_E")" -eq 0 ] && ok "submitter-closed issue dispatches nothing (terminal)" || bad "posted a job for a submitter-closed issue"
[ "$(ii_cursor "$II_TR/state-e" "$BARE_II_E" kriskowal-garden)" = 2026-06-27T14:00:00Z ] && ok "cursor slid past the terminal closed issue" || bad "cursor did not slide past closed issue"

# F — INERT until configured: with NO config/garden-repo set, dispatch nothing
BARE_II_F="$II_TR/f.git"; ii_seed "$BARE_II_F"
FIX_II_F="$II_TR/fix-f.tsv"
ii_row issue 2026-06-27T15:00:00Z 9400 80 kriskowal kriskowal open - - \
  https://github.com/kriskowal/garden/issues/80 'hello' > "$FIX_II_F"
env GARDEN_STATE="$II_TR/state-f" JOURNAL_REMOTE="$BARE_II_F" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_MAINTAINERS_ALLOWLIST="$II_ALLOW" II_FIXTURE="$FIX_II_F" \
    GARDEN_ISSUE_SOURCE="$II_SRCSTUB" \
    "$JOBS/issue-inbox-watcher.sh" >/dev/null 2>&1
[ "$(ii_todo_count "$BARE_II_F")" -eq 0 ] && ok "watcher inert with no config/garden-repo (dispatches nothing)" || bad "watcher acted without a configured repo"

# H — IDEMPOTENT comment re-poll: a re-poll of the SAME comment (coldstart, a
#     lost/reset cursor, or an updated_at-driven re-surface) must NOT double-act.
#     The watcher pins the message id to the GitHub comment id
#     (GARDEN_MSG_ID=issue-comment-<cid>), so a live-inbox send finds its file
#     already present and skips, and the dead-letter path lands on the same path
#     and promotes to a single basename-idempotent job. Each re-poll uses a FRESH
#     GARDEN_STATE so the watcher's OWN cursor dedup (which would otherwise mask
#     the inbox-level idempotency under test) is reset, mimicking a lost cursor.
hr; echo "H — comment re-poll idempotent by comment id (one delivery / one job)"; hr
# H1 — live doer: re-poll of the same comment delivers EXACTLY ONE message.
BARE_II_H="$II_TR/h.git"; ii_seed "$BARE_II_H"
HV="$(mktemp -d "$II_TR/hv.XXXXXX")"; git clone -q --single-branch --branch "$BRANCH" "$BARE_II_H" "$HV"
mkdir -p "$HV/inbox/issue-kriskowal-garden-90/unread"; touch "$HV/inbox/issue-kriskowal-garden-90/unread/.gitkeep"
git -C "$HV" add -A; git -C "$HV" "${git_id[@]}" commit -q -m "doer holds issue-90"; git -C "$HV" push -q origin "$BRANCH"; rm -rf "$HV"
FIX_II_H="$II_TR/fix-h.tsv"
ii_row issue-comment 2026-06-27T16:00:00Z 9500 90 kriskowal kriskowal open - - \
  https://github.com/kriskowal/garden/issues/90#issuecomment-9500 'Re-poll me twice.' > "$FIX_II_H"
ii_run "$II_TR/state-h1" "$BARE_II_H" "$FIX_II_H"     # first poll → delivers
ii_run "$II_TR/state-h2" "$BARE_II_H" "$FIX_II_H"     # fresh state = reset cursor → re-poll
HV="$(mktemp -d "$II_TR/hv2.XXXXXX")"; git clone -q --single-branch --branch "$BRANCH" "$BARE_II_H" "$HV"
nlive=$(ls -1 "$HV/inbox/issue-kriskowal-garden-90/unread" | grep -vxc '.gitkeep' || true)
hname="$(ls -1 "$HV"/inbox/issue-kriskowal-garden-90/unread/*.md 2>/dev/null | xargs -n1 basename 2>/dev/null | head -1)"
rm -rf "$HV"
[ "$nlive" -eq 1 ] && ok "live doer: re-poll of the same comment delivers exactly one message (idempotent)" || bad "re-poll double-delivered to a live doer ($nlive)"
[ "$hname" = "issue-comment-9500.md" ] && ok "live message filename is the deterministic comment id (issue-comment-9500.md)" || bad "message id not pinned to the comment id ($hname)"

# H2 — dead doer: two polls leave exactly ONE dead-letter at the comment-id path;
#      deadmail promotes it to exactly ONE job; a further re-poll + re-promote
#      (the dead-letter was retired, so it is re-created) never adds a duplicate.
BARE_II_H2="$II_TR/h2.git"; ii_seed "$BARE_II_H2"     # no inbox → the doer is gone
FIX_II_H2="$II_TR/fix-h2.tsv"
ii_row issue-comment 2026-06-27T17:00:00Z 9600 91 kriskowal kriskowal open - - \
  https://github.com/kriskowal/garden/issues/91#issuecomment-9600 'Re-poll the dead path.' > "$FIX_II_H2"
ii_run "$II_TR/state-h2a" "$BARE_II_H2" "$FIX_II_H2"  # poll 1 → dead-letter
ii_run "$II_TR/state-h2b" "$BARE_II_H2" "$FIX_II_H2"  # poll 2 (reset cursor) → same path, no dup
HV="$(mktemp -d "$II_TR/h2v.XXXXXX")"; git clone -q --single-branch --branch "$BRANCH" "$BARE_II_H2" "$HV"
ndead=$(ls -1 "$HV/inbox/dead" | grep -vxc '.gitkeep' || true)
deadname="$(ls -1 "$HV"/inbox/dead/*.md 2>/dev/null | xargs -n1 basename 2>/dev/null | head -1)"
rm -rf "$HV"
{ [ "$ndead" -eq 1 ] && [ "$deadname" = "issue-comment-9600.md" ]; } \
  && ok "dead doer: two polls leave exactly one dead-letter at the comment-id path" || bad "dead-letter duplicated/misnamed (n=$ndead name=$deadname)"
env GARDEN_STATE="$II_TR/state-h2a" JOURNAL_REMOTE="$BARE_II_H2" JOURNAL_BRANCH="$BRANCH" GARDEN=iihost \
  "$JOBS/deadmail.sh" >/dev/null 2>&1                 # promote → one job
ii_run "$II_TR/state-h2c" "$BARE_II_H2" "$FIX_II_H2"  # poll 3 after promotion (file retired) → re-create
env GARDEN_STATE="$II_TR/state-h2a" JOURNAL_REMOTE="$BARE_II_H2" JOURNAL_BRANCH="$BRANCH" GARDEN=iihost \
  "$JOBS/deadmail.sh" >/dev/null 2>&1                 # re-promote → idempotent by basename
HV="$(mktemp -d "$II_TR/h2v2.XXXXXX")"; git clone -q --single-branch --branch "$BRANCH" "$BARE_II_H2" "$HV"
npromo=$(ls -1 "$HV/jobs/todo"/deadmail-issue-comment-9600.md 2>/dev/null | grep -c . || true)
nany=$(ls -1 "$HV/jobs"/{todo,doin,tada}/deadmail-*.md 2>/dev/null | grep -c . || true)
rm -rf "$HV"
{ [ "$npromo" -eq 1 ] && [ "$nany" -eq 1 ]; } \
  && ok "dead doer: re-poll + re-promote yields exactly one job (deadmail-issue-comment-9600)" || bad "promoted job duplicated (named=$npromo any=$nany)"

# G — SOURCE handler: issue-source-gh.sh excludes PRs and joins parent-issue meta
hr; echo "G — issue-source-gh.sh excludes PRs, surfaces issues + joined comments"; hr
command -v jq >/dev/null 2>&1 && ii_have_jq=1 || ii_have_jq=0
if [ "$ii_have_jq" -eq 0 ]; then
  echo "  SKIP: no jq on host"
else
  GHII="$II_TR/gh-g"; mkdir -p "$GHII"
  # RELATIVE fixture timestamps. issue-source-gh.sh bounds its query window to the
  # last 24h and then re-filters the payload on `created_at >= since`, so a fixture
  # pinned to a literal date ROTS: once that date falls outside the window the
  # handler emits nothing and every assertion here reads an empty file (which is
  # how this case went red by default, ~a month after it was written). Anchor the
  # rows a few hours back from now instead, and pass a `since` older than all of
  # them but inside the floor.
  G_SINCE="$(date -u -d '-4 hours'            +%FT%TZ)"
  G_TS_I="$(date  -u -d '-3 hours'            +%FT%TZ)"
  G_TS_PR="$(date -u -d '-2 hours -55 minutes' +%FT%TZ)"
  G_TS_C="$(date  -u -d '-2 hours'            +%FT%TZ)"
  G_TS_CPR="$(date -u -d '-1 hour -55 minutes' +%FT%TZ)"
  cat > "$GHII/gh" <<EOF
#!/bin/bash
# minimal gh stub for the issue-source join test.
args="\$*"
case "\$args" in
  *"/issues?state=all"*)   # the issues list: one real issue (#42) + one PR (#43)
    printf '%s\n' '[{"id":1,"number":42,"state":"open","user":{"login":"kriskowal"},"created_at":"$G_TS_I","html_url":"https://x/issues/42","body":"real issue"},{"id":2,"number":43,"state":"open","user":{"login":"kriskowal"},"created_at":"$G_TS_PR","html_url":"https://x/pull/43","body":"a PR","pull_request":{"url":"x"}}]'; exit 0;;
  *"/issues/comments?"*)   # repo-wide comment feed: one on issue #50, one on PR #43
    printf '%s\n' '[{"id":91,"issue_url":"https://api/repos/o/r/issues/50","user":{"login":"kriskowal"},"created_at":"$G_TS_C","html_url":"https://x/issues/50#c91","body":"comment on issue"},{"id":92,"issue_url":"https://api/repos/o/r/issues/43","user":{"login":"kriskowal"},"created_at":"$G_TS_CPR","html_url":"https://x/pull/43#c92","body":"comment on PR"}]'; exit 0;;
  *"/issues/50")           printf '%s\n' '{"number":50,"state":"open","user":{"login":"kriskowal"}}'; exit 0;;
  *"/issues/43")           printf '%s\n' '{"number":43,"state":"open","user":{"login":"kriskowal"},"pull_request":{"url":"x"}}'; exit 0;;
esac
printf '[]\n'; exit 0
EOF
  chmod +x "$GHII/gh"
  G_OUT="$II_TR/g.out"
  G_ERR="$II_TR/g.err"
  env PATH="$GHII:$PATH" GARDEN_NO_MAINTAINER_ALERT=1 GARDEN_STATE="$II_TR/state-g" \
    "$JOBS/handlers/issue-source-gh.sh" o/r "$G_SINCE" > "$G_OUT" 2> "$G_ERR" || true
  { grep -qP "^issue\t$G_TS_I\t1\t42\t" "$G_OUT" && ! grep -qP '\t43\t' "$G_OUT"; } \
    && ok "source surfaces the real issue #42 and EXCLUDES the PR #43" || bad "source PR-exclusion wrong (out: $(cat "$G_OUT"))"
  grep -qP "^issue-comment\t$G_TS_C\t91\t50\tkriskowal\tkriskowal\topen\t-\t" "$G_OUT" \
    && ok "source emits the issue comment joined with parent-issue meta" || bad "comment row/join wrong (out: $(cat "$G_OUT"))"
  ! grep -q '#c92' "$G_OUT" \
    && ok "source drops the comment whose parent is a PR" || bad "PR comment leaked into the source output"
  [ ! -s "$G_ERR" ] \
    && ok "clean source enumeration emits no stderr noise" || bad "clean source emitted stderr: $(cat "$G_ERR")"

  # A definitive enumeration failure must append gh_api_retry's captured WARN to
  # the handler's die output, which the watcher relays as `source:` diagnostics.
  GHII_FAIL="$GHII/gh-definitive-fail"
  cat > "$GHII_FAIL" <<'EOF'
#!/bin/bash
printf '%s\n' 'gh api: HTTP 401: Bad credentials' >&2
exit 1
EOF
  chmod +x "$GHII_FAIL"
  BARE_II_G="$II_TR/g.git"; ii_seed "$BARE_II_G"
  g_death="$(env PATH="$GHII:$PATH" GARDEN_STATE="$II_TR/state-g-fail" \
    JOURNAL_REMOTE="$BARE_II_G" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_GARDEN_REPO=kriskowal/garden GARDEN_MAINTAINERS_ALLOWLIST="$II_ALLOW" \
    GARDEN_ISSUE_SOURCE="$JOBS/handlers/issue-source-gh.sh" GARDEN_GH="$GHII_FAIL" \
    GARDEN_GH_API_ATTEMPTS=1 GARDEN_NO_MAINTAINER_ALERT=1 \
    "$JOBS/issue-inbox-watcher.sh" 2>&1 >/dev/null || true)"
  grep -qE 'source: .*WARN: gh api repos/kriskowal/garden/issues\?.*failed \(definitive, rc=1\).*HTTP 401: Bad credentials' <<<"$g_death" \
    && ok "definitive source enumeration failure preserves gh API stderr in the tick death output" \
    || bad "definitive source enumeration stderr was swallowed (death: $g_death)"

  # Exercise the comments enumeration independently: the issue listing succeeds,
  # while the comments listing's classified gh failure must reach the same relay.
  GHII_COMMENTS_FAIL="$GHII/gh-comments-definitive-fail"
  cat > "$GHII_COMMENTS_FAIL" <<'EOF'
#!/bin/bash
case "$*" in
  *"/issues?state=all"*) printf '%s\n' '[]'; exit 0;;
  *"/issues/comments?"*) printf '%s\n' 'gh api: HTTP 403: Resource not accessible by integration' >&2; exit 1;;
esac
printf '%s\n' '[]'
EOF
  chmod +x "$GHII_COMMENTS_FAIL"
  g_comments_death="$(env PATH="$GHII:$PATH" GARDEN_STATE="$II_TR/state-g-comments-fail" \
    JOURNAL_REMOTE="$BARE_II_G" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_GARDEN_REPO=kriskowal/garden GARDEN_MAINTAINERS_ALLOWLIST="$II_ALLOW" \
    GARDEN_ISSUE_SOURCE="$JOBS/handlers/issue-source-gh.sh" GARDEN_GH="$GHII_COMMENTS_FAIL" \
    GARDEN_GH_API_ATTEMPTS=1 GARDEN_NO_MAINTAINER_ALERT=1 \
    "$JOBS/issue-inbox-watcher.sh" 2>&1 >/dev/null || true)"
  grep -qE 'source: .*WARN: gh api repos/kriskowal/garden/issues/comments\?.*failed \(definitive, rc=1\).*HTTP 403: Resource not accessible by integration' <<<"$g_comments_death" \
    && ok "comments enumeration failure preserves gh API stderr in the tick death output" \
    || bad "comments enumeration stderr was swallowed (death: $g_comments_death)"
fi
rm -rf "$II_TR"

# ============================================================================
hr; echo "SUBTEST 27 — UNIT EXECSTART: every rendered garden-*.service execs /bin/bash"; hr
# Regression for the 2026-06-27 fleet-wide status=203/EXEC outage: deploy-sync.sh
# advances the live checkout in place (git ff + install-units re-render) while a
# unit may be (re)starting, so a unit whose ExecStart execve()s the script file
# directly hits a momentarily absent/non-executable script → 203/EXEC, which counts
# toward StartLimitBurst and can wedge the worker DOWN past the deploy. The fix runs
# a stable interpreter (/bin/bash) so systemd never 203/EXECs; a transient unreadable
# script becomes an ordinary nonzero bash exit that Restart/the next tick retries.
# Render every template exactly as install-units.sh render() does (sed @GARDEN_ROOT@)
# and assert every ExecStart= begins with /bin/bash.
UE_SRC="$JOBS/../systemd"
UE_DEST="$TR/rendered-units"; mkdir -p "$UE_DEST"
ue_fail=0; ue_n=0
for f in "$UE_SRC"/garden-*.service; do
  [ -e "$f" ] || continue
  sed "s#@GARDEN_ROOT@#/home/kris#g" "$f" > "$UE_DEST/$(basename "$f")"
done
while IFS= read -r execline; do
  ue_n=$((ue_n+1))
  case "$execline" in
    ExecStart=/bin/bash\ *) : ;;
    *) bad "ExecStart does not exec /bin/bash: $execline"; ue_fail=1 ;;
  esac
done < <(grep -h '^ExecStart=' "$UE_DEST"/garden-*.service)
{ [ "$ue_fail" -eq 0 ] && [ "$ue_n" -ge 1 ]; } \
  && ok "all $ue_n rendered garden-*.service ExecStart lines exec /bin/bash (no 203/EXEC on a deploy-window restart)" \
  || bad "some garden-*.service ExecStart does not exec /bin/bash (checked $ue_n)"
rm -rf "$UE_DEST"

# ============================================================================
hr; echo "SUBTEST 28 — LEADER/FOLLOWER: is-main-host gates singletons by GARDEN"; hr
# issue kriskowal/garden#11 (Multibot): the journal root `leader` marker names the
# leader's GARDEN identity; is-main-host.sh exits 0 on the leader, 1 on a follower;
# gardeners stay ungated (every-host). Reuses the throwaway $BARE journal
# (JOURNAL_REMOTE is already exported; the seed created hosts/.gitkeep). A focused,
# self-contained companion lives in test/main-host-test.sh (TTL cache, set-main-host).
push_change "leader" "lead-host" "designate lead-host as leader"
# Pass JOURNAL_REMOTE/JOURNAL_BRANCH explicitly (the exported values are not
# reliable this late in the run — like the other late subtests at 1906/1993) and
# scrub GARDEN_* so ambient pollution (an exported GARDEN from a prior subtest)
# cannot pre-empt the GARDEN knob's defaulting.
imh_rc() { env -u GARDEN -u GARDEN_LEADER GARDEN_STATE="$TR/state-mh-$1" GARDEN="$2" \
               JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" GARDEN_NO_MAINTAINER_ALERT=1 \
               "$JOBS/is-main-host.sh" >/dev/null 2>&1; echo $?; }
[ "$(imh_rc a lead-host)" -eq 0 ]  && ok "is-main-host exits 0 on the journal-named leader" || bad "leader not recognized"
[ "$(imh_rc b other-host)" -eq 1 ] && ok "is-main-host exits 1 on a follower"               || bad "follower not recognized"
# GARDEN is the single host-identity var the predicate compares. Unset any ambient
# GARDEN first so the explicit assignment is what is exercised.
ghv="$(env -u GARDEN GARDEN=lead-host bash -c 'source "'"$JOBS"'/common.sh"; printf %s "$GARDEN"')"
[ "$ghv" = lead-host ] && ok "GARDEN is the host-identity var honored by common.sh" || bad "GARDEN not honored ($ghv)"
# Every leader-only timer-singleton service carries the ExecCondition; gardeners do not.
MH_SRC="$JOBS/../systemd"; mh_miss=0
for u in garden-foreman garden-scheduler garden-deadmail garden-reaper garden-follow-up \
         garden-proxy garden-mentor garden-mirror-closer garden-comment-watcher@ \
         garden-mention-watcher garden-triager@ garden-issue-inbox garden-library-source-drift-scan; do
  grep -q '^ExecCondition=/bin/bash .*is-main-host.sh' "$MH_SRC/$u.service" || { mh_miss=1; echo "      missing on $u"; }
done
[ "$mh_miss" -eq 0 ] && ok "all 13 timer-singleton services carry ExecCondition=is-main-host.sh" || bad "a singleton service lacks the ExecCondition"
grep -q 'is_main_host' "$JOBS/bulletin.sh" \
  && ok "bulletin (continuous singleton) gated in-process via is_main_host" || bad "bulletin lacks in-process leader gate"
grep -q 'is-main-host' "$MH_SRC/garden-gardener@.service" \
  && bad "gardener service is leader-gated (must run every-host)" \
  || ok "gardener service NOT gated (runs on every host)"

# ============================================================================
hr; echo "SUBTEST 29 — ISSUE-REF GATE: forbid partial #N in author-written sends"; hr
# check-issue-refs.sh (the deterministic, Markdown-aware gate) forbids an
# apparently partially-qualified issue/PR reference in a message body so a bare
# `#N` never enters the bus. These rule assertions need no journal — they run the
# checker directly, so the pre-existing SUBTEST 6 `no reply_to` failure cannot
# mask them. Then the real send path (send-msg.sh broadcast) is exercised against
# the throwaway $BARE journal to confirm the gate fires before the push.
CHK="$JOBS/check-issue-refs.sh"
chk() { printf '%s\n' "$1" | "$CHK" - >/dev/null 2>&1; echo $?; }   # rc: 0 clean, 1 rejected
[ "$(chk 'please look at #652 today')" -eq 1 ]                           && ok "bare #652 is rejected"                       || bad "bare #652 not rejected"
[ "$(chk 'see endojs/endo-but-for-bots#650 thanks')" -eq 0 ]            && ok "owner/repo#N passes"                         || bad "owner/repo#N wrongly rejected"
[ "$(chk 'see https://github.com/kriskowal/garden/pull/27 done')" -eq 0 ] && ok "full issue/PR URL passes"                  || bad "full URL wrongly rejected"
[ "$(chk "$(printf '```\nrun the gauntlet #7\n```')")" -eq 0 ]          && ok "bare #N inside a fenced block passes"         || bad "fenced-block #N wrongly rejected"
[ "$(chk 'the `rebase #652` command example')" -eq 0 ]                  && ok "bare #N inside an inline code span passes"    || bad "inline-span #N wrongly rejected"
[ "$(chk "$(printf '# Heading 2\nbody text')")" -eq 0 ]                 && ok "an ATX heading line is not flagged"           || bad "ATX heading wrongly flagged"
[ "$(chk 'partial owner#5 and GH-42 forms')" -eq 1 ]                    && ok "owner#N and GH-N rejected as partial"         || bad "owner#N / GH-N not rejected"
# the failure report names the offending ref AND a remedy
refrep="$(printf 'look at #652\n' | "$CHK" - 2>&1 1>/dev/null || true)"
case "$refrep" in *'#652'*fully-qualify*) ok "rejection report names the ref and the remedy";; *) bad "report missing ref/remedy: $refrep";; esac
# real send path: send-msg.sh broadcast runs the gate before the CAS push
send_rc() {  # send_rc <state-suffix> <body> [skip=0|1]
  printf '%s\n' "$2" | env GARDEN_STATE="$TR/state-refchk-$1" GARDEN=refchk-host \
     JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" GARDEN_SKIP_REF_CHECK="${3:-0}" \
     "$JOBS/send-msg.sh" broadcast >/dev/null 2>&1; echo $?
}
[ "$(send_rc rej 'urgent: fix #652 now')" -ne 0 ]                       && ok "send-msg.sh rejects a bare #N (not posted)"   || bad "send-msg.sh posted a bare #N"
[ "$(send_rc pass 'urgent: fix kriskowal/garden#652 now')" -eq 0 ]      && ok "send-msg.sh posts a fully-qualified ref"      || bad "send-msg.sh rejected a qualified ref"
[ "$(send_rc byp 'urgent: fix #652 now' 1)" -eq 0 ]                     && ok "GARDEN_SKIP_REF_CHECK=1 bypasses the gate (machine/relay path)" || bad "bypass did not post"

# ============================================================================
hr; echo "RESULT: $PASS passed, $FAIL failed"; hr
[ "$FAIL" -eq 0 ]
