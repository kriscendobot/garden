#!/bin/bash
# add-maintainer.sh — append a login to THIS instance's maintainer set (CAS).
#
# Usage: add-maintainer.sh <login>      e.g. add-maintainer.sh kriskowal
#
# Appends to maintainers/allowlist on the journal: the deterministic, allowlist-
# only trust set the garden-issue-inbox watcher gates every issue/comment author
# against (NO org-membership fallback — driving the garden via an issue is
# stricter than commenting on a watched PR). One login per line, '#' comments and
# blanks ignored, case-insensitive. Idempotent: a login already present is a
# no-op. PER-INSTANCE journal state, so other gardens track their OWN maintainers
# in their OWN journals.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="add-maintainer"

login="${1:?usage: add-maintainer.sh <login>}"
case "$login" in *[!A-Za-z0-9-]*|'') die "illegal login '$login'";; esac
lc="$(printf '%s' "$login" | tr '[:upper:]' '[:lower:]')"

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

for attempt in $(seq 1 50); do
  sync_clone "$DIR"
  mkdir -p "$DIR/maintainers"
  touch "$DIR/maintainers/allowlist"
  # Idempotent: already present (case-insensitive, ignoring '#' comments) → done.
  present=""
  while IFS= read -r line; do
    line="${line%%#*}"; line="$(printf '%s' "$line" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')"
    [ "$line" = "$lc" ] && { present=y; break; }
  done < "$DIR/maintainers/allowlist"
  if [ -n "$present" ]; then
    log "maintainer $login already present"; exit 0
  fi
  printf '%s\n' "$login" >> "$DIR/maintainers/allowlist"
  git -C "$DIR" add "maintainers/allowlist"
  # Capture with `|| rc=$?` (a false `if` with no `else` is exit 0 and would
  # swallow commit_and_push's rc=2); the present-login case is already handled
  # by the idempotency check above, so this mostly guards push races.
  rc=0; commit_and_push "$DIR" "maintainers: add $login" || rc=$?
  [ "$rc" -eq 0 ] && { log "added maintainer $login"; exit 0; }
  [ "$rc" -eq 2 ] && { log "maintainer $login already present"; exit 0; }
  log "add-maintainer lost a push race (attempt $attempt); re-syncing"
  backoff
done
die "could not add maintainer $login after retries"
