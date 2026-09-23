---
ts: 2026-05-22T21:45:00Z
kind: dispatch
role: appellate
project: endo-but-for-bots
to: appellate
host: endolinbot
slot: 1
prs:
  - repo: endojs/endo-but-for-bots
    pr: 316
    role: target
refs:
  - entries/2026/05/22/214000Z-result-barrister-44a5c7.md
---

# Dispatch: appellate 1a8c2c — review barrister-44a5c7's 4 acknowledge dispositions on #316

Dispatch root: `dispatches/appellate--1a8c2c/`. Project worktree on `endojs/endo-but-for-bots@chore/familiar-lts-node-pin`.

Barrister-44a5c7 terminated with: 0 must-fix-loop, 0 summary-fix, 0 follow-up, **4 acknowledge**, 0 drop. Formal review pullrequestreview-4348968413 (COMMENTED state; kriscendobot self-PR limitation). No fixer needed. Loop done from the panel's perspective.

The 4 acknowledge dispositions (per barrister result):
- releaser × 2 on changeset-presence and bump level
- gateway × 1 on workflow scope
- changeset-auditor rolled in one bump confirmation as acknowledge

## Task

Standard appellate pass per `garden/roles/appellate/AGENT.md`:
- Read the barrister's aggregated body (formal review id 4348968413 on PR #316) for the 4 acknowledge dispositions in context.
- Apply the small-and-in-context + loss-track-risky lens; appeal candidates promote `acknowledge` → `summary-fix`.
- Submit an appellate verdict (proposed promotions + dispositions kept-as-acknowledged) as a comment or formal review per the appellate role file.
- If summary-fix items are proposed, post the summary-fix job to the board per `skills/job-board/post-job.sh`.

For this declarative chore PR (5 files, +22/-3, no source-code surface), the bar for summary-fix promotion is high; the acknowledge dispositions are likely correctly classified as informational. The appellate's job is to verify that, not to manufacture work.

## Per-action authorization

- `gh pr comment` or formal review on PR #316.
- Post summary-fix job via `skills/job-board/post-job.sh` if any promotion.
- READ-ONLY everywhere else. Don't un-draft (the contractor un-drafts via `gh pr ready 316` on the next cycle).

## Out of scope

- Don't dispatch a new panel.
- Don't dispatch a fixer.

## Report

≤ 250 words: per-disposition appellate verdict (kept | promoted to summary-fix with one-line justification); any summary-fix job posted (path); recommendation to the contractor (un-draft directly or wait for summary-fix to resolve); one-line `Self-improvement: ...`.

Write to `journal/entries/2026/05/22/<HHMMSS>Z-result-appellate-1a8c2c.md` and commit+push to origin journal.
