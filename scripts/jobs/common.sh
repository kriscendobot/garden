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

# A killswitch file; if present, workers stop claiming. Mirrors pivoker's NOPE.
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
: "${GARDEN_LOCK_WAIT:=60}"       # seconds a clone-lock waiter blocks before backing off
: "${GARDEN_LOCK_RETRIES:=3}"     # bounded waits before a lock acquisition gives up

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

log()  { printf '%s [%s] %s\n' "$(date -u +%H:%M:%S)" "${GARDEN_TAG:-jobs}" "$*" >&2; }
die()  { log "FATAL: $*"; exit 1; }

killswitch_engaged() { [ -e "$GARDEN_KILLSWITCH" ]; }

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

declare -A _CLONE_LOCK_FD 2>/dev/null || true

_clone_lockfile() { printf '%s' "${1%/}.lock"; }

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
  local dir="$1" key lf fd
  [ -n "${_CLONE_LOCK_FD[$dir]:-}" ] && return 0       # this process already holds it
  key="$(_clone_lock_envkey "$dir")"
  if [ -n "${!key:-}" ]; then                          # an ancestor holds it — borrow
    _CLONE_LOCK_FD["$dir"]=borrowed
    return 0
  fi
  lf="$(_clone_lockfile "$dir")"; mkdir -p "$(dirname "$lf")"
  exec {fd}>"$lf" || die "cannot open clone lock $lf"
  # Bound the wait: a stuck holder (a hung fetch) must NOT block a waiter
  # forever — that is exactly how one stale connection wedged the whole fleet.
  # flock -w caps each wait; on timeout we back off and retry a bounded number
  # of times, then give up loudly rather than block indefinitely.
  local n=1
  until flock -w "$GARDEN_LOCK_WAIT" "$fd"; do
    if [ "$n" -ge "$GARDEN_LOCK_RETRIES" ]; then
      die "cannot acquire clone lock $lf after $n waits of ${GARDEN_LOCK_WAIT}s (stuck holder?)"
    fi
    log "clone lock $lf busy >${GARDEN_LOCK_WAIT}s; backoff + retry ($((n+1))/$GARDEN_LOCK_RETRIES)"
    backoff; n=$((n+1))
  done
  _CLONE_LOCK_FD["$dir"]="$fd"
  export "$key=held"
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
journal_fetch() {
  local dir="$1" attempt=1 rc=0
  while :; do
    if [ -n "${GARDEN_FETCH_CMD:-}" ]; then
      GARDEN_FETCH_DIR="$dir" "$GARDEN_FETCH_CMD"; rc=$?
    else
      timeout "$GARDEN_FETCH_TIMEOUT" git -C "$dir" fetch -q origin "$JOURNAL_BRANCH"; rc=$?
    fi
    [ "$rc" -eq 0 ] && return 0
    [ "$rc" -eq 124 ] && log "journal fetch in $dir timed out (>${GARDEN_FETCH_TIMEOUT}s) on attempt $attempt"
    if [ "$attempt" -ge "$GARDEN_FETCH_RETRIES" ]; then
      log "journal fetch in $dir failed after $attempt attempt(s) (last rc=$rc)"
      return "$rc"
    fi
    backoff; attempt=$((attempt+1))
  done
}

# Hard-sync a clone to the authoritative tip. The board's true state. Acquires
# the per-clone lock and HOLDS it; the matching commit_and_push releases it, so
# the entire sync→write→commit→push critical section is atomic per clone. A
# read-only caller that never pushes releases the lock at process exit (fd close)
# or on its next sync_clone (clone_lock re-entry).
sync_clone() {
  local dir="$1"
  clone_lock "$dir"
  journal_fetch "$dir" || die "fetch failed in $dir after bounded retries"
  git -C "$dir" reset -q --hard "origin/$JOURNAL_BRANCH"
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

# List job basenames in a lifecycle dir, sorted, excluding .gitkeep.
list_jobs() {
  local dir="$1" sub="$2"
  ls -1 "$dir/$sub" 2>/dev/null | grep -v -x '.gitkeep' || true
}
