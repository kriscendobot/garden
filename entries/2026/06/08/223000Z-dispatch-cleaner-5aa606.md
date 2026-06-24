---
ts: 2026-06-08T22:30:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: cleaner
dispatch_root: /home/kris/dispatches/cleaner--5aa606
prs:
  - repo: endojs/endo-but-for-bots
    pr: 131
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/131
  - https://github.com/endojs/endo-but-for-bots/pull/131#issuecomment-4654097115
---

# dispatch: cleaner — start review gamut on PR #131 per kriskowal @-mention

Maintainer @-mention on `endojs/endo-but-for-bots#131`
(`feat(chat): inventory drag-and-drop, cancel, type badges
(re-opened from #41 under the bot)`) at
2026-06-08T22:28:36Z (kriskowal):

> @kriscendobot please subject this to the review gamut.

Eyes reactji (`367313493`) posted before this dispatch.

## State at dispatch time

- **PR #131**, source-touching (2 files), non-draft, base
  `llm`, head `feat/chat-inventory-dnd` at full SHA
  `09eff8610b887efe66bd5a0d862d13ebb5e17ff0`. No prior reviews.
- Current `llm` tip: `11a76ae6` (post-#426 sync).
- The PR may need a rebase first per the post-#426 base-drift
  pattern noted in
  [`entries/2026/06/08/220000Z-result-steward-b2581a.md`](220000Z-result-steward-b2581a.md):
  unicorn numeric-separators, composite-tsconfig regen, new
  master test fixtures. CI hasn't run on current state; verify.

## Task

You are the **cleaner** stage of the gamut on PR #131. Per
`roles/cleaner/AGENT.md` and `skills/pr-creation-flow/SKILL.md`:

1. **Inspect PR state**. Read the diff vs `llm`. If CI is not
   green on current head, first determine whether it's a base-
   drift issue (unicorn / composite-tsconfig / fixture
   restoration per the post-#426 pattern). If yes, fold a rebase
   onto `llm-11a76ae` into your cleaner pass (push as part of
   your work). If no, surface the CI state in your result.
2. **Cleaner pass**: per the role's standard work — coverage
   commits, dead-code removal, prettier/lint polish. The
   cleaner stands between the builder and the jury; its
   output is what the judge panel reviews.
3. **Push** all cleaner commits to `feat/chat-inventory-dnd`.
4. **Reply on PR #131** with the cleaner outcome + the post-
   cleaner CI state. Cite the next-stage owner (judge will be
   dispatched by the steward on the next cycle).

After the cleaner returns, the steward dispatches a **barrister**
(first-round judge for source-touching PRs) per the gamut chain.

## Authorizations (per-action, forwarded by steward)

- **Push** cleaner commits.
- **Rebase + retarget PR base** if the base-drift pattern
  applies (per the standing post-#426 lesson).
- **Reply comment** on PR #131 (`endo-but-for-bots` standing
  broad-comment authorization).

## Out of scope

- Do NOT dispatch the judge yourself; the steward owns the
  cleaner→judge handoff.
- Do NOT touch other PRs.
- Do NOT un-draft (PR is already non-draft).

## Deliverable

A `result` entry under `journal/entries/2026/06/08/` naming
pre/post head SHAs, any rebase decision, cleaner commit SHAs,
post-cleaner CI state, reply-comment URL, and
`Self-improvement: ...`.

End your turn with a concise summary back to the orchestrator.
The orchestrator tears down your dispatch root on return.
