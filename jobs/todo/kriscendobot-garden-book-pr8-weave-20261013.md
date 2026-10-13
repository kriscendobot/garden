---
role: weaver
tier: mentor
fallback-tier: minion
arc: garden-book
dispatch: automatic
---
# Weave kriscendobot/garden-book PR #8 onto live main (resolve the chapter 8 conflict)

Repo: kriscendobot/garden-book. PR: https://github.com/kriscendobot/garden-book/pull/8 (copy-edit for reader exposure).

Maintainer (kriskowal, liaison session 2026-10-13) approved this: weave #8 onto live `main`, resolving the conflict in `chapters/ch8-cybernetics-budgeting.md`.

State: the conductor `kriscendobot-garden-book-pr8-conduct-20261012` tidied the PR to head `2721125` (byte-identical to the reviewed `04a5b7e`) and retargeted it from frozen `main-e6f2790` to live `main`, then refused to merge: the PR is CONFLICTING/DIRTY because live main carries newer illumination, data and equilibrium work in chapter 8 (PR #11, #12).

Rule for the resolution: **where the copy-edit and the newer chapter 8 text overlap, the newer text wins.** Re-apply the copy-edit's intent (introduce terms once, foreground consequences) around it only where it does not change the newer substance. Do not drop any newer figure, data table or illumination. Rebase onto live `main` (the base is already live main, so no frozen-base snapshot is needed); force-push the head with lease.

Verify: `npm test`, `npm run build`, `git diff --check`. Report the conflict hunks and how each was resolved, in the PR as a comment.

Do not merge. Do not start a gauntlet. Substantive resolution needs fresh review: the liaison will release the parked mentat supervisor `garden-book-review-supervisor-after-merge-20261012` once this completes. Be economical (claude-endolin1 is high; maintainer asked the fleet to slow down).
