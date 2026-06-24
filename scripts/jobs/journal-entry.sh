#!/bin/bash
# journal-entry.sh — post a progress/communication entry to the journal.
#
# Usage: journal-entry.sh <kind> [<body-file>]
#   <kind>  e.g. progress, claim, result, message
#   body    from <body-file>, else stdin, else a placeholder.
#
# Adopts the garden's practice of agents narrating their work into the journal.
# Entries live under entries/<YYYY>/<MM>/<DD>/<HHMMSSZ>-<kind>-<role>-<id>.md
# and are add-only, so a rejected push just re-syncs and retries.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="entry"

kind="${1:?usage: journal-entry.sh <kind> [body-file]}"
body_src="${2:-}"
role="${GARDEN_ROLE:-gardener}"

if   [ -n "$body_src" ] && [ -f "$body_src" ]; then BODY="$(cat "$body_src")"
elif [ ! -t 0 ];                                then BODY="$(cat)"
else BODY="(no body)"; fi

day="$(date -u +%Y/%m/%d)"
stamp="$(date -u +%H%M%SZ)"
sid="$(od -An -N3 -tx1 /dev/urandom | tr -d ' \n')"
rel="entries/$day/${stamp}-${kind}-${role}-${sid}.md"

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

for attempt in $(seq 1 50); do
  sync_clone "$DIR"
  mkdir -p "$DIR/$(dirname "$rel")"
  {
    printf -- '---\nkind: %s\nrole: %s\nhost: %s\nat: %s\n---\n' \
      "$kind" "$role" "$GARDEN_HOST" "$(date -u +%FT%TZ)"
    printf '%s\n' "$BODY"
  } > "$DIR/$rel"
  git -C "$DIR" add "$rel"
  if commit_and_push "$DIR" "$kind: $role on $GARDEN_HOST"; then
    log "posted $rel"; exit 0
  fi
  backoff
done
die "could not post journal entry after retries"
