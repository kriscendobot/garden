---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 131
upstream_mirror_repo: null
upstream_mirror_pr: null
created_at: 2026-06-08T23:09:30Z
last_appended_at: 2026-06-08T23:09:30Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#131

Created from the barrister's first-round code-panel verdict on PR #131 (`feat(chat): inventory drag-and-drop, cancel, and type badges`).
Panel: 14 of 26 seats per `panel-hints` (always-on core, always-fire, content-triggered for harden / harden(/ JSON.parse(); no overrides), in-band fallback.
Round 1 returned 2 `must-fix-loop`, 4 `summary-fix`, 3 `follow-up`, 4 `acknowledge`, 1 `drop`.

## Items

- [ ] **Component test scaffolding for `inventory-component.js`.**
  **Source juror(s)**: prover (and cleaner pass note).
  **Round**: 1.
  **Recommended action**: dispatch an assayer to write `packages/chat/test/component/inventory-component.test.js` with a mock-powers DI scaffold (mock `lookup` / `identify` / `locate` / `followNameChanges` / `copy` / `move` / `cancel`, plus a `dataTransfer` shim on happy-dom's `DragEvent`).
  Shape it after `packages/chat/test/component/spaces-gutter-home.test.js` (the same package's only existing mock-powers component test).
  The file is 1210 lines, owns drag-and-drop, two-step cancel confirmation, type-badge rendering, hub-gating, and recursive nested-inventory expansion, and is exercised by no existing test today.
  Rule: `skills/coverage-driven-testing/SKILL.md`; `packages/chat/CLAUDE.md` § Testing with AVA.

- [ ] **Package-wide `$parent` typing-contract pass for DOM-event handlers.**
  **Source juror(s)**: typist (with cleaner-pass corroboration of 18 net-new TS errors of the same shape).
  **Round**: 1.
  **Recommended action**: open a follow-up PR with a small helper module (e.g. `packages/chat/dom-events.js`) exporting narrowed `addEventListener` wrappers for `DragEvent`, `MouseEvent`, etc., that produce strictly-typed handler callbacks (`(e: DragEvent & { dataTransfer: DataTransfer }) => void` and similar). Adopt across all UI components in `packages/chat/`. This addresses the package's existing 207-baseline TS errors plus the 18 added by this PR. Out of scope for one PR's fixer pass; warrants its own builder dispatch on a `chore/chat-dom-event-typing` branch.
  Rule: `packages/chat/CLAUDE.md` § @ts-check and JSDoc types.

- [ ] **End-to-end integration test for drop-and-link / drop-and-move semantics.**
  **Source juror(s)**: prover.
  **Round**: 1.
  **Recommended action**: add a daemon-integration test that opens a chat, drags from a nested directory to the root, picks "Move here", and asserts the source name is gone and the target name resolves to the same identifier. Mirror with a "Link here" test where both source and target resolve to the same value but both still exist. Logical home: `packages/familiar/test/` or a new `packages/chat/test/e2e/` once one exists.
  Rule: `skills/regression-evidence/SKILL.md`.
