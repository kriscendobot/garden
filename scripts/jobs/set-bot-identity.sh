#!/bin/bash
# set-bot-identity.sh — declare a host's BOT git identity OVERRIDE on the journal.
#
# Usage: set-bot-identity.sh <name> <email> [host]   (host defaults to this host)
#
# The per-host bot identity is durable garden state, so it lives on the bus: writes
# journal2's identity/<host> file (`bot_name:` / `bot_email:` lines).
# bootstrap-bot-identity.sh on THAT host reads it and applies it to the local git
# config on bring-up, ahead of the tracked canonical default keyed on
# GARDEN_BOT_LOGIN (bot-identity-defaults.tsv). A host may thus be re-identified
# from anywhere and the change propagates via the journal push. Absent an override,
# the host uses the tracked default — so this writer is ONLY for a host that must
# differ from the canonical bot login.
#
# This mirrors set-workers.sh's per-host journal write; it does not go through
# land-journal-edit.sh (identity/ is a script-owned surface, like hosts/).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="set-bot-identity"

name="${1:?usage: set-bot-identity.sh <name> <email> [host]}"
email="${2:?usage: set-bot-identity.sh <name> <email> [host]}"
host="${3:-$GARDEN}"

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

for attempt in $(seq 1 50); do
  sync_clone "$DIR"
  mkdir -p "$DIR/identity"
  f="$DIR/identity/$host"
  {
    printf 'bot_name: %s\n'  "$name"
    printf 'bot_email: %s\n' "$email"
    printf 'updated_at: %s\n' "$(date -u +%FT%TZ)"
    printf 'updated_by: %s\n' "$GARDEN"
  } > "$f.tmp"
  mv "$f.tmp" "$f"
  git -C "$DIR" add "identity/$host"
  # Capture with `|| rc=$?` (a false `if` with no `else` is exit 0 and would
  # swallow commit_and_push's rc=2 "nothing to commit" on an idempotent re-run).
  rc=0; commit_and_push "$DIR" "identity($host) bot=$name <$email>" || rc=$?
  [ "$rc" -eq 0 ] && { log "declared $host bot identity: $name <$email>"; exit 0; }
  [ "$rc" -eq 2 ] && { log "$host already at bot identity: $name <$email>"; exit 0; }
  log "set-bot-identity lost a push race (attempt $attempt); retrying"
  backoff "$attempt"
done
die "could not declare bot identity for $host after retries"
