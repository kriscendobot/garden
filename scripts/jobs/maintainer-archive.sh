#!/bin/bash
# maintainer-archive.sh — archive a maintainer-inbox message (unread → read).
# Usage: maintainer-archive.sh <msgid>
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="maintainer-archive"
id="${1:?usage: maintainer-archive.sh <msgid>}"
DIR="${GARDEN_MAINT_CLONE:-$GARDEN_STATE/maintainer/journal}"
ensure_clone "$DIR"
for attempt in $(seq 1 50); do
  sync_clone "$DIR"
  if [ ! -e "$DIR/inbox/maintainer/unread/$id" ]; then log "$id already archived"; exit 0; fi
  mkdir -p "$DIR/inbox/maintainer/read"
  git -C "$DIR" mv "inbox/maintainer/unread/$id" "inbox/maintainer/read/$id"
  if commit_and_push "$DIR" "maintainer archive $id"; then log "archived $id"; exit 0; fi
  backoff
done
die "could not archive $id after retries"
