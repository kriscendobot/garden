#!/bin/bash
# watchman.sh — tell gardeners to reread after a deploy advances the root tree.
#
# Usage: watchman.sh
#
# Each tick: fetch origin and broadcast a deterministic "reread your role and
# skills" message to all active gardeners when this container's local tree HEAD
# has CHANGED since the last tick, then — best-effort — run the richer evolution
# handler (`claude -p` wearing the watchman role) for targeted notes.
#
# The aggressive checkout is RETIRED by default (GARDEN_AGGRESSIVE_CHECKOUT=0).
# Under the deliberate-deploy model (designs/deliberate-deploy.md) NOTHING
# fast-forwards the root tree except deploy-garden.sh: development happens in
# per-subagent worktrees, and the root is a deployed version advanced only by a
# drained deploy. So the watchman no longer touches the tree; it keeps only its
# BROADCAST role. Because the local tree HEAD now changes exactly once per deploy,
# the reread broadcast naturally becomes a POST-DEPLOY reread signal — which is
# precisely when gardeners need to reread their (newly-deployed) roles and skills.
#
# The legacy aggressive checkout remains behind GARDEN_AGGRESSIVE_CHECKOUT=1 for a
# host that has not yet cut over (it fast-forwards only a tree with no TRACKED
# edits and posts a resolve-wedge job, never pages the maintainer, on a wedge),
# but it is OFF by default and should stay off — re-enabling it reintroduces the
# continuous-ff collision this model was built to remove.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
# shellcheck source=wedge-resolve.sh
source "$HERE/wedge-resolve.sh"
export GARDEN_TAG="watchman"
: "${GARDEN_MAIN_BRANCH:=main2}"
: "${GARDEN_AGGRESSIVE_CHECKOUT:=0}"
: "${GARDEN_WATCH_HANDLER:=$HERE/handlers/watchman-claude.sh}"
: "${GARDEN_WATCHMAN_LOCAL_SHA_ATTEMPTS:=3}"
: "${GARDEN_WATCHMAN_LOCAL_SHA_RETRY_SLEEP:=1}"
: "${GARDEN_WATCHMAN_SEND_MSG:=$HERE/send-msg.sh}"
: "${GARDEN_WATCHMAN_BROADCAST_ATTEMPTS:=3}"

fleet_draining && { log "fleet draining; skipping"; exit 0; }

git -C "$GARDEN_ROOT" fetch -q origin "$GARDEN_MAIN_BRANCH" 2>/dev/null || log "fetch of origin/$GARDEN_MAIN_BRANCH failed (offline?)"

# Resolve <ref> in the root through the fleet git wrapper. A shared-lock timeout
# there is contention (a deploy, maintain/repack, or journal keeper holding the
# repository exclusively), not an unresolvable ref: record it in rev_lock_busy so
# the tick can skip instead of dying. The broadcast is keyed on HEAD changing
# between ticks, so a skipped tick loses nothing.
rev_lock_busy=0
watchman_rev_parse() { # <var> <ref>; sets <var> to the oid (empty on failure)
  local err rc=0 line pid cmd oid=''
  err="$(mktemp)"
  oid="$(git -C "$GARDEN_ROOT" rev-parse --verify --quiet "$2" 2>"$err")" || rc=$?
  [ "$rc" = 0 ] || oid=''
  printf -v "$1" '%s' "$oid"
  rev_lock_busy=0
  if grep -q '^garden repo lock: \(timeout after\|lock file kept being replaced\)' "$err"; then
    rev_lock_busy=1
    while IFS= read -r line; do
      log "$line"
      [[ "$line" =~ ^garden\ repo\ lock:\ [a-z-]+\ pid=([0-9]+) ]] || continue
      pid="${BASH_REMATCH[1]}"
      cmd="$(tr '\0' ' ' < "/proc/$pid/cmdline" 2>/dev/null || true)"
      [ -z "$cmd" ] || log "root repo lock holder pid=$pid: ${cmd% }"
    done < "$err"
  else
    cat "$err" >&2
  fi
  rm -f "$err"
}

local_sha=''
for ((attempt = 1; attempt <= GARDEN_WATCHMAN_LOCAL_SHA_ATTEMPTS; attempt += 1)); do
  watchman_rev_parse local_sha HEAD
  [ -z "$local_sha" ] || break
  if [ "$attempt" -lt "$GARDEN_WATCHMAN_LOCAL_SHA_ATTEMPTS" ]; then
    log "WARN: cannot resolve deployed HEAD in $GARDEN_ROOT (attempt $attempt/$GARDEN_WATCHMAN_LOCAL_SHA_ATTEMPTS); retrying after ${GARDEN_WATCHMAN_LOCAL_SHA_RETRY_SLEEP}s"
    sleep "$GARDEN_WATCHMAN_LOCAL_SHA_RETRY_SLEEP"
  fi
done
if [ -z "$local_sha" ]; then
  [ "$rev_lock_busy" = 0 ] || { log "WARN: root repo lock busy; skipping tick"; exit 0; }
  die "cannot resolve deployed HEAD in $GARDEN_ROOT"
fi
watchman_rev_parse up_sha "origin/$GARDEN_MAIN_BRANCH"
if [ -z "$up_sha" ]; then
  [ "$rev_lock_busy" = 0 ] || { log "WARN: root repo lock busy; skipping tick"; exit 0; }
  up_sha="$local_sha"
fi

# Aggressively converge local main2 onto upstream when behind (and clean).
if [ "$up_sha" != "$local_sha" ] && [ "$GARDEN_AGGRESSIVE_CHECKOUT" = "1" ]; then
  if git -C "$GARDEN_ROOT" merge-base --is-ancestor "$local_sha" "$up_sha" 2>/dev/null; then
    # "Clean enough to fast-forward" means no TRACKED changes. Untracked files
    # (--untracked-files=no excludes them) are not WIP and must not wedge the
    # fleet — only genuine tracked edits we'd risk clobbering should block.
    dirty_tracked="$(git -C "$GARDEN_ROOT" status --porcelain --untracked-files=no 2>/dev/null)"
    if [ -z "$dirty_tracked" ]; then
      if git -C "$GARDEN_ROOT" merge --ff-only "origin/$GARDEN_MAIN_BRANCH" >/dev/null 2>&1; then
        log "fast-forwarded $GARDEN_MAIN_BRANCH: $local_sha → $up_sha"
        local_sha="$up_sha"
      else
        # No tracked WIP, yet the ff was refused — typically an untracked file
        # colliding with an incoming tracked path. Resolve autonomously; never clobber.
        log "WARN: ff-merge to origin/$GARDEN_MAIN_BRANCH refused (untracked collision with an incoming path?); posting resolve-wedge job"
        trigger_wedge_resolution "$local_sha" "$up_sha" "fast-forward refused (an untracked file collides with an incoming tracked path)" ""
      fi
    else
      log "WARN: $GARDEN_MAIN_BRANCH worktree has TRACKED changes; skipping aggressive checkout, posting resolve-wedge job"
      trigger_wedge_resolution "$local_sha" "$up_sha" "tracked working-tree changes block the fast-forward" "$dirty_tracked"
    fi
  fi
fi

# Split point (issue kriskowal/garden#11, Multibot): the fetch + aggressive-ff
# ABOVE is per-host maintenance and runs on EVERY host. The "main2 advanced —
# reread" BROADCAST below is the duplicate-prone half — every host would broadcast
# the same advance to every gardener — so it is LEADER-ONLY. A follower has done
# its ff/maintenance and stops here. (The aggressive ff is off by default, so a
# follower watchman tick is effectively a no-op, which is correct.)
if ! is_main_host; then
  log "follower host; ff/maintenance only, skipping the reread broadcast (leader broadcasts)"
  exit 0
fi

target="$local_sha"
SEEN="$GARDEN_STATE/watchman/seen-$GARDEN_MAIN_BRANCH"
mkdir -p "$(dirname "$SEEN")"
old_sha="$(cat "$SEEN" 2>/dev/null || true)"
if [ "$old_sha" = "$target" ]; then
  log "no change on $GARDEN_MAIN_BRANCH ($target)"
  exit 0
fi
log "$GARDEN_MAIN_BRANCH at $target (was ${old_sha:-<none>}); notifying gardeners"

# Deterministic reread notice to every active gardener (required). The producer
# journal clone is shared with every other producer on the host, so its lock can
# stay busy past send-msg's own wait ladder (2026-11-01 04:32: "cannot acquire
# clone lock .../producer/journal.lock after 3 waits of 60s", which died here and
# failed the unit). That is contention, not a fault: retry with backoff, and if
# the lock is still busy, WARN and exit 0 WITHOUT advancing $SEEN so the next
# tick re-attempts this same advance. Any other send failure stays fatal.
broadcast_lock_busy() {  # <rc> <diagnostic>
  [ "$1" -eq "$GARDEN_OFFLINE_RC" ] || clone_lock_is_busy_contention "$1" "$2"
}
broadcast_err="$(mktemp)"
trap 'rm -f "$broadcast_err"' EXIT
broadcast_rc=0
for ((attempt = 1; attempt <= GARDEN_WATCHMAN_BROADCAST_ATTEMPTS; attempt += 1)); do
  broadcast_rc=0
  printf 'main2 advanced to %s — reread your role and skills as needed.\n' "$target" \
    | GARDEN_SENDER=watchman "$GARDEN_WATCHMAN_SEND_MSG" broadcast 2>"$broadcast_err" \
    || broadcast_rc=$?
  cat "$broadcast_err" >&2
  [ "$broadcast_rc" -ne 0 ] || break
  broadcast_lock_busy "$broadcast_rc" "$(cat "$broadcast_err")" \
    || die "could not broadcast reread notice (rc=$broadcast_rc)"
  if [ "$attempt" -lt "$GARDEN_WATCHMAN_BROADCAST_ATTEMPTS" ]; then
    log "WARN: producer journal lock busy broadcasting reread (attempt $attempt/$GARDEN_WATCHMAN_BROADCAST_ATTEMPTS, rc=$broadcast_rc); backing off"
    backoff "$attempt"
  fi
done
if [ "$broadcast_rc" -ne 0 ]; then
  log "WARN: producer journal lock still busy after $GARDEN_WATCHMAN_BROADCAST_ATTEMPTS broadcast attempt(s); leaving $GARDEN_MAIN_BRANCH advance to $target for the next tick"
  exit 0
fi

# The broadcast landed: record the advance now, before the slow best-effort
# handler, so a handler that dies or is killed never causes a duplicate notice.
printf '%s\n' "$target" > "$SEEN"
log "broadcast reread up to $target"

# Richer, targeted evolution notes (best-effort; needs claude).
"$GARDEN_WATCH_HANDLER" "${old_sha:-}" "$target" "$GARDEN_ROOT" \
  || log "evolution handler skipped (no claude or nothing to add)"
