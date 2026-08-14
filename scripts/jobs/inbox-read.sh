#!/bin/bash
# inbox-read.sh — drain a job doer's inbox, CAS-moving unread → read.
#
# Usage: inbox-read.sh <doer>
#   Prints each unread message and atomically moves it to inbox/<doer>/read/
#   via a CAS push, mirroring the board's claim move. The doer is the sole
#   mover of its own inbox, so the move always eventually lands; a rejected
#   push (a sender added a new unread message meanwhile) just means re-sync and
#   move whatever is still unread. Exit status is the number of messages read
#   (capped at 250).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"

doer="${1:?usage: inbox-read.sh <doer>}"
GARDEN_TAG="inbox-read/$doer"
DIR="${GARDEN_INBOX_CLONE:-$GARDEN_STATE/inbox/$doer/journal}"
: "${GARDEN_INBOX_CLONE_RETRIES:=3}"

# A gardener drains its directed inbox only once, immediately after claiming a
# job. Do not let a momentary failure while creating this doer's cold journal
# clone turn that sole drain into the caller's silent `|| true` skip. Contain
# ensure_clone in a subshell because its failure path calls die (exit), then
# retry with the shared bounded exponential backoff.
clone_ready=0
for attempt in $(seq 1 "$GARDEN_INBOX_CLONE_RETRIES"); do
  if ( ensure_clone "$DIR" ); then
    clone_ready=1
    break
  fi
  if [ "$attempt" -lt "$GARDEN_INBOX_CLONE_RETRIES" ]; then
    log "initial inbox journal clone failed (attempt $attempt/$GARDEN_INBOX_CLONE_RETRIES); backing off before retry"
    backoff "$attempt"
  fi
done
[ "$clone_ready" -eq 1 ] || die "initial inbox journal clone failed after $GARDEN_INBOX_CLONE_RETRIES attempts"

read_total=0
for attempt in $(seq 1 50); do
  sync_clone "$DIR"
  [ -d "$DIR/inbox/$doer/unread" ] || break
  mapfile -t msgs < <(list_jobs "$DIR" "inbox/$doer/unread")
  [ "${#msgs[@]}" -eq 0 ] && break

  mkdir -p "$DIR/inbox/$doer/read"
  for m in "${msgs[@]}"; do
    git -C "$DIR" mv "inbox/$doer/unread/$m" "inbox/$doer/read/$m"
  done
  if commit_and_push "$DIR" "inbox($doer) read ${#msgs[@]} msg(s) on $GARDEN"; then
    for m in "${msgs[@]}"; do
      printf '========== inbox %s/%s ==========\n' "$doer" "$m"
      cat "$DIR/inbox/$doer/read/$m"; printf '\n'
    done
    read_total=$(( read_total + ${#msgs[@]} ))
    # loop once more in case new mail arrived while we were moving
    continue
  fi
  log "inbox read for '$doer' lost a push race (attempt $attempt); re-syncing"
  backoff "$attempt"
done

[ "$read_total" -gt 0 ] && log "read $read_total message(s)"
[ "$read_total" -gt 250 ] && read_total=250
exit "$read_total"
