---
ts: 2026-05-14T19:44:07Z
kind: dispatch
role: liaison
project: endo
to: "*"
---

# Dispatch: designer proposes a top-level-await solution for SES + ModuleSource

Dispatch root: `dispatches/designer--759853/`. Project worktree on `endojs/endo@master` (detached). Output: one design markdown file under `<project>/designs/`; no commits.

Priority: **extreme low**. This dispatch produces a paper design that lands in the queue for a future builder; it is not on any near-term roadmap.

## The directive

Design a solution for **top-level-await (TLA)** in SES and `@endo/module-source`. The design should be implementable on `actual/master` (upstream endo's master branch, not the bots-fork `llm`). The maintainer's framing:

- **Lead with the test suite.** TDD shape: spec out what tests would cover the feature before sketching the implementation. The proposal's organizing principle should be: "here are the tests that an implementation must pass; here is the implementation strategy that makes them pass."
- **Babel's TLA test suite is a useful reference.** They have an extensive suite that exercises top-level-await across many module shapes. Reading those test fixtures tells the designer how the spec's edge cases (await on a rejected promise at top level; await + cyclic imports; await + dynamic import; etc.) get exercised.
- **Backward compatibility on serialized ModuleSource bundles.** A `ModuleSource` captured in an `@endo/bundle-source` bundle today is a serialized form with a specific shape (the functor is synchronous; the imports / exports / metadata layout is fixed). Adding TLA must preserve the existing shape for synchronous modules; only the new async-module case introduces new fields or a new variant.
- **The functor is synchronous by convention; augment SES with an async-module convention.** Today `ModuleSource`'s functor signature is synchronous (it returns when the module's top-level body has run, and synchronous exports are observable thereafter). The TLA design introduces a new convention — perhaps an `async` flag in the functor metadata, perhaps a separately-named async functor, perhaps a wrapper — that SES recognizes and routes through a different initialization path.
- **Read 262 background on module initialization synchronization.** The ECMAScript spec has a precise account of how TLA composes with the module-graph evaluation order ([Cyclic Module Records, evaluation phase](https://tc39.es/ecma262/#sec-cyclic-module-records)). The design's evaluation algorithm should compose with that spec, not invent a separate model.
- **Look for inspiration in test262 fixtures.** The test262 test suite has a `language/module-code/top-level-await/` directory exercising TLA in a fixture-shaped way. These fixtures are smaller and more isolated than Babel's; they may map more cleanly onto `@endo/module-source` test surface.

## Per-action authorization

The designer reads `endojs/endo` (read-only), reads from the bare clones (`worktrees/endojs-endo.git`) for upstream files, may read external references (Babel's repo for TLA tests, the test262 fixtures, the 262 spec) via `WebFetch`. Writes **one** markdown file in `<project>/designs/`. **No commits, no branches, no PRs.** The output is the design file; the maintainer reads it later when capacity allows.

## Task

1. **Orient.** Read `roles/COMMON.md`, `roles/designer/AGENT.md`. Read `<project>/designs/CLAUDE.md` (or whatever the project's design conventions doc is) to match the project's status-table / section conventions. Skim 2-3 existing `<project>/designs/*.md` files for the local voice and length.

2. **Read the relevant code.** Find the current `ModuleSource` shape (likely `<project>/packages/module-source/`) and `@endo/bundle-source`'s serialization format (likely `<project>/packages/bundle-source/`). Note the functor signature, the synchronous-by-convention semantics, and the bundle JSON shape. The SES side is in `<project>/packages/ses/`; locate where the module-graph evaluation loop runs and where synchronous-functor invocations happen.

3. **Read test262's TLA fixtures.** WebFetch [test262's top-level-await directory listing](https://github.com/tc39/test262/tree/main/test/language/module-code/top-level-await) (or a comparable index) and read a representative sample (5-10 fixtures, including cyclic-async and reject-at-top-level). Note which spec edge cases each fixture exercises.

4. **Read Babel's TLA tests.** WebFetch [`babel-plugin-syntax-top-level-await`](https://github.com/babel/babel/tree/main/packages/babel-plugin-syntax-top-level-await) or the equivalent transform package, plus their TLA test fixtures. Babel's tests are richer than test262's for parsing edge cases; the design should incorporate any parser-shape lesson.

5. **Read 262's cyclic module record evaluation algorithm.** Linkable: <https://tc39.es/ecma262/#sec-cyclic-module-records>. The async-module evaluation algorithm composes with the same dependency-resolution graph as sync modules; the design must NOT invent a separate model.

6. **Draft `designs/ses-top-level-await.md`.** Lead with the test suite per the maintainer's framing. Sections (adapt to local convention):
   - Status table (Draft, priority: extreme low).
   - Problem statement.
   - Scope and non-goals (NOT lazy modules, NOT dynamic-import-by-default; the design's scope is the static TLA-with-await-at-top-level shape).
   - **Test suite** — first-class section. Catalog the tests the design proposes, grouped by ECMAScript spec edge cases (single-async-module, async-cyclic, await-rejected-at-top, await-with-dynamic-import). Cross-reference each test to its test262 / Babel fixture inspiration. The design's success criterion is that an implementation passes this catalog.
   - **Backward compatibility for serialized ModuleSource bundles.** Explicitly state the invariant: an existing bundle's serialized ModuleSource without TLA must continue to deserialize and run identically. Document the new field(s) or variant the async-module case introduces; show how the deserializer detects sync vs async.
   - **SES augmentation.** The new convention SES recognizes (functor metadata field, or async functor signature, or a wrapper). Compose with the 262 cyclic-module-records evaluation algorithm; show how SES's existing synchronous evaluation loop dispatches to the async path.
   - **ModuleSource augmentation.** The parser changes (allow `await` at top level for the new variant), the functor-emit changes, the metadata changes.
   - **Alternatives considered.** One-liner per: a separately-named async ModuleSource type; a fully-async functor for all modules; a transpile-down-to-sync approach.
   - **Open questions.** Many; surface them rather than picking.

7. **Diagrams.** One mermaid sequence diagram showing the SES module-graph evaluation loop dispatching between sync and async functor invocations; one showing the bundle-source serialization round-trip with an async ModuleSource.

8. **Length.** Aim 2-4 screens. The test-suite section will likely be the longest; that is the right shape.

## Out of scope

- No code in `<project>/packages/`; design only.
- No commits, branches, or PRs.
- No implementation strategy that requires changes outside SES / module-source / bundle-source.
- No comparison to other JS module systems (Webpack, Vite, etc.); the design is for the SES platform specifically.

## Report

≤ 500 words: path to the design file (`<dispatch-root>/project/designs/ses-top-level-await.md`), the design's one-paragraph problem-statement opening quoted verbatim, the test catalog's top-level structure (one line per test category), the combined open-questions list, one-line `Self-improvement: ...`.
