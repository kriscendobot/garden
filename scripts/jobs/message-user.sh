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

# Coalesce this gardener's channel by default (audit rec 9 / § 3.3): a gardener in
# a retry/status loop re-reporting the SAME thing must AMEND one maintainer entry,
# not pile a new file per send — the duplicate mass the 2026-07-28 flood proved
# dominant. The episode key is (this job, this content): keyed on the doer PLUS a
# content hash so identical repeats fold while genuinely DISTINCT messages from the
# same gardener still get their own entry (the boundary: key on (sender, episode),
# not sender alone). A caller may pin its own GARDEN_MSG_ID to force an episode, or
# set GARDEN_MSG_COALESCE=0 to opt out entirely (a one-off that must never fold).
export GARDEN_MSG_COALESCE="${GARDEN_MSG_COALESCE:-1}"
if [ "$GARDEN_MSG_COALESCE" = 1 ] && [ -z "${GARDEN_MSG_ID:-}" ]; then
  if   [ -n "$body" ] && [ -f "$body" ]; then bodytext="$(cat "$body")"
  elif [ ! -t 0 ];                       then bodytext="$(cat)"; body=""; stdin_body=1
  else bodytext=""; fi
  # Only derive a content-keyed episode when there is real content to key on; an
  # empty body falls through to the original path (and its '(empty message)'
  # placeholder) rather than folding every empty send into one entry.
  if [ -n "$bodytext" ]; then
    digest="$(printf '%s' "$bodytext" | { sha1sum 2>/dev/null || shasum 2>/dev/null; } | cut -c1-12)"
    [ -n "$digest" ] || digest="nodigest"
    export GARDEN_MSG_ID="msg-$doer-$digest"
    if [ -n "$body" ]; then exec "$HERE/inbox-send.sh" maintainer "$body"; fi
    printf '%s' "$bodytext" | "$HERE/inbox-send.sh" maintainer; exit $?
  fi
  # Empty body: if it arrived on stdin we already consumed it, so feed the empty
  # body through the pipe (not the file arg) to keep behavior identical.
  if [ "${stdin_body:-0}" = 1 ]; then
    printf '%s' "$bodytext" | "$HERE/inbox-send.sh" maintainer; exit $?
  fi
fi
exec "$HERE/inbox-send.sh" maintainer ${body:+"$body"}
