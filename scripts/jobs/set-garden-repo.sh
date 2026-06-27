#!/bin/bash
# set-garden-repo.sh — declare THIS instance's own GitHub repo in the journal (CAS).
#
# Usage: set-garden-repo.sh <owner/name>     e.g. set-garden-repo.sh kriskowal/garden
#
# Writes config/garden-repo on the journal. The garden-issue-inbox watcher reads
# it at runtime and is INERT until it (and at least one maintainer) exists. This
# is PER-INSTANCE journal state — main2 stays generic, so "clone main2 + init a
# fresh journal" is enough to start a new garden pointed at a different repo.
# Overwrites one file, so a rejected push just re-syncs and retries.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="set-garden-repo"

repo="${1:?usage: set-garden-repo.sh <owner/name>}"
case "$repo" in
  */*) : ;;
  *)   die "illegal repo '$repo' (expected owner/name)";;
esac
case "$repo" in
  *[!A-Za-z0-9._/-]*|/*|*/|*/*/*) die "illegal repo '$repo' (expected a single owner/name)";;
esac

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

for attempt in $(seq 1 50); do
  sync_clone "$DIR"
  mkdir -p "$DIR/config"
  printf '%s\n' "$repo" > "$DIR/config/garden-repo"
  git -C "$DIR" add "config/garden-repo"
  # Capture the return with `|| rc=$?` (NOT an `if`): a false `if` with no `else`
  # has exit status 0, which would swallow commit_and_push's rc=2 "nothing to
  # commit" (the idempotent re-run) and loop forever.
  rc=0; commit_and_push "$DIR" "config: garden-repo=$repo" || rc=$?
  [ "$rc" -eq 0 ] && { log "set garden-repo=$repo"; exit 0; }
  [ "$rc" -eq 2 ] && { log "garden-repo already $repo"; exit 0; }
  log "set garden-repo lost a push race (attempt $attempt); re-syncing"
  backoff
done
die "could not set garden-repo after retries"
