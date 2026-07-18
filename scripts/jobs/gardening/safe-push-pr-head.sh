#!/bin/bash
# safe-push-pr-head.sh — push a project PR's head branch WITHOUT ever rewinding a
# peer's newer commits.
#
# The hazard (endojs/endo-but-for-bots #792, 2026-07-18): a shepherd pushed CI
# fixes (head 6e9937cd66d, green). The gauntlet then claimed the PR, worked from a
# worktree that PREDATED those commits, and finished with a plain `git push
# --force` that rewound the head to a strict ANCESTOR (a510ee6) — silently
# discarding the shepherd's two fix commits. CI went red, the conductor declined,
# and the arc stalled until a manual fast-forward restore.
#
# This helper closes that hole deterministically, in plain code, BEFORE any push:
#
#   1. Fetch the remote head FRESH. A lease against a worktree's stale
#      remote-tracking ref can rot into a lie; a lease only guards when it names a
#      just-fetched sha (that stale ref, incidentally, is exactly why a plain
#      --force-with-lease from the #792 worktree would ALSO have rejected the
#      push — but we make the fetch explicit so the guard cannot rot).
#   2. Compare our outgoing HEAD to the live head by ANCESTRY:
#        * HEAD == live head      -> already up to date; nothing to push.
#        * live head reachable    -> our HEAD already CONTAINS the live head
#          from HEAD                (fast-forward, or we rebased the peer's commits
#                                    under ours) -> the push adds, never rewinds.
#        * HEAD reachable from    -> our HEAD is STRICTLY BEHIND the live head:
#          live head                pushing it can ONLY rewind. REFUSE in every
#                                    mode. This is the #792 bug case.
#        * diverged (neither)     -> advance mode REFUSES (rebase onto the live
#                                    head first); rewrite mode allows it.
#   3. Push with --force-with-lease=<branch>:<freshly-fetched-live-sha> so even a
#      peer landing a commit in the fetch->push window is rejected by git, not
#      clobbered.
#
# Modes:
#   advance  (default) history-PRESERVING. For the gauntlet's fixer/cleaner/
#            assayer follow-up pushes, which only ADD commits on top of the live
#            head. Refuses a behind OR diverged head — the caller must rebase onto
#            the live head and re-run, never force over it.
#   rewrite  history-REWRITING (rebase/retcon/weave). A diverged head is expected
#            and allowed, but a strictly-BEHIND head (ours is an ancestor of live)
#            is STILL refused: pushing an ancestor can only rewind.
#
# Usage: safe-push-pr-head.sh [--mode advance|rewrite] <worktree> <remote> <branch>
# Exit:  0 pushed (or already up to date); 3 refused (caller must rebase onto the
#        live head); 1 usage/operational error.

set -euo pipefail

mode=advance
while [ "$#" -gt 0 ]; do
  case "$1" in
    --mode) mode="${2:?--mode needs a value}"; shift 2 ;;
    --mode=*) mode="${1#--mode=}"; shift ;;
    --) shift; break ;;
    -*) echo "safe-push-pr-head: unknown option $1" >&2; exit 1 ;;
    *) break ;;
  esac
done
case "$mode" in advance|rewrite) ;; *) echo "safe-push-pr-head: bad --mode '$mode' (advance|rewrite)" >&2; exit 1 ;; esac

wt="${1:?usage: safe-push-pr-head.sh [--mode advance|rewrite] <worktree> <remote> <branch>}"
remote="${2:?remote}"
branch="${3:?head branch}"

git() { command git -C "$wt" "$@"; }   # every git op is against the worktree

head="$(git rev-parse HEAD)" || { echo "safe-push-pr-head: no HEAD in $wt" >&2; exit 1; }

# --- 1. does the remote branch even exist? ----------------------------------
# A brand-new head has nothing to rewind; a plain push creates it (and still fails
# closed if a racing peer created it first, since a create is not a fast-forward).
if [ -z "$(git ls-remote "$remote" "refs/heads/$branch" 2>/dev/null)" ]; then
  git push "$remote" "HEAD:refs/heads/$branch"
  echo "safe-push-pr-head: created $remote/$branch at ${head:0:11}"
  exit 0
fi

# --- 1b. fetch the live head FRESH (the lease is only honest against this) ----
git fetch --quiet "$remote" "refs/heads/$branch" || { echo "safe-push-pr-head: fetch $remote $branch failed" >&2; exit 1; }
live="$(git rev-parse FETCH_HEAD)" || { echo "safe-push-pr-head: cannot read FETCH_HEAD" >&2; exit 1; }

# --- 2. ancestry gate -------------------------------------------------------
if [ "$head" = "$live" ]; then
  echo "safe-push-pr-head: $remote/$branch already at ${head:0:11}; nothing to push"
  exit 0
fi

# Our HEAD is strictly BEHIND the live head (HEAD is an ancestor of live): pushing
# it — even with force — can only REWIND the peer's newer commits. This is the
# #792 defect; refuse in EVERY mode.
if git merge-base --is-ancestor "$head" "$live"; then
  cat >&2 <<EOF
safe-push-pr-head: REFUSED — outgoing HEAD ${head:0:11} is an ANCESTOR of the live
  $remote/$branch head ${live:0:11}; pushing would rewind newer commits. Fetch and
  rebase/restart onto the live head, then re-run. (This is the endo-but-for-bots
  #792 branch-rewind hazard.)
EOF
  exit 3
fi

# The live head is reachable from our HEAD: we already contain it (fast-forward or
# a rebase of the peer's commits under ours). The push adds, never rewinds.
if git merge-base --is-ancestor "$live" "$head"; then
  git push --force-with-lease="refs/heads/$branch:$live" "$remote" "HEAD:refs/heads/$branch"
  echo "safe-push-pr-head: advanced $remote/$branch ${live:0:11} -> ${head:0:11}"
  exit 0
fi

# Diverged: neither head reaches the other.
if [ "$mode" = advance ]; then
  cat >&2 <<EOF
safe-push-pr-head: REFUSED — outgoing HEAD ${head:0:11} has DIVERGED from the live
  $remote/$branch head ${live:0:11} (neither contains the other). In advance mode
  the gauntlet must rebase onto the live head before pushing, not force over it.
EOF
  exit 3
fi

# rewrite mode: a divergent, history-rewriting push is intended (rebase/retcon).
# The lease against the fresh live sha still guards the fetch->push window.
git push --force-with-lease="refs/heads/$branch:$live" "$remote" "HEAD:refs/heads/$branch"
echo "safe-push-pr-head: rewrote $remote/$branch ${live:0:11} -> ${head:0:11}"
exit 0
