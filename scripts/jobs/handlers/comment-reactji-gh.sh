#!/bin/bash
# comment-reactji-gh.sh — default reactji poster for comment-watcher.sh.
#
# Invoked as: comment-reactji-gh.sh <owner/name> <surface> <comment-id> <content>
#
# Leaves a reactji (default 👀 "eyes") on the source comment as the cheap
# "received and processing" signal, BEFORE the substantive job is posted. The
# endpoint is selected by surface (translates skills/reactji-acknowledgment):
#   issue-comment      → /issues/comments/<id>/reactions
#   pr-review-comment  → /pulls/comments/<id>/reactions
#   pr-review-body     → reviews are NOT reactable; this is a no-op success.
#
# Authorization: the endo-but-for-bots standing authorization permits the
# reaction (every commenter is maintainer-equivalent on that gated repo). Posting
# a reaction from the bot identity on any other repo requires the same
# maintainer-authorization the monitoring-safety constraint demands.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="comment-reactji"

repo="${1:?owner/name}"; surface="${2:?surface}"; cid="${3:?comment-id}"; content="${4:-eyes}"

case "$surface" in
  issue-comment)     path="repos/$repo/issues/comments/$cid/reactions";;
  pr-review-comment) path="repos/$repo/pulls/comments/$cid/reactions";;
  pr-review-body)    log "review body $cid not reactable; skipping ack"; exit 0;;
  *)                 die "unknown surface '$surface'";;
esac

command -v gh >/dev/null 2>&1 || die "gh not on PATH; cannot react on $repo"
# Posting the same reactji twice from one identity is a GitHub no-op (dedup), so
# we do not check for an existing reaction first.
gh api -X POST "$path" -f content="$content" >/dev/null 2>&1 \
  || { log "reactji POST failed on $path"; exit 1; }
log "reacted $content on $surface/$cid"
