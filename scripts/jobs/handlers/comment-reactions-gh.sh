#!/bin/bash
# Print the GitHub created_at of the bot's earliest eyes reaction on one object.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"

repo="${1:?repo required}"
surface="${2:?surface required}"
id="${3:?comment id required}"
number="${4:?issue or pull number required}"
bot="${5:-kriscendobot}"

case "$surface" in
  issue|issue-body|pr-body) endpoint="repos/$repo/issues/$number/reactions" ;;
  issue-comment|pr-comment) endpoint="repos/$repo/issues/comments/$id/reactions" ;;
  pr-review-comment) endpoint="repos/$repo/pulls/comments/$id/reactions" ;;
  *) exit 0 ;;
esac

gh_api_retry --paginate -H 'Accept: application/vnd.github+json' "$endpoint?per_page=100" \
  | jq -rs --arg bot "$bot" '
      [ .[][]
        | select((.user.login // "" | ascii_downcase) == ($bot | ascii_downcase))
        | select(.content == "eyes")
        | .created_at ] | sort | .[0] // empty'
