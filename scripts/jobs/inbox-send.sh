#!/bin/bash
# inbox-send.sh — CAS-post a message into a job doer's inbox (unread/).
#
# Usage: inbox-send.sh <doer> [<body-file>]
#   <doer> is the job basename whose doer you want to reach. The inbox exists
#   only while that doer is alive (created at claim, destroyed at completion),
#   so sending to an inactive doer fails — by design, you cannot mail a doer
#   that is not currently working.
#
# Posting is add-only; a rejected push just means re-sync and retry (backoff).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="inbox-send"

doer="${1:?usage: inbox-send.sh <doer> [body-file]}"
body_src="${2:-}"
case "$doer" in */*|.*|'') die "illegal doer '$doer'";; esac

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

if   [ -n "$body_src" ] && [ -f "$body_src" ]; then BODY="$(cat "$body_src")"
elif [ ! -t 0 ];                                then BODY="$(cat)"
else BODY="(empty message)"; fi

msgid="$(date -u +%Y%m%dT%H%M%SZ)-$(od -An -N3 -tx1 /dev/urandom | tr -d ' \n')"

for attempt in $(seq 1 50); do
  sync_clone "$DIR"
  [ -d "$DIR/inbox/$doer" ] || die "no live inbox for doer '$doer' (not currently working a job)"
  mkdir -p "$DIR/inbox/$doer/unread"
  {
    printf 'from_host: %s\n' "$GARDEN_HOST"
    printf 'from: %s\n'      "${GARDEN_SENDER:-$GARDEN_TAG}"
    [ -n "${GARDEN_REPLY_TO:-}" ] && printf 'reply_to: %s\n' "$GARDEN_REPLY_TO"
    printf 'sent_at: %s\n---\n' "$(date -u +%FT%TZ)"
    printf '%s\n' "$BODY"
  } > "$DIR/inbox/$doer/unread/$msgid"
  git -C "$DIR" add "inbox/$doer/unread/$msgid"
  if commit_and_push "$DIR" "inbox($doer) ← $msgid from $GARDEN_HOST"; then
    log "delivered to inbox/$doer ($msgid)"; exit 0
  fi
  log "inbox-send to '$doer' lost a push race (attempt $attempt); retrying"
  backoff
done
die "could not deliver to inbox/$doer after retries"
