#!/bin/bash
# comment-reply-gh.sh — default REPLY-COMMENT poster for comment-watcher.sh.
#
# Invoked as: comment-reply-gh.sh <owner/name> <surface> <comment-id> <pr> <body-file>
#
# Maintainer directive (kriskowal, 2026-06-30, re endo-but-for-bots #58 comment
# 4848100199 — "What's the status of this effort?", which got only a 👀): an
# ACKNOWLEDGED trusted comment must get AT LEAST a reply comment, not just the
# reactji. The reactji says "I saw this"; the reply says "and here is what is
# happening" (or engages the question). This handler posts that reply.
#
#   issue-comment      → a PR/issue CONVERSATION reply: a new issue comment on <pr>
#   pr-comment         → same (a PR conversation comment IS an issue comment on the API)
#   pr-review-comment  → an INLINE thread reply: /pulls/<pr>/comments/<cid>/replies
#   pr-review-body / issue → no-op (review bodies are answered by their job; the
#                        issue-inbox owns issue bodies)
#
# ── Idempotent by comment-id (the feedback-loop guard) ───────────────────────
# The reply carries a hidden HTML marker keyed on the SOURCE comment id:
#   <!-- garden-reply:<cid> -->
# Before posting, the handler lists the existing replies on the same surface and
# greps for that marker; if it is already present the handler is a clean no-op.
# This makes a re-poll (or a crash before the watcher's cursor advances) never
# double-reply, satisfying the "reply once per comment" guard at the handler layer
# in addition to the watcher's cursor-based dedup. Combined with the source's
# self-comment drop (the watcher also refuses to reply to its own login), this is
# the defense against a reply→reply spiral.
#
# Authorization: same posture as comment-reactji-gh.sh — the endo-but-for-bots
# standing authorization permits the comment; posting from the bot identity on any
# other repo follows the monitoring-safety constraint.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="comment-reply"

repo="${1:?owner/name}"; surface="${2:?surface}"; cid="${3:?comment-id}"; pr="${4:?pr}"; bf="${5:?body-file}"
[ -f "$bf" ] || die "reply body file not found: $bf"

case "$surface" in
  issue-comment|pr-comment) mode=conversation ;;
  pr-review-comment)        mode=inline ;;
  pr-review-body|issue)     log "surface $surface is not reply-via-comment (its job/owner is the response); skipping"; exit 0 ;;
  *)                        die "unknown surface '$surface'" ;;
esac

command -v gh >/dev/null 2>&1 || die "gh not on PATH; cannot reply on $repo"

marker="<!-- garden-reply:$cid -->"

# --- idempotency: already replied to THIS comment? -> no-op -------------------
# List existing comment bodies on the same surface and look for our marker. A read
# failure fails OPEN toward NOT-already-replied only if it is a transient blip —
# but to avoid a double-reply on a flaky read we treat any nonzero read as "skip
# the post this tick" (the watcher re-polls): a missed reply is recoverable, a
# duplicate reply is the spiral we are guarding against.
case "$mode" in
  conversation) list_path="repos/$repo/issues/$pr/comments" ;;
  inline)       list_path="repos/$repo/pulls/$pr/comments" ;;
esac
existing="$(gh api --paginate "$list_path" --jq '.[].body' 2>/dev/null || printf '__READ_FAILED__')"
if [ "$existing" = "__READ_FAILED__" ]; then
  log "could not list existing replies on $list_path (transient); deferring reply to next poll"
  exit 0
fi
if printf '%s' "$existing" | grep -qF "$marker"; then
  log "already replied to $surface/$cid (marker present); no-op"
  exit 0
fi

# --- compose the body (caller text + the hidden idempotency marker) ----------
body="$(cat "$bf")"
body="$body

$marker"

case "$mode" in
  conversation)
    gh_api_retry -X POST "repos/$repo/issues/$pr/comments" -f body="$body" >/dev/null 2>&1 \
      || { log "reply POST failed on issues/$pr/comments (cid=$cid)"; exit 1; } ;;
  inline)
    gh_api_retry -X POST "repos/$repo/pulls/$pr/comments/$cid/replies" -f body="$body" >/dev/null 2>&1 \
      || { log "reply POST failed on pulls/$pr/comments/$cid/replies"; exit 1; } ;;
esac
log "replied on $surface/$cid (#$pr)"
