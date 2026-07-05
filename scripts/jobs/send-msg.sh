#!/bin/bash
# send-msg.sh — broadcast a message onto the journal message bus.
#
# Usage: send-msg.sh <address> [<body-file>]
#   <address> is one of:
#     role/<role>     — every agent currently working in <role>
#     job/<basename>  — whoever holds job <basename>
#     broadcast       — everyone
#   body is read from <body-file>, else stdin, else a placeholder.
#
# The bus IS the journal branch (the same git-push serialization point as the
# job board), so a message reaches agents on every host, not just this one —
# which is why even same-host communication goes through it. Messages are
# add-only, so a rejected push just means re-sync and retry.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="send"

addr="${1:?usage: send-msg.sh <role/NAME|job/BASE|broadcast> [body-file]}"
body_src="${2:-}"

# Deterministic recovery for an unsubstituted template placeholder address.
# When $addr arrives angle-bracket-wrapped (e.g. '<address: role/web-designer>'
# or '<role/web-designer>') because a calling agent failed to substitute the
# placeholder, strip a leading '<address:'/'<' and trailing '>' plus surrounding
# whitespace, and if the inner candidate is itself a well-formed address, unwrap
# it and proceed. The warning keeps the agent-side defect visible. A genuinely
# malformed address still falls through to the hard failure below.
case "$addr" in
  '<'*'>')
    candidate="$addr"
    candidate="${candidate#<}"           # drop leading '<'
    candidate="${candidate%>}"           # drop trailing '>'
    candidate="${candidate#address:}"    # drop optional 'address:' label
    # trim surrounding whitespace
    candidate="${candidate#"${candidate%%[![:space:]]*}"}"
    candidate="${candidate%"${candidate##*[![:space:]]}"}"
    case "$candidate" in
      role/?*|job/?*|broadcast)
        log "unwrapped angle-bracket-wrapped placeholder address '$addr' → '$candidate'"
        addr="$candidate"
        ;;
    esac
    ;;
esac

case "$addr" in
  role/?*|job/?*|broadcast) :;;
  *) die "illegal address '$addr' (use role/<name>, job/<base>, or broadcast)";;
esac

# Body source guard: a non-empty $2 that is not a readable file is almost always
# a mistake (an inline body STRING passed where a body-FILE path is expected).
# Without this, the body read falls through to `cat` on stdin — and with a
# non-tty stdin (every background / `claude -p` / systemd context) that blocks
# forever, wedging the shared producer lock
# (garden-harden-producer-body-read-hang). Fail fast, mirroring post-job.sh and
# journal-entry.sh.
if [ -n "$body_src" ] && [ ! -f "$body_src" ]; then
  die "body source '$body_src' is not a readable file (pass a body FILE path, or feed the body on stdin / leave \$2 empty for '(empty message)')"
fi

# unique, sortable message id (timestamp + short random)
msgid="$(date -u +%Y%m%dT%H%M%SZ)-$(od -An -N3 -tx1 /dev/urandom | tr -d ' \n')"
relpath="msgs/$addr/$msgid.md"

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

if   [ -n "$body_src" ] && [ -f "$body_src" ]; then BODY="$(cat "$body_src")"
elif [ ! -t 0 ];                                then BODY="$(cat)"
else BODY="(empty message)"
fi

for attempt in $(seq 1 50); do
  sync_clone "$DIR"
  mkdir -p "$DIR/msgs/$addr"
  {
    printf 'from_host: %s\n'  "$GARDEN"
    printf 'from: %s\n'       "${GARDEN_SENDER:-$GARDEN_TAG}"
    printf 'sent_at: %s\n'    "$(date -u +%FT%TZ)"
    printf 'to: %s\n---\n'    "$addr"
    printf '%s\n'             "$BODY"
  } > "$DIR/$relpath"
  git -C "$DIR" add "$relpath"
  if commit_and_push "$DIR" "msg($addr) $msgid from $GARDEN"; then
    log "sent → $addr ($msgid)"
    exit 0
  fi
  log "send to $addr lost a push race (attempt $attempt); re-syncing"
  backoff "$attempt"
done
die "could not send message to $addr after retries"
