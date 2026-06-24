#!/bin/bash
# inbox-list.sh — list the live (addressable) doer inboxes on the board.
#
# Usage: inbox-list.sh
#
# Prints one doer <base> per line for every inbox/<doer>/ that currently exists.
# A doer is addressable from the moment it claims a job until it completes (the
# inbox is created at claim, destroyed at completion), so this is the set of peers
# an agent can reach RIGHT NOW. It is how an agent learns a peer's live <base>
# before `inbox-send.sh <base>` — the answer to "how do related living agents find
# each other" (the standing maintainer inbox and the dead-mail queue are excluded;
# neither is a job doer).
#
# Read-only: syncs a dedicated journal clone and lists. Quiet on an empty board.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="inbox-list"

DIR="${GARDEN_INBOXLIST_CLONE:-$GARDEN_STATE/inbox-list/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

[ -d "$DIR/inbox" ] || exit 0
for d in "$DIR"/inbox/*/; do
  [ -d "$d" ] || continue
  base="$(basename "$d")"
  case "$base" in maintainer|dead) continue;; esac
  printf '%s\n' "$base"
done
