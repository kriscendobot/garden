---
ts: 2026-06-14T10:57:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: appellate
dispatch_root: /home/kris/dispatches/appellate--00fab2
prs:
  - repo: endojs/endo-but-for-bots
    pr: 440
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/440
  - https://github.com/endojs/endo-but-for-bots/pull/440#pullrequestreview-4492801941
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/14/105230Z-result-justice-1eed16.md
---

# dispatch: appellate — PR #440 round 2 terminating verdict

Justice `1eed16` round 2 terminated the code-panel chain on PR #440:
**0 must-fix-loop, 1 summary-fix, 1 follow-up, 5 acknowledge, 0 drop**. Per the appellate's default policy (run on every terminating round before un-draft), audit the 1 follow-up + 5 acknowledge items for any small-and-in-context items that should be promoted to summary-fix.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#440`, DRAFT, base `llm`, head `93b399160`.
- **Justice round-2 verdict**: https://github.com/endojs/endo-but-for-bots/pull/440#pullrequestreview-4492801941
- **Existing summary-fix job**: `journal/jobs/open/20260614T105226Z--ea095b--endo-but-for-bots-440-r2-summary-fix.md` (registry-host alignment with daemon's rewritten host case).
- **Followup ledger**: `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--440.md` (6 items now: 5 from round 1 + 1 from round 2).

## Task

In your `project/` worktree at `93b399160`:

1. Read the justice's `result` entry (`105230Z-result-justice-1eed16.md`) and the COMMENTED review body.
2. Read the followup ledger (especially the round-2 addition).
3. Read the diff at `93b399160` vs the prior head `888951a9f` (only the bits relevant to each finding).
4. Audit each of the 1 follow-up + 5 acknowledge items per the three appellate questions (small / in-context / loss-track risk).
5. Propose promotions where warranted; conservative bias.
6. Write the result entry per the appellate's structured output shape.

## Authorizations

- Read-only on the project.
- Write to journal (`result` entry + any followup-ledger removal if a promotion is accepted post-return).

## Out of scope

- Do NOT comment on PR #440.
- Do NOT push to the PR.
- Do NOT dispatch other roles.
- Do NOT run `gh pr ready 440` (that's the orchestrator's call after the summary-fix job has been claimed and applied).

## Deliverable

A `result` entry under `journal/entries/2026/06/14/` naming:

- The justice's `result` entry path.
- The count of follow-up + acknowledge items considered.
- The proposed promotions in the appellate's structured shape (or empty with rationale).
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator.
