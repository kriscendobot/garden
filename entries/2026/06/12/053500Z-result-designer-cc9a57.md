---
ts: 2026-06-12T05:35:00Z
kind: result
role: designer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: cc9a57
prs:
  - { repo: endojs/endo-but-for-bots, pr: 439, role: new }
refs:
  - entries/2026/06/12/051935Z-dispatch-designer-cc9a57.md
  - entries/2026/06/12/051636Z-result-researcher-01b231.md
  - entries/2026/06/12/052752Z-result-designer-cc9a57.md
---

# result: designer — PR #439 chat-value-modal-formula-view

PR #439 DRAFT, base llm, head design/chat-value-modal-formula-view.
Researcher precedence honored (refinement from `01b231` inlined).

## Three load-bearing decisions

1. **formula-inspector overlap: cite-as-precedent, NOT supersede.**
   Complementary surfaces sharing the `makePetStoreInspector`
   substrate (packages/daemon/src/daemon.js lines 5704-5829).
   New design owns the in-modal card-flip moment;
   formula-inspector keeps the dedicated inspector panel, edit
   toggle, retention-path reveal, and `endo inspect` CLI verb.
   Both surfaces share a future `formula-view-registry.js`
   layout source-of-truth.

2. **Navigation model: STACK.** Backspace / ← pops the most
   recent frame. Cycles do NOT coalesce in V1 (A→B→A is
   `[A, B, A]`); de-duplication surfaced as open question.
   Replace alternative rejected for losing entry-point context
   (the back-stack means closing the modal returns the user
   to the chat stream rather than the modal's prior value).

3. **API extension: reuse existing surfaces, no new daemon
   method.** Chat composes (a) `followNameChanges` `type`
   field extension from inventory-grouping-by-type (additive;
   old consumers unaffected) for at-stream type discovery,
   and (b) existing `InspectorHub.lookup(petName)` for
   per-type properties, lazy + per-session cached. A new
   `inspectFormula(formulaId)` method was rejected: daemon
   already returns this shape; new surface when existing
   suffices is wrong.

## Catalog correction surfaced

Researcher's brief cited the historical 26-formula-type set
from `daemon-256-bit-identifiers.md`. Live
`packages/daemon/src/formula-type.js` carries **33 types** —
added since: `channel`, `git`, `git-credential`, `git-remote`,
`make-archive`, `make-from-tree`, `mount`, `readable-tree`,
`scratch-mount`, `timer`. Designer used the live count, citing
`daemon-mount.md`, `daemon-git-capability.md`,
`daemon-make-archive.md`, `daemon-message-streaming.md` for
the additions.

Self-improvement signal: librarian should re-ingest
`d256` / `daemon-256-bit-identifiers` to refresh the count or
ingest `formula-type.js` directly as the source-of-truth.

## Six open questions for maintainer

1. Supersede vs specialize `formula-inspector.md` (designer
   chose specialize; surfaces for confirmation).
2. Navigation stack vs replace (designer chose stack).
3. Card-flip animation register + reduced-motion fallback
   (novel affordance; no chat-UI precedent).
4. Reference-to-promise status-aware rendering for `promise` /
   `resolver` types.
5. Cycle handling in the back-stack (de-duplication policy).
6. **NEW**: Enter-Profile keyboard-parity gap — designer
   proposes `Shift+P` to retire the existing gap while the
   modeline is being touched anyway.

## Coordination concern

Designer landed `designs/README.md` row update (summary table,
M9 milestone table, per-design estimate, dependency-graph
node + edges, M9 item count 12→13, total 55→56). Same
potential overlap with the in-flight groom rebucket PR #400 +
chat-inventory-create-menu PR #404 +
daemon-move-transfer-negotiation PR #432 README edits.
Maintainer reconciles README before merging any of them.

Dispatch root torn down.
