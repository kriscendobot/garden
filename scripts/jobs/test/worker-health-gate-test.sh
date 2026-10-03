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
# set-monks.sh refuses a cross-host write and drain-fleet.sh's marker is
# host-local — so the only actor that can take a broken worker out of rotation is
# that worker.
#
# THE INVARIANT UNDER TEST: a worker that cannot run a job never takes one.
#
#   SUBTEST 1  REGISTRY   — every worker kind declares the agent CLI its default
#                           handler drives (gardener/friar→claude, cleric/hermit/
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
#   SUBTEST 6  MODEL      — a CLI too old for the tier model parks until the
#                           installed version changes.
#   SUBTEST 7  AUTH       — a dead credential (matcher, latch, same-content park,
#                           changed-invalid park, validated recovery, codex
#                           fingerprint).
#   SUBTEST 8  AUTH SIM   — the endolin-garden2 scenario through the real poll
#                           loop: transient job, park after one failure, ONE
#                           maintainer notice, self-un-park on re-login.
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
# shellcheck source=test-fixture-helpers.sh
source "$HERE/test-fixture-helpers.sh"

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
# Keep claim admission hermetic too: usage-meter.sh is sourced before TR exists,
# so override its default live ~/.claude/projects sensor once the fixture root is
# available. An empty fixture sensor makes the generous test pool read unknown
# (fail-open), rather than inheriting this host's real subscription utilization.
export GARDEN_CCUSAGE_LOGDIR="$TR/ccusage"; mkdir -p "$GARDEN_CCUSAGE_LOGDIR"

git_id=(-c user.name=test -c user.email=test@localhost)

# seed_board <dir> <base> — throwaway origin + board holding ONE todo job.
# Prints the bare repo path.
seed_board() {
  local tr="$1" base="$2" host="${3:-healthhost}" bare="$1/journal.git" seed="$1/seed" branch=journal2 d
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$branch"
  ( cd "$seed"
    mkdir -p jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors
    for d in jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors; do touch "$d/.gitkeep"; done
    printf '# %s\n\ndo the work for %s\n' "$base" "$base" > "jobs/todo/$base.md" )
  seed_calibrated_test_pool "$seed" "$host" monk
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
check_bin monk       claude
check_bin cleric     codex
check_bin hermit     codex
check_bin mystic     kimi
check_bin fireworker codex
check_bin friar      claude

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

MARKER="$(worker_health_marker monk)"

# (a) CLI absent → the gate REFUSES and latches the episode.
export GARDEN_CLAUDE_BIN="$TR/nowhere/claude"
if worker_health_gate monk 1 2>/dev/null; then
  bad "the gate PERMITTED a claim with the agent CLI unresolvable"
else
  ok "the gate refuses to claim when the agent CLI is unresolvable"
fi
[ -d "$MARKER" ] && ok "the unhealthy episode is latched (marker present)" || bad "no episode marker latched"

# (b) further ticks and further WORKERS keep refusing — silently. This is the ps23
# flood: hundreds of near-identical error entries, one per failed job, for hours.
for i in 2 3 4 5; do worker_health_gate monk "$i" 2>/dev/null || true; done
n="$(grep -c '^unhealthy ' "$REPORTS" || true)"
if [ "${n:-0}" -eq 1 ]; then
  ok "exactly ONE unhealthy report across 5 ticks/workers (edge, not per tick)"
else
  bad "$n unhealthy reports across 5 ticks/workers, expected exactly 1"
fi

# (c) the CLI returns → the gate PERMITS again and reports recovery exactly once.
mkdir -p "$TR/late"; printf '#!/bin/sh\nexit 0\n' > "$TR/late/claude"; chmod +x "$TR/late/claude"
export GARDEN_CLAUDE_BIN="$TR/late/claude"
if worker_health_gate monk 1 2>/dev/null; then
  ok "the gate permits claiming once the agent CLI resolves again"
else
  bad "the gate still refuses though the agent CLI resolves"
fi
[ -d "$MARKER" ] && bad "the episode marker survived recovery" || ok "the episode marker is cleared on recovery"
for i in 2 3 4 5; do worker_health_gate monk "$i" 2>/dev/null || true; done
n="$(grep -c '^healthy ' "$REPORTS" || true)"
if [ "${n:-0}" -eq 1 ]; then
  ok "exactly ONE recovery report across 5 ticks/workers (edge, not per tick)"
else
  bad "$n recovery reports across 5 ticks/workers, expected exactly 1"
fi

# (d) a fresh unhealthy episode reports again — the gate is edge-triggered, not
# fire-once-per-process-lifetime.
export GARDEN_CLAUDE_BIN="$TR/nowhere/claude"
worker_health_gate monk 1 2>/dev/null || true
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
  bare="$(seed_board "$dir" "$base" "simhost-$name")"
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
  if [ -f "$V/jobs/todo/$base.md" ] && [ ! -f "$V/jobs/doin/$base.md" ] && ! fixture_has_tada "$V" "$base"; then
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
BARE="$(seed_board "$D" healjob healhost)"
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
  fixture_has_tada "$D/v2" healjob && { claimed=1; break; }
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
errs="$( (ls -1 "$D/v3/entries"/*/*/*/*-error-monk-*.md 2>/dev/null || true) | wc -l | tr -d ' ')"
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
BARE5="$(seed_board "$D5" okjob okhost)"
mkdir -p "$D5/bin"; printf '#!/bin/sh\nexit 0\n' > "$D5/bin/claude"; chmod +x "$D5/bin/claude"
env GARDEN=okhost GARDEN_STATE="$D5/gstate" \
    JOURNAL_REMOTE="$BARE5" JOURNAL_BRANCH=journal2 GARDEN_TEST=1 \
    GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_IDLE_SLEEP_CAP=2 \
    GARDEN_NO_MAINTAINER_ALERT=1 GARDEN_WORKER_HEALTH_GATE=1 \
    GARDEN_CLAUDE_BIN="$D5/bin/claude" GARDEN_JOB_HANDLER="$HERE/stub-handler.sh" \
    "$JOBS/gardener.sh" 1 > "$D5/g.log" 2>&1 || true

V5="$D5/verify"; verify_clone "$BARE5" "$V5"
if fixture_has_tada "$V5" okjob; then
  ok "the job was claimed and completed to tada/ — the gate is a no-op when healthy"
else
  bad "the healthy worker did not complete the job: $(tail -4 "$D5/g.log" | tr '\n' ' ')"
fi
if grep -q 'SELF-DISQUALIF' "$D5/g.log"; then
  bad "a healthy worker self-disqualified"
else
  ok "no self-disqualification on a healthy host"
fi
if [ -d "$D5/gstate/health/monk.unhealthy" ]; then
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

# ============================================================================
hr; echo "SUBTEST 6 — MODEL-UNSUPPORTED: a resolvable-but-too-old CLI parks the pool until the installed version CHANGES"; hr

# Regression (the oros-studio work-sink, 2026-09-27): Claude Code 2.1.267
# predated the mentor map's claude-opus-5-5, so every mentor claim died in 6–17s
# with an instant API 400 ("does not support this model; version 2.1.280 or
# newer is required") classified as a transient blip — 52 claims, 2 completions,
# 49 doomed in 6h — while the gate saw a perfectly resolvable binary. The latch
# records the INSTALLED version; the episode ends only when that string changes.

export GARDEN_STATE="$TR/state6"
export GARDEN_WORKER_HEALTH_DIR="$GARDEN_STATE/health"
export GARDEN_NO_MAINTAINER_ALERT=1
export GARDEN=modelhost
REPORTS6="$TR/reports6"; : > "$REPORTS6"
_worker_health_report() { printf '%s %s\n' "$3" "$1" >> "$REPORTS6"; }

# (a) the matcher recognizes the real wordings, and not overload text.
m400='API Error: 400 Claude Code 2.1.267 does not support this model; version 2.1.280 or newer is required.'
mwarn='[claude-code:unrecognized_model] {"model":"claude-opus-5-5","query_source":"sdk"}'
mcat="\"claude-opus-5-5\" isn't described by this version's model catalog; update Claude Code"
if is_model_unsupported_signature "$m400" && is_model_unsupported_signature "$mwarn" && is_model_unsupported_signature "$mcat"; then
  ok "is_model_unsupported_signature matches the API 400, the CLI warning, and the catalog wording"
else
  bad "is_model_unsupported_signature missed a real wording"
fi
if is_model_unsupported_signature 'API Error: 529 overloaded'; then
  bad "overload text matched the model-unsupported subset (would park hosts on ordinary blips)"
else
  ok "overload text does NOT match the model-unsupported subset"
fi

# (b) latch with a resolvable, versioned stub → the gate REFUSES though the
# binary probes healthy, reports ONCE, and repeats are silent.
mkdir -p "$TR/oldcli"
printf '#!/bin/sh\n[ "${1:-}" = --version ] && { echo "2.1.267 (Claude Code)"; exit 0; }\nexit 0\n' > "$TR/oldcli/claude"
chmod +x "$TR/oldcli/claude"
export GARDEN_CLAUDE_BIN="$TR/oldcli/claude"
MARKER6="$(worker_health_marker monk)"
worker_model_unsupported_latch monk 1 claude-opus-5-5
if [ -d "$MARKER6" ] && [ "$(cat "$MARKER6/reason" 2>/dev/null)" = model-unsupported ]; then
  ok "the latch opened a model-unsupported episode (reason recorded)"
else
  bad "no model-unsupported marker latched"
fi
if [ "$(cat "$MARKER6/cli-version" 2>/dev/null)" = "2.1.267 (Claude Code)" ]; then
  ok "the INSTALLED CLI version is recorded verbatim in the marker"
else
  bad "recorded cli-version is '$(cat "$MARKER6/cli-version" 2>/dev/null)', expected the stub's"
fi
if worker_health_gate monk 1 2>/dev/null; then
  bad "the gate PERMITTED a claim though the CLI is too old for the tier model"
else
  ok "the gate refuses to claim on a model-unsupported episode (binary resolvable or not)"
fi
worker_model_unsupported_latch monk 2 claude-opus-5-5
for i in 2 3 4; do worker_health_gate monk "$i" 2>/dev/null || true; done
n6="$(grep -c '^unhealthy ' "$REPORTS6" || true)"
if [ "${n6:-0}" -eq 1 ]; then
  ok "exactly ONE unhealthy report across repeated latches and ticks (edge, not per tick)"
else
  bad "$n6 unhealthy reports, expected exactly 1"
fi
if [ -d "$MARKER6" ]; then
  ok "the episode survives ticks while the installed version is unchanged (same-version reinstall does not clear it)"
else
  bad "the episode marker vanished without a version change"
fi

# (c) the installed version CHANGES (the update landing) → the gate permits,
# clears the marker, and reports recovery exactly once.
printf '#!/bin/sh\n[ "${1:-}" = --version ] && { echo "2.1.283 (Claude Code)"; exit 0; }\nexit 0\n' > "$TR/oldcli/claude"
chmod +x "$TR/oldcli/claude"
if worker_health_gate monk 1 2>/dev/null; then
  ok "the gate permits claiming once the installed CLI version differs from the recorded one"
else
  bad "the gate still refuses after the CLI was updated"
fi
[ -d "$MARKER6" ] && bad "the model-unsupported marker survived the version change" || ok "the marker is cleared on the version change"
for i in 2 3 4; do worker_health_gate monk "$i" 2>/dev/null || true; done
n6="$(grep -c '^healthy ' "$REPORTS6" || true)"
if [ "${n6:-0}" -eq 1 ]; then
  ok "exactly ONE recovery report (edge, not per tick)"
else
  bad "$n6 recovery reports, expected exactly 1"
fi

unset -f _worker_health_report
unset GARDEN_CLAUDE_BIN GARDEN_WORKER_HEALTH_DIR

# ============================================================================
hr; echo "SUBTEST 7 — AUTH-FAILURE: a dead credential parks the pool until the credential file CHANGES"; hr

# Regression (endolin-garden2, 2026-09-27/28): the host's Claude Code session
# expired, so every claim died in seconds with "Failed to authenticate: OAuth
# session expired and could not be refreshed" — 178 claims, 109 generic
# terminal-failure escalations in ~24h, no maintainer notice, and nothing
# stopped the host winning the next claim race. The latch records a CONTENT
# hash of the credential; the episode ends only when that content changes.

export GARDEN_STATE="$TR/state7"
export GARDEN_WORKER_HEALTH_DIR="$GARDEN_STATE/health"
export GARDEN_NO_MAINTAINER_ALERT=1
export GARDEN=authhost
REPORTS7="$TR/reports7"; : > "$REPORTS7"
_worker_health_report() { printf '%s %s %s\n' "$3" "$1" "${5:-}" >> "$REPORTS7"; }

# (a) the matcher recognizes the real wordings (the endolin-garden2 capture and
# the other Claude Code / Codex dead-credential sentences), and not a transient
# refresh-lock race, an overload, or a model rejection.
real='--- handler report (partial) ---
Failed to authenticate: OAuth session expired and could not be refreshed'
hits=0 misses=""
for t in "$real" \
    'OAuth token revoked · Please run /login' \
    'Login expired · Please run /login' \
    'API Error: 401 Invalid API key · Please run /login' \
    'Session expired. Please run /login to sign in again.' \
    'Not logged in. Run claude auth login to authenticate.' \
    'Your access token could not be refreshed. Please log out and sign in again.' \
    'Your access token could not be refreshed because your refresh token was already used. Please log out and sign in again.' \
    'no Codex credentials were found' \
    'ChatGPT account ID not available, please re-run `codex login`'; do
  if is_auth_failure_signature "$t"; then hits=$((hits+1)); else misses="$misses [$t]"; fi
done
if [ -z "$misses" ]; then
  ok "is_auth_failure_signature matches all $hits real Claude Code / Codex dead-credential wordings"
else
  bad "is_auth_failure_signature missed:$misses"
fi
for t in 'OAuth access token could not be refreshed: another Claude Code process is holding the refresh lock' \
    'API Error: 529 overloaded' \
    'API Error: 400 Claude Code 2.1.267 does not support this model; version 2.1.280 or newer is required.' \
    "You've hit your session limit · resets 2am (UTC)"; do
  if is_auth_failure_signature "$t"; then
    bad "non-auth text matched the auth-failure subset: [$t]"
  else
    ok "does NOT match: [$t]"
  fi
done
if [ "$(auth_failure_excerpt "$real")" = 'Failed to authenticate: OAuth session expired and could not be refreshed' ]; then
  ok "auth_failure_excerpt extracts the CLI's own sentence for the notice"
else
  bad "auth_failure_excerpt gave '$(auth_failure_excerpt "$real")'"
fi

# (b) latch with a resolvable CLI and a credential file → the gate REFUSES
# though the binary probes healthy, reports ONCE, repeats are silent, and an
# identical rewrite of the credential does NOT clear it.
mkdir -p "$TR/authcli" "$TR/cc7"
cat > "$TR/authcli/claude" <<'CLAUDE7_EOF'
#!/bin/sh
if [ "${1:-} ${2:-}" = "auth status" ]; then
  printf '%s\n' auth-status >> "${AUTH_STATUS_CALLS:?}"
  if grep -q '"accessToken":"fresh"' "$CLAUDE_CONFIG_DIR/.credentials.json"; then
    printf '{"loggedIn":true,"authMethod":"claude.ai"}\n'
    exit 0
  fi
  printf '{"loggedIn":false}\n'
  exit 1
fi
exit 0
CLAUDE7_EOF
chmod +x "$TR/authcli/claude"
export GARDEN_CLAUDE_BIN="$TR/authcli/claude"
export CLAUDE_CONFIG_DIR="$TR/cc7"
export AUTH_STATUS_CALLS="$TR/auth-status-calls7"; : > "$AUTH_STATUS_CALLS"
unset ANTHROPIC_API_KEY ANTHROPIC_AUTH_TOKEN || true
printf '{"claudeAiOauth":{"accessToken":"dead","refreshToken":"dead"}}\n' > "$CLAUDE_CONFIG_DIR/.credentials.json"
if [ "$(claude_credential_file)" = "$TR/cc7/.credentials.json" ]; then
  ok "claude_credential_file names the same file claude_auth_ok checks"
else
  bad "claude_credential_file gave '$(claude_credential_file)'"
fi
MARKER7="$(worker_health_marker monk)"
fp0="$(worker_credential_fingerprint monk)"
worker_auth_failure_latch monk 1 'Failed to authenticate: OAuth session expired and could not be refreshed'
if [ -d "$MARKER7" ] && [ "$(cat "$MARKER7/reason" 2>/dev/null)" = auth-failure ]; then
  ok "the latch opened an auth-failure episode (reason recorded)"
else
  bad "no auth-failure marker latched"
fi
if [ -n "$fp0" ] && [ "$(cat "$MARKER7/credential-fingerprint" 2>/dev/null)" = "$fp0" ]; then
  ok "the credential CONTENT fingerprint is recorded in the marker"
else
  bad "recorded fingerprint '$(cat "$MARKER7/credential-fingerprint" 2>/dev/null)' != '$fp0'"
fi
if grep -q '^unhealthy monk cannot AUTHENTICATE' "$REPORTS7"; then
  ok "the report carries the auth-specific headline (not 'cannot resolve their agent CLI')"
else
  bad "report headline wrong: $(cat "$REPORTS7")"
fi
if worker_health_gate monk 1 2>/dev/null; then
  bad "the gate PERMITTED a claim on a dead credential"
else
  ok "the gate refuses to claim on an auth-failure episode (binary resolvable)"
fi
worker_auth_failure_latch monk 2 'Failed to authenticate: OAuth session expired and could not be refreshed'
printf '{"claudeAiOauth":{"accessToken":"dead","refreshToken":"dead"}}\n' > "$CLAUDE_CONFIG_DIR/.credentials.json"
touch -d '+1 minute' "$CLAUDE_CONFIG_DIR/.credentials.json" 2>/dev/null || true
for i in 2 3 4; do worker_health_gate monk "$i" 2>/dev/null || true; done
n7="$(grep -c '^unhealthy ' "$REPORTS7" || true)"
if [ "${n7:-0}" -eq 1 ]; then
  ok "exactly ONE unhealthy report across repeated latches and ticks (one notice per episode)"
else
  bad "$n7 unhealthy reports, expected exactly 1"
fi
if [ -d "$MARKER7" ]; then
  ok "an IDENTICAL-content rewrite (new mtime, same bytes) does not un-park"
else
  bad "the episode cleared without the credential content changing"
fi

# (c) changed-but-still-invalid credentials fail the bounded Claude auth-status
# probe: the gate stays parked, retains the marker, and suppresses recovery.
printf '{"claudeAiOauth":{"accessToken":"different-but-dead","refreshToken":"also-dead"}}\n' > "$CLAUDE_CONFIG_DIR/.credentials.json"
if worker_health_gate monk 1 2>/dev/null; then
  bad "the gate permitted a changed credential rejected by claude auth status"
else
  ok "a changed-but-still-invalid credential remains parked after the Claude auth-status probe"
fi
if [ -d "$MARKER7" ] && [ "$(grep -c '^healthy ' "$REPORTS7" || true)" = 0 ]; then
  ok "failed auth validation retains the marker and suppresses false recovery"
else
  bad "failed auth validation removed the marker or reported recovery: $(cat "$REPORTS7")"
fi
if [ "$(wc -l < "$AUTH_STATUS_CALLS" | tr -d ' ')" = 1 ]; then
  ok "the changed credential was checked by claude auth status"
else
  bad "claude auth status call count was $(wc -l < "$AUTH_STATUS_CALLS" | tr -d ' '), expected 1"
fi

# (d) a changed credential that PASSES auth status → the gate permits, clears
# the marker, and reports recovery exactly once.
printf '{"claudeAiOauth":{"accessToken":"fresh","refreshToken":"fresh"}}\n' > "$CLAUDE_CONFIG_DIR/.credentials.json"
if worker_health_gate monk 1 2>/dev/null; then
  ok "the gate permits claiming once the credential content differs from the recorded one"
else
  bad "the gate still refuses after re-login"
fi
[ -d "$MARKER7" ] && bad "the auth-failure marker survived the re-login" || ok "the marker is cleared on the credential change"
for i in 2 3 4; do worker_health_gate monk "$i" 2>/dev/null || true; done
n7="$(grep -c '^healthy ' "$REPORTS7" || true)"
if [ "${n7:-0}" -eq 1 ]; then
  ok "exactly ONE recovery report (edge, not per tick)"
else
  bad "$n7 recovery reports, expected exactly 1"
fi

# (e) the codex side fingerprints its own login file.
export CODEX_HOME="$TR/codex7"; mkdir -p "$CODEX_HOME"
printf '{"tokens":"old"}\n' > "$CODEX_HOME/auth.json"; fc0="$(worker_credential_fingerprint cleric)"
printf '{"tokens":"new"}\n' > "$CODEX_HOME/auth.json"; fc1="$(worker_credential_fingerprint cleric)"
if [ -n "$fc0" ] && [ "$fc0" != "$fc1" ]; then
  ok "a cleric's fingerprint tracks \$CODEX_HOME/auth.json content (codex login un-parks it)"
else
  bad "cleric fingerprint did not change with auth.json ($fc0 / $fc1)"
fi
unset CODEX_HOME

unset -f _worker_health_report
unset GARDEN_CLAUDE_BIN GARDEN_WORKER_HEALTH_DIR
source "$JOBS/common.sh"   # restore the real _worker_health_report for SUBTEST 8

# ============================================================================
hr; echo "SUBTEST 8 — SIMULATION: the endolin-garden2 scenario through the REAL poll loop"; hr

# A handler that dies in a second printing the real capture text, against a
# board holding THREE jobs. Before the fix this host claimed and failed all of
# them, one generic escalation each. Now: (a) the failed job is classified
# TRANSIENT (requeue, no terminal-failure escalation), (b) the host parks after
# ONE failure and claims nothing else, (c) exactly ONE maintainer notice; then a
# re-login (credential rewrite) un-parks the host by itself.
D8="$TR/authsim"; mkdir -p "$D8/bin" "$D8/cc"
BARE8="$(seed_board "$D8" authjob-a authsimhost)"
( git clone -q --branch journal2 "$BARE8" "$D8/add" 2>/dev/null
  printf '# authjob-b\n\ndo b\n' > "$D8/add/jobs/todo/authjob-b.md"
  printf '# authjob-c\n\ndo c\n' > "$D8/add/jobs/todo/authjob-c.md"
  git -C "$D8/add" add -A && git -C "$D8/add" "${git_id[@]}" commit -q -m "two more jobs"
  git -C "$D8/add" push -q origin journal2 )
cat > "$D8/bin/claude" <<'CLAUDE8_EOF'
#!/bin/sh
if [ "${1:-} ${2:-}" = "auth status" ]; then
  if grep -q fresh "$CLAUDE_CONFIG_DIR/.credentials.json"; then
    printf '{"loggedIn":true}\n'
    exit 0
  fi
  printf '{"loggedIn":false}\n'
  exit 1
fi
exit 0
CLAUDE8_EOF
chmod +x "$D8/bin/claude"
printf '{"claudeAiOauth":{"accessToken":"expired"}}\n' > "$D8/cc/.credentials.json"
AUTHSTUB="$D8/auth-stub.sh"
cat > "$AUTHSTUB" <<'AUTHSTUB_EOF'
#!/bin/bash
# Dies like endolin-garden2's claude did while the credential is the expired one;
# runs normally once it has been rewritten (the human re-login).
set -uo pipefail
echo x >> "${AUTH_RUNS:?}"
if grep -q expired "$CLAUDE_CONFIG_DIR/.credentials.json"; then
  echo "Claude structured API error (status=unknown)."
  printf 'Failed to authenticate: OAuth session expired and could not be refreshed\n' > "${3:?}"
  exit 1
fi
printf '# report\nok\n' > "${3:?}"
[ -n "${GARDEN_COMPLETION_SENTINEL:-}" ] && : > "$GARDEN_COMPLETION_SENTINEL"
exit 0
AUTHSTUB_EOF
chmod +x "$AUTHSTUB"
ALERTS8="$D8/alerts"; : > "$ALERTS8"
ALERTCMD="$D8/alert-cmd.sh"
printf '#!/bin/sh\nprintf "%%s|%%s\\n" "$1" "$(printf "%%s" "$2" | head -n1)" >> "%s"\n' "$ALERTS8" > "$ALERTCMD"
chmod +x "$ALERTCMD"
: > "$D8/runs"

set -m
env GARDEN=authsimhost GARDEN_STATE="$D8/gstate" \
    JOURNAL_REMOTE="$BARE8" JOURNAL_BRANCH=journal2 GARDEN_TEST=1 \
    GARDEN_ONESHOT=0 GARDEN_IDLE_SLEEP=1 GARDEN_IDLE_SLEEP_CAP=2 \
    GARDEN_ALERT_CMD="$ALERTCMD" GARDEN_NO_MAINTAINER_ALERT=0 GARDEN_WORKER_HEALTH_GATE=1 \
    GARDEN_CLAUDE_BIN="$D8/bin/claude" CLAUDE_CONFIG_DIR="$D8/cc" \
    AUTH_RUNS="$D8/runs" GARDEN_JOB_HANDLER="$AUTHSTUB" \
    "$JOBS/gardener.sh" 1 > "$D8/g.log" 2>&1 &
GPID8=$!
set +m

# Wait for the first failure to latch, then give it several more ticks.
for _ in $(seq 1 60); do
  [ -d "$D8/gstate/health" ] && ls "$D8/gstate/health" 2>/dev/null | grep -q unhealthy && break
  sleep 1
done
sleep 6
runs="$(wc -l < "$D8/runs" | tr -d ' ')"
if grep -q 'credential rejected (re-login required); SELF-DISQUALIFIED' "$D8/g.log"; then
  ok "the park log names the cause (credential rejected), not 'agent CLI unresolvable'"
else
  bad "park log does not name the auth cause: $(grep SELF-DISQ "$D8/g.log" | tail -1)"
fi
if [ "$runs" = 1 ]; then
  ok "(b) the host PARKED after ONE auth failure — the handler ran once for three available jobs"
else
  bad "(b) the handler ran $runs times before parking, expected 1: $(tail -5 "$D8/g.log" | tr '\n' ' ')"
fi
if grep -q "AUTHENTICATION failure" "$D8/g.log" && grep -q "authjob-.* looks transient" "$D8/g.log" \
    && ! grep -q "published a bounded health cooldown" "$D8/g.log"; then
  ok "(a) the failed job was classified TRANSIENT (requeue), not escalated as a terminal failure"
else
  bad "(a) classification wrong: $(grep -E 'transient|DETERMINISTIC|escalat' "$D8/g.log" | tail -3 | tr '\n' ' ')"
fi
V8="$D8/v1"; verify_clone "$BARE8" "$V8"
todo8="$(ls "$V8/jobs/todo" | grep -c '^authjob-' || true)"
if [ "$todo8" = 2 ]; then
  ok "the other two jobs were never claimed (still in todo/)"
else
  bad "$todo8 authjob-* left in todo/, expected 2"
fi
na="$(grep -c '^worker-agent-bin-' "$ALERTS8" || true)"
if [ "$na" = 1 ] && grep -q 'cannot AUTHENTICATE' "$ALERTS8"; then
  ok "(c) exactly ONE maintainer notice for the episode: $(head -1 "$ALERTS8" | cut -c1-140)"
else
  bad "(c) $na maintainer notices (expected 1): $(cat "$ALERTS8" | cut -c1-160 | tr '\n' ' ')"
fi
if grep -q 'Failed to authenticate: OAuth session expired' "$D8/gstate/health/"*.unhealthy/excerpt 2>/dev/null; then
  ok "the episode marker carries the CLI's own sentence"
else
  bad "no excerpt recorded in the marker"
fi

# The human re-logs in: the credential file is rewritten. Nothing restarts the
# worker — it must un-park by itself and work the remaining jobs.
printf '{"claudeAiOauth":{"accessToken":"fresh"}}\n' > "$D8/cc/.credentials.json"
# The failed job stays in doin/ for the reaper's requeue (not this worker's to
# re-run); the OTHER two must now complete here.
failed8="$(basename "$(ls "$V8/jobs/doin"/authjob-*.md 2>/dev/null | head -n1)" .md)"
resumed=0
for _ in $(seq 1 60); do
  verify_clone "$BARE8" "$D8/v2"
  left=0
  for j in authjob-a authjob-b authjob-c; do
    [ "$j" = "$failed8" ] && continue
    fixture_has_tada "$D8/v2" "$j" || left=1
  done
  [ -n "$failed8" ] && [ "$left" = 0 ] && { resumed=1; break; }
  sleep 1
done
kill -TERM "$GPID8" 2>/dev/null || true
wait "$GPID8" 2>/dev/null || true
if [ "$resumed" = 1 ]; then
  ok "the host UN-PARKED by itself after the re-login and completed the two remaining jobs ('$failed8' awaits the reaper's requeue)"
else
  bad "the host did not resume after re-login: $(tail -5 "$D8/g.log" | tr '\n' ' ')"
fi
if grep -q '^worker-agent-bin-.*|RECOVERED:.*CHANGED credential' "$ALERTS8" && [ "$(grep -c '^worker-agent-bin-' "$ALERTS8")" = 2 ]; then
  ok "exactly one RECOVERED notice closes the episode"
else
  bad "recovery notices wrong: $(cat "$ALERTS8" | cut -c1-120 | tr '\n' ' ')"
fi

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
