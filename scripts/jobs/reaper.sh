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
#      forever; after GARDEN_REAP_POISON_THRESHOLD cycles it is POISONED: rather
#      than being dropped from the board, it is PARKED in jobs/plan/ under a held
#      `go-ahead` gate (no auto-promoter selects it) so the work survives and can be
#      resumed, and a maintainer notice is AMEND-OR-POST deduped by <job-base> +
#      <failure signature> (poison-notice.sh) so a restart that poisons dozens of
#      jobs does not flood the inbox with near-identical messages. See the poison
#      branch of the batch-requeue loop below and poison-notice.sh.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="reaper"

: "${GARDEN_CLAIM_TTL:=3600}"          # seconds a claim may sit in doin before reaping
: "${GARDEN_FETCH_REAP_AGE:=120}"      # seconds a `git fetch` may run before it is killed
: "${GARDEN_FETCH_REAP_KILL_AFTER:=5}" # grace seconds after SIGTERM before the stuck-fetch janitor escalates to SIGKILL
: "${GARDEN_REAP_PUSH_ATTEMPTS:=50}"   # bounded retries for the batched requeue push (CAS contention)
: "${GARDEN_REAP_POISON_THRESHOLD:=5}" # requeue cycles after which a job is surfaced as poison, not requeued
# A job carrying the gardener's `<!-- garden-deadline-overrun: N -->` marker hit its
# OWN handler wall-clock budget (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT) — a
# DETERMINISTIC overrun that will be killed identically on every requeue, so it is
# escalated to POISON at this much LOWER threshold (default 2) rather than the full
# GARDEN_REAP_POISON_THRESHOLD: two identical deadline hits is already conclusive, and
# requeuing it 5× (~5×GARDEN_HANDLER_TIMEOUT of gardener wall-clock) before surfacing
# it is pure waste. The gardener owns/increments the counter (common.sh
# § deadline-overrun); the reaper only reads it to decide the threshold.
: "${GARDEN_REAP_OVERRUN_THRESHOLD:=2}" # deadline-overrun cycles after which a wall-hitting job is surfaced as poison

# Marker the reaper stamps into a requeued job body to count requeue cycles. It
# is an HTML comment so it is invisible in rendered Markdown, and it survives both
# the claim-block strip (it lives in the body, above the trailing claim block) and
# a re-claim (claim-job appends its stamp BELOW the body).
REAP_MARKER_RE='^<!-- garden-reaped: [0-9][0-9]* -->$'

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
  local removed=0 entry
  for entry in "$GARDEN_SCRATCH"/*; do
    [ -e "$entry" ] || continue                         # empty-glob guard
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
  awk -v mark="$REAP_MARKER_RE" -v rnow="$REAP_NOW_MARKER_RE" -v prod="$PRODUCTIVE_MARKER_RE" '
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
        out[++m] = line[i]
      }
      while (m > 0 && out[m] ~ /^[ \t]*$/) m--  # trim trailing blank lines
      for (i = 1; i <= m; i++) print out[i]
    }
  ' "$1"
}

# Reap stuck fetches FIRST: if the reaper's own sync_clone below would contend
# for a clone lock held by a hung fetch, clearing the hang first lets this very
# tick proceed instead of blocking behind it.
reap_stuck_fetches

# GC abandoned job scratch (best-effort; never blocks the requeue path).
gc_scratch

DIR="${GARDEN_REAPER_CLONE:-$GARDEN_STATE/reaper/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

# --- 1. detect the stale set -------------------------------------------------
now="$(date -u +%s)"
declare -a STALE=()
for base in $(list_jobs "$DIR" "$JOBS_DOIN"); do
  f="$DIR/$JOBS_DOIN/$base"
  claimed_at="$(sed -n 's/^  claimed_at: //p' "$f" | head -1)"
  ts=0; [ -n "$claimed_at" ] && ts="$(date -u -d "$claimed_at" +%s 2>/dev/null || echo 0)"
  age=$(( now - ts ))
  # A gardener whose handler died a transient signal-kill stamps a reap-now hint on
  # its own still-in-doin claim (gardener.sh transient branch): it KNOWS the claim
  # is dead, so we requeue it on THIS tick instead of idling the full TTL. Checked
  # BEFORE the ts==0 guard so the hint is authoritative even on an unparseable
  # claimed_at. The hint only promotes the claim into the stale set early — it then
  # flows through the SAME requeue + poison-counter path below, so a job SIGTERM'd
  # every cycle still escalates as poison after the threshold (never loops forever).
  if has_reap_now_hint "$f"; then
    log "reap-now: '$base' carries a gardener reap-now hint (age ${age}s); requeueing before TTL"
    STALE+=("$base")
    continue
  fi
  if [ "$ts" -eq 0 ] || [ "$age" -lt "$GARDEN_CLAIM_TTL" ]; then
    continue
  fi
  log "stale: '$base' (age ${age}s ≥ TTL ${GARDEN_CLAIM_TTL}s)"
  STALE+=("$base")
done

if [ "${#STALE[@]}" -eq 0 ]; then
  clone_unlock "$DIR"
  log "no stale claims"
  exit 0
fi

# --- 2. best-effort orphaned-worktree cleanup (once, before the push loop) ----
for base in "${STALE[@]}"; do
  spine="${base%.md}"
  wt="$(sed -n 's/^worktree_dir: //p' "$DIR/work/$spine" 2>/dev/null | head -1)"
  if [ -n "$wt" ] && [ -d "$wt" ]; then
    git -C "$wt" rev-parse --is-inside-work-tree >/dev/null 2>&1 \
      && git --git-dir="$(git -C "$wt" rev-parse --git-common-dir 2>/dev/null)" worktree remove --force "$wt" 2>/dev/null \
      || rm -rf "$wt" 2>/dev/null || true
    log "removed orphaned worktree $wt"
  fi
done

# --- 3. batch-requeue with bounded retry (the land-within-a-tick fix) ---------
#
# Each attempt re-syncs (so we rebase onto the latest tip, the same way a lost
# CAS forces), re-stages every still-present stale claim, and pushes the whole
# batch as ONE commit. A poison job (too many requeue cycles) is removed from the
# board and queued for a maintainer alert flushed only after the board change
# lands. sync_clone holds the per-clone lock through commit_and_push, which
# releases it; on a non-final failed attempt we keep looping (sync_clone re-takes
# the lock re-entrantly).
reaped=0
poisoned=0
staged=0
declare -a POISON_BASE=() POISON_BODY=() POISON_COUNT=() POISON_OVERRUN=() POISON_SIG=()
for attempt in $(seq 1 "$GARDEN_REAP_PUSH_ATTEMPTS"); do
  sync_clone "$DIR"
  staged=0
  POISON_BASE=(); POISON_BODY=(); POISON_COUNT=(); POISON_OVERRUN=(); POISON_SIG=()
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
    # poison: RESET the streak to 0 so only cycles with NO progress accumulate toward
    # the drop. A job productive every cycle therefore never poisons; a job that truly
    # fails every cycle never earns the marker and still poisons at the threshold. This
    # is the reaper half of the productive-cycle fix (common.sh § productive-cycle hint).
    if has_productive_cycle_hint "$f"; then
      count=0
      log "productive: '$base' advanced a per-job worktree HEAD this cycle; resetting reap/poison counter (was $prev) — not counted toward poison"
    else
      count=$(( prev + 1 ))
    fi
    body="$(clean_body "$f")"
    # A gardener stamps `<!-- garden-deadline-overrun: N -->` on a claim whose handler
    # hit its OWN wall-clock budget (rc=124 at the wall) — a DETERMINISTIC overrun that
    # recurs identically every requeue. Such a job is poisoned at the much lower
    # GARDEN_REAP_OVERRUN_THRESHOLD rather than the full GARDEN_REAP_POISON_THRESHOLD.
    # clean_body preserves this marker across the requeue (it strips only the reap-count
    # and reap-now markers), so the count accumulates cycle over cycle.
    overrun="$(deadline_overrun_count "$f")"
    if [ "$overrun" -ge "$GARDEN_REAP_OVERRUN_THRESHOLD" ] || [ "$count" -ge "$GARDEN_REAP_POISON_THRESHOLD" ]; then
      # Poison: do NOT requeue, and do NOT drop the work — PARK it in jobs/plan/
      # under a HELD gate so the work survives and can be resumed once the
      # underlying issue is cleared, rather than being lost until a human
      # reconstructs it (the resume-lint-ceiling-shepherds loss, kriskowal
      # 2026-07-02). The parked plan is gated `go-ahead`, which NO auto-promoter
      # selects: plan_deferred_ranked/the foreman take only `deferred`, the unblock
      # watcher only `blocked`, the orchestrate watcher only `orchestrated`. So a
      # poisoned plan stays held until a human (via the liaison / promote-plan.sh)
      # or a cleared blocker promotes it back into todo/ — it never silently
      # re-enters the queue.
      #
      # The parked plan's basename is the ORIGINAL job spine, so a re-poison of the
      # same job overwrites the SAME plan/<spine>.md (updating its provenance)
      # rather than spawning duplicates — mirroring the keyed maintainer-message
      # dedup below. The signature (deterministic-overrun vs generic requeue
      # exhaustion) keys both the plan provenance and the maintainer notice.
      if [ "$overrun" -ge "$GARDEN_REAP_OVERRUN_THRESHOLD" ]; then sig="deadline-overrun"; else sig="requeue-exhausted"; fi
      # poison_count: how many times THIS job has been poison-parked. A re-poison
      # bumps the prior value carried in the existing plan file (idempotent on the
      # spine), so a job repeatedly promoted-and-re-poisoned accrues a visible count.
      pplan="$DIR/$JOBS_PLAN/$base"
      prevp=0
      if [ -f "$pplan" ]; then
        prevp="$(sed -n 's/^poison_count: *//p' "$pplan" | head -1)"
        [ -n "${prevp:-}" ] && [ "$prevp" -eq "$prevp" ] 2>/dev/null || prevp=0
      fi
      pcount=$(( prevp + 1 ))
      {
        printf -- '---\n'
        printf 'gate: go-ahead\n'
        printf 'priority: normal\n'
        printf 'poisoned: true\n'
        printf 'poison_signature: %s\n' "$sig"
        printf 'poison_count: %s\n'     "$pcount"
        printf 'requeue_cycles: %s\n'   "$count"
        printf 'deadline_overruns: %s\n' "$overrun"
        printf 'poisoned_at: %s\n'      "$(date -u +%FT%TZ)"
        printf 'poisoned_on: %s\n'      "$GARDEN"
        printf 'posted_by: reaper:%s\n' "$GARDEN"
        printf 'posted_at: %s\n'        "$(date -u +%FT%TZ)"
        printf -- '---\n\n'
        printf '%s\n' "$body"
      } > "$pplan"
      git -C "$DIR" rm -q "$JOBS_DOIN/$base"
      [ -e "$DIR/work/$spine" ] && git -C "$DIR" rm -q "work/$spine"
      [ -d "$DIR/inbox/$spine" ] && git -C "$DIR" rm -qr "inbox/$spine"
      git -C "$DIR" add "$JOBS_PLAN/$base"
      POISON_BASE+=("$spine"); POISON_BODY+=("$body"); POISON_COUNT+=("$count")
      POISON_OVERRUN+=("$overrun"); POISON_SIG+=("$sig")
    else
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
    poisoned=${#POISON_BASE[@]}
    reaped=$(( staged - poisoned ))
    # Flush poison alerts only AFTER the board change has landed, so a maintainer
    # is told only about jobs actually parked. Each alert is AMEND-OR-POST KEYED on
    # <job-base>+<signature> via poison-notice.sh: a re-poison of the same job for
    # the same condition AMENDS the open notice (bumps its occurrence count) instead
    # of posting another near-identical message — the fix for the 37-identical-
    # messages restart flood (kriskowal 2026-07-02). A new message is posted only
    # when the condition is substantially different (a different job, or the same
    # job failing for a materially different reason — requeue-exhausted vs
    # deadline-overrun).
    for i in "${!POISON_BASE[@]}"; do
      pbase="${POISON_BASE[$i]}"
      povr="${POISON_OVERRUN[$i]:-0}"
      psig="${POISON_SIG[$i]:-requeue-exhausted}"
      if [ "$povr" -ge "$GARDEN_REAP_OVERRUN_THRESHOLD" ]; then
        # Deterministic-overrun poison: the handler hit its OWN wall-clock budget every
        # cycle. Name the signature (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT) so the
        # maintainer reads "this job exceeds the handler budget", not a generic
        # "poison after N cycles".
        log "POISON (deadline-overrun): '$pbase' hit the handler wall-clock budget ${povr}× (≥ ${GARDEN_REAP_OVERRUN_THRESHOLD}); parked in plan/ (held), surfacing to maintainer"
        {
          printf 'POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after %s DEADLINE-OVERRUN cycles on %s.\n' \
                 "$povr" "$GARDEN"
          printf 'Its handler hit its OWN wall-clock budget every cycle (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT=%ss):\n' \
                 "${GARDEN_HANDLER_TIMEOUT:-2400}"
          printf 'this job EXCEEDS THE HANDLER BUDGET and would be killed identically on every requeue,\n'
          printf 'so the reaper surfaced it after %s overrun cycles (not the full %s-cycle poison threshold).\n' \
                 "$GARDEN_REAP_OVERRUN_THRESHOLD" "$GARDEN_REAP_POISON_THRESHOLD"
          printf 'The work is preserved at jobs/plan/%s; it stays HELD until a human promotes it\n' "$pbase"
          printf '(promote-plan.sh %s) or removes it. Triage: split the job, raise GARDEN_HANDLER_TIMEOUT\n' "$pbase"
          printf 'for this work, or fix what makes it run long.\n'
          printf 'Original job base: %s\n\n--- original job body ---\n%s\n' \
                 "$pbase" "${POISON_BODY[$i]}"
        } | GARDEN_SENDER="reaper:$GARDEN" \
            "$HERE/poison-notice.sh" "$pbase" "$psig" >/dev/null 2>&1 \
          || log "WARNING: could not surface deadline-overrun poison job '$pbase' to maintainer inbox"
      else
        log "POISON: '$pbase' reaped ${POISON_COUNT[$i]}× (≥ ${GARDEN_REAP_POISON_THRESHOLD}); parked in plan/ (held), surfacing to maintainer"
        {
          printf 'POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after %s requeue cycles on %s.\n' \
                 "${POISON_COUNT[$i]}" "$GARDEN"
          printf 'Its handler appears to fail every time; the reaper stopped requeueing it.\n'
          printf 'The work is preserved at jobs/plan/%s; it stays HELD until a human promotes it\n' "$pbase"
          printf '(promote-plan.sh %s) or removes it, so nothing is lost.\n' "$pbase"
          printf 'Original job base: %s\n\n--- original job body ---\n%s\n' \
                 "$pbase" "${POISON_BODY[$i]}"
        } | GARDEN_SENDER="reaper:$GARDEN" \
            "$HERE/poison-notice.sh" "$pbase" "$psig" >/dev/null 2>&1 \
          || log "WARNING: could not surface poison job '$pbase' to maintainer inbox"
      fi
    done
    break
  fi
  log "batch requeue lost a push race (attempt $attempt/$GARDEN_REAP_PUSH_ATTEMPTS); re-syncing"
  backoff "$attempt"
done

if [ "$reaped" -eq 0 ] && [ "$poisoned" -eq 0 ] && [ "$staged" -ne 0 ]; then
  log "FAILED to land requeue of ${#STALE[@]} stale claim(s) after $GARDEN_REAP_PUSH_ATTEMPTS attempts"
  exit 1
fi
log "reaped $reaped stale claim(s); poisoned $poisoned"
