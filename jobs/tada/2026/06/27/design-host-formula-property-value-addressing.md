Done. Worktree torn down, draft PR #550 open against `llm`.

---

## Completion report

**Job:** `design-host-formula-property-value-addressing` — design a general host-side way to address deeply nested values through hidden formula properties (the remaining `@info` replacement).

**What I did**
- Reconciled against existing material first (per the favor-an-update directive): read `designs/formula-inspector.md` (PR #439/#440), `designs/daemon-retention-paths.md` (PR #284), `designs/retention-path-notation.md`, and the actually-merged source on `llm` (`formula-record.js`, `getFormula`/`specialNames` in `host.js`). Confirmed the gap: `getFormula` (#440) only carried forward the *single-node read*; the `@info` hub's `lookup(["@info", petName, ...path])` form also addressed a deeply nested value by walking a *path* of formula properties — that part was unsupered.
- **Extended `designs/formula-inspector.md`** (rather than creating a new doc) with a `getFormulaPath(root, path, options?)` host-only method and full supporting material:
  - Path/address shape (structured `FormulaPathStep[]` = named property or `{property, key}` list entry; `FormulaAddress` = formula-record or literal leaf; `{trail}` option).
  - Built on `getFormula`/`FormulaRecord` (iterates `getFormulaForId → makeFormulaRecord`; the three property kinds *are* the legal step alphabet).
  - Composition with retention-paths: same field-edge set, opposite direction; shared `:field` / `:property[key]` notation; explicitly excludes pet-name edges.
  - Why host-only + **per-hop cross-peer check** (can't tunnel into a remote peer); grants no authority beyond chained `getFormula`.
  - Error/edge semantics table (missing property, kind mismatch, absent list key, descend-through-literal, cross-peer hop, GC'd reference, depth cap, cycles-are-not-a-hazard, empty-path base case).
  - Migration from `@info` (`lookup([...])` → `getFormulaPath(identify(...), [...])`); **verified on `llm` that nothing depends on the removed `INFO` special name**.
  - Forward-compat via #440's default-empty-properties contract; `endo inspect` trailing property-step args; Options Considered, Security, Scaling, Test Plan, Dependencies, Open Questions, Prompt.
- Synced `designs/README.md` (Updated date + summary row) per the design-doc convention.

**What changed**
- 2 files on a new branch `design/host-formula-property-addressing` off `llm`, committed as `endolinbot`.
- **Draft PR [#550](https://github.com/endojs/endo-but-for-bots/pull/550)** against `llm` (the correct base — that's where the formula-inspector/retention docs and the `getFormula` work live).
- Per-job worktree torn down.

**Follow-ups (left as design Open Questions, not actioned)**
- A value-returning variant of `getFormulaPath` (resolve leaf to live presence) — deferred, needs its own authority analysis.
- Reference-list CLI syntax (`property[key]` vs two tokens) and the depth-cap value — flagged for maintainer review.
- This is design-only; implementation in `packages/daemon` + `packages/cli` is a separate downstream job once the design is reviewed.
