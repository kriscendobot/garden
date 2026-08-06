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

# Shepherd handler budget (seconds). A shepherd DRIVES CI to green, so it BLOCKS on
# CI runs that routinely exceed the default GARDEN_HANDLER_TIMEOUT (2400s / 40min):
# a shepherd job stamped only with the default deterministically overruns (rc=124)
# and never COMPLETES. The shepherd producers — comment-watcher.sh's `shepherd #N`
# path and ci-watcher.sh's auto-shepherd-on-red path, which both mint the SAME
# `<slug>-pr<N>-shepherd` basename — stamp THIS value as a `handler-timeout:` header
# so the gardener honors it in place of the default (gardener.sh per-job budget).
# Both read it from here so the two producers never drift and an idempotent re-post
# does not flap the header. Sized for a full CI wait plus headroom for a couple of
# fix→CI cycles: endojs/endo-but-for-bots CI runs land on the order of 20–40min, so
# 2h covers ~2–3 cycles. It MUST stay ≤ the claim budget max (GARDEN_CLAIM_TTL −
# GARDEN_HANDLER_KILL_AFTER − 1 ≈ 14339s / 3.98h at the shipped defaults); 7200 is
# comfortably under, so the gardener honors it verbatim rather than clamping and
# escalating (gardener.sh). A shepherd genuinely needing longer than ONE claim
# (>~3.98h of CI-driving) cannot be helped by a larger header — it would clamp+
# escalate; that pathological case is out of scope for the common minutes-to-a-
# couple-hours shepherd this targets.
: "${GARDEN_SHEPHERD_HANDLER_TIMEOUT:=7200}"

# --- test-context guard against a production-journal push (incident 2026-07-11) -
# A test that isolates GARDEN_STATE but leaves the journal REMOTE pointing at the
# real garden repo pushed synthetic fleet traffic (a fake pxhost gardener asking to
# ferry upstream; driftname identity-drift alarms) straight onto production
# `journal2`, where it masqueraded as live work and cost real triage. State was
# sandboxed; the remote was not. The durable fix is a structural refusal in the
# push path: if a test context is in effect AND the push target resolves to the
# real production journal remote, commit_and_push/anchor_blob die loudly instead of
# pushing (see guard_no_production_push_in_test below). This closes the whole class,
# not just the two tests that leaked.
#
# GARDEN_TEST is the positive sentinel every test entrypoint exports from one place
# so a subtest that forgets to override the remote is still caught. A throwaway
# GARDEN_STATE under `.garden-test` is a secondary heuristic (kept tight so it can
# never match a real deployment's `.garden-state`).
: "${GARDEN_TEST:=0}"
# The canonical production journal repo, as <owner>/<name>. The garden's own repo was
# TRANSFERRED kriskowal/garden -> kriscendobot/garden on 2026-07-28, so the OLD path is
# carried alongside it as a MIGRATION ALIAS: GitHub redirects the old web and git
# endpoints indefinitely, and a host whose root/journal origin has not yet been migrated
# must keep resolving and pushing rather than be stranded mid-fleet. Drop the alias once
# no live origin, cache, or clone still names the old path.
: "${GARDEN_PRODUCTION_JOURNAL_REPO:=kriscendobot/garden}"
: "${GARDEN_PRODUCTION_JOURNAL_REPO_ALIASES:=kriskowal/garden}"
# The URL every "restore the canonical origin" instruction names.
: "${GARDEN_PRODUCTION_JOURNAL_URL:=git@github.com:$GARDEN_PRODUCTION_JOURNAL_REPO.git}"
# The signature of the canonical production journal remote (any of the repos above in
# https, scp-ssh, or ssh:// form, with or without a .git suffix / trailing slash).
# Overridable so this repo's own name is not hard-wired forever. Anchored to the FULL
# <owner>/<name> path — an alternation of exact repos, never a bare owner prefix — so a
# product fork under the SAME owner (kriscendobot/endo-but-for-bots, kriscendobot/…)
# still cannot match; accepting the new owner must not mean accepting its other repos.
_garden_prod_repo_alt="$GARDEN_PRODUCTION_JOURNAL_REPO"
for _garden_prod_repo in $GARDEN_PRODUCTION_JOURNAL_REPO_ALIASES; do
  _garden_prod_repo_alt="$_garden_prod_repo_alt|$_garden_prod_repo"
done
: "${GARDEN_PRODUCTION_JOURNAL_REMOTE_RE:=github\.com[:/]($_garden_prod_repo_alt)(\.git)?/?\$}"
unset _garden_prod_repo_alt _garden_prod_repo

# Per-instance state (gardener/producer journal clones, triager seen-markers).
# Kept OUTSIDE any reset-prone worktree on purpose.
: "${GARDEN_STATE:=$GARDEN_ROOT/.garden-state}"

# --- deprecated env-knob aliases (the doom rename, 2026-08-04) ----------------
# The reaper's doom-park knobs were renamed from GARDEN_*POISON* to GARDEN_*DOOM*
# ("doomed" replaces "poisoned" as the job-state vocabulary). These knobs are an
# OPERATOR-FACING contract (env / systemd unit overrides), so the OLD names are
# honored as DEPRECATED ALIASES: if the new knob is unset but the old one is set,
# adopt the old value and warn ONCE per process. Without this an existing override
# would silently stop taking effect. RETIRE after every host's deployed sha carries
# the new names (designs/job-board.md § the doom rename).
if [ -z "${GARDEN_REAP_DOOM_THRESHOLD:-}" ] && [ -n "${GARDEN_REAP_POISON_THRESHOLD:-}" ]; then
  GARDEN_REAP_DOOM_THRESHOLD="$GARDEN_REAP_POISON_THRESHOLD"; export GARDEN_REAP_DOOM_THRESHOLD
  printf '<4>%s: GARDEN_REAP_POISON_THRESHOLD is deprecated; use GARDEN_REAP_DOOM_THRESHOLD (honoring old value %s this run)\n' \
    "${GARDEN_TAG:-garden}" "$GARDEN_REAP_POISON_THRESHOLD" >&2
fi
if [ -z "${GARDEN_DOOM_SPOOL:-}" ] && [ -n "${GARDEN_POISON_SPOOL:-}" ]; then
  GARDEN_DOOM_SPOOL="$GARDEN_POISON_SPOOL"; export GARDEN_DOOM_SPOOL
  printf '<4>%s: GARDEN_POISON_SPOOL is deprecated; use GARDEN_DOOM_SPOOL (honoring old value %s this run)\n' \
    "${GARDEN_TAG:-garden}" "$GARDEN_POISON_SPOOL" >&2
fi

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
#      override; wins so a `GARDEN=… some-cmd` invocation still works). This is
#      NOT a durable configuration knob. A GARDEN pinned for the fleet (e.g. via
#      ~/.config/environment.d, which the systemd --user manager DOES inherit)
#      once silently shadowed the derived identity and thrashed the leader
#      marker between two shards; do not pin it. There is deliberately no
#      $GARDEN_ROOT/.garden file consulted anymore — identity is derived, not
#      configured.
#   2. `hostname -s` — the derived identity, and the normal case. The `./garden`
#      launcher bakes a location-derived name (<hostname>-<basename>-<hash8> of
#      the canonical checkout path) into the container's --hostname at creation,
#      so distinct checkouts on one machine get distinct kernel hostnames and
#      thus distinct identities automatically — no file or env knob to seed,
#      edit, or forget. See CLAUDE.md § Host environment and
#      context/first-run/identity.md.
# We export GARDEN so child processes (git, the handler, hooks) inherit the
# resolved identity.
# See issue kriskowal/garden#11 (Multibot) and designs/multibot-leader-follower.md.
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

# --- local inference (hermit worker backend, provider: local) ----------------
# GARDEN_LOCAL_OLLAMA_URL is the OpenAI-compatible /v1 base URL the hermit (provider:
# local) worker probes. The supervised endpoint derives its OLLAMA_HOST bind address
# from the same URL, so the client and server cannot drift on a non-default port.
: "${GARDEN_LOCAL_OLLAMA_URL:=http://127.0.0.1:11435/v1}"

# Fireworks is OpenAI-chat compatible.  The endpoint is deliberately a knob: a
# deployment/model selection is live provider data, not a garden release fact.
: "${GARDEN_FIREWORKS_BASE_URL:=https://api.fireworks.ai/inference/v1}"
: "${GARDEN_FIREWORKS_RETRY_ATTEMPTS:=3}"
: "${GARDEN_FIREWORKS_RETRY_DELAY:=1}"

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

# Foreman brake path — the FOREMAN-ONLY throttle, independent of the fleet drain.
# Unlike the draining marker above (a host-local FILE under $GARDEN_STATE that
# stops EVERY worker), the brake is JOURNAL-BACKED: a flag committed to journal2
# at this path. Journal-backed because the foreman is a leader-only singleton — a
# host-local brake would be left behind when the leader marker moves and the new
# leader's foreman would start pumping immediately, whereas a journal flag is fleet
# policy in fleet state: it follows the leader across a handoff, is reachable from
# any host without a new sysop op, and is auditable in git. Its EXISTENCE is the
# signal (like the drain marker); its CONTENTS are a prose reason (written by
# brake-foreman.sh). foreman_braked reads it from an ALREADY-SYNCED journal clone,
# so an unreadable/offline journal makes sync_clone exit the tick BEFORE the read —
# the pump never fires on a journal it could not read (fail-safe toward braked).
: "${GARDEN_FOREMAN_BRAKE_PATH:=config/foreman-brake}"

# --- transcript capture (designs/transcript-journal-capture.md) ---------------
#
# The garden captures every host's finished session transcripts into a dedicated
# `transcripts2` orphan branch on a configurable transcripts remote, so the
# journal holds the garden's transcript. All three knobs are overridable so the
# test harness can point the same code at a throwaway spool/remote.
#
# GARDEN_TRANSCRIPTS_BRANCH — the orphan branch transcripts live on, mirroring the
#   journal2 pattern; it is never merged with main2/journal2 and only the capture
#   service and a browsing human ever fetch it.
# GARDEN_TRANSCRIPTS_SPOOL — a per-host staging dir under $GARDEN_STATE (outside
#   any reset-prone worktree) where the gardener completion hook drops a gzip copy
#   of a finishing job's transcript BEFORE the handler's `rm -f` retires it (the
#   false-resume hazard is real, so the rm stays). The hourly capture timer drains
#   the spool. Spooling happens whether or not a remote is armed, so nothing is
#   lost while the archive is unconfigured.
# GARDEN_TRANSCRIPT_IDLE_SECS — the sweep captures a `~/.claude/projects` session
#   only once its mtime is older than this (default six hours), so a live,
#   still-growing session is not captured over and over.
: "${GARDEN_TRANSCRIPTS_BRANCH:=transcripts2}"
: "${GARDEN_TRANSCRIPTS_SPOOL:=$GARDEN_STATE/transcripts/spool}"
: "${GARDEN_TRANSCRIPT_IDLE_SECS:=21600}"

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

# --- declare the fleet's PATH tail (the inherited-PATH half of the ps23 outage) -
#
# `systemd --user` carries no PATH of its own and no unit under scripts/systemd/
# sets Environment=PATH, so every fleet worker and timer runs on whatever PATH the
# user manager happened to inherit when the session started — NOT the login-shell
# PATH /etc/profile.d/garden.sh builds (Dockerfile § login-shell env), which is
# what the image's tooling assumes. A worker therefore could not see the go tools
# or ~/bin, and its `claude` lookup rode on the same accident.
#
# APPEND the image's declared tool dirs (plus the two common user-local bin dirs)
# when they are missing, rather than pinning Environment=PATH in the units: an
# absolute unit-level pin would silently NARROW the PATH on any host whose session
# legitimately carries something else (a nvm node, ~/.cargo/bin, /snap/bin) and
# break the very builds the fleet runs. Appending can only ever ADD, it applies to
# every fleet entry point that sources this file (workers, timers, watchers), it
# needs no unit re-render or deploy, and it is EXPORTED so the `claude -p` children
# and their Bash tool calls inherit it too. The dirs are appended at the TAIL so a
# deliberately-prepended install still wins. The agent-CLI resolver below is the
# other half: it probes the known install locations even when PATH misses entirely.
# The ${HOME:-/nonexistent} default keeps an unset HOME from degenerating into the
# bare "/bin" / "/go/bin" the plain ${HOME:-} form would produce.
for _garden_path_dir in \
    "${HOME:-/nonexistent}/bin" "${HOME:-/nonexistent}/.local/bin" "${HOME:-/nonexistent}/go/bin" \
    /opt/go-tools/bin /usr/local/go/bin /usr/local/bin /usr/bin
do
  [ -n "$_garden_path_dir" ] && [ -d "$_garden_path_dir" ] || continue
  case ":$PATH:" in
    *":$_garden_path_dir:"*) : ;;                       # already present
    *) export PATH="$PATH:$_garden_path_dir" ;;
  esac
done
unset _garden_path_dir

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
    'connection timed out|error connecting to api\.github\.com|check your internet connection|(dial|read) tcp .* i/o timeout|TLS handshake timeout|could not resolve host'
}

# is_transient_auth_error <stderr-file-or-string> — true (0) when the given text
# bears the fingerprint of a TRANSIENT auth failure: GitHub returns an `HTTP 401:
# Bad credentials` for a brief window while an OAuth/installation token rotates,
# then the very next identical call succeeds. This is the auth-side sibling of
# is_transient_net_error: a watcher whose source dies on a 401 uses this to decide
# to RETRY once (the blip self-heals) rather than to `die` on the first 401 and
# detonate a systemd restart + self-heal. A truly revoked/misconfigured credential
# still fails the retry and is surfaced loudly there. Same argument contract as
# is_transient_net_error (a file is slurped; a non-file string is matched directly).
is_transient_auth_error() {
  local blob
  if [ -f "$1" ]; then
    blob="$(cat "$1" 2>/dev/null || true)"
  else
    blob="$1"
  fi
  printf '%s' "$blob" | grep -qiE 'HTTP 401|Bad credentials'
}

# is_transient_gh_source_error <stderr-file-or-string> — true (0) when the given
# text bears the fingerprint of a TRANSIENT gh-api failure that is NEITHER a plain
# connectivity blip (is_transient_net_error) NOR a 401 rotation (is_transient_auth_error):
# GitHub serving an HTML gateway/5xx/rate-limit page instead of JSON, so `gh … | jq`
# fails rc=1 with a Go-decoder / HTTP-5NN / HTTP-429 / rate-limit / EOF / server-
# misbehaving signature. This is the gh-api sibling of the two functions above: a
# watcher whose `gh run list`/`gh pr list` source dies with one of these skips the
# tick instead of `die`ing and detonating a systemd restart storm. It defers to the
# SAME curated GARDEN_TRANSIENT_GH_API_SIGNATURES set that gh_api_retry/mirror-closer
# honor (via _gh_api_stderr_is_transient), so the HTML-instead-of-JSON class the
# watchers see is classified in one place. Same argument contract as its siblings (a
# file is slurped; a non-file string is matched directly). A genuinely structural
# failure (a real 404, a malformed slug) matches NONE of these and still dies loud,
# preserving "never guess a state". _gh_api_stderr_is_transient and its signature set
# are defined later in this file but resolved at call time, so the ordering is fine.
is_transient_gh_source_error() {
  local blob
  if [ -f "$1" ]; then
    blob="$(cat "$1" 2>/dev/null || true)"
  else
    blob="$1"
  fi
  _gh_api_stderr_is_transient "$blob"
}

# True when this host's fleet is draining: the new draining marker OR the
# deprecated legacy killswitch marker exists. Keys on EXISTENCE only — an empty
# marker drains just as a prose-filled one does.
fleet_draining() { [ -e "$GARDEN_DRAINING_MARKER" ] || [ -e "$GARDEN_KILLSWITCH" ]; }
# Deprecated alias retained so any not-yet-updated caller keeps working.
killswitch_engaged() { fleet_draining; }

# True when the FOREMAN must not pump this tick: either the whole fleet is
# draining (fleet_draining — the drain keeps its meaning and keeps stopping the
# foreman, the first row of the truth table) OR the foreman-only brake is set.
# This is the ONLY predicate the foreman's guard changes; every other worker keeps
# calling fleet_draining, so a brake with the drain OFF stops the foreman alone and
# gardeners keep claiming.
#
# The brake is journal-backed (GARDEN_FOREMAN_BRAKE_PATH on journal2). Its presence
# is read from an ALREADY-SYNCED journal clone passed as $1 — never a fresh fetch
# here — so the read cost is one stat on a clone the foreman synced anyway. EXISTENCE
# is the signal, mirroring the drain marker: a present-but-garbage flag still brakes,
# so a corrupt brake cannot silently unbrake. The caller must sync the clone before
# calling this; sync_clone exits the tick on an offline/unreadable journal, so the
# pump never fires on a journal that could not be read — fail-safe toward braked.
foreman_braked() {
  local clone="${1:?foreman_braked: journal clone dir required}"
  fleet_draining && return 0
  [ -e "$clone/$GARDEN_FOREMAN_BRAKE_PATH" ]
}

# --- gardener mid-job (busy) marker — the single definition of "do not disturb" -
#
# --- worker-kind registry (the single point a new backend touches) -----------
#
# A "worker kind" is one flavor of the shared worker spine (gardener.sh): the loop,
# the board protocol, the scaler, the systemd template, and the per-job worktree
# lifecycle are ONE copy parameterized by kind, and everything that differs between
# kinds is a field in this table. Adding a third backend (say a `friar` on a future
# CLI) is then: one handler script implementing the handler contract, one row here,
# one rate-card/tier block — no spine file is copied or forked.
#   handler   default job handler path, relative to scripts/jobs/
#   agent_bin the agent CLI that kind's DEFAULT handler cannot run without — the
#             one thing the pre-claim health gate probes (worker_health_gate)
#   provider  the model provider (rate-card / model-selection scope)
#   unit      the systemd instance template prefix (rendered from garden-worker@.in)
#   count_key the hosts/<host> count line this kind reads/writes
#   state_ns  the $GARDEN_STATE namespace for this kind's per-instance clone/markers
#   label     the self-heal-run.sh service label (the unit prefix minus the '@')
worker_kind_field() {
  local kind="${1:?worker_kind_field: kind required}" field="${2:?worker_kind_field: field required}"
  case "$kind" in
    gardener)
      case "$field" in
        handler)   printf '%s\n' "handlers/gardener-claude.sh" ;;
        agent_bin) printf '%s\n' "claude" ;;
        provider)  printf '%s\n' "anthropic" ;;
        unit)      printf '%s\n' "garden-gardener@" ;;
        count_key) printf '%s\n' "gardeners" ;;
        state_ns)  printf '%s\n' "gardeners" ;;
        label)     printf '%s\n' "garden-gardener" ;;
        *) return 1 ;;
      esac ;;
    cleric)
      case "$field" in
        handler)   printf '%s\n' "handlers/cleric-codex.sh" ;;
        agent_bin) printf '%s\n' "codex" ;;
        provider)  printf '%s\n' "openai" ;;
        unit)      printf '%s\n' "garden-cleric@" ;;
        count_key) printf '%s\n' "clerics" ;;
        state_ns)  printf '%s\n' "clerics" ;;
        label)     printf '%s\n' "garden-cleric" ;;
        *) return 1 ;;
      esac ;;
    hermit)
      # The provider: local codex-cleric (guide §4, cleric-worker-bid-auction-
      # reputation.md §2.2 "Adding a third backend"). It REUSES the codex handler
      # verbatim — the handler is provider-parameterized and, seeing provider=local,
      # points codex at the local Ollama /v1 endpoint instead of paid OpenAI (zero
      # new handler file). Its provider is `local`, so its reputation and rate-card
      # rows stay DISTINCT from the paid-OpenAI cleric: the design keeps worker_kind
      # and provider separate for exactly this — a codex-harness kind driving a
      # *local* provider (§4.2).
      case "$field" in
        handler)   printf '%s\n' "handlers/cleric-codex.sh" ;;
        agent_bin) printf '%s\n' "codex" ;;
        provider)  printf '%s\n' "local" ;;
        unit)      printf '%s\n' "garden-hermit@" ;;
        count_key) printf '%s\n' "hermits" ;;
        state_ns)  printf '%s\n' "hermits" ;;
        label)     printf '%s\n' "garden-hermit" ;;
        *) return 1 ;;
      esac ;;
    mystic)
      # Hosted Moonshot Kimi K3 uses the official Kimi Code CLI, while retaining
      # a separate pool, state namespace, provider identity, and reputation arm.
      case "$field" in
        handler)   printf '%s\n' "handlers/mystic-kimi.sh" ;;
        agent_bin) printf '%s\n' "kimi" ;;
        provider)  printf '%s\n' "moonshot" ;;
        unit)      printf '%s\n' "garden-mystic@" ;;
        count_key) printf '%s\n' "mystics" ;;
        state_ns)  printf '%s\n' "mystics" ;;
        label)     printf '%s\n' "garden-mystic" ;;
        *) return 1 ;;
      esac ;;
    fireworker)
      # Fireworks uses the Codex custom OpenAI-compatible provider harness.  Its
      # routing id is deliberately namespaced (`fireworks/<wire-model>`), leaving
      # the volatile wire model/deployment identifier explicit in each job.
      case "$field" in
        handler)   printf '%s\n' "handlers/cleric-codex.sh" ;;
        agent_bin) printf '%s\n' "codex" ;;
        provider)  printf '%s\n' "fireworks" ;;
        unit)      printf '%s\n' "garden-fireworker@" ;;
        count_key) printf '%s\n' "fireworkers" ;;
        state_ns)  printf '%s\n' "fireworkers" ;;
        label)     printf '%s\n' "garden-fireworker" ;;
        *) return 1 ;;
      esac ;;
    *) return 1 ;;
  esac
}

# The set of worker kinds a host reconciles, one per line, in a fixed order. The
# scaler iterates this to reconcile every pool; set-workers.sh iterates it to
# preserve a sibling kind's count when it rewrites hosts/<host>. A new kind is added
# in exactly one place besides worker_kind_field: here.
worker_kinds() { printf '%s\n' gardener cleric hermit mystic fireworker; }

# quota_routing_mode — temporary, host-scoped escape hatch for an Anthropic
# quota outage. `auto` is deliberately narrow: only endolin-garden instances
# bypass bid selection for a `market: bid` job, leaving ps23's remaining Claude
# capacity on the normal auction path. The worker still has to pass the usual
# model/provider and host-capability gates before it can race the CAS.
#
# Set GARDEN_QUOTA_ROUTING=auction to roll this back on an endolin instance, or
# =race to force the temporary route on a named test/recovery host. An unknown
# value fails closed to `auction`, the established selection policy.
quota_routing_mode() {
  local mode="${GARDEN_QUOTA_ROUTING:-auto}"
  case "$mode" in
    auction|bid|off) printf '%s\n' auction ;;
    race|on)          printf '%s\n' race ;;
    auto)
      case "$GARDEN" in
        endolin-garden*) printf '%s\n' race ;;
        *)               printf '%s\n' auction ;;
      esac ;;
    *) printf '%s\n' auction ;;
  esac
}

# host_has_qualified_non_claude_worker <hosts-file> — succeeds only when this
# host has declared a positive count for a non-Anthropic kind AND its backend
# probe currently passes. This is the worker-floor safety predicate: a host may
# retire gardeners only when another actually usable class remains to claim work.
# It intentionally does not consult systemd state: the scaler is the component
# that is about to start/reconcile that declared, probe-qualified pool.
host_has_qualified_non_claude_worker() {
  local hosts_file="${1:?host_has_qualified_non_claude_worker: hosts file required}"
  local kind provider key want
  for kind in $(worker_kinds); do
    provider="$(worker_kind_field "$kind" provider)" || continue
    [ "$provider" = anthropic ] && continue
    key="$(worker_kind_field "$kind" count_key)" || continue
    want="$(read_desired_count "$hosts_file" "$key" 2>/dev/null)" || continue
    [ "$want" -gt 0 ] || continue
    worker_backend_probe "$kind" >/dev/null 2>&1 && return 0
  done
  return 1
}

# read_desired_count <hosts-file> <count_key> — read one worker kind's declared
# concurrency from a hosts/<host> file, distinguishing the THREE outcomes the pool
# scaler must treat differently. On a clean read it prints the parsed non-negative
# integer to stdout and returns 0; otherwise stdout is empty and the EXIT STATUS
# encodes WHY, so the caller can pick WARN vs a quiet no-op without re-parsing:
#   0 → the `<count_key>:` line is present and its value parses as ^[0-9]+$
#       (stdout carries it; an explicit `0` is a legitimate scale-to-zero).
#   2 → the file exists but has NO `<count_key>:` line — this host simply has not
#       declared this kind. A NORMAL steady state (or a transient partial write
#       while another host updates the file), NOT a misconfiguration → caller stays
#       quiet and leaves the pool unchanged.
#   1 → the file is missing entirely, OR the line is present but its value does not
#       parse (non-integer) — a genuine misconfiguration/corruption → caller WARNs
#       and leaves the pool unchanged.
# Missing is never scale-to-0: only a parsed explicit `0` (outcome 0) tears a pool
# down. Kept here, in the file both the scaler and its test source, so the count
# semantics live in one place.
read_desired_count() {
  local f="${1:?read_desired_count: hosts file required}" count_key="${2:?read_desired_count: count_key required}"
  [ -f "$f" ] || return 1
  grep -q "^$count_key:" "$f" || return 2
  local v
  v="$(sed -n "s/^$count_key:[[:space:]]*//p" "$f" | head -1)"
  [[ "$v" =~ ^[0-9]+$ ]] || return 1
  printf '%s\n' "$v"
}

# ollama_serve_host — derive Ollama's host:port bind value from the shared client URL.
# Strip the scheme and any path so http://127.0.0.1:11435/v1 becomes 127.0.0.1:11435.
ollama_serve_host() {
  local u="${GARDEN_LOCAL_OLLAMA_URL:-http://127.0.0.1:11435/v1}"
  u="${u#*://}"
  u="${u%%/*}"
  printf '%s\n' "${u:-127.0.0.1:11435}"
}

# ollama_models_dir — the filesystem directory where the garden's supervised Ollama
# stores model blobs. Ollama honors OLLAMA_MODELS when set; otherwise it defaults to
# the serving user's `$HOME/.ollama/models`. The sysop local-model provisioning op
# and its pull helper BOTH resolve the model store through this single helper so the
# preflight free-space check and the actual pull can never disagree on which
# filesystem the blobs land in (designs/sysop-local-model.md § Preconditions).
ollama_models_dir() {
  printf '%s\n' "${OLLAMA_MODELS:-$HOME/.ollama/models}"
}

# gardener.sh drops a local, lock-free marker file while a job handler runs and
# clears it the moment the job ends (and at the top of each loop), so a worker
# instance is "busy" (mid-job) exactly while that marker exists. Both the
# deliberate deploy (deploy-garden.sh, which waits for the fleet to quiesce and
# then re-execs workers onto landed code via deploy-restart.sh) and the pool
# scaler (install-units.sh scale, which disables extras on a scale-down) gate on
# it so a worker is restarted/disabled BETWEEN claims, never mid-`claude -p`:
# a `disable --now`/`restart` of a mid-job worker SIGTERMs the in-flight handler,
# which then requeues and burns a full TTL cycle — the rc=143 transient-handler
# outage this marker exists to prevent. Keeping the path and the predicate here,
# in one place both callers source, means the deploy and scale paths can never
# drift on what "mid-job" means or where the marker lives.
#
# The marker lives under the KIND's state namespace ($GARDEN_STATE/<state_ns>/<idx>),
# so a cleric-1 and a gardener-1 (distinct kinds, same index) never collide. The
# gardener_* wrappers below preserve the historical single-kind signature for the
# many callers that predate the cleric.
worker_busy_marker() {
  local kind="${1:?worker_busy_marker: kind required}" idx="${2:?worker_busy_marker: idx required}" ns
  ns="$(worker_kind_field "$kind" state_ns)" || ns="gardeners"
  printf '%s\n' "$GARDEN_STATE/$ns/$idx/busy"
}
worker_busy() {
  [ -e "$(worker_busy_marker "${1:?worker_busy: kind required}" "${2:?worker_busy: idx required}")" ]
}
gardener_busy_marker() {
  worker_busy_marker gardener "${1:?gardener_busy_marker: idx required}"
}
gardener_busy() {
  worker_busy gardener "${1:?gardener_busy: idx required}"
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

# --- per-provider spend & quota panel (the bulletin's maintainer view) --------
# Sourced AFTER usage-meter so render_quota_panel can reuse meter_window_total /
# meter_quota_status. Adds Claude dollar pricing (rate card over the session logs)
# and Codex token/dollar/quota from ~/.codex rollout logs. See quota-panel.sh.
# shellcheck source=quota-panel.sh
source "$(dirname "${BASH_SOURCE[0]}")/quota-panel.sh"

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

# --- agent-CLI resolution (the ps23 `claude not on PATH` outage) --------------
#
# Every claude-driving handler used to open with a bare
# `command -v claude >/dev/null || die` — a SINGLE probe of the INHERITED PATH,
# with zero tolerance, whose failure `die`s rc=1 and reads to gardener.sh as a
# deterministic defect in whatever job happened to be claimed at that instant.
# Two independent things make that shape wrong:
#
#   1. THE PATH IS NOT DECLARED. The image installs the CLI at /usr/local/bin/claude
#      (npm -g under the /usr/local prefix), but a `systemd --user` unit carries no
#      Environment=PATH, so the fleet runs on whatever PATH the user manager
#      happened to inherit at login. A native-installer or nvm/npm-prefix install
#      lands somewhere else entirely ($HOME/.local/bin, $HOME/.claude/local). The
#      resolver below therefore probes PATH FIRST (so a test stub or a deliberate
#      operator install on PATH still wins) and then the KNOWN install locations.
#   2. AN ABSENCE IS OFTEN MOMENTARY. An in-place `npm install -g
#      @anthropic-ai/claude-code` (the image's CLAUDE_CODE_MIN floor upgrade, or an
#      operator upgrading a live container) UNLINKS the global bin for a window of
#      seconds. A single probe landing in that window is not evidence the CLI is
#      gone. The resolver retries, bounded, before concluding absence.
#
# When it does conclude absence, the caller exits GARDEN_ENV_RC — an ENVIRONMENTAL
# failure, not a job defect (see die_environmental / is_environmental_rc below).
: "${GARDEN_AGENT_BIN_ATTEMPTS:=5}"   # bounded probes before declaring the CLI absent
: "${GARDEN_AGENT_BIN_SLEEP:=3}"      # seconds between probes (the npm -g relink window)
# EX_TEMPFAIL, the SAME code as GARDEN_OFFLINE_RC (an offline tick is one species of
# environmental failure) — named separately so a handler's intent reads clearly at
# the exit site and so the two can be tuned apart if that ever becomes necessary.
: "${GARDEN_ENV_RC:=75}"

# agent_bin_candidates <name> — the known install locations for an agent CLI,
# probed IN ORDER after PATH. Every entry is a path a real install has been seen
# at; an empty-prefix entry (e.g. NVM_BIN unset) is skipped by the probe.
#   /usr/local/bin     the image's npm -g prefix (Dockerfile), the fleet's normal home
#   /usr/bin           a distro/system-wide install
#   ~/.local/bin       the native installer's default, and pipx/pip --user
#   ~/.claude/local    Claude Code's own local-install location (`claude migrate-installer`)
#   $NVM_BIN           an nvm-managed node whose global bin is version-scoped
#   ~/.npm-global/bin, ~/.node/bin, ~/bin   common hand-set npm prefixes
agent_bin_candidates() {
  local name="${1:?agent_bin_candidates: name required}"
  printf '%s\n' \
    "/usr/local/bin/$name" \
    "/usr/bin/$name" \
    "${HOME:-}/.local/bin/$name" \
    "${HOME:-}/.claude/local/$name" \
    "${NVM_BIN:-}/$name" \
    "${HOME:-}/.npm-global/bin/$name" \
    "${HOME:-}/.node/bin/$name" \
    "${HOME:-}/bin/$name"
}

# agent_bin_probe <name> — ONE resolution pass. Prints an absolute (or PATH-resolved)
# command to stdout and returns 0; returns 1 if the CLI is nowhere to be found.
# Order: explicit operator override (GARDEN_<NAME>_BIN, e.g. GARDEN_CLAUDE_BIN) →
# PATH → the candidate list. No retry, no sleep — callers that can afford to wait
# use agent_bin (below); a soft-skip caller uses this directly.
agent_bin_probe() {
  local name="${1:?agent_bin_probe: name required}" resolved cand override_var
  # Built-in case conversion, NOT `printf | tr`: this function must resolve an
  # agent CLI even when PATH is so broken that no external command runs at all.
  override_var="GARDEN_${name^^}_BIN"
  override_var="${override_var//-/_}"
  resolved="${!override_var:-}"
  if [ -n "$resolved" ]; then
    # An override is AUTHORITATIVE and FAIL-CLOSED: honor it when it is runnable,
    # and FAIL when it is not, rather than silently running a different binary than
    # the operator named. A typo'd knob must surface as a loud environmental
    # failure (transient requeue + this log line), never as work quietly done by
    # the wrong agent. Note `[ -x ]` also correctly rejects a path on a noexec
    # mount, which is exactly what the caller means by "runnable".
    if [ -x "$resolved" ] || command -v "$resolved" >/dev/null 2>&1; then
      printf '%s\n' "$resolved"; return 0
    fi
    log "$override_var=$resolved is not runnable; refusing to fall back to another binary"
    return 1
  fi
  if resolved="$(command -v "$name" 2>/dev/null)" && [ -n "$resolved" ]; then
    printf '%s\n' "$resolved"; return 0
  fi
  while IFS= read -r cand; do
    case "$cand" in ''|/"$name") continue ;; esac   # skip an empty-prefix candidate
    [ -x "$cand" ] || continue
    printf '%s\n' "$cand"; return 0
  done < <(agent_bin_candidates "$name")
  return 1
}

# agent_bin <name> [attempts] [sleep-secs] — resolve with a BOUNDED retry, so a
# momentary absence (an in-place `npm install -g` unlinking the global bin) is not
# mistaken for a missing install. Prints the resolved command; returns 1 only after
# every attempt has failed.
agent_bin() {
  local name="${1:?agent_bin: name required}"
  local attempts="${2:-$GARDEN_AGENT_BIN_ATTEMPTS}" nap="${3:-$GARDEN_AGENT_BIN_SLEEP}"
  local n=1 resolved
  case "$attempts" in ''|*[!0-9]*) attempts=1 ;; esac
  [ "$attempts" -lt 1 ] && attempts=1
  case "$nap" in ''|*[!0-9]*) nap=0 ;; esac
  while :; do
    if resolved="$(agent_bin_probe "$name")"; then
      [ "$n" -gt 1 ] && log "$name resolved to $resolved on probe $n/$attempts (the absence was momentary)"
      printf '%s\n' "$resolved"
      return 0
    fi
    [ "$n" -ge "$attempts" ] && break
    log "$name not on PATH nor in any known install location; re-probing in ${nap}s ($n/$attempts)"
    if [ "$nap" -gt 0 ]; then sleep "$nap"; fi
    n=$((n + 1))
  done
  return 1
}

# claude_bin [attempts] [sleep-secs] — the agent CLI every claude handler drives.
# Usage at a call site that CANNOT proceed without it:
#     cli="$(claude_bin)" || die_environmental "cannot run <x>: the claude CLI …"
# Note the command substitution: die_environmental must run in the PARENT shell,
# so `exit` actually leaves the handler. A soft-skip caller uses claude_bin_now.
claude_bin()     { agent_bin claude "$@"; }
claude_bin_now() { agent_bin_probe claude; }

# die_environmental <msg> — the handler cannot run because its ENVIRONMENT is
# broken (the agent CLI is absent, a required runtime vanished), NOT because the
# claimed job is defective. Exits GARDEN_ENV_RC (EX_TEMPFAIL) so:
#   * gardener.sh classifies it TRANSIENT (is_environmental_rc) — one progress
#     note, no kind:error against an innocent job, left in doin for the reaper;
#   * a timer-driven handler under self-heal-run.sh exits CLEAN (that wrapper
#     already normalizes EX_TEMPFAIL) and burns no self-heal responder.
# The message still goes to the capture, so the environmental cause is diagnosable.
die_environmental() { log "ENVIRONMENT: $*"; exit "${GARDEN_ENV_RC:-75}"; }

# --- the transient (not-attributable) handler exit ---------------------------
#
# EX_TEMPFAIL again, the SAME code as GARDEN_ENV_RC / GARDEN_OFFLINE_RC (all three
# are species of "this failure is not attributable to the INPUT the handler was
# given") — named separately for the same reason those two are: so the intent
# reads clearly at the exit site, and so they can be tuned apart later.
#
# The distinction matters wherever a caller keeps a BOUNDED-RETRY BUDGET against a
# fixed input and DISCARDS that input when the budget runs out. follow-up.sh is the
# case that motivated this: it quarantines a digest of tada-report follow-ups after
# GARDEN_FOLLOWUP_MAX_RETRIES consecutive failures on the same pending set. A
# fleet-wide API outage (2026-07-28 08:48–09:18: four consecutive `garden-follow-up`
# failures inside the storm that took down ~30 gardener handlers) fails every tick
# for a reason that has NOTHING to do with the digest, so a budget that counts those
# ticks discards follow-ups that were never actually attempted. A handler that
# `die_transient`s says so explicitly, so the caller can retry WITHOUT spending
# budget instead of re-deriving the classification from captured text.
: "${GARDEN_TRANSIENT_RC:=75}"

# die_transient <msg> — the handler failed for a TRANSIENT cause that the next
# attempt on the SAME input will likely clear (an API overload/rate-limit window, a
# push-contention exhaustion), NOT because that input is bad. Exits
# GARDEN_TRANSIENT_RC (EX_TEMPFAIL), which self-heal-run.sh normalizes to a CLEAN
# exit — so a fleet-wide outage neither spends a retry budget, nor marks the unit
# failed, nor burns a self-heal responder per cadence.
die_transient() { log "TRANSIENT: $*"; exit "${GARDEN_TRANSIENT_RC:-75}"; }

# Classify an exit code ($1) as NOT ATTRIBUTABLE to the handler's input: the
# transient rc above, or either environmental rc (is_environmental_rc). Returns 0
# for those, 1 otherwise. A caller holding a bounded-retry budget against a fixed
# input must NOT charge these to it.
is_nonattributable_rc() {
  case "$1" in
    "${GARDEN_TRANSIENT_RC:-75}") return 0 ;;
  esac
  is_environmental_rc "$1"
}

# --- pre-claim worker health gate (the ps23 WORK-SINK outage) ----------------
#
# The resolver above makes the agent CLI easier to FIND; this gate stops a worker
# that STILL cannot find it from taking work. Both halves are needed — a resolver
# alone still fails open on a host where the CLI is genuinely absent.
#
# WHY A BROKEN HOST IS A FLEET PROBLEM, NOT A HOST PROBLEM. Probing the binary
# inside the handler — the shape every claude/codex handler had — runs AFTER the
# claim, so the job has already been stolen from the shared board. The handler then
# fails in about a second, which returns that worker to the poll loop far faster
# than a healthy worker actually doing a job. A fast-failing host therefore WINS
# CLAIM RACES DISPROPORTIONATELY: it drains the board into doin/, fails everything,
# the reaper requeues, and the jobs doom — while every healthy host sits idle.
# One misconfigured host can doom the whole fleet's board (ps23, 2026-07-27/28:
# 249 journal entries, ZERO tada completions, all 52 doin/ claims held by ps23).
#
# AND IT CANNOT BE FIXED FROM OUTSIDE. `set-gardeners.sh 0 <host>` is refused by
# design ("a host may set only its own worker counts") and drain-fleet.sh's marker
# is host-local ($GARDEN_ROOT/.garden-state/draining), so no peer can take a broken
# host out of rotation. The ONLY actor that can stop a broken worker from claiming
# is that worker. Hence: a gate in the spine, BEFORE the claim.
#
# THE INVARIANT: a worker that cannot run a job never takes one.
#
# Three properties the gate must have, each learned from the outage:
#   * SELF-DISQUALIFY, DON'T CRASH. An unhealthy worker idle-polls (re-probing on
#     the shared exponential backoff) rather than exiting into a systemd restart
#     loop, so it self-heals the moment the binary reappears after e.g. an
#     `npm install -g` window, and stays parked as long as it is unhealthy.
#   * REPORT ON THE EDGE, NOT PER TICK. ps23 emitted a journal `error` per failed
#     job for hours. The report here is keyed HOST-WIDE PER KIND and won by exactly
#     ONE worker via an atomic mkdir, so ~20 gardeners on a broken host produce ONE
#     error entry for the whole episode and ONE progress entry on recovery — never
#     one per worker, never one per tick (silent-until-error).
#   * COVER EVERY KIND. The probe target comes from the worker-kind registry
#     (agent_bin), so gardener→claude, cleric/hermit/fireworker→codex,
#     mystic→kimi are all gated by the one call site in the spine's poll loop.
#
# SCOPE: the gate asserts only that the kind's DEFAULT handler can run. The spine
# is backend-pluggable, so when GARDEN_JOB_HANDLER names a SUBSTITUTED handler (a
# test stub, an operator experiment) its dependencies are unknown to the spine and
# the gate does not apply — gardener.sh makes that determination at the call site.
# GARDEN_WORKER_HEALTH_GATE=0 disables it outright.
: "${GARDEN_WORKER_HEALTH_GATE:=1}"
# Host-local edge state. One directory per KIND per episode; its existence IS the
# "this kind is currently unhealthy on this host" fact, and creating/removing it is
# the atomic right to report the transition.
: "${GARDEN_WORKER_HEALTH_DIR:=$GARDEN_STATE/health}"

# worker_agent_bin <kind> — the agent CLI a kind's default handler drives. Prints
# the name; returns non-zero for an unknown kind or a kind with no CLI dependency.
worker_agent_bin() {
  worker_kind_field "${1:?worker_agent_bin: kind required}" agent_bin 2>/dev/null
}

# worker_health_marker <kind> — the per-kind episode marker directory (see above).
worker_health_marker() {
  printf '%s\n' "$GARDEN_WORKER_HEALTH_DIR/${1:?worker_health_marker: kind required}.unhealthy"
}

# worker_health_probe <kind> — ONE resolution pass for this kind's agent CLI.
# Prints the resolved command and returns 0 when the worker can run a job; returns
# 1 when the CLI is nowhere to be found. Deliberately the single-pass
# agent_bin_probe, not the retrying agent_bin: the gate's own backoff-and-re-probe
# park IS the retry, and a bounded sleep here would stall the loop's drain/stop
# checks. A kind with no declared CLI is healthy by definition (nothing to break).
worker_health_probe() {
  local kind="${1:?worker_health_probe: kind required}" name
  name="$(worker_agent_bin "$kind")" || return 0
  [ -n "$name" ] && [ "$name" != none ] || return 0
  agent_bin_probe "$name"
}

# _worker_health_report <kind> <id> <state> <detail> — the ONE transition report.
# Writes a journal entry (kind:error on the healthy→unhealthy edge, kind:progress
# on recovery) and raises/clears the matching coalescing maintainer notice. Only
# ever reached by the worker that won the atomic edge claim below. Never fails its
# caller: a journal push cannot be assumed to work on a host this broken.
_worker_health_report() {
  local kind="$1" id="$2" state="$3" detail="$4" entry_kind msg key
  key="worker-agent-bin-$kind-$GARDEN"
  if [ "$state" = unhealthy ]; then
    entry_kind=error
    msg="$(printf '%s\n' \
      "$kind workers on $GARDEN cannot resolve their agent CLI ($detail) — the pool has SELF-DISQUALIFIED and is claiming nothing." \
      "" \
      "Every $kind on this host is parked in its poll loop, re-probing on a backoff; it resumes claiming by itself the moment the CLI resolves (no restart needed). This is deliberate: a worker whose handler dies in a second wins claim races against healthy workers doing real work, so it would drain the shared board into doin/ and doom it. Parking makes the host merely IDLE instead of a work SINK." \
      "" \
      "To fix: install or repair the CLI on $GARDEN (the fleet probes PATH first, then /usr/local/bin, /usr/bin, ~/.local/bin, ~/.claude/local, \$NVM_BIN, ~/.npm-global/bin, ~/.node/bin, ~/bin), or pin it explicitly with the GARDEN_<NAME>_BIN override. One entry is emitted per host per kind per episode, not per tick; recovery reports itself.")"
  else
    entry_kind=progress
    msg="$kind workers on $GARDEN resolved their agent CLI again ($detail); the pool has UN-parked and is claiming normally. Closing the self-disqualification episode."
  fi
  log "health gate: $kind on $GARDEN is $state ($detail)"
  printf '%s\n' "$msg" \
    | GARDEN_ROLE="$kind" "$GARDEN_ROOT/scripts/jobs/journal-entry.sh" "$entry_kind" >/dev/null 2>&1 || true
  if [ "$state" = unhealthy ]; then alert_maintainer "$key" "$msg"
  else alert_maintainer_clear "$key" "$msg"; fi
  return 0
}

# worker_health_gate <kind> <id> — THE PRE-CLAIM GATE. Returns 0 when this worker
# may claim, 1 when it must not. Idempotent and cheap on the happy path: one probe
# plus one directory test, no fork, no journal traffic, so a healthy fleet behaves
# exactly as it did before this existed.
worker_health_gate() {
  local kind="${1:?worker_health_gate: kind required}" id="${2:-0}" marker cli name claimed
  [ "${GARDEN_WORKER_HEALTH_GATE:-1}" = 0 ] && return 0
  marker="$(worker_health_marker "$kind")"
  name="$(worker_agent_bin "$kind" 2>/dev/null || true)"
  if cli="$(worker_health_probe "$kind" 2>/dev/null)"; then
    # HEALTHY. Fast path when no episode is open. When one IS open, exactly one
    # worker wins the recovery report: the rename succeeds for the first caller
    # only, and every later caller finds the marker already gone.
    if [ -d "$marker" ]; then
      claimed="$marker.recovered.$$"
      if mv "$marker" "$claimed" 2>/dev/null; then
        rm -rf "$claimed" 2>/dev/null || true
        _worker_health_report "$kind" "$id" healthy "${cli:-${name:-agent CLI}}"
      fi
    fi
    return 0
  fi
  # UNHEALTHY. `mkdir` on an existing directory fails, so it is the atomic
  # healthy→unhealthy edge latch: the single winner reports, everyone else parks
  # silently. A marker we cannot create at all (an unwritable state dir) still
  # parks the worker — the invariant holds even when the bookkeeping does not.
  mkdir -p "$GARDEN_WORKER_HEALTH_DIR" 2>/dev/null || true
  if mkdir "$marker" 2>/dev/null; then
    date -u +%FT%TZ > "$marker/since" 2>/dev/null || true
    _worker_health_report "$kind" "$id" unhealthy "${name:-agent CLI} not on PATH nor in any known install location"
  fi
  return 1
}

# --- backend probe + effective count (auth auto-tune) -------------------------
#
# Layered ON TOP of the per-claim worker_health_gate above (see
# designs/gnome-backend-verified-autotune.md § 0), this adds the two dimensions the
# health gate deliberately does not carry: CREDENTIALS (the CLI can be on PATH yet
# unauthenticated) and a SCALER-LAYER effective count / provisioning gate (ramp a
# whole pool to 0 and back, and refuse to DECLARE a kind a host cannot back). Both
# reuse the same registry (worker_kind_field), so a new kind is covered from one
# place. The probe's software checks intentionally MIRROR the health gate's rather
# than depend on it, because the probe runs in the scaler and in set-workers, not
# only in the worker poll loop.

# claude_auth_ok — the one NEW probe (the gardener handler today checks only that the
# CLI is on PATH). Software: claude on PATH. Credentials: ANTHROPIC_API_KEY non-empty
# OR a non-empty Claude Code OAuth credential file. PRESENCE, not freshness, is the
# hard pass/fail: Claude Code refreshes an expired token from its stored refresh
# token, so a past .claudeAiOauth.expiresAt is only a soft signal; a human logout
# REMOVES the file, which is exactly the loss a tick must catch. No tokens spent.
claude_auth_ok() {                         # -> 0 authed+installed, 1 otherwise
  command -v claude >/dev/null 2>&1 || { echo "claude not on PATH" >&2; return 1; }
  [ -n "${ANTHROPIC_API_KEY:-}" ] && return 0
  local cred="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.credentials.json"
  [ -s "$cred" ] || { echo "no ANTHROPIC_API_KEY and no Claude login credential ($cred)" >&2; return 1; }
  return 0
}

# _probe_bounded <secs> <fn> [args...] — run one backend probe under a wall-clock
# bound so a wedged backend (e.g. a hung `codex login status`) can never stall the
# reconcile tick. A sidecar watchdog SIGTERMs the probe past the deadline; the
# probe's stderr diagnostic still flows to the caller (capturable via command
# substitution), and a killed probe returns non-zero (read as a failed probe).
_probe_bounded() {
  local secs="$1"; shift
  local rc=0 pid wd
  ( "$@" ) & pid=$!
  ( sleep "$secs"; kill -TERM "$pid" 2>/dev/null ) 2>/dev/null & wd=$!
  if wait "$pid" 2>/dev/null; then rc=0; else rc=$?; fi
  kill -TERM "$wd" 2>/dev/null || true; wait "$wd" 2>/dev/null || true
  return "$rc"
}

# _worker_backend_probe_dispatch <kind> <provider> — the provider-specific check.
# Reuses the handlers' EXISTING preflights verbatim (lazily sourcing the handler
# provider-common file), so the same code that gates a real job gates provisioning
# and the two can never drift on what "authenticated" means. Only the anthropic
# probe (claude_auth_ok) is new.
_worker_backend_probe_dispatch() {
  local kind="$1" provider="$2" handlers model
  handlers="$(dirname "${BASH_SOURCE[0]}")/handlers"
  case "$provider" in
    anthropic)
      claude_auth_ok ;;
    openai)
      declare -F codex_provider_preflight >/dev/null 2>&1 || source "$handlers/codex-provider-common.sh"
      # GARDEN_PROBE_LIVE=1 bypasses the per-boot auth-ok marker so a mid-boot logout
      # is SEEN (the scaler needs the opposite of the hot path's cached auth).
      GARDEN_PROBE_LIVE=1 codex_provider_preflight openai "$kind" scaler-probe \
        "$(worker_kind_field "$kind" state_ns)" 0 ;;
    local)
      declare -F codex_local_endpoint_ready >/dev/null 2>&1 || source "$handlers/codex-provider-common.sh"
      command -v codex >/dev/null 2>&1 || { echo "codex not on PATH (hermit backend)" >&2; return 1; }
      model="$(model_routing_default local 2>/dev/null || true)"; : "${model:=qwen3.6}"
      # READ-ONLY: endpoint reachable AND serving a usable model; does NOT self-heal
      # (that starts garden-ollama.service per job — the scaler must stay cheap).
      codex_local_endpoint_ready "$model" \
        || { echo "local inference endpoint serves no usable model ($model)" >&2; return 1; } ;;
    moonshot)
      declare -F kimi_provider_preflight >/dev/null 2>&1 || source "$handlers/kimi-provider-common.sh"
      kimi_provider_preflight scaler-probe ;;
    fireworks)
      declare -F fireworks_provider_preflight >/dev/null 2>&1 || source "$handlers/codex-provider-common.sh"
      fireworks_provider_preflight "$kind" scaler-probe ;;
    *)
      echo "worker_backend_probe: unhandled provider '$provider' for kind '$kind'" >&2; return 1 ;;
  esac
}

# worker_backend_probe <kind> — 0 when this host has BOTH credentials and software
# for the kind's backend, 1 otherwise, with a one-line actionable diagnostic on
# stderr. Spends NO tokens (every check is a filesystem/env read, a login-status
# subprocess, or a bounded curl) and is wrapped in a wall-clock bound.
worker_backend_probe() {
  local kind="${1:?worker_backend_probe: kind required}" provider bound
  # Test/override seam: a deterministic stand-in for the whole probe so the
  # effective-count hysteresis and the set-workers declare-gate can be driven
  # without a real backend. Mirrors GARDEN_UNIT_CTL / GARDEN_PRESS_HEAD_CMD.
  if [ -n "${GARDEN_BACKEND_PROBE_CMD:-}" ]; then
    "$GARDEN_BACKEND_PROBE_CMD" "$kind"; return $?
  fi
  provider="$(worker_kind_field "$kind" provider)" \
    || { echo "worker_backend_probe: unknown kind '$kind'" >&2; return 1; }
  bound="${GARDEN_BACKEND_PROBE_TIMEOUT:-8}"
  _probe_bounded "$bound" _worker_backend_probe_dispatch "$kind" "$provider"
}

# backend_effective_count <kind> <declared> — the RUNTIME cap the scaler applies in
# place of the declared journal target. Probes the kind's backend live, updates a
# tiny per-host record under $GARDEN_STATE/<state_ns>/backend/ ({ effective,
# pass_streak, fail_streak, degraded_ticks }), and prints the effective count. NO
# journal write (invisible to leader/follower and the owning-host-only-writes rule).
#
# Hysteresis (confirm-before-move, both directions):
#   ramp UP   after GARDEN_RAMP_UP_CONFIRM   (default 1) consecutive PASSES → declared
#   ramp DOWN after GARDEN_RAMP_DOWN_CONFIRM (default 2) consecutive FAILS   → 0
#   hold      inside the band (streak below threshold) → effective unchanged
# One confirmed pass is enough to ramp up (auth success is unambiguous); two failing
# ticks are required to ramp down so a single transient blip (a 429, a restarting
# Ollama) never tears the pool down. GARDEN_BACKEND_RAMP_STEP>0 raises effective by at
# most N per tick on ramp-up (default 0 = one-step to declared).
#
# The scaler keeps the gardener floor on DECLARED, never on the value this returns:
# an effective 0 from a failed Claude probe is INTENDED (§5), the mechanism by which
# "a gnome with no Claude auth sits at 0" holds without declaring 0. Logs every
# effective transition and, after GARDEN_BACKEND_DEGRADED_TICKS capped-below-declared
# ticks, raises ONE deduped maintainer alert.
backend_effective_count() {
  local kind="${1:?backend_effective_count: kind required}" declared="${2:?backend_effective_count: declared required}"
  local ns dir rec status count_key
  ns="$(worker_kind_field "$kind" state_ns)" || ns="$kind"
  count_key="$(worker_kind_field "$kind" count_key)" || count_key="$kind"
  dir="$GARDEN_STATE/$ns/backend"
  rec="$dir/state"; status="$dir/status"
  local up_confirm down_confirm degraded_ticks ramp_step
  up_confirm="${GARDEN_RAMP_UP_CONFIRM:-1}"
  down_confirm="${GARDEN_RAMP_DOWN_CONFIRM:-2}"
  degraded_ticks="${GARDEN_BACKEND_DEGRADED_TICKS:-10}"
  ramp_step="${GARDEN_BACKEND_RAMP_STEP:-0}"
  [[ "$declared" =~ ^[0-9]+$ ]] || declared=0

  # Load the prior record (all fields default to 0 / sanitize to 0).
  local eff=0 pass=0 fail=0 degraded=0 v
  if [ -f "$rec" ]; then
    v="$(sed -n 's/^effective=//p'      "$rec" | head -1)"; [[ "$v" =~ ^[0-9]+$ ]] && eff="$v"
    v="$(sed -n 's/^pass_streak=//p'    "$rec" | head -1)"; [[ "$v" =~ ^[0-9]+$ ]] && pass="$v"
    v="$(sed -n 's/^fail_streak=//p'    "$rec" | head -1)"; [[ "$v" =~ ^[0-9]+$ ]] && fail="$v"
    v="$(sed -n 's/^degraded_ticks=//p' "$rec" | head -1)"; [[ "$v" =~ ^[0-9]+$ ]] && degraded="$v"
  fi
  local old_eff="$eff" probe=pass diag=""
  if diag="$(worker_backend_probe "$kind" 2>&1 1>/dev/null)"; then probe=pass; else probe=fail; fi

  if [ "$probe" = pass ]; then
    pass=$((pass + 1)); fail=0
    if [ "$pass" -ge "$up_confirm" ]; then
      if [ "$ramp_step" -gt 0 ] && [ "$eff" -lt "$declared" ]; then
        eff=$((eff + ramp_step)); [ "$eff" -gt "$declared" ] && eff="$declared"
      else
        eff="$declared"
      fi
    fi
  else
    fail=$((fail + 1)); pass=0
    if [ "$fail" -ge "$down_confirm" ]; then eff=0; fi
  fi

  # Degraded = capped below the declared target while the owner declares > 0.
  if [ "$declared" -gt 0 ] && [ "$eff" -lt "$declared" ]; then
    degraded=$((degraded + 1))
  else
    degraded=0
  fi

  # Persist the runtime record + a cheap status sidecar (read-only, no journal).
  mkdir -p "$dir" 2>/dev/null || true
  if {
    printf 'effective=%s\n'      "$eff"
    printf 'pass_streak=%s\n'    "$pass"
    printf 'fail_streak=%s\n'    "$fail"
    printf 'degraded_ticks=%s\n' "$degraded"
    printf 'declared=%s\n'       "$declared"
    printf 'probe=%s\n'          "$probe"
  } > "$rec.tmp" 2>/dev/null; then mv "$rec.tmp" "$rec" 2>/dev/null || true; fi
  printf 'declared=%s effective=%s probe=%s degraded_ticks=%s\n' \
    "$declared" "$eff" "$probe" "$degraded" > "$status.tmp" 2>/dev/null \
    && mv "$status.tmp" "$status" 2>/dev/null || true

  # Observability: log every effective transition (a hold is a quiet DEBUG).
  local shown; [ "$probe" = pass ] && shown="$pass" || shown="$fail"
  if [ "$eff" != "$old_eff" ]; then
    log "auto-tune $kind: effective $old_eff->$eff (declared $declared; probe $probe streak $shown)"
  else
    log "DEBUG auto-tune $kind: hold effective $eff (declared $declared; probe $probe streak $shown)"
  fi

  # Surface a host that cannot run its declared kinds: ONE deduped alert once the
  # cap has held ~GARDEN_BACKEND_DEGRADED_TICKS ticks; cleared on recovery.
  local akey="backend-degraded-${GARDEN}-${kind}"
  if [ "$degraded" -ge "$degraded_ticks" ] && [ "$degraded_ticks" -gt 0 ]; then
    alert_maintainer "$akey" "host $GARDEN declares $count_key=$declared but its $kind backend probe has failed ~${degraded}m (effective 0). It cannot run its declared ${kind}s — ${diag:-backend unavailable}."
  elif [ "$declared" -eq 0 ]; then
    # Stood DOWN to zero — a legitimate resolution of "cannot run its declared
    # workers": there are none to run, so the notice must CLEAR, not merely fall
    # silent-but-outstanding (the else-branch above resets $degraded, so the alert
    # branch never fires again AND the recovery branch below — gated eff>=declared
    # with declared>0 — can never retire it either; the notice would sit forever).
    # Distinct wording: stood down, NOT a backend recovery — the inbox must not
    # conflate the two facts. alert_maintainer_clear is a no-op when nothing is
    # outstanding, so throttling an already-quiet class to zero makes no spurious
    # clear. General across worker kinds; fireworker is only the motivating case.
    alert_maintainer_clear "$akey" "$kind on $GARDEN stood down to $count_key=0; the backend-degraded notice is retired. The class was throttled to zero (nothing left to run) — this is a stand-down, not a backend recovery."
  elif [ "$eff" -ge "$declared" ]; then
    alert_maintainer_clear "$akey" "$kind backend on $GARDEN recovered; effective ramped to declared $declared."
  fi

  printf '%s\n' "$eff"
}

# --- watchdog notices: one entry per CONDITION, not one per occurrence --------
#
# Every `watchdog:*` maintainer message in the fleet is written by
# alert_maintainer below, so this is the ONE place the flood is fixed for every
# watchdog path (self-heal, the per-repo triagers, the foreman, ollama-serve, the
# journal-worktree keeper, the root-repo guard, …). Two mechanisms, layered:
#
#   1. COALESCE. Delivery goes through watchdog-notice.sh, which keeps ONE keyed
#      inbox entry per open condition and AMENDS it (notice_count / first_seen /
#      last_seen) instead of appending a new message — the reaper's doom-notice
#      treatment, generalized. Occurrences suppressed by the throttle are COUNTED
#      locally and folded into the next delivery, so notice_count is the true
#      occurrence count, not the delivery count.
#   2. CLASSIFY. A provider quota / usage-limit refusal is an ENVIRONMENTAL
#      condition affecting every unit at once, not one fault per unit: it is
#      re-keyed to the single fleet-level `provider-quota` key, so 94 per-unit
#      reports of "you've hit your weekly limit" become ONE fleet notice that
#      counts up. alert_maintainer_clear closes it when service returns.
#
# Local state per key, under $GARDEN_STATE/alerts/<key>.*:
#   .last   epoch of the last DELIVERY   (the throttle window)
#   .count  occurrences observed since the last delivery (folded into the next)
#   .total  occurrences in this episode  (reported by the recovery notice)
#   .first  ISO time of the episode's first occurrence
# All four are cleared by alert_maintainer_clear, which starts a fresh episode.

# Signatures of a PROVIDER quota / usage-cap refusal — the environmental class.
# Deliberately NARROWER than GARDEN_TRANSIENT_CLAUDE_SIGNATURES: a generic
# `rate limit` or 429 is retried in-band and is not necessarily fleet-wide, while
# these wordings are the account-level cap that refuses every call until a named
# reset time (e.g. "You've hit your weekly limit · resets 4:10pm (UTC)"). Matched
# case-insensitively.
: "${GARDEN_PROVIDER_QUOTA_SIGNATURES:=hit your (session|usage|weekly|5-hour) limit|(session|usage|weekly|5-hour) limit (reached|exceeded)|usage limit reached|quota (exceeded|exhausted)|resets [0-9][^)]*\(utc\)}"
# The ONE fleet-level key every provider-quota observation folds into.
: "${GARDEN_PROVIDER_QUOTA_KEY:=provider-quota}"

# is_provider_quota_text <text> — 0 when the text is a provider quota/limit
# refusal (the environmental class), 1 otherwise.
is_provider_quota_text() {
  printf '%s' "${1:-}" | grep -qiE "$GARDEN_PROVIDER_QUOTA_SIGNATURES"
}

# provider_quota_reset_clause <text> — echoes the "resets …" clause when the
# refusal names its own reset time, else nothing. Lets the fleet notice tell the
# maintainer WHEN the condition ends without them reading the raw diagnosis.
provider_quota_reset_clause() {
  printf '%s' "${1:-}" | grep -oiE 'resets [^.·|]*' | head -1 | sed 's/[[:space:]]*$//'
}

# alert_maintainer <dedup-key> <message> — best-effort, THROTTLED, COALESCING
# escalation to the maintainer inbox. Used by require_tools, the watchers'
# silent-output anomaly checks, the triagers, and the self-heal responder.
# Throttled per <dedup-key> (default 1h) via a local state marker so a per-minute
# failure loop cannot spam the inbox, and coalesced per key so a condition that
# outlives many windows still occupies ONE inbox entry whose count rises.
# Never fails its caller: every path swallows errors and returns 0.
alert_maintainer() {
  local key="$1" msg="$2"
  [ "${GARDEN_NO_MAINTAINER_ALERT:-0}" = 1 ] && return 0

  # Environmental reclassification (before keying): one fleet condition, one key.
  if is_provider_quota_text "$msg"; then
    local resets; resets="$(provider_quota_reset_clause "$msg" 2>/dev/null || true)"
    msg="provider quota/usage limit reached — the API is refusing calls fleet-wide${resets:+ (}${resets}${resets:+)}.
This is an ACCOUNT LIMIT, not a garden defect: no code fix applies, and the fleet
resumes on its own once the window resets (see skills/restore/SKILL.md for the
post-outage restore). Every unit that trips the limit folds into THIS one notice
rather than filing its own. Latest observation (originally keyed '$key', host $GARDEN):
$msg"
    key="$GARDEN_PROVIDER_QUOTA_KEY"
  fi

  local skey="${key//[^A-Za-z0-9._-]/_}"
  local dir="$GARDEN_STATE/alerts"
  local marker="$dir/$skey.last" cfile="$dir/$skey.count" tfile="$dir/$skey.total" ffile="$dir/$skey.first"
  local now last n total first
  now="$(date +%s 2>/dev/null || echo 0)"
  mkdir -p "$dir" 2>/dev/null || true

  # Count the occurrence FIRST, so one suppressed by the throttle is still folded
  # into the next delivery's notice_count (the flood's real magnitude, reported in
  # one entry instead of one message per window).
  n="$(cat "$cfile" 2>/dev/null || echo 0)"; [[ "$n" =~ ^[0-9]+$ ]] || n=0; n=$(( n + 1 ))
  printf '%s\n' "$n" > "$cfile" 2>/dev/null || true
  total="$(cat "$tfile" 2>/dev/null || echo 0)"; [[ "$total" =~ ^[0-9]+$ ]] || total=0
  printf '%s\n' "$(( total + 1 ))" > "$tfile" 2>/dev/null || true
  [ -s "$ffile" ] || date -u +%FT%TZ > "$ffile" 2>/dev/null || true

  # Throttle: at most one DELIVERY per window per key.
  if [ -f "$marker" ]; then
    last="$(cat "$marker" 2>/dev/null || echo 0)"
    [ $(( now - last )) -lt "${GARDEN_ALERT_THROTTLE_SECS:-3600}" ] && return 0
  fi
  printf '%s\n' "$now" > "$marker" 2>/dev/null || true
  first="$(cat "$ffile" 2>/dev/null || true)"

  if [ -n "${GARDEN_ALERT_CMD:-}" ]; then
    # Test/alternate sink. The historical two-argument contract is preserved; the
    # folded count and first_seen ride along as optional extra arguments.
    "$GARDEN_ALERT_CMD" "$key" "$msg" "$n" "${first:-}" >/dev/null 2>&1 || true
    printf '0\n' > "$cfile" 2>/dev/null || true
    return 0
  fi
  printf '%s\n' "$msg" \
    | GARDEN_SKIP_REF_CHECK=1 GARDEN_SENDER="watchdog:${GARDEN_TAG:-jobs}" \
      "$GARDEN_ROOT/scripts/jobs/watchdog-notice.sh" \
        --count "$n" ${first:+--first-seen "$first"} "$key" >/dev/null 2>&1 || true
  printf '0\n' > "$cfile" 2>/dev/null || true
  return 0
}

# alert_maintainer_clear <dedup-key> [message] — close the loop when a condition
# CLEARS. Silent-until-error means the maintainer never learns an alert ended
# unless we say so, and "it stopped" is exactly the fact that lets them stop
# reading the notice. Posts ONE recovery notice (amending the open entry in place,
# so the whole episode reads as one closed item) and starts a fresh episode.
#
# No-op — a single builtin file test, no fork — when the key was never raised, so
# a caller may put it on its happy path (the triager clears its fetch alert on
# every successful fetch). Never fails its caller.
alert_maintainer_clear() {
  local key="$1" msg="${2:-}"
  [ "${GARDEN_NO_MAINTAINER_ALERT:-0}" = 1 ] && return 0
  local skey="${key//[^A-Za-z0-9._-]/_}"
  local dir="$GARDEN_STATE/alerts"
  local marker="$dir/$skey.last" cfile="$dir/$skey.count" tfile="$dir/$skey.total" ffile="$dir/$skey.first"
  # Nothing was ever DELIVERED for this key on this host → nothing to close.
  [ -f "$marker" ] || return 0
  local total first
  total="$(cat "$tfile" 2>/dev/null || echo 1)"; [[ "$total" =~ ^[0-9]+$ ]] || total=1
  first="$(cat "$ffile" 2>/dev/null || true)"
  rm -f "$marker" "$cfile" "$tfile" "$ffile" 2>/dev/null || true
  [ -n "$msg" ] || msg="the watchdog condition '$key' has cleared on $GARDEN."
  if [ -n "${GARDEN_ALERT_CMD:-}" ]; then
    "$GARDEN_ALERT_CMD" "$key" "RECOVERED: $msg" "$total" "${first:-}" >/dev/null 2>&1 || true
    return 0
  fi
  printf '%s\n' "$msg" \
    | GARDEN_SKIP_REF_CHECK=1 GARDEN_SENDER="watchdog:${GARDEN_TAG:-jobs}" \
      "$GARDEN_ROOT/scripts/jobs/watchdog-notice.sh" \
        --recovered --count "$total" ${first:+--first-seen "$first"} "$key" >/dev/null 2>&1 || true
  return 0
}

# note_provider_quota <context> [text] — record ONE observation of the fleet-level
# provider quota condition, from whichever unit happened to trip it. The canonical
# phrase leads the message so alert_maintainer's classifier always fires (keying is
# then idempotent), and the observed refusal text rides along so its reset clause
# reaches the notice.
note_provider_quota() {
  alert_maintainer "$GARDEN_PROVIDER_QUOTA_KEY" \
    "usage limit reached while running ${1:-the fleet}. Observed: ${2:-(no detail captured)}"
}

# note_provider_ok [context] — the provider ANSWERED, so any open fleet-level
# quota condition has ended: emit the single recovery notice. Cheap no-op when no
# quota condition was ever raised on this host.
note_provider_ok() {
  alert_maintainer_clear "$GARDEN_PROVIDER_QUOTA_KEY" \
    "provider quota/usage limit CLEARED — a \`claude -p\` call completed normally on $GARDEN${1:+ (unit: $1)}. The fleet is serving again; see skills/restore/SKILL.md if workers need a restore."
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

# --- standing bare-clone provisioning helpers (shared) -----------------------
# The garden keeps its standing upstream bare clones under
# worktrees/<owner>-<name>.git. clone-keeper.sh re-creates a vanished tracked clone
# and triager.sh self-provisions a watched repo whose clone this host has never
# held; both need the SAME derive-URL + bounded-atomic-clone logic, so it lives
# here rather than being copied. Base of the canonical upstream URL reconstructed
# from a clone's dir basename; overridable for offline tests.
: "${GARDEN_CLONE_URL_BASE:=https://github.com}"

# Resolve the standing bare-clone directory for a repo <slug> (<owner>-<name>).
# The garden's canonical standing bare clones live under $GARDEN_ROOT/worktrees/<slug>.git
# (maintained by clone-keeper.sh; see CLAUDE.md § Layout and WORKTREES.md) — NOT the
# un-provisioned $GARDEN_ROOT/repos, whose stale default silently FATAL-looped every
# armed triager tick. Both the triager and the comment-watcher resolve their local
# clone through THIS single helper so their two defaults cannot drift apart again.
# Honors a GARDEN_REPOS override (the test harness points it at a norepos/ dir to
# exercise the missing-clone path); absent that override it defaults to the worktrees/
# location clone-keeper actually maintains, the sole place the default now lives.
bare_clone_dir() {  # bare_clone_dir <slug> — echoes the abs bare-clone path
  printf '%s/%s.git\n' "${GARDEN_REPOS:-$GARDEN_ROOT/worktrees}" "${1:?usage: bare_clone_dir <slug>}"
}

# True when $abs is ITS OWN bare git repo, not a discovered ANCESTOR repo. The
# standing clones live under worktrees/ inside the garden root, which is itself a
# git repo, so a plain `rev-parse --git-dir` on a missing/corrupt dir would walk up
# and succeed against the garden repo — a false positive. Require the resolved
# absolute git-dir to equal $abs. Fails when $abs is missing (git cannot chdir) or
# is a non-repo dir (git discovers an ancestor whose git-dir != $abs).
is_own_git_repo() {
  local abs="$1" gd a g
  gd="$(git -C "$abs" rev-parse --absolute-git-dir 2>/dev/null || true)"
  [ -n "$gd" ] || return 1
  a="$(realpath -m "$abs" 2>/dev/null || echo "$abs")"
  g="$(realpath -m "$gd" 2>/dev/null || echo "$gd")"
  [ "$a" = "$g" ]
}

# True when $1 is a fetchable/cloneable URL or path rather than a bare remote NAME
# (like "origin"). A location source drives a clone directly; a bare name cannot be
# resolved once the clone is gone, so callers derive the URL from the dir basename.
is_remote_location() {
  case "$1" in
    *://*|*@*:*|*/*) return 0 ;;
    *) return 1 ;;
  esac
}

# Reconstruct the canonical upstream URL of a bare clone from its dir basename. The
# garden names standing bare clones worktrees/<owner>-<name>.git, so the upstream is
# derived by reversing it: strip the .git suffix, split on the FIRST '-' into
# <owner>/<name>, and form <GARDEN_CLONE_URL_BASE>/<owner>/<name>.git. Echoes the URL
# and returns 0 when derivable; returns 1 when the basename does not fit the
# <owner>-<name>.git shape (no .git suffix, or no '-' to split on). The FIRST-'-'
# split is ambiguous for hyphenated owners/names — the caller treats it as a last
# resort behind any explicitly-configured source.
derive_clone_url() {
  local abs="$1" bn owner name
  bn="$(basename -- "$abs")"
  case "$bn" in *.git) bn="${bn%.git}" ;; *) return 1 ;; esac
  case "$bn" in *-*) ;; *) return 1 ;; esac
  owner="${bn%%-*}"
  name="${bn#*-}"
  [ -n "$owner" ] && [ -n "$name" ] || return 1
  printf '%s/%s/%s.git\n' "$GARDEN_CLONE_URL_BASE" "$owner" "$name"
}

# Bounded fetch in <dir>. The remaining arguments are passed to `git fetch`, so
# callers can fetch a named remote/branch or refresh every configured remote.
# Each attempt has a wall-clock deadline, retries with backoff, and returns the
# last non-zero status only after the retry budget is spent. This is shared by
# clone-keeper, the triager and root-repo-guard: a network blip must not leave a
# timer running until systemd kills it.
bounded_fetch() {
  local dir="$1" attempt=1 rc=0
  shift
  while :; do
    if timeout --kill-after="$GARDEN_FETCH_KILL_AFTER" "$GARDEN_FETCH_TIMEOUT" \
         git -C "$dir" fetch -q "$@" 2>/dev/null; then
      return 0
    else
      rc=$?
    fi
    { [ "$rc" -eq 124 ] || [ "$rc" -eq 137 ]; } \
      && log "fetch $* in $dir timed out (>${GARDEN_FETCH_TIMEOUT}s, rc=$rc) on attempt $attempt"
    if [ "$attempt" -ge "$GARDEN_FETCH_RETRIES" ]; then
      log "fetch $* in $dir failed after $attempt attempt(s) (last rc=$rc)"
      return "$rc"
    fi
    backoff "$attempt"; attempt=$((attempt+1))
  done
}

# Bounded bare clone of <src> into <abs>, mirroring bounded_fetch's timeout+retry
# discipline (git has no IO timeout of its own). We NEVER clone straight into the
# tracked path: git clone removes its own target on an internal error, but a
# timeout SIGTERM can leave a partial tree, and a concurrent tick (or a worktree
# being cut off this clone) could observe that half-populated $abs. So we clone into
# a SIBLING temp path and, only on a fully-successful clone, atomically `mv -T` it
# into place — a genuine atomic rename(2) on the same filesystem, so $abs is only
# ever fully absent or fully complete. `mv -T` also refuses to move INTO an existing
# dir, so if a racing tick recreated $abs first our rename fails, we discard our
# temp, and report success. Every temp is scrubbed on failure and between retries.
# Returns 0 on success, the last non-zero rc after the retry budget is spent.
bounded_clone() {
  local src="$1" abs="$2" attempt=1 rc=0 tmp
  mkdir -p "$(dirname "$abs")"
  while :; do
    tmp="${abs%/}.reclone.$$.$attempt"
    rm -rf "$tmp"
    if timeout --kill-after="$GARDEN_FETCH_KILL_AFTER" "$GARDEN_FETCH_TIMEOUT" git clone -q --bare "$src" "$tmp" 2>/dev/null; then
      if mv -T "$tmp" "$abs" 2>/dev/null; then
        return 0
      fi
      rm -rf "$tmp"
      is_own_git_repo "$abs" && return 0
      rc=1
    else
      rc=$?
      rm -rf "$tmp"
    fi
    [ "$rc" -eq 124 ] && log "clone of $src into $abs timed out (>${GARDEN_FETCH_TIMEOUT}s) on attempt $attempt"
    if [ "$attempt" -ge "$GARDEN_FETCH_RETRIES" ]; then
      log "clone of $src into $abs failed after $attempt attempt(s) (last rc=$rc)"
      return "$rc"
    fi
    backoff "$attempt"; attempt=$((attempt+1))
  done
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
# 2026-07-01 incident that doomed a dozen unrelated jobs). The fleet brake is a
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

# exec_tmpdir — echo a TMPDIR that is safe to execute from.
#
# The container mounts /tmp noexec. Yarn 4's portable shell materializes every
# package-bin invocation as a temporary exec shim under $TMPDIR, so on a noexec
# $TMPDIR any `yarn run <script>` that dispatches through a bin dies with
# "permission denied: <bin>" (seen as `ses-ava` and `tsc` on
# endojs/endo-but-for-bots) even though the same script is green on CI. That is
# an environment-parity defect in the sense of skills/local-verify: the check
# cannot run locally at all, so it is only ever discovered on CI.
#
# Echoes $TMPDIR unchanged when it is already exec-capable, else an exec-capable
# directory under $GARDEN_SCRATCH. Never fails; falls back to the current
# $TMPDIR (or /tmp) if the scratch dir cannot be made exec-capable either.
exec_tmpdir() {
  local cur probe rc alt
  cur="${TMPDIR:-/tmp}"
  probe="$cur/.garden-execprobe.$$"
  rc=1
  if printf '#!/bin/sh\nexit 0\n' >"$probe" 2>/dev/null && chmod +x "$probe" 2>/dev/null; then
    "$probe" >/dev/null 2>&1 && rc=0
  fi
  rm -f "$probe" 2>/dev/null || true
  if [ "$rc" -eq 0 ]; then printf '%s\n' "$cur"; return 0; fi

  alt="$GARDEN_SCRATCH/tmpexec"
  mkdir -p "$alt" 2>/dev/null || { printf '%s\n' "$cur"; return 0; }
  probe="$alt/.garden-execprobe.$$"
  rc=1
  if printf '#!/bin/sh\nexit 0\n' >"$probe" 2>/dev/null && chmod +x "$probe" 2>/dev/null; then
    "$probe" >/dev/null 2>&1 && rc=0
  fi
  rm -f "$probe" 2>/dev/null || true
  if [ "$rc" -eq 0 ]; then printf '%s\n' "$alt"; else printf '%s\n' "$cur"; fi
}

# hermetic_gitconfig — export GIT_CONFIG_GLOBAL/GIT_CONFIG_SYSTEM so that every
# `git` in this process tree sees ONLY repository-local configuration.
#
# The garden container bind-mounts the host user's home, so the maintainer's
# ~/.config/git/config is in effect for every git the fleet spawns — while a
# stock CI runner has no user configuration at all. Any setting there that
# changes git's SEMANTICS rather than its presentation is therefore a silent
# local-vs-CI divergence in the sense of skills/local-verify § Parity is the
# contract. Observed instance: `rerere.enabled=true` made a project's conflict
# fixture auto-resolve its intentional conflict ("Staged 'app.txt' using
# previous resolution"), so a test that asserts on the conflict stopping the
# rebase failed locally and passed on CI. `diff.algorithm`, `diff.renames`,
# `merge.conflictStyle`, `rebase.autostash`, `core.autocrlf`, and
# `url.<base>.insteadOf` are the same hazard waiting to happen.
#
# Blanking both config layers is what makes a local run match the runner, so the
# gate's silence means what it claims. Repository-local config still applies (it
# is checked in, hence identical on CI), as does anything a project passes with
# `git -c`. Set GARDEN_INHERIT_GITCONFIG=1 to opt out while debugging.
#
# Idempotent, never fails, and exports nothing when opted out.
hermetic_gitconfig() {
  [ "${GARDEN_INHERIT_GITCONFIG:-}" = "1" ] && return 0
  GIT_CONFIG_GLOBAL=/dev/null
  GIT_CONFIG_SYSTEM=/dev/null
  GIT_CONFIG_NOSYSTEM=1
  export GIT_CONFIG_GLOBAL GIT_CONFIG_SYSTEM GIT_CONFIG_NOSYSTEM
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

# transcript_spool <jsonl-path> [<job-base>] — stage a finishing session's
# transcript into the capture spool so the hourly sweep (transcript-capture.sh)
# can archive it even though the gardener completion hook is about to `rm` the
# original (the false-resume hazard the rm exists to prevent). gzip-copies
# <jsonl-path> to
#   $GARDEN_TRANSCRIPTS_SPOOL/<encoded-cwd>/<session-id>.jsonl.gz
# and appends a pending index row (tab-separated: spooled_at, session_id,
# job_base-or-'-', encoded_cwd) to $GARDEN_TRANSCRIPTS_SPOOL/pending.tsv. The
# <encoded-cwd> is the parent directory NAME of the jsonl (Claude Code's project
# dir), which already carries the `gardener-wt-<base>` pattern the sweep can
# back-derive a base from. Does NO network work and NEVER fails its caller —
# every path logs and returns 0 — so the completion path stays fast and
# offline-safe and the spool survives under $GARDEN_STATE until the timer drains
# it. A missing/empty source is a silent no-op (returns 0): the hook calls this
# for BOTH candidate encodings and only one exists. Redaction is NOT applied here
# (the spool is un-redacted, gzipped raw); the sweep redacts on drain, so
# redaction lives in exactly one place.
transcript_spool() {
  local src="${1:-}" base="${2:--}"
  [ -n "$src" ] && [ -f "$src" ] || return 0
  local encoded_cwd sid spool_dir dest now
  encoded_cwd="$(basename "$(dirname "$src")")"
  sid="$(basename "$src" .jsonl)"
  spool_dir="${GARDEN_TRANSCRIPTS_SPOOL}/${encoded_cwd}"
  if ! mkdir -p "$spool_dir" 2>/dev/null; then
    log "WARN: transcript_spool: cannot create spool dir $spool_dir; not spooling $sid"
    return 0
  fi
  dest="$spool_dir/$sid.jsonl.gz"
  if ! gzip -nc -- "$src" > "$dest" 2>/dev/null; then
    log "WARN: transcript_spool: gzip of $src failed; not spooling $sid"
    rm -f "$dest" 2>/dev/null || true
    return 0
  fi
  now="$(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || echo -)"
  printf '%s\t%s\t%s\t%s\n' "$now" "$sid" "${base:--}" "$encoded_cwd" \
    >> "${GARDEN_TRANSCRIPTS_SPOOL}/pending.tsv" 2>/dev/null \
    || log "WARN: transcript_spool: could not append pending index row for $sid"
  return 0
}

# --- bot git identity (durable across a garden reset) ------------------------
# The fleet's commits and gh calls ride a BOT identity (user.name/user.email), NOT
# the parent shell's global git identity (the maintainer's, on a maintainer host —
# reserved for the ferry). The source of truth is the garden repo's LOCAL
# .git/config, pinned into every per-job worktree by bot_name/bot_email below.
#
# That local config is NOT tracked and NOT baked into the image (the bind mount
# masks it), so a fresh checkout / container recreation would lose it. To make the
# identity DURABLE across a reset we keep two records a reset cannot lose:
#   1. a TRACKED canonical default (bot-identity-defaults.tsv, keyed on the bot
#      login) — always present in a fresh checkout: the fallback; and
#   2. an optional PER-HOST journal override (identity/<host> on journal2, written
#      by set-bot-identity.sh) — the durable per-host store that survives a
#      re-clone from origin/journal2.
# bootstrap-bot-identity.sh applies the resolved identity to the local config on
# bring-up (idempotent, wired into the container entrypoint + the starting
# procedure), and bot_name/bot_email SELF-HEAL to the tracked default so a
# stray-unset config still resolves to the right identity — never garden-bot.
: "${GARDEN_BOT_LOGIN:=kriscendobot}"

# The tracked canonical-defaults table (`login<TAB>name<TAB>email`); comments (#)
# and blank lines are ignored. Field 2 = name, 3 = email; keyed on GARDEN_BOT_LOGIN.
_bot_identity_defaults_file() { printf '%s\n' "$GARDEN_ROOT/scripts/jobs/bot-identity-defaults.tsv"; }
_bot_identity_default_field() {  # <field-index: 2=name 3=email> — prints value, rc 1 if unresolved
  local idx="$1" f val; f="$(_bot_identity_defaults_file)"
  [ -f "$f" ] || return 1
  val="$(awk -F'\t' -v l="$GARDEN_BOT_LOGIN" -v i="$idx" \
    '/^[[:space:]]*#/ {next} NF<3 {next} $1==l {print $i; exit}' "$f" 2>/dev/null)"
  [ -n "$val" ] && { printf '%s\n' "$val"; return 0; }
  return 1
}
# Last-ditch fallbacks (login unknown to the table) still yield a plausible bot
# identity rather than garden-bot: the login as the name, its GitHub noreply email.
bot_default_name()  { _bot_identity_default_field 2 || printf '%s\n' "$GARDEN_BOT_LOGIN"; }
bot_default_email() { _bot_identity_default_field 3 || printf '%s\n' "${GARDEN_BOT_LOGIN}@users.noreply.github.com"; }

# Read a per-host bot-identity override field (bot_name|bot_email) from a SYNCED
# journal clone <dir>. Best-effort: prints nothing when the file/field is absent.
# Consumed by bootstrap-bot-identity.sh (which syncs <dir> first); NOT the hot path.
journal_bot_identity_field() {  # <dir> <field>
  local dir="$1" field="$2"
  sed -n "s/^${field}:[[:space:]]*//p" "$dir/identity/$GARDEN" 2>/dev/null | head -1
}

bot_name()  { git -C "$GARDEN_ROOT" config --get user.name  2>/dev/null || bot_default_name; }
bot_email() { git -C "$GARDEN_ROOT" config --get user.email 2>/dev/null || bot_default_email; }

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

# _is_foreign_github_remote <url> — 0 when <url> is a github.com repo that is NOT the
# canonical garden journal remote (nor one of its migration aliases): the exact
# signature of the incident-2026-07-21 poison, a root origin a worker rewrote to a
# project/fork repo (endojs/endo-but-for-bots, kriscendobot/endo-but-for-bots, …).
# Note the garden's OWN repo now lives under the same owner as the product forks
# (kriscendobot/garden since the 2026-07-28 transfer), so this rests on the exact
# <owner>/<name> anchor in GARDEN_PRODUCTION_JOURNAL_REMOTE_RE: a sibling
# kriscendobot repo is still the poison, only kriscendobot/garden is not.
# Returns 1 for the garden remote itself AND for any NON-github url
# (a local throwaway test upstream, an operator's JOURNAL_REMOTE bare repo), so the
# refusal it drives targets ONLY a foreign github repo and can never reject a
# legitimate non-production journal remote. The github match is deliberately broad
# (host anywhere in the url, scp-ssh or https) so a fork in any transport is caught.
_is_foreign_github_remote() {
  local url="$1"
  [ -n "$url" ] || return 1
  printf '%s' "$url" | grep -qiE 'github\.com[:/]' || return 1   # not a github url → not the poison
  is_production_journal_remote "$url" && return 1                # the garden itself → fine
  return 0                                                       # a foreign github repo → the poison
}

# _reheal_root_origin <url> — re-assert the canonical garden origin on the ROOT
# checkout when a worker has REWRITTEN it to a project/fork repo (incident
# 2026-07-21: a worker misused the deployed root as an endo-but-for-bots project
# working tree and left remote.origin.url pointing at the fork, which — because
# linked worktrees share repo config — poisoned journal_remote for every FRESH
# doer clone). Called ONLY with a URL already accepted as the journal remote, and
# ONLY acts when the current root origin is a FOREIGN github repo (the poison
# signature, _is_foreign_github_remote). It can therefore only ever move a poisoned
# fork origin BACK to the resolved garden remote, never disturb a legitimate origin
# (including a local test upstream). Best-effort and idempotent; every git error
# swallowed so a caller under set -e is safe. This ends the recurrence at the source
# so later ticks stop having to fall through the refusal.
_reheal_root_origin() {
  local url="$1" cur
  [ -n "$url" ] || return 0
  cur="$(git -C "$GARDEN_ROOT" config --get remote.origin.url 2>/dev/null || true)"
  _is_foreign_github_remote "$cur" || return 0
  git -C "$GARDEN_ROOT" remote set-url origin "$url" >/dev/null 2>&1 \
    && log "REPAIRED: root checkout $GARDEN_ROOT origin was '$cur' (a foreign github repo — a worker rewrote it to a project/fork); reset to '$url'" || true
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
  local url poisoned=0
  # --- structural refusal against a project/fork origin rewrite (incident 2026-07-21)
  # A worker misusing the deployed ROOT checkout as an endo-but-for-bots project
  # working tree rewrote remote.origin.url to the fork. Because linked worktrees
  # SHARE repo config, that rewrite poisoned the journal-worktree read below AND the
  # root-origin fallback AND (once resolved) the cache — so journal_remote handed a
  # FORK url to every FRESH doer clone, which then cloned the wrong repo (and the
  # push CAS silently targeted the fork). The durable fix, in the same shape as
  # guard_no_production_push_in_test: REFUSE any resolved journal remote whose url is
  # a FOREIGN github repo (_is_foreign_github_remote — a github.com repo that is not
  # the canonical garden repo or a migration alias of it), the exact poison
  # signature. A local throwaway test upstream or
  # an operator's JOURNAL_REMOTE bare repo is NOT github-shaped, so it flows through
  # untouched. A poisoned source is skipped with a loud REFUSED log (never cached,
  # never re-healed FROM); we fall through to a clean source and, from a non-shared
  # clean source, re-assert the correct root origin (_reheal_root_origin) so the
  # poison is repaired at the source. If EVERY source is poisoned we die loudly
  # naming the fix — never returning a fork url.
  if url="$(git -C "$jw" config --get remote.origin.url 2>/dev/null)" && [ -n "$url" ]; then
    if _is_foreign_github_remote "$url"; then
      poisoned=1
      log "REFUSED: journal worktree $jw origin is '$url', a foreign github repo (NOT $GARDEN_PRODUCTION_JOURNAL_REPO) — the root checkout's remote.origin.url appears rewritten to a project/fork repo; refusing to propagate it (would make fresh doer clones clone the wrong repo). Restore with: git -C \"$GARDEN_ROOT\" remote set-url origin $GARDEN_PRODUCTION_JOURNAL_URL"
    else
      _cache_journal_remote "$url"
      printf '%s\n' "$url"; return
    fi
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
    if _is_foreign_github_remote "$url"; then
      poisoned=1
      log "REFUSED: cached journal remote at $JOURNAL_REMOTE_CACHE is '$url', a foreign github repo (NOT $GARDEN_PRODUCTION_JOURNAL_REPO) — a poisoned root origin was previously cached; refusing. Clear it with: rm -f \"$JOURNAL_REMOTE_CACHE\""
    else
      log "WARN: journal worktree $jw yielded no origin; using cached journal remote $url (transient — config lock / worktree repair / deploy window)"
      _reheal_journal_worktree_origin "$url" "$jw"
      _reheal_root_origin "$url"
      printf '%s\n' "$url"; return
    fi
  fi
  if url="$(git -C "$GARDEN_ROOT" config --get remote.origin.url 2>/dev/null)" && [ -n "$url" ]; then
    if _is_foreign_github_remote "$url"; then
      poisoned=1
      log "REFUSED: $GARDEN_ROOT origin is '$url', a foreign github repo (NOT $GARDEN_PRODUCTION_JOURNAL_REPO) — the root checkout's origin appears rewritten to a project/fork repo; refusing to propagate it as the journal remote. Restore with: git -C \"$GARDEN_ROOT\" remote set-url origin $GARDEN_PRODUCTION_JOURNAL_URL"
    else
      log "WARN: journal worktree $jw yielded no origin; falling back to $GARDEN_ROOT origin $url"
      _cache_journal_remote "$url"
      _reheal_journal_worktree_origin "$url" "$jw"
      printf '%s\n' "$url"; return
    fi
  fi
  if url="$(_journal_remote_from_state_clones)" && [ -n "$url" ]; then
    if _is_foreign_github_remote "$url"; then
      poisoned=1
      log "REFUSED: per-instance clone origin under $GARDEN_STATE is '$url', a foreign github repo (NOT $GARDEN_PRODUCTION_JOURNAL_REPO) — refusing."
    else
      log "WARN: journal worktree $jw yielded no origin; falling back to a per-instance clone origin under $GARDEN_STATE ($url)"
      _cache_journal_remote "$url"
      _reheal_journal_worktree_origin "$url" "$jw"
      _reheal_root_origin "$url"
      printf '%s\n' "$url"; return
    fi
  fi
  # Every source that yielded a value was a foreign github repo: the root checkout's
  # origin was rewritten to a project/fork repo and the poison reached every
  # fallback (shared config + cache + clones). Die loudly rather than return a fork
  # url — a fork url would make fresh doer clones clone the wrong repo and the push
  # CAS target the fork. Name the exact repair.
  if [ "$poisoned" = 1 ]; then
    die "journal remote UNRESOLVABLE: every source that yielded a value was a foreign github repo (a project/fork, NOT $GARDEN_PRODUCTION_JOURNAL_REPO). The root checkout's remote.origin.url was rewritten by a worker misusing the deployed root as a project working tree. Refusing to return a fork url. Restore with: git -C \"$GARDEN_ROOT\" remote set-url origin $GARDEN_PRODUCTION_JOURNAL_URL   then clear the poisoned cache: rm -f \"$JOURNAL_REMOTE_CACHE\""
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

# --- git gc lock liveness (sysop `maintain` op + root-repo-guard escalation) --
# git's `gc.pid` lock (in a repo's common git dir) records "<pid> <hostname>". When a
# gc dies without releasing it, the stale lock makes every later `git gc` fail at lock
# acquisition ("gc is already running ... pid N (use --force if not)"). Breaking that
# lock is only safe once the recorded holder is confirmed dead — otherwise we clobber a
# running gc. These two helpers, shared by sysop.sh's synchronous precheck and
# root-repo-guard.sh's authorized escalation, tell a STALE lock from a live one WITHOUT
# ever passing `git gc --force` (which ignores liveness).

# read_gc_lock <gitdir> — echo "<pid> <host>" from <gitdir>/gc.pid, empty if absent.
read_gc_lock() {
  local f="${1:-}/gc.pid" pid host
  [ -f "$f" ] || return 0
  read -r pid host _ < "$f" 2>/dev/null || return 0
  printf '%s %s\n' "${pid:-}" "${host:-}"
}

# gc_lock_holder_alive <pid> — true (0) ONLY when <pid> is a LIVE git gc/repack process
# (a real gc whose lock must be respected). False (1) when the pid is absent/unparseable,
# dead, or alive-but-not-a-git-process (a recycled pid whose original gc is long gone —
# the trigger case). A test seam GARDEN_GC_HOLDER_LIVE_CMD, when set, is the authority
# (run as `$CMD <pid>`; its rc is the answer), so a harness drives all three states with
# no real process games. On this single-user fleet `kill -0` is a reliable liveness probe.
gc_lock_holder_alive() {
  local pid="${1:-}"
  if [ -n "${GARDEN_GC_HOLDER_LIVE_CMD:-}" ]; then
    "$GARDEN_GC_HOLDER_LIVE_CMD" "$pid"; return $?
  fi
  case "$pid" in ''|*[!0-9]*) return 1 ;; esac           # no/garbled pid → not a live holder
  kill -0 "$pid" 2>/dev/null || return 1                 # dead → stale → safe to unlock
  local cmd=""
  if [ -r "/proc/$pid/cmdline" ]; then
    cmd="$(tr '\0' ' ' < "/proc/$pid/cmdline" 2>/dev/null || true)"
  elif command -v ps >/dev/null 2>&1; then
    cmd="$(ps -o args= -p "$pid" 2>/dev/null || true)"
  fi
  case "$cmd" in
    *git*gc*|*git*repack*|*git-gc*|*git-repack*) return 0 ;;  # a real gc → respect the lock
    *) return 1 ;;                                            # recycled/unrelated pid → safe
  esac
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

# Remove git's own lockfiles left behind when a git child is killed while
# updating this clone. clone_lock protects the entire clone critical section,
# so any such lockfile found while it is held cannot belong to a live fleet git
# operation. Keep the set deliberately narrow: only git's standard top-level
# locks plus ref locks are recoverable here.
_sweep_stale_git_locks() {
  local dir="$1" gitdir="$1/.git" lock removed=0
  [ -d "$gitdir" ] || return 0

  for lock in index.lock HEAD.lock config.lock packed-refs.lock ORIG_HEAD.lock; do
    if [ -e "$gitdir/$lock" ]; then
      rm -f -- "$gitdir/$lock"
      removed=1
    fi
  done
  if [ -d "$gitdir/refs" ]; then
    while IFS= read -r -d '' lock; do
      rm -f -- "$lock"
      removed=1
    done < <(find "$gitdir/refs" -type f -name '*.lock' -print0)
  fi
  [ "$removed" -eq 0 ] || log "swept stale git lockfile(s) in $gitdir"
}

# Ensure a single-branch journal clone exists at $1 and is identity-pinned. The
# clone + config write is serialized so concurrent producers don't race a cold
# `git clone` into the same dir or collide on `.git/config`.
# clone_is_corrupt <dir> -- a cheap local health probe for a present journal
# clone. A checkout can retain a `.git` directory while its origin tracking ref
# points at a missing object, so merely testing for `.git` is not enough. gc.log
# is also an explicit poison marker: git leaves it after a failed maintenance
# run and may refuse future repacks until it is removed. Re-cloning is safer than
# trying to reason about the rest of that object database.
clone_is_corrupt() {
  local dir="$1"
  [ -e "$dir/.git/gc.log" ] && return 0
  git -C "$dir" rev-parse -q --verify "refs/remotes/origin/$JOURNAL_BRANCH^{commit}" >/dev/null 2>&1 || return 0
  return 1
}

# reclone_clone <dir> <remote> -- replace a missing, partial, or corrupt clone
# through a sibling temporary directory. The caller holds clone_lock, so the
# remove/clone/rename sequence cannot race another producer using this clone.
# The temp is a sibling (same parent, thus same filesystem) so the rename is
# atomic: the destination only ever appears fully cloned or not at all, never
# half-populated, so an interrupted clone leaves only a discardable temp behind.
reclone_clone() {
  local dir="$1" remote="$2" tmp
  rm -rf "$dir"
  mkdir -p "$(dirname "$dir")"
  tmp="${dir}.tmp.$$"
  rm -rf "$tmp"
  if git clone -q --single-branch --branch "$JOURNAL_BRANCH" "$remote" "$tmp"; then
    mv "$tmp" "$dir" || { rm -rf "$tmp"; die "atomic rename of fresh clone $tmp -> $dir failed"; }
  else
    rm -rf "$tmp"
    die "clone of $remote ($JOURNAL_BRANCH) into $dir failed"
  fi
}

ensure_clone() {
  local dir="$1" remote; remote="$(journal_remote)"
  clone_lock "$dir"
  if [ ! -d "$dir/.git" ]; then
    # A destination that exists but lacks .git is a POISONED PARTIAL CLONE: a
    # prior `git clone` was interrupted (SIGKILL at TimeoutStop, a sync_clone
    # reset aborted mid-flight, a disk hiccup) and left $dir populated without a
    # repo. `git clone` refuses a non-empty destination, so a naive retry would
    # `die` here on EVERY tick forever (observed: 145 identical [unblock] FATALs
    # over ~12h). Self-heal by re-cloning through reclone_clone, which clears the
    # poisoned dir and lands the fresh clone via an atomic sibling-temp rename so
    # a future interruption can NEVER re-wedge us; we hold clone_lock "$dir"
    # throughout, so no concurrent producer races the same destination.
    if [ -e "$dir" ]; then
      log "WARN: $dir exists without .git (poisoned partial clone); self-healing by re-cloning"
    fi
    reclone_clone "$dir" "$remote"
  elif clone_is_corrupt "$dir"; then
    log "WARN: $dir has a corrupt clone; self-healing by re-cloning"
    reclone_clone "$dir" "$remote"
  fi
  _sweep_stale_git_locks "$dir"
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

# Canonical UPSTREAM-GONE signature set — the failures that do NOT self-resolve.
# A deleted/renamed fork (or a host whose credentials lost access to it) fails a
# fetch with a message that OVERLAPS the offline set: GitHub-over-SSH answers a
# missing repo with "ERROR: Repository not found." followed by "fatal: Could not
# read from remote repository.", and that second line is an offline signature. Any
# caller that classifies offline FIRST therefore reads a dead upstream as weather
# and retries it silently forever. Test THIS set first; it is deliberately narrow,
# matching only wordings GitHub/git emit for a repo that is absent or forbidden.
: "${GARDEN_UPSTREAM_GONE_SIGNATURES:=Repository not found|remote: Not Found|HTTP 404|The requested URL returned error: 404|repository .* (does not exist|not found)|does not appear to be a git repository|Permission denied \(publickey\)|You do not have permission|access denied}"

# Classify captured git-fetch stderr ($1) as a connectivity/DNS outage rather
# than a real repository error. These are the transient, self-resolving failures
# a tick should skip over (EX_TEMPFAIL) instead of dying on. Returns 0 if the
# text matches a known outage signature, 1 otherwise. Case-insensitive (-i) so a
# signature classifies regardless of how the producing tool cased it.
_fetch_stderr_is_offline() {
  printf '%s' "$1" | grep -qiE "$GARDEN_OFFLINE_SIGNATURES"
}

# Local repository corruption is distinct from a transient transport outage: a
# retry against the same clone will deterministically fail, but a fresh clone
# can recover a bad remote-tracking ref or damaged object database. Keep this
# set separate from GARDEN_OFFLINE_SIGNATURES so an outage never causes an
# unnecessary re-clone, and corruption never gets silently skipped as offline.
# Matched case-insensitively for the same cross-version diagnostic variance as
# the offline classifier above. `invalid sha1 pointer` / `bad ref for` / `broken
# ref` / `invalid HEAD` / `does not point to a valid object` cover a damaged
# REF/reflog specifically — both the garden-cleric item-7 remote-tracking case
# (refs/remotes/origin/journal2 = the null sha 0000…0000 left by an interrupted
# ref update) AND the repo-watcher local-ref case (a zero-byte loose
# refs/heads/journal2 shadowing a valid packed-refs entry, with bad
# .git/logs/{HEAD,refs/…} reflogs): fetch aborts `fatal: bad object refs/…` /
# `bad ref for …` / `did not send all necessary objects`, and `git fsck` reports
# `invalid sha1 pointer 0000...0000` / `invalid HEAD`. Either shape re-clones.
#
# A second cleric-item-7 shape observed later was a damaged OBJECT DB, not just a
# ref: a stale `.git/gc.log` blocked every repack and gc, so fetch's implicit
# maintenance failed with `fatal: failed to run repack` and git refused to gc
# (`warning: … Please correct the root cause and remove .git/gc.log`). That state
# emits NO `bad object` line on its own, so without `failed to run repack` /
# `gc\.log` in the set it slips past the classifier and crash-loops the unit. The
# re-clone subsumes removing gc.log. `unable to read` is kept generic (not just
# tree/sha1/object) to catch any `unable to read <path>` the object DB throws;
# the offline classifier runs FIRST, so a transport `Could not read from remote`
# is claimed as offline before this set ever sees it.
: "${GARDEN_CORRUPT_SIGNATURES:=bad object|invalid sha1 pointer|bad ref for|broken ref|invalid HEAD|does not point to a valid object|did not send all necessary objects|unable to read|object file .* is empty|loose object .* is corrupt|packfile .* cannot be accessed|invalid index-pack output|did not receive expected object|failed to run repack|gc\.log|fsck}"

_fetch_stderr_is_corrupt() {
  printf '%s' "$1" | grep -qiE "$GARDEN_CORRUPT_SIGNATURES"
}

# Print the first matching corruption signature for an operator-useful repair
# log. This deliberately shares the classifier's source of truth.
_fetch_stderr_corrupt_signature() {
  printf '%s\n' "$1" | grep -ioEm1 "$GARDEN_CORRUPT_SIGNATURES" || true
}

# Classify captured git-fetch stderr ($1) as a GONE/FORBIDDEN upstream — the
# non-self-resolving class the offline set would otherwise swallow (see above).
# Returns 0 on a match, 1 otherwise. Case-insensitive, same rationale.
_fetch_stderr_is_upstream_gone() {
  printf '%s' "$1" | grep -qiE "$GARDEN_UPSTREAM_GONE_SIGNATURES"
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
#   * GitHub PRIMARY quota exhaustion fails after one attempt: unlike a secondary
#     throttle, it cannot recover before the hourly reset.
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
#
# When GitHub is overloaded it serves an HTML error page (a 5xx gateway / overload
# / maintenance / rate-limit page) instead of JSON; `gh`'s JSON decoder then emits
# `invalid character '<' looking for beginning of value` with NO HTTP-status word,
# so without the signature below it is misclassified DEFINITIVE and crashes the
# caller (observed: garden-mirror-closer exit 1 on Agoric/agoric-sdk#11031 at
# 2026-07-12 06:28:21). An HTML body is a server-side transient page, so absorbing
# it under the bounded retry preserves "never guess a state": if GitHub keeps
# returning HTML past GARDEN_GH_API_ATTEMPTS the call still fails loud (nonzero,
# empty) rather than guessing. gh-api set ONLY (a Go-decoder string, never git's).
: "${GARDEN_TRANSIENT_GH_API_SIGNATURES:=HTTP 5[0-9][0-9]|HTTP 429|rate limit|secondary rate|abuse detection|i/o timeout|dial tcp|context deadline exceeded|net/http: TLS handshake timeout|no such host|server misbehaving|\bEOF\b|invalid character .<. looking for beginning of value|${GARDEN_OFFLINE_SIGNATURES}}"

# GitHub's PRIMARY hourly quota refusal. This is deliberately narrower than the
# transient signature set above: secondary-rate-limit / abuse throttles and HTTP
# 429 can clear inside the bounded retry window, while this refusal cannot clear
# until the account's primary quota resets. Matching the provider-quota predicate
# shape keeps callers from re-deriving this distinction from a generic "rate limit"
# substring. The failing response itself is the source of truth; do not spend an
# extra, equally-doomed `gh api rate_limit` call merely to learn the reset time.
: "${GARDEN_GH_PRIMARY_RATE_LIMIT_SIGNATURES:=API rate limit exceeded for user([[:space:]]+ID)?|x-ratelimit-remaining:[[:space:]]*0}"

# is_gh_primary_rate_limit_text <text> — 0 only for GitHub primary quota
# exhaustion, 1 for secondary/abuse throttling, HTTP 429, and other failures.
is_gh_primary_rate_limit_text() {
  grep -qiE "$GARDEN_GH_PRIMARY_RATE_LIMIT_SIGNATURES" <<<"${1:-}"
}

# Classify captured gh stderr ($1) as a transient (self-resolving) gh-api failure:
# returns 0 on a transient signature, 1 on a definitive one. Case-insensitive.
# Feed grep directly: `printf | grep -q` lets grep close the pipe at the first
# match, then a large stderr blob makes printf hit EPIPE; under pipefail that turns
# the successful match into a false definitive result (and emits a broken-pipe
# diagnostic). A here-string has no producer process that can fail this way.
_gh_api_stderr_is_transient() {
  grep -qiE "$GARDEN_TRANSIENT_GH_API_SIGNATURES" <<<"$1"
}

# gh_api_retry <gh-api-args…> — run `gh api <args…>` with bounded transient retry.
# Prints captured stdout and returns 0 ONLY on a clean success; returns the gh
# rc with empty stdout on a definitive error (no retry) or after the transient
# retries are exhausted. See the block comment above for the full contract.
gh_api_retry() {
  local attempt=1 out rc errf stderr label gh_bin a
  # The gh binary is "${GARDEN_GH:-gh}" — the same test seam gh_pr_view_retry and
  # ci-wait-merge.sh use to inject a stub, so a handler's GraphQL/REST read can be
  # exercised hermetically (e.g. mirror-closer-test.sh's large-PR 422 case) without
  # PATH/command-hash games. Unset in production → the fleet's pinned `gh` wrapper.
  gh_bin="${GARDEN_GH:-gh}"
  # A human-readable label for the logs: the first arg that looks like an API
  # path/query (has a `/` or `?`), so `--paginate` / `-X GET` / `--jq` flags do
  # not become the label. The API path always precedes any `--jq` in our callers.
  # Default to the first positional (e.g. `graphql`), never the literal "gh api":
  # every log line already prefixes "gh api $label", so "gh api" here doubled it
  # into "gh api gh api failed".
  label="${1:-gh api}"
  for a in "$@"; do case "$a" in */*|*\?*) label="$a"; break;; esac; done
  errf="$(mktemp 2>/dev/null || printf '%s' "${TMPDIR:-/tmp}/gh_api_retry.$$")"
  while :; do
    # Capture stdout (the payload) and stderr (the diagnostic) separately. The
    # `if` keeps a non-zero gh from tripping the caller's `set -e` before $rc is
    # read; gh's stderr goes to a temp file so the returned stdout stays clean.
    if out="$("$gh_bin" api "$@" 2>"$errf")"; then rc=0; else rc=$?; fi
    if [ "$rc" -eq 0 ]; then
      rm -f "$errf"
      printf '%s' "$out"
      return 0
    fi
    stderr="$(cat "$errf" 2>/dev/null || true)"
    # The primary hourly quota cannot recover inside this millisecond-scale retry
    # budget. Fail immediately and let the caller freeze/degrade the tick.
    if is_gh_primary_rate_limit_text "$stderr"; then
      log "WARN: gh api $label RATE LIMITED by GitHub primary quota (rc=$rc); not retrying: ${stderr:-<no stderr>}"
      rm -f "$errf"
      return "$rc"
    fi
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
# guesses a state. Secondary/abuse throttling and HTTP 429 ARE retried here;
# GitHub primary quota exhaustion is recognized separately and fails after one
# attempt because this budget cannot outwait its hourly reset. The gh binary is
# "${GARDEN_GH:-gh}" (the same test seam
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
    # As above, a primary hourly quota refusal is not a useful retry candidate.
    if is_gh_primary_rate_limit_text "$stderr"; then
      log "WARN: $label RATE LIMITED by GitHub primary quota (rc=$rc); not retrying: ${stderr:-<no stderr>}"
      rm -f "$errf"
      return "$rc"
    fi
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

# EXPLICIT-CAP subset of the transient signatures: the first-person Claude Code
# session/usage-cap wordings ("You've hit your session limit …", "usage limit
# reached", the "resets H:MMam (UTC)" clause). These are definitive statements the
# CLI prints about ITS OWN quota state, not ambient error text a setup script might
# echo, so they are trustworthy on CONTENT alone — gardener.sh exempts them from
# the GARDEN_MIN_PLAUSIBLE_OVERRUN_SECS floor. The floor's premise ("a genuine cap
# cannot trip in a couple of seconds") is empirically FALSE for these: a cap
# rejection is one fast API round trip — on 2026-07-17T00:43:48Z a real cap hit
# died rc=1 after 2s with "You've hit your session limit · resets 2am (UTC)"
# (capture blob ac1a1d97f4) and was misclassified a deterministic defect twice,
# killing a review job and a press claim until the reaper's TTL. The AMBIGUOUS
# overload-shaped alternatives (overloaded / 429 / 5xx / api error / connection
# drops — the 2026-07-03 sub-2s echo batch the floor was built for) are NOT in
# this subset and keep the floor. Matched case-insensitively.
: "${GARDEN_EXPLICIT_CAP_SIGNATURES:=hit your (session|usage) limit|(session|usage|5-hour) limit (reached|reset)|resets [0-9].*\(utc\)}"

# Classify a failed `claude -p`'s combined output ($1) as carrying an EXPLICIT
# session/usage-cap statement (returns 0) — transient by content, regardless of
# how fast the handler died. Callers use this to bypass elapsed-plausibility
# heuristics; it is a SUBSET refinement of is_transient_claude_signature, never a
# replacement (anything matching this also matches the transient set).
is_explicit_cap_signature() {
  printf '%s' "$1" | grep -qiE "$GARDEN_EXPLICIT_CAP_SIGNATURES"
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
# every cycle, so the reaper's `<!-- garden-reaped: N -->` doom counter escalates it
# as doom after GARDEN_REAP_DOOM_THRESHOLD cycles, rather than spamming a
# kind:error on every single requeue.
is_handler_timeout_rc() {
  case "$1" in
    124) return 0 ;;
    *) return 1 ;;
  esac
}

# Classify a handler exit code ($1) as an ENVIRONMENTAL failure: the handler could
# not run because its ENVIRONMENT was broken — the agent CLI was absent from PATH
# and from every known install location (die_environmental, common.sh § agent-CLI
# resolution), or a tick lost connectivity (GARDEN_OFFLINE_RC). Returns 0 for
# GARDEN_ENV_RC / GARDEN_OFFLINE_RC (both EX_TEMPFAIL 75 by default), 1 otherwise.
#
# This is the THIRD capture-content-INDEPENDENT transient class, alongside the
# signal-kills (is_external_kill_rc) and the wall-clock timeout
# (is_handler_timeout_rc), and for the same reason: nothing about the CLAIMED JOB
# caused it, so it must never be escalated as a defect in the job that happened to
# be claimed at that moment (the ps23 outage — an in-place `npm install -g` that
# unlinked /usr/local/bin/claude for a few seconds `die`d rc=1 with a diagnostic in
# the capture, which read as a real, job-specific failure). Capture content is
# irrelevant precisely BECAUSE die_environmental writes a diagnostic: the whole
# point is that a well-explained environmental failure is still not a job defect.
# is_transient_empty_failure already covers the EMPTY-capture case for the same
# code; this covers it regardless of output.
is_environmental_rc() {
  case "$1" in
    "${GARDEN_ENV_RC:-75}"|"${GARDEN_OFFLINE_RC:-75}") return 0 ;;
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
# than be deferred to the reaper's multi-hour doom cycle. Mirrors the
# signal/offline discrimination in self-heal-run.sh.
is_transient_empty_failure() {
  case "$1" in
    143|130|137|"${GARDEN_OFFLINE_RC:-75}") return 0 ;;
    *) return 1 ;;
  esac
}

# reap_process_group <pgid> [grace-secs] — terminate a completed handler's
# process group, including any non-detaching children it left behind. gardener.sh
# creates a fresh group for every claim and invokes this for every outcome.
# Refuse unsafe targets so a caller defect can never broaden the signal scope.
#
# Kept here with the other spine helpers. The Mystic migration must not remove it:
# gardener.sh invokes this independently of the selected worker kind.
reap_process_group() {
  local pgid="${1:-}" grace="${2:-5}" waited=0 self_pgid
  case "$pgid" in ''|*[!0-9]*) return 0 ;; esac
  [ "$pgid" -gt 1 ] 2>/dev/null || return 0
  [ "$pgid" = "$$" ] && return 0
  self_pgid="$(ps -o pgid= -p "$$" 2>/dev/null | tr -dc '0-9')"
  [ -n "$self_pgid" ] && [ "$pgid" = "$self_pgid" ] && return 0
  kill -0 -"$pgid" 2>/dev/null || return 0
  kill -TERM -"$pgid" 2>/dev/null || true
  while [ "$waited" -lt "$grace" ]; do
    kill -0 -"$pgid" 2>/dev/null || return 0
    sleep 1
    waited=$((waited + 1))
  done
  kill -KILL -"$pgid" 2>/dev/null || true
  return 0
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

# Marker the reaper stamps into a requeued job body to count requeue cycles. It
# is an HTML comment so it is invisible in rendered Markdown, and it survives both
# the claim-block strip (it lives in the body, above the trailing claim block) and
# a re-claim (claim-job appends its stamp BELOW the body).
#
# It lives HERE, beside the other cycle-marker regexes (REAP_NOW_MARKER_RE,
# DEADLINE_OVERRUN_MARKER_RE, PRODUCTIVE_MARKER_RE, OUTAGE_MARKER_RE), rather than
# in reaper.sh, because the reaper is no longer its only reader: promote-plan.sh
# CLEARS this whole marker family when it promotes a parked job back into todo/.
# One spelling, sourced by both, so a format change cannot half-land.
REAP_MARKER_RE='^<!-- garden-reaped: [0-9][0-9]* -->$'

# reap_count <jobfile> — the reaper's requeue-cycle count carried on a job, read
# from its `<!-- garden-reaped: N -->` marker (the marker reaper.sh writes; format
# REAP_MARKER_RE). Echoes N, or 0 when the marker is absent (a first-pass job the
# reaper has never requeued) or the file is missing. Extraction mirrors reaper.sh
# exactly (same sed, same `tail -1` defensiveness — clean_body keeps only one
# marker, but the reaper tails so we do too). READ-ONLY: this inspects the marker
# the reaper already maintains; it never writes, advances, or CAS-races it. Used by
# the gardener's transient-handler-failure note so a job dying the SAME transient
# way every cycle is greppable in the journal NOW, not only after the reaper's
# ~5×TTL doom threshold fires (~5h).
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
# GARDEN_REAP_DOOM_THRESHOLD (default 5) cycles before the reaper's doom
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
# -->` doom counter. The hint only PROMOTES a claim into the reaper's stale set
# early (reaper.sh § detect the stale set); the claim then flows through the SAME
# requeue + doom path, so a job that is SIGTERM'd every cycle (a genuinely wedged
# fetch — the risk gardener.sh flags) still escalates to the maintainer as doom
# after GARDEN_REAP_DOOM_THRESHOLD cycles rather than requeueing forever. The
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
# budget. Requeuing it the full GARDEN_REAP_DOOM_THRESHOLD (5) cycles before the
# reaper surfaces it burns ~5×the handler budget of gardener wall-clock for a verdict
# that a single deadline hit already proves. So the gardener stamps a per-job COUNTER
# here, and the reaper escalates a job carrying it to DOOM after the much lower
# GARDEN_REAP_OVERRUN_THRESHOLD (1) instead — after the FIRST deterministic overrun.
# A productive wall-hit (a per-job worktree HEAD advanced — the sanctioned resume
# treadmill that hits its wall by design) is exempt: the reaper RESETS this counter on
# a productive cycle, so only a wall-hit that made NO progress counts toward doom.
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
# and, once the counter reaches GARDEN_REAP_OVERRUN_THRESHOLD, dooms it early
# instead of burning the full GARDEN_REAP_DOOM_THRESHOLD cycles. Bounded CAS retry
# reusing sync_clone/commit_and_push; returns 0 once landed (or the claim is already
# gone), non-zero only if it could not land (caller falls back to the TTL requeue).
# Run in a SUBSHELL from a long-lived caller: sync_clone `exit`s on a connectivity
# blip, which a subshell contains. Mirrors stamp_reap_now_hint's contract.
#
# The optional third arg is a short REASON woven into the commit message so the
# git log distinguishes the two callers that stamp this same counter: a handler
# that hit its OWN wall-clock bound (rc=124 at the wall — the default reason) and
# the elapsed-constancy path, which confirms a DETERMINISTIC overrun from a
# near-constant elapsed across requeue cycles and reuses this early-doom counter
# so the reaper dooms after GARDEN_REAP_OVERRUN_THRESHOLD rather than the full
# doom threshold. The MARKER is identical either way (the reaper only knows the
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
# The reaper counts requeue cycles (`<!-- garden-reaped: N -->`) and DOOMS a job
# after GARDEN_REAP_DOOM_THRESHOLD cycles on the assumption that a handler which
# is requeued that many times "fails every time". But a long builder on the
# SANCTIONED RESUME TREADMILL — push green commits each cycle, then exit WITHOUT the
# completion signal before the handler wall, and RESUME on the next claim — trips the
# SAME counter even though EVERY cycle lands real progress. xs2rust-endor-build-stage3
# was false-doomed exactly this way (2026-07-03): its tracked HEAD advanced across
# the "failing" cycles, yet the counter climbed to the threshold and it was dropped.
#
# The fix: a cycle in which the handler made REAL PROGRESS (a per-job worktree HEAD
# advanced — it committed / pushed work) is PRODUCTIVE and must NOT count toward
# doom. The gardener DETECTS progress (it owns the worktree locally; see gardener.sh
# job_worktree_heads/job_cycle_productive around the handler call) and stamps THIS
# marker on its still-in-doin claim; the reaper READS it and RESETS the reap-count
# rather than incrementing, so only cycles with NO progress accumulate toward the
# drop. A genuinely-failing job (no commits, hard error every cycle) never earns the
# marker and still dooms at the threshold.
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
# land it on the board, so the reaper RESETS the doom counter for this cycle instead
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

# --- outage-cycle hint (the sustained-outage doom-pause) --------------------
#
# A job's handler can transient-fail purely because the WHOLE FLEET is in a
# correlated outage — a Claude quota/usage cut, an API-overload storm — that has
# nothing to do with THIS job's content. Left alone, GARDEN_REAP_DOOM_THRESHOLD
# such cycles doom an otherwise-healthy job (park it held, page the maintainer)
# even though every failure was environmental and self-resolving — the 2026-07-01
# storm that doomed a dozen unrelated jobs, and the case this marker exists to
# prevent.
#
# The discriminator is the shared FLEET BRAKE: a per-job defect fails while its
# peers succeed; a fleet-wide outage makes MANY handlers fail at once, which is
# exactly the correlated-transient DENSITY the brake already measures. So when a
# gardener transient-fails AND fleet_brake_engaged is true (the same predicate that
# PAUSES claiming), it stamps THIS marker on its still-in-doin claim; the reaper
# READS it and PAUSES the doom counter for that cycle — HOLDS it steady, neither
# incrementing toward the threshold nor resetting it — so cycles that failed only
# because the fleet was down do not accrue toward doom, while a job that still
# fails once the outage clears dooms on its own (non-outage) cycles.
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
# the board, so the reaper PAUSES the doom counter for this cycle. Idempotent (a
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

# --- the cycle-marker family, cleared on every plan-side transition ----------
#
# The five markers above (reap-count, deadline-overrun, and the per-cycle reap-now /
# productive-cycle / outage-cycle hints) are the reaper's and the gardener's running
# account of ONE job's failure history. They are meaningful only while the job is
# cycling through todo -> doin -> requeue; a job that reaches jobs/plan/ has stopped
# cycling, and its counters are stale the moment it is parked.
#
# Carrying them into (or out of) plan/ is what made a doomed job inescapable: at
# GARDEN_REAP_OVERRUN_THRESHOLD=1 a body still carrying `<!-- garden-deadline-overrun:
# N -->` re-dooms on its FIRST evaluation, so promotion is a no-op the job can never
# escape (the 07-26 endo-sturdyref-agent-surface-build-gauntlet park). promote-plan.sh
# closed the PROMOTION half; post-plan.sh closes the PARKING half, so a producer that
# re-parks a live job body cannot smuggle a stale counter into plan/ to begin with; and
# annotate-plan.sh closes the ANNOTATION half, the third write into a parked body —
# it appends producer-supplied note text, so a producer piping a live job body as a
# note would otherwise re-introduce the family behind both of the other strips. And
# proxy.sh's blocked-job park closes the fourth: it lifts a LIVE board file straight
# into plan/, so it carries not only the family but the trailing `---`/`claim:` block
# a doin/ file ends with — hence cut_claim_block below, this section's companion.
# All four use these helpers rather than re-spelling the family, so a marker-format change
# — or a SIXTH marker — lands in one place and cannot half-apply.

# CYCLE_MARKER_RE — the alternation matching any one cycle marker line. A single
# spelling of "the family", so no caller enumerates the members itself.
CYCLE_MARKER_RE="$REAP_MARKER_RE|$DEADLINE_OVERRUN_MARKER_RE|$REAP_NOW_MARKER_RE|$PRODUCTIVE_MARKER_RE|$OUTAGE_MARKER_RE"

# strip_cycle_markers — drop every cycle-marker line from a job body (stdin -> stdout).
# Idempotent by construction: a body with no markers passes through byte-identical, and
# a second pass over a stripped body is a no-op. Everything else — including a body's
# own `---` rules and any HTML comment that is not a cycle marker — is preserved.
strip_cycle_markers() {
  grep -Ev "$CYCLE_MARKER_RE" \
    || true   # grep exits 1 on an empty result; an empty body is not an error here
}

# cycle_marker_summary <file> — a compact, greppable record of which cycle markers
# <file> carries, for the provenance a strip leaves behind. Prints `none` when the
# body carries no markers (the common non-doom case), else a comma-joined list like
# `reaped=4,deadline-overrun=2,reap-now`.
cycle_marker_summary() {
  local f="$1" out="" n
  n="$(reap_count "$f")";             [ "$n" -gt 0 ] && out="${out:+$out,}reaped=$n"
  n="$(deadline_overrun_count "$f")"; [ "$n" -gt 0 ] && out="${out:+$out,}deadline-overrun=$n"
  if has_reap_now_hint "$f";         then out="${out:+$out,}reap-now"; fi
  if has_productive_cycle_hint "$f"; then out="${out:+$out,}productive-cycle"; fi
  if has_outage_cycle_hint "$f";     then out="${out:+$out,}outage-cycle"; fi
  printf '%s\n' "${out:-none}"
}

# cut_claim_block <file> — print the job body with the trailing `---`/`claim:` block
# and any trailing blank lines removed. The block is anchored on the `---` line
# IMMEDIATELY followed by `claim:` (the shape claim-job.sh appends), and only the LAST
# such pair is the cut point — so a body that itself contains a `---` rule is preserved
# intact. With no claim block the body comes back unchanged (never blindly truncated at
# a stray `---`). Same anchor as reaper.sh's clean_body and the stamp_*_hint inserters.
#
# The companion of strip_cycle_markers for the FOURTH plan-side writer: proxy.sh's
# blocked-job park lifts a LIVE board file, and a jobs/doin/ file carries the claim
# block claim-job.sh appended. promote-plan.sh's strip_frontmatter removes only the
# LEADING plan block, so a claim block parked verbatim rides all the way back into
# todo/ when the blocker clears — a claim record for a run that already ended, reading
# as live provenance to every consumer that greps for it.
cut_claim_block() {
  awk '
    { line[NR] = $0 }
    END {
      cut = 0
      for (i = 1; i < NR; i++) if (line[i] == "---" && line[i+1] == "claim:") cut = i
      end = (cut > 0) ? cut - 1 : NR
      while (end > 0 && line[end] ~ /^[ \t]*$/) end--   # trim trailing blank lines
      for (i = 1; i <= end; i++) print line[i]
    }
  ' "$1"
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
  local dir="$1" rc corrupt_sig
  clone_lock "$dir"
  _sweep_stale_git_locks "$dir"
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
    # A corrupt LOCAL clone cannot recover by retrying unchanged. Replace it
    # through ensure_clone's atomic sibling-temp clone path, while retaining the
    # clone lock held by this sync. This branch is deliberately reached once: a
    # corruption signature from the fresh clone is an upstream problem, not a
    # reason to spin a re-clone loop.
    if _fetch_stderr_is_corrupt "$GARDEN_FETCH_STDERR" || [ -e "$dir/.git/gc.log" ]; then
      corrupt_sig="$(_fetch_stderr_corrupt_signature "$GARDEN_FETCH_STDERR")"
      log "WARN: $dir corrupt (${corrupt_sig:-stale gc.log}); self-healing by re-cloning"
      rm -rf "$dir"
      # ensure_clone re-enters the inherited lock in a subshell and closes only
      # that subshell's fd, so this sync_clone invocation remains serialized.
      ( ensure_clone "$dir" )
      if journal_fetch "$dir"; then rc=0; else rc=$?; fi
      if [ "$rc" -ne 0 ]; then
        if [ "$rc" -eq 124 ] || [ "$rc" -eq 137 ] || _fetch_stderr_is_offline "$GARDEN_FETCH_STDERR"; then
          log "offline; skipping tick (rc=$GARDEN_OFFLINE_RC)"
          exit "$GARDEN_OFFLINE_RC"
        fi
        die "fetch failed in $dir after re-cloning corrupt journal clone"
      fi
      log "REPAIRED: re-cloned corrupt journal clone $dir (signature: ${corrupt_sig:-stale gc.log})"
    else
      die "fetch failed in $dir after bounded retries"
    fi
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

# --- test-context production-push guard (incident 2026-07-11) -----------------
#
# _in_test_context — 0 (in a test) when the positive sentinel GARDEN_TEST=1 is set,
# or (secondary heuristic) GARDEN_STATE lives under a `.garden-test` throwaway root,
# or the ENTRYPOINT script itself lives under a `test/`/`tests/` tree. The heuristics
# are deliberately tight: `.garden-test` matches only the path the harness uses, never
# a real deployment's `.garden-state`, and the entrypoint check reads $0 (the script
# the process was started with), not the cwd — so a gardener working in a project
# checkout that merely CONTAINS a tests/ directory is never mistaken for a test.
#
# The entrypoint heuristic is the self-arming half (incident 2026-07-28): a test run
# DIRECTLY — not through a harness that exports GARDEN_TEST — used to be invisible to
# this guard, which is exactly how tests/checks/test_identity_drift_guard.sh pushed
# three synthetic drift reports onto production journal2. Nothing under a test tree
# may ever push to the production journal, so recognizing the entrypoint closes that
# shape for every test at once rather than one forgotten export at a time.
_in_test_context() {
  [ "${GARDEN_TEST:-0}" = 1 ] && return 0
  case "${GARDEN_STATE:-}" in
    */.garden-test|*/.garden-test/*) return 0 ;;
  esac
  case "${0:-}" in
    */test/*|*/tests/*) return 0 ;;
  esac
  return 1
}

# is_production_journal_remote <url> — 0 when <url> is the canonical production
# journal remote (github.com/<GARDEN_PRODUCTION_JOURNAL_REPO> or a migration alias,
# any transport form). Empty → 1.
is_production_journal_remote() {
  local url="$1"
  [ -n "$url" ] || return 1
  printf '%s' "$url" | grep -qiE "$GARDEN_PRODUCTION_JOURNAL_REMOTE_RE"
}

# _journal_push_target <dir> — the remote URL a `git push origin` in <dir> will
# actually contact: the clone's own origin.url, falling back to the resolved
# journal_remote when the clone has no origin yet.
_journal_push_target() {
  local dir="$1" url
  url="$(git -C "$dir" config --get remote.origin.url 2>/dev/null || true)"
  [ -n "$url" ] || url="$(journal_remote 2>/dev/null || true)"
  printf '%s' "$url"
}

# guard_no_production_push_in_test <dir> — the structural refusal. In a test context,
# die loudly if the push target for <dir> resolves to the production journal remote,
# so a test can NEVER push to production `journal2`. A no-op outside a test context
# and for any throwaway origin, so production runs are unaffected.
guard_no_production_push_in_test() {
  local dir="$1" url
  _in_test_context || return 0
  url="$(_journal_push_target "$dir")"
  if is_production_journal_remote "$url"; then
    die "REFUSING production-journal push from a TEST context (GARDEN_TEST=${GARDEN_TEST:-0} GARDEN_STATE=${GARDEN_STATE:-}): target '$url' is the real $GARDEN_PRODUCTION_JOURNAL_REPO journal — point JOURNAL_REMOTE / GARDEN_PRODUCER_CLONE at a throwaway bare repo (guard: harden-test-journal-push, incident 2026-07-11)"
  fi
  return 0
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
  # Structural refusal: a test context must never push to production journal2.
  guard_no_production_push_in_test "$dir"
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
#   reachable on the shared remote. Naming the SHA in a committed file is NOT
#   enough — the text mentions the blob, nothing points AT it, so the push leaves
#   it behind and the responder gets an un-inspectable SHA (the 2026-08-01
#   unreachable-transcript defect). Two durable options, in order of preference:
#     1. Commit the CONTENT itself as a tracked, content-addressed file (the SHA
#        as the filename) and push it the normal CAS way. The blob is then in the
#        pushed tree, so `git push origin HEAD:journal2` carries it and a plain
#        fetch resolves the SHA anywhere. This is what report-error.sh does
#        (`inboxes/<host>/captures/<sha>`, alongside the inbox section that names
#        it) and is the default for any capture that escalates off-host.
#     2. Anchor the loose blob under a ref and push that ref, when you want the
#        capture available before/without a committed escalation:
#          anchor_blob "$sha" "captures/$(basename ...)" "$dir"   # see below
#        Weaker: `refs/captures/*` is outside the default refspec, so an ordinary
#        `git fetch` does NOT retrieve it — the responder must ask for it by name.
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
  # Same structural refusal as commit_and_push: never push a capture ref to production.
  guard_no_production_push_in_test "$dir"
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

# The GAUNTLET category sits ALONGSIDE the lifecycle (like plan/, index/, orch/)
# and is NEVER claimed or reaped. Each entry `jobs/gauntlet/<g>.md` is a gauntlet
# RECORD: a per-PR run of the clean → panel → fix-loop → un-draft chain, decomposed
# into claim-sized STAGE jobs (`<g>-clean`, `<g>-panel-<k>`, `<g>-fix-<k>`,
# `<g>-undraft`) that the deterministic gauntlet.sh driver posts ONE at a time,
# advancing the record against each stage's completion marker. The record carries
# the PR identity, the panel/fix loop counter, its give-up bound, and the stage
# currently in flight; the driver writes tada/<g> when the PR un-drafts (or halts
# on a stage failure / non-convergence). This is the per-PR analog of orchestrate.sh
# over jobs/orch/ — same "deterministic leader-only watcher over a record outside the
# claim lifecycle" shape, with a loop orchestrate.sh's fixed child list cannot express.
# See scripts/jobs/gauntlet.sh and designs/staged-gauntlet.md.
JOBS_GAUNTLET="jobs/gauntlet"

# List job basenames in a lifecycle dir, sorted, excluding .gitkeep.
list_jobs() {
  local dir="$1" sub="$2"
  ls -1 "$dir/$sub" 2>/dev/null | grep -v -x '.gitkeep' || true
}

# Per-schedule carry-forward mailbox (relative to a journal clone root). A
# recurring schedule dispatches each tick as a fresh short-lived doer with a
# TIMESTAMPED base (<prefix>-YYYYMMDD-HHMMSS) whose inbox is destroyed at
# completion, so a sub-job's completion report addressed to the tick that spawned
# it can never reach a live inbox. But the SCHEDULE itself has a durable,
# timestamp-free identity: its file stem. deadmail.sh deposits such a carried
# report here keyed by that stem; scheduler.sh drains it into the schedule's NEXT
# dispatched tick body, so the report reaches the true reader deterministically
# instead of via a generic-gardener restate-and-hope. Kept OUT of schedules/ so
# the scheduler's `list_jobs … schedules` iteration never mistakes it for a
# schedule file. The argument is the schedule name (with or without .md).
schedule_carry_forward_dir() { printf 'carry-forward/%s\n' "${1%.md}"; }

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
# designer job and a builder job both run on Opus without the poster having to
# name a model explicitly. Empty if absent.
plan_role() { plan_field "$1" role; }

# --- host capability requirements -------------------------------------------
#
# A job's optional `requires:` header is a comma-separated set of opaque,
# lowercase capability tokens (for example `requires: aws`).  It is deliberately
# separate from authorization headers such as identity_switch_authorized: true:
# a requirement describes a fact the host can currently satisfy; it never grants
# a permission.  Unknown tokens fail closed, which makes adding a new requirement
# safe before every host has learned its probe.
job_requirements() { # <job-file> — one normalized token per line
  local raw token
  raw="$(plan_field "$1" requires)"
  [ -n "$raw" ] || return 0
  IFS=',' read -r -a _job_requirements <<< "$raw"
  for token in "${_job_requirements[@]}"; do
    token="$(printf '%s' "$token" | tr -d '[:space:]')"
    [ -n "$token" ] || continue
    printf '%s\n' "$token"
  done
}

job_requirements_valid() { # <job-file>
  local token
  while IFS= read -r token; do
    [[ "$token" =~ ^[a-z][a-z0-9-]*$ ]] || return 1
  done < <(job_requirements "$1")
}

# The cache is intentionally host-local, never journal state: journal2 is public
# and publishing that a named host holds an AWS credential would be useful
# targeting metadata.  A cache is keyed by boot id, so a reboot re-probes without
# any operator cleanup.  The post-claim check below requests `fresh`, protecting
# against a key/session expiring after a cached claim-time verdict.
: "${GARDEN_CAPABILITY_CACHE_DIR:=$GARDEN_STATE/capabilities}"
: "${GARDEN_AWS_VERIFY:=$GARDEN_ROOT/scripts/aws/verify.sh}"

host_capability_probe() { # <token> — one authoritative, uncached probe
  case "$1" in
    aws) "$GARDEN_AWS_VERIFY" "$GARDEN_ROOT" >/dev/null 2>&1 ;;
    *) return 1 ;;
  esac
}

host_capability_available() { # <token> [fresh]
  local token="$1" fresh="${2:-cached}" boot marker
  case "$token" in aws) ;; *) return 1 ;; esac
  if [ "$fresh" != fresh ]; then
    boot="$(tr -dc 'A-Za-z0-9' < /proc/sys/kernel/random/boot_id 2>/dev/null || true)"
    marker="$GARDEN_CAPABILITY_CACHE_DIR/$token-${boot:-noboot}"
    case "$(cat "$marker" 2>/dev/null || true)" in yes) return 0 ;; no) return 1 ;; esac
  fi
  if host_capability_probe "$token"; then
    if [ "$fresh" != fresh ]; then mkdir -p "$GARDEN_CAPABILITY_CACHE_DIR" 2>/dev/null || true; printf 'yes\n' > "$marker" 2>/dev/null || true; fi
    return 0
  fi
  if [ "$fresh" != fresh ]; then mkdir -p "$GARDEN_CAPABILITY_CACHE_DIR" 2>/dev/null || true; printf 'no\n' > "$marker" 2>/dev/null || true; fi
  return 1
}

job_requirements_available() { # <job-file> [fresh] — shared claim/runtime predicate
  local file="$1" mode="${2:-cached}" token
  job_requirements_valid "$file" || return 1
  while IFS= read -r token; do host_capability_available "$token" "$mode" || return 1; done < <(job_requirements "$file")
}

job_requirements_missing() { # <job-file> [fresh] — comma-separated unavailable tokens
  local file="$1" mode="${2:-cached}" token out=""
  if ! job_requirements_valid "$file"; then printf 'invalid-requires-header\n'; return; fi
  while IFS= read -r token; do
    host_capability_available "$token" "$mode" || out="${out:+$out,}$token"
  done < <(job_requirements "$file")
  printf '%s\n' "$out"
}

# --- model routing table (data-driven, journal-backed) -----------------------
# WHICH backend/provider may claim a `model:`-pinned job, and each provider's
# fleet-default model, are DATA — not hardcoded case arms — so the set can change
# as models come and go WITHOUT a code edit or deploy. The table is a TSV with one
# row per provider: `<provider>\t<patterns>\t<default>` (see the header of
# model-routing-defaults.tsv for the column contract). Two records, precedence
# high→low, exactly mirroring the bot-identity pattern (§ bot identity):
#   1. a PER-INSTANCE journal override — `config/model-routing` on journal2, written
#      by set-model-routing.sh — read from whatever synced journal clone the caller
#      already has (a gardener's freshly-synced claim clone, the producer clone, or
#      the deployed journal worktree). A maintainer edit here needs NO deploy: the
#      next claim re-syncs the clone and picks it up.
#   2. the TRACKED canonical default — scripts/jobs/model-routing-defaults.tsv —
#      always present in a fresh checkout; the fail-safe when the journal file is
#      absent/unreadable, so a missing file NEVER opens the claim path to
#      mis-routing (it resolves to the sane seeded reality instead).
# A last-ditch inline built-in covers a checkout somehow missing even the tracked
# file. NO clone or network fetch happens here: the journal read is a plain
# working-tree file read of a clone some other part of the spine already synced.
: "${GARDEN_MODEL_ROUTING_PATH:=config/model-routing}"

_model_routing_defaults_file() { printf '%s\n' "$GARDEN_ROOT/scripts/jobs/model-routing-defaults.tsv"; }
_model_tier_inventory_file() {
  [ -n "${GARDEN_MODEL_TIER_INVENTORY_FILE:-}" ] && { printf '%s\n' "$GARDEN_MODEL_TIER_INVENTORY_FILE"; return; }
  local f="$GARDEN_ROOT/scripts/jobs/model-tier-inventory.tsv"
  [ -f "$f" ] || f="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/model-tier-inventory.tsv"
  printf '%s\n' "$f"
}

# model_dispatch_tier <provider> <concrete-id> -> mentat|mentor|minion|myrmidon.
# This is deliberately an exact, closed inventory: new provider models are
# unclassified until an explicit reviewed row is added, never silently eligible.
#
# The inventory carries an OPTIONAL fourth `pull_bytes` column (blank for models
# that are not locally provisioned; read by model_pull_bytes below for the sysop
# local-model op). Every reader of the first three columns therefore reads a fourth
# throwaway field so the added column can never be absorbed into `tier`
# (designs/sysop-local-model.md § Message and target resolution).
model_dispatch_tier() {
  local provider="$1" model="$2" p m tier _pb
  while IFS=$'\t' read -r p m tier _pb; do
    case "$p" in ''|\#*) continue;; esac
    [ "$p" = "$provider" ] && [ "$m" = "$model" ] && { printf '%s\n' "$tier"; return 0; }
  done < "$(_model_tier_inventory_file)"
  return 1
}

# model_pull_bytes <provider> <concrete-id> -> the reviewed download size in bytes
# from the inventory's optional fourth column, or non-zero when the row is absent or
# carries no size. Used ONLY by the sysop local-model provisioning op's disk
# preflight; a blank/missing value fails that op closed BEFORE any network or unit
# activity (designs/sysop-local-model.md § Preconditions and guards).
model_pull_bytes() {
  local provider="$1" model="$2" p m _tier pb
  while IFS=$'\t' read -r p m _tier pb; do
    case "$p" in ''|\#*) continue;; esac
    if [ "$p" = "$provider" ] && [ "$m" = "$model" ]; then
      [ -n "$pb" ] || return 1        # row present but no reviewed size → fail closed
      printf '%s\n' "$pb"; return 0
    fi
  done < "$(_model_tier_inventory_file)"
  return 1
}

model_is_claude() { [ "$(model_dispatch_tier anthropic "${1:-}" 2>/dev/null || true)" != "" ]; }

# job_tier returns the durable requested capability tier.  `model:` is deliberately
# a bounded migration surface: old queued jobs are read as their inventory tier,
# but no new producer writes it.  Unknown models fail closed.
job_tier() {
  local f="$1" tier model p m t
  tier="$(plan_field "$f" tier)"
  case "$tier" in mentat|mentor|minion|myrmidon) printf '%s\n' "$tier"; return 0;; esac
  [ -n "$tier" ] && return 1
  model="$(plan_field "$f" model)"; [ -n "$model" ] || return 1
  # Previous releases accepted these selector aliases. Keep this finite migration
  # vocabulary only; arbitrary provider/model strings never default.
  case "$model" in
    mentat|fable) printf '%s\n' mentat; return 0;;
    opus|terra|luna|frontier|mini) printf '%s\n' minion; return 0;;
    sonnet|haiku) printf '%s\n' myrmidon; return 0;;
  esac
  while IFS=$'\t' read -r p m t _pb; do
    case "$p" in ''|\#*) continue;; esac
    [ "$m" = "$model" ] && { printf '%s\n' "$t"; return 0; }
  done < "$(_model_tier_inventory_file)"
  return 1
}

# job_provider_constraint <job-file> -> a known provider, or non-zero when the
# optional leading `provider:` field is absent/unknown.  A provider constraint is
# a routing boundary for a tier-pinned canary, not a concrete model selector.
# Unknown combinations fail closed at the caller.
job_provider_constraint() {
  local provider
  provider="$(plan_field "$1" provider)"
  [ -n "$provider" ] || return 1
  case "$provider" in anthropic|openai|local|moonshot|fireworks) printf '%s\n' "$provider";; *) return 1;; esac
}

job_provider_is_constrained() { [ -n "$(plan_field "$1" provider)" ]; }

# tier_model_for_provider resolves a capability tier at claim/run time.  The
# durable job intent remains the tier when this inventory assignment changes.
tier_model_for_provider() {
  local wanted="$1" provider="$2" p m t _pb
  while IFS=$'\t' read -r p m t _pb; do
    case "$p" in ''|\#*) continue;; esac
    [ "$p" = "$provider" ] && [ "$t" = "$wanted" ] && _model_classify "$p" "$m" && { printf '%s\n' "$m"; return 0; }
  done < "$(_model_tier_inventory_file)"
  return 1
}

# automatic_route_body rewrites producer output to the current quota-posture
# capability ceiling. `tier:` is the durable intent; the concrete Codex pin is a
# deliberately redundant compatibility bridge while every deployed worker catches
# up with the fleet upgrade. Consumers MUST resolve from tier, not from this pin.
automatic_route_body() {
  awk '
    function trim(s){sub(/^[ \t]+/,"",s);sub(/[ \t]+$/, "",s);return s}
    { line[++n]=$0 }
    END {
      if (n && line[1]=="---") for(i=2;i<=n;i++) if(line[i]=="---"){end=i;break}
      if (!end) { print "---"; print "tier: mentor"; print "fallback-tier: minion"; print "dispatch: automatic"; print "---"; for(i=1;i<=n;i++) print line[i]; exit }
      seentier=seenfallback=seendispatch=0
      for(i=1;i<end;i++) {
        if(i==1){print line[i]; continue}
        if(line[i] ~ /^(model|fallback-model):[ \t]*/) continue
        if(line[i] ~ /^tier:[ \t]*/) { print "tier: mentor"; seentier=1; continue }
        if(line[i] ~ /^fallback-tier:[ \t]*/) { print "fallback-tier: minion"; seenfallback=1; continue }
        if(line[i] ~ /^dispatch:[ \t]*/) { print "dispatch: automatic"; seendispatch=1; continue }
        print line[i]
      }
      if (!seentier) print "tier: mentor"
      if (!seenfallback) print "fallback-tier: minion"
      if (!seendispatch) print "dispatch: automatic"
      for(i=end;i<=n;i++) print line[i]
    }'
}

# Echo the effective routing table (TSV text). Resolution order above; warns once
# per throttle window when it must drop to the inline built-in fallback.
_model_routing_table() {
  # 1. explicit override file (tests, and set-model-routing.sh's validator).
  if [ -n "${GARDEN_MODEL_ROUTING_FILE:-}" ] && [ -s "${GARDEN_MODEL_ROUTING_FILE}" ]; then
    cat "$GARDEN_MODEL_ROUTING_FILE" 2>/dev/null && return 0
  fi
  # 2. a per-instance journal override, read from any already-synced clone's working
  #    tree (no new clone/fetch — whichever the current caller kept fresh).
  local d f
  for d in "${GARDEN_GARDENER_CLONE:-}" "${GARDEN_PRODUCER_CLONE:-}" \
           "${GARDEN_LEADER_CLONE:-}" "$GARDEN_ROOT/journal"; do
    [ -n "$d" ] || continue
    f="$d/$GARDEN_MODEL_ROUTING_PATH"
    [ -s "$f" ] && { cat "$f" 2>/dev/null && return 0; }
  done
  # 3. the tracked canonical default (the durable seed + fail-safe fallback).
  f="$(_model_routing_defaults_file)"
  [ -s "$f" ] && { cat "$f" 2>/dev/null && return 0; }
  # 4. last-ditch inline built-in — the checkout is missing even the tracked file.
  alert_maintainer "model-routing-fallback" \
    "model-routing table unresolved (no journal override, no $f); using inline built-in — routing may be stale" 2>/dev/null || true
  printf '%s\n' \
    'anthropic	claude-fable-5 claude-opus-4-8 claude-opus-4-8[1m] claude-opus-4-7 claude-sonnet-5 claude-sonnet-4-6 claude-haiku-4-5 claude-haiku-4-5-20251001 claude-mythos-5	' \
    'openai	gpt-5.6-terra gpt-5.6-luna gpt-5.5 gpt-5.4-mini	gpt-5.6-terra' \
    'local	qwen3.6	qwen3.6' \
    'moonshot	kimi-k3' \
    'fireworks	fireworks/accounts/fireworks/models/glm-5p2	'
}

# _model_classify <provider> <model-id> -> rc 0 iff the id BELONGS to <provider>
# per the routing table (matches an include glob AND no exclude `!` glob). The
# deterministic backend-fit predicate: a claim-eligible check, no LLM.
_model_classify() {
  local provider="$1" id="$2" p pats def tok included=0 excluded=0
  [ -n "$id" ] || return 1
  # Routing configuration may select among reviewed entries, but it cannot make a
  # new id eligible. This closes the former wildcard/journal-override escape hatch.
  model_dispatch_tier "$provider" "$id" >/dev/null 2>&1 || return 1
  while IFS=$'\t' read -r p pats def; do
    case "$p" in ''|\#*) continue;; esac
    [ "$p" = "$provider" ] || continue
    for tok in $pats; do
      if [ "${tok#\!}" != "$tok" ]; then
        # shellcheck disable=SC2254  # $tok is an intentional glob pattern
        case "$id" in ${tok#\!}) excluded=1;; esac
      else
        # shellcheck disable=SC2254
        case "$id" in $tok) included=1;; esac
      fi
    done
  done < <(_model_routing_table)
  [ "$included" -eq 1 ] && [ "$excluded" -eq 0 ]
}

# model_routing_default <provider> -> the fleet-default model id for <provider>
# from the routing table (empty when the row has no default, e.g. anthropic).
model_routing_default() {
  local provider="$1" p pats def
  while IFS=$'\t' read -r p pats def; do
    case "$p" in ''|\#*) continue;; esac
    [ "$p" = "$provider" ] || continue
    printf '%s\n' "$def"; return 0
  done < <(_model_routing_table)
  return 1
}

# --- model selection (the canonical role->model policy) ----------------------
# The garden resolves the Claude model for a unit of work in two places that MUST
# agree: the scripted-fleet path (gardener-claude.sh, keyed on a job's `model:` /
# `role:` frontmatter) and the Agent-dispatch path (the liaison/steward passing a
# `model` tier per the dispatch contract). The two functions below are the
# EXECUTABLE single source of truth for the fleet path; skills/model-selection/
# SKILL.md is the human-readable canonical statement the Agent path follows, and
# it points back here so the two never drift.
#
# CLASSIFICATION vs BINDING. resolve_model_tier does two jobs: (a) BIND a short
# tier alias (opus, terra) to a concrete versioned id — that stays in code here, so
# a version bump is one edit; and (b) CLASSIFY a concrete id to its provider (is
# `qwen3.6` a local id?) — that is DATA, read from the journal-backed routing table
# via _model_classify, so the recognized-model set changes without a code edit.

# resolve_model_tier [provider] <tier-or-id> -> concrete model id (empty if the
# value is unknown/blank). Accepts the short tier names the maintainer uses in a
# job's `model:` field and on an Agent dispatch, and passes a concrete provider id
# through verbatim. The single place the short names bind to concrete ids, so a
# model-version bump is one edit here.
#
# Provider-scoped for the two backends the fleet drives (§ worker-kind registry):
# `resolve_model_tier anthropic <tier>` (the claude line) and
# `resolve_model_tier openai <tier>` (the codex line). The leading provider is
# OPTIONAL and defaults to `anthropic`, so every historical single-arg caller
# (`resolve_model_tier opus`) is unchanged. The codex ids and effort ladders come
# from designs/provider-model-catalog.md (re-verify live before a version bump).
resolve_model_tier() {
  local provider tier
  case "${1:-}" in
    anthropic|openai|local|moonshot|fireworks) provider="$1"; tier="${2:-}" ;;
    *)                      provider="anthropic"; tier="${1:-}" ;;
  esac
  case "$provider" in
    anthropic)
      case "$tier" in
        mentat|fable) printf '%s\n' "claude-fable-5" ;;  # manual-only tier -> concrete id
        opus)     printf '%s\n' "claude-opus-4-8" ;;
        opus5)    printf '%s\n' "claude-opus-5" ;;
        sonnet)   printf '%s\n' "claude-sonnet-4-6" ;;
        haiku)    printf '%s\n' "claude-haiku-4-5-20251001" ;;
        # a concrete id passes through iff the table CLASSIFIES it as anthropic.
        *)        if _model_classify anthropic "$tier"; then printf '%s\n' "$tier"; else printf '%s\n' ""; fi ;;
      esac ;;
    openai)
      case "$tier" in
        terra)    printf '%s\n' "gpt-5.6-terra" ;;   # effective codex default
        sol)      printf '%s\n' "gpt-5.6-sol" ;;
        luna)     printf '%s\n' "gpt-5.6-luna" ;;
        frontier) printf '%s\n' "gpt-5.5" ;;
        mini)     printf '%s\n' "gpt-5.4-mini" ;;
        # a concrete id passes through iff the table CLASSIFIES it as openai (the
        # table's `!gpt-oss*` exclude keeps a LOCAL served tag out of the openai id
        # space even though it matches gpt-*).
        *)        if _model_classify openai "$tier"; then printf '%s\n' "$tier"; else printf '%s\n' ""; fi ;;
      esac ;;
    local)
      # The LOCAL provider serves Ollama model TAGS. There are no short tier aliases
      # here now (the box serves a single family, currently qwen — see the routing
      # table); a concrete served tag passes through iff the table CLASSIFIES it as
      # local, so a gpt-oss:* tag is NO LONGER local (it matches no provider ->
      # unpinned) per "hermits only respond to qwen at this time."
      if _model_classify local "$tier"; then printf '%s\n' "$tier"; else printf '%s\n' ""; fi ;;
    moonshot)
      # Mystic is activation-only. An abbreviated `model: k3` must not silently
      # select it: only the concrete, explicit `model: kimi-k3` is valid.
      if [ "$tier" = "kimi-k3" ] && _model_classify moonshot "$tier"; then printf '%s\n' "$tier"; else printf '%s\n' ""; fi ;;
    fireworks)
      # The namespace is required, but the closed inventory still decides whether
      # this exact Fireworks selector is eligible.
      if [[ "$tier" == fireworks/* ]] && [ -n "${tier#fireworks/}" ] && _model_classify fireworks "$tier"; then printf '%s\n' "$tier"; else printf '%s\n' ""; fi ;;
    *) printf '%s\n' "" ;;
  esac
}

# role_default_model [kind] <role> -> the concrete model id that role runs on BY
# DEFAULT for the given worker kind (empty for a role with no policy, so the caller
# falls back to the fleet default). This is the canonical role->model map. The
# leading kind is OPTIONAL and defaults to `gardener`, so every historical single-arg
# caller (`role_default_model builder`) is unchanged.
#
# During the Moonshot-credit exhaustion period, automatic role defaults are
# minion/Codex. The Claude handler itself is manual-Fable-only, and Mystics have
# no default, so no role can implicitly select Kimi.
#
# Cleric (codex) side: designer/builder pin `gpt-5.6-terra`; mechanical roles use
# the corresponding economical tiers (`mini` or `frontier`). The effort distinction
# is carried by role_default_effort. An explicit per-job `model:` ALWAYS overrides
# this default — the caller applies this only when no `model:` field is present.
role_default_model() {
  local kind role
  case "${1:-}" in
    gardener|cleric|hermit|mystic|fireworker) kind="$1"; role="${2:-}" ;;
    *)                      kind="gardener"; role="${1:-}" ;;
  esac
  case "$kind" in
    gardener)
      # The gardener kind is ANTHROPIC. Every id here must be one `claude --model`
      # accepts: these rows returned `gpt-5.6-terra` (an OpenAI id) until
      # 2026-08-01, which the Claude CLI cannot run — latent because the tier
      # branch in gardener-claude.sh wins whenever a job carries `tier:`, and
      # automatic_route_body always stamps one. A role-only job reached it and
      # died. Mirrors the cleric branch's shape: heavy / mechanical / ops.
      case "$role" in
        designer|builder) printf '%s\n' "$(resolve_model_tier anthropic opus)" ;;
        cleaner|retcon|yarn-lock|journalist)
                  printf '%s\n' "$(resolve_model_tier anthropic haiku)" ;;
        weaver|conductor|pages-shepherd)
                  printf '%s\n' "$(resolve_model_tier anthropic sonnet)" ;;
        *)        printf '%s\n' "" ;;
      esac ;;
    cleric)
      case "$role" in
        designer) printf '%s\n' "$(resolve_model_tier openai terra)" ;;
        builder)  printf '%s\n' "$(resolve_model_tier openai terra)" ;;
        cleaner|retcon|yarn-lock|journalist)
                  printf '%s\n' "$(resolve_model_tier openai mini)" ;;
        weaver|conductor|pages-shepherd)
                  printf '%s\n' "$(resolve_model_tier openai frontier)" ;;
        *)        printf '%s\n' "" ;;
      esac ;;
    hermit)
      # The local codex-cleric. The box currently serves a single local family (qwen),
      # so every hermit role — including the heavier designer/builder — rides the
      # local fleet default from the routing table (model_routing_default local, e.g.
      # qwen3.6) rather than pinning a separate flagship tag that is not served. An
      # explicit per-job `model:` always overrides. The bid auction (guide §5) — not
      # this default — is what keeps a local arm OFF high-stakes build/design on main,
      # via the human-review-$ term; this default only sets the model a hermit uses IF
      # it wins such a job. When a box grows a distinct heavier local model, add it to
      # the routing table and pin the role here — a data edit plus (for the pin) one code line.
      case "$role" in
        designer|builder|cleaner|retcon|yarn-lock|journalist|weaver|conductor|pages-shepherd)
                  model_routing_default local ;;
        *)        printf '%s\n' "" ;;
      esac ;;
    mystic)
      # Kimi is explicitly disabled while Moonshot credits are exhausted.
      printf '%s\n' "" ;;
    fireworker)
      # Explicit model only.  There is no safe catalog default for a hosted,
      # changing Fireworks fleet.
      printf '%s\n' "" ;;
    *) printf '%s\n' "" ;;
  esac
}

# role_default_tier is the producer-facing counterpart of role_default_model.
# Automatic producers currently always request minion. The compatibility model pin
# above is never authoritative over this durable tier intent.
role_default_tier() { printf '%s\n' minion; }

# role_default_effort [kind] <role> -> the default thoughtfulness (reasoning-effort)
# level a role runs at for a race/pre-auction job that names no explicit `effort:`
# header (design §5): `high` for the design-heavy designer/builder roles, `medium`
# for everything else. Kind is accepted for symmetry with role_default_model and a
# future kind that wants a different ladder; both current kinds share this map. The
# level is on the unified thoughtfulness axis (catalog §3); each handler normalizes
# it down to its model's nearest supported level.
role_default_effort() {
  local role
  case "${1:-}" in
    gardener|cleric|hermit|mystic|fireworker) role="${2:-}" ;;
    *)                      role="${1:-}" ;;
  esac
  case "$role" in
    designer|builder) printf '%s\n' "high" ;;
    *)                printf '%s\n' "medium" ;;
  esac
}

# --- per-role default handler budget -----------------------------------------
#
# GARDEN_HANDLER_TIMEOUT (2400s / 40 min) is the right default for the ordinary
# job: read a PR, make an edit, push. It is NOT the right default for a BUILD,
# which routinely runs a full install + compile + test pass and blows through 40
# minutes by construction. Until 2026-08-01 the only remedy was a per-job
# `handler-timeout:` header the PRODUCER had to remember to stamp, with no
# auto-classifier — and the failure mode when they forgot was expensive and
# silent-ish: the handler is SIGTERM-killed at 2400s on EVERY requeue, makes no
# progress, and the reaper dooms it as a deterministic overrun after one cycle
# (ebfb-pr882-bootstrap-generators, rc=124 at elapsed=2401s, doomed to plan/
# with two maintainer notices; its re-post then carried handler-timeout: 7200).
#
# So the build roles now carry a LARGER DEFAULT. This is a default, not a cap: an
# explicit `handler-timeout:` header still wins in either direction, and the
# claim-scoping invariant (budget + KILL_AFTER < CLAIM_TTL) still clamps the
# result at the call sites.
#
# 7200s (2h) is not a guess — it is where the fleet had already converged by hand:
# of the jobs on the board carrying an explicit header, 16 said 7200, 11 said
# 10800, 1 said 14000. 7200 covers the common build and leaves headroom under the
# ~14339s claim ceiling for a genuinely heavy job (a cold `docker build`) to ask
# for more explicitly.
#
# GARDEN_BUILD_HANDLER_TIMEOUT is the knob; set it to GARDEN_HANDLER_TIMEOUT to
# retire the distinction entirely.
: "${GARDEN_BUILD_HANDLER_TIMEOUT:=7200}"

# role_default_handler_timeout <role> -> default handler budget in seconds for
# that role. Empty role, or a role with no build character, yields the fleet
# default. Kept beside role_default_model/effort so the three per-role policies
# stay visibly one family.
role_default_handler_timeout() {
  local role="${1:-}"
  case "$role" in
    builder|web-builder) printf '%s\n' "${GARDEN_BUILD_HANDLER_TIMEOUT:-7200}" ;;
    *)                   printf '%s\n' "${GARDEN_HANDLER_TIMEOUT:-2400}" ;;
  esac
}

# job_handler_budget_base <jobfile> -> the budget a job gets BEFORE any explicit
# `handler-timeout:` header is applied.
#
# SINGLE SOURCE OF TRUTH, DELIBERATELY. gardener.sh (which runs the handler under
# `timeout`) and reaper.sh (which decides when a claim is stale) must compute the
# SAME budget or the invariant breaks in the worst direction: a reaper that thinks
# the budget is 2400s while the gardener is running a 7200s build would requeue
# the base onto a SECOND gardener while the first still runs — duplicate concurrent
# execution on one worktree, the exact hole the claim-scoping invariant closes.
# Both call this; neither re-derives it.
job_handler_budget_base() {
  local jf="${1:-}" role=""
  [ -n "$jf" ] && [ -r "$jf" ] && role="$(plan_role "$jf" 2>/dev/null || true)"
  role_default_handler_timeout "$role"
}

# --- kimi-k3-takes-opus-work-with-opus-fallback ------------------------------
# The directive (kriskowal 2026-07-28): route some opus-exclusive work (builder)
# to kimi-k3 for evaluation, with an AUTOMATIC opus retry on failure. Opus's
# exclusive work is exactly what a mystic is barred from (job_eligible_for_kind),
# so honoring it means RELAXING that bar — but only behind the fallback that
# justifies it. Two knobs plus a pure body transform implement the whole thing;
# the eligibility relaxation (claim-job.sh) and the re-route (reaper.sh) read
# these. Design: designs/kimi-k3-takes-opus-work-with-opus-fallback.md.

# The per-instance journal flag that ARMS the relaxation. Absent/unreadable/not
# `on` reads as OFF (fail-safe: a missing file never opens the claim path), so
# landing this code is a no-op until a maintainer runs set-kimi-fallback.sh on.
: "${GARDEN_KIMI_FALLBACK_PATH:=config/kimi-takes-opus-work}"
# Genuine (non-outage, non-productive) failure cycles kimi is given before the
# reaper re-routes the job to the next fallback model. 1 = fall back on the first
# real failure; raise to give kimi more attempts. The reaper's existing
# productive/outage exemptions already keep progress and correlated transients
# from counting, so this counts only real failures.
: "${GARDEN_KIMI_FALLBACK_AFTER:=1}"

# kimi_fallback_enabled [clone-dir] — 0 (true) iff the relaxation is armed for this
# instance. Precedence mirrors the model-routing override read: an explicit env
# override (tests), then the flag file in a caller-named clone (the reaper passes its
# own $DIR, which it does not export), then any already-synced clone working tree (no
# new clone/fetch), else OFF. The value must be exactly `on` (case/space-insensitive).
kimi_fallback_enabled() {
  local v="" d f
  if [ -n "${GARDEN_KIMI_FALLBACK_ENABLED:-}" ]; then
    v="$GARDEN_KIMI_FALLBACK_ENABLED"
  else
    for d in "${1:-}" "${GARDEN_GARDENER_CLONE:-}" "${GARDEN_PRODUCER_CLONE:-}" \
             "${GARDEN_LEADER_CLONE:-}" "${GARDEN_REAPER_CLONE:-}" "$GARDEN_ROOT/journal"; do
      [ -n "$d" ] || continue
      f="$d/$GARDEN_KIMI_FALLBACK_PATH"
      [ -s "$f" ] && { v="$(head -1 "$f" 2>/dev/null || true)"; break; }
    done
  fi
  v="$(printf '%s' "$v" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')"
  [ "$v" = on ]
}

# reroute_job_model — compatibility-named reaper transform on stdin a job BODY.
# clean_body produces it). If the frontmatter pins `model:` to a burnable value
# AND carries a non-empty `fallback-model:` chain, ADVANCE the pin to the chain
# head, POP that head, and append the burned model to `model-burned:`; print the
# transformed body and return 0. Otherwise print the body UNCHANGED and return 1.
# Pure text transform — no journal, no network — so the reaper (the single
# requeue writer) can call it inline. The chain is comma- and/or space-separated;
# entries stay verbatim (a short tier like `opus` resolves downstream exactly as a
# hand-pinned model: does), so the re-routed job needs no new consumer: it now
# classifies to the fallback provider and that kind claims it, while the original
# provider's kind can no longer claim it (the ping-pong bound).
reroute_job_model() {
  awk '
    function trim(s){ gsub(/^[ \t]+|[ \t]+$/, "", s); return s }
    { line[NR]=$0 }
    END {
      # Find the leading frontmatter block: line 1 is "---", closed by the next "---".
      fm_end=0
      if (NR>=1 && line[1]=="---") {
        for (i=2;i<=NR;i++) if (line[i]=="---") { fm_end=i; break }
      }
      if (fm_end==0) { for (i=1;i<=NR;i++) print line[i]; exit 1 }  # no frontmatter -> no-op
      # Prefer durable tier:/fallback-tier:.  model fields remain migration-only.
      model=""; mi=0; chain=""; ci=0; burned=""; bi=0
      for (i=2;i<fm_end;i++) {
        l=line[i]
        if (l ~ /^tier:[ \t]*/)                { model=trim(substr(l, index(l,":")+1));  mi=i; tierkey=1 }
        else if (l ~ /^fallback-tier:[ \t]*/)  { chain=trim(substr(l, index(l,":")+1));  ci=i; fallbackkey=1 }
        else if (l ~ /^model:[ \t]*/ && !mi)   { model=trim(substr(l, index(l,":")+1));  mi=i }
        else if (l ~ /^fallback-model:[ \t]*/ && !ci) { chain=trim(substr(l, index(l,":")+1)); ci=i }
        else if (l ~ /^model-burned:[ \t]*/)    { burned=trim(substr(l, index(l,":")+1)); bi=i }
      }
      if (model=="" || chain=="") { for (i=1;i<=NR;i++) print line[i]; exit 1 }  # nothing to route
      # Split the chain on comma/space; head is the next model, tail is the remainder.
      n=split(chain, parts, /[ ,]+/)
      next_model=""; rest=""
      for (i=1;i<=n;i++) {
        if (parts[i]=="") continue
        if (next_model=="") next_model=parts[i]
        else rest=(rest==""?parts[i]:rest" "parts[i])
      }
      if (next_model=="") { for (i=1;i<=NR;i++) print line[i]; exit 1 }  # empty chain -> no-op
      # The reaper is automatic machinery.  A legacy Claude fallback must never
      # reintroduce an automatic Claude pin during the quota route.
      if (model=="mentor" && next_model=="mentat") next_model="minion"
      new_burned=(burned==""?model:burned" "model)
      # Emit, rewriting model:/fallback-model:/model-burned:. When model-burned:
      # was absent (bi==0) insert it immediately after the model: line so it lands
      # inside the frontmatter block.
      for (i=1;i<=NR;i++) {
        if (i==mi)      { print (tierkey ? "tier: " : "model: ") next_model; if (bi==0) print "model-burned: " new_burned }
        else if (i==ci) { print (fallbackkey ? "fallback-tier: " : "fallback-model: ") rest }
        else if (i==bi) { print "model-burned: " new_burned }
        else            { print line[i] }
      }
      exit 0
    }
  '
}

# --- orchestration-record metadata helpers ----------------------------------
# An orchestration record (jobs/orch/<base>.md) carries leading YAML frontmatter:
#   ---
#   order: serial | parallel           # sequencing of the children (default serial)
#   children: a b c                    # space-separated child job basenames, in order
#   on-child-failure: halt | continue  # policy when a child fails (default halt)
#   state: pending | running | done | halted   # managed by orchestrate.sh
#   child-<base>-reap-count: <N>      # watcher baseline at promotion
#   child-<base>-host: <host>         # first claimant; diagnostic only
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

# --- gauntlet-record metadata helpers ---------------------------------------
# A gauntlet record (jobs/gauntlet/<g>.md) carries leading YAML frontmatter:
#   ---
#   pr: https://github.com/<owner>/<repo>/pull/<N>
#   repo: <owner>/<repo>
#   pr_number: <N>
#   build_job: <build-base>            # provenance; empty for a run-the-gauntlet origin
#   kind: feature | probe              # a probe NEVER un-drafts
#   stage: clean | panel | fix | undraft | done | halted
#   iteration: <k>                     # the panel/fix loop counter (0 during clean)
#   max_iterations: 6                  # give-up bound for the loop
#   resumes: <n>                       # still-pending re-posts spent so far
#   max_resumes: 6                     # give-up bound for the still-pending re-post
#   current_child: <stage-job-base>    # the stage job currently in flight
#   state: pending | running | done | halted
#   created_by: <role>
#   created_at: <iso8601>
#   ---
# All read via plan_field (a leading-frontmatter scalar reader). Defaults mirror
# post-gauntlet.sh's own defaults so a hand-edited record still parses sanely.
gauntlet_field() { plan_field "$1" "$2"; }
gauntlet_kind() { local v; v="$(plan_field "$1" kind)"; printf '%s\n' "${v:-feature}"; }
gauntlet_stage() { local v; v="$(plan_field "$1" stage)"; printf '%s\n' "${v:-clean}"; }
gauntlet_iteration() { local v; v="$(plan_field "$1" iteration)"; printf '%s\n' "${v:-0}"; }
gauntlet_max_iterations() { local v; v="$(plan_field "$1" max_iterations)"; printf '%s\n' "${v:-6}"; }
# A record written before the resume bound existed carries neither field; both
# default so an in-flight gauntlet keeps advancing under the new bound.
gauntlet_resumes() { local v; v="$(plan_field "$1" resumes)"; printf '%s\n' "${v:-0}"; }
gauntlet_max_resumes() { local v; v="$(plan_field "$1" max_resumes)"; printf '%s\n' "${v:-6}"; }
gauntlet_current_child() { plan_field "$1" current_child; }
gauntlet_state() { local v; v="$(plan_field "$1" state)"; printf '%s\n' "${v:-pending}"; }
gauntlet_repo() { plan_field "$1" repo; }
gauntlet_pr_number() { plan_field "$1" pr_number; }
gauntlet_pr() { plan_field "$1" pr; }

# Did a job's tada REPORT declare that the job completed WITHOUT achieving its
# gated outcome? A job can reach tada/ (it finished, its worker exited cleanly)
# yet decline the very thing a downstream gate keys on — the canonical case is a
# conductor whose `merge` job correctly REFUSES to merge (CI red, base frozen,
# ferry-required) but still completes. Such a report carries an explicit failure
# marker so a dependent is NOT satisfied by the mere completion:
#   orchestration-failed: true|yes            (or: yes)
#   orchestration-status: fail…               (halted / failed / fail)
# Returns 0 when the marker is present, 1 otherwise. This is the SINGLE source of
# truth for "completed-but-declined", honored by BOTH deterministic serial
# primitives: the orchestrate watcher (a child that failed → on-child-failure
# policy) and the unblock watcher (a blocked_on predecessor that declined → do
# NOT promote; hold for the maintainer). Keep the two in lock-step by reading the
# same marker here rather than re-spelling the grep in each.
tada_failed() {
  grep -qiE '^orchestration-(status:[[:space:]]*fail|failed:[[:space:]]*(true|yes))' \
    "$1" 2>/dev/null
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
