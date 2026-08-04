#!/bin/bash
# worker-health-gate-test.sh — the PRE-CLAIM worker health gate: a worker that
# cannot resolve its agent binary must SELF-DISQUALIFY rather than claim
# (common.sh § pre-claim worker health gate, gardener.sh's poll loop).
#
# Regression (the ps23 WORK-SINK outage, 2026-07-27/28): the agent CLI was probed
# INSIDE the handler — AFTER the claim had already stolen the job from the shared
# board. A host without the CLI therefore failed every job in about a second and
# returned to its poll loop far faster than a healthy worker doing real work, so it
# WON CLAIM RACES DISPROPORTIONATELY: it drained the fleet's board into doin/,
# failed everything, and the reaper requeued each job until it doomed. Evidence:
# 249 journal entries mentioning ps23, ZERO tada completions, and all 52 claims in
# jobs/doin/ held by ps23 while every other host sat idle. Nor could a peer stop it —
# set-gardeners.sh refuses a cross-host write and drain-fleet.sh's marker is
# host-local — so the only actor that can take a broken worker out of rotation is
# that worker.
#
# THE INVARIANT UNDER TEST: a worker that cannot run a job never takes one.
#
#   SUBTEST 1  REGISTRY   — every worker kind declares the agent CLI its default
#                           handler drives (gardener→claude, cleric/hermit/
#                           fireworker→codex, mystic→kimi), so the ONE gate in the
#                           spine covers every kind.
#   SUBTEST 2  EDGE       — worker_health_gate refuses while the CLI is absent and
#                           permits once it resolves, and reports EXACTLY ONCE per
#                           edge no matter how many workers/ticks observe it (the
#                           ps23 flood: one journal `error` per failed job for
#                           hours).
#   SUBTEST 3  SIMULATION — the REAL gardener.sh poll loop with its CLI denied,
#                           against a throwaway board: the board is UNTOUCHED, no
#                           doin/ entry appears, and the handler never runs. Run for
#                           BOTH the production default handler and a stub, so the
#                           refusal is the gate's doing and not a handler crash.
#   SUBTEST 4  PARK+HEAL  — a parked worker stays parked (no crash, no exit) and
#                           un-parks BY ITSELF the moment the binary reappears (the
#                           `npm install -g` window closing), claiming the job it
#                           previously refused. One error entry, one progress entry.
#   SUBTEST 5  UNCHANGED  — with the CLI resolvable the gate is a no-op: the worker
#                           claims and completes exactly as before.
#
# Usage: worker-health-gate-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env (a live gardener running this test as a board job would
# otherwise splice its own GARDEN_*/JOURNAL_*/SELF_HEAL_* state — clone, remote,
# and any GARDEN_CLAUDE_BIN override — underneath the fixture; run-test.sh
# § hermetic baseline).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1
# shellcheck source=../common.sh
source "$JOBS/common.sh"   # sourced BEFORE the exec-base probe: it defines the
                           # GARDEN_SCRATCH fallback the probe needs after the scrub

# The fixtures below are probed with `[ -x ]`, which honors a mount's noexec flag —
# and the sandbox mounts /tmp noexec, so a fixture there would read as "present but
# not runnable" and silently invert every assertion. Probe for an exec-allowed base
# exactly as claude-bin-resolver-test.sh does. Never $HOME: it is the garden root.
pick_exec_base() {
  local c probe rc
  for c in "${TMPDIR:-}" /tmp "${GARDEN_SCRATCH:-}" "${GARDEN_ROOT:+$GARDEN_ROOT/scratch}"; do
    [ -n "$c" ] || continue
    mkdir -p "$c" 2>/dev/null || true
    [ -d "$c" ] && [ -w "$c" ] || continue
    probe="$(mktemp -d "$c/whg-probe.XXXXXX" 2>/dev/null)" || continue
    printf '#!/bin/sh\nexit 7\n' > "$probe/x"; chmod +x "$probe/x" 2>/dev/null
    "$probe/x" >/dev/null 2>&1; rc=$?
    rm -rf "$probe"
    [ "$rc" -eq 7 ] && { printf '%s\n' "$c"; return 0; }
  done
  return 1
}
EXEC_BASE="$(pick_exec_base)" || { echo "  SKIP: no exec-allowed temp base (needed for the -x probes)"; exit 0; }
TR="$(mktemp -d "$EXEC_BASE/garden-health-gate.XXXXXX")"; trap 'rm -rf "$TR"' EXIT

git_id=(-c user.name=test -c user.email=test@localhost)

# seed_board <dir> <base> — throwaway origin + board holding ONE todo job.
# Prints the bare repo path.
seed_board() {
  local tr="$1" base="$2" bare="$1/journal.git" seed="$1/seed" branch=journal2 d
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$branch"
  ( cd "$seed"
    mkdir -p jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors
    for d in jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors; do touch "$d/.gitkeep"; done
    printf '# %s\n\ndo the work for %s\n' "$base" "$base" > "jobs/todo/$base.md" )
  git -C "$seed" add -A
  git -C "$seed" "${git_id[@]}" commit -q -m "seed: 1 job + structure"
  git -C "$seed" remote add origin "$bare"
  git -C "$seed" push -q -u origin "$branch"
  printf '%s\n' "$bare"
}

# verify_clone <bare> <dest> — a fresh read-only view of the board's true state.
verify_clone() { rm -rf "$2"; git clone -q --single-branch --branch journal2 "$1" "$2" 2>/dev/null; }

# ============================================================================
hr; echo "SUBTEST 1 — every worker kind declares the agent CLI the gate probes"; hr

check_bin() { # check_bin <kind> <expected>
  local got; got="$(worker_agent_bin "$1" 2>/dev/null || true)"
  if [ "$got" = "$2" ]; then ok "$1 → $2"; else bad "$1 → '$got', expected '$2'"; fi
}
check_bin gardener   claude
check_bin cleric     codex
check_bin hermit     codex
check_bin mystic     kimi
check_bin fireworker codex

# Every kind the spine reconciles must be covered — a new kind added to
# worker_kinds() without an agent_bin row would silently fail open (claim while
# unable to run), the exact hole this gate closes.
missing=""
while IFS= read -r k; do
  worker_agent_bin "$k" >/dev/null 2>&1 || missing="$missing $k"
done < <(worker_kinds)
if [ -z "$missing" ]; then
  ok "every kind in worker_kinds() has an agent_bin row (no kind fails open)"
else
  bad "kinds with no agent_bin row (they would claim while unable to run):$missing"
fi

# ============================================================================
hr; echo "SUBTEST 2 — the gate refuses while absent, permits when present, reports ONCE per EDGE"; hr

# Deny the CLI through the fail-closed GARDEN_<NAME>_BIN override rather than by
# scrubbing PATH: it reproduces the outage's resolution failure DETERMINISTICALLY
# on a host that does have a real claude installed, and leaves a real PATH so
# common.sh's own helpers still work.
export GARDEN_STATE="$TR/state2"
export GARDEN_WORKER_HEALTH_DIR="$GARDEN_STATE/health"
export GARDEN_NO_MAINTAINER_ALERT=1
export GARDEN=healthhost
# Count transition reports without a journal push: stub the reporter and tally.
REPORTS="$TR/reports"; : > "$REPORTS"
_worker_health_report() { printf '%s %s\n' "$3" "$1" >> "$REPORTS"; }

MARKER="$(worker_health_marker gardener)"

# (a) CLI absent → the gate REFUSES and latches the episode.
export GARDEN_CLAUDE_BIN="$TR/nowhere/claude"
if worker_health_gate gardener 1 2>/dev/null; then
  bad "the gate PERMITTED a claim with the agent CLI unresolvable"
else
  ok "the gate refuses to claim when the agent CLI is unresolvable"
fi
[ -d "$MARKER" ] && ok "the unhealthy episode is latched (marker present)" || bad "no episode marker latched"

# (b) further ticks and further WORKERS keep refusing — silently. This is the ps23
# flood: hundreds of near-identical error entries, one per failed job, for hours.
for i in 2 3 4 5; do worker_health_gate gardener "$i" 2>/dev/null || true; done
n="$(grep -c '^unhealthy ' "$REPORTS" || true)"
if [ "${n:-0}" -eq 1 ]; then
  ok "exactly ONE unhealthy report across 5 ticks/workers (edge, not per tick)"
else
  bad "$n unhealthy reports across 5 ticks/workers, expected exactly 1"
fi

# (c) the CLI returns → the gate PERMITS again and reports recovery exactly once.
mkdir -p "$TR/late"; printf '#!/bin/sh\nexit 0\n' > "$TR/late/claude"; chmod +x "$TR/late/claude"
export GARDEN_CLAUDE_BIN="$TR/late/claude"
if worker_health_gate gardener 1 2>/dev/null; then
  ok "the gate permits claiming once the agent CLI resolves again"
else
  bad "the gate still refuses though the agent CLI resolves"
fi
[ -d "$MARKER" ] && bad "the episode marker survived recovery" || ok "the episode marker is cleared on recovery"
for i in 2 3 4 5; do worker_health_gate gardener "$i" 2>/dev/null || true; done
n="$(grep -c '^healthy ' "$REPORTS" || true)"
if [ "${n:-0}" -eq 1 ]; then
  ok "exactly ONE recovery report across 5 ticks/workers (edge, not per tick)"
else
  bad "$n recovery reports across 5 ticks/workers, expected exactly 1"
fi

# (d) a fresh unhealthy episode reports again — the gate is edge-triggered, not
# fire-once-per-process-lifetime.
export GARDEN_CLAUDE_BIN="$TR/nowhere/claude"
worker_health_gate gardener 1 2>/dev/null || true
n="$(grep -c '^unhealthy ' "$REPORTS" || true)"
if [ "${n:-0}" -eq 2 ]; then
  ok "a NEW episode reports again (edge-triggered, not fire-once)"
else
  bad "$n unhealthy reports after a second episode, expected 2"
fi

unset -f _worker_health_report
unset GARDEN_CLAUDE_BIN GARDEN_WORKER_HEALTH_DIR
# shellcheck source=../common.sh
source "$JOBS/common.sh"   # restore the real reporter for the integration subtests

# ============================================================================
hr; echo "SUBTEST 3 — SIMULATION: the real poll loop with its CLI denied claims NOTHING"; hr

# run_spine <dir> <base> <handler-arg> <oneshot> [extra env...] — the REAL
# gardener.sh against a throwaway board. Prints nothing; leaves its log at $1/g.log.
sim() { # sim <name> <handler|DEFAULT>
  # Two statements on purpose: `local` expands ALL its words before binding any of
  # them, so a `dir="$TR/$name"` on the same line would read the OUTER (unset) name.
  local name="$1" handler="$2" bare base=simjob
  local dir="$TR/$name"
  mkdir -p "$dir"
  bare="$(seed_board "$dir" "$base")"
  local -a envv=(
    GARDEN="simhost-$name" GARDEN_STATE="$dir/gstate"
    JOURNAL_REMOTE="$bare" JOURNAL_BRANCH=journal2 GARDEN_TEST=1
    GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_IDLE_SLEEP_CAP=2
    GARDEN_NO_MAINTAINER_ALERT=1
    GARDEN_WORKER_HEALTH_GATE=1
    GARDEN_CLAUDE_BIN="$dir/nowhere/claude"
    HANDLER_RAN_MARKER="$dir/handler-ran"
  )
  [ "$handler" = DEFAULT ] || envv+=(GARDEN_JOB_HANDLER="$handler")
  env "${envv[@]}" "$JOBS/gardener.sh" 1 > "$dir/g.log" 2>&1 || true
  printf '%s\n' "$dir|$bare|$base"
}

# A stub that RECORDS that it ran. If the gate works, this file never appears —
# proving the refusal happened at the CLAIM, not by the handler failing after one.
TATTLE="$TR/tattle-handler.sh"
cat > "$TATTLE" <<'TATTLE_EOF'
#!/bin/bash
set -euo pipefail
: > "${HANDLER_RAN_MARKER:?}"
printf '# report\nthe handler RAN\n' > "${3:?}"
[ -n "${GARDEN_COMPLETION_SENTINEL:-}" ] && : > "$GARDEN_COMPLETION_SENTINEL"
TATTLE_EOF
chmod +x "$TATTLE"

for case_ in "stub|$TATTLE" "default|DEFAULT"; do
  cname="${case_%%|*}"; chandler="${case_##*|}"
  IFS='|' read -r dir bare base <<< "$(sim "$cname" "$chandler")"
  V="$dir/verify"; verify_clone "$bare" "$V"
  if [ -f "$V/jobs/todo/$base.md" ] && [ ! -f "$V/jobs/doin/$base.md" ] && [ ! -f "$V/jobs/tada/$base.md" ]; then
    ok "[$cname] the board is UNTOUCHED — job still in todo/, no doin/ entry, no tada/ entry"
  else
    bad "[$cname] the board MOVED (todo=$([ -f "$V/jobs/todo/$base.md" ] && echo y || echo n) doin=$([ -f "$V/jobs/doin/$base.md" ] && echo y || echo n) tada=$([ -f "$V/jobs/tada/$base.md" ] && echo y || echo n))"
  fi
  if [ "$cname" = stub ]; then
    if [ -e "$dir/handler-ran" ]; then
      bad "[$cname] the handler RAN — the job was claimed first and refused after (the ps23 shape)"
    else
      ok "[$cname] the handler never ran — the refusal is PRE-claim, not post-claim"
    fi
  fi
  if grep -q 'SELF-DISQUALIF' "$dir/g.log"; then
    ok "[$cname] the worker logged its self-disqualification"
  else
    bad "[$cname] no self-disqualification in the log: $(tail -3 "$dir/g.log" | tr '\n' ' ')"
  fi
done

# ============================================================================
hr; echo "SUBTEST 4 — a parked worker STAYS parked, then un-parks BY ITSELF"; hr

D="$TR/heal"; mkdir -p "$D"
BARE="$(seed_board "$D" healjob)"
LATE="$D/late/claude"          # created MID-RUN: the `npm install -g` window closing

set -m
env GARDEN=healhost GARDEN_STATE="$D/gstate" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 GARDEN_TEST=1 \
    GARDEN_ONESHOT=0 GARDEN_IDLE_SLEEP=1 GARDEN_IDLE_SLEEP_CAP=2 \
    GARDEN_NO_MAINTAINER_ALERT=1 GARDEN_WORKER_HEALTH_GATE=1 \
    GARDEN_CLAUDE_BIN="$LATE" GARDEN_JOB_HANDLER="$HERE/stub-handler.sh" \
    "$JOBS/gardener.sh" 1 > "$D/g.log" 2>&1 &
GPID=$!
set +m

# Give it several park ticks, then assert it neither claimed nor died.
sleep 6
V="$D/v1"; verify_clone "$BARE" "$V"
if [ -f "$V/jobs/todo/healjob.md" ] && [ ! -f "$V/jobs/doin/healjob.md" ]; then
  ok "parked worker claimed nothing across several ticks"
else
  bad "parked worker touched the board"
fi
if kill -0 "$GPID" 2>/dev/null; then
  ok "parked worker is STILL RUNNING (no crash into a systemd restart loop)"
else
  bad "parked worker exited (rc=$(wait "$GPID" 2>/dev/null; echo $?)) instead of parking"
fi
parks="$(grep -c 'SELF-DISQUALIFIED' "$D/g.log" || true)"
if [ "${parks:-0}" -ge 2 ]; then
  ok "the worker re-probes on a backoff (${parks} park ticks), so recovery is automatic"
else
  bad "only ${parks:-0} park tick(s); the worker is not re-probing"
fi

# The binary reappears. Nothing restarts the worker — it must notice by itself.
mkdir -p "$(dirname "$LATE")"; printf '#!/bin/sh\nexit 0\n' > "$LATE"; chmod +x "$LATE"
claimed=0
for _ in $(seq 1 40); do
  verify_clone "$BARE" "$D/v2"
  [ -f "$D/v2/jobs/tada/healjob.md" ] && { claimed=1; break; }
  sleep 1
done
kill -TERM "$GPID" 2>/dev/null || true
wait "$GPID" 2>/dev/null || true

if [ "$claimed" -eq 1 ]; then
  ok "the worker UN-PARKED by itself once the binary reappeared and completed the job"
else
  bad "the worker never resumed after the binary reappeared: $(tail -4 "$D/g.log" | tr '\n' ' ')"
fi

verify_clone "$BARE" "$D/v3"
errs="$( (ls -1 "$D/v3/entries"/*/*/*/*-error-gardener-*.md 2>/dev/null || true) | wc -l | tr -d ' ')"
progs="$( (grep -rl 'resolved their agent CLI again' "$D/v3/entries" 2>/dev/null || true) | wc -l | tr -d ' ')"
if [ "$errs" = 1 ]; then
  ok "exactly ONE journal error entry for the whole unhealthy episode"
else
  bad "$errs journal error entries, expected exactly 1 (the ps23 flood)"
fi
if [ "$progs" = 1 ]; then
  ok "exactly ONE journal progress entry on recovery"
else
  bad "$progs recovery progress entries, expected exactly 1"
fi

# ============================================================================
hr; echo "SUBTEST 5 — UNCHANGED: a host whose CLI resolves claims exactly as before"; hr

D5="$TR/healthy"; mkdir -p "$D5"
BARE5="$(seed_board "$D5" okjob)"
mkdir -p "$D5/bin"; printf '#!/bin/sh\nexit 0\n' > "$D5/bin/claude"; chmod +x "$D5/bin/claude"
env GARDEN=okhost GARDEN_STATE="$D5/gstate" \
    JOURNAL_REMOTE="$BARE5" JOURNAL_BRANCH=journal2 GARDEN_TEST=1 \
    GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_IDLE_SLEEP_CAP=2 \
    GARDEN_NO_MAINTAINER_ALERT=1 GARDEN_WORKER_HEALTH_GATE=1 \
    GARDEN_CLAUDE_BIN="$D5/bin/claude" GARDEN_JOB_HANDLER="$HERE/stub-handler.sh" \
    "$JOBS/gardener.sh" 1 > "$D5/g.log" 2>&1 || true

V5="$D5/verify"; verify_clone "$BARE5" "$V5"
if [ -f "$V5/jobs/tada/okjob.md" ]; then
  ok "the job was claimed and completed to tada/ — the gate is a no-op when healthy"
else
  bad "the healthy worker did not complete the job: $(tail -4 "$D5/g.log" | tr '\n' ' ')"
fi
if grep -q 'SELF-DISQUALIF' "$D5/g.log"; then
  bad "a healthy worker self-disqualified"
else
  ok "no self-disqualification on a healthy host"
fi
if [ -d "$D5/gstate/health/gardener.unhealthy" ]; then
  bad "a healthy worker latched an unhealthy episode"
else
  ok "no unhealthy episode latched, and no journal traffic added on the happy path"
fi
n5="$( (ls -1 "$V5/entries"/*/*/*/*-error-*.md 2>/dev/null || true) | wc -l | tr -d ' ')"
if [ "$n5" = 0 ]; then
  ok "a healthy run emits NO health entries (silent-until-error preserved)"
else
  bad "$n5 error entries on a healthy run, expected 0"
fi

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
