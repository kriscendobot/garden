#!/bin/bash
# send-msg.sh — broadcast a message onto the journal message bus.
#
# Usage: send-msg.sh <address> [<body-file>]
#   <address> is one of:
#     role/<role>     — every agent currently working in <role>
#     job/<basename>  — whoever holds job <basename>
#     host/<GARDEN>   — the addressed host's standing sysop daemon (host operations)
#     broadcast       — everyone
#   body is read from <body-file>, else stdin, else a placeholder.
#
# The host/<GARDEN> kind is a FAN-OUT TOPIC read by exactly one reader (the
# addressed host's garden-sysop). It carries host-directed system operations off
# the bus to a per-host daemon (scripts/jobs/sysop.sh; designs/sysop.md), most
# importantly to an UNATTENDED FOLLOWER where no liaison is sitting. It reuses the
# existing single-segment address guard below unchanged — a <GARDEN> identity
# (<hostname>-<basename>-<hash8>) fits [A-Za-z0-9._-] by construction, so it adds
# no new escape surface.
#
# The bus IS the journal branch (the same git-push serialization point as the
# job board), so a message reaches agents on every host, not just this one —
# which is why even same-host communication goes through it. Messages are
# add-only, so a rejected push just means re-sync and retry.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="send"

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
      role/?*|job/?*|host/?*|broadcast)
        log "unwrapped angle-bracket-wrapped placeholder address '$addr' → '$candidate'"
        addr="$candidate"
        ;;
    esac
    ;;
esac

case "$addr" in
  role/?*|job/?*|host/?*|broadcast) :;;
  *) die "illegal address '$addr' (use role/<name>, job/<base>, host/<GARDEN>, or broadcast)";;
esac
# The prefix match above still admits nested slashes and dot segments; a
# relpath like msgs/job/../../x would escape msgs/ (a stray write elsewhere in
# the journal, or a mid-lock `git add` death on 'outside repository'). Require
# exactly one path segment after the kind, with the same charset the job/doer
# basename guards enforce.
case "$addr" in
  broadcast) :;;
  *) seg="${addr#*/}"
     case "$seg" in
       *[!A-Za-z0-9._-]*|.*|'') die "illegal address segment '$seg' (one [A-Za-z0-9._-]+ segment, no leading dot)";;
     esac;;
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

# Forbid partially-qualified issue/PR references in an AUTHOR-written body (bare
# `#N`), so the reference resolves unambiguously wherever it renders (see
# skills/message-bus/SKILL.md, check-issue-refs.sh). Machine/relay callers that
# broadcast generated bodies set GARDEN_SKIP_REF_CHECK=1 to bypass.
if [ "${GARDEN_SKIP_REF_CHECK:-0}" != "1" ]; then
  printf '%s\n' "$BODY" | "$HERE/check-issue-refs.sh" - \
    || die "message not posted — fully-qualify the issue/PR reference(s) reported above, then retry"
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
