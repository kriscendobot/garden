---
ts: 2026-06-17T22:17:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--a37e0f
model: sonnet
prs:
  - repo: endojs/endo-but-for-bots
    pr: 449
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/449
  - https://github.com/endojs/endo-but-for-bots/pull/449#pullrequestreview-4520012627
---

# dispatch: fixer — #449 round 3 (2 must-fix-loop + 2 inline reply confirmations)

Solicitor 2c53c2 r2 verdict (review id 4520012627) at 22:15:24Z:
**request-changes**. 2 must-fix-loop, 12 summary-fix (deferred to
terminating round bundle), 2 inline-reply confirmations, 7
acknowledge, 0 drop.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#449`, DRAFT, base
  `master-4a04d07`, head
  `design/immutable-arraybuffer-freezable-typedarray-emulation` at
  `ba4703bd564fa41259cc4dae5589a9c9c3d2ae84`.

## Task

In your `project/` worktree at `ba4703bd5`:

1. Read the r2 verdict
   (`pulls/449/reviews/4520012627`) in full for context.
2. Address the **two must-fix-loop items**:
   - **[critic must-fix-loop]** Inline a *permits.js delta*
     sub-section under
     `packages/immutable-arraybuffer/designs/freezable-typedarray.md`
     > *Implementation outline* > *Files added or modified*, or
     extend the row-7 entry, to spell out the existing
     `%TypedArrayPrototype%.buffer` permit and the proposed edit
     (replacement accessor + any mutator-method slot changes).
     Round-2 erights asked this directly on discussion
     `r3431666901` line 383.
   - **[skeptic must-fix-loop]** In *Future adapter withdrawal
     from `@endo/bytes`* sub-section: either name one or two
     concrete adapter functions whose withdrawal is anticipated,
     OR rephrase the paragraph to defer enumeration to the
     withdrawal PR's design (so the reader can estimate scope).
3. Send **inline-reply confirmations** on two threads to confirm
   the prior fixer round already addressed them:
   - `r3431690105` (erights 21:53Z): "Please collapse into
     `lib.js`. The separate `immutable-arraybuffer-pony-internal.js`
     no longer serves any purpose." Already addressed by fixer
     a58c91 commit `aab2af75d`; reply citing that commit.
   - `r3431697346` (erights 21:55Z): "Please just delete
     `internal-heir.js`." Already addressed by same commit; reply
     citing it.
4. Run pre-push-gates.
5. Commit per logical unit and push to
   `design/immutable-arraybuffer-freezable-typedarray-emulation`
   (append only).
6. Post inline replies via `gh api repos/.../comments/{id}/replies`.

## Authorizations

- Push commits to `design/immutable-arraybuffer-freezable-typedarray-emulation` (append only).
- Inline-thread reply comments.

## Out of scope

- The 12 summary-fix items wait for the terminating round's bundle.
- Do NOT re-request review.
- Do NOT mark PR ready.

## Deliverable

A `result` entry under `journal/entries/2026/06/17/` naming:

- Pre/post head SHAs.
- Per-commit substance.
- Files modified.
- Pre-push-gates result.
- The two inline reply URLs.
- **Recommended next stage**: `next: solicitor` for #449 r3 panel.

End your turn with a concise summary back to the orchestrator.
