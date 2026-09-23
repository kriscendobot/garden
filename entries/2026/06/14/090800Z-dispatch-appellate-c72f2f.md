---
ts: 2026-06-14T09:08:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: appellate
dispatch_root: /home/kris/dispatches/appellate--c72f2f
prs:
  - repo: endojs/endo-but-for-bots
    pr: 442
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/442
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/14/090300Z-result-barrister-9c09ea.md
---

# dispatch: appellate — PR #442 daemon-cas extraction first-round termination

Barrister 9c09ea terminated the first code-panel round on PR #442
with **0 must-fix-loop, 1 summary-fix, 3 follow-up, 21 acknowledge,
3 drop**. Per the appellate's default policy (run on every
terminating round before un-draft), this dispatch audits the 3
follow-up and 21 acknowledge items for any small-and-in-context
items that should be promoted to summary-fix.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#442`, DRAFT, base `llm-c85d618`,
  head `f472c43c5` (the SHA the barrister reviewed).
- **Barrister's verdict**: posted as COMMENTED review on PR #442.
- **Summary-fix job** already posted at
  `journal/jobs/open/20260614T090132Z--7e80fa--endo-but-for-bots-442-summary-fix.md`
  (single item: wrap daemon-cas tests in `@endo/ses-ava`).
- **Followup ledger** at
  `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--442.md`
  with the 3 parked follow-up items.

## Task

In your `project/` worktree at `f472c43c5`:

1. **Read** the barrister's result entry
   (`journal/entries/2026/06/14/090300Z-result-barrister-9c09ea.md`)
   and the COMMENTED review body on PR #442.
2. **Read** the followup ledger
   (`journal/projects/endo-but-for-bots/followups/endo-but-for-bots--442.md`).
3. **Read** the diff at `f472c43c5` vs `llm-c85d618` (only the
   bits relevant to each finding).
4. **Audit** each of the 3 follow-up + 21 acknowledge items per
   the three appellate questions (small / in-context / loss-track
   risk).
5. **Propose** promotions to summary-fix for items that score yes
   on all three (strong) or yes on two of three with a softer
   rationale.
6. **Write** the result entry per the appellate's structured
   output shape.

## Authorizations

- Read-only on the project.
- Write to journal (`result` entry + any followup-ledger removal
  if a promotion is accepted by the orchestrator post-return).

## Out of scope

- Do NOT comment on PR #442.
- Do NOT push to the PR.
- Do NOT dispatch other roles.
- Do NOT run `gh pr ready 442` (that's the orchestrator's call
  after the summary-fix job(s) have been claimed and applied).

## Deliverable

A `result` entry under `journal/entries/2026/06/14/` naming:

- The barrister's `result` entry path.
- The count of follow-up + acknowledge items considered.
- The proposed promotions in the appellate's structured shape
  (or an empty proposal list with rationale if none warrant
  promotion).
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator.
