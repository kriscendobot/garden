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
    [ -z "${GAUNTLET_GH_READS_LOG:-}" ] || printf '%s\n' "$*" >> "$GAUNTLET_GH_READS_LOG"
    # gauntlet.sh asks gh's --jq to print only each top-level comment body. The
    # fixture stores exactly those bodies, so replaying the files is equivalent.
    find "$comments_dir" -maxdepth 1 -type f -name '*.md' -print0 2>/dev/null \
      | sort -z | xargs -0 -r cat
    ;;
  "pr view")
    pr="${3:-0}"
    [ ! -e "${GAUNTLET_GH_FAIL_VIEWS_FILE:-/nonexistent}" ] || exit 1
    if [ -s "${GAUNTLET_GH_HEAD_FILE:-/nonexistent}" ]; then
      head_oid="$(cat "$GAUNTLET_GH_HEAD_FILE")"
    else
      head_oid="$(printf '%040d' "$pr")"
    fi
    if [ -s "${GAUNTLET_GH_DRAFT_FILE:-/nonexistent}" ]; then
      is_draft="$(cat "$GAUNTLET_GH_DRAFT_FILE")"
    else
      is_draft=false
    fi
    # GAUNTLET_GH_BODY_FILE supplies the PR body (the phase/evidence ledger the
    # driver reads after a passing panel); absent, the body is empty.
    body_text=""
    [ ! -s "${GAUNTLET_GH_BODY_FILE:-/nonexistent}" ] || body_text="$(cat "$GAUNTLET_GH_BODY_FILE")"
    jq -cn --arg head "$head_oid" --argjson draft "$is_draft" --arg body "$body_text" \
      '{headRefOid: $head, isDraft: $draft, body: $body,
        statusCheckRollup: [{status: "COMPLETED", conclusion: "SUCCESS"}]}'
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
