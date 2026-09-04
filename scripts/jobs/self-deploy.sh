#!/bin/bash
# self-deploy.sh — the FOLLOWER self-deploy trigger daemon. NO LLM. Every host.
#
# Usage: self-deploy.sh   (per-host oneshot, driven by garden-self-deploy.timer)
#
# The follower half of the rolling deploy (designs/follower-self-deploy.md). It is
# the actual per-host deploy TRIGGER, and it fires deploy-garden.sh ONLY on this
# host's own host-local `upgrade-ready` cryptographic fact + git ancestry — NEVER on
# a bus message, a message body, or any agent-authored text (design point 4's
# invariant, preserved verbatim). What GATES that trigger has two modes:
#
#   PRIMARY (mechanism the leader releases): a leader-written JOURNAL release token
#   deploy/roll/<GARDEN> naming the sha this host is cleared to advance to. The token
#   is a GATE, not a trigger: this host still requires its independent upgrade-ready
#   fact to move, and only ever advances to origin/main2's tip, so the token cannot
#   widen what code can land — the sysop `deploy` op's attestation is never routed
#   through. When the leader releases this host, the leader supersedes the old
#   autonomous headless behavior.
#
#   DEGRADED FALLBACK (liveness backstop): if there is NO live leader to orchestrate —
#   the journal `leader` marker is absent, or this host has waited past
#   GARDEN_ROLL_LEADERLESS_GRACE for a release that never came — fall back to the
#   ORIGINAL headless self-deploy, gated by the old "never get AHEAD of the
#   last-known-good sha" canary (deploy/leader-sha). This preserves the nine-day-stall
#   fix even if the leader itself dies: a leaderless fleet still advances, just without
#   the rolling validation, which is the best guarantee when there is no conductor.
#
# Deterministic (no LLM), silent on the healthy/current path, and bounded. Runs on
# EVERY host (the leader ALSO runs it — its own release is the leader's advance,
# driven by rolling-deploy.sh — but a leader that reaches here without a release just
# waits; the leader's LAST-wave self-deploy is issued by the conductor, not here).
#
# Test seams:
#   GARDEN_SELF_DEPLOY_CLONE        read clone (this host's journal view)
#   GARDEN_SELF_DEPLOY_STATE        host-local settle/backoff state
#   GARDEN_SELF_DEPLOY_DEPLOY_CMD   invoke the real deploy (default deploy-garden.sh)
#   GARDEN_SELF_DEPLOY_ANCESTOR_CMD optional <target> <lkg> → rc0 iff target is an
#                                   ancestor-or-equal of lkg (default: git in $GARDEN_ROOT)
#   GARDEN_SELF_DEPLOY_NOW          fixed epoch seconds (default: date +%s)

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="self-deploy"

require_tools git

DIR="${GARDEN_SELF_DEPLOY_CLONE:-$GARDEN_STATE/self-deploy/journal}"
STATE="${GARDEN_SELF_DEPLOY_STATE:-$GARDEN_STATE/self-deploy}"
DEPLOY_CMD="${GARDEN_SELF_DEPLOY_DEPLOY_CMD:-$HERE/deploy-garden.sh}"
mkdir -p "$STATE" 2>/dev/null || true

now_s() { if [ -n "${GARDEN_SELF_DEPLOY_NOW:-}" ]; then printf '%s\n' "$GARDEN_SELF_DEPLOY_NOW"; else date +%s; fi; }
sd() { printf '%s\n' "${1:0:12}"; }
# set -e / pipefail-safe single-line readers (a `cat missing | head` fails the pipe).
rdsha()  { [ -f "$1" ] && head -n1 "$1" 2>/dev/null | tr -d '[:space:]' || true; }
rdline() { [ -f "$1" ] && head -n1 "$1" 2>/dev/null || true; }

# --- 1. the host-local deploy DECISION (never a bus message) -----------------
if [ ! -e "$GARDEN_UPGRADE_READY_MARKER" ]; then
  # Current: nothing to do. Silent (autonomous posture).
  exit 0
fi
target="$( { sed -n 's/^available:[[:space:]]*//p' "$GARDEN_UPGRADE_READY_MARKER" 2>/dev/null || true; } | head -1 | tr -d '[:space:]')"
[ -n "$target" ] || { log "WARN: upgrade-ready present but no 'available:' sha parsed; skipping"; exit 0; }

# --- 2. settle window (a FLOOR on tip age; clock restarts on a new target) ----
settle_file="$STATE/settle/$(sd "$target")"
mkdir -p "$(dirname "$settle_file")" 2>/dev/null || true
now="$(now_s)"
first_seen="$(rdline "$settle_file")"
if ! [[ "$first_seen" =~ ^[0-9]+$ ]]; then first_seen="$now"; printf '%s\n' "$now" > "$settle_file"; fi
waited=$(( now - first_seen ))
if [ "$waited" -lt "$GARDEN_SELF_DEPLOY_SETTLE" ]; then
  exit 0   # not settled yet — silent
fi

ensure_clone "$DIR"
sync_clone "$DIR"

release="$(rdsha "$DIR/$GARDEN_DEPLOY_ROLL_PATH/$GARDEN")"

do_deploy() {  # do_deploy <mode>
  log "self-deploy ($1): advancing this host to ${target:0:12} via deploy-garden.sh (host-local upgrade-ready + $1 gate)"
  "$DEPLOY_CMD" || log "WARN: deploy-garden.sh returned non-zero (it manages its own drain/quiesce/abort)"
}

# --- 3. PRIMARY: the leader released this host -------------------------------
if [ "$release" = "$target" ]; then
  if fleet_draining; then
    # An operator paused this host. Do NOT self-deploy out from under them; publish an
    # operator-drained health record so the leader's conductor SKIPS this canary rather
    # than waiting for a deploy that will not come.
    publish_fleet_health "$(deployed_sha 2>/dev/null || true)" operator-drained \
      && log "released to ${target:0:12} but operator-drained; declined and published operator-drained status" \
      || log "WARN: operator-drained + could not publish decline status"
    exit 0
  fi
  do_deploy "leader-release"
  exit 0
fi

# --- 4. DEGRADED: leaderless-grace headless fallback ------------------------
leader="$(leader_host 2>/dev/null || true)"
leaderless=0
if [ -n "$leader" ] && [ "$leader" = "$GARDEN" ]; then
  # THIS host is the leader. Its own advance is the conductor's LAST wave
  # (rolling-deploy.sh calls deploy-garden.sh directly once canaries pass); the
  # leader must never headless-self-deploy ahead of that. Hold for the conductor.
  log "this host is the leader; the rolling-deploy conductor drives the leader's own (last) advance — holding here"
  exit 0
elif [ -z "$leader" ]; then
  leaderless=1
elif [ "$waited" -ge "$GARDEN_ROLL_LEADERLESS_GRACE" ]; then
  # Waited a long time for a release that never came. The leader-sha canary below is
  # the real safety: if a live leader simply has not reached this host yet, leader-sha
  # will be BEHIND the target and the ancestor gate holds us anyway.
  leaderless=1
fi

if [ "$leaderless" -ne 1 ]; then
  log "upgrade-ready for ${target:0:12} but not yet released by leader '$leader' (waited ${waited}s); holding for the roll"
  exit 0
fi

if fleet_draining; then
  log "leaderless fallback eligible but this host is operator-drained; holding (never self-deploy out from under an operator)"
  exit 0
fi

# Headless canary: never advance AHEAD of the last-known-good leader-validated sha.
lkg="$(rdsha "$DIR/$GARDEN_DEPLOY_LEADER_SHA_PATH")"
if [ -z "$lkg" ]; then
  log "leaderless (leader='${leader:-<none>}') but no deploy/leader-sha last-known-good recorded; HOLDING rather than racing ahead unvalidated"
  exit 0
fi

ancestor_ok=0
if [ "$target" = "$lkg" ]; then
  ancestor_ok=1
elif [ -n "${GARDEN_SELF_DEPLOY_ANCESTOR_CMD:-}" ]; then
  "$GARDEN_SELF_DEPLOY_ANCESTOR_CMD" "$target" "$lkg" >/dev/null 2>&1 && ancestor_ok=1
elif git -C "$GARDEN_ROOT" merge-base --is-ancestor "$target" "$lkg" 2>/dev/null; then
  ancestor_ok=1
fi
if [ "$ancestor_ok" -ne 1 ]; then
  log "leaderless (leader='${leader:-<none>}'): target ${target:0:12} is AHEAD of last-known-good ${lkg:0:12}; HOLDING (never get ahead of a leader-validated sha)"
  exit 0
fi

# Backoff between headless attempts so a deploy that keeps deferring does not re-fire
# every tick.
bo_file="$STATE/headless-last-attempt"
last="$(rdline "$bo_file")"; [[ "$last" =~ ^[0-9]+$ ]] || last=0
if [ $(( now - last )) -lt "$GARDEN_SELF_DEPLOY_RETRY_BACKOFF" ]; then
  log "leaderless headless deploy backing off ($(( now - last ))s < ${GARDEN_SELF_DEPLOY_RETRY_BACKOFF}s since last attempt)"
  exit 0
fi
printf '%s\n' "$now" > "$bo_file"
do_deploy "leaderless-headless"
exit 0
