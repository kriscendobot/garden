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
# origin, and — when that worktree is dangling/absent — fall back to the shared
# root checkout's origin ($GARDEN_ROOT), since journal2 and main2 live in the
# same repo and share one remote (see journal_remote). For tests, set
# JOURNAL_REMOTE to a local bare repo.
: "${JOURNAL_REMOTE:=}"
# The message-bus / job-board branch. Directory is `journal`; branch is `journal2`.
: "${JOURNAL_BRANCH:=journal2}"

# Per-instance state (gardener/producer journal clones, triager seen-markers).
# Kept OUTSIDE any reset-prone worktree on purpose.
: "${GARDEN_STATE:=$GARDEN_ROOT/.garden-state}"

# Per-host cache of the last successfully-resolved journal remote. Lives under
# GARDEN_STATE (outside any reset-prone worktree, never committed) so a MOMENTARY
# empty read of the journal worktree's origin — a config-lock race with the
# worktree-keeper, or a deploy window — falls back to the last good value instead
# of FATAL-storming every garden-* unit off its systemd Restart. Written on every
# successful resolution; read as a fallback ahead of the root checkout's origin.
# See journal_remote.
: "${JOURNAL_REMOTE_CACHE:=$GARDEN_STATE/config/journal-remote}"

# The one place for ephemeral job scratch and ad-hoc worktrees. It is
# gitignored (`/scratch/` in .gitignore), so a job that dirties files here can
# never block the watchman fast-forward — the recurring deploy outage whose
# root cause was jobs leaving scratch dirs and worktrees at the live tree root.
# Jobs get a private path via scratch_dir and release it with scratch_cleanup
# (both below); never create scratch at the garden root. See roles/COMMON.md
# § Scratch discipline.
: "${GARDEN_SCRATCH:=$GARDEN_ROOT/scratch}"

# Host identity. GARDEN is the canonical, per-invocation host-identity knob and
# the SINGLE name every script uses (the journal index key, the claim-metadata
# key, the hosts/<host> worker-count key, the leader predicate's comparand).
# Resolved with this precedence:
#   1. an explicit GARDEN already in the environment (an operator/test one-off
#      override; wins so a `GARDEN=… some-cmd` invocation still works);
#   2. the gitignored per-instance identity file $GARDEN_ROOT/.garden — the
#      DURABLE shard config. It is home-directory state, so it is NOT committed
#      (a top-level dotfile, already covered by .gitignore's /.[!.]*), NOT shared
#      via git or Claude memory (both of which ARE shared across instances), and
#      — unlike a login-shell `export GARDEN=…` — it is read by common.sh itself,
#      so every `systemctl --user` unit that sources this file inherits it. A
#      login-shell export does NOT reach the systemd --user manager, which is the
#      trap that made an exported GARDEN silently fail to reach the fleet. Seeded
#      by ./garden at container creation (GARDEN_HOSTNAME); hand-editable after.
#   3. `hostname -s` — the single-shard default. The kernel hostname is fixed at
#      container creation and cannot distinguish two pools on one home directory,
#      which is exactly why the .garden file exists.
# We export GARDEN so child processes (git, the handler, hooks) inherit the
# resolved identity. NOTE: this does NOT reliably populate the drift-reconcile's
# view. The gardener-scaler reads the unit's MainPID /proc/<pid>/environ, but the
# MainPID is the self-heal-run.sh wrapper — the identity is only visible in the
# gardener.sh child that actually sources this file. So a file-derived identity
# reads as "unset" to gardener_instance_garden, which treats it as the hostname
# default (not drifted): a *live* edit of .garden is therefore NOT auto-detected;
# restart the pool to apply it. (Env-derived identity in the manager env WAS
# visible in the wrapper environ; the file trades that for durability. Making the
# reconcile read the gardener.sh child's environ is a follow-up.)
# See issue kriskowal/garden#11 (Multibot) and designs/multibot-leader-follower.md.
if [ -z "${GARDEN:-}" ] && [ -r "$GARDEN_ROOT/.garden" ]; then
  GARDEN="$(head -1 "$GARDEN_ROOT/.garden" 2>/dev/null | tr -d '[:space:]')"
fi
: "${GARDEN:=$(hostname -s 2>/dev/null || echo host)}"
export GARDEN

# --- leader/follower host topology (issue kriskowal/garden#11, Multibot) ------
# Gardeners run on EVERY host (concurrent claims dedup via the job-board push
# CAS); SINGLETON services (foreman, scheduler, bulletin, deadmail, reaper,
# follow-up, proxy, mentor, mirror-closer, the comment/mention watchers, the
# library-source-drift scan, and the liaison maintainer-inbox Monitor) run on
# exactly ONE leader host, because none of them handle concurrent duplicates.
# The leader is named by the single journal file `leader` (at the journal root),
# holding the leader's GARDEN identity; is_main_host (below) compares this host's
# GARDEN to it. The leader is changed by hand (set-main-host.sh) — manual
# designation, no automatic failover. See designs/multibot-leader-follower.md.
#
# GARDEN_LEADER, when set in the environment, short-circuits the journal read
# (operator/test override).
: "${GARDEN_LEADER_MARKER_PATH:=leader}"
: "${GARDEN_LEADER_CLONE:=$GARDEN_STATE/leader/journal}"
: "${GARDEN_LEADER_CACHE:=$GARDEN_STATE/leader/cached}"
# Seconds the cached leader identity is trusted before a fresh journal read; keeps
# a per-tick ExecCondition from hammering the journal while staying responsive to a
# leader change. The cache also covers a transient journal outage (stale fallback).
: "${GARDEN_LEADER_TTL:=30}"
# Default verdict when the leader is wholly UNDETERMINABLE (no env override, no
# readable marker, no cache, no network — only a cold offline host hits this).
# `leader` fails OPEN so a lone host's singletons still run (single-host behavior
# is unchanged); set `follower` to fail closed. A 2+-host fleet populates the cache
# on its first successful read, after which this default no longer applies.
: "${GARDEN_LEADER_DEFAULT:=leader}"

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
# Grace between the SIGTERM at GARDEN_FETCH_TIMEOUT and the unconditional SIGKILL
# escalation (timeout's --kill-after). Bare `timeout` sends ONLY SIGTERM, and git's
# transport child (git-remote-https on a half-open TLS connection) does not reliably
# die on SIGTERM — it orphans into the service cgroup, which is exactly the
# `garden-reaper.service: Found left-over process <pid> (git) in control group`
# warnings (observed 2026-06-29). --kill-after escalates to SIGKILL after the grace
# so a SIGTERM-ignoring transport child cannot wedge a fetch forever. GNU `timeout`
# already runs the command in its OWN process group and signals the WHOLE group on
# expiry (we do NOT pass --foreground), so both the SIGTERM and the SIGKILL reach the
# transport grandchild. Mirrors the gardener handler's --kill-after grace (commit
# a89e9bcda) for the identical SIGTERM-ignoring-child problem. Kept small: it only
# bites a wedged child, and the SIGKILL surfaces as rc=137, classified transient
# alongside the rc=124 wall-clock kill (journal_fetch / sync_clone below).
: "${GARDEN_FETCH_KILL_AFTER:=10}"  # seconds after SIGTERM before SIGKILL escalation
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

# is_transient_net_error <stderr-file-or-string> — true (0) when the given text
# bears the fingerprint of a TRANSIENT connectivity failure (a GitHub outage, a
# DNS blip, a TLS/handshake/read timeout) rather than a STRUCTURAL one (auth,
# 404, malformed response). A watcher whose PR/comment source fails uses this to
# decide between a loud `die` (structural — a real bug to surface) and a quiet
# skip-this-tick degrade (transient — the network will heal). The argument may be
# a path to a stderr capture file OR a literal string; a file is slurped, a
# non-file is matched directly. Matching is case-insensitive on a curated set of
# git/gh/curl/Go-http connectivity signatures.
is_transient_net_error() {
  local blob
  if [ -f "$1" ]; then
    blob="$(cat "$1" 2>/dev/null || true)"
  else
    blob="$1"
  fi
  printf '%s' "$blob" | grep -qiE \
    'connection timed out|error connecting to api\.github\.com|check your internet connection|read tcp .* i/o timeout|TLS handshake timeout|could not resolve host'
}

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

# --- gardener in-process host identity (for the scaler's identity reconcile) ---
#
# gardener_instance_garden <unit> — echo the GARDEN host-identity the RUNNING
# instance actually carries in its process environment, or empty (rc 1) when it
# cannot be read (the unit has no live MainPID, or /proc/<pid>/environ is
# unreadable, or the process never had GARDEN in its environ). A long-lived
# garden-gardener@N.service inherits GARDEN once, at spawn, from the manager env;
# if the host's identity is later corrected (e.g. a stale `GARDEN=endolinbot2`
# override is removed so a fresh process would resolve `hostname -s`=endolinbot),
# the already-running worker keeps the STALE value in its environ and goes on
# keying phantom hosts/<stale> state. This reads that live value straight from the
# kernel's /proc so the scaler can detect the drift and restart the worker onto the
# corrected identity. GARDEN_PROC is overridable so the reconcile step is testable
# without a real /proc. A worker with NO GARDEN in its environ resolved it from the
# kernel-fixed `hostname -s` default (which cannot drift): return 1 so the caller
# treats "unset" as "not drifted" rather than forcing a spurious restart.
: "${GARDEN_PROC:=/proc}"
gardener_instance_garden() {
  local unit="${1:?gardener_instance_garden: unit required}" pid environ val
  # Bounded: a hung `show` on one wedged unit must not stall the reconcile loop.
  # On timeout the pid reads empty → return 1 (treated as "not drifted", skipped).
  pid="$(unit_ctl_bounded show "$unit" -p MainPID --value 2>/dev/null | tr -dc '0-9')"
  [ -n "$pid" ] && [ "$pid" != 0 ] || return 1
  environ="$GARDEN_PROC/$pid/environ"
  [ -r "$environ" ] || return 1
  # environ is a NUL-delimited list of KEY=VALUE records; take the last GARDEN=.
  val="$(tr '\0' '\n' < "$environ" 2>/dev/null | sed -n 's/^GARDEN=//p' | tail -1)"
  [ -n "$val" ] || return 1
  printf '%s\n' "$val"
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
  local msg="required tool(s) missing on PATH (host=${GARDEN}, tag=${GARDEN_TAG:-jobs}): ${missing[*]} — this silently drops work; install them or fix PATH"
  alert_maintainer "missing-tools-${GARDEN}" "$msg"
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

# Exponential backoff with full jitter (per kriskowal #10, "use exponential
# back-off with full jitter, generally"). Each retry sleeps a FRESH uniform draw
# in [0, window], where window = min(cap, base * 2^(attempt-1)). The growth lets
# a busy branch drain without a tight poll, and the full-jitter draw (a new
# random span every attempt, not a fixed band) is what actually breaks the
# lockstep between contending writers — collisions on attempt N spread out across
# a wider, independently-sampled interval on attempt N+1 instead of re-colliding.
# This is the canonical AWS "exponential backoff and jitter" recipe.
#
# Callers inside a retry loop SHOULD pass their 1-based attempt counter
# (`backoff "$attempt"`); a bare `backoff` behaves as attempt 1 (a single small
# jittered pause, ~0-50ms). Tunable via GARDEN_BACKOFF_BASE_MS / _CAP_MS.
GARDEN_BACKOFF_BASE_MS="${GARDEN_BACKOFF_BASE_MS:-50}"
GARDEN_BACKOFF_CAP_MS="${GARDEN_BACKOFF_CAP_MS:-2000}"
backoff() {
  local attempt="${1:-1}" base="$GARDEN_BACKOFF_BASE_MS" cap="$GARDEN_BACKOFF_CAP_MS"
  [ "$attempt" -lt 1 ] 2>/dev/null && attempt=1
  # window = min(cap, base * 2^(attempt-1)); clamp the shift so a deep retry loop
  # cannot overflow the arithmetic before the cap clamps it.
  local exp=$((attempt - 1)) window
  if [ "$exp" -ge 16 ]; then window="$cap"; else
    window=$(( base << exp ))
    [ "$window" -gt "$cap" ] && window="$cap"
  fi
  # Full jitter: a fresh uniform draw in [0, window] milliseconds. RANDOM is
  # 0-32767, which comfortably covers the capped window.
  local ms=$(( RANDOM % (window + 1) ))
  sleep "$(printf '%d.%03d' "$((ms / 1000))" "$((ms % 1000))")"
}

# Idle-poll backoff with full jitter (per kriskowal #10, "use exponential
# back-off with full jitter, generally") — the SECOND-scale analog of backoff()
# for a steady poll loop rather than a tight CAS retry. A ~100-gardener fleet
# started in lockstep (a fresh boot or a deploy restart of the whole pool) would
# otherwise wake on the same fixed GARDEN_IDLE_SLEEP boundary and hit journal2
# with ~100 simultaneous fetches every interval — a thundering herd that the flat
# poll never breaks. Each idle tick instead sleeps a FRESH uniform draw in
# [0, window], window = min(cap, base * 2^(attempt-1)):
#   - a freshly-idle gardener (attempt 1) polls quickly, so a just-posted job is
#     picked up with low latency;
#   - a persistently-idle fleet backs off toward the cap AND decorrelates — the
#     full-jitter draw spreads each gardener's fetch across the whole window
#     instead of re-bunching on a shared boundary.
# Across the fleet the time-to-first-poll stays small even at the cap, because
# many independently-jittered pollers cover the interval; aggregate journal load
# drops sharply. NOTE this is a SEPARATE counter from the gardener's `idle_rounds`
# (which drives ONESHOT drain semantics) — do not conflate them. base =
# GARDEN_IDLE_SLEEP, cap = GARDEN_IDLE_SLEEP_CAP; attempt is the consecutive
# non-productive-tick count, reset to 1 on a productive (claimed) tick.
GARDEN_IDLE_SLEEP_CAP="${GARDEN_IDLE_SLEEP_CAP:-30}"
idle_backoff() {
  local attempt="${1:-1}" base_s="${GARDEN_IDLE_SLEEP:-5}" cap_s="${GARDEN_IDLE_SLEEP_CAP:-30}"
  [ "$attempt" -lt 1 ] 2>/dev/null && attempt=1
  local base_ms=$(( base_s * 1000 )) cap_ms=$(( cap_s * 1000 ))
  # window = min(cap, base * 2^(attempt-1)); clamp the shift so a long idle period
  # cannot overflow the arithmetic before the cap clamps it.
  local exp=$((attempt - 1)) window
  if [ "$exp" -ge 16 ]; then window="$cap_ms"; else
    window=$(( base_ms << exp ))
    [ "$window" -gt "$cap_ms" ] && window="$cap_ms"
  fi
  # Full-jitter draw. RANDOM (0-32767) covers windows up to ~32s; a larger cap is
  # effectively clamped to that range, which is acceptable for an idle poll.
  [ "$window" -gt 32767 ] && window=32767
  local ms=$(( RANDOM % (window + 1) ))
  sleep "$(printf '%d.%03d' "$((ms / 1000))" "$((ms % 1000))")"
}

# --- shared fleet brake (the quota-storm circuit breaker) ---------------------
# A correlated outage — a Claude quota/usage cut, an API-overload storm — makes
# many gardeners' handlers fail transiently AT ONCE. A per-worker backoff alone is
# not enough: ~100 independently-backing-off workers still collectively hammer the
# already-exhausted quota, amplifying the outage and churning todo<->doin (the
# 2026-07-01 incident that poisoned a dozen unrelated jobs). The fleet brake is a
# SHARED circuit breaker across this host's pool: every gardener stamps ONE
# timestamp into a host-local rolling ledger on each transient-classified handler
# failure (record_transient_failure); before each claim every gardener reads that
# ledger (fleet_brake_engaged) and, when the recent fleet-wide transient-failure
# DENSITY crosses a threshold, PAUSES claiming for a jittered window
# (fleet_brake_pause) so the storm drains instead of being fed. A paused gardener
# records nothing, so the density ages out of the window and the brake releases —
# the storm drains rather than being amplified. It changes only claim CADENCE: the
# reaper stays the sole owner of the requeue, and a braked gardener touches no board
# state. Fail-open by construction: an unreadable/missing ledger reads as density 0
# (brake released), so a broken brake can never wedge the fleet.
#
# The ledger lives under $GARDEN_STATE (per-host, outside any reset-prone worktree,
# never committed) — the same home as the usage meter's fallback ledger. It is
# host-local on purpose: a quota storm is observed per-host (each host runs its own
# `claude -p` handlers against the one shared subscription) and a cross-host brake
# would need journal coordination the storm-response path must not depend on.
GARDEN_FLEET_BRAKE_LEDGER="${GARDEN_FLEET_BRAKE_LEDGER:-$GARDEN_STATE/fleet-brake/failures}"
# Trailing window over which transient failures are counted (seconds).
GARDEN_FLEET_BRAKE_WINDOW_SECS="${GARDEN_FLEET_BRAKE_WINDOW_SECS:-300}"
# Transient failures within the window, across the whole host pool, that engage the
# brake. Sized above the handful of uncorrelated blips a healthy fleet produces so
# only a genuine correlated storm trips it. 0 DISABLES the brake.
GARDEN_FLEET_BRAKE_THRESHOLD="${GARDEN_FLEET_BRAKE_THRESHOLD:-10}"
# Base pause a braked gardener sleeps before re-checking (seconds); jittered.
GARDEN_FLEET_BRAKE_PAUSE_SECS="${GARDEN_FLEET_BRAKE_PAUSE_SECS:-60}"
# Soft cap on ledger lines before an opportunistic prune of out-of-window rows.
GARDEN_FLEET_BRAKE_LEDGER_MAXLINES="${GARDEN_FLEET_BRAKE_LEDGER_MAXLINES:-10000}"

# _fleet_brake_now — wall clock in epoch seconds, overridable for deterministic
# tests (mirrors the usage meter's meter_now shape).
_fleet_brake_now() { printf '%s\n' "${GARDEN_FLEET_BRAKE_NOW:-$(date +%s 2>/dev/null || echo 0)}"; }

# record_transient_failure — append one transient-failure event (a bare epoch
# timestamp) to the host-local rolling ledger. Called by a gardener on every
# transient-classified handler failure (both the exit-0-unsatisfying and the
# non-zero transient paths). Atomic append; never fails the caller (callers run
# under set -e). Opportunistically prunes out-of-window rows past the soft cap.
record_transient_failure() {
  local ledger="$GARDEN_FLEET_BRAKE_LEDGER" n
  mkdir -p "$(dirname "$ledger")" 2>/dev/null || return 0
  printf '%s\n' "$(_fleet_brake_now)" >> "$ledger" 2>/dev/null || true
  n="$(wc -l < "$ledger" 2>/dev/null || echo 0)"
  [ "${n:-0}" -gt "$GARDEN_FLEET_BRAKE_LEDGER_MAXLINES" ] && _fleet_brake_prune
  return 0
}

# _fleet_brake_prune — drop ledger rows older than the window, under a non-blocking
# flock (skip rather than block a concurrent recorder). Best-effort; a rare lost
# prune just defers cleanup to a later append. Mirrors the meter's meter_prune.
_fleet_brake_prune() {
  local ledger="$GARDEN_FLEET_BRAKE_LEDGER" lf cutoff tmp fd
  [ -f "$ledger" ] || return 0
  lf="${ledger}.lock"
  exec {fd}>>"$lf" 2>/dev/null || return 0
  if flock -n "$fd"; then
    cutoff=$(( "$(_fleet_brake_now)" - GARDEN_FLEET_BRAKE_WINDOW_SECS ))
    tmp="$(mktemp "${ledger}.XXXXXX" 2>/dev/null)" || { exec {fd}>&- 2>/dev/null || true; return 0; }
    if awk -v c="$cutoff" '($1+0)>=c' "$ledger" > "$tmp" 2>/dev/null; then
      mv -f "$tmp" "$ledger" 2>/dev/null || rm -f "$tmp" 2>/dev/null
    else
      rm -f "$tmp" 2>/dev/null
    fi
  fi
  exec {fd}>&- 2>/dev/null || true
  return 0
}

# transient_failure_density [<window-secs>] — count ledger rows within the trailing
# window. Prints the integer count (0 when the ledger is missing/unreadable — the
# fail-open reading). Always returns 0.
transient_failure_density() {
  local window="${1:-$GARDEN_FLEET_BRAKE_WINDOW_SECS}" ledger="$GARDEN_FLEET_BRAKE_LEDGER" now cutoff
  now="$(_fleet_brake_now)"; case "$now" in ''|*[!0-9]*) now=0 ;; esac
  cutoff=$(( now - window ))
  if [ -f "$ledger" ] && [ -r "$ledger" ]; then
    awk -v c="$cutoff" '($1+0)>=c { n++ } END { printf "%d\n", n+0 }' "$ledger" 2>/dev/null && return 0
  fi
  printf '0\n'; return 0
}

# fleet_brake_engaged — 0 (engaged) iff the recent fleet-wide transient-failure
# density is at/over the threshold; 1 otherwise. A threshold of 0 (or a misconfigured
# non-integer) DISABLES the brake. Fail-open: an unreadable ledger reads as density
# 0 → not engaged.
fleet_brake_engaged() {
  local thr="${GARDEN_FLEET_BRAKE_THRESHOLD:-10}" d
  case "$thr" in ''|*[!0-9]*) return 1 ;; esac
  [ "$thr" -eq 0 ] && return 1
  d="$(transient_failure_density)"
  [ "${d:-0}" -ge "$thr" ]
}

# fleet_brake_pause — sleep a jittered window while the brake is engaged, so a quota
# storm drains instead of being fed and the pool does not resume in lockstep (a
# thundering herd back onto the exhausted quota). The sleep is drawn in
# [base/2, 3*base/2] seconds — a base offset plus a full-jitter span — to
# decorrelate resume across the fleet. RANDOM (0-32767) caps the jitter span at
# ~32s, which is ample decorrelation for a poll loop.
fleet_brake_pause() {
  local base="${GARDEN_FLEET_BRAKE_PAUSE_SECS:-60}" lo span_ms ms
  case "$base" in ''|*[!0-9]*) base=60 ;; esac
  [ "$base" -lt 1 ] && base=1
  lo=$(( base / 2 ))                       # floor of the window
  span_ms=$(( base * 1000 ))               # jitter span in ms (= base seconds)
  [ "$span_ms" -gt 32767 ] && span_ms=32767
  ms=$(( lo * 1000 + RANDOM % (span_ms + 1) ))
  sleep "$(printf '%d.%03d' "$((ms / 1000))" "$((ms % 1000))")"
}

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

# kill_stale_worktree_handlers <worktree> — SIGTERM→SIGKILL any live process still
# rooted in <worktree>, so a re-claim of the SAME job base on THIS host can never
# run a second handler incarnation against a worktree a prior one is still writing.
#
# THE HAZARD (reaper-requeue-kills-or-waits-for-live-handler, 2026-07-05; the
# endo-but-for-bots #58 corruption class). A requeue re-runs the SAME base, and the
# per-job worktree path is DETERMINISTIC from the base (gardener-claude.sh § per-job
# worktree), so a re-claim on this host re-enters the identical worktree. The
# requeue can fire — a gardener reap-now hint (the exit-0-unsatisfying / transient
# branches stamp one) or the claim TTL — while a PRIOR incarnation's `claude -p`, or
# a subagent/tool child that outlived it, or an orphan left when the wrapper's
# `timeout` reaped only its direct child, is STILL RUNNING in that worktree. Two
# live incarnations then share one working tree and their interleaved edits corrupt
# each other (observed 2026-07-05 on fable-review-fix-garden-scripts: requeued at
# ~17-minute intervals — a reap-now hint, well under the 3600s TTL — with the prior
# `claude -p` still live each time). The reaper cannot close this: it may run on a
# different host than the orphan. The CLAIMING handler can, because the orphan is a
# LOCAL process on the same host it re-claims onto — which is the ONLY case a
# worktree is shared, since a cross-host re-claim gets a fresh worktree via
# ensure_worktree and cannot collide.
#
# Every process rooted at <worktree> at claim time is by construction a stale
# predecessor: the handler does not launch its own claude until AFTER this runs, and
# nothing else legitimately sets a cwd to a per-job worktree. We still exclude our
# own process tree (self + ancestors) and process group defensively. We signal the
# whole process GROUP of each match (claude plus the node/tool children `timeout`
# grouped with it) and escalate TERM→KILL like the reaper's stuck-fetch janitor, so
# a child that ignores SIGTERM is still reaped rather than left writing. Best-effort:
# never fails its caller. Linux /proc only; a host without it is a no-op (the
# resume/worktree machinery is already Linux-specific).
: "${GARDEN_STALE_HANDLER_KILL_GRACE:=5}"   # seconds between the group SIGTERM and the SIGKILL escalation
kill_stale_worktree_handlers() {
  local wt="${1:-}"
  [ -n "$wt" ] || return 0
  [ -d /proc ] || return 0
  # Normalize to the absolute path readlink /proc/<pid>/cwd reports.
  local abs
  abs="$(cd "$wt" 2>/dev/null && pwd)" || return 0
  [ -n "$abs" ] || return 0

  # Our own process tree (self + transitive ancestors) and process group — never
  # signal them, so this can never kill the very handler that is running it.
  local self_tree=" $$ " a="$$" mypgid
  mypgid="$(ps -o pgid= -p "$$" 2>/dev/null | tr -d ' ')"
  while :; do
    a="$(ps -o ppid= -p "$a" 2>/dev/null | tr -d ' ')"
    [ -n "$a" ] && [ "$a" -gt 1 ] 2>/dev/null || break
    case "$self_tree" in *" $a "*) break ;; esac      # cycle guard
    self_tree="$self_tree$a "
  done

  # Pass 1: collect every pid whose cwd is the worktree, plus their process groups.
  local pid cwd pgid procdir
  local -a match=() groups=()
  for procdir in /proc/[0-9]*; do
    pid="${procdir#/proc/}"
    case "$self_tree" in *" $pid "*) continue ;; esac
    cwd="$(readlink "/proc/$pid/cwd" 2>/dev/null || true)"
    [ "$cwd" = "$abs" ] || continue
    match+=("$pid")
    pgid="$(ps -o pgid= -p "$pid" 2>/dev/null | tr -d ' ')"
    [ -n "$pgid" ] || continue
    [ -n "$mypgid" ] && [ "$pgid" = "$mypgid" ] && continue   # never our own group
    case " ${groups[*]:-} " in *" $pgid "*) : ;; *) groups+=("$pgid") ;; esac
  done
  [ "${#match[@]}" -gt 0 ] || return 0

  log "killing ${#match[@]} stale predecessor process(es) still live in worktree $abs (pids: ${match[*]}) before launching a fresh handler — closing the two-writer window"
  # SIGTERM each match's whole group (covers the orphan's children), then the pids
  # directly as a belt (an orphan reparented to init keeps its own pgid, handled
  # above; this catches any pid a group signal missed).
  local g
  for g in "${groups[@]}"; do kill -TERM -"$g" 2>/dev/null || true; done
  for pid in "${match[@]}"; do kill -TERM "$pid" 2>/dev/null || true; done

  sleep "$GARDEN_STALE_HANDLER_KILL_GRACE"

  # Pass 2: SIGKILL anything that survived the grace — a SIGTERM-ignoring child —
  # by group, then by any pid still rooted in the worktree.
  for g in "${groups[@]}"; do kill -KILL -"$g" 2>/dev/null || true; done
  for procdir in /proc/[0-9]*; do
    pid="${procdir#/proc/}"
    case "$self_tree" in *" $pid "*) continue ;; esac
    cwd="$(readlink "/proc/$pid/cwd" 2>/dev/null || true)"
    [ "$cwd" = "$abs" ] && kill -KILL "$pid" 2>/dev/null || true
  done
  return 0
}

bot_name()  { git -C "$GARDEN_ROOT" config --get user.name  2>/dev/null || echo garden-bot; }
bot_email() { git -C "$GARDEN_ROOT" config --get user.email 2>/dev/null || echo garden-bot@localhost; }

# prune_worktrees_preserving_live [<root>] — run `git worktree prune` in <root>
# (default $GARDEN_ROOT) WITHOUT deleting the admin entry of a LIVE per-job
# gardener worktree. Use this EVERYWHERE the journal machinery would otherwise call
# a blanket `git -C $GARDEN_ROOT worktree prune`.
#
# The hazard (the endolinbot2 signature, 2026-07-05). A garden-root RELOCATION — an
# `mv` of the whole tree, e.g. /home/kris/garden2 -> /home/kris — leaves EVERY
# worktree admin entry recording the OLD absolute path in
# $GARDEN_ROOT/.git/worktrees/<id>/gitdir, so `git worktree list` marks each entry
# `prunable` even though a LIVE gardener is committing from the checkout at the NEW
# path. A blanket `git worktree prune` then deletes those admin entries out from
# under the running jobs; once an entry is gone `git worktree repair` can no longer
# recover it, so the job's commits fail irrecoverably. The stale JOURNAL sibling the
# keeper wants to clear and a live gardener-wt-* entry are BOTH `prunable` after a
# relocation, so a blanket prune cannot tell them apart — it takes both.
#
# The fix is ORDER: REPAIR every live per-job checkout FIRST. Given a live path,
# `git worktree repair <path>` rewrites BOTH cross-pointers (the admin gitdir and
# the checkout's forward .git) back to the current location, so the entry is no
# longer prunable; THEN prune. After the repair only genuinely-dead entries (no
# live checkout anywhere) remain prunable, so the prune still clears the stale
# journal sibling and abandoned per-job entries while every live gardener survives.
# Repair on an already-healthy checkout is a lossless near-no-op (it touches the two
# pointer files only when they disagree, never the working tree), so this is safe to
# run every tick and never perturbs a gardener mid-commit. Best-effort + quiet.
prune_worktrees_preserving_live() {
  local root="${1:-$GARDEN_ROOT}"
  # Enumerate the live per-job checkout shapes registered in <root>: the per-job
  # gardener dev worktrees under $GARDEN_SCRATCH (gardener-wt-<base>) and the v1
  # dispatch triples. Only dirs that currently exist with a .git gitlink are passed
  # to repair; an unexpanded glob or a vanished dir is skipped by the -e test.
  local live=() d
  for d in "$GARDEN_SCRATCH"/gardener-wt-* \
           "$root"/dispatches/*/garden "$root"/dispatches/*/journal; do
    [ -e "$d/.git" ] && live+=("$d")
  done
  # Re-link any relocation-staled admin entry to its live path so prune leaves it
  # alone. One repair call handles the whole batch; healthy paths are no-ops.
  if [ "${#live[@]}" -gt 0 ]; then
    git -C "$root" worktree repair "${live[@]}" >/dev/null 2>&1 || true
  fi
  git -C "$root" worktree prune >/dev/null 2>&1 || true
}

# ensure_journal_worktree_linked [<worktree>] — self-heal a journal worktree whose
# `.git` gitdir points at a nonexistent/wrong admin dir. This is the exact
# corruption that stranded the fleet: the worktree's forward `.git` file dangles —
# e.g. it names `/home/kris/.git/worktrees/journal` when the real repo lives at
# `/home/kris/garden2/.git/worktrees/journal` — so every `git -C <worktree>` dies
# with `fatal: not a git repository: <admin-dir>`, which journal_remote then
# misread as a missing origin and crash-looped claim/monitor under systemd Restart.
# When BOTH halves of the link still exist (the worktree checkout's `.git` gitdir
# file AND the repo-side admin dir under $GARDEN_ROOT/.git/worktrees/journal),
# `git worktree repair` re-links the forward `.git` file and the admin `gitdir`
# back-pointer losslessly, and `worktree prune` clears any stale admin entry.
# Quiet + best-effort: an already-valid worktree is a no-op, and when the pieces
# needed to re-link are absent (a truly missing worktree is ensure_clone's job,
# not ours) it leaves the fault for the caller's own validity check to report.
# Returns 0 iff the worktree is a valid git repo afterward.
ensure_journal_worktree_linked() {
  local wt="${1:-$GARDEN_ROOT/journal}"
  # Already a valid worktree — nothing to repair.
  git -C "$wt" rev-parse --git-dir >/dev/null 2>&1 && return 0
  # Only attempt a repair when both ends of the link are still on disk. A missing
  # worktree checkout or a missing admin dir is not a dangling-gitdir case.
  [ -e "$wt/.git" ] || return 1
  [ -d "$GARDEN_ROOT/.git/worktrees/journal" ] || return 1
  git -C "$GARDEN_ROOT" worktree repair "$wt" >/dev/null 2>&1 || true
  # Prune stale registrations WITHOUT taking a live per-job gardener worktree whose
  # recorded path a garden-root relocation staled (see prune_worktrees_preserving_live).
  prune_worktrees_preserving_live "$GARDEN_ROOT"
  # Re-check: success is silent; a still-broken worktree falls through to the
  # caller's accurate diagnostic.
  git -C "$wt" rev-parse --git-dir >/dev/null 2>&1
}

# repair_journal_worktree_gitdir [<jw>] — the SHARED, hardened prune-first repair of
# a severed journal-worktree gitdir link, factored out of the journal-worktree-keeper
# (jw_repair_gitdir) so every leader-only reader of the journal — the keeper AND the
# issue-inbox / comment / mention watchers, each of which aborts its WHOLE tick (an
# issue-inbox tick silently DROPS a maintainer's issue) when a `git -C <worktree>`
# dies "not a git repository" on a dangling gitdir — shares ONE hardened
# implementation instead of drifting copies. NON-DESTRUCTIVE: it only ever runs
# `git worktree prune` + `git worktree repair`, both of which touch pointer files and
# never the working tree, so a caller with no backup/active-writer machinery (a
# watcher) can call it safely. The keeper layers its LOSSY rebuild-from-origin
# fallback (jw_rebuild_dangling_worktree) on TOP of a non-zero return here.
#
# Prune-BEFORE-repair (2026-07-04, the companion keeper fix). A garden-root
# relocation (/home/kris/garden2 -> /home/kris) leaves a STALE sibling worktree
# registration ($GARDEN_ROOT/.git/worktrees/* pointing at a now-absent garden2/*
# path, shown `prunable` by `git worktree list`). A worktree whose gitdir CURRENTLY
# resolves but with a lingering stale registration would be declared healthy and
# never pruned; a later git op then re-resolves the cross-pointers onto the stale
# entry and re-breaks the linkage within the hour (`fatal: not a git repository:
# …/garden2/.git/worktrees/journal`), FATAL-storming the fleet. So prune runs
# UNCONDITIONALLY, at the top, BEFORE the health check — the order that empirically
# makes the fix stick. It is idempotent and cheap to run every tick.
#
# Live-worktree-preserving prune (2026-07-05). The prune is routed through
# prune_worktrees_preserving_live, NOT a raw `git worktree prune`. A blanket prune
# is NOT actually safe for live worktrees under a garden-root RELOCATION: an `mv` of
# the tree (garden2 -> the current root) stales EVERY admin entry's recorded path at
# once, so `git worktree list` marks a LIVE per-job gardener-wt-* worktree `prunable`
# right alongside the stale journal sibling, and a raw prune deletes the gardener's
# admin entry out from under a running job (the endolinbot2 corruption). The helper
# repairs every live per-job checkout FIRST (re-linking its cross-pointers so it is
# no longer prunable), then prunes — clearing only genuinely-dead entries.
#
# Returns 0 when the worktree resolves as a git repo (its gitdir), 1 when even a
# prune+repair could not re-link it. The healthy-path early return mirrors the
# keeper: it gates on the GITDIR only (a missing remote.origin.url is a separate
# concern handled by jw_ensure_origin / journal_remote's re-heal, NOT a reason to
# fall through to the keeper's destructive rebuild). The post-repair success gate
# additionally requires origin to resolve, because the observed failure was BOTH the
# gitdir dying AND the downstream "no origin", so a re-link that leaves origin
# unreadable has not actually closed the window. Best-effort and quiet: never dies;
# a missing worktree ($jw absent) returns 1 for the caller's own missing-repo check.
repair_journal_worktree_gitdir() {  # repair_journal_worktree_gitdir [<jw>]
  local jw="${1:-$GARDEN_ROOT/journal}" gd
  [ -d "$jw" ] || return 1
  # DEFENSIVE PRUNE — unconditional, before the health check (see header). Routed
  # through prune_worktrees_preserving_live so a garden-root relocation that stales
  # the journal sibling's recorded path does NOT also delete a live gardener-wt-*
  # entry staled by the SAME relocation (the endolinbot2 corruption).
  prune_worktrees_preserving_live "$GARDEN_ROOT"
  # Healthy already (gitdir resolves AND its target exists on disk): nothing to do.
  # rev-parse emits a path relative to $jw, so probe it with $jw as the base.
  if gd="$(git -C "$jw" rev-parse --git-dir 2>/dev/null)" \
     && [ -n "$gd" ] && ( cd "$jw" && [ -e "$gd" ] ); then
    return 0
  fi
  # The cheap fix: `git worktree repair` re-links both pointer files against the
  # surviving admin entry (the stale sibling was already pruned above). Gate success
  # on the linkage actually resolving afterward — repair can exit 0 without fixing an
  # unrelated breakage — and require origin too so a re-link that leaves origin
  # unreadable is not mistaken for a heal.
  git -C "$GARDEN_ROOT" worktree repair "$jw" >/dev/null 2>&1 || true
  if git -C "$jw" rev-parse --git-dir >/dev/null 2>&1 \
     && git -C "$jw" config --get remote.origin.url >/dev/null 2>&1; then
    log "REPAIRED: journal worktree gitdir re-linked on $jw via prune+worktree-repair (rev-parse --git-dir + remote.origin.url both resolve again)"
    return 0
  fi
  return 1
}

# _cache_journal_remote <url> — best-effort persist the last good journal remote to
# the per-host cache ($JOURNAL_REMOTE_CACHE, under GARDEN_STATE) so a later empty
# read of the worktree origin self-heals from the cached value instead of dying.
# Never fails the caller (write errors swallowed; callers may run under set -e) and
# only rewrites when the value actually changed, so it adds no per-tick disk churn.
_cache_journal_remote() {
  local url="$1" cur
  [ -n "$url" ] || return 0
  cur="$(cat "$JOURNAL_REMOTE_CACHE" 2>/dev/null || true)"
  [ "$cur" = "$url" ] && return 0
  mkdir -p "$(dirname "$JOURNAL_REMOTE_CACHE")" 2>/dev/null || return 0
  printf '%s\n' "$url" > "$JOURNAL_REMOTE_CACHE" 2>/dev/null || true
  return 0
}

# _reheal_journal_worktree_origin <url> — when we resolved the journal remote from a
# fallback source (cache / another clone) because the journal worktree itself yields
# no origin, opportunistically re-add it in place so the NEXT tick reads origin
# straight from the worktree and never enters the fallback path again. Only meaningful
# when the worktree is a valid git repo whose origin is genuinely unset (a broken
# gitdir link is ensure_journal_worktree_linked's job, not this one; a `remote add`
# there just fails harmlessly). Best-effort and idempotent: `remote add` no-ops once
# origin exists, and every git error is swallowed so a caller under set -e is safe.
_reheal_journal_worktree_origin() {
  local url="$1" jw="${2:-$GARDEN_ROOT/journal}"
  [ -n "$url" ] || return 0
  git -C "$jw" rev-parse --git-dir >/dev/null 2>&1 || return 0
  git -C "$jw" config --get remote.origin.url >/dev/null 2>&1 && return 0
  git -C "$jw" remote add origin "$url" >/dev/null 2>&1 || true
  return 0
}

# _journal_remote_from_state_clones — last-resort read of remote.origin.url from any
# existing per-instance journal clone under $GARDEN_STATE. Each v2 service and the
# shared producer hash into their own $GARDEN_STATE/<svc>/journal clone, and the
# read-side watchers (issue-inbox, comment, mention, ci, deadmail) keep a
# $GARDEN_STATE/<svc>/verify clone — BOTH shapes carry the correct origin. When the
# worktree AND the per-host cache AND the root origin are all unavailable, one of
# these sibling clones almost certainly still carries the origin, so we scan them
# rather than die. Including the `*/verify` shape is load-bearing for the read-side
# watchers: a severed journal worktree would otherwise abort an issue-inbox tick (and
# silently drop a maintainer's issue) even though that watcher's OWN verify clone,
# right there under $GARDEN_STATE, still holds the origin — the `*/journal`-only glob
# never consulted it. Prints the first URL found and returns 0; prints nothing and
# returns 1 when none resolves. Quiet + best-effort.
_journal_remote_from_state_clones() {
  local d url
  for d in "$GARDEN_STATE"/*/journal "$GARDEN_STATE"/*/verify; do
    [ -d "$d/.git" ] || [ -e "$d/.git" ] || continue
    if url="$(git -C "$d" config --get remote.origin.url 2>/dev/null)" && [ -n "$url" ]; then
      printf '%s\n' "$url"; return 0
    fi
  done
  return 1
}

journal_remote() {
  if [ -n "$JOURNAL_REMOTE" ]; then printf '%s\n' "$JOURNAL_REMOTE"; return; fi
  local jw="$GARDEN_ROOT/journal"
  # Preflight: self-heal a dangling worktree gitdir link before reading origin.
  # When the garden root moves on disk (e.g. /home/kris → /home/kris/garden2), the
  # worktree .git file and its admin back-pointer keep pointing at the old paths,
  # so every git op in the worktree exits 128 ("not a git repository") and the
  # config read below would fail not because origin is missing but because git
  # can't open the repo at all — the die() would then mislabel it as a
  # missing-origin error and send recurrences down the wrong path (the very bug
  # that crash-looped claim/monitor and the gardener-scaler via
  # ensure_clone → journal_remote). ensure_journal_worktree_linked runs
  # `git worktree repair` + `prune` to re-link the forward .git file and the admin
  # gitdir back-pointer.
  ensure_journal_worktree_linked "$jw" || true
  local url
  if url="$(git -C "$jw" config --get remote.origin.url 2>/dev/null)" && [ -n "$url" ]; then
    _cache_journal_remote "$url"
    printf '%s\n' "$url"; return
  fi
  # The journal worktree yielded no origin — the repair above could not re-link a
  # dangling gitdir (its admin dir is gone, not just mis-pointed), origin is unset
  # there, OR (the common transient case) the read was MOMENTARILY empty: a git
  # config lock held by the worktree-keeper, or a deploy window. A per-tick die()
  # here FATAL-storms EVERY garden-* unit off its systemd Restart even though the
  # origin is intact seconds later — the 2026-07-03 11:06-11:11Z outage. So instead
  # of dying we fall back and log a SINGLE WARN. Fallback order:
  #   (1) the per-host cache of the last good resolution (survives a reset/deploy);
  #   (2) the shared root checkout's origin — journal2 and main2 live in the SAME
  #       repo/remote, so the root shares the same origin URL;
  #   (3) remote.origin.url from any sibling per-instance clone under $GARDEN_STATE.
  # Whenever a fallback resolves, we also opportunistically re-add origin to the
  # worktree in place (_reheal_journal_worktree_origin) so the NEXT tick reads it
  # straight from the worktree and skips the fallback entirely.
  if url="$(cat "$JOURNAL_REMOTE_CACHE" 2>/dev/null)" && [ -n "$url" ]; then
    log "WARN: journal worktree $jw yielded no origin; using cached journal remote $url (transient — config lock / worktree repair / deploy window)"
    _reheal_journal_worktree_origin "$url" "$jw"
    printf '%s\n' "$url"; return
  fi
  if url="$(git -C "$GARDEN_ROOT" config --get remote.origin.url 2>/dev/null)" && [ -n "$url" ]; then
    log "WARN: journal worktree $jw yielded no origin; falling back to $GARDEN_ROOT origin $url"
    _cache_journal_remote "$url"
    _reheal_journal_worktree_origin "$url" "$jw"
    printf '%s\n' "$url"; return
  fi
  if url="$(_journal_remote_from_state_clones)" && [ -n "$url" ]; then
    log "WARN: journal worktree $jw yielded no origin; falling back to a per-instance clone origin under $GARDEN_STATE ($url)"
    _cache_journal_remote "$url"
    _reheal_journal_worktree_origin "$url" "$jw"
    printf '%s\n' "$url"; return
  fi
  # Nothing resolved on either checkout. Distinguish a BROKEN worktree (git can't
  # open the repo — name the dangling gitdir target so the fix is obvious) from a
  # genuinely MISSING origin (repos open fine, just no remote configured).
  if ! git -C "$jw" rev-parse --git-dir >/dev/null 2>&1; then
    local target=""
    [ -f "$jw/.git" ] && target="$(sed -n 's/^gitdir: *//p' "$jw/.git" 2>/dev/null | head -1)"
    die "broken journal worktree at $jw: gitdir link ${target:+points at ${target} which }is unresolvable, and $GARDEN_ROOT has no origin either — run 'git -C $GARDEN_ROOT worktree repair'"
  fi
  die "no JOURNAL_REMOTE set and no origin on $jw or $GARDEN_ROOT"
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
    backoff "$((n+1))"; n=$((n+1))
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
  local dir="$1" remote tmp; remote="$(journal_remote)"
  clone_lock "$dir"
  if [ ! -d "$dir/.git" ]; then
    # A destination that exists but lacks .git is a POISONED PARTIAL CLONE: a
    # prior `git clone` was interrupted (SIGKILL at TimeoutStop, a sync_clone
    # reset aborted mid-flight, a disk hiccup) and left $dir populated without a
    # repo. `git clone` refuses a non-empty destination, so a naive retry would
    # `die` here on EVERY tick forever (observed: 145 identical [unblock] FATALs
    # over ~12h). Self-heal by clearing the poisoned dir. To ensure a future
    # interruption can NEVER re-wedge us, clone into a sibling temp path first
    # and atomically rename into place — the destination only ever appears
    # fully cloned or not at all, never half-populated, so an interrupted clone
    # leaves only a discardable temp behind. The temp is a sibling (same parent,
    # thus same filesystem) so the rename is atomic; we hold clone_lock "$dir"
    # throughout, so no concurrent producer races the same destination.
    if [ -e "$dir" ]; then
      log "WARN: $dir exists without .git (poisoned partial clone); self-healing by re-cloning"
      rm -rf "$dir"
    fi
    mkdir -p "$(dirname "$dir")"
    tmp="${dir}.tmp.$$"
    rm -rf "$tmp"
    if git clone -q --single-branch --branch "$JOURNAL_BRANCH" "$remote" "$tmp"; then
      mv "$tmp" "$dir" || { rm -rf "$tmp"; die "atomic rename of fresh clone $tmp -> $dir failed"; }
    else
      rm -rf "$tmp"
      die "clone of $remote ($JOURNAL_BRANCH) into $dir failed"
    fi
  fi
  git -C "$dir" config user.name  "$(bot_name)"
  git -C "$dir" config user.email "$(bot_email)"
  clone_unlock "$dir"
}

# --- leader/follower predicate (issue kriskowal/garden#11) -------------------
#
# _journal_git_fetch — the SINGLE timeout-wrapped `git fetch` of the journal branch.
# Both journal-fetch call sites (leader_host's best-effort leader-marker read and
# journal_fetch's bounded retry loop) route through here so the kill-after grace
# policy cannot drift between them. Runs git fetch under `timeout` with BOTH a
# wall-clock bound (GARDEN_FETCH_TIMEOUT, SIGTERM at expiry) and a --kill-after grace
# (GARDEN_FETCH_KILL_AFTER, SIGKILL escalation) — see the GARDEN_FETCH_KILL_AFTER knob
# above for why the SIGKILL escalation is load-bearing (a SIGTERM-ignoring
# git-remote-https orphaning into the cgroup). Passes the caller's stdio through
# untouched (caller redirects); the exit code is timeout's: the git rc on success,
# 124 if SIGTERM ended it at the deadline, 137 if the --kill-after SIGKILL had to.
_journal_git_fetch() {
  timeout --kill-after="$GARDEN_FETCH_KILL_AFTER" "$GARDEN_FETCH_TIMEOUT" \
    git -C "$1" fetch -q origin "$JOURNAL_BRANCH"
}

# leader_host — echo the configured leader's GARDEN identity. Resolution order:
#   1. $GARDEN_LEADER if set (operator/test override; no journal read).
#   2. the cached value when it is younger than GARDEN_LEADER_TTL (cheap, no
#      network — keeps a per-tick ExecCondition from hammering the journal).
#   3. a fresh read of the journal `leader` marker (bounded best-effort fetch
#      into a dedicated clone), which then refreshes the cache.
#   4. the last cached value when the journal is unreachable (transient-outage
#      fallback so a blip never flips a singleton's leader/follower verdict).
# Echoes the identity (possibly empty if nothing is resolvable). Never exits the
# caller: unlike sync_clone it does NOT exit on an offline fetch, because it runs
# as a systemd ExecCondition where a clean 0/1 answer is required, not a skip.
leader_host() {
  if [ -n "${GARDEN_LEADER:-}" ]; then printf '%s\n' "$GARDEN_LEADER"; return 0; fi
  local dir="$GARDEN_LEADER_CLONE" cache="$GARDEN_LEADER_CACHE" val="" now mtime age
  now="$(date +%s 2>/dev/null || echo 0)"
  if [ -f "$cache" ]; then
    mtime="$(stat -c %Y "$cache" 2>/dev/null || echo 0)"
    age=$(( now - mtime ))
    if [ "$age" -ge 0 ] && [ "$age" -lt "$GARDEN_LEADER_TTL" ]; then
      head -1 "$cache" 2>/dev/null | tr -d '[:space:]'; return 0
    fi
  fi
  # Contain ensure_clone in a SUBSHELL: on an unresolvable journal remote it
  # reaches journal_remote's die() → `exit 1`, and a bare `|| true` cannot catch
  # an exit from a same-shell function — leader_host would kill its caller, so
  # is-main-host.sh would exit 1 = "follower" and every singleton would skip its
  # tick on the TRUE leader (silently defeating the GARDEN_LEADER_DEFAULT=leader
  # fail-open this function promises). The subshell converts the exit into a
  # plain non-zero status the `|| true` absorbs; the clone lock is released with
  # the subshell's fds, and the fallback-to-cache path below still runs.
  ( ensure_clone "$dir" ) >/dev/null 2>&1 || true
  _journal_git_fetch "$dir" >/dev/null 2>&1 || true
  val="$(git -C "$dir" show "origin/$JOURNAL_BRANCH:$GARDEN_LEADER_MARKER_PATH" 2>/dev/null | head -1 | tr -d '[:space:]')"
  if [ -n "$val" ]; then
    mkdir -p "$(dirname "$cache")" 2>/dev/null || true
    printf '%s\n' "$val" > "$cache" 2>/dev/null || true
    printf '%s\n' "$val"; return 0
  fi
  # Journal unreachable or marker empty: fall back to the last cached value.
  head -1 "$cache" 2>/dev/null | tr -d '[:space:]'
}

# is_main_host — true (0) when THIS host is the leader, false (1) otherwise. The
# single "am I leader or follower?" check every mode-aware service consults (the
# systemd ExecCondition wrapper is-main-host.sh, the bulletin loop, the watchman
# broadcast gate). When the leader is wholly undeterminable, fall back to
# GARDEN_LEADER_DEFAULT (leader = fail open, the single-host case).
is_main_host() {
  local leader; leader="$(leader_host)"
  if [ -z "$leader" ]; then
    [ "${GARDEN_LEADER_DEFAULT:-leader}" = leader ]
    return
  fi
  [ "$leader" = "$GARDEN" ]
}

# Bounded journal fetch: timeout-wrapped, with backoff + retry. git has no IO
# timeout of its own, so a half-open connection can hang a fetch forever; every
# fetch routes through _journal_git_fetch (above), which bounds it with
# `timeout --kill-after=GARDEN_FETCH_KILL_AFTER GARDEN_FETCH_TIMEOUT`. A timeout
# (exit 124 at the SIGTERM deadline, or 137 if the --kill-after SIGKILL had to
# escalate a SIGTERM-ignoring transport child) or any transient failure is
# retryable, never a hang. Returns 0 on success, the last non-zero rc after
# GARDEN_FETCH_RETRIES attempts. Honors GARDEN_FETCH_CMD for test injection (it
# then owns its own timing).
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
      if GARDEN_FETCH_STDERR="$(_journal_git_fetch "$dir" 2>&1 1>/dev/null)"; then rc=0; else rc=$?; fi
    fi
    [ "$rc" -eq 0 ] && return 0
    # 124 = SIGTERM ended the fetch at the deadline; 137 = a SIGTERM-ignoring transport
    # child was escalated to SIGKILL by --kill-after after GARDEN_FETCH_KILL_AFTER. Both
    # are the same wall-clock-timeout kill — log them identically (and treat both as a
    # transient stall in sync_clone's offline classification below).
    { [ "$rc" -eq 124 ] || [ "$rc" -eq 137 ]; } && log "journal fetch in $dir timed out (>${GARDEN_FETCH_TIMEOUT}s, rc=$rc) on attempt $attempt"
    if [ "$attempt" -ge "$GARDEN_FETCH_RETRIES" ]; then
      log "journal fetch in $dir failed after $attempt attempt(s) (last rc=$rc)${GARDEN_FETCH_STDERR:+: $GARDEN_FETCH_STDERR}"
      return "$rc"
    fi
    backoff "$attempt"; attempt=$((attempt+1))
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
#   * gh top-line: error connecting to <host>   (gh's own transport-failure line,
#                 emitted when the underlying dial-tcp/no-such-host cause is absent)
#                 check your internet connection   (gh's connectivity hint)
# A `Could not resolve host` pattern (no trailing `name`) deliberately covers BOTH
# git-over-HTTPS's `Could not resolve host:` and SSH's `Could not resolve hostname`.
: "${GARDEN_OFFLINE_SIGNATURES:=Could not resolve host|Temporary failure in name resolution|Could not read from remote repository|Connection timed out|Operation timed out|Connection reset by peer|Recv failure|Early EOF|unexpected disconnect|RPC failed|HTTP 5[0-9][0-9]|The requested URL returned error: 5|gnutls_handshake|SSL|TLS|error connecting to|check your internet connection}"

# Classify captured git-fetch stderr ($1) as a connectivity/DNS outage rather
# than a real repository error. These are the transient, self-resolving failures
# a tick should skip over (EX_TEMPFAIL) instead of dying on. Returns 0 if the
# text matches a known outage signature, 1 otherwise. Case-insensitive (-i) so a
# signature classifies regardless of how the producing tool cased it.
_fetch_stderr_is_offline() {
  printf '%s' "$1" | grep -qiE "$GARDEN_OFFLINE_SIGNATURES"
}

# --- bounded read-only gh-api retry (the transient-blip absorber) ------------
#
# Every read-only gh handler in the watcher fleet used to issue a SINGLE bare
# `gh api … --jq … || die`. One transient GitHub blip on that call — a 5xx, a
# 429/secondary-rate-limit, a momentary DNS/TLS/reset — escalated an otherwise
# self-healing tick into a FATAL + nonzero exit, marking the systemd unit Failed
# even though the very next probe would have succeeded (mirror-closer hit exactly
# this on endojs/endo#3137 at 2026-06-29 15:26:06; it self-healed one tick later).
#
# gh_api_retry wraps the call in a bounded full-jitter retry loop so a transient
# blip is absorbed silently, WITHOUT weakening the "never guess a state"
# discipline:
#   * a clean success prints the captured stdout and returns 0 — the ONLY path
#     that yields output;
#   * a DEFINITIVE failure (a 404/401/403/422 client error whose stderr matches
#     no transient signature) is NOT retried — it breaks immediately, so the
#     caller's `|| die` still fails fast and loud;
#   * a TRANSIENT failure is retried under `backoff "$attempt"` up to
#     GARDEN_GH_API_ATTEMPTS (default 4); once exhausted it still fails (nonzero,
#     empty stdout) so the caller dies loud rather than acting on a guess.
#
# Usage (a read; the caller still owns the die):
#   out="$(gh_api_retry "repos/$repo/pulls/$num" --jq '…')" \
#     || die "gh api repos/$repo/pulls/$num failed (no usable state)"
#
# Idempotent writes (a dedup'd reactji POST) may also use it — re-POSTing the
# same reaction from one identity is a GitHub no-op, so a retried POST is safe.
# Do NOT wrap a non-idempotent write. The handler keeps its own require_tools /
# `command -v gh` precondition; this helper assumes gh is already on PATH.
#
# On the FINAL failure the captured gh stderr is surfaced (a WARN log naming the
# definitive-vs-exhausted reason and the gh stderr) so an outage triage is never
# blind to the cause.
GARDEN_GH_API_ATTEMPTS="${GARDEN_GH_API_ATTEMPTS:-4}"
# Transient gh-api failure signatures: a 5xx gateway/overload, throttling (429 /
# rate limit / secondary-rate / abuse detection), and the shared connectivity set
# (DNS / TLS / reset / timeout) GARDEN_OFFLINE_SIGNATURES already names. A failure
# whose stderr matches NONE of these is DEFINITIVE (a 404/401/403/422 that
# re-running cannot fix) and is not retried. Matched case-insensitively.
#
# `gh` runs on Go's net/http stack, which emits DIFFERENT timeout/transport wording
# than git's curl/SSH transport (the offline set). A transient dial/TLS timeout from
# `gh api` surfaces as e.g. `dial tcp 140.82.116.5:443: i/o timeout` — words the
# offline set never names — so without the Go signatures below it is misclassified
# DEFINITIVE and crashes the caller (observed: garden-mirror-closer exit 1 on
# endojs/endo#3137 at 2026-06-29 21:14:03). These are added to the gh-api set ONLY,
# never to GARDEN_OFFLINE_SIGNATURES, which classifies git's transport for
# clone/fetch and must not absorb a Go-only string (e.g. a bare `EOF`) spuriously.
: "${GARDEN_TRANSIENT_GH_API_SIGNATURES:=HTTP 5[0-9][0-9]|HTTP 429|rate limit|secondary rate|abuse detection|i/o timeout|dial tcp|context deadline exceeded|net/http: TLS handshake timeout|no such host|server misbehaving|\bEOF\b|${GARDEN_OFFLINE_SIGNATURES}}"

# Classify captured gh stderr ($1) as a transient (self-resolving) gh-api failure:
# returns 0 on a transient signature, 1 on a definitive one. Case-insensitive.
_gh_api_stderr_is_transient() {
  printf '%s' "$1" | grep -qiE "$GARDEN_TRANSIENT_GH_API_SIGNATURES"
}

# gh_api_retry <gh-api-args…> — run `gh api <args…>` with bounded transient retry.
# Prints captured stdout and returns 0 ONLY on a clean success; returns the gh
# rc with empty stdout on a definitive error (no retry) or after the transient
# retries are exhausted. See the block comment above for the full contract.
gh_api_retry() {
  local attempt=1 out rc errf stderr label a
  # A human-readable label for the logs: the first arg that looks like an API
  # path/query (has a `/` or `?`), so `--paginate` / `-X GET` / `--jq` flags do
  # not become the label. The API path always precedes any `--jq` in our callers.
  label="gh api"
  for a in "$@"; do case "$a" in */*|*\?*) label="$a"; break;; esac; done
  errf="$(mktemp 2>/dev/null || printf '%s' "${TMPDIR:-/tmp}/gh_api_retry.$$")"
  while :; do
    # Capture stdout (the payload) and stderr (the diagnostic) separately. The
    # `if` keeps a non-zero gh from tripping the caller's `set -e` before $rc is
    # read; gh's stderr goes to a temp file so the returned stdout stays clean.
    if out="$(gh api "$@" 2>"$errf")"; then rc=0; else rc=$?; fi
    if [ "$rc" -eq 0 ]; then
      rm -f "$errf"
      printf '%s' "$out"
      return 0
    fi
    stderr="$(cat "$errf" 2>/dev/null || true)"
    # Definitive failure (no transient signature): do NOT retry — fail now so the
    # caller dies fast and loud, preserving "never guess a state".
    if ! _gh_api_stderr_is_transient "$stderr"; then
      log "WARN: gh api $label failed (definitive, rc=$rc); not retrying: ${stderr:-<no stderr>}"
      rm -f "$errf"
      return "$rc"
    fi
    # Transient blip: retry under full-jitter backoff until attempts are spent.
    if [ "$attempt" -ge "$GARDEN_GH_API_ATTEMPTS" ]; then
      log "WARN: gh api $label failed after $attempt transient attempt(s) (rc=$rc): ${stderr:-<no stderr>}"
      rm -f "$errf"
      return "$rc"
    fi
    log "gh api $label transient blip (rc=$rc); retry $((attempt+1))/$GARDEN_GH_API_ATTEMPTS after backoff: ${stderr:-<no stderr>}"
    backoff "$attempt"
    attempt=$((attempt+1))
  done
}

# gh_pr_view_retry <gh-pr-view-args…> — the `gh pr view` sibling of gh_api_retry.
#
# `gh pr view` does NOT route through `gh api`, so it cannot reuse gh_api_retry
# directly; this thin mirror drives the SAME transient absorber
# (_gh_api_stderr_is_transient) and the SAME bounded full-jitter backoff
# (GARDEN_GH_API_ATTEMPTS) over the `gh pr view` transport. `gh pr view` runs on
# the same Go net/http stack as `gh api`, so it emits the same transient wording
# (net/http: TLS handshake timeout, dial tcp … i/o timeout, context deadline
# exceeded, …) the gh-api signature set already names — so a single transient
# blip no longer drops a PR's CI verdict for a whole tick (the recurring
# `#503/#313/#463 rollup unreadable (TLS handshake timeout)` WARNs where one
# retry would have recovered, and endojs-endo-but-for-bots#286 where one
# TLS-handshake-timeout left a red PR unshepherded).
#
# Contract mirrors gh_api_retry exactly: prints captured stdout and returns 0
# ONLY on a clean success; a DEFINITIVE failure (a 404/401/403/422 whose stderr
# matches no transient signature) is NOT retried (fast + loud); a TRANSIENT
# failure is retried under `backoff "$attempt"` up to GARDEN_GH_API_ATTEMPTS,
# then still fails (nonzero, empty stdout) so the caller skips rather than
# guesses a state. Throttling (429 / rate limit / secondary-rate / abuse) is a
# transient signature and IS retried here, same as everywhere else in the fleet
# — the bounded, jittered budget cannot deepen a cooldown the way an unbounded
# retry would. The gh binary is "${GARDEN_GH:-gh}" (the same test seam
# ci-wait-merge.sh uses to inject a stub).
gh_pr_view_retry() {
  local attempt=1 out rc errf stderr label gh_bin a
  gh_bin="${GARDEN_GH:-gh}"
  # Label the logs with the first positional (the PR number/URL), skipping flags.
  label="gh pr view"
  for a in "$@"; do case "$a" in -*) ;; *) label="gh pr view $a"; break;; esac; done
  errf="$(mktemp 2>/dev/null || printf '%s' "${TMPDIR:-/tmp}/gh_pr_view_retry.$$")"
  while :; do
    if out="$("$gh_bin" pr view "$@" 2>"$errf")"; then rc=0; else rc=$?; fi
    if [ "$rc" -eq 0 ]; then
      rm -f "$errf"
      printf '%s' "$out"
      return 0
    fi
    stderr="$(cat "$errf" 2>/dev/null || true)"
    # Definitive failure (no transient signature): do NOT retry — fail now so the
    # caller skips fast and loud, preserving "never guess a state".
    if ! _gh_api_stderr_is_transient "$stderr"; then
      log "WARN: $label failed (definitive, rc=$rc); not retrying: ${stderr:-<no stderr>}"
      rm -f "$errf"
      return "$rc"
    fi
    # Transient blip: retry under full-jitter backoff until attempts are spent.
    if [ "$attempt" -ge "$GARDEN_GH_API_ATTEMPTS" ]; then
      log "WARN: $label failed after $attempt transient attempt(s) (rc=$rc): ${stderr:-<no stderr>}"
      rm -f "$errf"
      return "$rc"
    fi
    log "$label transient blip (rc=$rc); retry $((attempt+1))/$GARDEN_GH_API_ATTEMPTS after backoff: ${stderr:-<no stderr>}"
    backoff "$attempt"
    attempt=$((attempt+1))
  done
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
#   * hit your session/usage limit          (Claude Code 5-hour session/usage cap,
#     e.g. "You've hit your session limit · resets 1:10am (UTC)" — a cap that names
#     its own reset time is the definitive self-resolving transient; requeuing past
#     the named reset succeeds. The `resets N…(utc)` alternative also catches the
#     usage-cap wording that leads with the reset clause.)
#     A follow-on worth doing but out of this change's scope: when the signature
#     carries an explicit reset time, back off the reaper requeue until that time
#     instead of re-failing every TTL cycle (parse the "resets H:MMam (UTC)" clause).
: "${GARDEN_TRANSIENT_CLAUDE_SIGNATURES:=overloaded|rate[ _-]?limit|connection error|\b(429|5[0-9][0-9])\b|api[ _-]?error|econnreset|etimedout|hit your (session|usage) limit|(session|usage|5-hour) limit (reached|reset)|resets [0-9].*\(utc\)}"

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

# Classify a handler exit code ($1) as a WALL-CLOCK-TIMEOUT kill: the handler was
# terminated by its own `timeout --signal=TERM "$GARDEN_HANDLER_TIMEOUT"` wrapper
# (gardener.sh's single-call-site runtime bound), which surfaces as rc=124 — the
# fourth external-kill source alongside the three OS-signal codes is_external_kill_rc
# covers (deploy/drain SIGTERM 143, SIGINT 130, OOM/SIGKILL 137). Returns 0 for 124,
# 1 otherwise. This is a DISTINCT classifier, not folded into is_external_kill_rc,
# because 124 is `timeout`'s own exit code, NOT a POSIX signal code (the wrapper TERMs
# the handler but reports expiry as 124, masking the underlying 143) — keeping the two
# helpers disjoint preserves is_external_kill_rc's signal-code purity while still
# classifying the wall-clock kill as transient.
#
# Treat it EXACTLY like the signal-kill transients: a handler hitting the wall-clock
# bound is an EXTERNAL termination (the supervisor wrapper killed it), not a
# deterministic job defect, so capture content is IRRELEVANT (an inherently-long
# handler — e.g. a shepherd driving CI to green at the 2400s window — flushes plenty
# of legitimate progress output before the kill and must NOT be escalated as a defect
# for having done so). gardener.sh branches this into the SAME transient path as
# is_external_kill_rc: ONE kind:progress note, NO gardener-inbox kind:error, left in
# doin for the reaper. A genuinely DEADLOCKED handler still surfaces — it times out
# every cycle, so the reaper's `<!-- garden-reaped: N -->` poison counter escalates it
# as poison after GARDEN_REAP_POISON_THRESHOLD cycles, rather than spamming a
# kind:error on every single requeue.
is_handler_timeout_rc() {
  case "$1" in
    124) return 0 ;;
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

# --- job completion signal ---------------------------------------------------
#
# The deterministic "the job genuinely finished" contract between the `claude -p`
# worker, its handler, and gardener.sh. gardener.sh gates a doin→tada completion
# on the PRESENCE of the completion SENTINEL file (GARDEN_COMPLETION_SENTINEL),
# NOT on the handler's exit code. A `claude` that exits 0 without finishing —
# quota/usage cut mid-response, an API error swallowed to a clean exit, or a run
# that simply "did not reach a satisfying conclusion" — must NOT be recorded as
# done (doin→tada) and lost in tada where the reaper never requeues it. Instead
# the absence of the sentinel makes gardener.sh requeue the job (via the reaper's
# single-writer reap-now path), exactly as a non-zero transient failure does.
#
# The signal has two layers so gardener.sh stays handler-agnostic:
#   1. WORKER contract — the `claude -p` agent emits GARDEN_COMPLETION_MARKER as
#      the final line of its report, as its last deterministic act, ONLY when it
#      has genuinely finished the job. A truncated/quota-cut/unsatisfying run does
#      not reach that final act, so the marker is absent.
#   2. HANDLER contract — the handler confirms `claude` exited 0 AND the marker is
#      present (report_has_completion_marker), strips the marker from the report
#      (strip_completion_marker, so it never lands in the tada report), and only
#      then writes the sentinel at GARDEN_COMPLETION_SENTINEL. A test stub that
#      simulates a genuine completion just writes the sentinel directly.
# gardener.sh reads only the sentinel: present → complete; absent → requeue.
GARDEN_COMPLETION_MARKER='<<<GARDEN-JOB-COMPLETE>>>'

# report_has_completion_marker <report-file> — 0 iff the report's LAST non-blank
# line is exactly the completion marker (the worker's final deterministic act).
# Anchoring on the last non-blank line means a marker quoted mid-report (a job
# spec that mentions it, a diff) cannot forge completion — only a run that reached
# its final act and emitted the marker last passes.
report_has_completion_marker() {
  local f="${1:-}" last
  [ -f "$f" ] || return 1
  last="$(awk 'NF{l=$0} END{print l}' "$f")"
  [ "$last" = "$GARDEN_COMPLETION_MARKER" ]
}

# strip_completion_marker <report-file> — remove the trailing completion-marker
# line (and any surrounding trailing blank lines) in place, so the human-facing
# tada report never carries the machine marker. No-op if the marker is absent.
strip_completion_marker() {
  local f="${1:-}"
  [ -f "$f" ] || return 0
  awk -v m="$GARDEN_COMPLETION_MARKER" '
    { line[NR]=$0 }
    END {
      n=NR
      while (n>0 && line[n] ~ /^[ \t]*$/) n--   # trailing blanks
      if (n>0 && line[n]==m) n--                # the marker line itself
      while (n>0 && line[n] ~ /^[ \t]*$/) n--   # blanks that preceded it
      for (i=1;i<=n;i++) print line[i]
    }
  ' "$f" > "$f.stripmarker" && mv "$f.stripmarker" "$f"
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

# --- elapsed-constancy early-escalation --------------------------------------
#
# A transient CLASSIFICATION is not proof of a self-resolving blip. A job that
# deterministically OVERRUNS and dies with a transient-claude signature (a Claude
# Code session/usage cap that trips at the same point every run, or a prompt that
# always drives the CLI to the same failure) is classified transient by
# gardener.sh's handler-failure classifier and requeued — burning all
# GARDEN_REAP_POISON_THRESHOLD (default 5) cycles before the reaper's poison
# counter surfaces it (~5×TTL). Its TELL is a near-CONSTANT elapsed across requeue
# cycles: a genuine deploy/drain/OOM blip is killed at a VARIED elapsed (and reads
# as an external-kill/timeout rc), whereas a deterministic overrun dies at the same
# wall-time every cycle. These two helpers let gardener.sh make that "is this
# actually stuck?" call in the script, READ-ONLY of state it already holds, so a
# misclassified job surfaces in ~2 cycles instead of ~5 — without a human or a
# watchman grep, and without the gardener ever writing the requeue (the reaper
# stays the sole requeue writer; the gardener only escalates a warning).

# prior_transient_elapsed_series <clone> <base> — echo the elapsed seconds (one
# integer per line, oldest→newest) recovered READ-ONLY from this gardener-clone's
# prior progress journal entries for job <base>. Each transient/overrun note
# gardener.sh posts carries `job <base> handler exited … elapsed=<N>s`; this greps
# those notes (the clone was synced at claim time, so it holds prior cycles' notes
# but NOT the current one) so a later cycle can tell a near-CONSTANT elapsed from a
# VARIED one — no new state, no CAS. The `job <base> handler exited` anchor pins
# the base with a trailing token so a base that is a prefix of another cannot
# bleed in. Entries sort chronologically by their entries/YYYY/MM/DD/HHMMSSZ-…
# path, so `sort` on the matching filenames orders the series oldest→newest.
# Always returns 0 (an empty series is not an error).
prior_transient_elapsed_series() {
  local clone="${1:-}" base="${2:-}" dir f
  dir="$clone/entries"
  [ -n "$clone" ] && [ -n "$base" ] && [ -d "$dir" ] || return 0
  grep -rlF "job $base handler exited" "$dir" 2>/dev/null | sort | while IFS= read -r f; do
    sed -n 's/.*elapsed=\([0-9][0-9]*\)s.*/\1/p' "$f" | head -1
  done || true
}

# elapsed_within_band <tol_pct> <v1> <v2> … — 0 iff every value is within a
# ±<tol_pct>% band of a common center, i.e. the series is near-constant. The
# integer-safe test is max·(100−tol) ≤ min·(100+tol): if the spread from the
# smallest to the largest value stays inside the tolerance window they agree.
# Needs ≥2 positive integer values; returns 1 (not near-constant) otherwise, and
# on any non-integer/zero argument (a malformed series is treated as inconclusive,
# never as constant).
elapsed_within_band() {
  local tol="${1:-}"; shift || return 1
  case "$tol" in ''|*[!0-9]*) return 1 ;; esac
  [ "$#" -ge 2 ] || return 1
  local v min='' max=''
  for v in "$@"; do
    case "$v" in ''|*[!0-9]*) return 1 ;; esac
    [ "$v" -gt 0 ] || return 1
    if [ -z "$min" ] || [ "$v" -lt "$min" ]; then min="$v"; fi
    if [ -z "$max" ] || [ "$v" -gt "$max" ]; then max="$v"; fi
  done
  [ "$(( max * (100 - tol) ))" -le "$(( min * (100 + tol) ))" ]
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
    if commit_and_push "$clone" "reap-now: hint $rel by $GARDEN (transient handler kill)"; then rc=0; else rc=$?; fi
    [ "$rc" -eq 0 ] && return 0
    [ "$rc" -eq 2 ] && return 0   # nothing to commit (a racing stamp won): treat as landed
    backoff "$attempt"            # rc=1: CAS lost — re-sync and retry
  done
  return 1
}

# --- deadline-overrun hint ---------------------------------------------------
#
# A DISTINCT marker for the ONE transient shape that is NOT a self-resolving blip:
# a handler killed by its OWN wall-clock bound (rc=124 via is_handler_timeout_rc)
# at an elapsed AT the wall — GARDEN_HANDLER_TIMEOUT ± GARDEN_HANDLER_KILL_AFTER —
# rather than an external SIGTERM/OOM/drain that varies in elapsed. Such a handler
# will be killed IDENTICALLY on every requeue: the job simply exceeds the handler
# budget. Requeuing it the full GARDEN_REAP_POISON_THRESHOLD (5) cycles before the
# reaper surfaces it burns ~5×GARDEN_HANDLER_TIMEOUT (~200 min) of gardener
# wall-clock for a verdict that two identical deadline hits already prove. So the
# gardener stamps a per-job COUNTER here, and the reaper escalates a job carrying it
# to POISON after the much lower GARDEN_REAP_OVERRUN_THRESHOLD (2) instead.
#
# The marker is a COUNTER the GARDENER owns and increments (distinct from the
# reaper-owned `<!-- garden-reaped: N -->` cycle counter): each wall-hit cycle the
# gardener reads the prior N and re-stamps N+1. Unlike the reap-now hint it must
# PERSIST across a requeue so the count accumulates — reaper.sh's clean_body drops
# only the reap-count and reap-now markers, so this one survives the requeue in the
# body by construction (and a re-claim appends the claim block BELOW it). It is
# stamped ALONGSIDE the reap-now hint so the reaper still requeues promptly (≤1 tick)
# rather than idling the full GARDEN_CLAIM_TTL; the two markers ride together.
DEADLINE_OVERRUN_MARKER_RE='^<!-- garden-deadline-overrun: [0-9][0-9]* -->$'

# deadline_overrun_count <file> — the gardener's deadline-overrun cycle count carried
# on a job, read from its `<!-- garden-deadline-overrun: N -->` marker. Echoes N, or 0
# when the marker is absent (a job that has never hit its own wall) or the file is
# missing. READ-ONLY; mirrors reap_count's extraction shape.
deadline_overrun_count() {
  local f="${1:-}" n
  [ -f "$f" ] || { printf '0\n'; return 0; }
  n="$(sed -n 's/^<!-- garden-deadline-overrun: \([0-9][0-9]*\) -->$/\1/p' "$f" | tail -1)"
  printf '%s\n' "${n:-0}"
}

# stamp_deadline_overrun_hint <clone> <doin-relpath> — increment and re-stamp the
# deadline-overrun COUNTER in the BODY of a still-in-doin claim (dropping any prior
# overrun marker so the count never accumulates duplicates) AND stamp the reap-now
# hint beside it, both just above the trailing claim block, then land it on the
# board. The reaper then requeues the claim on its NEXT tick (via the reap-now hint)
# and, once the counter reaches GARDEN_REAP_OVERRUN_THRESHOLD, poisons it early
# instead of burning the full GARDEN_REAP_POISON_THRESHOLD cycles. Bounded CAS retry
# reusing sync_clone/commit_and_push; returns 0 once landed (or the claim is already
# gone), non-zero only if it could not land (caller falls back to the TTL requeue).
# Run in a SUBSHELL from a long-lived caller: sync_clone `exit`s on a connectivity
# blip, which a subshell contains. Mirrors stamp_reap_now_hint's contract.
#
# The optional third arg is a short REASON woven into the commit message so the
# git log distinguishes the two callers that stamp this same counter: a handler
# that hit its OWN wall-clock bound (rc=124 at the wall — the default reason) and
# the elapsed-constancy path, which confirms a DETERMINISTIC overrun from a
# near-constant elapsed across requeue cycles and reuses this early-poison counter
# so the reaper poisons after GARDEN_REAP_OVERRUN_THRESHOLD rather than the full
# poison threshold. The MARKER is identical either way (the reaper only knows the
# one `garden-deadline-overrun` counter); only the audit-trail wording differs.
stamp_deadline_overrun_hint() {
  local clone="$1" rel="$2" reason="${3:-handler wall-clock overrun}" attempt f rc prev new
  : "${GARDEN_REAP_NOW_PUSH_ATTEMPTS:=25}"
  for attempt in $(seq 1 "$GARDEN_REAP_NOW_PUSH_ATTEMPTS"); do
    sync_clone "$clone"
    f="$clone/$rel"
    if [ ! -e "$f" ]; then clone_unlock "$clone"; return 0; fi      # already moved by a peer
    prev="$(deadline_overrun_count "$f")"
    new=$(( prev + 1 ))
    awk -v rnow="$REAP_NOW_MARKER" -v rnow_re="$REAP_NOW_MARKER_RE" \
        -v ovr_re="$DEADLINE_OVERRUN_MARKER_RE" -v ovr="<!-- garden-deadline-overrun: $new -->" '
      { line[NR] = $0 }
      END {
        cut = 0
        for (i = 1; i < NR; i++) if (line[i] == "---" && line[i+1] == "claim:") cut = i
        for (i = 1; i <= NR; i++) {
          if (cut > 0 && i == cut) { print ovr; print rnow }  # insert both, in the body above the claim block
          if (line[i] ~ ovr_re) continue                      # drop the prior overrun marker (re-stamped incremented)
          if (line[i] ~ rnow_re) continue                     # drop a prior reap-now hint (idempotent)
          print line[i]
        }
        if (cut == 0) { print ovr; print rnow }               # no claim block: append (defensive)
      }
    ' "$f" > "$f.overrun" && mv "$f.overrun" "$f"
    git -C "$clone" add "$rel"
    if commit_and_push "$clone" "deadline-overrun: hint $rel (cycle $new) by $GARDEN ($reason)"; then rc=0; else rc=$?; fi
    [ "$rc" -eq 0 ] && return 0
    [ "$rc" -eq 2 ] && return 0   # nothing to commit (a racing stamp won): treat as landed
    backoff "$attempt"            # rc=1: CAS lost — re-sync and retry
  done
  return 1
}

# --- productive-cycle hint ---------------------------------------------------
#
# The reaper counts requeue cycles (`<!-- garden-reaped: N -->`) and POISONS a job
# after GARDEN_REAP_POISON_THRESHOLD cycles on the assumption that a handler which
# is requeued that many times "fails every time". But a long builder on the
# SANCTIONED RESUME TREADMILL — push green commits each cycle, then exit WITHOUT the
# completion signal before the handler wall, and RESUME on the next claim — trips the
# SAME counter even though EVERY cycle lands real progress. xs2rust-endor-build-stage3
# was false-poisoned exactly this way (2026-07-03): its tracked HEAD advanced across
# the "failing" cycles, yet the counter climbed to the threshold and it was dropped.
#
# The fix: a cycle in which the handler made REAL PROGRESS (a per-job worktree HEAD
# advanced — it committed / pushed work) is PRODUCTIVE and must NOT count toward
# poison. The gardener DETECTS progress (it owns the worktree locally; see gardener.sh
# job_worktree_heads/job_cycle_productive around the handler call) and stamps THIS
# marker on its still-in-doin claim; the reaper READS it and RESETS the reap-count
# rather than incrementing, so only cycles with NO progress accumulate toward the
# drop. A genuinely-failing job (no commits, hard error every cycle) never earns the
# marker and still poisons at the threshold.
#
# The marker is a BOOLEAN hint present iff the LAST cycle was productive — unlike the
# reaper-owned reap-count and the gardener-owned deadline-overrun COUNTER, it does not
# accumulate. reaper.sh's clean_body STRIPS it on requeue (like the reap-now hint) so
# it never persists into the next cycle: each cycle must RE-EARN productivity by a
# fresh gardener stamp. Stamped alongside the reap-now hint so the reaper still
# requeues promptly; the two ride together.
PRODUCTIVE_MARKER='<!-- garden-productive-cycle -->'
PRODUCTIVE_MARKER_RE='^<!-- garden-productive-cycle -->$'

# has_productive_cycle_hint <file> — 0 iff the job file carries the productive marker.
has_productive_cycle_hint() {
  local f="${1:-}"
  [ -f "$f" ] || return 1
  grep -Eq "$PRODUCTIVE_MARKER_RE" "$f"
}

# stamp_productive_cycle_hint <clone> <doin-relpath> — insert the productive marker
# into the BODY of a still-in-doin claim (just above the trailing claim block) and
# land it on the board, so the reaper RESETS the poison counter for this cycle instead
# of incrementing it. Idempotent: a claim already carrying the hint, or already moved
# out of doin, is left as-is. Bounded CAS retry against journal push contention,
# reusing sync_clone/commit_and_push. Returns 0 once the hint is on the board (or was
# already there / the claim is gone), non-zero only if it could not land. Run in a
# SUBSHELL from a long-lived caller: sync_clone `exit`s GARDEN_OFFLINE_RC on a
# connectivity blip, which a subshell contains. Mirrors stamp_reap_now_hint's contract.
stamp_productive_cycle_hint() {
  local clone="$1" rel="$2" attempt f rc
  : "${GARDEN_REAP_NOW_PUSH_ATTEMPTS:=25}"
  for attempt in $(seq 1 "$GARDEN_REAP_NOW_PUSH_ATTEMPTS"); do
    sync_clone "$clone"
    f="$clone/$rel"
    if [ ! -e "$f" ]; then clone_unlock "$clone"; return 0; fi           # already moved by a peer
    if has_productive_cycle_hint "$f"; then clone_unlock "$clone"; return 0; fi  # already hinted
    awk -v m="$PRODUCTIVE_MARKER" '
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
    ' "$f" > "$f.prod" && mv "$f.prod" "$f"
    git -C "$clone" add "$rel"
    if commit_and_push "$clone" "productive-cycle: hint $rel by $GARDEN (handler advanced a worktree HEAD)"; then rc=0; else rc=$?; fi
    [ "$rc" -eq 0 ] && return 0
    [ "$rc" -eq 2 ] && return 0   # nothing to commit (a racing stamp won): treat as landed
    backoff "$attempt"            # rc=1: CAS lost — re-sync and retry
  done
  return 1
}

# --- outage-cycle hint (the sustained-outage poison-pause) --------------------
#
# A job's handler can transient-fail purely because the WHOLE FLEET is in a
# correlated outage — a Claude quota/usage cut, an API-overload storm — that has
# nothing to do with THIS job's content. Left alone, GARDEN_REAP_POISON_THRESHOLD
# such cycles poison an otherwise-healthy job (park it held, page the maintainer)
# even though every failure was environmental and self-resolving — the 2026-07-01
# storm that poisoned a dozen unrelated jobs, and the case this marker exists to
# prevent.
#
# The discriminator is the shared FLEET BRAKE: a per-job defect fails while its
# peers succeed; a fleet-wide outage makes MANY handlers fail at once, which is
# exactly the correlated-transient DENSITY the brake already measures. So when a
# gardener transient-fails AND fleet_brake_engaged is true (the same predicate that
# PAUSES claiming), it stamps THIS marker on its still-in-doin claim; the reaper
# READS it and PAUSES the poison counter for that cycle — HOLDS it steady, neither
# incrementing toward the threshold nor resetting it — so cycles that failed only
# because the fleet was down do not accrue toward poison, while a job that still
# fails once the outage clears poisons on its own (non-outage) cycles.
#
# Distinct from the productive-cycle hint, which RESETS the counter on real
# progress: an outage cycle made no progress, so it HOLDS rather than resets (a
# reset would let intermittent outages erase legitimate prior failures and shield a
# genuinely-broken job forever). Like the productive/reap-now hints it is a BOOLEAN
# present iff the LAST cycle failed under an engaged brake; reaper.sh's clean_body
# STRIPS it on requeue so it never persists — each cycle must RE-EARN the outage
# classification by a fresh gardener stamp under a still-engaged brake. Stamped
# alongside the reap-now hint so the reaper still requeues promptly; the two ride
# together.
OUTAGE_MARKER='<!-- garden-outage-cycle -->'
OUTAGE_MARKER_RE='^<!-- garden-outage-cycle -->$'

# has_outage_cycle_hint <file> — 0 iff the job file carries the outage marker.
has_outage_cycle_hint() {
  local f="${1:-}"
  [ -f "$f" ] || return 1
  grep -Eq "$OUTAGE_MARKER_RE" "$f"
}

# stamp_outage_cycle_hint <clone> <doin-relpath> — insert the outage marker into the
# BODY of a still-in-doin claim (just above the trailing claim block) and land it on
# the board, so the reaper PAUSES the poison counter for this cycle. Idempotent (a
# claim already carrying the hint, or already moved out of doin, is left as-is),
# bounded CAS retry against journal push contention, subshell-safe — mirrors
# stamp_productive_cycle_hint's contract exactly.
stamp_outage_cycle_hint() {
  local clone="$1" rel="$2" attempt f rc
  : "${GARDEN_REAP_NOW_PUSH_ATTEMPTS:=25}"
  for attempt in $(seq 1 "$GARDEN_REAP_NOW_PUSH_ATTEMPTS"); do
    sync_clone "$clone"
    f="$clone/$rel"
    if [ ! -e "$f" ]; then clone_unlock "$clone"; return 0; fi              # already moved by a peer
    if has_outage_cycle_hint "$f"; then clone_unlock "$clone"; return 0; fi # already hinted
    awk -v m="$OUTAGE_MARKER" '
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
    ' "$f" > "$f.outage" && mv "$f.outage" "$f"
    git -C "$clone" add "$rel"
    if commit_and_push "$clone" "outage-cycle: hint $rel by $GARDEN (transient failure under engaged fleet brake)"; then rc=0; else rc=$?; fi
    [ "$rc" -eq 0 ] && return 0
    [ "$rc" -eq 2 ] && return 0   # nothing to commit (a racing stamp won): treat as landed
    backoff "$attempt"            # rc=1: CAS lost — re-sync and retry
  done
  return 1
}

# --- per-job progress detection (the productive-cycle signal source) ---------
#
# A job's real work lands in ISOLATED per-job git worktrees under GARDEN_SCRATCH: the
# garden worktree (gardener-wt-<base>, created by handlers/gardener-claude.sh) and any
# project checkouts (project-wt-<base_safe>-<disc>, from ensure-project-worktree.sh).
# Both are keyed by the UNIQUE job base and PERSIST across a reaper requeue so a resumed
# run re-enters them, which is exactly what lets the gardener compare git state ACROSS a
# handler run and see whether the cycle committed anything.

# job_worktree_heads <base> — print `<worktree-path>:<HEAD-sha>` for every per-job git
# worktree under GARDEN_SCRATCH that exists and has a resolvable HEAD (the garden
# worktree and any project checkouts). Empty output when none exist yet. READ-ONLY.
job_worktree_heads() {
  local base="${1:?base}" base_safe wt head
  base_safe="${base//[^A-Za-z0-9._-]/-}"
  for wt in "$GARDEN_SCRATCH/gardener-wt-$base" "$GARDEN_SCRATCH"/project-wt-"$base_safe"-*; do
    [ -e "$wt/.git" ] || continue
    head="$(git -C "$wt" rev-parse HEAD 2>/dev/null || true)"
    [ -n "$head" ] && printf '%s:%s\n' "$wt" "$head"
  done
}

# job_cycle_productive <before-heads> <after-heads> — 0 (productive) iff SOME per-job
# worktree present in BOTH snapshots advanced its HEAD across the handler run — the
# handler committed real work this cycle. A worktree that ONLY appears in `after` is a
# freshly-created checkout (setup, not a commit) and does NOT count, so merely creating
# a worktree cannot be mistaken for progress; this is why the RESUME cycles (2nd+,
# where the worktree persisted from the prior cycle so it is in `before` too) are what
# this reliably detects — precisely the resume-treadmill class it must protect.
# Snapshots are newline-separated `path:sha` from job_worktree_heads.
job_cycle_productive() {
  local before="$1" after="$2" line path sha bsha
  while IFS= read -r line; do
    [ -n "$line" ] || continue
    path="${line%%:*}"; sha="${line##*:}"
    bsha="$(printf '%s\n' "$before" | awk -F: -v p="$path" '$1==p{print $2; exit}')"
    [ -n "$bsha" ] || continue           # path not in `before` → newly created, not progress
    [ "$bsha" != "$sha" ] && return 0     # a persisted worktree advanced → productive
  done <<< "$after"
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
    #   * rc=124 or rc=137: journal_fetch's `timeout` killed a stalled fetch after
    #     bounded retries (it already logged the timeout). A half-open connection that
    #     never makes progress is the commonest symptom under ~100-gardener
    #     contention; promote the timeout to the clean-skip path rather than dying.
    #     124 is the SIGTERM-at-deadline kill; 137 is the --kill-after SIGKILL
    #     escalation for a transport child that ignored SIGTERM (GARDEN_FETCH_KILL_AFTER)
    #     — both are the same wall-clock stall, so both take the clean-skip path.
    #   * any rc whose captured stderr matches a known outage signature. These
    #     surface under SEVERAL exit codes (128, 1, 6, …), not just 128 — git/curl/
    #     OpenSSH disagree — so we gate on the signature, NOT a hard rc==128.
    if [ "$rc" -eq 124 ] || [ "$rc" -eq 137 ] || _fetch_stderr_is_offline "$GARDEN_FETCH_STDERR"; then
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
    # Same guarded idiom as the first fetch above: a bare `journal_fetch ...; rc=$?`
    # is a `set -e` exit at the call itself when the re-fetch ALSO fails (the classic
    # connectivity outage), killing the process with the raw rc before the offline
    # classification below can run.
    if journal_fetch "$dir"; then rc=0; else rc=$?; fi
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
# (Part B) for the prompt-on-failure capture pattern.
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

# Bootstrap the env `systemctl --user` needs in non-login/cron/ssh contexts:
# USER (some systemd/loginctl paths read it), XDG_RUNTIME_DIR (how `systemctl
# --user` finds the user bus — absent it fails "No medium found"), and the dbus
# session address derived from it. All idempotent (`:=` only fills an unset var),
# so it is safe to call repeatedly and safe when systemd already set them for a
# user service. Lingering via `loginctl enable-linger` — which creates
# /run/user/<uid> — is a separate one-time operator step.
systemd_user_env() {
  : "${USER:=$(id -un)}"; export USER
  : "${XDG_RUNTIME_DIR:=/run/user/$(id -u)}"; export XDG_RUNTIME_DIR
  : "${DBUS_SESSION_BUS_ADDRESS:=unix:path=$XDG_RUNTIME_DIR/bus}"; export DBUS_SESSION_BUS_ADDRESS
}

# Apply it at source time so EVERY script sourcing common.sh gets the env
# globally — not only the calls that route through unit_ctl(). This is what makes
# a direct `systemctl --user ...` in any fleet script Just Work, retiring the
# per-instance self-heal. (Login shells are covered separately by
# /etc/profile.d/garden.sh, since they do not source common.sh.)
systemd_user_env

# Unit control, indirected so tests can mock it. Set GARDEN_UNIT_CTL to a
# command that receives the same args as `systemctl --user`.
unit_ctl() {
  if [ -n "${GARDEN_UNIT_CTL:-}" ]; then "$GARDEN_UNIT_CTL" "$@"; else
    systemd_user_env; systemctl --user "$@"
  fi
}

# Bounded per-unit control. Runs the SAME command unit_ctl would (the mock or
# `systemctl --user`) but under `timeout`, so no single hung/slow `systemctl` call
# (a wedged user-manager or dbus) can stall a whole scale/reconcile loop past its
# service window — garden-gardener-scaler.service is a Type=oneshot with
# TimeoutStartSec=900, and one blocked `disable --now` over ~100 gardener units
# used to eat the entire window and get SIGKILLed, leaving the pool unreconciled.
# `-k` escalates to SIGKILL for a call that ignores SIGTERM. On the deadline
# `timeout` exits 124 (137 when the kill was needed); callers treat that as "skip
# this unit and continue — a later scaler tick retries it" rather than blocking.
# The bound is a few seconds by default; GARDEN_UNIT_CTL_TIMEOUT overrides it.
unit_ctl_bounded() {
  local secs="${GARDEN_UNIT_CTL_TIMEOUT:-5}"
  if [ -n "${GARDEN_UNIT_CTL:-}" ]; then
    timeout -k 2 "$secs" "$GARDEN_UNIT_CTL" "$@"
  else
    systemd_user_env; timeout -k 2 "$secs" systemctl --user "$@"
  fi
}

# foreman_kick — deterministic, non-blocking, best-effort EDGE trigger that asks
# the foreman to re-evaluate the board the instant a gardener completes a job,
# instead of waiting out its 5-minute poll + idle-settle debounce. Routes through
# unit_ctl (so GARDEN_UNIT_CTL mocks it in tests) with `start --no-block`, which
# returns immediately and never stalls the completing gardener.
#
# It is safe to kick FREQUENTLY, on every completion, because the kick is a cheap
# no-op whenever a real pump is not due:
#   (a) The foreman is a LEADER-ONLY singleton — its
#       ExecCondition=is-main-host.sh means a kick on a FOLLOWER host starts the
#       unit but the tick is skipped cleanly (condition-failed, never Failed), so
#       a follower's completion cannot double-pump the leader.
#   (b) Even on the leader, the foreman's own idle-detection +
#       GARDEN_FOREMAN_IDLE_SETTLE debounce + weekly token cost-gate + anti-flap
#       mean a kick while the board is busy, or still within the settle window,
#       spends no `claude -p` — it exits early having done nothing.
#
# Best-effort / NEVER fatal: every failure is swallowed (`|| true`) so a missing
# unit, absent systemd (standalone/test invocation), or a follower host never
# fails or delays the completion that called it — safe under `set -euo pipefail`.
# GARDEN_FOREMAN_EDGE_KICK=0 disables it (default on).
foreman_kick() {
  [ "${GARDEN_FOREMAN_EDGE_KICK:-1}" = "0" ] && return 0
  unit_ctl start --no-block garden-foreman.service >/dev/null 2>&1 || true
  return 0
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

# The directive-identity index sits ALONGSIDE the lifecycle (like plan/) and is
# NEVER claimed or reaped. It maps a producer-supplied *directive identity* (a
# stable key for the PR comment / review that triggered the work) to the single
# job base that owns it, so ONE directive maps to at most one OPEN job even when
# two different producers (the comment-watcher and a peer) mint DIFFERENTLY-named
# jobs for it. post-job.sh reads/writes it; see its header and designs/job-board.md
# § Directive-identity dedup. Each entry is `jobs/index/<hash>` holding two lines:
#   base: <owning-job-base>
#   identity: <the raw directive identity>   # for collision-detection + audit
JOBS_INDEX="jobs/index"

# The ORCHESTRATION category sits ALONGSIDE the lifecycle (like plan/ and index/)
# and is NEVER claimed or reaped. Each entry `jobs/orch/<base>.md` is an
# orchestration RECORD: a multi-part unit of work whose child sub-jobs are parked
# in plan/ (gate=orchestrated) and are sequenced into todo/ by the deterministic
# orchestrate.sh watcher (serial by default, or all-at-once in parallel). The
# record carries the child list, ordering, and the on-child-failure policy; the
# watcher advances it one step per tick against the board state and writes
# tada/<base> on completion. See scripts/jobs/orchestrate.sh and
# skills/orchestration/SKILL.md.
JOBS_ORCH="jobs/orch"

# List job basenames in a lifecycle dir, sorted, excluding .gitkeep.
list_jobs() {
  local dir="$1" sub="$2"
  ls -1 "$dir/$sub" 2>/dev/null | grep -v -x '.gitkeep' || true
}

# Hash a directive identity to a filesystem-safe index key. 16 sha1 hex chars —
# wider than the 8-char comment-watcher base hash, since a collision here would
# wrongly fold two *distinct* directives onto one job (a dropped directive), the
# opposite of the failure mode a base-hash collision causes (a duplicate job).
job_id_hash() { printf '%s' "$1" | (sha1sum 2>/dev/null || shasum) | cut -c1-16; }

# Is <base> present anywhere in the live lifecycle (plan|todo|doin|tada) of a
# journal clone <dir>? An index entry pointing at a base that has fully drained
# out of tada is STALE and must not block a fresh directive. plan/ counts as
# live: a blocked job parked there by the proxy (park_blocked_jobs) is the ONE
# copy of its spine and will be promoted back to todo/ — minting a second copy
# would run it while "blocked" and let the promotion clobber the fresh body.
# Mirrors post-job.sh's own "already present in lifecycle" basename check.
job_in_lifecycle() {
  local dir="$1" base="$2" sub
  for sub in "$JOBS_PLAN" "$JOBS_TODO" "$JOBS_DOIN" "$JOBS_TADA"; do
    [ -e "$dir/$sub/$base.md" ] && return 0
  done
  return 1
}

# Print the base that owns <identity> on <ref> in clone <dir> IFF that base is
# still live (plan|todo|doin|tada — the same set job_in_lifecycle checks, or the
# watchers would misread a dedup against a plan-parked owner as a lost push);
# return 1 otherwise. The watchers call this in
# their post-confirm: when post-job.sh's directive-identity dedup found the
# directive already owned by a DIFFERENT-named live job, the requested base is
# (correctly) never created, so a plain "base not on board" check would misread a
# successful dedup as a lost push and wedge the cursor. The caller must have
# fetched <ref> fresh already (the preceding verify_posted does).
journal_identity_owner_live() {
  local dir="$1" ref="$2" identity="$3" idhash owner sub entry
  [ -n "$identity" ] || return 1
  idhash="$(job_id_hash "$identity")"
  entry="$(git -C "$dir" cat-file -p "$ref:$JOBS_INDEX/$idhash" 2>/dev/null)" || return 1
  owner="$(printf '%s\n' "$entry" | sed -n 's/^base:[[:space:]]*//p' | head -1)"
  [ -n "$owner" ] || return 1
  for sub in "$JOBS_PLAN" "$JOBS_TODO" "$JOBS_DOIN" "$JOBS_TADA"; do
    git -C "$dir" cat-file -e "$ref:$sub/$owner.md" 2>/dev/null && { printf '%s\n' "$owner"; return 0; }
  done
  return 1
}

# Best-effort: derive a canonical directive identity from a job BODY, for a
# producer that did not pass one explicitly (a hand-named / LLM-authored peer
# job). Returns 0 and prints `<owner>/<repo>#<pr>:comment:<id>` ONLY when the
# body cites EXACTLY ONE GitHub comment/review identity via a canonical URL
# anchor (#issuecomment-<id>, #discussion_r<id>, #pullrequestreview-<id>) on a
# .../pull/<n> URL; otherwise prints nothing and returns 1 (no identity — leave
# behavior unchanged rather than risk folding two distinct jobs). Conservative by
# construction: 0 or >1 distinct anchors ⇒ no identity.
derive_job_identity_from_body() {
  local body="$1" ids
  # Extract "<owner>/<repo>#<pr>:comment:<anchor-id>" for every pull-request
  # comment URL anchor in the body, then keep it only if a single distinct one
  # survives. grep -oE emits one match per line; sed rewrites each to the key.
  ids="$(printf '%s\n' "$body" \
    | grep -oiE 'github\.com/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+/pull/[0-9]+#(issuecomment-|discussion_r|pullrequestreview-)[0-9]+' \
    | sed -E 's%.*github\.com/([A-Za-z0-9_.-]+)/([A-Za-z0-9_.-]+)/pull/([0-9]+)#(issuecomment-|discussion_r|pullrequestreview-)([0-9]+).*%\1/\2#\3:comment:\5%' \
    | sort -u)"
  [ -n "$ids" ] || return 1
  [ "$(printf '%s\n' "$ids" | wc -l)" -eq 1 ] || return 1
  printf '%s\n' "$ids"
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

# The performing role a job requests, read from the `role:` field. This is the
# role a gardener WEARS to do the work (designer, builder, fixer, …), distinct
# from `posted_by:` (the producer that minted the job). It is the key the model
# policy below (role_default_model) resolves a per-role default model from, so a
# designer job runs on Fable and a builder on Opus without the poster having to
# name a model explicitly. Empty if absent.
plan_role() { plan_field "$1" role; }

# --- model selection (the canonical role->model policy) ----------------------
# The garden resolves the Claude model for a unit of work in two places that MUST
# agree: the scripted-fleet path (gardener-claude.sh, keyed on a job's `model:` /
# `role:` frontmatter) and the Agent-dispatch path (the liaison/steward passing a
# `model` tier per the dispatch contract). The two functions below are the
# EXECUTABLE single source of truth for the fleet path; skills/model-selection/
# SKILL.md is the human-readable canonical statement the Agent path follows, and
# it points back here so the two never drift.

# resolve_model_tier <tier-or-id> -> concrete `claude-*` model id (empty if the
# value is unknown/blank). Accepts the short tier names the maintainer uses in a
# job's `model:` field and on an Agent dispatch, and passes a concrete `claude-*`
# id through verbatim. The single place the short names bind to concrete ids, so
# a Claude-version bump is one edit here.
resolve_model_tier() {
  case "${1:-}" in
    fable)    printf '%s\n' "claude-fable-5" ;;
    opus)     printf '%s\n' "claude-opus-4-8" ;;
    sonnet)   printf '%s\n' "claude-sonnet-4-6" ;;
    haiku)    printf '%s\n' "claude-haiku-4-5-20251001" ;;
    claude-*) printf '%s\n' "$1" ;;            # already a concrete model id
    *)        printf '%s\n' "" ;;              # unknown/blank -> caller decides fallback
  esac
}

# role_default_model <role> -> the concrete `claude-*` model id that role runs on
# BY DEFAULT (empty for a role with no policy, so the caller falls back to the
# fleet default). This is the canonical role->model map. The maintainer's standing
# policy (2026-07-02, via the liaison): the design-only `designer` role runs on
# Fable; the mergeable-feature `builder` role runs on the latest Opus. Every other
# role is unpinned here (empty) and rides the fleet default unless a job names an
# explicit `model:`. An explicit per-job `model:` ALWAYS overrides this default —
# the caller applies this only when no `model:` field is present.
role_default_model() {
  case "${1:-}" in
    designer) printf '%s\n' "$(resolve_model_tier fable)" ;;
    builder)  printf '%s\n' "$(resolve_model_tier opus)" ;;
    *)        printf '%s\n' "" ;;
  esac
}

# --- orchestration-record metadata helpers ----------------------------------
# An orchestration record (jobs/orch/<base>.md) carries leading YAML frontmatter:
#   ---
#   order: serial | parallel           # sequencing of the children (default serial)
#   children: a b c                    # space-separated child job basenames, in order
#   on-child-failure: halt | continue  # policy when a child fails (default halt)
#   state: pending | running | done | halted   # managed by orchestrate.sh
#   created_by: <role>                 # optional provenance
#   created_at: <iso8601>              # optional provenance
#   ---
#   <human description of the multi-part work>
# The frontmatter helpers reuse plan_field (a leading-frontmatter scalar reader).

# The ordering of an orchestration (serial default). Only serial|parallel are
# meaningful; an unknown value is treated as serial by the watcher.
orch_order() {
  local o; o="$(plan_field "$1" order)"; printf '%s\n' "${o:-serial}"
}
# The child job basenames, space-separated in run order. Empty if absent.
orch_children() { plan_field "$1" children; }
# The failure policy (halt default): halt stops a serial run at the first failed
# child; continue proceeds to the next.
orch_failure_policy() {
  local p; p="$(plan_field "$1" on-child-failure)"; printf '%s\n' "${p:-halt}"
}
# The watcher-managed lifecycle state (pending default before the first tick).
orch_state() {
  local s; s="$(plan_field "$1" state)"; printf '%s\n' "${s:-pending}"
}

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
