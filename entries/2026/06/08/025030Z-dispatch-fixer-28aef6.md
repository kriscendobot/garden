---
ts: 2026-06-08T02:50:30Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--28aef6
prs:
  - repo: endojs/endo-but-for-bots
    pr: 125
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/125
  - https://github.com/endojs/endo-but-for-bots/pull/125#pullrequestreview-4446336564
---

# dispatch: fixer — apply kriskowal's new CHANGES_REQUESTED on PR #125 (edit history as linked list)

Maintainer-feedback dispatch on `endojs/endo-but-for-bots#125`
(`feat(daemon): add editMessage and messageHistory`). Review
`4446336564` (kriskowal CHANGES_REQUESTED) at 2026-06-08T02:37:25Z,
top-level body (no inline asks):

> Let's treat edits as ephemeral (in-memory history is fine) but
> after `done`, they should be persisted. That might be best
> represented as a linked list of the message edit history.

The maintainer is asking for a structural change in the message-
history persistence model: edits-while-editing are in-memory only;
edit history persists only after the message reaches `done` state,
and the persisted form is a linked list (each edit pointing at
its predecessor).

## State at dispatch time

- **PR #125** (rebased this cycle), head `feat/edit-message` at
  `59224db2d...` (full SHA — fetch via gh-api for lease anchor).
  Base: `llm-11a76ae` (frozen base retargeted earlier this
  cycle).

## Task

In your `project/` worktree on `feat/edit-message` (currently
at `59224db`):

1. **Read the current implementation** in
   `packages/daemon/src/` and `packages/chat/src/` to find
   where editMessage + messageHistory are wired. The PR's
   commits are the implementation surface; trace the change.
2. **Determine the implementation shape** for the linked-list
   edit history:
   - In-memory edit history (ephemeral) while message is in
     `editing` state.
   - Persisted linked list (each edit references prior via a
     formula key or similar) when message transitions to `done`.
   - Decide whether this is a substantive refactor of the
     message-formula schema OR a small addition.
3. **If small/surgical**: apply the change, commit (one or two
   commits), reply on the review with the addressing SHA,
   surface ambiguity as Open Question in a follow-up review
   comment if any.
4. **If substantive** (requires daemon-formula schema change,
   new test fixtures, or interface redesign that exceeds the
   fixer's surgical scope): write a `message: fixer → liaison`
   surfacing the over-scope, post a review-comment ask on PR
   #125 confirming the intent, and stop at a partial fix.
5. **Push** to `feat/edit-message` (regular append).
6. **Reply on the review** (or a top-level comment if the
   maintainer's review had no inline comments to thread on)
   citing the addressing SHA + the structural decisions taken.

## Authorizations (per-action, forwarded by steward)

- **Push commits** to `feat/edit-message`.
- **Reply comment** on PR #125 (`endo-but-for-bots` standing
  broad-comment authorization).
- **Review-comment ask** if you need maintainer clarification.
- **NOT re-request review**.

## Out of scope

- Do NOT touch packages outside `packages/daemon/` and
  `packages/chat/` (the PR's existing surface).
- Do NOT shepherd CI to green.

## Deliverable

A `result` entry under `journal/entries/2026/06/08/` naming
pre/post head SHAs, the commit SHAs + per-commit description,
the structural decisions taken (ephemeral vs persisted shape,
linked-list-pointer format), the reply-comment URL, and a
`Self-improvement: ...` line.

If you escalate via `message: fixer → liaison`, name the
specific over-scope concern (e.g., "daemon-formula schema
change requires its own design dispatch").

End your turn with a concise summary back to the orchestrator.
The orchestrator tears down your dispatch root on return.
