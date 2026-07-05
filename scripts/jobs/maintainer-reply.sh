#!/bin/bash
# maintainer-reply.sh — the maintainer answers a gardener, then archives.
#
# Usage: maintainer-reply.sh <msgid> [<body-file>]   (body else stdin)
#
# Reads the maintainer message's reply_to (the originating doer), delivers the
# reply into that doer's inbox, and archives the maintainer message. If the doer
# has since completed (its inbox is gone), the reply is dead-lettered for
# garden-deadmail to promote (see inbox-send.sh).
#
# Empty reply = acknowledge only. When the reply body (body-file, else stdin) is
# empty or whitespace-only, nothing is delivered to the doer: the message is just
# moved from unread to read. This lets the maintainer dismiss a message that needs
# no answer by leaving the reply section blank, instead of delivering a literal
# "(empty message)" into the doer's inbox.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="maintainer-reply"

id="${1:?usage: maintainer-reply.sh <msgid> [body-file]}"
body="${2:-}"

# Body source guard: a non-empty $2 that is not a readable file is almost always
# a mistake (an inline reply STRING passed where a body-FILE path is expected).
# Without this, the reply read falls through to `cat` on stdin — and with a
# non-tty stdin (every background / `claude -p` / systemd context) that blocks
# forever (garden-harden-producer-body-read-hang). Fail fast, mirroring
# post-job.sh and journal-entry.sh.
if [ -n "$body" ] && [ ! -f "$body" ]; then
  die "body source '$body' is not a readable file (pass a body FILE path, or feed the reply on stdin / leave \$2 empty to acknowledge only)"
fi

DIR="${GARDEN_MAINT_CLONE:-$GARDEN_STATE/maintainer/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

f="inbox/maintainer/unread/$id"
[ -e "$DIR/$f" ] || f="inbox/maintainer/read/$id"
[ -e "$DIR/$f" ] || die "no such maintainer message: $id"

# Resolve the reply body here (body-file, else stdin, else empty) so we can tell
# an empty reply from a substantive one before deciding whether to deliver.
if   [ -n "$body" ] && [ -f "$body" ]; then REPLY="$(cat "$body")"
elif [ ! -t 0 ];                       then REPLY="$(cat)"
else REPLY=""; fi

# Empty (whitespace-only) reply: acknowledge by moving unread → read, deliver
# nothing. No reply_to is required for a bare acknowledgment.
if [ -z "$(printf '%s' "$REPLY" | tr -d '[:space:]')" ]; then
  "$HERE/maintainer-archive.sh" "$id"
  log "empty reply to $id; acknowledged (unread → read), nothing delivered"
  exit 0
fi

doer="$(sed -n 's/^reply_to:[[:space:]]*//p' "$DIR/$f" | head -1)"
[ -n "$doer" ] || die "message $id has no reply_to; cannot route a reply"

# deliver the resolved reply into the originating doer's inbox via a temp file
tmp="$(mktemp)"; trap 'rm -f "$tmp"' EXIT
printf '%s\n' "$REPLY" > "$tmp"
GARDEN_SENDER=maintainer "$HERE/inbox-send.sh" "$doer" "$tmp"
# archive the maintainer message (no-op if already archived)
"$HERE/maintainer-archive.sh" "$id" || true
log "replied to doer '$doer' and archived $id"
