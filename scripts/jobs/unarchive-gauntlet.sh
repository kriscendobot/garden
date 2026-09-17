#!/bin/bash
# unarchive-gauntlet.sh — restore a drain-archived staged gauntlet in place.
#
# Usage: unarchive-gauntlet.sh <gauntlet-base>
#
# Archiving moves an active record from jobs/gauntlet/ to
# jobs/gauntlet-archived/ without changing its stage state. This inverse move is
# deliberately narrow: it never creates or restarts a stage, so gauntlet.sh
# resumes from the current_child recorded before the drain.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="unarchive-gauntlet"

base="${1:?usage: unarchive-gauntlet.sh <gauntlet-base>}"
case "$base" in
  -*)        die "illegal gauntlet base: '$base'";;
  */*|.*|'') die "illegal gauntlet base: '$base'";;
esac
base="${base%.md}"

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

for attempt in $(seq 1 "${GARDEN_POST_ATTEMPTS:-50}"); do
  sync_clone "$DIR"
  active="$DIR/$JOBS_GAUNTLET/$base.md"
  archived="$DIR/jobs/gauntlet-archived/$base.md"

  if [ -e "$active" ]; then
    log "gauntlet '$base' is already active; nothing to do"
    exit 0
  fi
  [ -e "$archived" ] || die "no archived gauntlet '$base' to restore"

  mkdir -p "$DIR/$JOBS_GAUNTLET"
  git -C "$DIR" mv "jobs/gauntlet-archived/$base.md" "$JOBS_GAUNTLET/$base.md"
  if commit_and_push "$DIR" "gauntlet($base) unarchived by $GARDEN"; then
    log "unarchived gauntlet '$base' at its recorded stage"
    exit 0
  fi
  log "unarchive of '$base' lost a push race (attempt $attempt); re-syncing"
  backoff "$attempt"
done
die "could not unarchive gauntlet '$base' after retries"
