#!/bin/bash
# Reverify and close one unchanged, proven Dependabot Node-engine conflict.
# rc 0: fixed verdict posted, PR closed, terminal result journaled
# rc 1: live PR/proof changed or became unreadable; caller falls back to botanist
# rc 75: the proof remains exact but an outward action failed; caller defers

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
export GARDEN_TAG=dependabot-engine-close GARDEN_NO_LLM=1

repo="${1:?repo required}"; pr="${2:?pr required}"; pkg="${3:?package required}"
old="${4:?old version required}"; new="${5:?new version required}"
floor="${6:?floor required}"; declared="${7:?declared range required}"
required="${8:?required range required}"; path="${9:?manifest path required}"
project="${10:?project required}"
: "${GARDEN_BOT_LOGIN:=kriscendobot}"
: "${GARDEN_DEPENDABOT_LOGIN:=dependabot[bot]}"
: "${GARDEN_DEPB_COMPAT:=$HERE/dep-compat-gh.sh}"
: "${GARDEN_DEPB_JOURNAL_RESULT:=$HERE/../journal-entry.sh}"
gh_bin="${GARDEN_GH:-gh}"

case "$repo" in endojs/endo-but-for-bots|"$GARDEN_BOT_LOGIN"/*) ;; *) exit 1;; esac
case "$pr" in ''|*[!0-9]*) exit 1;; esac

# Re-fetch immediately before acting. Do not trust the earlier roster: the head,
# title, author, or state may have changed between the two observations.
doc="$(gh_api_retry "repos/$repo/pulls/$pr" 2>/dev/null)" || exit 1
state="$(printf '%s' "$doc" | jq -r '.state // empty')"
author="$(printf '%s' "$doc" | jq -r '.user.login // empty')"
title="$(printf '%s' "$doc" | jq -r '.title // empty')"
[ "$state" = open ] || [ "$state" = closed ] || exit 1
[ "$state" = closed ] && already_closed=1 || already_closed=0
[ "$already_closed" -eq 1 ] || {
[ "$(printf '%s' "$author" | tr '[:upper:]' '[:lower:]')" = "$(printf '%s' "$GARDEN_DEPENDABOT_LOGIN" | tr '[:upper:]' '[:lower:]')" ] || exit 1
[[ "$title" =~ ^[A-Za-z]+(\([A-Za-z0-9_./-]*\))?!?:[[:space:]]+(.*)$ ]] && title="${BASH_REMATCH[2]}"
[[ "$title" =~ ^[Bb]ump[[:space:]]+([^[:space:]]+)[[:space:]]+from[[:space:]]+([^[:space:]]+)[[:space:]]+to[[:space:]]+([^[:space:]]+)([[:space:]].*)?$ ]] || exit 1
[ "${BASH_REMATCH[1]}" = "$pkg" ] && [ "${BASH_REMATCH[2]}" = "$old" ] && [ "${BASH_REMATCH[3]}" = "$new" ] || exit 1

proof="$("$GARDEN_DEPB_COMPAT" "$repo" "$pr" "$pkg" "$new" 2>/dev/null)" || exit 1
[ "$proof" = "incompatible"$'\t'"node"$'\t'"$floor"$'\t'"$declared"$'\t'"$required"$'\t'"$path" ] || exit 1
}

tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
marker="<!-- garden-dependabot-engine-close:$repo#$pr:$pkg@$new -->"
{
  printf 'REJECT (incompatible). `%s` declares Node `%s` (supported floor `%s`), while `%s` %s requires Node `%s`; the dependency excludes the project-supported floor.\n\n' \
    "$path" "$declared" "$floor" "$pkg" "$new" "$required"
  printf 'This was reverified against the live Dependabot head during this deterministic close attempt. Reopen if either declaration changes.\n\n%s\n' "$marker"
} > "$tmp/comment"

# Keep retries idempotent across a comment-success/close-failure split. The
# comment is best-effort: authorization can differ between issue comments and PR
# lifecycle writes, so a 403 must not suppress the terminal close.
comment_status=skipped-already-closed
comment_error=""
if [ "$already_closed" -eq 0 ]; then
  comment_status=already-present
  comments="$(gh_api_retry --paginate "repos/$repo/issues/$pr/comments?per_page=100" 2>"$tmp/comment-read.err")" || comments=""
  if ! printf '%s' "$comments" | jq -se --arg m "$marker" 'any(.[][]; (.body // "") | contains($m))' >/dev/null; then
    comment_status=posted
    if ! "$gh_bin" pr comment "$pr" -R "$repo" --body-file "$tmp/comment" >/dev/null 2>"$tmp/comment-write.err"; then
      comment_status=failed
      comment_error="$(tr '\n' ' ' < "$tmp/comment-write.err" | head -c 500)"
    fi
  fi

  "$gh_bin" pr close "$pr" -R "$repo" >/dev/null || exit "${GARDEN_TRANSIENT_RC:-75}"
fi

{
  printf 'project: %s\nrepo: %s\npr: %s\ndependabotany-terminal-pr: %s\n' "$project" "$repo" "$pr" "$pr"
  printf 'comment-status: %s\nclose-status: closed\n\n' "$comment_status"
  printf '# Dependabotany deterministic result: %s#%s — REJECT incompatible\n\n' "$repo" "$pr"
  printf 'Fixed REJECT (incompatible) for `%s` %s -> %s after a second live-head revalidation reproduced the exact Node-engine conflict: `%s` declares `%s` (floor `%s`), while the target requires `%s`. The deterministic close is authorized and retried on an outward-action failure; no botanist review is dispatched.\n' \
    "$pkg" "$old" "$new" "$path" "$declared" "$floor" "$required"
  [ -z "$comment_error" ] || printf 'The verdict comment failed non-fatally: %s\n' "$comment_error"
} > "$tmp/result"
GARDEN_ROLE=dependabotany-preflight "$GARDEN_DEPB_JOURNAL_RESULT" result "$tmp/result" >/dev/null \
  || exit "${GARDEN_TRANSIENT_RC:-75}"
