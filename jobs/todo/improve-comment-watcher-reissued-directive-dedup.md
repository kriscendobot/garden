---
role: fixer
---

# fixer (garden main2) — make the comment-watcher directive dedup distinguish a RE-ISSUED directive

## Problem (observed 2026-07-22)
A maintainer had to **manually relay** a "Shepherd." directive on
endojs/endo-but-for-bots#719 because the comment-watcher's dedup would collapse it
against the THREE already-completed #719 shepherd jobs in `jobs/tada/`. A directive
re-issued as a NEW comment must not be silently swallowed just because a prior
same-verb job for that PR already finished.

## First: reconcile with existing work — do NOT duplicate
`jobs/tada/fix-comment-watcher-verb-directive-tada-dedup.md` and
`improve-comment-watcher-review-fanout-dedup.md` already landed on `main2`
(currently UNDEPLOYED — the running watcher predates them). **Determine whether
those fixes already handle the re-issued-directive case.** If they do and the only
gap was that they are not yet deployed, say so plainly (the deploy resolves it) and
stop — do not re-fix.

## If a real gap remains: make it more sophisticated
The dedup must distinguish:
- **Same directive already handled** (same comment id / directive identity) → dedup,
  as today; vs
- **A NEW comment re-issuing a directive** (new comment id), even the same verb on
  the same PR whose prior job completed to `jobs/tada/` → this is a FRESH directive
  and MUST spawn a new job.
Key: dedup on the **directive identity (comment/review id)**, and treat a completed
`tada/` job for an OLDER identity as NOT a reason to swallow a new identity. Preserve
the genuine-duplicate protection (the #58 concurrent-producer collision) — the goal
is precision, not removing dedup. Land on `main2` (garden convention, no self-PR),
with a regression test covering "re-issued verb directive after a completed tada job
spawns a fresh job."

## Report
State whether the existing fixes already cover this (deploy-only) or a code change
was needed, with the commit sha + test evidence.

<!-- garden-reaped: 1 -->
