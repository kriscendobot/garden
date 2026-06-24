#!/bin/bash
# cursor-get.sh — read a journal-backed poll cursor.
#
# Usage: cursor-get.sh <key>        (e.g. activity/kriscendobot-endo)
# Prints the cursor's contents (empty if none). Cursors live in the journal
# (cursors/<key>), so a poller resumes from the last committed position after a
# restart or a failed run — and across hosts. The caller parses the body
# (typically `last_event_id` / `etag` / `last_polled_at` for a GitHub activity
# stream, or `last_sha` for a branch).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="cursor-get"

key="${1:?usage: cursor-get.sh <key>}"
case "$key" in /*|*..*|'') die "illegal cursor key '$key'";; esac

DIR="${GARDEN_CURSOR_CLONE:-$GARDEN_STATE/cursors/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"
[ -f "$DIR/cursors/$key" ] && cat "$DIR/cursors/$key" || true
