# Design: general host-side addressing of deeply nested values through formula properties (the @info-hub replacement)

Map: **design** → dispatch a designer. Target repo: `endojs/endo-but-for-bots`.
Deliverable is a DESIGN DOC under `designs/`. Design only — no implementation in
this job. Reconcile with existing material and FAVOR UPDATING an existing design
over creating new material where it is the natural home.

## The need (maintainer 2026-06-27)
The `@info` inspector name hubs have been only PARTIALLY superseded. We need a
GENERAL way for **hosts (not guests)** to address **deeply nested values** through
the **hidden formula properties** — i.e. given a root value/formula, follow a path
through its formula's reference / reference-list properties (and theirs, and so on)
to resolve a deeply nested value, host-only.

## Reconciliation — what already exists (start here; do NOT re-derive)
The liaison searched issues/PRs/designs; favor updating these over new material:
- **`endojs/endo-but-for-bots#440` (MERGED)** — `feat(daemon,cli,chat): drop @info
  name hub for formula-inspector design (#439)`. This is what PARTIALLY superseded
  @info. It added host-only **`EndoHost.getFormula(identifier)`** returning a
  normalized **`FormulaRecord` = { type, number, properties }** where each property
  is `{ kind: 'literal', value }`, `{ kind: 'reference', identifier }`, or
  `{ kind: 'reference-list', entries }` (classification in
  `packages/daemon/src/formula-record.js`), and REMOVED `INFO: inspectorId` from
  `packages/daemon/src/host.js` `specialNames` (so `@info` is no longer reachable).
  `getFormula` is host-only (absent on `GuestInterface`). The PR is based on the
  **`llm`** branch (not `master`), because the chat cut targets `packages/chat`
  which exists on `llm`. https://github.com/endojs/endo-but-for-bots/pull/440
- **`designs/formula-inspector.md`** (design #439) — the merged design `getFormula`
  implements. THE LIKELY HOME for this addressing extension; prefer extending it.
- **`designs/daemon-retention-paths.md` + PR #284** (`retention-paths Phase 1 — host
  API + endo paths CLI`) — the INVERSE graph walk (paths by which a formula is
  retained). Same host-only-traversal precedent and reference-graph model; the
  addressing mechanism is the forward-traversal counterpart. Reconcile vocabulary,
  the host-only rule, and the path/edge model with it.
  https://github.com/endojs/endo-but-for-bots/pull/284
- **Deferred plan job `formula-inspector-retention-paths-table`** — a UI follow-on
  that renders #284's retention paths in the formula inspector. Related surface;
  make sure the addressing model and that table share concepts, not diverge.
- No OPEN issue/PR tracks the general mechanism (liaison searched both
  `endojs/endo-but-for-bots` and `endojs/endo`). Before creating new material, do a
  final reconciliation sweep — including the ORIGINAL `@info`/inspector-hub design
  history and what capabilities it offered that `getFormula` alone does NOT yet
  cover — so the new design closes the actual gap rather than re-stating #440.

## What the design must cover
- A general **addressing/traversal API on `EndoHost`** (host-only; absent on guests)
  that resolves a path through formula properties — root identifier + a sequence of
  property steps (named property, reference, and reference-list index/key edges) —
  to the deeply nested formula and/or its value. Define the path expression /
  address shape (programmatic and, if warranted, a CLI/textual form analogous to
  `endo paths`), error/edge semantics (missing property, non-reference leaf,
  cycles, unresolved/garbage-collected references, depth limits), and what is
  returned at each step vs the leaf (a `FormulaRecord`? a value capability? both?).
- How it **builds on `getFormula`/`FormulaRecord`** rather than duplicating it, and
  how it composes with retention-paths (#284) — shared edge/path model.
- **Why host-only** and the capability-safety argument (guests must not gain
  addressing into hidden formula structure) — carry the #440 / retention-paths
  precedent.
- The migration story from `@info` hubs: what `@info` used to let a host reach, and
  how the new addressing covers each case; confirm nothing still depends on the
  removed `INFO` special name.
- Forward-compatibility for not-yet-classified formula types (mirror #440's
  default-empty-properties contract).

## Constraints
- Bot repo only; design lives under `designs/` on `endojs/endo-but-for-bots`.
  Confirm the correct base branch (the formula-inspector/`getFormula` work is on
  `llm`; the design doc may target `llm` to sit beside `formula-inspector.md` —
  verify where that design currently lives before branching).
- Prefer EXTENDING `designs/formula-inspector.md` (or a tightly-linked sibling)
  over a free-standing new doc, per the maintainer's favor-an-update directive.
  If a new doc is genuinely warranted, cross-link it bidirectionally with
  formula-inspector.md and daemon-retention-paths.md and say why a new doc was
  needed.
- Design only — no daemon/CLI/chat implementation here.
