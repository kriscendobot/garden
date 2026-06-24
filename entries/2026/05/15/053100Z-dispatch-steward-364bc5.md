---
ts: 2026-05-15T05:31:00Z
kind: dispatch
role: steward
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 247
    role: target
---

# Dispatch: conductor merges PR #247 (`feat(eventual-send,eventual-send-test)`)

Dispatch root: `dispatches/conductor--364bc5/`. Project worktree on `endojs/endo-but-for-bots@feat/eventual-send-test`.

## Why now

User flagged a missed cue: PR #247 cleared the review-queue at 04:39:40Z (the REMOVE event the daemon emitted), which is the standing signal that kriskowal completed reviewing. State now: `reviewDecision: APPROVED`, `mergeable: MERGEABLE`, `isDraft: false`. The next-owed step is merge.

The pattern (REMOVE on review-queue + APPROVED state → conductor dispatch) is the canonical conductor-dispatch trigger; the autonomous steward missed it on the 04:39:40Z notification, treating REMOVE as informational. Going forward the standing-monitor reaction should recognize REMOVE-paired-with-APPROVED as a conductor cue.

## Per-action authorization

- `gh pr edit 247 -R endojs/endo-but-for-bots --title ... --body ...` if title/body refresh is owed per the maintainer's standing instructions for merge-commit-message readers (the precedent on #126 + #258).
- `gh pr merge 247 -R endojs/endo-but-for-bots --squash` (matches the repo's squash-merge convention).
- If the merge is blocked (workflow OAuth scope, etc.), post a comment naming the block — surface back to steward for liaison routing.

## Task

1. **Title and body refresh** per `skills/pr-formation/SKILL.md` (the merge-commit-message style the maintainer prefers). Conductor's call on the precise wording; the current title `feat(eventual-send,eventual-send-test): break devDep cycle via @endo/eventual-send-test (Cut 5 of #206 design)` is already concise — body may need trimming for forwarding artifacts.
2. **Merge.** `gh pr merge 247 --squash`. The merge commit's title and body are produced from the PR's title and body, which is the whole point of step 1.

## Out of scope

- No edit to the diff itself.
- No master-base mirror in this dispatch.
- No comment except in the OAuth-blocked failure case.

## Report

≤ 400 words. The refreshed title (if changed), 3-line summary of body changes (if any), merge result (commit SHA on llm), one-line `Self-improvement: ...`. If merge blocked, name the block.
