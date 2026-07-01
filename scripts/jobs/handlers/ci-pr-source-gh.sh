#!/bin/bash
# ci-pr-source-gh.sh — default open-PR source for ci-watcher.sh.
#
# Invoked as: ci-pr-source-gh.sh <owner/name> [<bot-login>]
#
# Emits one TSV line per OPEN pull request on the repo:
#
#   pr_number  author_login  head_repo_full_name  updated_at
#
# The watcher applies the author==bot and head-branch-pushable gates itself (kept
# in the watcher, not here, so the test exercises them directly against a fixture
# of mixed-author PRs). This handler only enumerates.
#
# AUTHORITATIVE enumeration, never a default page cap. `gh pr list` (no --limit)
# returns only the 30-most-recent open PRs via the search API — the #284 blindness
# where an older open PR is silently dropped from surveillance. We use the paginated
# REST list (`repos/<repo>/pulls?state=open --paginate`), which returns EVERY open
# PR. The result is small in practice (the watcher only acts on the bot's own open
# PRs), so no activity bound is needed; enumerating all open PRs each tick is cheap
# and lets the watcher's own idempotency (post-job basename) keep re-ticks a no-op.
#
# Monitoring safety: this handler reads only PR metadata (number, author, head repo,
# timestamp) — NEVER a PR body, title, or comment — and none of it is fed to an LLM.
# The watcher's job body is deterministic. So unlike the comment source, no untrusted
# text reaches `claude -p`; the ci-watcher is injection-safe by construction. It is
# still gated to the cleared comment-repos/ set for defence in depth (see
# ci-watcher.sh header).
#
# Silent-failure discipline (the 2026-06-24 jq-outage lesson): require_tools fails
# LOUD on a missing binary; a structural gh failure surfaces its stderr and exits
# nonzero so the watcher never mistakes a broken enumeration for "no open PRs".

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="ci-pr-source"

repo="${1:?usage: ci-pr-source-gh.sh <owner/name> [<bot-login>]}"
# bot login is accepted for symmetry with the other sources but the author gate
# lives in the watcher; this handler emits every open PR's author for it to filter.
: "${2:-}"

require_tools gh jq

# The authoritative paginated open-PR list. A structural failure here must NOT be
# swallowed into an empty list (which would read as "no open PRs" and silently stop
# every shepherd) — surface gh's stderr and exit nonzero so the watcher dies loud.
gh_api_retry --paginate "repos/$repo/pulls?state=open&per_page=100" \
  | jq -r '.[]
      | [ (.number|tostring),
          (.user.login // ""),
          (.head.repo.full_name // ""),
          (.updated_at // "") ]
      | @tsv'
