#!/bin/bash
# Hermetic gh surface for gauntlet-test.sh's terminal PR status comments.
set -euo pipefail

comments_dir="${GAUNTLET_GH_COMMENTS:?GAUNTLET_GH_COMMENTS is required}"
mkdir -p "$comments_dir"

case "${1:-} ${2:-}" in
  "api --paginate")
    if [ -e "${GAUNTLET_GH_FAIL_READS_FILE:-/nonexistent}" ]; then
      printf 'gh: Not Found (HTTP 404)\n' >&2
      exit 1
    fi
    # gauntlet.sh asks gh's --jq to print only each top-level comment body. The
    # fixture stores exactly those bodies, so replaying the files is equivalent.
    find "$comments_dir" -maxdepth 1 -type f -name '*.md' -print0 2>/dev/null \
      | sort -z | xargs -0 -r cat
    ;;
  "pr view")
    pr="${3:-0}"
    printf '{"headRefOid":"%040d","statusCheckRollup":[{"status":"COMPLETED","conclusion":"SUCCESS"}]}\n' "$pr"
    ;;
  "pr comment")
    [ ! -e "${GAUNTLET_GH_FAIL_WRITES_FILE:-/nonexistent}" ] || exit 1
    body=""
    while [ "$#" -gt 0 ]; do
      case "$1" in
        --body-file) body="${2:?--body-file needs a path}"; shift 2;;
        *) shift;;
      esac
    done
    [ -n "$body" ] || exit 2
    next="$(find "$comments_dir" -maxdepth 1 -type f -name '*.md' 2>/dev/null | wc -l)"
    cp "$body" "$comments_dir/comment-$next.md"
    # Record whether the post was declared machine-authored (comment-provenance.sh
    # § AUTOMATIC) so the test can pin that it never trips the provenance-gap alert.
    printf '%s\n' "${GARDEN_NO_LLM:-unset}" > "$comments_dir/comment-$next.nollm"
    ;;
  *)
    printf 'gauntlet-gh-stub: unexpected invocation: %s\n' "$*" >&2
    exit 2
    ;;
esac
