#!/bin/bash
# namespace-clone-maintenance.sh — prune and repack the per-namespace journal
# clones ($GARDEN_STATE/<ns>/journal: leader, sysop, repo-watcher, unblock,
# fork-watch, ...), on EVERY host. NO LLM.
#
# Why: nothing ever ran gc/repack on these clones. Interrupted or timed-out fetches
# leave objects/pack/tmp_pack_* behind and every fetch adds a pack, so on
# oros-studio-garden-ce242c49 (2026-10-08) leader/journal reached 6,239 packs +
# 14,832 tmp_pack files and `git show origin/journal2:leader` took 57 s — the read
# every leader-gated ExecCondition (is-main-host.sh) made. ~100 units wedged in
# `activating`, load 20-45, every journal fetch blew its 45 s bound. A manual
# `git repack -a -d` took it to 26 packs / 0.075 s and freed ~23 GB across five
# clones.
#
# Per clone, under that clone's lock (soft: a busy clone is skipped this pass):
#   1. delete objects/pack/tmp_* and objects/incoming-* older than
#      GARDEN_NS_CLONE_TMP_MAX_AGE_MIN minutes (a live fetch's tmp file is fresh);
#   2. when the pack count exceeds GARDEN_NS_CLONE_PACK_THRESHOLD, run
#      `git repack -a -d` at nice 19 / ionice idle.
#   3. (once per pass, outside any clone lock) remove ORPHANED clone siblings:
#      bounded_clone's `<path>.reclone.<pid>.<n>` temps and usage-meter's
#      `<path>.budget-stale.<pid>` / `<path>.budget-reclone.<pid>` swap dirs that
#      a SIGTERM/SIGKILL (a unit timeout, a scaler kill) stranded before their own
#      cleanup ran. Removed only when the embedded pid is dead AND the dir's ctime
#      is older than GARDEN_NS_CLONE_TMP_MAX_AGE_MIN, or unconditionally once its
#      ctime is older than GARDEN_NS_CLONE_ORPHAN_MAX_AGE_MIN (pid reuse; no clone
#      runs that long). ctime, not mtime: the budget swap renames an old clone,
#      which keeps its mtime but refreshes its ctime. (oros-studio 2026-10-12: 12
#      such dirs, 3.0 GB / 193k inodes, the oldest from 2026-10-01.)
# A clone still over the threshold after the pass (repack failed or was skipped)
# raises a coalesced watchdog-notice; a healthy pass clears it.
#
# Invoked from state-clone-keeper.sh (hourly, every host) after a random jitter.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="${GARDEN_TAG:-namespace-clone-maintenance}"

: "${GARDEN_NS_CLONE_PACK_THRESHOLD:=50}"
: "${GARDEN_NS_CLONE_TMP_MAX_AGE_MIN:=180}"
: "${GARDEN_NS_CLONE_ORPHAN_MAX_AGE_MIN:=1440}"
: "${GARDEN_NS_CLONE_JITTER:=300}"
: "${GARDEN_NS_CLONE_REPACK_TIMEOUT:=1800}"
: "${GARDEN_NS_CLONE_NOTICE:=$HERE/watchdog-notice.sh}"

jitter="$GARDEN_NS_CLONE_JITTER"
case "$jitter" in ''|*[!0-9]*) jitter=0 ;; esac
[ "$jitter" -gt 0 ] && sleep "$(( RANDOM % jitter ))"

pack_count() { find "$1/objects/pack" -maxdepth 1 -name 'pack-*.pack' 2>/dev/null | wc -l; }

maintain_one() {
  local clone="$1" gitdir n pruned
  gitdir="$(git -C "$clone" rev-parse --absolute-git-dir 2>/dev/null)" || return 0
  pruned="$(find "$gitdir/objects/pack" "$gitdir/objects" -maxdepth 1 \
    \( -name 'tmp_*' -o -name 'incoming-*' \) -mmin +"$GARDEN_NS_CLONE_TMP_MAX_AGE_MIN" \
    -print -exec rm -rf {} + 2>/dev/null | wc -l)"
  [ "$pruned" -gt 0 ] && log "$clone: pruned $pruned stale tmp file(s)"
  n="$(pack_count "$gitdir")"
  if [ "$n" -gt "$GARDEN_NS_CLONE_PACK_THRESHOLD" ]; then
    log "$clone: $n packs > $GARDEN_NS_CLONE_PACK_THRESHOLD; repacking"
    if timeout "$GARDEN_NS_CLONE_REPACK_TIMEOUT" nice -n 19 ionice -c3 \
         git -C "$clone" repack -a -d -q >/dev/null 2>&1; then
      log "$clone: repacked $n -> $(pack_count "$gitdir") pack(s)"
    else
      log "$clone: repack failed or timed out"
    fi
  fi
}

# orphan_pid <dir> — the pid embedded in a clone-sibling name (first match).
orphan_pid() {
  basename "$1" | grep -oE '\.(reclone|budget-stale|budget-reclone)\.[0-9]+' \
    | head -n 1 | grep -oE '[0-9]+$'
}

# ctime_age_min <dir> — whole minutes since the dir's ctime.
ctime_age_min() {
  local ct
  ct="$(stat -c %Z "$1" 2>/dev/null)" || return 1
  echo $(( ($(date +%s) - ct) / 60 ))
}

sweep_orphans() {
  local dir pid age reaped=0
  while IFS= read -r dir; do
    [ -d "$dir" ] || continue
    pid="$(orphan_pid "$dir")"
    [ -n "$pid" ] || continue
    age="$(ctime_age_min "$dir")" || continue
    if [ "$age" -ge "$GARDEN_NS_CLONE_ORPHAN_MAX_AGE_MIN" ]; then
      :
    elif kill -0 "$pid" 2>/dev/null || [ -d "/proc/$pid" ]; then
      continue
    elif [ "$age" -lt "$GARDEN_NS_CLONE_TMP_MAX_AGE_MIN" ]; then
      continue
    fi
    if rm -rf -- "$dir" 2>/dev/null && [ ! -e "$dir" ]; then
      log "removed orphaned clone sibling $dir (pid $pid)"
      reaped=$((reaped + 1))
    else
      log "could not remove orphaned clone sibling $dir"
    fi
  done < <(find "$GARDEN_STATE" -mindepth 2 -maxdepth 3 -type d \
             \( -name '*.reclone.[0-9]*' -o -name '*.budget-stale.[0-9]*' \
                -o -name '*.budget-reclone.[0-9]*' \) -prune -print 2>/dev/null)
  [ "$reaped" -eq 0 ] || log "removed $reaped orphaned clone sibling(s)"
}
sweep_orphans

over=""
busy_clones=""
busy_count=0
lock_err="$(mktemp)"
body="$(mktemp)"
trap 'rm -f "$lock_err" "$body"' EXIT
soft_lock_warning_re='WARN: clone lock .* busy >[0-9]+s; abandoning this OPTIONAL refresh \(fail-open, no retry ladder\)'
for clone in "$GARDEN_STATE"/*/journal; do
  [ -d "$clone" ] || continue
  # Subshell: soft clone_lock EXITS (not returns) when the clone is busy, which
  # must skip only this clone, and the lock is released with the subshell's fds.
  : > "$lock_err"
  if ( GARDEN_CLONE_LOCK_SOFT=1 clone_lock "$clone"; maintain_one "$clone" ) \
       2>"$lock_err"; then
    lock_rc=0
  else
    lock_rc=$?
  fi
  lock_diagnostic="$(<"$lock_err")"
  # Match the capture file directly. With pipefail, `printf "$capture" |
  # grep -q` can report printf's SIGPIPE (141), not grep's match, when grep exits
  # after an early match in a capture larger than the pipe buffer. That turns an
  # ordinary busy clone into the fallback branch, which replays every <4> warning
  # to journald instead of coalescing it.
  if [ "$lock_rc" -eq "$GARDEN_OFFLINE_RC" ] \
     && grep -qE "$soft_lock_warning_re" "$lock_err" \
     && ! (set +o pipefail; journal_diagnostic_is_definite_failure "$lock_diagnostic"); then
    busy_count=$((busy_count + 1))
    busy_clones="${busy_clones}${busy_clones:+, }$clone"
    # Keep anything other than clone_lock's expected busy-peer line visible.
    grep -vE "$soft_lock_warning_re" "$lock_err" >&2 || true
  else
    [ -z "$lock_diagnostic" ] || printf '%s\n' "$lock_diagnostic" >&2
    [ "$lock_rc" -eq 0 ] || log "$clone: maintenance failed (rc=$lock_rc)"
  fi
  gitdir="$(git -C "$clone" rev-parse --absolute-git-dir 2>/dev/null)" || continue
  n="$(pack_count "$gitdir")"
  [ "$n" -gt "$GARDEN_NS_CLONE_PACK_THRESHOLD" ] && over="$over  $clone: $n packs"$'\n'
done
[ "$busy_count" -eq 0 ] \
  || log "clone lock contention: skipped $busy_count busy clone(s) this tick: $busy_clones"

key="namespace-clone-packs-$GARDEN"
# Host-local "alert open" flag, so a healthy pass only sends --recovered after a
# real alert (never a recovery notice for an episode that never opened).
flag="$GARDEN_STATE/namespace-clone-maintenance/alert-open"
if [ -n "$over" ]; then
  printf 'Per-namespace journal clones on %s are still over the %s-pack threshold after maintenance:\n%s\nA pack/tmp_pack buildup makes every git read slow (2026-10-08: 57 s leader read wedged ~100 leader-gated units). Inspect by hand: `nice ionice -c3 git -C <clone> repack -a -d`.\n' \
    "$GARDEN" "$GARDEN_NS_CLONE_PACK_THRESHOLD" "$over" > "$body"
  if "$GARDEN_NS_CLONE_NOTICE" "$key" "$body" >/dev/null 2>&1; then
    mkdir -p "$(dirname "$flag")" && : > "$flag"
  else log "watchdog-notice failed"; fi
elif [ -e "$flag" ]; then
  printf 'Per-namespace journal clones on %s are back under the %s-pack threshold.\n' \
    "$GARDEN" "$GARDEN_NS_CLONE_PACK_THRESHOLD" > "$body"
  "$GARDEN_NS_CLONE_NOTICE" --recovered "$key" "$body" >/dev/null 2>&1 && rm -f "$flag"
fi
exit 0
