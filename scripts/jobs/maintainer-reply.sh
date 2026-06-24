#!/bin/bash
# maintainer-reply.sh — the maintainer answers a gardener, then archives.
#
# Usage: maintainer-reply.sh <msgid> [<body-file>]   (body else stdin)
#
# Reads the maintainer message's reply_to (the originating doer), delivers the
# reply into that doer's inbox, and archives the maintainer message. If the doer
# has since completed (its inbox is gone), the reply fails loudly and the
# message is left unread.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="maintainer-reply"

id="${1:?usage: maintainer-reply.sh <msgid> [body-file]}"
body="${2:-}"
DIR="${GARDEN_MAINT_CLONE:-$GARDEN_STATE/maintainer/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

f="inbox/maintainer/unread/$id"
[ -e "$DIR/$f" ] || f="inbox/maintainer/read/$id"
[ -e "$DIR/$f" ] || die "no such maintainer message: $id"
doer="$(sed -n 's/^reply_to:[[:space:]]*//p' "$DIR/$f" | head -1)"
[ -n "$doer" ] || die "message $id has no reply_to; cannot route a reply"

# deliver into the originating doer's inbox
GARDEN_SENDER=maintainer "$HERE/inbox-send.sh" "$doer" ${body:+"$body"}
# archive the maintainer message (no-op if already archived)
"$HERE/maintainer-archive.sh" "$id" || true
log "replied to doer '$doer' and archived $id"
