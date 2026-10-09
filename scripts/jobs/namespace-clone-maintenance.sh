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

over=""
for clone in "$GARDEN_STATE"/*/journal; do
  [ -d "$clone" ] || continue
  # Subshell: soft clone_lock EXITS (not returns) when the clone is busy, which
  # must skip only this clone, and the lock is released with the subshell's fds.
  ( GARDEN_CLONE_LOCK_SOFT=1 clone_lock "$clone"; maintain_one "$clone" ) || true
  gitdir="$(git -C "$clone" rev-parse --absolute-git-dir 2>/dev/null)" || continue
  n="$(pack_count "$gitdir")"
  [ "$n" -gt "$GARDEN_NS_CLONE_PACK_THRESHOLD" ] && over="$over  $clone: $n packs"$'\n'
done

key="namespace-clone-packs-$GARDEN"
# Host-local "alert open" flag, so a healthy pass only sends --recovered after a
# real alert (never a recovery notice for an episode that never opened).
flag="$GARDEN_STATE/namespace-clone-maintenance/alert-open"
body="$(mktemp)"; trap 'rm -f "$body"' EXIT
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
