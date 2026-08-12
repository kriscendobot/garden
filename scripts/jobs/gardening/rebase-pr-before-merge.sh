#!/bin/bash
# rebase-pr-before-merge.sh — establish that the exact remote PR head contains
# the freshly fetched live base before ci-wait-merge.sh accepts CI or merges.
#
# Usage: rebase-pr-before-merge.sh <owner/name> <pr-number> <project-worktree>
#
# stdout is reserved for the resulting head OID. Diagnostics go to stderr.
# Exit 3 is safe-rebase.sh's fail-closed conflict refusal (`needs weave`); exit 1
# is an operational or worktree-state refusal. A changed head is published only
# through safe-push-pr-head.sh's fresh, exact force-with-lease rewrite mode.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
export GARDEN_TAG="rebase-pr-before-merge"

repo="${1:?usage: rebase-pr-before-merge.sh <owner/name> <pr-number> <project-worktree>}"
pr="${2:?pr number}"
wt="${3:?project worktree}"

GH=gh
if [ -n "${GARDEN_GH:-}" ] && { [ -x "$GARDEN_GH" ] || command -v "$GARDEN_GH" >/dev/null 2>&1; }; then
  GH="$GARDEN_GH"
fi
require_tools "$GH" git jq

: "${GARDEN_SAFE_REBASE:=$HERE/safe-rebase.sh}"
: "${GARDEN_SAFE_PUSH:=$HERE/safe-push-pr-head.sh}"
head_remote="${GARDEN_PR_REMOTE:-origin}"
base_remote="${GARDEN_BASE_REMOTE:-origin}"

meta="$("$GH" pr view "$pr" -R "$repo" \
  --json state,baseRefName,headRefName,headRefOid 2>/dev/null)" \
  || { echo "rebase-before-merge: cannot read live PR metadata for $repo#$pr" >&2; exit 1; }
printf '%s' "$meta" | jq -e . >/dev/null 2>&1 \
  || { echo "rebase-before-merge: unparseable live PR metadata for $repo#$pr" >&2; exit 1; }
state="$(printf '%s' "$meta" | jq -r '.state // ""')"
base="$(printf '%s' "$meta" | jq -r '.baseRefName // ""')"
head_branch="$(printf '%s' "$meta" | jq -r '.headRefName // ""')"
remote_head="$(printf '%s' "$meta" | jq -r '.headRefOid // ""')"

# ci-wait-merge.sh handles terminal states idempotently. Do not require a
# project checkout merely to observe that a prior invocation already merged.
if [ "$state" != OPEN ]; then
  # The wait loop exits on state before comparing this sentinel. A deleted head
  # branch may make headRefOid empty after merge/close; keep the stdout contract
  # valid without touching a worktree for an already-terminal PR.
  printf '%040d\n' 0
  exit 0
fi

if [ -z "$base" ] || [ -z "$head_branch" ] || [[ ! "$remote_head" =~ ^[0-9a-fA-F]{40}$ ]]; then
  echo "rebase-before-merge: incomplete base/head metadata for $repo#$pr" >&2
  exit 1
fi
if [[ "$base" =~ ^(llm|main|master)-[0-9a-f]{4,40}$ ]]; then
  echo "rebase-before-merge: REFUSED — base '$base' is still frozen; unfreeze-to-live did not complete" >&2
  exit 1
fi

git -C "$wt" rev-parse --git-dir >/dev/null 2>&1 \
  || { echo "rebase-before-merge: $wt is not a project git worktree" >&2; exit 1; }
if [ -n "$(git -C "$wt" status --porcelain 2>/dev/null)" ]; then
  echo "rebase-before-merge: REFUSED — project worktree is dirty; preserving local work" >&2
  exit 1
fi

# Synchronize only by a clean fast-forward to the exact remote PR head. A local
# ahead/diverged head may contain another worker's unpublished work, so it is not
# overwritten or guessed through.
git -C "$wt" fetch --quiet "$head_remote" "refs/heads/$head_branch" \
  || { echo "rebase-before-merge: fetch $head_remote/$head_branch failed" >&2; exit 1; }
fetched_head="$(git -C "$wt" rev-parse FETCH_HEAD)"
if [ "$fetched_head" != "$remote_head" ]; then
  echo "rebase-before-merge: REFUSED — git head ${fetched_head:0:11} and GitHub head ${remote_head:0:11} disagree" >&2
  exit 1
fi
local_head="$(git -C "$wt" rev-parse HEAD)"
if [ "$local_head" != "$remote_head" ]; then
  if git -C "$wt" merge-base --is-ancestor "$local_head" "$remote_head"; then
    git -C "$wt" merge --ff-only --quiet "$remote_head" \
      || { echo "rebase-before-merge: could not fast-forward worktree to the live PR head" >&2; exit 1; }
  else
    echo "rebase-before-merge: REFUSED — local HEAD ${local_head:0:11} is ahead of or diverged from live PR head ${remote_head:0:11}; preserving local work" >&2
    exit 1
  fi
fi

before="$(git -C "$wt" rev-parse HEAD)"
rebase_rc=0
GARDEN_BASE_REMOTE="$base_remote" GARDEN_BASE_BRANCH="$base" \
  "$GARDEN_SAFE_REBASE" "$wt" "$base" >&2 || rebase_rc=$?
case "$rebase_rc" in
  0) ;;
  3) exit 3 ;;
  *) echo "rebase-before-merge: safe rebase failed for $repo#$pr (rc=$rebase_rc)" >&2; exit 1 ;;
esac
after="$(git -C "$wt" rev-parse HEAD)"

if [ "$after" != "$before" ]; then
  push_rc=0
  "$GARDEN_SAFE_PUSH" --mode rewrite "$wt" "$head_remote" "$head_branch" >&2 || push_rc=$?
  [ "$push_rc" -eq 0 ] \
    || { echo "rebase-before-merge: rewritten head was not published (rc=$push_rc)" >&2; exit 1; }
  echo "rebase-before-merge: published rebased head ${before:0:11} -> ${after:0:11}" >&2
fi

printf '%s\n' "$after"
