#!/bin/bash
# inbox-send.sh — CAS-post a message into a job doer's inbox (unread/).
#
# Usage: inbox-send.sh <doer> [<body-file>]
#   <doer> is the job basename whose doer you want to reach. The inbox exists
#   only while that doer is alive (created at claim, destroyed at completion).
#
# Dead-mail fallback: a message sent to a recipient whose inbox is GONE (the doer
# already completed and tore down — the race the maintainer named: a reply to a
# torn-down doer would otherwise be lost) is NOT dropped. It is deposited into the
# dead-mail queue (inbox/dead/<id>.md, carrying the intended recipient, sender, and
# body) so garden-deadmail (scripts/jobs/deadmail.sh) can promote the intent into a
# fresh job a gardener claims. Delivery to a LIVE inbox stays the fast path;
# dead-lettering is the fallback. Set GARDEN_NO_DEADLETTER=1 to restore the legacy
# hard failure (used where a caller genuinely wants the send to error out).
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
  if [ ! -d "$DIR/inbox/$doer" ]; then
    # The recipient's inbox is gone (the doer completed/tore down, or never
    # existed). Don't drop the message — dead-letter it for garden-deadmail to
    # promote into a job. Legacy hard-fail is opt-in via GARDEN_NO_DEADLETTER=1.
    if [ "${GARDEN_NO_DEADLETTER:-0}" = "1" ]; then
      die "no live inbox for doer '$doer' (not currently working a job)"
    fi
    mkdir -p "$DIR/inbox/dead"
    {
      printf 'to: %s\n'        "$doer"
      printf 'from_host: %s\n' "$GARDEN_HOST"
      printf 'from: %s\n'      "${GARDEN_SENDER:-$GARDEN_TAG}"
      [ -n "${GARDEN_REPLY_TO:-}" ] && printf 'reply_to: %s\n' "$GARDEN_REPLY_TO"
      [ -n "${GARDEN_BLOCKED_ON:-}" ] && printf 'blocked_on: %s\n' "$GARDEN_BLOCKED_ON"
      printf 'sent_at: %s\n'              "$(date -u +%FT%TZ)"
      printf 'dead_lettered_at: %s\n---\n' "$(date -u +%FT%TZ)"
      printf '%s\n' "$BODY"
    } > "$DIR/inbox/dead/$msgid.md"
    git -C "$DIR" add "inbox/dead/$msgid.md"
    if commit_and_push "$DIR" "deadmail($doer) ← $msgid from $GARDEN_HOST"; then
      log "recipient inbox '$doer' gone; dead-lettered $msgid for garden-deadmail to promote"
      exit 0
    fi
    log "dead-letter for '$doer' lost a push race (attempt $attempt); retrying"
    backoff
    continue
  fi
  mkdir -p "$DIR/inbox/$doer/unread"
  {
    printf 'from_host: %s\n' "$GARDEN_HOST"
    printf 'from: %s\n'      "${GARDEN_SENDER:-$GARDEN_TAG}"
    [ -n "${GARDEN_REPLY_TO:-}" ] && printf 'reply_to: %s\n' "$GARDEN_REPLY_TO"
    [ -n "${GARDEN_BLOCKED_ON:-}" ] && printf 'blocked_on: %s\n' "$GARDEN_BLOCKED_ON"
    printf 'sent_at: %s\n---\n' "$(date -u +%FT%TZ)"
    printf '%s\n' "$BODY"
  } > "$DIR/inbox/$doer/unread/$msgid.md"
  git -C "$DIR" add "inbox/$doer/unread/$msgid.md"
  if commit_and_push "$DIR" "inbox($doer) ← $msgid from $GARDEN_HOST"; then
    log "delivered to inbox/$doer ($msgid)"; exit 0
  fi
  log "inbox-send to '$doer' lost a push race (attempt $attempt); retrying"
  backoff
done
die "could not deliver to inbox/$doer after retries"
