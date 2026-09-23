---
ts: 2026-06-17T22:28:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--a91a9d
model: sonnet
prs:
  - repo: endojs/endo-but-for-bots
    pr: 449
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/449
  - https://github.com/endojs/endo-but-for-bots/pull/449#discussion_r3431832085
---

# dispatch: fixer — #449 table-row example uses view.at(0) (erights 22:26:39Z)

After erights's correction-then-retraction cycle at 22:23-22:25Z
(both addressed inline), erights at 22:26:39Z surfaced a separate
issue: the *API surface* table row at
`packages/immutable-arraybuffer/designs/freezable-typedarray.md`
line 143 currently demonstrates the post-assignment read as
`view[0] = 42; view[0]` evaluating to `42`. This is technically
correct (OrdinaryGet finds the shadowing own data property), but
it doesn't demonstrate the invariant the table is documenting
(the underlying buffer is untouched). Erights wants the example
changed to `view[0] = 42; view.at(0)` which evaluates to `0` (the
original buffer byte) — directly showing the invariant.

Erights's comment (id 3431832085, in_reply_to 3431601526):

> Oh, the line in the table is still wrong. After the assignment,
> `view[0]` evaluates to `0`. I think the example in the table
> should be `view[0] = 42; view.at(0)`

(The "evaluates to `0`" is a slip — erights means the underlying
buffer's byte 0 is what should be demonstrated, and `view.at(0)`
is the read that returns that.)

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#449`, DRAFT, base
  `master-4a04d07`, head
  `design/immutable-arraybuffer-freezable-typedarray-emulation`
  at `cc55ec895`.

## Task

In your `project/` worktree at `cc55ec895`:

1. Open
   `packages/immutable-arraybuffer/designs/freezable-typedarray.md`
   line 143 (the *API surface* table's `view[0] = 42; view[0]`
   row).
2. Change the table-row example to use `view.at(0)` for the read:
   - Example column: `view[0] = 42; view.at(0)`
   - Evaluation column: `0` on a non-frozen wrapper (the
     underlying buffer is unchanged); `0` on a frozen wrapper too
     (the assignment is silently swallowed). Update the row's
     evaluation text accordingly. The row currently distinguishes
     frozen (`undefined`) vs non-frozen (`42`); with `view.at(0)`
     the answer is `0` in both cases (because the underlying
     buffer is never modified) and the distinction collapses. If
     the table wants to keep a frozen/non-frozen split, add a
     second row showing the OrdinaryGet path
     (`view[0] = 42; view[0]` → `42` non-frozen, `undefined`
     frozen) and label the two rows by their *purpose* (the
     `view.at(0)` row demonstrates the buffer invariant; the
     `view[0]` row demonstrates the wrapper's own-property
     install).
3. Cross-check the worked-example prose at lines 201-263 to make
   sure the prose and the table tell a consistent story. Edit the
   prose if needed to match the table.
4. Reply inline on comment id `3431832085` confirming the table
   row update and citing the new commit SHA.
5. Run pre-push-gates.
6. Commit (one commit, scoped to the table-row and any
   consistency edits) and push to
   `design/immutable-arraybuffer-freezable-typedarray-emulation`
   (append only).
7. Write a `result` journal entry under
   `journal/entries/2026/06/17/` naming pre/post head SHAs, the
   files modified, pre-push-gates result, the inline reply URL,
   a `Self-improvement: ...` line, and **Recommended next stage**:
   `next: solicitor` for #449 r3.

## Authorizations

- Push to `design/immutable-arraybuffer-freezable-typedarray-emulation` (append only).
- Inline reply on comment 3431832085.

## Out of scope

- Do NOT re-request review.
- Do NOT mark PR ready.
- The 12 round-2 summary-fix items still wait for the
  terminating-round bundle; do NOT address them here.

End your turn with a concise summary back to the orchestrator.
