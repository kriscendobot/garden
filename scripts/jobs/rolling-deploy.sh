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
# move, and only ever advances to the released sha, which deploy-garden.sh refuses
# unless it lies on origin/main2. A forged or stray token can therefore only permit a
# host to reach a point on the canonical branch; it cannot make a follower deploy
# arbitrary code.
#
# EVERY deploy this conductor fires is PINNED (GARDEN_DEPLOY_TARGET) to the sha the
# canaries validated. An unpinned deploy-garden.sh advances to whatever
# origin/main2 is at that moment, so main2 advancing mid-roll put unvalidated
# commits on the leader (roll 48ee7a on 2026-09-23 landed 3d453e). A roll is
# recorded complete only once the leader's deployed sha is the target: deploy-garden
# exits 0 on a DEFER too, which once logged roll 987bb13 "completed" ten times while
# the leader never moved. So the sysop `deploy` op and its
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
#   GARDEN_ROLLING_ANCESTOR_CMD optional <a> <b> → rc0 iff a is an ancestor-or-equal
#                               of b (default: git in $GARDEN_ROOT)
#   GARDEN_ROLL_STUCK_CANARY_AFTER seconds a released follower may stay undeployed
#                               before the stuck-canary notice (default: 20 min)
#   GARDEN_HOST_OFFLINE_AFTER   max budget/live heartbeat age (default: 30 min)

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

: "${GARDEN_ROLL_STUCK_CANARY_AFTER:=1200}"

is_ancestor() {  # is_ancestor <a> <b> → rc0 iff a is an ancestor-or-equal of b
  [ "$1" = "$2" ] && return 0
  if [ -n "${GARDEN_ROLLING_ANCESTOR_CMD:-}" ]; then
    "$GARDEN_ROLLING_ANCESTOR_CMD" "$1" "$2" >/dev/null 2>&1
    return
  fi
  git -C "$GARDEN_ROOT" merge-base --is-ancestor "$1" "$2" 2>/dev/null
}

# The leader's own (last-wave or solo) deploy, pinned to the validated target.
leader_deploy() {  # leader_deploy <target>
  GARDEN_DEPLOY_TARGET="$1" "$DEPLOY_CMD"
}

ensure_clone "$DIR"
sync_clone "$DIR"

# --- CAS write of one journal file (release token, leader-sha) ---------------
journal_put() {  # journal_put <relpath> <content> <commitmsg>
  local rel="$1" content="$2" msg="$3"
  local PDIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}" attempt rc put_start
  ensure_clone "$PDIR"
  # Overall wall-clock deadline (same shape as post-job.sh, commit 5db2500cee).
  # Attempt COUNT (25) alone does not bound elapsed time: each sync_clone can burn
  # ~GARDEN_FETCH_TIMEOUT+GARDEN_FETCH_KILL_AFTER seconds under DEGRADED (not cleanly
  # offline) connectivity, so 25 attempts plus growing backoff can exceed the unit's
  # TimeoutStartSec (900s) and end in a blunt SIGTERM/kill mid-deploy instead of a
  # clean skip. Bail EX_TEMPFAIL once the bound is exceeded — self-heal-run.sh
  # normalizes GARDEN_OFFLINE_RC to a clean exit 0, so a degraded episode fails fast
  # and clean and the next idempotent tick resumes the roll. A design-intended push
  # race is sub-second, so the deadline never trims a healthy loop.
  put_start=$SECONDS
  for attempt in $(seq 1 25); do
    if [ $((SECONDS - put_start)) -ge "${GARDEN_POST_DEADLINE_SECS:-300}" ]; then
      log "journal_put of '$rel' exceeded ${GARDEN_POST_DEADLINE_SECS:-300}s wall-clock deadline under degraded connectivity (attempt $attempt); skipping tick (rc=$GARDEN_OFFLINE_RC)"
      exit "$GARDEN_OFFLINE_RC"
    fi
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
  local PDIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}" attempt rc rm_start
  ensure_clone "$PDIR"
  # Same overall wall-clock deadline as journal_put (see its note): attempt COUNT
  # alone does not bound elapsed time under degraded connectivity, so bail
  # EX_TEMPFAIL once the bound is exceeded rather than grinding into a unit kill.
  rm_start=$SECONDS
  for attempt in $(seq 1 25); do
    if [ $((SECONDS - rm_start)) -ge "${GARDEN_POST_DEADLINE_SECS:-300}" ]; then
      log "journal_rm of '$rel' exceeded ${GARDEN_POST_DEADLINE_SECS:-300}s wall-clock deadline under degraded connectivity (attempt $attempt); skipping tick (rc=$GARDEN_OFFLINE_RC)"
      exit "$GARDEN_OFFLINE_RC"
    fi
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

# Every configured follower, including an offline one. Dot-prefixed archived host
# records are deliberately outside the glob: returning from offline does NOT undo an
# operator's archival decision.
all_follower_hosts() {
  local h b
  for h in "$DIR"/hosts/*; do
    [ -e "$h" ] || continue
    b="$(basename "$h")"
    case "$b" in .gitkeep) continue ;; esac
    [ "$b" = "$GARDEN" ] && continue
    printf '%s\n' "$b"
  done | sort
}

# The authoritative liveness fact is the periodically refreshed budget heartbeat,
# NOT fleet/health (which is deploy-event-only and can look healthy for days after a
# host dies). A host can contribute to more than one pool; its freshest heartbeat is
# authoritative. Legacy flat budget/live/<host> records remain readable during the
# rolling format migration.
host_heartbeat_epoch() {  # host_heartbeat_epoch <host>
  local host="$1" file at latest=""
  for file in "$DIR"/budget/live/*/"$host" "$DIR"/budget/live/"$host"; do
    [ -f "$file" ] || continue
    at="$(sed -n 's/^sampled_at_epoch:[[:space:]]*//p' "$file" 2>/dev/null | head -1)"
    if ! [[ "$at" =~ ^[0-9]+$ ]]; then
      at="$(sed -n 's/^sampled_at:[[:space:]]*//p' "$file" 2>/dev/null | head -1)"
      at="$(date -u -d "$at" +%s 2>/dev/null || true)"
    fi
    [[ "$at" =~ ^[0-9]+$ ]] || continue
    { [ -z "$latest" ] || [ "$at" -gt "$latest" ]; } && latest="$at"
  done
  printf '%s\n' "$latest"
}

HOST_LIVENESS_DETAIL=""
host_is_online() {  # host_is_online <host>; detail is suitable for logs/records
  local host="$1" sampled age
  sampled="$(host_heartbeat_epoch "$host")"
  if ! [[ "$sampled" =~ ^[0-9]+$ ]]; then
    HOST_LIVENESS_DETAIL="no budget/live heartbeat"
    return 1
  fi
  age=$(( now - sampled )); [ "$age" -lt 0 ] && age=0
  if [ "$age" -gt "$GARDEN_HOST_OFFLINE_AFTER" ]; then
    HOST_LIVENESS_DETAIL="heartbeat stale by ${age}s (offline threshold ${GARDEN_HOST_OFFLINE_AFTER}s; sampled_at_epoch=$sampled)"
    return 1
  fi
  HOST_LIVENESS_DETAIL="heartbeat fresh (${age}s old; sampled_at_epoch=$sampled)"
  return 0
}

# Public selection predicate: only PRESENT peers enter the canary rotation. Offline
# peers are classified before a release/deploy budget can begin.
follower_hosts() {
  local h
  while IFS= read -r h; do
    host_is_online "$h" && printf '%s\n' "$h"
  done < <(all_follower_hosts)
}

roll_completion_record() {  # roll_completion_record <target>
  local target="$1" h st reason passed="" skipped=""
  while IFS= read -r h; do
    st="$(rstat_get "$target" "$h")"
    case "$st" in
      passed) passed="${passed}${passed:+,}$h" ;;
      skipped)
        reason="$(rfield_get "$target" "$h" skip_reason)"; : "${reason:=drained}"
        skipped="${skipped}${skipped:+; }$h ($reason)"
        ;;
    esac
  done < <(all_follower_hosts)
  printf 'target: %s\nleader: %s\ncompleted_at: %s\npassed_canaries: %s\nskipped_peers: %s\n' \
    "$target" "$GARDEN" "$(date -u -d "@$now" +%FT%TZ)" "${passed:--}" "${skipped:--}"
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
  # An ADVISORY posture probe (garden_unit_is_advisory, common.sh) is never a deploy
  # regression. Current publishers already exclude it from unit_failures; this also
  # forgives a record whose ONLY failure is such a probe (an older publisher).
  if [ "$uf" -eq 1 ] && [ -n "$fb" ] && [ "$fb" != "-" ] && garden_unit_is_advisory "$fb"; then uf=0; fb="-"; fi
  if [ "$uf" -ne 0 ]; then VAL_DETAIL="$uf failed unit(s) (first: ${fb:-?})"; return 1; fi
  [ "${fb:-"-"}" = "-" ] || { VAL_DETAIL="unit $fb failed"; return 1; }

  # (b) round-trip probe: a synthetic host-pinned no-op job that must reach tada/.
  local probe posted_at now
  probe="$(rfield_get "$target" "$host" probe_base)"
  now="$(now_s)"
  if [ -z "$probe" ]; then
    # Attempt-suffix the probe base so a RETRY posts a fresh job rather than matching a
    # previous attempt's stale tada (retries==0 → no suffix, the first-attempt name).
    local tries suffix=""; tries="$(rfield_get "$target" "$host" retries)"
    [[ "$tries" =~ ^[0-9]+$ ]] && [ "$tries" -gt 0 ] && suffix="-r$tries"
    probe="canary-probe-$host-$(sd "$target")$suffix"
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

# --- roll_drain: leave a suspect canary drained with ROLL provenance ----------
# A BENIGN drain op (no attestation), stamped source=rolling-deploy so self-deploy and
# this conductor can tell it apart from an operator pause and RETRY it — the fix for the
# deadlock where a roll-set drain was indistinguishable from an operator drain and
# permanently excluded the canary (designs/follower-self-deploy.md § Failure handling).
roll_drain() {  # roll_drain <host> <reason>
  "$DRAIN_OP" "$1" op=drain state=on source="$GARDEN_DRAIN_SOURCE_ROLL" reason="rolling-deploy: $2" >/dev/null 2>&1 \
    || log "WARN: could not send benign roll-induced drain-on to canary $1"
}
roll_undrain() {  # roll_undrain <host> <reason>
  "$DRAIN_OP" "$1" op=drain state=off reason="rolling-deploy: $2" >/dev/null 2>&1 \
    || log "WARN: could not send drain-off to canary $1"
}

# --- retry_or_halt: a FRESH validation/deploy failure of a canary ------------
# A roll-induced canary drain is RETRYABLE. Under the retry budget: drain the suspect
# canary (roll provenance) and schedule a retry (rstat retry-wait); the conductor lifts
# the drain and re-releases it after a backoff. When the budget is exhausted: fall
# through to a terminal halt that pages LOUDLY and leaves it drained for a human.
retry_or_halt() {  # retry_or_halt <host> <target> <reason>
  local host="$1" target="$2" reason="$3" tries
  tries="$(rfield_get "$target" "$host" retries)"; [[ "$tries" =~ ^[0-9]+$ ]] || tries=0
  if [ "$tries" -ge "$GARDEN_CANARY_MAX_RETRIES" ]; then
    halt_roll "$host" "$target" "$reason" exhausted
    return
  fi
  rstat_set "$target" "$host" retry-wait
  rfield_set "$target" "$host" retry_at "$now"
  roll_drain "$host" "canary FAILED validation, retry ${tries}/${GARDEN_CANARY_MAX_RETRIES} pending ($reason)"
  log "canary $host failed for ${target:0:12} (retry ${tries}/${GARDEN_CANARY_MAX_RETRIES} pending): $reason — drained (roll-induced); will re-release after backoff"
}

# --- handle_roll_retry: a canary that is roll-drained / awaiting a retry ------
# Reached when a released canary publishes roll_status=roll-drained (its own or a stale
# roll-drain from an earlier target) or its rstat is retry-wait. Respects an operator
# override (an operator drain that overwrote the marker → skip), waits out the backoff,
# then LIFTS the roll-drain and re-arms the canary for another validation round, bounded
# by GARDEN_CANARY_MAX_RETRIES. Always advances at most one step and its caller exits.
handle_roll_retry() {  # handle_roll_retry <host> <target>
  local host="$1" target="$2" tries ra
  # Operator override mid-retry: an operator drain (source=operator) overwrites the
  # marker, so self-deploy publishes operator-drained. Operator wins — skip forever.
  if [ "$(follower_health_field "$host" roll_status)" = operator-drained ]; then
    rstat_set "$target" "$host" skipped
    log "canary $host became operator-drained during retry; SKIPPING (operator drain is inviolable)"
    return
  fi
  tries="$(rfield_get "$target" "$host" retries)"; [[ "$tries" =~ ^[0-9]+$ ]] || tries=0
  if [ "$tries" -ge "$GARDEN_CANARY_MAX_RETRIES" ]; then
    halt_roll "$host" "$target" "retries exhausted after re-validation kept failing" exhausted
    return
  fi
  ra="$(rfield_get "$target" "$host" retry_at)"
  if [[ "$ra" =~ ^[0-9]+$ ]] && [ $(( now - ra )) -lt "$GARDEN_CANARY_RETRY_BACKOFF" ]; then
    log "canary $host in retry backoff ($(( now - ra ))s/${GARDEN_CANARY_RETRY_BACKOFF}s) for ${target:0:12}; holding"
    return
  fi
  # Backoff elapsed (or a stale roll-drain with no recorded retry_at): grant a retry.
  # Stamp retry_at=now so, until the follower republishes a non-roll-drained status
  # (its drain-off is async), a re-entry HOLDS on the fresh backoff rather than burning
  # the whole budget in a few ticks.
  tries=$(( tries + 1 ))
  rfield_set "$target" "$host" retries "$tries"
  rfield_set "$target" "$host" retry_at "$now"
  roll_undrain "$host" "retry ${tries}/${GARDEN_CANARY_MAX_RETRIES} — lifting roll-drain to re-validate ${target:0:12}"
  # Clear the prior probe so validate_canary posts a FRESH one (a new attempt-suffixed
  # base) rather than reading the previous attempt's stale tada.
  rfield_set "$target" "$host" probe_base ""
  rfield_set "$target" "$host" probe_posted_at ""
  rstat_set "$target" "$host" released
  rfield_set "$target" "$host" released_at "$now"
  alert_maintainer_clear "rolling-deploy-canary-failed-$host" "retrying canary $host (attempt ${tries}/${GARDEN_CANARY_MAX_RETRIES}); clearing prior page." || true
  log "canary $host retry ${tries}/${GARDEN_CANARY_MAX_RETRIES}: lifted roll-drain and re-armed for ${target:0:12}"
}

# --- halt: page (LOUDER when retries are exhausted), leave the canary drained -
halt_roll() {  # halt_roll <host> <target> <reason> [exhausted]
  local host="$1" target="$2" reason="$3" mode="${4:-}"
  rstat_set "$target" "$host" failed
  # Leave the failed canary DRAINED so it stops taking real work on a suspect version
  # (a BENIGN, roll-provenance drain op — no attestation). Best-effort; the alert is the
  # load-bearing part.
  roll_drain "$host" "canary FAILED validation ($reason)"
  local aged=""
  if [ "$mode" = exhausted ]; then
    aged="This canary was RETRIED ${GARDEN_CANARY_MAX_RETRIES} time(s) automatically and kept
failing, so the roll has stopped retrying and now needs YOU. This is a persistent,
confirmed regression, not a transient blip — treat it as higher severity than a
first-tick halt.
"
  fi
  alert_maintainer "rolling-deploy-canary-failed-$host" \
"Rolling deploy HALTED on a failed canary.
canary host: $host
target sha:  $target
failing signal: $reason
${aged}The roll released no further followers and the LEADER did NOT advance itself — a
broken tip that fails a canary never reaches the leader. The canary was left DRAINED
(benign roll-induced drain op) pending your decision; auto-rollback is deliberately not
performed (designs/follower-self-deploy.md § Failure handling). Investigate the target
on $host, then lift its drain and re-trigger, or hold the tip. (leader=$GARDEN)"
  log "HALTED: canary $host failed validation for ${target:0:12}${mode:+ ($mode)}: $reason — leader will NOT advance; canary left drained"
}

# --- stuck-canary watchdog -----------------------------------------------------
# A follower holding a release token it has not deployed for
# GARDEN_ROLL_STUCK_CANARY_AFTER raises ONE keyed notice per episode (alert_maintainer
# coalesces repeats). It runs on EVERY tick, including "nothing to roll": the
# 2026-09-23 strand happened after the leader was already current, when no roll step
# ever looked at the canary again. The clock restarts when the token names a new sha.
# Offline peers have their own watchdog, and an operator-drained peer is a
# deliberate pause, so neither counts as stuck.
stuck_canary_watch() {
  local f tok fd rec since key d="$STATE/stuck-canary"
  mkdir -p "$d" 2>/dev/null || true
  while IFS= read -r f; do
    key="rolling-deploy-canary-stuck-$f"
    tok="$(release_token "$f")"; fd="$(follower_deployed_sha "$f")"
    if [ -z "$tok" ] || [ "$fd" = "$tok" ] || ! host_is_online "$f" \
       || [ "$(follower_health_field "$f" roll_status)" = operator-drained ]; then
      if [ -e "$d/$f" ]; then
        rm -f "$d/$f"
        alert_maintainer_clear "$key" "canary $f is no longer stuck (release ${tok:-cleared}, deployed ${fd:-unknown})." || true
      fi
      continue
    fi
    rec="$(rdline "$d/$f")"
    if [ "${rec%% *}" != "$tok" ]; then
      printf '%s %s\n' "$tok" "$now" > "$d/$f"
      continue
    fi
    since="${rec##* }"; [[ "$since" =~ ^[0-9]+$ ]] || since="$now"
    [ $(( now - since )) -ge "$GARDEN_ROLL_STUCK_CANARY_AFTER" ] || continue
    alert_maintainer "$key" \
"Rolling-deploy canary $f is STUCK: it was released to ${tok:0:12} $(( (now - since) / 60 )) min ago
but still reports deployed_sha ${fd:-<none>}. Check garden-self-deploy on $f
(journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
keeps it from advancing. The leader does not advance past an undeployed canary.
(leader=$GARDEN)"
    log "canary $f STUCK: released to ${tok:0:12} $(( now - since ))s ago, still at ${fd:-<none>}"
  done < <(all_follower_hosts)
}

# --- catch-up: a follower left BEHIND a leader that is already current ---------
# The leader can reach a sha by a path other than a completed roll: the liaison's
# hand-run deploy-garden.sh override, or the leader-only degenerate path. The
# conductor then sees no upgrade-ready and does nothing, and the follower holds a
# release for an OLDER sha, or none, until the 60-minute leaderless grace. That is
# the 2026-09-23 strand. So while the leader is current, release every present follower
# whose deployed sha is an ancestor of the leader's to the leader's sha. The leader
# already runs that sha, so no further canary validation applies. A token the
# follower has already reached is cleared.
catch_up_followers() {
  local L f fd tok
  L="$(deployed_sha 2>/dev/null || true)"
  [ -n "$L" ] || return 0
  while IFS= read -r f; do
    host_is_online "$f" || continue
    fd="$(follower_deployed_sha "$f")"; tok="$(release_token "$f")"
    if [ "$fd" = "$L" ]; then
      [ -z "$tok" ] || journal_rm "$GARDEN_DEPLOY_ROLL_PATH/$f" "deploy/roll($f) cleared (at leader sha ${L:0:12}) by $GARDEN" || true
      continue
    fi
    [ -n "$fd" ] && [ "$tok" != "$L" ] || continue
    is_ancestor "$fd" "$L" || continue
    if journal_put "$GARDEN_DEPLOY_ROLL_PATH/$f" "$L" "deploy/roll($f)=${L:0:12} (catch-up to leader by $GARDEN)"; then
      log "follower $f is behind the current leader (${fd:0:12} < ${L:0:12}, prior release ${tok:-none}); released it to catch up"
    else
      log "WARN: could not write catch-up release token for $f; retrying next tick"
    fi
  done < <(all_follower_hosts)
}

# =============================================================================
# --- the tick ---------------------------------------------------------------

# Observe absence even when there is no upgrade pending. The rolling-deploy timer is
# the fleet's first periodic host-liveness watchdog, so "nothing to roll" must not
# suppress an offline alert. The stable per-host key makes one notice per episode;
# alert_maintainer_clear closes it when any authoritative pool heartbeat resumes.
now="$(now_s)"
while IFS= read -r f; do
  if host_is_online "$f"; then
    alert_maintainer_clear "rolling-deploy-host-offline-$f" \
      "heartbeat resumed for $f; it is PRESENT again and will automatically rejoin the canary rotation while its hosts/$f record remains active. Archived records are not unarchived automatically." || true
  else
    [ -z "$(release_token "$f")" ] || journal_rm "$GARDEN_DEPLOY_ROLL_PATH/$f" "deploy/roll($f) cleared (peer offline) by $GARDEN" || true
    alert_maintainer "rolling-deploy-host-offline-$f" \
"Host $f is OFFLINE: $HOST_LIVENESS_DETAIL.
The authority is budget/live/<pool>/$f, refreshed periodically; fleet/health/$f is
not a heartbeat and was intentionally ignored. Rolling deploy will SKIP this peer:
no release token, deploy budget, failed-canary count, or halt. Restore the host and
its heartbeat to rejoin automatically. If hosts/$f was archived, unarchive it as a
separate operator decision; this watchdog never reverses decommissioning. (leader=$GARDEN)"
    log "peer $f is OFFLINE; watchdog open and any stale release cleared: $HOST_LIVENESS_DETAIL"
  fi
done < <(all_follower_hosts)

stuck_canary_watch

# The leader's own host-local upgrade-ready signal is the deploy DECISION (a
# cryptographic ancestry fact, never a bus message). Absent → the leader is current.
if [ ! -e "$GARDEN_UPGRADE_READY_MARKER" ]; then
  catch_up_followers
  log "leader deployed version is current (no upgrade-ready signal); nothing to roll"
  exit 0
fi
target="$( { sed -n 's/^available:[[:space:]]*//p' "$GARDEN_UPGRADE_READY_MARKER" 2>/dev/null || true; } | head -1 | tr -d '[:space:]')"
[ -n "$target" ] || { log "WARN: upgrade-ready signal present but no 'available:' sha parsed; skipping"; exit 0; }

# --- settle window (a FLOOR on tip age; the clock restarts on a new target) ---
settle_file="$STATE/settle/$(sd "$target")"
mkdir -p "$(dirname "$settle_file")" 2>/dev/null || true
first_seen="$(rdline "$settle_file")"
if ! [[ "$first_seen" =~ ^[0-9]+$ ]]; then first_seen="$now"; printf '%s\n' "$now" > "$settle_file"; fi
waited=$(( now - first_seen ))
if [ "$waited" -lt "$GARDEN_SELF_DEPLOY_SETTLE" ]; then
  log "target ${target:0:12} settling (${waited}s/${GARDEN_SELF_DEPLOY_SETTLE}s); not rolling yet"
  exit 0
fi

# --- degenerate fleet: leader-only (no followers = no canary by construction) -
mapfile -t all_followers < <(all_follower_hosts)
if [ "${#all_followers[@]}" -eq 0 ]; then
  log "leader-only fleet (no followers to canary); self-deploying directly on the settled upgrade-ready — today's solo-leader behavior"
  leader_deploy "$target" || log "WARN: leader self-deploy returned non-zero (deploy-garden.sh manages its own drain/abort)"
  exit 0
fi

# Classify liveness before selecting/releasing a canary. This also runs on every
# active-roll tick, so a heartbeat recovery closes its keyed watchdog episode and an
# offline-skipped host automatically rejoins if the roll is still holding. A host
# record archived by an operator is absent from all_followers and is never unarchived.
offline_count=0
offline_blocking_failure=""
for f in "${all_followers[@]}"; do
  if host_is_online "$f"; then
    if [ "$(rstat_get "$target" "$f")" = skipped ] \
       && [[ "$(rfield_get "$target" "$f" skip_reason)" = offline:* ]]; then
      rstat_set "$target" "$f" pending
      rfield_set "$target" "$f" skip_reason ""
      log "canary $f RECOVERED from OFFLINE ($HOST_LIVENESS_DETAIL); rejoining this roll"
    fi
  else
    offline_count=$(( offline_count + 1 ))
    prior="$(rstat_get "$target" "$f")"
    case "$prior" in
      passed)
        log "canary $f is now OFFLINE, but its completed PASS for ${target:0:12} remains valid: $HOST_LIVENESS_DETAIL"
        ;;
      failed|retry-wait)
        # Liveness loss after an observed validation failure must never erase the
        # safety result. Hold until the failure is resolved; do not relabel it as
        # an innocent pre-participation absence.
        offline_blocking_failure="$f ($prior)"
        log "canary $f is now OFFLINE after a real validation failure ($prior); preserving the failure and HOLDING"
        ;;
      *)
        rstat_set "$target" "$f" skipped
        rfield_set "$target" "$f" skip_reason "offline: $HOST_LIVENESS_DETAIL"
        log "canary $f is OFFLINE; SKIPPING without release or failure: $HOST_LIVENESS_DETAIL"
        ;;
    esac
  fi
done
mapfile -t followers < <(follower_hosts)
[ -z "$offline_blocking_failure" ] || { log "HOLDING leader: $offline_blocking_failure went offline after failing validation; failure safety gate remains in force"; exit 0; }

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
    retry-wait) skipped_all=0; handle_roll_retry "$f" "$target"; exit 0 ;;
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
    rfield_set "$target" "$f" skip_reason "operator-drained"
    log "canary $f is operator-drained; SKIPPING it (roll proceeds with the remaining followers)"
    continue
  fi

  # Released but ROLL-DRAINED — a failure-remediation drain from THIS or an earlier
  # target (never an operator pause; operator-drained is handled just above). A
  # roll-drain must NOT permanently exclude the canary: hand it to the bounded retry
  # machinery, which lifts the drain and re-arms it (or halts+escalates when exhausted).
  # This is the crux of the deadlock fix — a stale roll-drain is retried, not skipped.
  if [ "$(follower_health_field "$f" roll_status)" = roll-drained ]; then
    handle_roll_retry "$f" "$target"
    exit 0
  fi

  # Released but not yet deployed to the target?
  if [ "$(follower_deployed_sha "$f")" != "$target" ]; then
    ra="$(rfield_get "$target" "$f" released_at)"; : "${ra:=$now}"
    # A generous deploy budget: the follower's deploy-garden.sh may DEFER behind a long
    # in-flight job. Bound it by the probe deadline + watch so a follower that never
    # advances is eventually a failed canary, not an infinite wait.
    local_budget=$(( GARDEN_CANARY_PROBE_DEADLINE + GARDEN_CANARY_WATCH ))
    if [ $(( now - ra )) -ge "$local_budget" ]; then
      retry_or_halt "$f" "$target" "released ${local_budget}s ago but never advanced to the target sha (deploy stuck/failed on the canary)"
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
    *) retry_or_halt "$f" "$target" "$VAL_DETAIL"; exit 0 ;;
  esac
done

# --- every follower passed or was skipped ------------------------------------
if [ "$passed_any" -eq 1 ]; then
  log "all required canaries passed for ${target:0:12}; leader self-deploying LAST"
  if leader_deploy "$target"; then
    # deploy-garden.sh exits 0 on a DEFER (a long mid-job gardener) as well as on a
    # real deploy, so success means "this host now runs the target", read back.
    now_at="$(deployed_sha 2>/dev/null || true)"
    if [ "$now_at" = "$target" ]; then
      record="$(roll_completion_record "$target")"
      journal_put "$GARDEN_ROLL_COMPLETED_PATH/$target" "$record" "deploy roll ${target:0:12} completed by $GARDEN" || true
      log "roll completion recorded for ${target:0:12}; skipped peers: $(sed -n 's/^skipped_peers: //p' <<<"$record")"
    else
      log "leader deploy of ${target:0:12} did not land (deployed sha ${now_at:-unknown}; deferred or no-op); no completion recorded, retrying next tick"
    fi
  else
    log "WARN: leader self-deploy returned non-zero (deploy-garden.sh manages its own drain/abort)"
  fi
  # On success deploy-garden.sh records the new sha; the upgrade-monitor clears the
  # signal next tick and this roll's state ages out.
  exit 0
fi

# Every follower was offline and/or operator-drained: HOLD. Absence is not a failed
# canary, but neither is it validation permission for the leader.
if [ "$skipped_all" -eq 1 ] || [ "$passed_any" -eq 0 ]; then
  alert_maintainer "rolling-deploy-no-canary-$GARDEN" \
"Rolling deploy is HOLDING the leader: every configured follower is OFFLINE or
operator-drained, so there is no canary to validate ${target:0:12}. The leader will
not advance unvalidated. Restore any offline host until budget/live heartbeats resume,
or lift an operator drain. An archived host additionally needs a separate operator
unarchive; this roll never reverses archival. (leader=$GARDEN, offline=$offline_count)"
  log "HOLDING leader: no PRESENT, undrained canary available for ${target:0:12} (offline=$offline_count); restore a heartbeat or lift a drain"
fi
exit 0
