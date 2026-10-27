#!/bin/bash
# Hermetic gh surface for panel-review-submission-test.sh.
set -euo pipefail

case "${1:-} ${2:-}" in
  "api user")
    printf '%s\n' "${PANEL_GH_AUTH_LOGIN:?PANEL_GH_AUTH_LOGIN is required}"
    ;;
  "pr view")
    printf '%s\n' "${PANEL_GH_AUTHOR_LOGIN:?PANEL_GH_AUTHOR_LOGIN is required}"
    ;;
  "pr review")
    log="${PANEL_GH_LOG:?PANEL_GH_LOG is required}"
    body=""
    printf '%s\n' "$*" >> "$log"
    while [ "$#" -gt 0 ]; do
      case "$1" in
        --body-file) body="${2:?--body-file needs a path}"; shift 2 ;;
        *) shift ;;
      esac
    done
    [ -n "$body" ] || exit 2
    cp "$body" "${PANEL_GH_BODY:?PANEL_GH_BODY is required}"
    [ "${PANEL_GH_FAIL_REVIEW:-0}" != 1 ] || exit 1
    if [ "${PANEL_GH_FAIL_REVIEW:-0}" = 403 ]; then
      echo 'GraphQL: Resource not accessible by personal access token (addPullRequestReview)' >&2
      exit 1
    fi
    if [ "${PANEL_GH_FAIL_REVIEW:-0}" = ratelimit ]; then
      echo 'HTTP 403: You have exceeded a secondary rate limit' >&2
      exit 1
    fi
    ;;
  *)
    printf 'panel-review-submit-gh-stub: unexpected invocation: %s\n' "$*" >&2
    exit 2
    ;;
esac
