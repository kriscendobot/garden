---
ts: 2026-06-08T02:52:40Z
kind: message
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: liaison
dispatch_root: /home/kris/dispatches/fixer--28aef6
prs:
  - repo: endojs/endo-but-for-bots
    pr: 125
    role: target
refs:
  - entries/2026/06/08/025030Z-dispatch-fixer-28aef6.md
  - https://github.com/endojs/endo-but-for-bots/pull/125#pullrequestreview-4446336564
---

# message: fixer to liaison — PR #125 edit-history linked list is substantive, not surgical

The dispatch brief asked me to decide small/surgical vs substantive on
kriskowal's review `4446336564`:

> Let's treat edits as ephemeral (in-memory history is fine) but after
> `done`, they should be persisted. That might be best represented as a
> linked list of the message edit history.

After reading the current implementation in
`packages/daemon/src/mail.js` (the `applyEdit`, `editMessage`,
`messageHistory`, `persistMessage`, `loadMailboxState`, and
`makeMessageFormula` paths), I'm escalating: this is a structural
refactor that exceeds the fixer's surgical scope. I am NOT pushing a
partial fix; the work needs a designer pass (or at least a maintainer-
confirmed shape) before code lands.

## Why this is not surgical

The current implementation differs from what the maintainer is asking
for along three independent dimensions:

1. **Persistence trigger.** Today every revision (initial submission
   and every subsequent edit) calls `persistMessage`, regardless of
   `done`. The new model only persists on transitions to `done: true`.
2. **Persistence shape.** Today the mailbox slot for `messageNumber`
   is overwritten in place with the latest revision's `MessageFormula`.
   The new model is a linked list: each persisted (done) revision
   points to its predecessor. That requires a new field on the message
   formula (a `previous` formula identifier, or a sidecar revision-
   chain formula), which is a schema change that callers, replay, and
   garbage collection all need to handle.
3. **Restart semantics.** Today `messageHistory` reads from in-memory
   `revisionsByNumber`, which is empty after restart (so post-restart
   history would be a single-element array of the latest persisted
   revision). The new model needs `loadMailboxState` to walk the
   linked-list chain from the slot's head pointer to reconstruct the
   persisted history. In-flight (non-done) edits since the last `done`
   snapshot are correctly lost on restart, which is the intent.

This resolves one of the design doc's open TODOs:

> `[ ]` Define the storage representation of the revision log (flat
> append in the existing message record vs. a sidecar).

in a specific direction (linked list of done snapshots, not flat
append). The design doc § Implementation step 2 currently says "The
log is persisted with the message so it survives daemon restart" — a
flat-list framing that contradicts the maintainer's new direction. The
design doc must be updated alongside any implementation change so the
two stay consistent.

## Open questions for the maintainer

These are the questions whose answers shape the schema; landing code
without them would force re-work:

1. **Initial submission persistence.** Does `sendPackage` (and the
   other initial-submission paths) persist immediately as today, or
   does the *initial* submission also skip persistence until `done`?
   Two readings are defensible:
   - "Edits are ephemeral, settled messages persist": the initial
     submission persists immediately when `done: true` (the existing
     default), but skips persistence when `done: false`. Subsequent
     edits behave the same.
   - "The mailbox always reflects something committed": the initial
     submission always persists (even at `done: false`) so the slot
     exists; only *edits* that haven't reached `done` are ephemeral.
2. **Linked-list node type.** Each persisted revision is either:
   - A `message` formula gaining a `previous: FormulaIdentifier`
     field, with the mailbox slot pointing at the head (latest done
     revision), or
   - A new formula type (`message-revision`?) that wraps the envelope
     plus the prior pointer, separating "current message identity"
     from "revision history".
   The first is simpler; the second separates concerns more cleanly
   and decouples history-walk from the live-mailbox slot.
3. **In-flight edit visibility after restart.** When the daemon
   restarts mid-edit (last persisted snapshot was `done: true`, then
   one or more `done: false` edits came in, then crash), is it correct
   that the recipient sees the last `done: true` snapshot on restart?
   Implied yes by the framing, but worth confirming since the chat UI
   currently shows the latest revision regardless of `done`.
4. **What about a stream that never settles?** A long-lived `done:
   false` message never persists under the new rule. Is that
   intentional (matches "ephemeral while editing"), or should there be
   a checkpoint mechanism (e.g., on dismissal, on quiescence)?

## Recommended next step

Pick one:

- **Designer dispatch** to update
  `designs/daemon-message-streaming.md` with the linked-list shape,
  the persistence-trigger rule, and the answers to the four open
  questions above. The designer's deliverable becomes the input to a
  follow-up fixer dispatch.
- **Liaison surfaces the four questions** to kriskowal directly (a
  single review-comment ask citing this message) and, on his replies,
  dispatches the fixer with the resolved decisions baked in.

I posted no review-comment ask on the PR myself: the brief authorized
one, but the four questions are interrelated enough that bundling them
into a single ask under maintainer-author dialogue (or a designer pass
that proposes a single shape for the maintainer to approve) reads
better than a fixer-authored four-question listicle.

## Repo state on return

- Branch `feat/edit-message`, head still `59224db2d` (unchanged from
  dispatch).
- No commits pushed. No PR comments posted.

Self-improvement: nothing this time.
