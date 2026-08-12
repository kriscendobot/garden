#!/bin/bash
# reaper.sh — requeue stale claims (the `doin` watchdog pivoker lacks).
#
# Usage: reaper.sh
#
# Scans jobs/doin/ for claims older than GARDEN_CLAIM_TTL seconds and moves
# them back to jobs/todo/ (stripping the claim stamp), removes the matching
# work/<base> record, and best-effort removes any orphaned worktree named by
# that basename. A gardener that died mid-job thus releases its job back to
# the pool.
#
# Work RECOVERY (carrying the dead session forward, not just the job) is the
# handler's half of the contract: because the requeue keeps the SAME base, the
# fresh gardener that re-claims it derives the same deterministic Claude session
# id and `--resume`s the interrupted session's transcript when it is still on
# this host. See scripts/jobs/handlers/gardener-claude.sh § session continuity.
# The reaper itself stays a dumb requeue — it needs no session knowledge.
#
# Only jobs/doin/ is scanned. The jobs/plan/ category (parked work — gated on a
# go-ahead or deferred by priority) is never claimed, so it is never in flight and
# never reaped; parked jobs do not go stale.
#
# This is vigil's "idle-but-pending → trigger" decision retargeted from
# systemd unit state to claim-file age.
#
# THE REQUEUE MUST ACTUALLY LAND. The journal is under constant push contention
# (the bulletin loop, comment-watcher, schedulers, and every gardener push to
# origin/journal2 all the time). A reaper that attempts each requeue exactly once
# per tick loses that single CAS race on essentially every tick under steady
# contention, so a stale claim is requeued NEVER, not "next tick" — exactly the
# failure observed 2026-06-25 (three jobs stranded 15–19h, "lost a race; will
# retry next reaper tick" logged every tick, hand-requeued in the end). So this
# reaper:
#   1. RETRIES the requeue within the tick (a bounded sync→stage→commit→push loop
#      like post-job.sh), reusing the hardened commit_and_push (verify-after-push)
#      so a "succeeded but didn't land" push also retries — it concedes the first
#      race but not the tick.
#   2. BATCHES the tick's reaps into ONE commit+push, so N stale claims cost one
#      race, not N races each of which can be lost.
#   3. Strips ONLY the trailing claim block (anchored on the `---` that precedes
#      `claim:`), so a job body that itself contains a `---` (a Markdown rule or
#      embedded frontmatter) is not truncated.
#   4. Counts requeue cycles per job (a `<!-- garden-reaped: N -->` marker carried
#      in the body across cycles). A job whose handler fails every time would loop
#      forever; after GARDEN_REAP_DOOM_THRESHOLD cycles it is DOOMED: rather
#      than being dropped from the board, it is PARKED in jobs/plan/ under a held
#      `go-ahead` gate (no auto-promoter selects it) so the work survives and can be
#      resumed, and a maintainer notice is AMEND-OR-POST deduped by <job-base> +
#      <failure signature> (doom-notice.sh) so a restart that dooms dozens of
#      jobs does not flood the inbox with near-identical messages. See the doom
#      branch of the batch-requeue loop below and doom-notice.sh.
#      Two gardener-stamped exemptions keep the counter from dooming HEALTHY work:
#      a PRODUCTIVE cycle (a per-job worktree HEAD advanced) RESETS it, and a
#      SUSTAINED-OUTAGE cycle (the handler transient-failed while the shared fleet
#      brake was engaged — a fleet-wide quota/API storm, not a defect in this job)
#      PAUSES it (holds it steady). The outage exemption is what stops a correlated
#      outage from mass-dooming a dozen unrelated jobs (the 2026-07-01 incident);
#      see common.sh § outage-cycle hint and the has_outage_cycle_hint branch below.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
# reputation.sh (source-once guarded) supplies rep_resolve_arm/rep_work_class/
# rep_target/rep_arm_relpath, used ONLY by the best-effort kimi-fallback attribution
# event below. It never gates the requeue path.
# shellcheck source=reputation.sh
source "$HERE/reputation.sh"
GARDEN_TAG="reaper"

: "${GARDEN_CLAIM_TTL:=14400}"         # seconds a claim may sit in doin before reaping (4h; must match gardener.sh)
: "${GARDEN_FETCH_REAP_AGE:=120}"      # seconds a `git fetch` may run before it is killed
: "${GARDEN_FETCH_REAP_KILL_AFTER:=5}" # grace seconds after SIGTERM before the stuck-fetch janitor escalates to SIGKILL
: "${GARDEN_REAP_PUSH_ATTEMPTS:=50}"   # bounded retries for the batched requeue push (CAS contention)
: "${GARDEN_REAP_DOOM_THRESHOLD:=5}" # requeue cycles after which a job is surfaced as doom, not requeued
# STAGGER A BURST. A restart cycle can orphan dozens of claims within minutes of
# each other; they then cross the age floor together and, uncapped, ONE tick would
# dump the whole burst into todo/ at once — the pool re-claims them together and the
# herd re-forms (the 42-claims-in-5-minutes evidence, kriskowal 2026-07-28). So bound
# how many AGE-EXPIRED claims one tick requeues; the tick reaps the OLDEST this many
# and defers the rest to later ticks (oldest-first, nothing dropped — § 1b below).
# Default 8: at the 10-minute reaper cadence (garden-reaper.timer, OnCalendar=*:03/10)
# a 42-job backlog drains over ~6 ticks ≈ 1h — small waves the pool picks up spread
# out, versus one herd — while still clearing even a large backlog far inside the 4h
# GARDEN_CLAIM_TTL window so nothing lingers. This can ONLY ever DELAY a reap by whole
# ticks; it never reaps anything earlier than the age floor already required, so the
# single-owner-per-worktree invariant is untouched. Reap-now-hinted claims BYPASS it
# (they are known-dead and event-driven, not part of a TTL-synchronized burst).
: "${GARDEN_REAP_MAX_PER_TICK:=8}"     # max age-expired claims one tick requeues (reap-now claims are exempt)
# A job carrying the gardener's `<!-- garden-deadline-overrun: N -->` marker hit its
# OWN handler wall-clock budget (rc=124, elapsed≈handler budget) — a DETERMINISTIC
# overrun that will be killed identically on every requeue, so it is escalated to
# DOOM at this much LOWER threshold (default 1) rather than the full
# GARDEN_REAP_DOOM_THRESHOLD: a job that overruns its budget will overrun it again on
# every requeue, so ONE deadline hit is already conclusive — surfacing after the first
# (not the fifth) stops it from burning ~5×the budget of gardener wall-clock before the
# maintainer even hears about it. This case is safe to trip at 1 because a NON-defective
# long job on the sanctioned resume treadmill (which hits its wall by design) earns the
# PRODUCTIVE-cycle exemption below — a productive wall-hit RESETS this counter to 0 — so
# only a job that hits its wall AND makes NO progress accumulates toward doom here. A
# doomed job is not dropped: it is PARKED (held, resumable) with a maintainer notice,
# so a legitimately build-heavy job that simply needs a bigger budget is surfaced fast
# for a human to re-post with a larger `handler-timeout:` rather than churned silently.
# The gardener owns/increments the counter (common.sh § deadline-overrun); the reaper
# only reads it to decide the threshold.
: "${GARDEN_REAP_OVERRUN_THRESHOLD:=1}" # deadline-overrun cycles after which a wall-hitting job is surfaced as doom

# --- two-writers-in-one-worktree guard (data-corruption class) ----------------
#
# A claim is reapable only once its handler is GUARANTEED dead. The gardener bounds
# every handler at `timeout --signal=TERM --kill-after=GARDEN_HANDLER_KILL_AFTER
# GARDEN_HANDLER_TIMEOUT`, so a handler cannot outlive GARDEN_HANDLER_TIMEOUT +
# GARDEN_HANDLER_KILL_AFTER; the gardener's INVARIANT
# (GARDEN_HANDLER_TIMEOUT + GARDEN_HANDLER_KILL_AFTER < GARDEN_CLAIM_TTL) is what
# lets the reaper treat a claim past GARDEN_CLAIM_TTL as dead. But that invariant is
# CONFIG-FRAGILE: nothing stops GARDEN_CLAIM_TTL being set BELOW the handler wall
# (the reaper and the gardener read the knob independently, in separate processes).
# When it is, the reaper requeues a claim whose handler is STILL RUNNING — a fresh
# gardener re-claims the SAME base, re-enters the SAME persisted per-job worktree,
# and now TWO live handlers write one tree (the ~18-min-requeue-vs-40-min-wall
# corruption). So the reaper re-derives the invariant at reap time (reap_age_threshold
# below): it NEVER treats a claim as stale before the maximum lifetime its handler
# could hold has elapsed, whatever GARDEN_CLAIM_TTL says. These two knobs must match
# gardener.sh's defaults so the derived floor tracks the real handler wall.
: "${GARDEN_HANDLER_TIMEOUT:=2400}"    # must match gardener.sh: the default handler wall-clock budget
: "${GARDEN_HANDLER_KILL_AFTER:=60}"   # must match gardener.sh: grace before the handler's SIGKILL
: "${GARDEN_REAP_SAFETY_SLACK:=30}"    # extra seconds past the handler's max lifetime before its claim is reapable

# The requeue-cycle marker regex (REAP_MARKER_RE, `<!-- garden-reaped: N -->`) is
# defined in common.sh beside the rest of the cycle-marker family, because the
# reaper is no longer its only reader — promote-plan.sh clears the family on
# promotion. The reaper remains its only WRITER.

# --- durable doom-notice spool (un-surfaced-alert recovery) -----------------
#
# doom-notice.sh already retries its OWN push budget (GARDEN_POST_ATTEMPTS, 50)
# with backoff and `die`s LOUDLY when the maintainer inbox is genuinely
# unreachable (the journal is down, its clone is broken, or it never won a push
# race). Historically the reaper swallowed that die with `>/dev/null 2>&1` and only
# logged a bare "WARNING: could not surface …", then fell through and `break`ed out
# of the requeue loop — so the doom job stayed PARKED in jobs/plan/ (held) but the
# maintainer was NEVER told and the WARNING named no cause. A deterministically
# overrunning job (the 00:15:19 `xs2rust-…-boot-surface-remainder` tail) thus
# vanished from human view: the only signal it was stuck was permanently dropped.
#
# So the reaper no longer drops the alert. surface_doom() CAPTURES
# doom-notice.sh's stderr and names the cause in the WARNING (a lost push race, an
# unreachable clone, a bad key), and on failure it SPOOLS the notice to a durable
# directory. drain_doom_spool(), run at the top of every tick, re-attempts each
# spooled notice — so a transient inbox-unreachable window heals on a LATER tick
# instead of losing the notice forever. The spool file is keyed by the same
# <base>+<signature> dedup key doom-notice.sh uses, so a re-spool overwrites
# (idempotent) rather than accreting, and a successful delivery clears it.
: "${GARDEN_DOOM_SPOOL:=$GARDEN_STATE/reaper/doom-spool}"

# doom_key <base> <signature> — the deterministic dedup/filesystem key, computed
# the SAME way doom-notice.sh derives its maintainer-inbox filename, so the spool
# entry and the notice it recovers share one identity.
doom_key() {
  local key
  key="$(printf 'doomed-%s-%s' "$1" "$2" | tr -c 'A-Za-z0-9._-' '-')"
  printf '%s' "$key"
}

# spool_doom <base> <signature> <sender> <body> — persist an un-surfaced doom
# notice under GARDEN_DOOM_SPOOL so the next tick can re-drain it. Keyed by
# doom_key so a re-spool of the same job+condition overwrites the prior entry
# rather than accumulating duplicates. The small header carries everything
# drain_doom_spool needs to re-invoke doom-notice.sh; the body follows the
# first `---` line (the body itself may contain `---`, so the split is first-only).
spool_doom() {
  local base="$1" signature="$2" sender="$3" body="$4" key dest
  key="$(doom_key "$base" "$signature")"
  if ! mkdir -p "$GARDEN_DOOM_SPOOL" 2>/dev/null; then
    log "WARNING: cannot create doom spool dir '$GARDEN_DOOM_SPOOL'; doom alert for '$base' NOT durably recorded (will not survive this tick)"
    return 1
  fi
  dest="$GARDEN_DOOM_SPOOL/$key.md"
  {
    printf 'base: %s\n'       "$base"
    printf 'signature: %s\n'  "$signature"
    printf 'sender: %s\n'     "$sender"
    printf 'spooled_at: %s\n' "$(date -u +%FT%TZ)"
    printf -- '---\n'
    printf '%s\n' "$body"
  } > "$dest" 2>/dev/null \
    || { log "WARNING: could not write doom spool entry '$dest' for '$base'"; return 1; }
  return 0
}

# surface_doom <base> <signature> <sender> <body> — deliver ONE doom notice to
# the maintainer inbox via doom-notice.sh, CAPTURING its stderr so a failure is
# DIAGNOSABLE. On success, clear any spooled copy of the same notice and return 0.
# On failure, log the captured cause (the FATAL die line, else the last stderr line)
# AND spool the notice durably so the next tick re-drains it, then return 1 — the
# alert is never permanently swallowed.
surface_doom() {
  local base="$1" signature="$2" sender="$3" body="$4" key err cause
  key="$(doom_key "$base" "$signature")"
  err="$(mktemp "${TMPDIR:-/tmp}/reaper-doom-notice.XXXXXX" 2>/dev/null)" || err=""
  if printf '%s' "$body" | GARDEN_SENDER="$sender" \
       "$HERE/doom-notice.sh" "$base" "$signature" >/dev/null 2>"${err:-/dev/null}"; then
    [ -n "$err" ] && rm -f "$err"
    rm -f "$GARDEN_DOOM_SPOOL/$key.md" 2>/dev/null || true
    return 0
  fi
  cause=""
  if [ -n "$err" ]; then
    # Prefer the FATAL die line (the definitive cause); fall back to the last
    # non-blank line. Strip the leading `<N>` journald syslog-level prefix.
    cause="$(grep -aE 'FATAL' "$err" 2>/dev/null | tail -1)"
    [ -n "$cause" ] || cause="$(grep -avE '^[[:space:]]*$' "$err" 2>/dev/null | tail -1)"
    cause="$(printf '%s' "$cause" | sed 's/^<[0-9]>//')"
    rm -f "$err"
  fi
  [ -n "$cause" ] || cause="(doom-notice.sh failed; no stderr captured)"
  log "WARNING: could not surface doom job '$base' ($signature) to maintainer inbox: $cause — spooling to '$GARDEN_DOOM_SPOOL' for the next tick to re-drain"
  spool_doom "$base" "$signature" "$sender" "$body" || true
  return 1
}

# drain_doom_spool — at the top of every tick, re-attempt every spooled doom
# notice from a prior tick. A notice that now delivers is cleared from the spool
# (surface_doom rm's it on success); one that still fails stays for a later tick.
# Best-effort and independent of the reaper's own journal clone (doom-notice.sh
# operates on the producer clone), so it never blocks or aborts the requeue path.
drain_doom_spool() {
  local f base signature sender body
  [ -d "$GARDEN_DOOM_SPOOL" ] || return 0
  local entries=()
  local e; for e in "$GARDEN_DOOM_SPOOL"/*.md; do [ -e "$e" ] && entries+=("$e"); done
  [ "${#entries[@]}" -gt 0 ] || return 0
  log "draining ${#entries[@]} spooled doom notice(s) from a prior tick"
  for f in "${entries[@]}"; do
    [ -f "$f" ] || continue
    base="$(sed -n 's/^base: *//p' "$f" | head -1)"
    signature="$(sed -n 's/^signature: *//p' "$f" | head -1)"
    sender="$(sed -n 's/^sender: *//p' "$f" | head -1)"
    # Body is everything after the FIRST `---` line (the body may itself contain `---`).
    body="$(awk 'seen{print} /^---$/{if(!seen){seen=1}}' "$f")"
    if [ -z "$base" ] || [ -z "$signature" ]; then
      log "WARNING: malformed doom spool entry '$f' (missing base/signature); leaving in place for inspection"
      continue
    fi
    [ -n "$sender" ] || sender="reaper:$GARDEN"
    surface_doom "$base" "$signature" "$sender" "$body" || true
  done
}

# --- stuck-fetch janitor -----------------------------------------------------
#
# A journal fetch should finish in well under a minute; git has no default IO
# timeout, so a half-open connection left by a transient network blip can hang a
# `git fetch` FOREVER, and (since clones serialize behind an flock) a stuck fetch
# holds its clone lock and wedges every producer behind it — that is how one
# stale connection wedged the whole fleet for ~15 minutes (2026-06-25). The
# timeout wrapper in common.sh bounds NEW fetches; this janitor is the backstop
# that reaps any `git fetch` already running past GARDEN_FETCH_REAP_AGE seconds
# (one that started before this shipped, or somehow escaped its `timeout`), and
# surfaces a one-line anomaly so a stuck fetch self-heals in minutes.
#
# `ps -o etimes` is elapsed seconds since start; the `[g]it` bracket trick keeps
# this very grep out of its own match. The grep is only a cheap PREFILTER — a
# process is targeted only if `_is_git_fetch_cmd` then confirms git is the program
# word (not a process that merely MENTIONS "git fetch" in a long argument, e.g. a
# claude agent quoting a job spec). That precision matters doubly now that a match
# escalates to a whole-subtree SIGKILL: a false positive would nuke an innocent
# agent and its children, not just send it a survivable SIGTERM.
#
# Escalation matters: a `git fetch` hung on a half-open connection (or one whose
# transport child sits in an uninterruptible read) ignores the SIGTERM below and
# survives the janitor, keeping its clone lock and remaining in the cgroup as the
# leftover the NEXT reaper start reports. A bare `kill -TERM "$pid"` is therefore
# not enough, and a bare `kill -KILL "$pid"` is no better: SIGKILL does not
# propagate to children, so the actual transport child (git-remote-https /
# fetch-pack — where the socket read is wedged) is merely orphaned to init and
# keeps the connection. So we SIGKILL the whole fetch subtree, not just the parent.
# This mirrors the `timeout --kill-after` escalation that bounds NEW fetches
# (common.sh) and bounds handlers (gardener.sh): TERM, a short grace, then KILL.

# _is_git_fetch_cmd <command-line> — true iff the line is a real `git ... fetch`
# invocation: git (bare or path-suffixed) as the program word — under an optional
# `timeout <secs> [flags]` supervisor prefix — with `fetch` as a standalone
# argument. A process whose argv merely contains the substring "git fetch" inside
# one long argument (a claude agent quoting this very job spec) has a non-git
# program word and is rejected, so the loose substring match can never escalate
# against it.
_is_git_fetch_cmd() {
  # Word-split the command line; the journal-fetch forms this targets have no
  # space-bearing arguments, so plain splitting reconstructs the tokens.
  # shellcheck disable=SC2206
  local -a tok=($1)
  local i=0
  if [ "${tok[0]:-}" = "timeout" ]; then
    i=1                                   # skip `timeout` and its flags/duration operands
    while [ "$i" -lt "${#tok[@]}" ]; do
      case "${tok[$i]}" in
        -*|[0-9]*) i=$((i+1)) ;;          # --kill-after=…, --signal=…, 45, 45s
        *) break ;;
      esac
    done
  fi
  case "${tok[$i]:-}" in git|*/git) ;; *) return 1 ;; esac
  local j=$((i+1))
  while [ "$j" -lt "${#tok[@]}" ]; do
    [ "${tok[$j]}" = "fetch" ] && return 0
    j=$((j+1))
  done
  return 1
}

# _proc_descendants <pid> — print <pid> and every transitive descendant pid, one
# per line, from a single `ps` ppid snapshot. Captured BEFORE the SIGKILL grace,
# while the tree is still intact: once the parent dies, its children reparent to
# init and a walk rooted at the dead parent would no longer find them.
_proc_descendants() {
  # SC2009: pgrep -P is not transitive and absent on some hosts; walk ps's ppid map.
  # shellcheck disable=SC2009
  ps -eo pid=,ppid= 2>/dev/null | awk -v root="$1" '
    { ppid[$1] = $2 }
    END {
      n = 0; queue[n++] = root; seen[root] = 1; print root
      for (i = 0; i < n; i++) {
        cur = queue[i]
        for (p in ppid) if (ppid[p] == cur && !(p in seen)) {
          seen[p] = 1; queue[n++] = p; print p
        }
      }
    }'
}

# reap_age_threshold <doin-file> — echo the minimum claim age (seconds) at which
# this job's claim may be reaped. It is the LARGER of the configured
# GARDEN_CLAIM_TTL and the maximum lifetime the job's handler could hold: the
# effective handler budget + GARDEN_HANDLER_KILL_AFTER + GARDEN_REAP_SAFETY_SLACK.
# The effective budget is the DEFAULT GARDEN_HANDLER_TIMEOUT — the gardener runs a
# headerless job at that default regardless of GARDEN_CLAIM_TTL — unless the job
# carries a valid `handler-timeout:` header, which the gardener honors clamped to
# GARDEN_CLAIM_TTL - GARDEN_HANDLER_KILL_AFTER - 1. This
# re-derives the gardener's single-owner invariant at reap time so a GARDEN_CLAIM_TTL
# misconfigured below the handler wall can no longer requeue a still-live handler.
reap_age_threshold() {
  local f="$1" budget floor
  # The BASE is per-role, from the same helper gardener.sh uses
  # (common.sh job_handler_budget_base): a build role defaults to
  # GARDEN_BUILD_HANDLER_TIMEOUT, not the fleet default. If this diverged from the
  # gardener's view, the reaper would judge a live 7200s build stale at 2400s and
  # requeue the base onto a SECOND gardener while the first still runs.
  budget="$(applied_handler_budget "$f")"
  floor=$(( budget + GARDEN_HANDLER_KILL_AFTER + GARDEN_REAP_SAFETY_SLACK ))
  if [ "$GARDEN_CLAIM_TTL" -ge "$floor" ]; then printf '%s\n' "$GARDEN_CLAIM_TTL"; else printf '%s\n' "$floor"; fi
}

# _handler_alive_pids <base> — print the pids of any LIVE handler subtree working
# this base ON THIS HOST, one per line. <base> is the doin filename INCLUDING its
# `.md` suffix (list_jobs yields it that way). A running handler (and its `timeout`
# supervisor) is invoked with the job file `.../jobs/doin/<base>` as an argument, so
# any process whose argv carries that path token is part of the live handler subtree
# — a precise, handler-agnostic liveness probe (the leading `doin/` and the `.md`
# suffix anchor it so base `boom.md` does not match `xboom.md`/`boomer.md`). The
# reaper's OWN git/sed children take the same path as an argument, so the reaper
# process subtree is excluded. This can only see THIS host's processes; a claim on
# another host reports nothing here and is governed by reap_age_threshold's floor.
_handler_alive_pids() {
  local base="$1"
  local needle="jobs/doin/$base" self_tree pid cmd
  self_tree=" $(_proc_descendants $$ 2>/dev/null | tr '\n' ' ') "
  # SC2009: we need ps's args column (pgrep gives neither cmdline nor a substring match).
  # shellcheck disable=SC2009
  ps -eo pid=,args= 2>/dev/null | while read -r pid cmd; do
    [ -n "$pid" ] || continue
    case "$self_tree" in *" $pid "*) continue ;; esac   # never match the reaper's own subtree
    case "$cmd" in *"$needle"*) printf '%s\n' "$pid" ;; esac
  done
}

reap_stuck_fetches() {
  local killed=0 pid etimes cmd procs d
  local -a targets=()
  # SC2009: we need ps's etimes/args columns (pgrep gives neither), so grep ps.
  # shellcheck disable=SC2009
  procs="$(ps -eo pid=,etimes=,args= 2>/dev/null | grep -E '[g]it.* fetch' || true)"
  while read -r pid etimes cmd; do
    [ -n "$pid" ] || continue
    _is_git_fetch_cmd "$cmd" || continue
    if [ "$etimes" -ge "$GARDEN_FETCH_REAP_AGE" ]; then
      log "ANOMALY: killing stuck git fetch pid=$pid age=${etimes}s (>${GARDEN_FETCH_REAP_AGE}s): $cmd"
      kill -TERM "$pid" 2>/dev/null || true
      # Snapshot the whole subtree NOW, before the grace lets TERM tear it apart.
      while read -r d; do [ -n "$d" ] && targets+=("$d"); done < <(_proc_descendants "$pid")
      killed=$((killed+1))
    fi
  done <<< "$procs"
  if [ "$killed" -gt 0 ]; then
    # Give a SIGTERM-respecting fetch a brief grace to exit cleanly, then SIGKILL
    # the captured subtree unconditionally — survivors of the TERM and the orphaned
    # transport children alike — so a SIGTERM-ignoring fetch is actually reaped
    # rather than left in the cgroup for the next reaper start to report.
    sleep "$GARDEN_FETCH_REAP_KILL_AFTER"
    for d in "${targets[@]}"; do
      kill -KILL "$d" 2>/dev/null || true
    done
    log "stuck-fetch janitor killed $killed stuck fetch(es)"
  fi
  return 0
}

# --- scratch janitor ---------------------------------------------------------
#
# GC the dedicated job-scratch tree (GARDEN_SCRATCH; see common.sh scratch_dir/
# scratch_cleanup). A job is supposed to scratch_cleanup its own dir, but a job
# that dies mid-flight leaves it behind. This backstop removes $GARDEN_SCRATCH/*
# entries whose whole subtree has been UNTOUCHED for GARDEN_SCRATCH_GC_AGE hours
# (default 24): the mtime-quiescence test is the "no live owner" proxy, since a
# running job touches its scratch continuously. A quiescent entry that is still a
# registered git worktree is deregistered (git worktree remove --force) before
# its directory is removed, so no stale worktree admin entry is left behind.
GARDEN_SCRATCH_GC_AGE="${GARDEN_SCRATCH_GC_AGE:-24}"   # hours of quiescence before GC
gc_scratch() {
  [ -d "$GARDEN_SCRATCH" ] || return 0
  # LIVE-BASE protection. Per-job worktrees (gardener-wt-<base>,
  # project-wt-<base_safe>-*) deliberately PERSIST across a reaper requeue so a
  # resumed claim re-enters its in-flight work. During a long drain or quota
  # outage a requeued job sits in todo/ untouched past the quiescence window
  # while its worktree still holds uncommitted work — age alone must not reap
  # it. Protect every entry whose base is still live on the board
  # (todo|doin|plan), read from the reaper's already-synced clone; when the
  # clone is unavailable the protection set is empty and behavior is unchanged.
  local live_bases=() b sub name
  if [ -n "${DIR:-}" ] && [ -d "$DIR/jobs" ]; then
    for sub in todo doin plan; do
      while IFS= read -r b; do
        [ -n "$b" ] && live_bases+=("${b%.md}")
      done < <(list_jobs "$DIR" "jobs/$sub")
    done
  fi
  local removed=0 entry
  for entry in "$GARDEN_SCRATCH"/*; do
    [ -e "$entry" ] || continue                         # empty-glob guard
    name="$(basename "$entry")"
    for b in "${live_bases[@]}"; do
      case "$name" in
        "gardener-wt-$b"|"project-wt-${b//[^A-Za-z0-9._-]/-}"-*) continue 2 ;;
      esac
    done
    # Quiescence: the most recent mtime anywhere in the subtree. If nothing has
    # been modified within the window, treat the scratch dir as abandoned.
    if find "$entry" -newermt "-${GARDEN_SCRATCH_GC_AGE} hours" -print -quit 2>/dev/null | grep -q .; then
      continue                                          # touched recently — a live owner
    fi
    if [ -e "$entry/.git" ]; then
      local gitdir owner
      gitdir="$(git -C "$entry" rev-parse --git-common-dir 2>/dev/null || true)"
      if [ -n "$gitdir" ]; then
        owner="$(cd "$gitdir/.." 2>/dev/null && pwd || true)"
        [ -n "$owner" ] && git -C "$owner" worktree remove --force "$entry" >/dev/null 2>&1 || true
      fi
    fi
    rm -rf "$entry" 2>/dev/null && removed=$((removed+1)) || true
  done
  [ "$removed" -gt 0 ] && log "scratch janitor removed $removed quiescent scratch dir(s) (>${GARDEN_SCRATCH_GC_AGE}h)"
  return 0
}

# clean_body <doin-file> — print the job body with the trailing claim block, the
# reap-count markers, and any trailing blank lines removed. The claim block is
# anchored on the `---` line IMMEDIATELY followed by `claim:` (the shape
# claim-job.sh appends), and only the LAST such pair is the cut point — so a body
# that itself contains a `---` rule is preserved intact. If no claim block is
# found the body is returned unchanged (never blindly truncated at a stray `---`).
clean_body() {
  awk -v mark="$REAP_MARKER_RE" -v rnow="$REAP_NOW_MARKER_RE" -v prod="$PRODUCTIVE_MARKER_RE" \
      -v outage="$OUTAGE_MARKER_RE" '
    { line[NR] = $0 }
    END {
      cut = 0
      for (i = 1; i < NR; i++) if (line[i] == "---" && line[i+1] == "claim:") cut = i
      end = (cut > 0) ? cut - 1 : NR
      m = 0
      for (i = 1; i <= end; i++) {
        if (line[i] ~ mark) continue          # drop prior reap-count markers
        if (line[i] ~ rnow) continue          # drop the gardener reap-now hint (never persist it)
        if (line[i] ~ prod) continue          # drop the gardener productive-cycle hint (re-earned each cycle)
        if (line[i] ~ outage) continue        # drop the gardener outage-cycle hint (re-earned each cycle)
        out[++m] = line[i]
      }
      while (m > 0 && out[m] ~ /^[ \t]*$/) m--  # trim trailing blank lines
      for (i = 1; i <= m; i++) print out[i]
    }
  ' "$1"
}

# record_kimi_fallback_event <doin-file> <spine> <kimi-cycles> — BEST-EFFORT, fully
# guarded: when a kimi-k3 job is re-routed to opus, record ONE reputation event for
# the KIMI arm marked `accepted: false` so the evaluation charges the failed attempt
# to kimi (without this the kimi arm never sees the attempt and the comparison lies —
# designs/kimi-k3-takes-opus-work-with-opus-fallback.md § Evaluation). The doin file
# still carries `model: kimi-k3` at call time, so rep_resolve_arm resolves the kimi
# arm. Dollars stay `censored` until build-token-cost-ledger lands; the acceptance
# half works today. Staged into the SAME requeue commit; never aborts the requeue.
record_kimi_fallback_event() {
  local jf="$1" spine="$2" cycles="$3" provider model tht wc tgt dest
  { read -r provider; read -r model; read -r tht; } < <(rep_resolve_arm mystic "$jf" 2>/dev/null) || return 0
  [ -n "$provider" ] && [ -n "$model" ] || return 0
  wc="$(rep_work_class "$jf" 2>/dev/null || echo other)"
  tgt="$(rep_target "$jf" 2>/dev/null || echo main2)"
  dest="$REP_EVENTS/${spine}-kimi-fallback.md"
  mkdir -p "$DIR/$(dirname "$dest")" 2>/dev/null || return 0
  {
    printf -- '---\n'
    printf 'base: %s\n' "${spine}-kimi-fallback"
    printf 'kind: %s\n' "mystic"
    printf 'provider: %s\n' "$provider"
    printf 'model: %s\n' "$model"
    printf 'thoughtfulness: %s\n' "$tht"
    printf 'work_class: %s\n' "$wc"
    printf 'target: %s\n' "$tgt"
    printf 'accepted: %s\n' "false"
    printf 'agentic_dollars: %s\n' "censored"
    printf 'human_dollars: %s\n' "0"
    printf 'aggregate_dollars: %s\n' "censored"
    printf 'attempts: %s\n' "$cycles"
    printf 'fallback: %s\n' "kimi-k3->opus"
    printf 'source: fallback\n'
    printf 'recorded_by: %s\n' "reaper:$GARDEN"
    printf 'recorded_at: %s\n' "$(date -u +%FT%TZ)"
    printf -- '---\n'
    printf 'kimi-fallback event for %s: arm %s/%s/%s work_class %s target %s accepted false (re-routed to opus after %s kimi cycle(s))\n' \
      "$spine" "$provider" "$model" "$tht" "$wc" "$tgt" "$cycles"
  } > "$DIR/$dest" 2>/dev/null || return 0
  git -C "$DIR" add "$dest" 2>/dev/null || true
}

# Reap stuck fetches FIRST: if the reaper's own sync_clone below would contend
# for a clone lock held by a hung fetch, clearing the hang first lets this very
# tick proceed instead of blocking behind it.
reap_stuck_fetches

# GC abandoned job scratch (best-effort; never blocks the requeue path).
DIR="${GARDEN_REAPER_CLONE:-$GARDEN_STATE/reaper/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"
# Scratch janitor AFTER the sync so its live-base protection reads fresh board
# state (it previously ran before the clone existed; ordering here is otherwise
# inert — the stuck-fetch janitor above still runs first).
gc_scratch

# Re-drain any doom notices a PRIOR tick spooled because the maintainer inbox was
# unreachable then. Runs UNCONDITIONALLY every tick — before the no-stale-claims
# early exit below — so a transient inbox outage heals on a later tick instead of
# permanently dropping the "this job is stuck" signal. Independent of the reaper's
# clone (doom-notice.sh uses the producer clone), so this never blocks the requeue.
drain_doom_spool

# --- 1. detect the stale set -------------------------------------------------
now="$(date -u +%s)"
declare -a STALE=()
declare -a STALE_AGE=()            # parallel to STALE: claim age in seconds (oldest-first cap ordering, § 1b)
declare -a STALE_RN=()             # parallel to STALE: 1 iff reap-now-hinted (cap-exempt, § 1b)
declare -a LIVE_KILL_TARGETS=()   # pids to SIGKILL after a grace: handlers still live past staleness
live_deferred=0
for base in $(list_jobs "$DIR" "$JOBS_DOIN"); do
  f="$DIR/$JOBS_DOIN/$base"
  claimed_at="$(sed -n 's/^  claimed_at: //p' "$f" | head -1)"
  ts=0; [ -n "$claimed_at" ] && ts="$(date -u -d "$claimed_at" +%s 2>/dev/null || echo 0)"
  age=$(( now - ts ))
  reap_now_flag=0
  # A gardener whose handler died a transient signal-kill stamps a reap-now hint on
  # its own still-in-doin claim (gardener.sh transient branch): it KNOWS the claim
  # is dead, so we requeue it on THIS tick instead of idling the full TTL. Checked
  # BEFORE the ts==0 guard so the hint is authoritative even on an unparseable
  # claimed_at. The hint only promotes the claim into the stale set early — it then
  # flows through the SAME requeue + doom-counter path below, so a job SIGTERM'd
  # every cycle still escalates as doom after the threshold (never loops forever).
  if has_reap_now_hint "$f"; then
    reap_now_flag=1
    log "reap-now: '$base' carries a gardener reap-now hint (age ${age}s); requeueing before TTL"
  else
    # Age-based staleness, floored at the handler's maximum possible lifetime
    # (reap_age_threshold) so a GARDEN_CLAIM_TTL set below the handler wall cannot
    # requeue a still-running handler — the two-writers-in-one-worktree fix.
    threshold="$(reap_age_threshold "$f")"
    if [ "$ts" -eq 0 ] || [ "$age" -lt "$threshold" ]; then
      continue
    fi
    if [ "$threshold" -gt "$GARDEN_CLAIM_TTL" ]; then
      log "stale: '$base' (age ${age}s ≥ safe floor ${threshold}s; GARDEN_CLAIM_TTL=${GARDEN_CLAIM_TTL}s is BELOW the handler wall GARDEN_HANDLER_TIMEOUT=${GARDEN_HANDLER_TIMEOUT}s + kill-after ${GARDEN_HANDLER_KILL_AFTER}s — check the config)"
    else
      log "stale: '$base' (age ${age}s ≥ TTL ${GARDEN_CLAIM_TTL}s)"
    fi
  fi

  # LIVE-HANDLER GUARD (kill-or-wait). Even past the age floor, a handler that
  # somehow outlived its own `timeout` (a wedged supervisor) would still be writing
  # this base's worktree. Requeuing it now would let a re-claim re-enter that tree
  # under a second live writer. So if a handler subtree for this base is still alive
  # ON THIS HOST, KILL it (SIGTERM now, SIGKILL its subtree after a grace, mirroring
  # the stuck-fetch janitor) and DEFER the requeue to the next tick — by then the
  # process is gone and the requeue lands against a settled, single-owner tree. A
  # claim on another host reports no local process and requeues under the age floor.
  live_pids="$(_handler_alive_pids "$base" 2>/dev/null || true)"
  if [ -n "$live_pids" ]; then
    log "ANOMALY: '$base' is reapable (age ${age}s) but a LIVE handler subtree is still running on $GARDEN (pids: $(echo "$live_pids" | tr '\n' ' ')); killing it and deferring the requeue one tick to avoid two writers in one worktree"
    while read -r pid; do
      [ -n "$pid" ] || continue
      kill -TERM "$pid" 2>/dev/null || true
      while read -r d; do [ -n "$d" ] && LIVE_KILL_TARGETS+=("$d"); done < <(_proc_descendants "$pid")
    done <<< "$live_pids"
    live_deferred=$((live_deferred+1))
    continue
  fi

  STALE+=("$base")
  STALE_AGE+=("$age")
  STALE_RN+=("$reap_now_flag")
done

# Escalate the deferred kills: give a SIGTERM-respecting handler a brief grace, then
# SIGKILL the captured subtrees unconditionally. The claims stay in doin/ this tick
# and are requeued next tick once the processes are confirmed gone.
if [ "${#LIVE_KILL_TARGETS[@]}" -gt 0 ]; then
  sleep "$GARDEN_FETCH_REAP_KILL_AFTER"
  for d in "${LIVE_KILL_TARGETS[@]}"; do
    kill -KILL "$d" 2>/dev/null || true
  done
  log "live-handler guard: killed $live_deferred stale-but-live handler(s); their claims deferred to next tick"
fi

if [ "${#STALE[@]}" -eq 0 ]; then
  clone_unlock "$DIR"
  log "no stale claims"
  exit 0
fi

# --- 1b. per-tick requeue cap (stagger a burst) ------------------------------
#
# Bound how many AGE-EXPIRED claims this tick requeues to GARDEN_REAP_MAX_PER_TICK,
# so a restart-orphaned burst that crosses the age floor together drains over
# several ticks instead of landing in todo/ at once (and re-forming the herd). This
# is a pure DELAY layered on TOP of the age floor: a deferred claim just stays in
# doin/ this tick exactly as if it had not yet aged, so nothing is ever reaped
# EARLIER than reap_age_threshold already requires — the never-reap-earlier invariant
# is preserved, not traded against.
#
# OLDEST FIRST so nothing starves: sort the expired set by claim age (descending;
# base ascending as a deterministic, testable tie-break) and keep the oldest
# GARDEN_REAP_MAX_PER_TICK. Every deferred claim is strictly younger than every one
# reaped this tick and ages into a later tick's selection.
#
# REAP-NOW claims are CAP-EXEMPT: a gardener stamped that hint because it KNOWS the
# claim is dead and deliberately bypasses the TTL, and such hints are event-driven
# (a caught transient signal), not TTL-synchronized — they neither form the burst
# this cap addresses nor benefit from being held back. They are always requeued this
# tick, on top of (never counting against) the capped age-expired selection.
#
# DOOM accounting is untouched: deferral leaves a claim's `garden-reaped: N` marker
# in doin/ unread this tick, so when it is finally requeued the counter still
# advances by exactly one — a deferred reap cannot skip or double a doom cycle, nor
# let a doom job escape escalation (it is merely surfaced a tick or two later).
cap="$GARDEN_REAP_MAX_PER_TICK"
if ! [ "$cap" -ge 1 ] 2>/dev/null; then
  log "WARNING: GARDEN_REAP_MAX_PER_TICK='$cap' is not a positive integer; using 8"
  cap=8
fi
declare -a KEEP=()
rn_kept=0
for i in "${!STALE[@]}"; do
  [ "${STALE_RN[$i]}" -eq 1 ] || continue
  KEEP+=("${STALE[$i]}")
  rn_kept=$(( rn_kept + 1 ))
done
declare -a AGED_SORTED=()
while IFS=$'\t' read -r _a b; do
  [ -n "$b" ] && AGED_SORTED+=("$b")
done < <(
  for i in "${!STALE[@]}"; do
    [ "${STALE_RN[$i]}" -eq 1 ] && continue
    printf '%s\t%s\n' "${STALE_AGE[$i]}" "${STALE[$i]}"
  done | sort -k1,1nr -k2,2
)
aged_total=${#AGED_SORTED[@]}
aged_kept=0
for b in "${AGED_SORTED[@]}"; do
  [ "$aged_kept" -lt "$cap" ] || break
  KEEP+=("$b")
  aged_kept=$(( aged_kept + 1 ))
done
deferred=$(( aged_total - aged_kept ))
if [ "$deferred" -gt 0 ]; then
  log "requeue cap: $aged_total age-expired claim(s) exceed GARDEN_REAP_MAX_PER_TICK=$cap; requeueing the $aged_kept oldest this tick, deferring $deferred younger claim(s) to a later tick (oldest-first, none dropped)"
fi
[ "$rn_kept" -gt 0 ] && log "requeue cap: $rn_kept reap-now-hinted claim(s) requeued this tick (cap-exempt: known-dead, bypass TTL)"
STALE=("${KEEP[@]}")

# --- 2. (REMOVED) per-requeue worktree cleanup -------------------------------
# The old block here force-removed each stale claim's `worktree_dir:` path on
# EVERY requeue. That was doubly wrong: (a) per-job worktrees deliberately
# PERSIST across a requeue so a resumed claim re-enters its in-flight work (the
# sanctioned resume treadmill) — deleting them on requeue would discard that
# work; it only "worked" because claim-job stamped a path where worktrees never
# actually live, making the cleanup a permanent no-op. And (b) the stamped
# prefix was the LIVE fork-worktree namespace (worktrees/<owner>-<repo>/), so a
# job base colliding with an <owner>-<repo> dirname would have rm -rf'd a
# directory of live fork worktrees. Orphan GC is the scratch janitor's job
# (gc_scratch below, age-gated), never the requeue path's.

# --- 3. batch-requeue with bounded retry (the land-within-a-tick fix) ---------
#
# Each attempt re-syncs (so we rebase onto the latest tip, the same way a lost
# CAS forces), re-stages every still-present stale claim, and pushes the whole
# batch as ONE commit. A doom job (too many requeue cycles) is removed from the
# board and queued for a maintainer alert flushed only after the board change
# lands. sync_clone holds the per-clone lock through commit_and_push, which
# releases it; on a non-final failed attempt we keep looping (sync_clone re-takes
# the lock re-entrantly).
reaped=0
doomed=0
staged=0
declare -a DOOM_BASE=() DOOM_BODY=() DOOM_COUNT=() DOOM_OVERRUN=() DOOM_SIG=() DOOM_BUDGET=()
for attempt in $(seq 1 "$GARDEN_REAP_PUSH_ATTEMPTS"); do
  sync_clone "$DIR"
  staged=0
  DOOM_BASE=(); DOOM_BODY=(); DOOM_COUNT=(); DOOM_OVERRUN=(); DOOM_SIG=(); DOOM_BUDGET=()
  mkdir -p "$DIR/$JOBS_TODO" "$DIR/$JOBS_PLAN"
  for base in "${STALE[@]}"; do
    spine="${base%.md}"
    f="$DIR/$JOBS_DOIN/$base"
    [ -e "$f" ] || { log "'$base' already moved by someone else; skip"; continue; }

    prev="$(sed -n 's/^<!-- garden-reaped: \([0-9][0-9]*\) -->$/\1/p' "$f" | tail -1)"
    [ -n "${prev:-}" ] || prev=0
    # PRODUCTIVE cycle: the gardener stamped the productive marker because a per-job
    # worktree HEAD advanced this cycle — the handler pushed REAL WORK (the sanctioned
    # resume treadmill), NOT a handler that "fails every time". Do NOT count it toward
    # doom: RESET the streak to 0 so only cycles with NO progress accumulate toward
    # the drop. A job productive every cycle therefore never dooms; a job that truly
    # fails every cycle never earns the marker and still dooms at the threshold. This
    # is the reaper half of the productive-cycle fix (common.sh § productive-cycle hint).
    outage=0
    if has_productive_cycle_hint "$f"; then
      productive=1
      count=0
      log "productive: '$base' advanced a per-job worktree HEAD this cycle; resetting reap/doom counter (was $prev) — not counted toward doom"
    elif has_outage_cycle_hint "$f"; then
      # OUTAGE cycle: the gardener stamped this because the handler transient-failed
      # while the shared fleet brake was ENGAGED — a fleet-wide correlated outage (a
      # Claude quota/usage cut, an API-overload storm), not a defect in THIS job. PAUSE
      # the doom counter: HOLD it at its prior value rather than incrementing, so an
      # environmental storm cannot doom an otherwise-healthy job (the 2026-07-01
      # dozen-job dooming). Unlike a productive cycle it does NOT reset — the job made
      # no progress, so genuine prior no-progress failures are preserved and the job
      # still dooms on its own (non-outage) cycles once the outage clears. `outage=1`
      # also guards the doom DECISION below so this cycle can never itself doom.
      productive=0
      outage=1
      count="$prev"
      log "outage: '$base' transient-failed under an engaged fleet brake this cycle; PAUSING doom counter (held at $prev) — sustained environmental transient, not counted toward doom"
    else
      productive=0
      count=$(( prev + 1 ))
    fi
    body="$(clean_body "$f")"
    # A gardener stamps `<!-- garden-deadline-overrun: N -->` on a claim whose handler
    # hit its OWN wall-clock budget (rc=124 at the wall) — a DETERMINISTIC overrun that
    # recurs identically every requeue. Such a job is doomed at the much lower
    # GARDEN_REAP_OVERRUN_THRESHOLD rather than the full GARDEN_REAP_DOOM_THRESHOLD.
    # clean_body preserves this marker across the requeue (it strips only the reap-count
    # and reap-now markers), so the count accumulates cycle over cycle.
    overrun="$(deadline_overrun_count "$f")"
    # PRODUCTIVE cycle also spares the deadline-overrun counter, symmetric to the reap
    # counter above — and it is what makes the threshold-1 doom safe. A builder on the
    # SANCTIONED resume treadmill hits its OWN handler wall (rc=124 at its budget) every
    # cycle BY DESIGN and gets garden-deadline-overrun stamped each time; at
    # GARDEN_REAP_OVERRUN_THRESHOLD=1 it would false-doom after its FIRST productive
    # wall-hit (and when it is an on-child-failure:halt orchestration child, that false
    # doom halts the whole serial chain) without this reset. So on a productive cycle
    # zero the count for the decision AND strip the preserved marker from the requeued
    # body: the overrun marker survives clean_body by design, so a productive cycle must
    # re-stamp it to 0 (not merely zero the local variable) or the next cycle re-reads the
    # stale N and re-accumulates. Only NON-productive wall-hits count toward the overrun
    # doom — a genuinely deadlocked handler never earns the productive marker and still
    # dooms at threshold 1, after its first no-progress overrun.
    if [ "$productive" -eq 1 ] && [ "$overrun" -ne 0 ]; then
      log "productive: '$base' hit its handler wall on a productive cycle; resetting deadline-overrun counter (was $overrun) — not counted toward overrun doom"
      overrun=0
      body="$(printf '%s\n' "$body" | grep -vE "$DEADLINE_OVERRUN_MARKER_RE" || true)"
    fi
    if [ "$outage" -ne 1 ] && { [ "$overrun" -ge "$GARDEN_REAP_OVERRUN_THRESHOLD" ] || [ "$count" -ge "$GARDEN_REAP_DOOM_THRESHOLD" ]; }; then
      # Doom: do NOT requeue, and do NOT drop the work — PARK it in jobs/plan/
      # under a HELD gate so the work survives and can be resumed once the
      # underlying issue is cleared, rather than being lost until a human
      # reconstructs it (the resume-lint-ceiling-shepherds loss, kriskowal
      # 2026-07-02). The parked plan is gated `go-ahead`, which NO auto-promoter
      # selects: plan_deferred_ranked/the foreman take only `deferred`, the unblock
      # watcher only `blocked`, the orchestrate watcher only `orchestrated`. So a
      # doomed plan stays held until a human (via the liaison / promote-plan.sh)
      # or a cleared blocker promotes it back into todo/ — it never silently
      # re-enters the queue.
      #
      # The parked plan's basename is the ORIGINAL job spine, so a re-doom of the
      # same job overwrites the SAME plan/<spine>.md (updating its provenance)
      # rather than spawning duplicates — mirroring the keyed maintainer-message
      # dedup below. The signature (deterministic-overrun vs generic requeue
      # exhaustion) keys both the plan provenance and the maintainer notice.
      if [ "$overrun" -ge "$GARDEN_REAP_OVERRUN_THRESHOLD" ]; then sig="deadline-overrun"; else sig="requeue-exhausted"; fi
      # doom_count: how many times THIS job has been doom-parked. A re-doom
      # bumps the prior value carried in the existing plan file (idempotent on the
      # spine), so a job repeatedly promoted-and-re-doomed accrues a visible count.
      pplan="$DIR/$JOBS_PLAN/$base"
      prevp=0
      if [ -f "$pplan" ]; then
        # DUAL-READ: accept the new `doom_count:` and the legacy `poison_count:`
        # (a plan a still-old peer host parked during the rollout window), so a
        # re-doom preserves the accrued count across mixed-version hosts.
        prevp="$(sed -n 's/^doom_count: *//p' "$pplan" | head -1)"
        [ -n "${prevp:-}" ] || prevp="$(sed -n 's/^poison_count: *//p' "$pplan" | head -1)"
        [ -n "${prevp:-}" ] && [ "$prevp" -eq "$prevp" ] 2>/dev/null || prevp=0
      fi
      pcount=$(( prevp + 1 ))
      # Capture this BEFORE git rm removes the doin file. applied_handler_budget
      # needs the file to resolve its role/stage default; calling it after rm made
      # every role-defaulted doom notice fall back to the flat 2400s fleet default.
      doomed_budget="$(applied_handler_budget "$f")"
      {
        printf -- '---\n'
        printf 'gate: go-ahead\n'
        printf 'priority: normal\n'
        printf 'doomed: true\n'
        printf 'doom_signature: %s\n' "$sig"
        printf 'doom_count: %s\n'     "$pcount"
        printf 'requeue_cycles: %s\n'   "$count"
        printf 'deadline_overruns: %s\n' "$overrun"
        printf 'doomed_at: %s\n'      "$(date -u +%FT%TZ)"
        printf 'doomed_on: %s\n'      "$GARDEN"
        printf 'posted_by: reaper:%s\n' "$GARDEN"
        printf 'posted_at: %s\n'        "$(date -u +%FT%TZ)"
        printf -- '---\n\n'
        printf '%s\n' "$body"
      } > "$pplan"
      git -C "$DIR" rm -q "$JOBS_DOIN/$base"
      [ -e "$DIR/work/$spine" ] && git -C "$DIR" rm -q "work/$spine"
      [ -d "$DIR/inbox/$spine" ] && git -C "$DIR" rm -qr "inbox/$spine"
      git -C "$DIR" add "$JOBS_PLAN/$base"
      DOOM_BASE+=("$spine"); DOOM_BODY+=("$body"); DOOM_COUNT+=("$count")
      DOOM_OVERRUN+=("$overrun"); DOOM_SIG+=("$sig")
      DOOM_BUDGET+=("$doomed_budget")
    else
      # A stale Moonshot claim is an already-running automatic job, not a new
      # dispatch. Never touch a live doin claim before it reaches this reaper path;
      # once its handler has exited (including quota exhaustion), rewrite its clean
      # body to the current minion/Codex posture and let an eligible non-Kimi worker
      # race-claim the same spine. This is deliberately before the historical
      # Kimi-fallback experiment: quota exhaustion must not spend another Kimi cycle.
      if grep -q '^  provider: moonshot[[:space:]]*$' "$f" \
        || [ "$(plan_field "$f" model)" = kimi-k3 ]; then
        body="$(printf '%s\n' "$body" | automatic_route_body)"
        count=0
        log "kimi quota posture: '$base' exited Moonshot; re-routing its requeue to minion/Codex"
      else
      # --- historical kimi-k3 -> qualified non-Claude re-route ------------------
      # On a GENUINE failure (not an outage, not a productive cycle) of a job whose
      # `model:` pin is fallback-eligible AND that carries a `fallback-model:` chain,
      # advance the pin to the chain head so an opus gardener claims the SAME base
      # next instead of a mystic re-claiming and failing again. Gated on the armed
      # journal flag (default off => no-op), on `outage -ne 1` (never re-route during
      # an environmental storm — that is not kimi's fault), and on the job having
      # reached GARDEN_KIMI_FALLBACK_AFTER genuine failure cycles. A re-route RESETS
      # the reap counter (the fresh provider earns a fresh doom budget) and records
      # the kimi arm as a failure so the evaluation stays honest. Session/worktree
      # freshness is by construction: the opus handler finds no Claude transcript for
      # this base (kimi wrote none) and resets the leftover worktree — see the design.
      # Bounded to ONE hop: reroute_job_model pops the burned model into model-burned:
      # and empties a single-entry chain, and the re-routed job is no longer kimi-k3-
      # pinned, so a mystic cannot re-claim it. Fully guarded — a failure anywhere
      # here leaves the ordinary requeue below to run.
      if [ "$outage" -ne 1 ] && [ "$count" -ge "${GARDEN_KIMI_FALLBACK_AFTER:-1}" ]; then
        rerouted_body="$(printf '%s\n' "$body" | reroute_job_model)" && rerouted=1 || rerouted=0
        if [ "$rerouted" -eq 1 ]; then
          record_kimi_fallback_event "$f" "$spine" "$count" || true
          body="$rerouted_body"
          log "kimi-fallback: '$base' failed $count cycle(s) on kimi-k3; re-routing to its qualified non-Claude fallback, resetting reap counter"
          count=0
        fi
      fi
      fi
      {
        printf '%s\n' "$body"
        printf '\n<!-- garden-reaped: %s -->\n' "$count"
      } > "$DIR/$JOBS_TODO/$base"
      git -C "$DIR" rm -q "$JOBS_DOIN/$base"
      [ -e "$DIR/work/$spine" ] && git -C "$DIR" rm -q "work/$spine"
      git -C "$DIR" add "$JOBS_TODO/$base"
    fi
    staged=$(( staged + 1 ))
  done

  if [ "$staged" -eq 0 ]; then
    clone_unlock "$DIR"
    log "nothing left to reap (all claims moved by peers)"
    break
  fi

  if commit_and_push "$DIR" "requeue: reaped $staged stale claim(s) by $GARDEN"; then
    doomed=${#DOOM_BASE[@]}
    reaped=$(( staged - doomed ))
    # Flush doom alerts only AFTER the board change has landed, so a maintainer
    # is told only about jobs actually parked. Each alert is AMEND-OR-POST KEYED on
    # <job-base>+<signature> via doom-notice.sh: a re-doom of the same job for
    # the same condition AMENDS the open notice (bumps its occurrence count) instead
    # of posting another near-identical message — the fix for the 37-identical-
    # messages restart flood (kriskowal 2026-07-02). A new message is posted only
    # when the condition is substantially different (a different job, or the same
    # job failing for a materially different reason — requeue-exhausted vs
    # deadline-overrun).
    for i in "${!DOOM_BASE[@]}"; do
      pbase="${DOOM_BASE[$i]}"
      povr="${DOOM_OVERRUN[$i]:-0}"
      psig="${DOOM_SIG[$i]:-requeue-exhausted}"
      pbudget="${DOOM_BUDGET[$i]:-${GARDEN_HANDLER_TIMEOUT:-2400}}"
      if [ "$povr" -ge "$GARDEN_REAP_OVERRUN_THRESHOLD" ]; then
        # Early-escalation doom (the gardener stamped the deadline-overrun counter).
        # The counter is stamped from TWO gardener paths that the reaper cannot tell
        # apart here — a GENUINE wall-clock overrun (rc=124 at the handler budget) and
        # a FAST repeated failure the elapsed-constancy detector flags (e.g. a 1–2s
        # usage-cap rejection that recurs with constant elapsed). The old notice
        # asserted a wall-clock overrun as fixed boilerplate ("elapsed≈2400s") and gave
        # budget-raising advice that is actively wrong for the fast-failure case, and it
        # printed the literal 2400s default even for a job declaring a larger
        # handler-timeout. So this notice names the ACTUAL budget in force ($pbudget,
        # captured at park time) and presents BOTH shapes with how to tell them apart,
        # instead of a single false claim.
        log "DOOM (deadline-overrun): '$pbase' stamped the deadline-overrun counter ${povr}× (≥ ${GARDEN_REAP_OVERRUN_THRESHOLD}), budget=${pbudget}s; parked in plan/ (held), surfacing to maintainer"
        pbody="$(
          printf 'DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after %s early-escalation cycle(s) on %s.\n' \
                 "$povr" "$GARDEN"
          printf 'The gardener stamped the deadline-overrun counter, so the reaper surfaced it after %s\n' "$povr"
          printf 'cycle(s) rather than the full %s-cycle doom threshold. The effective handler budget in\n' \
                 "$GARDEN_REAP_DOOM_THRESHOLD"
          printf 'force for this job is %ss. That counter is stamped for two DISTINCT shapes; check the\n' "$pbudget"
          printf 'gardener log for the actual elapsed to tell which applies:\n'
          printf '  (a) GENUINE wall-clock overrun — elapsed ≈ %ss (rc=124 at the wall). The job does not\n' "$pbudget"
          printf '      fit one claim: SPLIT it into claim-sized stages, or raise its handler-timeout.\n'
          printf '  (b) FAST repeated failure — elapsed far below %ss (e.g. a 1–2s usage-cap/API rejection)\n' "$pbudget"
          printf '      flagged by elapsed-constancy. The budget is NOT the problem; read the handler log\n'
          printf '      for the real cause (quota/usage cut, swallowed error) — raising the budget will not help.\n'
          printf 'The work is preserved at jobs/plan/%s; it stays HELD until a human promotes it\n' "$pbase"
          printf '(promote-plan.sh %s) or removes it.\n' "$pbase"
          printf 'Original job base: %s\n\n--- original job body ---\n%s\n' \
                 "$pbase" "${DOOM_BODY[$i]}"
        )"
        surface_doom "$pbase" "$psig" "reaper:$GARDEN" "$pbody" || true
      else
        log "DOOM: '$pbase' reaped ${DOOM_COUNT[$i]}× (≥ ${GARDEN_REAP_DOOM_THRESHOLD}); parked in plan/ (held), surfacing to maintainer"
        pbody="$(
          printf 'DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after %s requeue cycles on %s.\n' \
                 "${DOOM_COUNT[$i]}" "$GARDEN"
          printf 'Its handler appears to fail every time; the reaper stopped requeueing it.\n'
          printf 'The work is preserved at jobs/plan/%s; it stays HELD until a human promotes it\n' "$pbase"
          printf '(promote-plan.sh %s) or removes it, so nothing is lost.\n' "$pbase"
          printf 'Original job base: %s\n\n--- original job body ---\n%s\n' \
                 "$pbase" "${DOOM_BODY[$i]}"
        )"
        surface_doom "$pbase" "$psig" "reaper:$GARDEN" "$pbody" || true
      fi
    done
    break
  fi
  log "batch requeue lost a push race (attempt $attempt/$GARDEN_REAP_PUSH_ATTEMPTS); re-syncing"
  backoff "$attempt"
done

if [ "$reaped" -eq 0 ] && [ "$doomed" -eq 0 ] && [ "$staged" -ne 0 ]; then
  log "FAILED to land requeue of ${#STALE[@]} stale claim(s) after $GARDEN_REAP_PUSH_ATTEMPTS attempts"
  exit 1
fi
log "reaped $reaped stale claim(s); doomed $doomed"
