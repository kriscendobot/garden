---
role: weaver
---
# Refresh fork mirror #589 against canonical upstream endojs/endo#3312 (drop the closed dup #3318)

The retire-function-keyword work has two upstream PRs on `endojs/endo`: **#3312** (OPEN, canonical,
head `chore/retire-function-keyword`) and **#3318** (a boatman-created **duplicate**, head
`kriskowal-retire-function-keyword`, now **CLOSED** by the maintainer). Our fork mirror is
**endojs/endo-but-for-bots#589** ("refactor: retire function-keyword …", reconstruct of #474, head
`chore/retire-function-keyword-v2`, base `master-0594e99`). Refresh #589 so it tracks **#3312**,
not the closed #3318.

## Task
1. **Reconcile with #3312.** Treat upstream **endojs/endo#3312** as the canonical counterpart.
   Fetch its current head (`chore/retire-function-keyword`) and bring any upstream review changes it
   carries into #589's head, keeping #589's "re-applied to the current upstream master" approach
   (do NOT blindly cherry-pick #474's old commits). **Ignore #3318** — it is closed; if #589's body,
   links, or metadata reference #3318, repoint them to #3312. Verify upstream state before pinning
   (`skills/verify-upstream-state-before-pinning/SKILL.md`).
2. **Refresh onto a fresh frozen base** (`skills/frozen-base-branch/SKILL.md`). Snapshot the CURRENT
   upstream `master` as `master-<7-char-sha>`, push it to the fork, rebase #589's head onto it, and
   move #589's base field from `master-0594e99` to the new anchor. Do NOT target the moving `master`
   or recreate the mutable `master` (anchor branch only).
3. Keep #589 otherwise intact (title, draft state); push the refreshed head. Note any
   rebase/reconcile conflict resolution.

## Skills
`skills/frozen-base-branch/SKILL.md`, `skills/verify-upstream-state-before-pinning/SKILL.md`,
`skills/rebase-before-followup/SKILL.md`.

## Done
Fork #589 is reconciled with the latest canonical upstream `endojs/endo#3312`, rebased onto a fresh
frozen `master-<sha>` anchor (base field updated), with no lingering reference to the closed #3318.
The `tada` report links #3312 and #589, names the new frozen-base sha, and notes any conflicts.
