#!/bin/bash
# common.sh — shared helpers for the garden job board.
#
# The job board lives on the garden's orphan `journal` branch. A `git push`
# of that branch to the shared origin is the cross-host serialization point:
# the first accepted fast-forward wins, which is the compare-and-swap that
# makes concurrent claims safe. Nothing here assumes a single worker.
#
# Every path and remote is environment-overridable so the test harness can
# point the same code at a throwaway journal. Defaults target the real garden.
#
# Source this; do not execute it.

# --- configuration (all overridable) ----------------------------------------

# Garden root (where main + journal worktrees live).
: "${GARDEN_ROOT:=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"

# The shared journal remote (the serialization point) and branch. If
# JOURNAL_REMOTE is empty we derive it from the canonical journal worktree's
# origin. For tests, set JOURNAL_REMOTE to a local bare repo.
: "${JOURNAL_REMOTE:=}"
# The message-bus / job-board branch. Directory is `journal`; branch is `journal2`.
: "${JOURNAL_BRANCH:=journal2}"

# Per-instance state (gardener/producer journal clones, triager seen-markers).
# Kept OUTSIDE any reset-prone worktree on purpose.
: "${GARDEN_STATE:=$GARDEN_ROOT/.garden-state}"

# The one place for ephemeral job scratch and ad-hoc worktrees. It is
# gitignored (`/scratch/` in .gitignore), so a job that dirties files here can
# never block the watchman fast-forward — the recurring deploy outage whose
# root cause was jobs leaving scratch dirs and worktrees at the live tree root.
# Jobs get a private path via scratch_dir and release it with scratch_cleanup
# (both below); never create scratch at the garden root. See roles/COMMON.md
# § Scratch discipline.
: "${GARDEN_SCRATCH:=$GARDEN_ROOT/scratch}"

# Logical host name (the journal index key). Falls back gracefully.
: "${GARDEN_HOST:=$(hostname -s 2>/dev/null || echo host)}"

# The dev / next-version branch. Subagents land development here from their own
# worktrees; the deliberate deploy (deploy-garden.sh) merges it into the root
# checkout, and the upgrade monitor compares its tip to the deployed sha. Named
# centrally so a future rename or consolidation onto `main` is a one-variable
# change. See designs/deliberate-deploy.md § Branch model.
: "${GARDEN_MAIN_BRANCH:=main2}"

# Deliberate-deploy host standing state (designs/deliberate-deploy.md). Lives
# under $GARDEN_STATE — per-host, outside any reset-prone worktree, NOT committed
# to the dev branch, exactly like the watchman `seen` marker and the draining
# marker. deployed-sha is the commit the root checkout was last deployed to;
# upgrade-ready is present only while the dev branch is ahead of it.
: "${GARDEN_DEPLOY_STATE:=$GARDEN_STATE/deploy}"
: "${GARDEN_DEPLOYED_SHA_MARKER:=$GARDEN_DEPLOY_STATE/deployed-sha}"
: "${GARDEN_UPGRADE_READY_MARKER:=$GARDEN_DEPLOY_STATE/upgrade-ready}"

# Fleet draining marker. If present, this host's workers finish their in-flight
# claims but take no new ones — a graceful, mundane pause, not a kill. The marker
# is a FILE whose EXISTENCE is the signal; its CONTENTS are a short prose note for
# whoever finds it (written by drain-fleet.sh). An empty file still counts.
: "${GARDEN_DRAINING_MARKER:=$GARDEN_STATE/draining}"
# Deprecated legacy alias for the same idea (pivoker's NOPE killswitch). Still
# honored by fleet_draining so a rename landing mid-flight, or an operator who set
# the old marker, is never stranded. Remove once no host carries a NOPE marker.
: "${GARDEN_KILLSWITCH:=$GARDEN_STATE/NOPE}"

# --- bounded git network operations (the stuck-fetch hardening) --------------
#
# A journal fetch should finish in well under a second, but git has NO default
# IO timeout: a half-open connection left over from a transient network blip can
# stall a `git fetch` FOREVER. Worse, since harden-producer-push-path serialized
# each clone behind an flock, one stuck fetch HOLDS its clone lock, so every
# producer serialized behind that lock blocks too — a single stale connection
# wedged the WHOLE fleet (2026-06-25). The fix bounds BOTH the fetch and the
# lock wait, and a janitor (reaper.sh) reaps any fetch that outlives its bound.
: "${GARDEN_FETCH_TIMEOUT:=45}"   # seconds before a journal fetch is killed and retried
: "${GARDEN_FETCH_RETRIES:=3}"    # bounded attempts for a journal fetch
: "${GARDEN_OFFLINE_RC:=75}"      # EX_TEMPFAIL: sync_clone exit on a connectivity/DNS outage
: "${GARDEN_LOCK_WAIT:=60}"       # seconds a clone-lock waiter blocks before backing off
: "${GARDEN_LOCK_RETRIES:=3}"     # bounded waits before a lock acquisition gives up
# Stale-lock recovery: a clone lock whose recorded holder is dead, or whose stamp
# is older than the TTL, is presumed crashed/hung and reclaimable. This is the
# belt to flock's suspenders — flock frees a dead holder on fd close, but if the
# lock file outlives its holder (a 0-byte tombstone left by a killed run) or a
# holder hangs forever holding it, a waiter that would otherwise give up loudly
# first tries to reclaim. The TTL must sit comfortably ABOVE the longest
# legitimate hold (worst case ~GARDEN_FETCH_TIMEOUT * GARDEN_FETCH_RETRIES + a
# push) so a slow-but-live holder is never stolen from.
: "${GARDEN_LOCK_TTL:=300}"       # seconds; a still-held lock older than this is reclaimable
: "${GARDEN_LOCK_STEALS:=2}"      # bounded reclaim attempts before giving up loudly

# Belt: teach git itself to abort a stalled transfer rather than rely solely on
# the `timeout` wrapper. For https remotes, treat a transfer slower than
# ~1KB/s sustained for GARDEN_FETCH_TIMEOUT seconds as dead. For the
# git@github.com ssh remote, cap connect time and send keepalives so a dead peer
# is detected promptly. Only set GIT_SSH_COMMAND if the operator has not.
export GIT_HTTP_LOW_SPEED_LIMIT="${GIT_HTTP_LOW_SPEED_LIMIT:-1000}"
export GIT_HTTP_LOW_SPEED_TIME="${GIT_HTTP_LOW_SPEED_TIME:-$GARDEN_FETCH_TIMEOUT}"
if [ -z "${GIT_SSH_COMMAND:-}" ]; then
  export GIT_SSH_COMMAND="ssh -o ConnectTimeout=10 -o ServerAliveInterval=10 -o ServerAliveCountMax=3"
fi

# --- deterministic fleet gh identity -----------------------------------------
#
# Prepend the fleet's gh wrapper dir to PATH so every fleet `gh` call (this
# script's children, and the `claude -p` gardener subagents and their Bash tool
# calls, which all inherit this exported PATH) resolves to scripts/jobs/bin/gh.
# That wrapper pins the gh identity to the bot (kriscendobot) regardless of the
# mutable global active account in ~/.config/gh, with an explicit override path
# for the boatman's authorized-kriskowal ferries. See scripts/jobs/bin/gh and
# designs/fleet-gh-identity.md. Guarded so repeated sourcing in one process tree
# does not stack the entry.
GARDEN_BIN="$GARDEN_ROOT/scripts/jobs/bin"
case ":$PATH:" in
  "$GARDEN_BIN:"*) : ;;             # already at the front; nothing to do
  *) export PATH="$GARDEN_BIN:$PATH" ;;
esac

# --- small utilities ---------------------------------------------------------

# log()/die() emit a leading systemd syslog-level prefix (`<N>`) on the stderr
# line so journald classifies each line at the right priority and a
# `journalctl -p warning` capture survives the lines that matter. Without it
# every line journals at the default `info` and a priority-filtered failure tail
# drops them all — including `die "FATAL: …"` — leaving an outage triage blind to
# the script-level cause (the 18:46 fleet outage tail had 0 `[gardener-scaler]`/
# `[install]`/`[deploy-sync]` lines, only systemd's generic "exit-code"). The
# prefix is keyed off the message text: `<3>` (err) for FATAL, `<4>` (warning)
# for a line beginning WARN, `<6>` (info) otherwise. systemd's SyslogLevelPrefix
# honors `<N>` by default for Type=exec/simple units. The prefix is STRIPPED when
# stderr is a TTY (`[ -t 2 ]`) so interactive runs stay clean; it only appears
# when stderr is the journal/a pipe, exactly where journald consumes it.
log() {
  local prefix=""
  if [ ! -t 2 ]; then
    case "$*" in
      FATAL*) prefix='<3>' ;;
      WARN*)  prefix='<4>' ;;
      *)      prefix='<6>' ;;
    esac
  fi
  printf '%s%s [%s] %s\n' "$prefix" "$(date -u +%H:%M:%S)" "${GARDEN_TAG:-jobs}" "$*" >&2
}
die()  { log "FATAL: $*"; exit 1; }

# True when this host's fleet is draining: the new draining marker OR the
# deprecated legacy killswitch marker exists. Keys on EXISTENCE only — an empty
# marker drains just as a prose-filled one does.
fleet_draining() { [ -e "$GARDEN_DRAINING_MARKER" ] || [ -e "$GARDEN_KILLSWITCH" ]; }
# Deprecated alias retained so any not-yet-updated caller keeps working.
killswitch_engaged() { fleet_draining; }

# --- gardener mid-job (busy) marker — the single definition of "do not disturb" -
#
# gardener.sh drops a local, lock-free marker file while a job handler runs and
# clears it the moment the job ends (and at the top of each loop), so a gardener
# instance is "busy" (mid-job) exactly while that marker exists. Both the
# deliberate deploy (deploy-garden.sh, which waits for the fleet to quiesce and
# then re-execs workers onto landed code via deploy-restart.sh) and the pool
# scaler (install-units.sh scale, which disables extras on a scale-down) gate on
# it so a worker is restarted/disabled BETWEEN claims, never mid-`claude -p`:
# a `disable --now`/`restart` of a mid-job gardener SIGTERMs the in-flight handler,
# which then requeues and burns a full TTL cycle — the rc=143 transient-handler
# outage this marker exists to prevent. Keeping the path and the predicate here,
# in one place both callers source, means the deploy and scale paths can never
# drift on what "mid-job" means or where the marker lives.
gardener_busy_marker() {
  printf '%s\n' "$GARDEN_STATE/gardeners/${1:?gardener_busy_marker: idx required}/busy"
}
gardener_busy() {
  [ -e "$(gardener_busy_marker "${1:?gardener_busy: idx required}")" ]
}

# --- deliberate-deploy state (designs/deliberate-deploy.md) -------------------
#
# The deployed sha is the commit the root checkout was last advanced to by
# deploy-garden.sh. It is the deployed-version source of truth — NOT the branch
# name and NOT the live tree HEAD (which a stray operation could move) — so the
# upgrade monitor compares against a value the deploy explicitly recorded.

# deployed_sha — echo the recorded deployed sha. On a host that has never run a
# deploy (no marker), fall back to the current tree HEAD of the dev branch so the
# first upgrade comparison is still meaningful (the tree IS the deployed code
# until the first explicit deploy records a marker).
deployed_sha() {
  local s
  s="$(cat "$GARDEN_DEPLOYED_SHA_MARKER" 2>/dev/null || true)"
  if [ -z "$s" ]; then
    s="$(git -C "$GARDEN_ROOT" rev-parse --verify --quiet "$GARDEN_MAIN_BRANCH" 2>/dev/null || true)"
  fi
  printf '%s\n' "$s"
}

# record_deployed_sha <sha> — persist the deployed sha marker (host standing
# state). Creates the deploy-state dir on demand.
record_deployed_sha() {
  local sha="${1:?record_deployed_sha: sha}"
  mkdir -p "$(dirname "$GARDEN_DEPLOYED_SHA_MARKER")" 2>/dev/null || true
  printf '%s\n' "$sha" > "$GARDEN_DEPLOYED_SHA_MARKER"
}

# --- deterministic weekly token meter (the foreman back-off signal) -----------
# Sourced AFTER log/GARDEN_STATE so its helpers (meter_record, meter_window_total,
# meter_quota_status, meter_claude) can use them. See usage-meter.sh for the design
# and the documented choice of usage source.
# shellcheck source=usage-meter.sh
source "$(dirname "${BASH_SOURCE[0]}")/usage-meter.sh"

# --- hard-dependency guard (the silent-jq-outage fix) ------------------------
#
# A missing external binary must NEVER hide as silent empty output. On
# 2026-06-24 `jq` was absent from the host, and comment-source-gh.sh piped
# `gh api | jq` with a blanket `2>/dev/null || true` that swallowed the
# "command not found" — every PR comment was dropped for ~16h with no error
# surfaced. require_tools makes any fleet hard dependency a LOUD, fail-fast
# precondition instead.
#
#   require_tools git gh jq      # at the top of any script that needs them
#
# On a missing tool it logs FATAL, best-effort surfaces a THROTTLED maintainer
# message (so a silent dependency gap reaches a human, not just a systemd log),
# and exits 1. The maintainer alert is best-effort and never masks the die: it
# is skipped entirely when GARDEN_NO_MAINTAINER_ALERT=1 (set by tests and by any
# context with no journal), and routed through GARDEN_ALERT_CMD when set (tests
# capture it without touching the board).
require_tools() {
  local t missing=()
  for t in "$@"; do command -v "$t" >/dev/null 2>&1 || missing+=("$t"); done
  [ "${#missing[@]}" -eq 0 ] && return 0
  local msg="required tool(s) missing on PATH (host=${GARDEN_HOST}, tag=${GARDEN_TAG:-jobs}): ${missing[*]} — this silently drops work; install them or fix PATH"
  alert_maintainer "missing-tools-${GARDEN_HOST}" "$msg"
  die "$msg"
}

# alert_maintainer <dedup-key> <message> — best-effort, THROTTLED escalation to
# the maintainer inbox. Used by require_tools and the watchers' silent-output
# anomaly check. Throttled per <dedup-key> (default 1h) via a local state marker
# so a per-minute failure loop cannot spam the inbox with hundreds of messages.
# Never fails its caller: every path swallows errors and returns 0.
alert_maintainer() {
  local key="$1" msg="$2"
  [ "${GARDEN_NO_MAINTAINER_ALERT:-0}" = 1 ] && return 0
  # Throttle: at most once per window per key (a runaway timer must not flood).
  local marker="$GARDEN_STATE/alerts/${key//[^A-Za-z0-9._-]/_}.last" now last
  now="$(date +%s 2>/dev/null || echo 0)"
  if [ -f "$marker" ]; then
    last="$(cat "$marker" 2>/dev/null || echo 0)"
    [ $(( now - last )) -lt "${GARDEN_ALERT_THROTTLE_SECS:-3600}" ] && return 0
  fi
  mkdir -p "$(dirname "$marker")" 2>/dev/null || true
  printf '%s\n' "$now" > "$marker" 2>/dev/null || true
  if [ -n "${GARDEN_ALERT_CMD:-}" ]; then
    "$GARDEN_ALERT_CMD" "$key" "$msg" >/dev/null 2>&1 || true
    return 0
  fi
  printf '%s\n' "$msg" \
    | GARDEN_SENDER="watchdog:${GARDEN_TAG:-jobs}" \
      "$GARDEN_ROOT/scripts/jobs/inbox-send.sh" maintainer >/dev/null 2>&1 || true
  return 0
}

# Randomized backoff (~50–300ms) to break lockstep retries under contention.
backoff() { sleep "0.$(printf '%03d' "$(( (RANDOM % 250) + 50 ))")"; }

# --- job scratch (the live-tree-root clutter fix) ----------------------------
#
# Jobs that need a private scratch directory or an ad-hoc worktree MUST place it
# under $GARDEN_SCRATCH, never at the live garden tree root. A scratch dir/
# worktree at the root pollutes `git status` and — when a job dirties a tracked
# file — wedges the watchman's fast-forward (the recurring deploy outage). The
# $GARDEN_SCRATCH tree is gitignored, so nothing under it can ever block the
# watchman.
#
# scratch_dir <base> [<keep-list>] — make and echo a fresh private path
#   $GARDEN_SCRATCH/<base>-<short-rand>/, created on demand. The <base> is a
#   human-readable label (the job slug); the random suffix keeps concurrent
#   jobs sharing a base from colliding. Echoes the absolute path on stdout.
scratch_dir() {
  local base="${1:-scratch}" rand path
  base="${base//[^A-Za-z0-9._-]/-}"                 # keep the path well-formed
  # 4 hex chars of randomness without Date/openssl dependency hard-fails: prefer
  # openssl, fall back to $RANDOM (two draws → up to 8 hex digits of entropy).
  rand="$(openssl rand -hex 2 2>/dev/null || printf '%04x' $(( RANDOM & 0xffff )))"
  path="$GARDEN_SCRATCH/${base}-${rand}"
  mkdir -p "$path" || die "scratch_dir: cannot create $path"
  printf '%s\n' "$path"
}

# scratch_cleanup <dir> — remove a scratch dir created by scratch_dir. If <dir>
# is a registered git worktree (of any repo whose admin dir can be located), it
# is torn down with `git worktree remove --force` first so no stale worktree
# administrative entry is left behind; then the directory itself is removed.
# Refuses to touch anything outside $GARDEN_SCRATCH so a bad argument can never
# delete a live tree. Best-effort: never fails its caller.
scratch_cleanup() {
  local dir="${1:-}"
  [ -n "$dir" ] || return 0
  # Resolve to an absolute, normalized path and confine to $GARDEN_SCRATCH.
  local abs scratch_abs
  abs="$(cd "$dir" 2>/dev/null && pwd)" || { rm -rf "$dir" 2>/dev/null || true; return 0; }
  scratch_abs="$(cd "$GARDEN_SCRATCH" 2>/dev/null && pwd)" || return 0
  case "$abs/" in
    "$scratch_abs"/*) : ;;                          # inside scratch — safe to remove
    *) log "scratch_cleanup: refusing to remove $abs (outside $scratch_abs)"; return 0 ;;
  esac
  # If it is a git worktree, deregister it from its owning repo first.
  if [ -e "$abs/.git" ]; then
    local gitdir owner
    gitdir="$(git -C "$abs" rev-parse --git-common-dir 2>/dev/null || true)"
    if [ -n "$gitdir" ]; then
      owner="$(cd "$gitdir/.." 2>/dev/null && pwd || true)"
      [ -n "$owner" ] && git -C "$owner" worktree remove --force "$abs" >/dev/null 2>&1 || true
    fi
  fi
  rm -rf "$abs" 2>/dev/null || true
  return 0
}

bot_name()  { git -C "$GARDEN_ROOT" config --get user.name  2>/dev/null || echo garden-bot; }
bot_email() { git -C "$GARDEN_ROOT" config --get user.email 2>/dev/null || echo garden-bot@localhost; }

journal_remote() {
  if [ -n "$JOURNAL_REMOTE" ]; then printf '%s\n' "$JOURNAL_REMOTE"; return; fi
  git -C "$GARDEN_ROOT/journal" config --get remote.origin.url \
    || die "no JOURNAL_REMOTE set and no origin on $GARDEN_ROOT/journal"
}

# --- per-clone serialization (the shared-clone race fix) ---------------------
#
# Many producers share ONE journal clone: post-job, inbox-send, send-msg,
# set-schedule, set-schedule-once, set-gardeners, and journal-entry all default
# to $GARDEN_STATE/producer/journal. Without serialization their
# sync→write→commit→push critical sections interleave on a single working tree,
# index, and HEAD. The failure modes (all observed under an 8-way concurrent
# post): one process's sync_clone `reset --hard`/`clean` discards another's
# just-staged job before it pushes (then `git add`/`commit` aborts the script
# under `set -e`, BEFORE its retry loop — a silent directive loss); concurrent
# git invocations collide on `.git/index.lock`, `cannot lock ref 'HEAD'`, and
# `could not lock config file .git/config`; and a cold concurrent `git clone`
# into the same dir fails outright.
#
# We serialize the whole critical section with an flock held from sync_clone
# (or ensure_clone) through commit_and_push. The lock file is a SIBLING of the
# clone dir (outside the working tree) so `git clean`/`git add` never touch it,
# and closing the fd releases the lock even if the holder is killed — a crashed
# producer never wedges its peers. For per-service clones with no concurrent
# users the lock is uncontended: one cheap syscall. This is the smaller change
# than per-process clones (no new clone-per-invocation cost, no teardown) and
# removes the race at its source for every caller of the shared primitive.
#
# flock's "fd close frees the lock" guarantee has ONE gap: a killed holder whose
# child inherited the open fd keeps the lock alive (an orphan), so the next post
# blocks then dies, and a 0-byte tombstone is all the operator sees — the
# 2026-06-26 producer wedge that only `rm -f journal.lock` cleared. So the lock is
# also STALE-AWARE: the holder stamps "PID EPOCH" into the lock file, and a waiter
# that times out reclaims the lock when that holder is dead or older than
# GARDEN_LOCK_TTL (see clone_lock + _clone_lock_is_stale). Producers should still
# post SEQUENTIALLY against one clone — these helpers bound and recover from
# contention, they do not make concurrent fan-out against a shared clone free.

declare -A _CLONE_LOCK_FD 2>/dev/null || true

_clone_lockfile() { printf '%s' "${1%/}.lock"; }

# Stamp the acquiring process's identity into an already-flocked lock fd so a
# future waiter can tell a crashed/hung holder from a busy one. Written at offset
# 0 of the <>-opened fd as "PID EPOCH" on the first line; a waiter reads only that
# line, so trailing bytes from a longer prior stamp are harmless. Best-effort: a
# failed stamp must never abort the holder that already owns the lock.
_clone_lock_stamp() {
  local fd="$1"
  printf '%s %s\n' "$$" "$(date +%s 2>/dev/null || echo 0)" >&"$fd" 2>/dev/null || true
}

# Decide whether the lock file <lf> is held by a crashed/hung holder and may be
# reclaimed. True (0) only when the recorded holder PID is gone, OR the stamp is
# older than GARDEN_LOCK_TTL. Conservative by construction: an unreadable, empty,
# or non-numeric stamp returns false (1) so we never steal from a holder that just
# has not stamped yet — preserving mutual exclusion in the common busy case. On
# this single-user fleet `kill -0` is a reliable liveness probe (all producers run
# as the same user); PID reuse is backstopped by the TTL.
_clone_lock_is_stale() {
  local lf="$1" pid ts now
  [ -f "$lf" ] || return 1
  read -r pid ts _ < "$lf" 2>/dev/null || return 1
  case "${pid:-}" in ''|*[!0-9]*) return 1 ;; esac     # no/garbled stamp → not provably stale
  kill -0 "$pid" 2>/dev/null || return 0               # recorded holder is gone → stale
  case "${ts:-}" in ''|*[!0-9]*) return 1 ;; esac      # alive but no usable timestamp → busy
  now="$(date +%s 2>/dev/null || echo 0)"
  [ "$ts" -gt 0 ] && [ $(( now - ts )) -ge "$GARDEN_LOCK_TTL" ] && return 0   # alive but ancient → hung
  return 1
}

# A process-tree-stable env-var name marking that an ANCESTOR process already
# holds this clone's lock. A nested same-clone child (e.g. maintainer-reply holds
# the maintainer clone, then invokes maintainer-archive on the same clone) must
# NOT try to acquire the lock again: the ancestor is blocked waiting for the
# child, so a fresh flock on the same file would deadlock. Instead the child
# BORROWS the ancestor's lock — the ancestor's flock is still held (its fd stays
# open across the wait), so external mutual exclusion is preserved and the child
# is safe to operate while the ancestor idles.
_clone_lock_envkey() {
  local k; k="$(printf '%s' "${1%/}" | tr -c 'A-Za-z0-9' '_')"
  printf 'GARDEN_HELD_LOCK_%s' "$k"
}

# Ensure this process tree holds the exclusive lock for clone <dir>. Idempotent
# and re-entrant:
#   * already held by THIS process (a retry loop re-entering sync_clone before a
#     commit_and_push releases): no-op, keep holding.
#   * held by an ANCESTOR (env marker inherited across exec): borrow it, do not
#     re-flock (that would deadlock).
#   * otherwise: open a sibling lock file (outside the working tree) and flock it.
clone_lock() {
  local dir="$1" key lf fd n=1 steals=0
  [ -n "${_CLONE_LOCK_FD[$dir]:-}" ] && return 0       # this process already holds it
  key="$(_clone_lock_envkey "$dir")"
  if [ -n "${!key:-}" ]; then                          # an ancestor holds it — borrow
    _CLONE_LOCK_FD["$dir"]=borrowed
    return 0
  fi
  lf="$(_clone_lockfile "$dir")"; mkdir -p "$(dirname "$lf")"
  # Bound the wait, then RECLAIM a stale holder rather than wedge. Two ways a lock
  # outlives its usefulness: (a) a stuck holder (a hung fetch) blocks a waiter —
  # how one stale connection wedged the whole fleet; (b) a KILLED run leaves the
  # lock effectively held by an orphaned child that inherited the fd, so every
  # later post blocks then dies — the 2026-06-26 producer outage, where manual
  # `rm -f journal.lock` was the only recovery. flock -w caps each wait; on
  # timeout we consult the holder's stamp and reclaim it if the holder is dead or
  # older than the TTL, else back off and retry a bounded number of times, then
  # give up loudly. A stale steal trades flock's strict exclusion for liveness,
  # but only after a full GARDEN_LOCK_WAIT AND a positive staleness verdict, so a
  # busy live holder is never disturbed.
  while :; do
    # Open NON-truncating (<>) so a waiter peeking at the holder's stamp never
    # wipes it; the file is created on demand.
    exec {fd}<>"$lf" || die "cannot open clone lock $lf"
    if flock -w "$GARDEN_LOCK_WAIT" "$fd"; then
      _clone_lock_stamp "$fd"                          # record our pid + time for the next waiter
      _CLONE_LOCK_FD["$dir"]="$fd"
      export "$key=held"
      return 0
    fi
    exec {fd}>&- 2>/dev/null || true                   # release our failed attempt before deciding
    if [ "$steals" -lt "$GARDEN_LOCK_STEALS" ] && _clone_lock_is_stale "$lf"; then
      log "clone lock $lf stale (holder dead or >${GARDEN_LOCK_TTL}s old); reclaiming ($((steals+1))/$GARDEN_LOCK_STEALS)"
      rm -f "$lf"; steals=$((steals+1)); continue       # drop the tombstone, reopen a fresh inode, retry now
    fi
    if [ "$n" -ge "$GARDEN_LOCK_RETRIES" ]; then
      die "cannot acquire clone lock $lf after $n waits of ${GARDEN_LOCK_WAIT}s and $steals reclaim attempt(s) (a live holder is still busy; if it is crashed, rm -f $lf)"
    fi
    log "clone lock $lf busy >${GARDEN_LOCK_WAIT}s; backoff + retry ($((n+1))/$GARDEN_LOCK_RETRIES)"
    backoff; n=$((n+1))
  done
}

# Release the lock for clone <dir> if this process owns it (closing the fd
# releases the flock). A borrowed lock (owned by an ancestor) is left alone.
clone_unlock() {
  local dir="$1" key fd
  fd="${_CLONE_LOCK_FD[$dir]:-}"
  [ -n "$fd" ] || return 0
  unset '_CLONE_LOCK_FD[$dir]'
  [ "$fd" = borrowed ] && return 0
  key="$(_clone_lock_envkey "$dir")"; unset "$key"
  # NOTE: never add a `2>...` redirection to this `exec` — exec makes redirections
  # PERMANENT, so it would silence the shell's stderr for the rest of the run.
  exec {fd}>&- || true
}

# Ensure a single-branch journal clone exists at $1 and is identity-pinned. The
# clone + config write is serialized so concurrent producers don't race a cold
# `git clone` into the same dir or collide on `.git/config`.
ensure_clone() {
  local dir="$1" remote; remote="$(journal_remote)"
  clone_lock "$dir"
  if [ ! -d "$dir/.git" ]; then
    mkdir -p "$(dirname "$dir")"
    git clone -q --single-branch --branch "$JOURNAL_BRANCH" "$remote" "$dir" \
      || die "clone of $remote ($JOURNAL_BRANCH) into $dir failed"
  fi
  git -C "$dir" config user.name  "$(bot_name)"
  git -C "$dir" config user.email "$(bot_email)"
  clone_unlock "$dir"
}

# Bounded journal fetch: timeout-wrapped, with backoff + retry. git has no IO
# timeout of its own, so a half-open connection can hang a fetch forever; we wrap
# every journal fetch in `timeout GARDEN_FETCH_TIMEOUT` and treat a timeout
# (exit 124) or any transient failure as retryable, never a hang. Returns 0 on
# success, the last non-zero rc after GARDEN_FETCH_RETRIES attempts. Honors
# GARDEN_FETCH_CMD for test injection (it then owns its own timing).
#
# The final attempt's stderr is captured into GARDEN_FETCH_STDERR so a caller
# (sync_clone) can deterministically tell a connectivity/DNS outage from a real
# repo error without re-running the fetch. We capture stderr in BOTH branches so
# an injected GARDEN_FETCH_CMD can drive the classification in tests by writing
# the same diagnostic strings git would.
GARDEN_FETCH_STDERR=""
journal_fetch() {
  local dir="$1" attempt=1 rc=0
  GARDEN_FETCH_STDERR=""
  while :; do
    # Capture the fetch's stderr AND its exit code. The assignment must sit inside
    # an `if` so a non-zero command substitution does NOT trip the caller's `set -e`
    # before we can read $rc: a bare `VAR="$(failing-cmd)"; rc=$?` exits the whole
    # process at the assignment under `set -e`, which silently defeated sync_clone's
    # offline classification (its `exit $GARDEN_OFFLINE_RC` was never reached when
    # journal_fetch was called from a bare `set -e` context — the claim/complete
    # path — so a transient outage crashed the worker with the raw fetch rc instead
    # of the clean EX_TEMPFAIL skip). The `if` suspends `set -e` for the condition,
    # so we capture the real rc and let sync_clone do the classifying.
    if [ -n "${GARDEN_FETCH_CMD:-}" ]; then
      if GARDEN_FETCH_STDERR="$(GARDEN_FETCH_DIR="$dir" "$GARDEN_FETCH_CMD" 2>&1 1>/dev/null)"; then rc=0; else rc=$?; fi
    else
      if GARDEN_FETCH_STDERR="$(timeout "$GARDEN_FETCH_TIMEOUT" git -C "$dir" fetch -q origin "$JOURNAL_BRANCH" 2>&1 1>/dev/null)"; then rc=0; else rc=$?; fi
    fi
    [ "$rc" -eq 0 ] && return 0
    [ "$rc" -eq 124 ] && log "journal fetch in $dir timed out (>${GARDEN_FETCH_TIMEOUT}s) on attempt $attempt"
    if [ "$attempt" -ge "$GARDEN_FETCH_RETRIES" ]; then
      log "journal fetch in $dir failed after $attempt attempt(s) (last rc=$rc)${GARDEN_FETCH_STDERR:+: $GARDEN_FETCH_STDERR}"
      return "$rc"
    fi
    backoff; attempt=$((attempt+1))
  done
}

# Canonical transient-connectivity signature set. The single source of truth for
# what stderr text counts as a self-resolving network/DNS outage (EX_TEMPFAIL) vs
# a real repository error. Both _fetch_stderr_is_offline (below) and the
# belt-and-suspenders fallback grep in self-heal-run.sh consume this regex, so the
# two lists can never drift. Add new signatures HERE and both paths inherit them.
# Matched case-INSENSITIVELY (grep -i): git/curl/OpenSSH/gnuTLS vary the casing of
# the same diagnostic across versions, so the patterns gate on the words, not the
# case. The set spans the full transient surface a fetch over HTTPS or SSH hits:
#   * DNS:        Could not resolve host[name]:   (git/curl resolver failure)
#                 Temporary failure in name resolution   (getaddrinfo / SSH)
#   * remote:     Could not read from remote repository   (SSH side)
#   * timeouts:   Connection timed out / Operation timed out
#   * HTTPS blip: Connection reset by peer / Recv failure   (curl transport drop)
#                 Early EOF / unexpected disconnect / RPC failed   (smart-HTTP cut)
#                 HTTP 5NN / The requested URL returned error: 5NN   (5xx gateway)
#   * TLS:        gnutls_handshake / SSL / TLS errors   (handshake interrupted)
# A `Could not resolve host` pattern (no trailing `name`) deliberately covers BOTH
# git-over-HTTPS's `Could not resolve host:` and SSH's `Could not resolve hostname`.
: "${GARDEN_OFFLINE_SIGNATURES:=Could not resolve host|Temporary failure in name resolution|Could not read from remote repository|Connection timed out|Operation timed out|Connection reset by peer|Recv failure|Early EOF|unexpected disconnect|RPC failed|HTTP 5[0-9][0-9]|The requested URL returned error: 5|gnutls_handshake|SSL|TLS}"

# Classify captured git-fetch stderr ($1) as a connectivity/DNS outage rather
# than a real repository error. These are the transient, self-resolving failures
# a tick should skip over (EX_TEMPFAIL) instead of dying on. Returns 0 if the
# text matches a known outage signature, 1 otherwise. Case-insensitive (-i) so a
# signature classifies regardless of how the producing tool cased it.
_fetch_stderr_is_offline() {
  printf '%s' "$1" | grep -qiE "$GARDEN_OFFLINE_SIGNATURES"
}

# Canonical transient-`claude -p` signature set. The single source of truth for
# what a failed inner-agent's combined stdout+stderr must contain to count as a
# self-resolving API blip (overload / rate-limit / 5xx / bare connection drop)
# rather than a genuine crash, malformed-prompt, or auth failure. Both the
# gardener's inner-claude classifier (gardener.sh) and the follow-up handler
# (follow-up-claude.sh) consume this, so the two lists can never drift — add a new
# signature HERE and both paths inherit it. Matched case-insensitively (grep -i):
#   * overloaded / api[ _-]?error          (Anthropic 529 / generic API surface)
#   * rate[ _-]?limit / 429                  (throttling)
#   * connection error / econnreset / etimedout   (transport drop / SDK)
#   * 5NN                                    (any 5xx gateway/overload)
: "${GARDEN_TRANSIENT_CLAUDE_SIGNATURES:=overloaded|rate[ _-]?limit|connection error|\b(429|5[0-9][0-9])\b|api[ _-]?error|econnreset|etimedout}"

# Classify a failed `claude -p`'s combined output ($1) as a transient API blip
# (returns 0) versus a genuine, non-self-resolving failure (returns 1). A
# transient signature means re-rolling the SAME prompt next cadence will likely
# succeed; a non-transient failure (crash / malformed prompt / auth) will only
# re-roll the same defect and must be routed to a human instead of retried
# blindly (the 2026-06-27 07:53–08:44 follow-up re-roll loop). Case-insensitive.
is_transient_claude_signature() {
  printf '%s' "$1" | grep -qiE "$GARDEN_TRANSIENT_CLAUDE_SIGNATURES"
}

# Classify a handler exit code ($1) as an EXTERNAL signal-kill: SIGTERM (143),
# SIGINT (130), or SIGKILL/OOM (137). Returns 0 for these, 1 otherwise. An
# external signal-kill is NEVER a deterministic job defect — it is a deploy-window
# restart, a drain-fleet stop, an OOM, a host shutdown, or the reaper's claim-TTL
# kill — so it is transient REGARDLESS of whether the killed handler had already
# flushed partial output to its capture (progress lines, a folded report tail).
# gardener.sh consults this FIRST, before the empty/non-empty capture split, so
# capture content is irrelevant for these codes; the reaper requeues the job after
# GARDEN_CLAIM_TTL. Deliberately does NOT cover the offline rc (GARDEN_OFFLINE_RC):
# that stays gated on its own existing paths (sync_clone's clean skip, the
# empty-capture is_transient_empty_failure branch), since an offline tick is a
# connectivity classification, not a process kill.
is_external_kill_rc() {
  case "$1" in
    143|130|137) return 0 ;;
    *) return 1 ;;
  esac
}

# Classify an EMPTY-output handler failure by its exit code ($1): transient blip
# (returns 0) versus a deterministic defect that must escalate now (returns 1).
# With no stdout/stderr and no $report there is no signature to match, so the
# exit code is the only signal. Empty output is transient ONLY for a
# signal/clean-shutdown code (143 SIGTERM, 130 SIGINT, 137 SIGKILL) or the
# offline rc (GARDEN_OFFLINE_RC, default 75 EX_TEMPFAIL) — a `claude -p` killed
# mid-call or a tick that lost connectivity, both self-resolving on re-claim. A
# non-signal, non-offline non-zero rc with empty output is a DETERMINISTIC
# failure — rc=127/126 (missing / non-executable external tool, the jq-outage
# signature) or a bare rc=1/2 — and must surface to a human immediately rather
# than be deferred to the reaper's multi-hour poison cycle. Mirrors the
# signal/offline discrimination in self-heal-run.sh.
is_transient_empty_failure() {
  case "$1" in
    143|130|137|"${GARDEN_OFFLINE_RC:-75}") return 0 ;;
    *) return 1 ;;
  esac
}

# reap_count <jobfile> — the reaper's requeue-cycle count carried on a job, read
# from its `<!-- garden-reaped: N -->` marker (the marker reaper.sh writes; format
# REAP_MARKER_RE). Echoes N, or 0 when the marker is absent (a first-pass job the
# reaper has never requeued) or the file is missing. Extraction mirrors reaper.sh
# exactly (same sed, same `tail -1` defensiveness — clean_body keeps only one
# marker, but the reaper tails so we do too). READ-ONLY: this inspects the marker
# the reaper already maintains; it never writes, advances, or CAS-races it. Used by
# the gardener's transient-handler-failure note so a job dying the SAME transient
# way every cycle is greppable in the journal NOW, not only after the reaper's
# ~5×TTL poison threshold fires (~5h).
reap_count() {
  local f="${1:-}" n
  [ -f "$f" ] || { printf '0\n'; return 0; }
  n="$(sed -n 's/^<!-- garden-reaped: \([0-9][0-9]*\) -->$/\1/p' "$f" | tail -1)"
  printf '%s\n' "${n:-0}"
}

# --- reap-now hint -----------------------------------------------------------
#
# A marker a gardener stamps onto its OWN still-in-doin claim when it KNOWS at exit
# time the claim is dead: a transient signal-kill handler outage (143 SIGTERM / 137
# SIGKILL/OOM / 130 SIGINT) means the handler was killed by a deploy/drain/OOM and
# the job will never complete under this claim. Without it the job idles the full
# GARDEN_CLAIM_TTL (up to an hour) before its claimed_at age trips the reaper — the
# exact 2026-06-27 case where two Wayback-fetch scholar jobs died ~4 min into a
# 1-hour TTL and would have idled ~56 min before any retry.
#
# The reaper stays the SINGLE writer of the requeue and the `<!-- garden-reaped: N
# -->` poison counter. The hint only PROMOTES a claim into the reaper's stale set
# early (reaper.sh § detect the stale set); the claim then flows through the SAME
# requeue + poison path, so a job that is SIGTERM'd every cycle (a genuinely wedged
# fetch — the risk gardener.sh flags) still escalates to the maintainer as poison
# after GARDEN_REAP_POISON_THRESHOLD cycles rather than requeueing forever. The
# gardener must NOT requeue doin→todo itself, which would bypass that counter.
#
# The marker lives in the job BODY (above the trailing claim block); clean_body
# strips it on requeue so it never persists into a healthy re-claim and prematurely
# reaps a live worker.
REAP_NOW_MARKER='<!-- garden-reap-now -->'
REAP_NOW_MARKER_RE='^<!-- garden-reap-now -->$'

# has_reap_now_hint <file> — 0 if the job file carries the reap-now marker.
has_reap_now_hint() {
  local f="${1:-}"
  [ -f "$f" ] || return 1
  grep -Eq "$REAP_NOW_MARKER_RE" "$f"
}

# stamp_reap_now_hint <clone> <doin-relpath> — insert the reap-now marker into the
# BODY of a still-in-doin claim (just above the trailing `---`/`claim:` block) and
# land it on the board, so the reaper requeues the claim on its NEXT tick (≤10 min)
# instead of after GARDEN_CLAIM_TTL. Idempotent: a claim already carrying the hint,
# or already moved out of doin (reaped/completed by a peer), is left as-is. Bounded
# CAS retry against journal push contention, reusing sync_clone/commit_and_push.
# Returns 0 once the hint is on the board (or was already there / the claim is gone),
# non-zero only if it could not land — in which case the caller falls back to the
# reaper's TTL requeue. Run this in a SUBSHELL from a long-lived caller: sync_clone
# `exit`s GARDEN_OFFLINE_RC on a connectivity blip, which a subshell contains.
stamp_reap_now_hint() {
  local clone="$1" rel="$2" attempt f rc
  : "${GARDEN_REAP_NOW_PUSH_ATTEMPTS:=25}"
  for attempt in $(seq 1 "$GARDEN_REAP_NOW_PUSH_ATTEMPTS"); do
    sync_clone "$clone"
    f="$clone/$rel"
    if [ ! -e "$f" ]; then clone_unlock "$clone"; return 0; fi      # already moved by a peer
    if has_reap_now_hint "$f"; then clone_unlock "$clone"; return 0; fi  # already hinted
    awk -v m="$REAP_NOW_MARKER" '
      { line[NR] = $0 }
      END {
        cut = 0
        for (i = 1; i < NR; i++) if (line[i] == "---" && line[i+1] == "claim:") cut = i
        for (i = 1; i <= NR; i++) {
          if (cut > 0 && i == cut) print m   # insert just above the claim block (in the body)
          print line[i]
        }
        if (cut == 0) print m                # no claim block: append (defensive)
      }
    ' "$f" > "$f.reapnow" && mv "$f.reapnow" "$f"
    git -C "$clone" add "$rel"
    if commit_and_push "$clone" "reap-now: hint $rel by $GARDEN_HOST (transient handler kill)"; then rc=0; else rc=$?; fi
    [ "$rc" -eq 0 ] && return 0
    [ "$rc" -eq 2 ] && return 0   # nothing to commit (a racing stamp won): treat as landed
    backoff                       # rc=1: CAS lost — re-sync and retry
  done
  return 1
}

# Hard-sync a clone to the authoritative tip. The board's true state. Acquires
# the per-clone lock and HOLDS it; the matching commit_and_push releases it, so
# the entire sync→write→commit→push critical section is atomic per clone. A
# read-only caller that never pushes releases the lock at process exit (fd close)
# or on its next sync_clone (clone_lock re-entry).
sync_clone() {
  local dir="$1" rc
  clone_lock "$dir"
  # `journal_fetch ...; rc=$?` would trip the caller's `set -e` at the call itself
  # when the fetch fails (a function returning non-zero in a bare statement is a
  # `set -e` exit), killing the process before we can classify the failure as a
  # transient outage below. Capture the rc through an `if` so `set -e` is suspended
  # for the call and the offline path is actually reachable from a bare caller.
  if journal_fetch "$dir"; then rc=0; else rc=$?; fi
  if [ "$rc" -ne 0 ]; then
    # A transient network/resolver outage is not a real failure: exit EX_TEMPFAIL
    # so the wrapper and callers skip the tick and retry next cadence instead of
    # treating a fleet-wide blip as one failure per worker. Two transient shapes:
    #   * rc=124: journal_fetch's `timeout` killed a stalled fetch after bounded
    #     retries (it already logged the timeout). A half-open connection that
    #     never makes progress is the commonest symptom under ~100-gardener
    #     contention; promote the timeout to the clean-skip path rather than dying.
    #   * any rc whose captured stderr matches a known outage signature. These
    #     surface under SEVERAL exit codes (128, 1, 6, …), not just 128 — git/curl/
    #     OpenSSH disagree — so we gate on the signature, NOT a hard rc==128.
    if [ "$rc" -eq 124 ] || _fetch_stderr_is_offline "$GARDEN_FETCH_STDERR"; then
      log "offline; skipping tick (rc=$GARDEN_OFFLINE_RC)"
      exit "$GARDEN_OFFLINE_RC"
    fi
    die "fetch failed in $dir after bounded retries"
  fi
  # The fetch above succeeded, but the hard reset can ITSELF exit 128 on a
  # momentary network/ref inconsistency (a blip racing the local ref update).
  # Under `set -e` that raw 128 would escape classification and reach the
  # caller as a fatal — re-introducing the very per-blip fatal the fetch path
  # was hardened against. So guard the reset the same way: on any failure,
  # re-fetch once; if THAT fetch trips a recognizable offline signature, this is
  # a connectivity outage, so exit EX_TEMPFAIL exactly like the fetch path. A
  # reset that fails for any other reason still surfaces (the retry below dies).
  if ! git -C "$dir" reset -q --hard "origin/$JOURNAL_BRANCH"; then
    journal_fetch "$dir"; rc=$?
    if [ "$rc" -ne 0 ] && _fetch_stderr_is_offline "$GARDEN_FETCH_STDERR"; then
      log "offline on reset; skipping tick (rc=$GARDEN_OFFLINE_RC)"
      exit "$GARDEN_OFFLINE_RC"
    fi
    git -C "$dir" reset -q --hard "origin/$JOURNAL_BRANCH"
  fi
  git -C "$dir" clean -qfd jobs 2>/dev/null || true
}

# Push the journal branch. Indirected via GARDEN_PUSH_CMD so a test can inject a
# push that "succeeds" without advancing the remote (the silent-loss case).
_push_journal() {
  local dir="$1"
  if [ -n "${GARDEN_PUSH_CMD:-}" ]; then
    GARDEN_PUSH_DIR="$dir" "$GARDEN_PUSH_CMD"
  else
    git -C "$dir" push -q origin "HEAD:$JOURNAL_BRANCH" 2>/dev/null
  fi
}

# Confirm the just-pushed HEAD actually landed on origin/$JOURNAL_BRANCH. A push
# can report success yet not advance the remote (shared-clone races, transient
# ref-locks). Re-fetch and require our commit to BE the remote tip or an ancestor
# of it. Returns 0 if reachable, 1 if the post was silently lost.
_verify_pushed() {
  local dir="$1" head remote
  head="$(git -C "$dir" rev-parse HEAD 2>/dev/null)"               || return 1
  journal_fetch "$dir" >/dev/null 2>&1                             || return 1
  remote="$(git -C "$dir" rev-parse "origin/$JOURNAL_BRANCH" 2>/dev/null)" || return 1
  [ "$head" = "$remote" ] && return 0
  git -C "$dir" merge-base --is-ancestor "$head" "$remote" 2>/dev/null
}

# Commit staged changes, attempt the CAS push, and CONFIRM it landed before
# reporting success. Returns 0 only if the commit is verified reachable from
# origin/$JOURNAL_BRANCH; 1 if the push was rejected (CAS lost — normal, quiet)
# OR succeeded-but-was-silently-lost (loud, so the symptom is never invisible);
# 2 if there was nothing to commit. The caller's retry loop re-syncs and re-posts
# on 1. Releases the per-clone lock taken by sync_clone/ensure_clone on every
# path. This is the single place verify-after-push lives, so post-job,
# complete-job, claim-job, schedule, bulletin, inbox-send, and every other caller
# inherit it.
commit_and_push() {
  local dir="$1" msg="$2" rc=1
  if ! git -C "$dir" commit -q -m "$msg"; then clone_unlock "$dir"; return 2; fi
  if _push_journal "$dir"; then
    if _verify_pushed "$dir"; then
      rc=0
    else
      log "ALERT: push of '$msg' reported success but did NOT land on origin/$JOURNAL_BRANCH; re-syncing (silent-loss guard)"
      rc=1
    fi
  fi
  clone_unlock "$dir"
  return "$rc"
}

# --- failure capture (the git-content-store pattern) -------------------------
#
# A self-healing wrapper should never inline a large failure log into a
# `claude -p` prompt: it bloats the responder's context and an identical failure
# never short-circuits. Instead, capture the log as a git blob and pass only its
# SHA; the responder pulls just the slices it needs with `git cat-file -p <sha> |
# grep/sed/awk/tail`. Identical inputs hash to identical SHAs, so recurring flakes
# are recognizable by their content address. See designs/self-healing-audit.md
# (Part B) and designs/driver.md § Prompt-on-failure capture pattern.
#
# Cross-host inspection (the local-clone-vs-cross-host nuance):
#   `git hash-object -w` writes the blob into the *local* object DB of <clone-dir>
#   only. Each v2 service hashes into its own $GARDEN_STATE/<svc>/journal clone
#   (the caller's $DIR), so the blob is reachable by any reader ON THIS HOST but
#   is NOT on origin and NOT visible to a responder on another host (the central
#   mentor may run elsewhere). A bare `hash-object` is therefore enough only when
#   the responder runs on the same host against the same clone.
#
#   For a failure that a DIFFERENT host must inspect, the SHA must be made
#   reachable on the shared remote. Two durable options, in order of preference:
#     1. Write the SHA into a *committed* board/inbox file (a job body, an
#        inbox-error report) and push it the normal CAS way. The commit references
#        the tree, not a loose blob, so `git push origin HEAD:journal2` carries the
#        blob with it. This is what the v1 report-error.sh does and is the default
#        for any capture that escalates off-host.
#     2. Anchor the loose blob under a ref and push that ref, when you want the
#        capture available before/without a committed escalation:
#          anchor_blob "$sha" "captures/$(basename ...)" "$dir"   # see below
#   A capture that only ever feeds a same-host responder needs neither.

# capture_blob <file> [<clone-dir>] -> prints the blob SHA on stdout.
#
# Hash <file> into <clone-dir>'s object store (default: the caller's per-service
# $DIR clone) and print the resulting blob SHA. The blob is written (-w) but
# unreferenced, so it lives only in that clone's local object DB until a commit
# or ref makes it reachable for a push — see the cross-host note above.
capture_blob() {
  local file="$1" dir="${2:-${DIR:?capture_blob: no clone-dir given and \$DIR unset}}"
  git -C "$dir" hash-object -w --stdin < "$file"
}

# inspect_note <sha> [<clone-dir>] -> the one-line brief handed to a responder.
#
# Prints the exact command a responder runs to read the captured blob. The
# responder narrows from there with a pipe (`| grep`, `| tail`, `| sed -n`); it
# never needs the whole blob in context. Pair the SHA with this note in any
# `claude -p` prompt or inbox-error report instead of inlining the log body.
inspect_note() {
  local sha="$1" dir="${2:-${DIR:?inspect_note: no clone-dir given and \$DIR unset}}"
  printf 'inspect via: git -C %s cat-file -p %s\n' "$dir" "$sha"
}

# anchor_blob <sha> <ref-suffix> [<clone-dir>] -> pushes the loose blob to the
# shared remote under refs/captures/<ref-suffix> so an off-host responder (the
# central mentor) can fetch it. Use only when you need the capture reachable
# WITHOUT a committed escalation; the committed-file route (option 1 above) is the
# default. Returns non-zero (and logs) if the push is rejected; the loose blob is
# still safe locally, so the caller may fall back to a committed report.
anchor_blob() {
  local sha="$1" suffix="$2" dir="${3:-${DIR:?anchor_blob: no clone-dir given and \$DIR unset}}"
  local ref="refs/captures/$suffix"
  git -C "$dir" update-ref "$ref" "$sha" || { log "anchor_blob: update-ref $ref failed"; return 1; }
  git -C "$dir" push -q origin "$ref:$ref" 2>/dev/null \
    || { log "anchor_blob: push of $ref rejected (blob still local in $dir)"; return 1; }
}

# Bootstrap the env `systemctl --user` needs in non-login/cron/ssh contexts.
# (pivoker common.sh does the same; lingering via `loginctl enable-linger` is a
# separate one-time operator step.)
systemd_user_env() {
  : "${XDG_RUNTIME_DIR:=/run/user/$(id -u)}"; export XDG_RUNTIME_DIR
  : "${DBUS_SESSION_BUS_ADDRESS:=unix:path=$XDG_RUNTIME_DIR/bus}"; export DBUS_SESSION_BUS_ADDRESS
}

# Unit control, indirected so tests can mock it. Set GARDEN_UNIT_CTL to a
# command that receives the same args as `systemctl --user`.
unit_ctl() {
  if [ -n "${GARDEN_UNIT_CTL:-}" ]; then "$GARDEN_UNIT_CTL" "$@"; else
    systemd_user_env; systemctl --user "$@"
  fi
}

# job lifecycle dirs (relative to a journal clone root)
JOBS_TODO="jobs/todo"
JOBS_DOIN="jobs/doin"
JOBS_TADA="jobs/tada"
# The PLAN category sits ALONGSIDE the lifecycle but is OUTSIDE it: a plan job is
# a proposal/parked item that gardeners NEVER claim and the reaper NEVER reaps. It
# becomes work only when promoted into JOBS_TODO (see promote-plan.sh). Claims read
# only JOBS_TODO and the reaper scans only JOBS_DOIN, so plan/ is invisible to the
# worker pool by construction.
JOBS_PLAN="jobs/plan"

# List job basenames in a lifecycle dir, sorted, excluding .gitkeep.
list_jobs() {
  local dir="$1" sub="$2"
  ls -1 "$dir/$sub" 2>/dev/null | grep -v -x '.gitkeep' || true
}

# --- plan-job metadata helpers ----------------------------------------------
# A plan job carries leading YAML frontmatter:
#   ---
#   gate: go-ahead | deferred          # WHY it is parked (the gate reason)
#   priority: urgent|high|normal|low   # selection key for deferred promotion
#   roadmap: <milestone/item>          # optional; the roadmap item it serves
#   posted_by: <role>                  # optional provenance
#   posted_at: <iso8601>               # optional provenance
#   ---
#   <the work body — becomes the todo job on promotion>
# `urgency:` is accepted as a synonym for `priority:` (legacy plan files use it).

# Read a single leading-frontmatter scalar field from a plan file ($1=file,
# $2=key), stripping surrounding quotes. Empty if absent.
plan_field() {
  sed -n "s/^$2:[[:space:]]*//p" "$1" 2>/dev/null | head -1 | sed 's/^"\(.*\)"$/\1/; s/^'\''\(.*\)'\''$/\1/'
}

# The gate reason of a plan file, defaulting to 'deferred' when unset.
plan_gate() {
  local g; g="$(plan_field "$1" gate)"; printf '%s\n' "${g:-deferred}"
}

# The priority of a plan file (falls back to the legacy `urgency:` key), default 'normal'.
plan_priority() {
  local p; p="$(plan_field "$1" priority)"; [ -n "$p" ] || p="$(plan_field "$1" urgency)"
  printf '%s\n' "${p:-normal}"
}

# The blocker artifact of a `gate: blocked` plan file (a PR URL or a job basename),
# read from the `blocked_on:` field. This field IS the single source of truth for
# the blocked-job dependency edge — the proxy parks the job carrying it, the
# bulletin renders it, and the unblock watcher scans for it. Empty if absent.
plan_blocked_on() { plan_field "$1" blocked_on; }

# Parse an artifact string as a GitHub pull-request reference. On a match prints
# "<owner>/<repo>\t<number>" and returns 0; on no match prints nothing, returns 1.
# Recognized: a full PR URL (…github.com/<o>/<r>/pull/<n>[/…|#…|?…]) and the short
# "<o>/<r>#<n>" form. A bare token with no '/' or '#' is a JOB basename, not a PR.
# Shared by the proxy's blocked-parking (courtesy comment) and the unblock watcher
# (merge/close check) so both classify a blocker identically.
parse_pr_ref() {
  local a="$1"
  if [[ "$a" =~ github\.com/([^/]+)/([^/]+)/pull/([0-9]+) ]]; then
    printf '%s/%s\t%s\n' "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" "${BASH_REMATCH[3]}"; return 0
  elif [[ "$a" =~ ^([A-Za-z0-9._-]+)/([A-Za-z0-9._-]+)#([0-9]+)$ ]]; then
    printf '%s/%s\t%s\n' "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" "${BASH_REMATCH[3]}"; return 0
  fi
  return 1
}

# Is an artifact a JOB basename (a blocker that is another job)? True when it is a
# plain basename — no '/', '#', ':', and non-empty — i.e. the spine that ties a
# job's plan/todo/doin/tada files together.
is_job_basename() {
  case "$1" in ''|*/*|*'#'*|*:*) return 1;; *) return 0;; esac
}

# Map a named priority/urgency to a numeric rank (LOWER = more important, promoted
# first). Unknown values rank as normal so a typo never jumps the queue.
plan_rank() {
  case "$1" in
    urgent|critical|p0|0) echo 0;;
    high|p1|1)            echo 1;;
    normal|medium|p2|2|'') echo 2;;
    low|p3|3)             echo 3;;
    *)                    echo 2;;
  esac
}

# Print the deferred plan jobs in promotion order: highest priority first, oldest
# first within a priority (FIFO fairness). One basename (extensionless) per line.
# go-ahead plan jobs are EXCLUDED — those are promoted only by maintainer
# authorization, never auto-selected. $1 = a synced journal clone root.
plan_deferred_ranked() {
  local dir="$1" base f gate rank mtime
  for base in $(list_jobs "$dir" "$JOBS_PLAN"); do
    f="$dir/$JOBS_PLAN/$base"
    [ -f "$f" ] || continue
    gate="$(plan_gate "$f")"
    [ "$gate" = "deferred" ] || continue
    rank="$(plan_rank "$(plan_priority "$f")")"
    mtime="$(stat -c %Y "$f" 2>/dev/null || echo 0)"
    printf '%s\t%s\t%s\n' "$rank" "$mtime" "${base%.md}"
  done | sort -t"$(printf '\t')" -k1,1n -k2,2n | cut -f3
}
