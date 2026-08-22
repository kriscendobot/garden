#!/bin/bash
# message-user.sh — a gardener sends a message to the user (maintainer).
#
# Usage: message-user.sh <reply-to-doer> [<body-file>]   (body else stdin)
#
# Posts into the standing maintainer inbox, tagged reply_to=<reply-to-doer> so
# the maintainer — through the liaison — can answer back into that doer's own
# inbox while it keeps working. <reply-to-doer> is normally the gardener's
# current job basename.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Intercept help BEFORE consuming the positional, so a '--help'/'-h' typo is not
# sent to the maintainer inbox as an empty reply_to=--help message (the same
# --help-as-positional misfire class guarded in inbox-send.sh / post-job.sh).
case "${1:-}" in
  -h|--help) sed -n '2,9p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
esac
doer="${1:?usage: message-user.sh <reply-to-doer> [body-file]}"
body="${2:-}"
export GARDEN_REPLY_TO="$doer"
export GARDEN_SENDER="${GARDEN_SENDER:-gardener:$doer}"
exec "$HERE/inbox-send.sh" maintainer ${body:+"$body"}
