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
# drift). Posting the same reactji twice from one identity is a GitHub no-op, so
# the POST is idempotent and safe for gh_api_retry to re-issue: a TRANSIENT blip
# (5xx / 429 / DNS-TLS-reset) is ridden out under backoff rather than dropping the
# ack on a single flake, while a DEFINITIVE failure falls through to exit 1 (with a
# diagnostic WARN) — except a definitive 404 (deleted/absent target), which is a
# benign ack race classified as a silent skip (exit 0) below.
[ -n "${GARDEN_BOT_GH_TOKEN:-}" ] && export GH_TOKEN="$GARDEN_BOT_GH_TOKEN"
# Discard the success payload (>/dev/null) but CAPTURE gh_api_retry's stderr
# diagnostic — its rc, gh's response, and its definitive-vs-transient verdict —
# instead of dropping it with `2>&1` into the void. Order matters: `2>&1 >/dev/null`
# points stderr at the command-substitution pipe, then stdout at /dev/null, so the
# diagnostic is captured while the reaction payload is thrown away. `|| rc=$?`
# reads the rc without tripping `set -e`; a clean success leaves rc=0.
rc=0
reason="$(gh_api_retry -X POST "$path" -f content="$content" 2>&1 >/dev/null)" || rc=$?
if [ "$rc" -ne 0 ]; then
  # A DEFINITIVE 404 means the comment/issue was deleted between the mention and
  # this ack — a benign race, not a failure. Skip silently (exit 0, info log) so a
  # deleted-comment race stops masquerading as a WARN, and a real 403/permission
  # failure is the only thing that stands out. gh_api_retry has already ridden out
  # any transient blip under backoff, so a surviving 404 here is truly definitive.
  if printf '%s' "$reason" | grep -q 'HTTP 404'; then
    log "reactji target gone on $path (HTTP 404 — comment/issue deleted before ack); skipping"
    exit 0
  fi
  log "WARN: reactji POST failed on $path (rc=$rc): ${reason:-<no diagnostic>}"
  exit 1
fi
log "reacted $content on $surface ($repo ${cid:-#$number})"
