---
ts: 2026-06-14T08:45:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: builder
dispatch_root: /home/kris/dispatches/builder--7cfbcc
prs:
  - repo: endojs/endo-but-for-bots
    pr: 440
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/440
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/14/085200Z-result-investigator-b25691.md
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/13/072236Z-result-builder-256add.md
---

# dispatch: builder — implement cut 3 (chat) of formula-inspector on PR #440

Investigator `b25691` confirmed `packages/chat/` and
`packages/goblin-chat/` are **disjoint applications** — cut 3
implements against `packages/chat/` only (Option A).

PR #440 is now rebased onto `llm` so `packages/chat/` is
reachable.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#440`, DRAFT, base `llm`,
  head `feat/formula-inspector` at `f01499f1a...` (FETCH if
  newer).
- **Cuts 1+2 already landed** (daemon `getFormula` + CLI
  `endo inspect`).
- **Cut 4** in separate PR #441 (status bump on llm).
- **Cut 3 (chat)** is the remaining implementation work.

## What's being built (per merged `designs/formula-inspector.md`)

- **`packages/chat/value-component.js`** (extend, currently
  512 lines):
  - Add flip control (gear icon flips Value → Formula).
  - Add back-face mount for Formula view.
  - Add back-stack (push/pop for drill-down).
  - Add `F` keybind to flip back.
  - Add `Escape`-to-flip / `Escape`-to-pop.
  - Wire `Shift+P` for Enter Profile (mode-line hint).
- **New `packages/chat/formula-view-component.js`**: Formula
  view rendering. Per-type taxonomy. Status-split for
  promise-formula view:
  - Pending → subscribe + "View next value" button.
  - Fulfilled → reference button.
  - Rejected → reason + on-demand
    `E(host).traces().lookup(errorId)`.
- **New `packages/chat/formula-view-registry.js`**: registry
  of formula-type → view component mapping.
- **`packages/chat/inventory-component.js`** (extend,
  currently 1,267 lines, insertion point ~line 538):
  - Add gear icon affordance on the row builder.
  - Clicking gear opens Value modal already flipped to back
    face.
- **`packages/chat/index.css`**: card-flip CSS variables +
  reduced-motion override.
- **No cycle unwinding**: principle of least surprise.
- **Read-only at this stage**: no edit toggle.

## Task

In your `project/` worktree on `feat/formula-inspector`
(FETCH if needed):

1. **Read** the merged design `designs/formula-inspector.md`
   in full + investigator `b25691`'s result + prior builder
   `256add`'s result for context.
2. **Inspect the current `packages/chat/`** code surface:
   value-component.js, inventory-component.js, chat.js
   (lines 95-128 + 442-457 + 1734-1750 per prior researcher
   d73da3), index.css.
3. **Implement the chat cut** per the design:
   - Edit `value-component.js` for flip + F + back-stack +
     Escape + Shift+P.
   - Add `formula-view-component.js` (per-type taxonomy +
     promise-status-split).
   - Add `formula-view-registry.js` (formula-type → view
     map).
   - Edit `inventory-component.js` line ~538 for gear icon.
   - Edit `index.css` for card-flip + reduced-motion.
   - Wire daemon's `EndoHost.getFormula(identifier)` (cut 1)
     into the Formula view's data source.
4. **Add tests**:
   - `packages/chat/test/unit/` for formula-view component
     logic.
   - `packages/chat/test/component/` (happy-dom) for
     value-component flip behavior + Shift+P.
   - `packages/chat/test/e2e/` (Playwright) e2e for
     inventory-gear → modal-back-face flow.
5. **Run** `corepack yarn workspace @endo/chat test`.
6. **Run pre-push-gates**.
7. **Commit per logical step**:
   - `feat(chat): formula-view registry + component for
     value-modal back face per #439 design`
   - `feat(chat): flip control + back-stack on
     value-component + gear icon on inventory-component`
   - `feat(chat): card-flip CSS + reduced-motion override`
   - `test(chat): unit + component + e2e for formula-view
     surface`
8. **Push** to `feat/formula-inspector` (append push only).
9. **Post a top-level summary** on PR #440 at-mentioning
   `@kriskowal`:
   - Cut 3 commit SHAs.
   - Notes on any design departures.
   - Test results.
   - Note that cuts 1+2 (daemon + CLI) and cut 3 (chat) are
     now all in this PR; cut 4 (design status bump) is in
     PR #441.

## Authorizations

- Push commits to `feat/formula-inspector` (append only).
- Top-level summary comment on PR #440.

## Out of scope

- Do NOT touch `packages/goblin-chat/` (disjoint).
- Do NOT rebase or force-push.
- Do NOT re-request review (maintainer is actively
  reviewing).
- Do NOT mark PR ready.

## Deliverable

A `result` entry under `journal/entries/2026/06/14/` naming:

- Pre/post head SHAs.
- Per-commit substance.
- Files modified/added in `packages/chat/`.
- Test results.
- pre-push-gates result.
- The PR comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: cleaner` for #440
  re-gamut on the expanded scope.

End your turn with a concise summary back to the orchestrator.
