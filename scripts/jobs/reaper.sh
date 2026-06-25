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
#      forever; after GARDEN_REAP_POISON_THRESHOLD cycles it is surfaced to the
#      maintainer inbox as a POISON job and dropped from the board rather than
#      requeued again.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="reaper"

: "${GARDEN_CLAIM_TTL:=3600}"          # seconds a claim may sit in doin before reaping
: "${GARDEN_FETCH_REAP_AGE:=120}"      # seconds a `git fetch` may run before it is killed
: "${GARDEN_REAP_PUSH_ATTEMPTS:=50}"   # bounded retries for the batched requeue push (CAS contention)
: "${GARDEN_REAP_POISON_THRESHOLD:=5}" # requeue cycles after which a job is surfaced as poison, not requeued

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
# this very grep out of its own match.
reap_stuck_fetches() {
  local killed=0 pid etimes cmd procs
  # SC2009: we need ps's etimes/args columns (pgrep gives neither), so grep ps.
  # shellcheck disable=SC2009
  procs="$(ps -eo pid=,etimes=,args= 2>/dev/null | grep -E '[g]it.* fetch' || true)"
  while read -r pid etimes cmd; do
    [ -n "$pid" ] || continue
    case "$cmd" in *git*fetch*) ;; *) continue ;; esac
    if [ "$etimes" -ge "$GARDEN_FETCH_REAP_AGE" ]; then
      log "ANOMALY: killing stuck git fetch pid=$pid age=${etimes}s (>${GARDEN_FETCH_REAP_AGE}s): $cmd"
      kill -TERM "$pid" 2>/dev/null || true
      killed=$((killed+1))
    fi
  done <<< "$procs"
  [ "$killed" -gt 0 ] && log "stuck-fetch janitor killed $killed stuck fetch(es)"
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
  awk -v mark="$REAP_MARKER_RE" '
    { line[NR] = $0 }
    END {
      cut = 0
      for (i = 1; i < NR; i++) if (line[i] == "---" && line[i+1] == "claim:") cut = i
      end = (cut > 0) ? cut - 1 : NR
      m = 0
      for (i = 1; i <= end; i++) {
        if (line[i] ~ mark) continue          # drop prior reap-count markers
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
declare -a POISON_BASE=() POISON_BODY=() POISON_COUNT=()
for attempt in $(seq 1 "$GARDEN_REAP_PUSH_ATTEMPTS"); do
  sync_clone "$DIR"
  staged=0
  POISON_BASE=(); POISON_BODY=(); POISON_COUNT=()
  mkdir -p "$DIR/$JOBS_TODO"
  for base in "${STALE[@]}"; do
    spine="${base%.md}"
    f="$DIR/$JOBS_DOIN/$base"
    [ -e "$f" ] || { log "'$base' already moved by someone else; skip"; continue; }

    prev="$(sed -n 's/^<!-- garden-reaped: \([0-9][0-9]*\) -->$/\1/p' "$f" | tail -1)"
    [ -n "${prev:-}" ] || prev=0
    count=$(( prev + 1 ))
    body="$(clean_body "$f")"

    if [ "$count" -ge "$GARDEN_REAP_POISON_THRESHOLD" ]; then
      # Poison: drop from the board (do NOT requeue) and remember it for a
      # post-push maintainer alert so a job whose handler fails every time does
      # not loop forever invisibly. Its full body goes to the maintainer so the
      # intent is preserved, not lost.
      git -C "$DIR" rm -q "$JOBS_DOIN/$base"
      [ -e "$DIR/work/$spine" ] && git -C "$DIR" rm -q "work/$spine"
      [ -d "$DIR/inbox/$spine" ] && git -C "$DIR" rm -qr "inbox/$spine"
      POISON_BASE+=("$spine"); POISON_BODY+=("$body"); POISON_COUNT+=("$count")
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

  if commit_and_push "$DIR" "requeue: reaped $staged stale claim(s) by $GARDEN_HOST"; then
    poisoned=${#POISON_BASE[@]}
    reaped=$(( staged - poisoned ))
    # Flush poison alerts only AFTER the board change has landed, so a maintainer
    # is told only about jobs actually removed from the board.
    for i in "${!POISON_BASE[@]}"; do
      pbase="${POISON_BASE[$i]}"
      log "POISON: '$pbase' reaped ${POISON_COUNT[$i]}× (≥ ${GARDEN_REAP_POISON_THRESHOLD}); dropped from board, surfacing to maintainer"
      {
        printf 'POISON job dropped from the board after %s requeue cycles on %s.\n' \
               "${POISON_COUNT[$i]}" "$GARDEN_HOST"
        printf 'Its handler appears to fail every time; the reaper stopped requeueing it.\n'
        printf 'Original job base: %s\n\n--- original job body ---\n%s\n' \
               "$pbase" "${POISON_BODY[$i]}"
      } | GARDEN_SENDER="reaper:$GARDEN_HOST" \
          "$GARDEN_ROOT/scripts/jobs/inbox-send.sh" maintainer >/dev/null 2>&1 \
        || log "WARNING: could not surface poison job '$pbase' to maintainer inbox"
    done
    break
  fi
  log "batch requeue lost a push race (attempt $attempt/$GARDEN_REAP_PUSH_ATTEMPTS); re-syncing"
  backoff
done

if [ "$reaped" -eq 0 ] && [ "$poisoned" -eq 0 ] && [ "$staged" -ne 0 ]; then
  log "FAILED to land requeue of ${#STALE[@]} stale claim(s) after $GARDEN_REAP_PUSH_ATTEMPTS attempts"
  exit 1
fi
log "reaped $reaped stale claim(s); poisoned $poisoned"
