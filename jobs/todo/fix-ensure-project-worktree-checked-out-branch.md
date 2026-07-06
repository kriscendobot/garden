---
role: fixer
---

# Fix: ensure-project-worktree.sh hard-fails when the requested branch is checked out in a standing worktree

**Symptom (observed 2026-07-06, job design-ebfb-buffered-channel-exo-stream-consolidation):**
`scripts/jobs/ensure-project-worktree.sh <base> endojs/endo-but-for-bots llm`
dies every time with "could not fetch endojs/endo-but-for-bots@llm ...
refusing to hand back a stale tree". This is NOT transient: it blocks every
job that needs an llm-branch checkout on this host.

**Root cause:** the script's fetch_branch does
`git fetch origin '+refs/heads/llm:refs/heads/llm'`, but `refs/heads/llm` is
checked out at the standing monitor worktree
`/home/kris/worktrees/endojs-endo-but-for-bots/watch-endo-but-for-bots--monitor--20260512-233307`,
so git refuses: "fatal: refusing to fetch into branch 'refs/heads/llm'
checked out at ...". The error is swallowed by 2>/dev/null; the (correct)
stale-tree guard added in main2 commit 5df0a675d then sees the stale local
head and dies. The guard turned a silent 8-week-stale checkout into a
deterministic failure, which is right; but the fetch strategy must not
require updating a ref that a standing worktree can legitimately hold.

**Suggested fix:** fetch into the remote-tracking ref instead and check the
worktree out from THAT: fetch `+refs/heads/$branch:refs/remotes/origin/$branch`,
verify `refs/remotes/origin/$branch` against `ls-remote`, and
`git worktree add --detach "$wt" refs/remotes/origin/$branch` (when
`$ref` == `$branch`; an explicit SHA/ref argument keeps its current path).
Remote-tracking refs are never checked out, so the force-update always
succeeds, and detached adds do not need a local head. Also drop or log the
fetch's stderr instead of discarding it, so the next failure mode is visible.
Keep the stale-tree guard; re-point it at the ref actually used for the add.
Update test/project-worktree-isolation-test.sh to cover a branch held
checked-out by another worktree.

**Workaround used meanwhile (for reference):** fetch to
refs/remotes/origin/llm, verify against ls-remote, `worktree add --detach`
at the verified SHA, pin bot identity — the same shape the fix should encode.
