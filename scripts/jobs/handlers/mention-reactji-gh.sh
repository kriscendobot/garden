#!/bin/bash
# mention-reactji-gh.sh — default reactji poster for mention-watcher.sh.
#
# Invoked as: mention-reactji-gh.sh <owner/name> <surface> <comment-id> <number> <content>
#
# Leaves a reactji (default 👀 "eyes") on the source of a VERIFIED-TRUSTED mention
# as the cheap "received and processing" signal, BEFORE the substantive job is
# posted. The endpoint is selected by surface:
#   issue-comment      → /issues/comments/<id>/reactions
#   pr-review-comment  → /pulls/comments/<id>/reactions
#   issue-body|pr-body → /issues/<number>/reactions  (a PR is an issue for this)
#
# Identity: the reaction is posted AS THE BOT (kriscendobot). The fleet's default
# gh identity must already be the bot; if GARDEN_BOT_GH_TOKEN is set we pass it
# explicitly via GH_TOKEN so the reaction cannot accidentally post under a
# maintainer identity. The watcher only ever calls this after the deterministic
# sender-trust gate has passed, so a reaction is never left on an untrusted
# sender's comment.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="mention-reactji"

repo="${1:?owner/name}"; surface="${2:?surface}"; cid="${3:-}"; number="${4:-}"; content="${5:-eyes}"

case "$surface" in
  issue-comment)      path="repos/$repo/issues/comments/$cid/reactions";;
  pr-review-comment)  path="repos/$repo/pulls/comments/$cid/reactions";;
  issue-body|pr-body) [ -n "$number" ] || { log "no number for $surface on $repo; skipping ack"; exit 0; }
                      path="repos/$repo/issues/$number/reactions";;
  *)                  die "unknown surface '$surface'";;
esac

command -v gh >/dev/null 2>&1 || die "gh not on PATH; cannot react on $repo"

# Pin the bot token explicitly when provided (defense against an ambient identity
# drift). Posting the same reactji twice from one identity is a GitHub no-op.
[ -n "${GARDEN_BOT_GH_TOKEN:-}" ] && export GH_TOKEN="$GARDEN_BOT_GH_TOKEN"
gh api -X POST "$path" -f content="$content" >/dev/null 2>&1 \
  || { log "reactji POST failed on $path"; exit 1; }
log "reacted $content on $surface ($repo ${cid:-#$number})"
