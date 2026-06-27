#!/bin/bash
# block-pr-comment-stub.sh — deterministic courtesy-comment poster for tests.
# Records each call (repo, num, base) to $BLOCK_PR_COMMENT_CALLS so the proxy's
# blocked-parking test can assert the PR-blocker courtesy comment fired exactly
# once, after the park landed, with the right arguments. Posts nothing.
set -euo pipefail
repo="${1:?repo}"; num="${2:?num}"; base="${3:?base}"
[ -n "${BLOCK_PR_COMMENT_CALLS:-}" ] && printf '%s\t%s\t%s\n' "$repo" "$num" "$base" >> "$BLOCK_PR_COMMENT_CALLS"
exit 0
