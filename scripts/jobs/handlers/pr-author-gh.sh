#!/bin/bash
# pr-author-gh.sh — look up the AUTHOR login of a PR or issue.
#
# Invoked as: pr-author-gh.sh <owner/name> <number>
#
# Echoes the author's GitHub login on stdout (empty on any failure). Used by
# comment-watcher.sh's MENTION-ONLY PR-author filter to decide whether feedback
# on a listed contributor's PR/issue should be dropped. PRs ARE issues in the
# GitHub REST API, so the issues endpoint resolves the author for both surfaces.
#
# Like the silent-watcher anomaly probe, this uses gh's BUILT-IN `--jq` (not the
# external jq the comment source pipes to), so it stays one fewer dependency on
# the path that decides whether to act. require_tools fails LOUDLY if gh is gone.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="pr-author"

repo="${1:?owner/name}"; num="${2:?pr-or-issue number}"
require_tools gh

# `2>/dev/null`: a 404 (deleted/transferred) or a transient blip yields an empty
# login, which the caller treats as "author unknown → not mention-only" (fail
# open to UNCHANGED behavior, never silently mention-only-suppress on an error).
gh api "repos/$repo/issues/$num" --jq '.user.login // ""' 2>/dev/null || true
