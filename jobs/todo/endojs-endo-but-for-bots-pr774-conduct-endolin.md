---
role: conductor
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Finalize (un-draft -> merge) endojs/endo-but-for-bots PR #774 (host-pinned handoff)

Handoff from job `endojs-endo-but-for-bots-pr774-conduct`, claimed on
oros-studio-garden-ce242c49. The bot PAT there gets 403 on PR writes to endojs
(`gh pr ready` → `markPullRequestReadyForReview` 403, verified 2026-10-22T07:3xZ), so it
cannot un-draft, retarget, or merge. This job is pinned to endolin.

PR: https://github.com/endojs/endo-but-for-bots/pull/774
("feat(parcel): add the first-wins Parcel shim and open API"), head
`build/sturdyref-shim-first-wins` @ dbd2b003e68f02d45ccc347ef8e25bb7dc03510e, base the frozen
snapshot `llm-863a995`, still DRAFT. At handoff it was OPEN, mergeable (CLEAN), and
reviewDecision APPROVED.

Authorization: kriskowal's APPROVED review on dbd2b003
(https://github.com/endojs/endo-but-for-bots/pull/774#pullrequestreview-5609838628),
"conduct and post a plan to build for the foreman to pick up on the parcel budget".
The plan half is DONE: `jobs/plan/ebfb-parcel-layer2-build-20261022.md` (Parcel layer 2,
#1391, arc `endo-ocapn-background`) is already parked. Do not post it again.

## Task (roles/conductor/AGENT.md)

1. Re-verify: still OPEN, approval not dismissed or superseded by CHANGES_REQUESTED. If it is
   already MERGED or CLOSED, do nothing.
2. Un-draft: `gh pr ready 774 -R endojs/endo-but-for-bots`.
3. From an isolated project worktree (`ensure-project-worktree.sh <this-base>
   endojs/endo-but-for-bots build/sturdyref-shim-first-wins`), run
   `scripts/jobs/gardening/ci-wait-merge.sh endojs/endo-but-for-bots 774`. It unfreezes
   `llm-863a995` → `llm`, rebases through safe-rebase, waits for CI on the resulting head,
   and merges with `--merge`. Its exit code is the outcome: 3 → stall `ci red: needs
   shepherd`, `needs-weave` → stall `needs weave`, 4 → re-enqueue.
4. Note: downstream draft #1391 is stacked on a snapshot of #774's head. The spine keeps the
   head branch if an open PR uses it as base. The parked layer-2 plan rebases #1391 after
   the merge.
