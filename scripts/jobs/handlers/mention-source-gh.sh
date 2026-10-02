#!/bin/bash
# mention-source-gh.sh — default mention source for mention-watcher.sh.
#
# Invoked as: mention-source-gh.sh <since-iso> <bot-login>
#
# Emits one TSV line per GitHub-wide @<bot> mention at or after <since-iso>,
# newest position last (ascending). The watcher applies the deterministic
# sender-trust gate and acts; this handler only fetches. Two complementary
# sources catch issue/PR/comment mentions across all repos:
#
#   notifications (reason==mention) → the canonical "you were @-mentioned"
#       stream; resolve each to its source comment (latest_comment_url) or, when
#       the mention is in the issue/PR body itself, the subject.url.
#   search/issues (q=mentions:<bot>) → issue/PR BODIES that @-mention the bot,
#       which notifications can miss if the bot is not subscribed.
#
# TSV columns (tab-separated, body single-lined):
#   created_at  surface  comment_id  repo  number  author  html_url  body
# surface ∈ issue-comment | pr-review-comment | issue-body | pr-body
#
# Monitoring safety: the watcher DROPS any mention whose author is not a verified
# trusted contributor BEFORE the body reaches `claude -p` or a job. This handler
# is therefore the only place untrusted text is fetched; it never reasons over it.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="mention-source"

since="${1:-}"; bot="${2:-kriscendobot}"

# Hard dependencies (this handler pipes `gh api | jq` to EXTERNAL jq). require_tools
# fails loudly + alerts the maintainer rather than letting a missing binary yield
# silent empty output — the 2026-06-24 comment-watcher failure mode.
require_tools gh jq

# Bound the query window: never look back more than 24h; on a cold start seed a
# modest 1h retroactive window so a just-left mention is still caught.
floor="$(date -u -d '-24 hours' +%FT%TZ 2>/dev/null || echo "$since")"
cold="$(date -u -d '-1 hour'   +%FT%TZ 2>/dev/null || echo "")"
[ -n "$since" ] || since="$cold"
if [ -n "$floor" ] && [ -n "$since" ] && [ "$since" \< "$floor" ]; then since="$floor"; fi

oneline='(.body // "") | gsub("[\t\r\n]+"; " ")'

# A host-shared gh-api cooldown (a primary-quota latch, or any rate-limit window)
# means EVERY further request this tick is refused NOT ISSUED or is doomed: stop the
# whole source at once with this distinct status instead of swallowing the failure
# and looking successful (2026-10-02T04:39:22: one latch → a NOT ISSUED warning per
# notification). mention-watcher.sh marks the heartbeat `cooldown` and skips quietly.
: "${GARDEN_MENTION_SOURCE_COOLDOWN_RC:=73}"

# src_api <gh-api-args…> — gh_api_retry, but a refusal/failure under a live cooldown
# exits the source with GARDEN_MENTION_SOURCE_COOLDOWN_RC. Any other failure returns
# gh's rc to the caller (a deleted comment's 404 is still skipped per row).
src_api() {
  local out rc
  if out="$(gh_api_retry "$@")"; then printf '%s' "$out"; return 0; else rc=$?; fi
  if api_cooldown_active rest; then exit "$GARDEN_MENTION_SOURCE_COOLDOWN_RC"; fi
  return "$rc"
}

# src_get <var> <gh-api-args…> — src_api into <var>; a command substitution is a
# subshell, so re-raise its cooldown exit here. Any other failure leaves <var> empty
# and returns 1 for the caller to skip (best-effort, as before).
src_get() {
  local __v="$1" __out __rc; shift
  if __out="$(src_api "$@")"; then printf -v "$__v" '%s' "$__out"; return 0; else __rc=$?; fi
  [ "$__rc" -ne "$GARDEN_MENTION_SOURCE_COOLDOWN_RC" ] || exit "$__rc"
  printf -v "$__v" '%s' ""; return 1
}

api_cooldown_active rest && exit "$GARDEN_MENTION_SOURCE_COOLDOWN_RC"

emit_comment() {  # emit_comment <repo> <surface> <number> <comment-api-url>
  local repo="$1" surface="$2" number="$3" curl="$4" json
  src_get json "$curl" || return 0
  printf '%s' "$json" | jq -r --arg repo "$repo" --arg surface "$surface" --arg n "$number" "
      [ .created_at, \$surface, (.id|tostring), \$repo, \$n, .user.login, .html_url, ($oneline) ]
      | @tsv" 2>/dev/null || true
}

emit_subject() {  # emit_subject <repo> <subject-type> <subject-api-url>
  local repo="$1" stype="$2" surl="$3" surface json
  case "$stype" in PullRequest) surface=pr-body;; *) surface=issue-body;; esac
  src_get json "$surl" || return 0
  printf '%s' "$json" | jq -r --arg repo "$repo" --arg surface "$surface" "
      [ (.created_at // .updated_at), \$surface, (.number|tostring), \$repo,
        (.number|tostring), .user.login, .html_url, ($oneline) ]
      | @tsv" 2>/dev/null || true
}

# 1) notifications (reason==mention). `since` filters by updated time; `all=true`
#    so a read mention is still resolved (the cursor, not the read flag, dedups).
#    Fetched up front (not piped into the loop) so a cooldown exit from src_api in a
#    row lookup ends the source itself rather than only a pipeline subshell.
#    Any other notifications failure stays fatal, as it was through pipefail.
notes="$(src_api --paginate "notifications?all=true&since=${since}&per_page=100")" || {
  rc=$?; exit "$rc"; }
rows="$(printf '%s' "$notes" | jq -r '.[] | select(.reason=="mention")
            | [ .repository.full_name, .subject.type,
                (.subject.latest_comment_url // ""), (.subject.url // "") ] | @tsv' 2>/dev/null || true)"
while IFS=$'\t' read -r repo stype lcu surl; do
      [ -n "$repo" ] || continue
      number="$(printf '%s' "$surl" | grep -oE '[0-9]+$' || true)"
      if [ -n "$lcu" ]; then
        case "$lcu" in
          *"/pulls/comments/"*)  emit_comment "$repo" pr-review-comment "$number" "$lcu";;
          *"/issues/comments/"*) emit_comment "$repo" issue-comment     "$number" "$lcu";;
          *)                     emit_comment "$repo" issue-comment     "$number" "$lcu";;
        esac
      elif [ -n "$surl" ]; then
        emit_subject "$repo" "$stype" "$surl"
      fi
done <<<"$rows"

# 2) search API: issue/PR BODIES that @-mention the bot (notifications can miss a
#    body mention if the bot is not subscribed to the thread).
src_get search --paginate "search/issues?q=mentions:${bot}+updated:>=${since}&per_page=100" || true
printf '%s' "$search" | jq -r --arg s "$since" "
      .items // [] | .[]
      | select((.created_at // \"\") >= \$s)
      | [ .created_at,
          (if .pull_request then \"pr-body\" else \"issue-body\" end),
          (.number|tostring),
          (.repository_url | sub(\"https://api.github.com/repos/\"; \"\")),
          (.number|tostring),
          .user.login, .html_url, ($oneline) ] | @tsv" 2>/dev/null || true
