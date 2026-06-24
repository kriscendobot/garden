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

# Logical host name (the journal index key). Falls back gracefully.
: "${GARDEN_HOST:=$(hostname -s 2>/dev/null || echo host)}"

# A killswitch file; if present, workers stop claiming. Mirrors pivoker's NOPE.
: "${GARDEN_KILLSWITCH:=$GARDEN_STATE/NOPE}"

# --- small utilities ---------------------------------------------------------

log()  { printf '%s [%s] %s\n' "$(date -u +%H:%M:%S)" "${GARDEN_TAG:-jobs}" "$*" >&2; }
die()  { log "FATAL: $*"; exit 1; }

killswitch_engaged() { [ -e "$GARDEN_KILLSWITCH" ]; }

# Randomized backoff (~50–300ms) to break lockstep retries under contention.
backoff() { sleep "0.$(printf '%03d' "$(( (RANDOM % 250) + 50 ))")"; }

bot_name()  { git -C "$GARDEN_ROOT" config --get user.name  2>/dev/null || echo garden-bot; }
bot_email() { git -C "$GARDEN_ROOT" config --get user.email 2>/dev/null || echo garden-bot@localhost; }

journal_remote() {
  if [ -n "$JOURNAL_REMOTE" ]; then printf '%s\n' "$JOURNAL_REMOTE"; return; fi
  git -C "$GARDEN_ROOT/journal" config --get remote.origin.url \
    || die "no JOURNAL_REMOTE set and no origin on $GARDEN_ROOT/journal"
}

# Ensure a single-branch journal clone exists at $1 and is identity-pinned.
ensure_clone() {
  local dir="$1" remote; remote="$(journal_remote)"
  if [ ! -d "$dir/.git" ]; then
    mkdir -p "$(dirname "$dir")"
    git clone -q --single-branch --branch "$JOURNAL_BRANCH" "$remote" "$dir" \
      || die "clone of $remote ($JOURNAL_BRANCH) into $dir failed"
  fi
  git -C "$dir" config user.name  "$(bot_name)"
  git -C "$dir" config user.email "$(bot_email)"
}

# Hard-sync a clone to the authoritative tip. The board's true state.
sync_clone() {
  local dir="$1"
  git -C "$dir" fetch -q origin "$JOURNAL_BRANCH" || die "fetch failed in $dir"
  git -C "$dir" reset -q --hard "origin/$JOURNAL_BRANCH"
  git -C "$dir" clean -qfd jobs 2>/dev/null || true
}

# Commit staged changes and attempt the CAS push. Returns 0 if the push was
# accepted (the operation is now authoritative), 1 if rejected (someone else
# advanced the branch — caller decides whether to retry or back off).
commit_and_push() {
  local dir="$1" msg="$2"
  git -C "$dir" commit -q -m "$msg" || return 2   # nothing to commit
  if git -C "$dir" push -q origin "HEAD:$JOURNAL_BRANCH" 2>/dev/null; then
    return 0
  fi
  return 1
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
