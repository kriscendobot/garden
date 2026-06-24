#!/bin/bash
# maintainer-watch.sh — surface unread messages addressed to the user.
#
# The liaison runs this through the Claude Code **Monitor** tool, e.g. a Monitor
# whose command is `scripts/jobs/maintainer-watch.sh` on a short interval. It is
# READ-ONLY: it lists the maintainer inbox's unread messages each tick (so they
# persist until explicitly archived); the maintainer then replies with
# maintainer-reply.sh or archives with maintainer-archive.sh.
#
# Usage: maintainer-watch.sh

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="maintainer-watch"

DIR="${GARDEN_MAINT_CLONE:-$GARDEN_STATE/maintainer/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

n=0
for m in $(list_jobs "$DIR" "inbox/maintainer/unread"); do
  printf '========== maintainer message %s ==========\n' "$m"
  cat "$DIR/inbox/maintainer/unread/$m"; printf '\n'
  n=$((n+1))
done
[ "$n" -eq 0 ] && echo "(no unread maintainer messages)"
exit 0
