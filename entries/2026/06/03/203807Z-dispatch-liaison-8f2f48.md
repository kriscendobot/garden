---
ts: 2026-06-03T20:38:07Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: appellate
dispatch_root: /home/kris/dispatches/appellate--8f2f48
prs:
  - repo: endojs/endo-but-for-bots
    pr: 417
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/417
  - entries/2026/06/03/203900Z-result-justice-53be75.md
---

# dispatch: appellate — #417 gamut stage 5 (review follow-up/acknowledge promotions before un-draft)

User explicit ask:

> Please mirror https://github.com/endojs/endo/pull/3164 and
> run the gamut.

#417 gamut progression:
- Stage 1 (cleaner): typo fixes → `984b5d4df`.
- Stage 2 (barrister): `must-fix-loop` (2) + `summary-fix` (5).
- Stage 3 (fixer): all 7 addressed → `0bf3dc8e6`.
- Stage 4 (justice): verdict `approve`; 3 follow-up + 3
  acknowledge dispositions carried; 0 must-fix-loop, 0
  summary-fix, 0 new findings.
- **Stage 5 (this dispatch)**: appellate per
  `roles/appellate/AGENT.md` (default policy: dispatched on
  every terminating judge verdict before un-draft).

## Target

- PR: endojs/endo-but-for-bots#417
- Head: `0bf3dc8e6`.
- Base: `master` (`ba26f4cdb`).
- State: DRAFT (justice declined the un-draft pending appellate).

## Justice's carried dispositions (3 follow-up + 3 acknowledge)

Per the justice's result at
`entries/2026/06/03/203900Z-result-justice-53be75.md`. The
appellate reads the justice's findings and the followup ledger
at `journal/projects/endo-but-for-bots/followups/endo-but-for-
bots--417.md` to evaluate which (if any) follow-up or
acknowledge items are small-and-in-context enough to promote
into a `summary-fix` bundle to land before un-draft.

## Appellate scope

Per `roles/appellate/AGENT.md`:
- Propose promotions: each candidate is an item the appellate
  thinks would be cheaper to land NOW than in a follow-up PR.
- The liaison (this dispatch's orchestrator) accepts or rejects
  each promotion.
- Accepted promotions amend the `summary-fix` job and the
  followup ledger before un-draft.

For this dispatch, the appellate's verdict + proposed
promotions return to the liaison; the liaison applies the
promotions (via a thin fixer or directly) and un-drafts.

## Per-action authorizations

- Read the followup ledger + justice's findings. Authorized.
- Post a top-level PR comment naming any proposed promotions
  + rationale. Authorized.
- Update the followup ledger if you make a promotion-side
  edit (rare in this dispatch). Authorized.

## Not authorized

- Modifying source files (fixer's job if a promotion lands).
- Force-pushing.
- Un-drafting (the liaison runs `gh pr ready` after applying
  any accepted promotions).
- Touching upstream.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/appellate--8f2f48/garden/roles/COMMON.md`
2. `/home/kris/dispatches/appellate--8f2f48/garden/roles/appellate/AGENT.md`
3. The followup-ledger format docs.
4. Skills referenced just-in-time.

Project worktree at `project/` on `mirror/3164-freezable-typedarrays`
(head `0bf3dc8e6`).

## Report

A `result` journal entry. Include:

- Per-disposition appellate verdict (promote / keep-as-follow-
  up / keep-as-acknowledge).
- Proposed `summary-fix` bundle (if any), with per-item
  rationale.
- Top-level PR comment ID if posted.
- Whether the un-draft can proceed immediately or needs a
  promotion-fixer first.
