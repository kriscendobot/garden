---
ts: 2026-06-08T02:52:45Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/fixer--28aef6
prs:
  - repo: endojs/endo-but-for-bots
    pr: 125
    role: target
refs:
  - entries/2026/06/08/025030Z-dispatch-fixer-28aef6.md
  - entries/2026/06/08/025240Z-message-fixer-2d8285.md
  - https://github.com/endojs/endo-but-for-bots/pull/125#pullrequestreview-4446336564
---

# result: fixer — PR #125 edit-history linked list: escalated as substantive (partial fix, no push, no PR comment)

## Outcome

**Partial: escalated to liaison.** No code pushed, no PR comment
posted. See sibling
`entries/2026/06/08/025240Z-message-fixer-2d8285.md` for the full
escalation message and the four open questions whose answers shape
the schema.

The dispatch brief's branching rule was small/surgical → apply +
push + reply, substantive (schema change, interface redesign) →
surface to liaison via `message: fixer → liaison` and stop at
partial. After reading the implementation in
`packages/daemon/src/mail.js`, this is substantive on three
independent axes:

- Persistence trigger (only on `done: true`, not on every revision).
- Persistence shape (linked list of formulas, not in-place overwrite
  of one mailbox slot).
- Restart semantics (walk the chain from the slot head on load).

The change also resolves one of the design doc's open TODOs (the
"flat append vs sidecar" question for the revision-log storage
representation), so the design doc must be updated alongside any
code change.

## Repo state

- Pre-head: `59224db2d` (`feat/edit-message`).
- Post-head: `59224db2d` (unchanged; no commits added).
- No push performed.

## Authorizations used

None of the per-action authorizations were exercised:

- Push to `feat/edit-message`: not used.
- Reply on the review / top-level PR comment: not used. The brief
  authorized one review-comment ask, but the four open questions
  are interrelated enough that bundling them into a maintainer
  dialogue (or routing through a designer pass that proposes a
  single shape) reads better than a four-question ask from the
  fixer.
- Re-request review: not authorized; not used.

## Recommended next step (from the message)

Either:

- **Designer dispatch** to update
  `designs/daemon-message-streaming.md` with the linked-list shape
  + persistence-trigger rule + answers to the four open questions,
  then a follow-up fixer dispatch on the resolved design.
- **Liaison surfaces the four questions to kriskowal directly**
  (single review-comment ask), then dispatches the fixer with the
  resolved decisions baked in.

Both paths converge on the fixer landing code only after the
schema and persistence-trigger questions are answered.

## Files read (no edits)

- `packages/daemon/src/mail.js` (the `applyEdit`, `editMessage`,
  `messageHistory`, `persistMessage`, `loadMailboxState`,
  `makeMessageFormula` paths).
- `designs/daemon-message-streaming.md` (especially § Implementation
  step 2 and the Known Gaps and TODOs section).

Self-improvement: nothing this time.
