#!/bin/bash
# rolling-deploy.sh — the LEADER-ONLY rolling-deploy conductor. NO LLM.
#
# Usage: rolling-deploy.sh   (leader-only oneshot, driven by garden-rolling-deploy.timer)
#
# The garden advances the deployed version fleet-wide with NO human on the critical
# path (designs/follower-self-deploy.md). This conductor is the leader half: it rolls
# followers first as CANARIES — one at a time by default — validates each, and
# advances the LEADER ITSELF LAST, and never on a failed canary. The per-host deploy
# is the identical, already-hardened deploy-garden.sh; this script adds only the
# ORCHESTRATION: which host advances when, how a follower is released and validated,
# and what fires the leader's own advance.
#
# THE ATTESTATION BOUNDARY IS UNTOUCHED (the crux, designs § Reconciliation A). The
# conductor issues NO sysop `deploy` op. The only bus messages it may send are
# BENIGN-tier `drain` ops (issuer-gated, no maintainer attestation). To release a
# follower it writes a JOURNAL release token deploy/roll/<GARDEN> — which is NOT a
# sysop op and NOT a deploy trigger: the follower's own garden-self-deploy daemon
# still requires its independent host-local `upgrade-ready` cryptographic fact to
# move, and only ever advances to origin/main2's tip. A forged or stray token can
# therefore only permit a host to reach the canonical tip it would reach anyway; it
# cannot make a follower deploy arbitrary code. So the sysop `deploy` op and its
# maintainer attestation are never routed through by the rolling deploy.
#
# The conductor is DETERMINISTIC and EVENT-DRIVEN (like orchestrate.sh / unblock.sh):
# each tick reads local signals + journal state and advances the roll AT MOST ONE
# step, then exits — a probe that must reach tada/ within a 10-minute deadline is
# watched across ticks, never blocked on inside one. Leader-only via the unit's
# ExecCondition=is-main-host.sh (a second in-process guard here is belt-and-suspenders).
#
# Test seams (all overridable so the harness drives the state machine with no real
# deploy, no real probe worker, and a throwaway journal):
#   GARDEN_ROLLING_CLONE        read clone (leader's journal view)
#   GARDEN_ROLLING_STATE        host-local per-target roll state
#   GARDEN_ROLLING_DEPLOY_CMD   invoke the real per-host deploy (default deploy-garden.sh)
#   GARDEN_ROLLING_POST_JOB     post the canary probe job (default post-job.sh)
#   GARDEN_ROLLING_DRAIN_OP     send a benign drain op to a host (default send-host-op.sh)
#   GARDEN_ROLL_REGRESSION_CMD  optional deterministic regression check <host> <sha> (default: pass)
#   GARDEN_ROLL_PREDRAIN        1 → send a benign `drain on` before releasing a canary (default 0)
#   GARDEN_ROLLING_NOW          fixed epoch seconds (default: date +%s)

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="rolling-deploy"

require_tools git

# Belt-and-suspenders leader gate (the unit's ExecCondition already gates; this makes
# a stray direct run on a follower a clean no-op too).
is_main_host || { log "not the leader; skipping (rolling deploy is leader-orchestrated)"; exit 0; }

# A drain owns this host (an operator pause, or deploy-garden.sh mid-swap on the
# leader itself). Do not drive the roll while the leader is draining.
fleet_draining && { log "leader is draining; skipping this roll tick"; exit 0; }

DIR="${GARDEN_ROLLING_CLONE:-$GARDEN_STATE/rolling-deploy/journal}"
STATE="${GARDEN_ROLLING_STATE:-$GARDEN_STATE/rolling-deploy}"
DEPLOY_CMD="${GARDEN_ROLLING_DEPLOY_CMD:-$HERE/deploy-garden.sh}"
POST_JOB="${GARDEN_ROLLING_POST_JOB:-$HERE/post-job.sh}"
DRAIN_OP="${GARDEN_ROLLING_DRAIN_OP:-$HERE/send-host-op.sh}"
mkdir -p "$STATE" 2>/dev/null || true

now_s() { if [ -n "${GARDEN_ROLLING_NOW:-}" ]; then printf '%s\n' "$GARDEN_ROLLING_NOW"; else date +%s; fi; }

# set -e / pipefail-safe single-line file readers (a `cat missing | head` fails the
# pipeline under pipefail, which would abort the whole tick; these never fail).
rdsha()  { [ -f "$1" ] && head -n1 "$1" 2>/dev/null | tr -d '[:space:]' || true; }
rdline() { [ -f "$1" ] && head -n1 "$1" 2>/dev/null || true; }

ensure_clone "$DIR"
sync_clone "$DIR"

# --- CAS write of one journal file (release token, leader-sha) ---------------
journal_put() {  # journal_put <relpath> <content> <commitmsg>
  local rel="$1" content="$2" msg="$3"
  local PDIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}" attempt rc
  ensure_clone "$PDIR"
  for attempt in $(seq 1 25); do
    sync_clone "$PDIR"
    mkdir -p "$(dirname "$PDIR/$rel")" 2>/dev/null || true
    printf '%s\n' "$content" > "$PDIR/$rel"
    git -C "$PDIR" add "$rel"
    rc=0; commit_and_push "$PDIR" "$msg" || rc=$?
    { [ "$rc" -eq 0 ] || [ "$rc" -eq 2 ]; } && return 0
    backoff "$attempt"
  done
  return 1
}
journal_rm() {  # journal_rm <relpath> <commitmsg>  (best-effort)
  local rel="$1" msg="$2"
  local PDIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}" attempt rc
  ensure_clone "$PDIR"
  for attempt in $(seq 1 25); do
    sync_clone "$PDIR"
    [ -e "$PDIR/$rel" ] || return 0
    git -C "$PDIR" rm -q "$rel" 2>/dev/null || return 0
    rc=0; commit_and_push "$PDIR" "$msg" || rc=$?
    { [ "$rc" -eq 0 ] || [ "$rc" -eq 2 ]; } && return 0
    backoff "$attempt"
  done
  return 1
}

# --- journal readers (from the synced read clone) ----------------------------
follower_deployed_sha() { rdsha "$DIR/$GARDEN_FLEET_DEPLOYED_PATH/$1"; }
follower_health_field() { local f="$DIR/$GARDEN_FLEET_HEALTH_PATH/$1"; [ -f "$f" ] && sed -n "s/^$2:[[:space:]]*//p" "$f" 2>/dev/null | head -1 || true; }
release_token() { rdsha "$DIR/$GARDEN_DEPLOY_ROLL_PATH/$1"; }

# The follower set: every host with a hosts/<h> record, minus the leader, sorted.
follower_hosts() {
  local h b
  for h in "$DIR"/hosts/*; do
    [ -e "$h" ] || continue
    b="$(basename "$h")"
    case "$b" in .gitkeep) continue ;; esac
    [ "$b" = "$GARDEN" ] && continue
    printf '%s\n' "$b"
  done | sort
}

# --- host-local per-target roll state ----------------------------------------
sd() { printf '%s\n' "${1:0:12}"; }   # short sha for state dir / names
roll_dir() { printf '%s/roll/%s\n' "$STATE" "$(sd "$1")"; }
rstat_get() { rdline "$(roll_dir "$1")/$2.status"; }
rstat_set() { local d; d="$(roll_dir "$1")"; mkdir -p "$d" 2>/dev/null || true; printf '%s\n' "$3" > "$d/$2.status"; }
rfield_get() { rdline "$(roll_dir "$1")/$2.$3"; }
rfield_set() { local d; d="$(roll_dir "$1")"; mkdir -p "$d" 2>/dev/null || true; printf '%s\n' "$4" > "$d/$2.$3"; }

# --- validation: unit health + round-trip probe + regression watch -----------
# Returns 0 pass, 1 fail, 2 still-waiting (probe not yet terminal). Event-driven:
# posts the probe once, then reads its tada/ across ticks bounded by the deadline.
validate_canary() {  # validate_canary <host> <target>
  local host="$1" target="$2"

  # (a) unit health, from the follower's published post-deploy health record: the
  # gate is "NONE FAILED" (a crash-loop / a unit dead after the restart), not "all
  # active" — most garden units are timer-driven oneshots, legitimately inactive
  # between firings (fleet_unit_health, common.sh).
  local uf fb; uf="$(follower_health_field "$host" unit_failures)"; fb="$(follower_health_field "$host" first_bad_unit)"
  if ! [[ "$uf" =~ ^[0-9]+$ ]]; then VAL_DETAIL="no unit-health record published"; return 1; fi
  if [ "$uf" -ne 0 ]; then VAL_DETAIL="$uf failed unit(s) (first: ${fb:-?})"; return 1; fi
  [ "${fb:-"-"}" = "-" ] || { VAL_DETAIL="unit $fb failed"; return 1; }

  # (b) round-trip probe: a synthetic host-pinned no-op job that must reach tada/.
  local probe posted_at now
  probe="$(rfield_get "$target" "$host" probe_base)"
  now="$(now_s)"
  if [ -z "$probe" ]; then
    probe="canary-probe-$host-$(sd "$target")"
    # Deterministic (no LLM): requires host-pin + canary-probe short-circuit in the
    # worker spine (gardener.sh). handler-timeout small: it never runs a handler.
    local body; body="$(mktemp "${TMPDIR:-/tmp}/canary-probe.XXXXXX")"
    {
      printf -- '---\n'
      printf 'requires: host=%s\n' "$host"
      printf 'canary-probe: true\n'
      printf 'handler-timeout: 120\n'
      printf -- '---\n'
      printf '# rolling-deploy canary probe for %s @ %s\n\n' "$host" "$(sd "$target")"
      printf 'Synthetic no-op round-trip probe: claim -> complete -> tada on the freshly deployed code.\n'
    } > "$body"
    "$POST_JOB" "$probe" "$body" >/dev/null 2>&1 || { rm -f "$body"; VAL_DETAIL="could not post probe job"; return 2; }
    rm -f "$body"
    rfield_set "$target" "$host" probe_base "$probe"
    rfield_set "$target" "$host" probe_posted_at "$now"
    log "canary $host: posted round-trip probe '$probe' (deadline ${GARDEN_CANARY_PROBE_DEADLINE}s)"
    VAL_DETAIL="probe posted; awaiting tada"; return 2
  fi
  posted_at="$(rfield_get "$target" "$host" probe_posted_at)"; : "${posted_at:=$now}"
  if tada_exists "$DIR" "$probe"; then
    :  # probe completed — fall through to the regression watch
  else
    if [ $(( now - posted_at )) -ge "$GARDEN_CANARY_PROBE_DEADLINE" ]; then
      VAL_DETAIL="probe '$probe' did not reach tada within ${GARDEN_CANARY_PROBE_DEADLINE}s (claim/spine broken on new code)"
      return 1
    fi
    VAL_DETAIL="probe '$probe' in flight ($(( now - posted_at ))s / ${GARDEN_CANARY_PROBE_DEADLINE}s)"
    return 2
  fi

  # (c) regression watch: the probe round-trip IS the claim-liveness + completion
  # signal the maintainer named (the self-throttle-to-zero failure class shows up as
  # a probe that never claims). A deeper failure-rate scan is a deterministic seam;
  # when unset the successful probe within the watch window is sufficient evidence.
  if [ -n "${GARDEN_ROLL_REGRESSION_CMD:-}" ]; then
    if ! "$GARDEN_ROLL_REGRESSION_CMD" "$host" "$target" >/dev/null 2>&1; then
      VAL_DETAIL="regression watch flagged $host (GARDEN_ROLL_REGRESSION_CMD non-zero)"
      return 1
    fi
  fi
  VAL_DETAIL="units all active + probe round-trip OK"
  return 0
}

# --- halt: page once, leave the canary drained, never advance the leader -----
halt_roll() {  # halt_roll <host> <target> <reason>
  local host="$1" target="$2" reason="$3"
  rstat_set "$target" "$host" failed
  # Leave the failed canary DRAINED so it stops taking real work on a suspect version
  # (a BENIGN drain op — no attestation). Best-effort; the alert is the load-bearing part.
  "$DRAIN_OP" "$host" op=drain state=on reason="rolling-deploy: canary FAILED validation ($reason)" >/dev/null 2>&1 \
    || log "WARN: could not send benign drain-on to failed canary $host"
  alert_maintainer "rolling-deploy-canary-failed-$host" \
"Rolling deploy HALTED on a failed canary.
canary host: $host
target sha:  $target
failing signal: $reason
The roll released no further followers and the LEADER did NOT advance itself — a
broken tip that fails a canary never reaches the leader. The canary was left DRAINED
(benign drain op) pending your decision; auto-rollback is deliberately not performed
(designs/follower-self-deploy.md § Failure handling). Investigate the target on $host,
then lift its drain and re-trigger, or hold the tip. (leader=$GARDEN)"
  log "HALTED: canary $host failed validation for ${target:0:12}: $reason — leader will NOT advance; canary left drained"
}

# =============================================================================
# --- the tick ---------------------------------------------------------------

# The leader's own host-local upgrade-ready signal is the deploy DECISION (a
# cryptographic ancestry fact, never a bus message). Absent → the leader is current.
if [ ! -e "$GARDEN_UPGRADE_READY_MARKER" ]; then
  log "leader deployed version is current (no upgrade-ready signal); nothing to roll"
  exit 0
fi
target="$( { sed -n 's/^available:[[:space:]]*//p' "$GARDEN_UPGRADE_READY_MARKER" 2>/dev/null || true; } | head -1 | tr -d '[:space:]')"
[ -n "$target" ] || { log "WARN: upgrade-ready signal present but no 'available:' sha parsed; skipping"; exit 0; }

# --- settle window (a FLOOR on tip age; the clock restarts on a new target) ---
settle_file="$STATE/settle/$(sd "$target")"
mkdir -p "$(dirname "$settle_file")" 2>/dev/null || true
now="$(now_s)"
first_seen="$(rdline "$settle_file")"
if ! [[ "$first_seen" =~ ^[0-9]+$ ]]; then first_seen="$now"; printf '%s\n' "$now" > "$settle_file"; fi
waited=$(( now - first_seen ))
if [ "$waited" -lt "$GARDEN_SELF_DEPLOY_SETTLE" ]; then
  log "target ${target:0:12} settling (${waited}s/${GARDEN_SELF_DEPLOY_SETTLE}s); not rolling yet"
  exit 0
fi

# --- degenerate fleet: leader-only (no followers = no canary by construction) -
mapfile -t followers < <(follower_hosts)
if [ "${#followers[@]}" -eq 0 ]; then
  log "leader-only fleet (no followers to canary); self-deploying directly on the settled upgrade-ready — today's solo-leader behavior"
  "$DEPLOY_CMD" || log "WARN: leader self-deploy returned non-zero (deploy-garden.sh manages its own drain/abort)"
  exit 0
fi

# --- roll the followers, one canary at a time (default batch=1) --------------
# Walk followers in deterministic order. For the current canary: release it if not
# yet released; skip it if operator-drained; validate it once it has deployed; halt
# on a failed validation. The leader advances itself only after the loop finds every
# follower passed-or-skipped (§ leader self-deploy, made concrete).
passed_any=0; skipped_all=1
for f in "${followers[@]}"; do
  st="$(rstat_get "$target" "$f")"
  case "$st" in
    passed)  passed_any=1; skipped_all=0; continue ;;
    skipped) continue ;;
    failed)  log "roll already HALTED at failed canary $f for ${target:0:12}; leader holds"; exit 0 ;;
  esac
  skipped_all=0

  # Not yet released for this target? Release it (batch=1 → only one in flight).
  if [ "$(release_token "$f")" != "$target" ]; then
    if [ "${GARDEN_ROLL_PREDRAIN:-0}" = "1" ]; then
      "$DRAIN_OP" "$f" op=drain state=on reason="rolling-deploy: pre-drain canary before release" >/dev/null 2>&1 || true
    fi
    if journal_put "$GARDEN_DEPLOY_ROLL_PATH/$f" "$target" "deploy/roll($f)=${target:0:12} (canary release by $GARDEN)"; then
      rstat_set "$target" "$f" released
      rfield_set "$target" "$f" released_at "$now"
      log "released canary $f to advance to ${target:0:12} (release token written); awaiting its deploy"
    else
      log "WARN: could not write release token for $f; retrying next tick"
    fi
    exit 0
  fi

  # Released. Did the follower DECLINE because it is operator-drained? (It publishes
  # roll_status: operator-drained with its un-advanced sha.) Skip it — a paused host
  # cannot validate, and self-deploying it out from under an operator is forbidden.
  if [ "$(follower_health_field "$f" roll_status)" = operator-drained ]; then
    rstat_set "$target" "$f" skipped
    log "canary $f is operator-drained; SKIPPING it (roll proceeds with the remaining followers)"
    continue
  fi

  # Released but not yet deployed to the target?
  if [ "$(follower_deployed_sha "$f")" != "$target" ]; then
    ra="$(rfield_get "$target" "$f" released_at)"; : "${ra:=$now}"
    # A generous deploy budget: the follower's deploy-garden.sh may DEFER behind a long
    # in-flight job. Bound it by the probe deadline + watch so a follower that never
    # advances is eventually a failed canary, not an infinite wait.
    local_budget=$(( GARDEN_CANARY_PROBE_DEADLINE + GARDEN_CANARY_WATCH ))
    if [ $(( now - ra )) -ge "$local_budget" ]; then
      halt_roll "$f" "$target" "released ${local_budget}s ago but never advanced to the target sha (deploy stuck/failed on the canary)"
      exit 0
    fi
    log "canary $f released; awaiting its deploy to ${target:0:12} ($(( now - ra ))s/${local_budget}s)"
    exit 0
  fi

  # Deployed to the target → VALIDATE (unit health + probe + regression).
  VAL_DETAIL=""
  set +e; validate_canary "$f" "$target"; vrc=$?; set -e
  case "$vrc" in
    0) rstat_set "$target" "$f" passed; passed_any=1
       log "canary $f PASSED for ${target:0:12}: $VAL_DETAIL"
       # Clear the release token now that this canary is validated (tidy; not required).
       journal_rm "$GARDEN_DEPLOY_ROLL_PATH/$f" "deploy/roll($f) cleared (canary passed) by $GARDEN" || true
       alert_maintainer_clear "rolling-deploy-canary-failed-$f" "canary $f passed a later roll; clearing." || true
       continue ;;
    2) log "canary $f validating for ${target:0:12}: $VAL_DETAIL"; exit 0 ;;
    *) halt_roll "$f" "$target" "$VAL_DETAIL"; exit 0 ;;
  esac
done

# --- every follower passed or was skipped ------------------------------------
if [ "$passed_any" -eq 1 ]; then
  log "all required canaries passed for ${target:0:12}; leader self-deploying LAST"
  "$DEPLOY_CMD" || log "WARN: leader self-deploy returned non-zero (deploy-garden.sh manages its own drain/abort)"
  # On success deploy-garden.sh records the new sha; the upgrade-monitor clears the
  # signal next tick and this roll's state ages out.
  exit 0
fi

# Every follower was operator-drained → the fleet has NO available canary because a
# human paused them all. Design open question — leaning HOLD: treat "a human paused
# all followers" as a signal to WAIT for the human, not to deploy the leader
# unvalidated. Page once so the operator knows the leader is holding.
if [ "$skipped_all" -eq 1 ] || [ "$passed_any" -eq 0 ]; then
  alert_maintainer "rolling-deploy-all-followers-drained-$GARDEN" \
"Rolling deploy is HOLDING the leader: every follower is operator-drained, so there
is no available canary to validate ${target:0:12}. Per designs/follower-self-deploy.md
this is treated as a signal to wait for you, not to advance the leader unvalidated.
Lift a follower's drain to give the roll a canary, or deploy the leader by hand if you
accept an unvalidated advance. (leader=$GARDEN)"
  log "HOLDING leader: all followers operator-drained; no canary available for ${target:0:12}"
fi
exit 0
