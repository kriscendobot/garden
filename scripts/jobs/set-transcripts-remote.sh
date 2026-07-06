#!/bin/bash
# set-transcripts-remote.sh — arm the transcripts archive by declaring the remote
# that carries the `transcripts2` orphan branch, in the journal (CAS).
#
# Usage: set-transcripts-remote.sh <git-url>
#   e.g. set-transcripts-remote.sh git@github.com:kriskowal/garden-transcripts.git
#
# Writes config/transcripts-remote on the journal. transcript-capture.sh reads it
# at runtime and is INERT until it exists: every host still disables Claude Code's
# deletion and SPOOLS its finished transcripts locally, but pushes nowhere until a
# remote is configured. Writing this file is therefore the deliberate ARMING act,
# and — because transcripts are the fleet's raw working memory — a safety-weighted
# one the maintainer performs (a private repo is recommended; the garden's own
# origin is public). Record it with a journal `message` entry when you arm it.
# See designs/transcript-journal-capture.md and context/operations/transcripts.md.
#
# Overwrites one file, so a rejected push just re-syncs and retries. Modeled on
# set-garden-repo.sh.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="set-transcripts-remote"

url="${1:?usage: set-transcripts-remote.sh <git-url>}"
# Accept the git URL shapes we actually push over: scp-like ssh
# (git@host:owner/repo.git), ssh:// , https:// , and a local path (for tests).
case "$url" in
  *[[:space:]]*) die "illegal transcripts remote '$url' (contains whitespace)";;
  git@*:*|ssh://*|https://*|http://*|/*|file://*) : ;;
  *) die "illegal transcripts remote '$url' (expected git@host:owner/repo.git, ssh://…, https://…, or an absolute path)";;
esac

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

for attempt in $(seq 1 50); do
  sync_clone "$DIR"
  mkdir -p "$DIR/config"
  printf '%s\n' "$url" > "$DIR/config/transcripts-remote"
  git -C "$DIR" add "config/transcripts-remote"
  # Capture the return with `|| rc=$?` (NOT an `if`): a false `if` with no `else`
  # has exit status 0, which would swallow commit_and_push's rc=2 "nothing to
  # commit" (the idempotent re-run) and loop forever.
  rc=0; commit_and_push "$DIR" "config: transcripts-remote=$url" || rc=$?
  [ "$rc" -eq 0 ] && { log "set transcripts-remote=$url"; exit 0; }
  [ "$rc" -eq 2 ] && { log "transcripts-remote already $url"; exit 0; }
  log "set transcripts-remote lost a push race (attempt $attempt); re-syncing"
  backoff "$attempt"
done
die "could not set transcripts-remote after retries"
