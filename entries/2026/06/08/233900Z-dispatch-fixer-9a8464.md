---
ts: 2026-06-08T23:39:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--9a8464
prs:
  - repo: endojs/endo-but-for-bots
    pr: 131
    role: target
refs:
  - entries/2026/06/08/231028Z-result-barrister-520458.md
  - https://github.com/endojs/endo-but-for-bots/pull/131
  - https://github.com/endojs/endo-but-for-bots/pull/131#pullrequestreview-4454030105
  - https://github.com/endojs/endo-but-for-bots/pull/131#issuecomment-4654390222
  - https://github.com/endojs/endo-but-for-bots/pull/131#issuecomment-4654420930
---

# dispatch: fixer — PR #131 must-fix-loop (6 items: 2 barrister + 1 maintainer bug + 3 maintainer-escalated follow-ups)

Per the gamut chain on PR #131 plus kriskowal's substantive
follow-up activity:

- **Barrister's first-round panel** (review `4454030105`,
  `entries/2026/06/08/231028Z-result-barrister-520458.md`)
  classified 2 must-fix-loop items.
- **kriskowal's manual testing** added 1 bug (drop-zone retract
  issue) via comment `4654420930`.
- **kriskowal's follow-up override** (comment `4654390222`)
  said "Please address these now" / "Let's address this now"
  to ALL 3 of the barrister's `follow-up`-classified items,
  pulling them into the must-fix-now set.

**Total: 6 must-fix items.** Per memory rule (*"COMMENTED
reviews with explicit asks ARE actionable"*), the
"Please address these now" framing is the actionable directive.

## State at dispatch time

- **PR #131**, source-touching, non-draft, base `llm-11a76ae`,
  head `86cae54126adb536a2b5a169b512edcc2b516917`.
- **CI**: 22/0/0 SUCCESS/FAILURE/IN_PROGRESS.

## 6 must-fix items

### From barrister (review `4454030105`)

1. **`packages/chat/inventory-component.js:578`** — `E(powers).cancel(...itemPath)` spreads the path but `EndoHost.cancel` is `M.call(NameOrPathShape).optional(M.error())`; for any nested item (path length ≥ 2) the second segment is forwarded as `reason` and the M.interface guard rejects. **Fix**: pass `itemPath` as one array (matching `move`/`copy` at lines 462/467).

2. **`packages/chat/inventory-component.js:1210`** — missing `harden(inventoryComponent);` per project CLAUDE.md. Sibling components in the package all honor the convention; add the harden call.

### From maintainer's manual testing (`4654420930`)

3. **Drop-zone retract bug**: "Manual testing revealed that the drop zone does not reliably retract after completing a link or copy action from the drop context menu." Investigate the drop-context-menu completion path; the drop-zone visual state isn't being cleared after the action commits. Likely a missing state-reset in the `link` / `copy` handler.

### From maintainer's follow-up override (`4654390222`)

4. **Component test scaffolding** for `inventory-component.js`. Per the cleaner's notes: would require a mock-powers DI scaffold of the shape `test/component/spaces-gutter-home.test.js` carries (`lookup` / `identify` / `locate` / `followNameChanges` / `copy` / `move` / `cancel`) plus a `dataTransfer` shim on happy-dom's `DragEvent`. **Author the test file.** Rule: `skills/coverage-driven-testing/SKILL.md`.

5. **Eighteen TypeScript errors** in `inventory-component.js`: `DragEvent.dataTransfer` and `MouseEvent.clientX/Y` narrowing on `addEventListener` arrow handlers. Pattern matches the package's existing 207 baseline of the same shape. Maintainer asked for a **package-wide `$parent` typing-contract pass**. Rule: `packages/chat/CLAUDE.md` § @ts-check and JSDoc types.

6. **Daemon-integration test** for drag-and-link / drag-and-move semantics. The PR's description claims "Link calls `E(powers).copy()` (an alias of the same capability). Move calls the daemon's atomic move..." but this is exercised through manual UI verification only. Author an end-to-end test that opens a chat, drags from a nested directory to the root, picks "Move here", and asserts the source name is gone and the target name resolves to the same identifier. Logical home: `packages/familiar/test/` or a new `packages/chat/test/e2e/`. Rule: `skills/regression-evidence/SKILL.md`.

## Task

In your `project/` worktree on `feat/chat-inventory-dnd`
(currently at `86cae541`):

1. **Items 1, 2, 3 (surgical fixes)**: apply directly. Commit
   each separately with descriptive conventional-commit
   messages.
2. **Items 4, 5, 6 (substantial test/typing work)**:
   - **Item 4** (component test): if you can author the
     mock-powers DI scaffold + the test file in surgical
     scope (1-2 commits, plausibly < 500 lines including
     test fixtures), do it. If it grows beyond that, surface
     as `next: assayer` and stop the test-scaffolding part
     of this dispatch.
   - **Item 5** (TS typing-contract pass): the package-wide
     `$parent` pass is broader than this PR. Apply it to
     `inventory-component.js` (the 18 errors named by the
     cleaner) and surface the broader package-wide pass as
     `next: liaison` or queue for a separate fixer.
   - **Item 6** (daemon-integration test): if you can author
     an end-to-end test in surgical scope (1 commit, new
     test file in `packages/chat/test/e2e/` or
     `packages/familiar/test/`), do it. If it requires
     standing up new test infrastructure beyond a single
     file, surface as `next: assayer` and stop.
3. **Push** all commits to `feat/chat-inventory-dnd` (regular
   appends).
4. **Reply on PR #131** with a summary of addressed-vs-escalated
   items, citing each commit SHA + any `next: <role>`
   escalation surfaced.

## Authorizations (per-action, forwarded by steward)

- **Push commits** to `feat/chat-inventory-dnd`.
- **Top-level summary comment** on PR #131
  (`endo-but-for-bots` standing broad-comment authorization).
- **Inline reply** on each of the barrister's must-fix
  inline-review-comments citing the addressing SHAs.
- **NOT re-request review**: per memory and standard fixer
  norm; the per-cycle scan picks up the justice re-run.

## Out of scope

- Do NOT shepherd CI to green; if CI fails on the fix push,
  surface to liaison.
- Do NOT touch other PRs.

## Deliverable

A `result` entry under `journal/entries/2026/06/08/` per the
standard fixer deliverable shape, plus a per-item disposition
table (addressed-here vs escalated-as-next-role).

If you escalate items 4-6, name `next: assayer` (or `next:
liaison` for the TS package-wide pass) with the specific
boundary you stopped at.

End your turn with a concise summary back to the orchestrator.
The orchestrator tears down your dispatch root on return.
