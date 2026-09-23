---
kind: result
role: skeptic
host: endolin-garden2-5bcdff64
at: 2026-08-17T16:47:05Z
---
Design-panel juror block for `endojs/endo-but-for-bots` PR [#1019](https://github.com/endojs/endo-but-for-bots/pull/1019) (design: `designs/rust-module-lexer-consolidation.md`, base `origin/llm`, head `5dab3a799b`), seat `skeptic`, round 2.

### skeptic

**Verdict:** request-changes

**Findings:**

- must-fix. § Test parity's central mechanism does not run. `analyzeCommonJS` **throws** on ESM source: I ran it on this worktree (2026-08-17, `packages/cjs-module-analyzer/index.js`) and `analyzeCommonJS("import x from 'y';")` raised `Unexpected import statement in CJS module` (and `export {a} from 'y'` likewise). So "The JS side runs `analyzeCommonJS` over each case" is impossible for exactly the half of the seed corpus drawn from `entry_walk.rs`'s `scan_static_imports` tests. The unstated premise (one JS analyzer covers both halves of the corpus) is false. § Parity goal already names `@endo/module-source` for the ESM half; § Test parity must say per-case which JS runner executes it, and whether module-source's output reduces to the corpus expectation shape at all. [rule: skills/node-parity-test/SKILL.md, a parity claim is substantiated by a runnable pair over one shared assertions module, not by prose]

- must-fix. The fixture schema names a key the fork does not emit. `analyzeCommonJS` returns `{ exports, reexports, requires }` (observed: `{"exports":["c"],"reexports":[],"requires":["b"]}`), not `{ imports, exports, reexports }`. § Motivation's table concedes this parenthetically ("imports (requires)"), but the § Test parity fixture schema and the § Parity goal bullet both assert `imports`, so "both assert the same expected object" is untrue at the key level. State the schema or the mapping. [rule: skills/regression-evidence/SKILL.md, equivalence claims need a backing test]

- should-fix. Phase 1 contradicts itself. It promises "No behavior change", yet Recommendation step 1 requires `skip-template` adopt the depth stack, which changes entry_walk's semantics (its own comment at the single-counter site concedes "templates inside templates would slip through", `rust/endo/src/entry_walk.rs:278-281` on `feat/endor-run-entry-point-deps`). Phase 1 is also told to add a nested-backtick corpus case, though the corpus is not built until Phase 3. [proposed-rule: a phase labelled "no behavior change" may not carry a mandated semantic change; split it out with its own test.]

- should-fix. § Honoring the allocation constraint enforces via "and/or", so option 1 alone (an invariant comment plus a reviewer checklist) satisfies it, while that same section argues the corpus cannot guard the property. The allocation win is the review's stated condition for granting a bespoke scanner, so make the counting-allocator test (option 2) required, not optional. [rule: roles/jurors/skeptic/AGENT.md § Verified-claim evidence discipline]

- should-fix. Option (b) silently reframes the review's "borrow the Rust version of the lexer from Node.js" as "write our own port", without recording whether an existing Rust implementation was searched for. Record the search (name the artifact, or state that none exists as of 2026-08-17); otherwise (b) is surveyed against something the reviewer may have meant literally. [proposed-rule: when a survey rejects an option the reviewer named as an existing artifact, state the search that established the artifact does not exist.]

**Notes (out of scope but worth flagging):**

- Phase 2's guard is "existing tests" (25 `#[test]`s in `rust/endo/src/cjs_lexer.rs`), but `collect_object_literal_keys` takes `&[Token]` and so is rewritten wholesale by the `Vec<Token>` removal. Worth naming what coverage that guard actually has before relying on "behavior must not move". [proposed-rule: a refactor phase that claims existing tests as its guard states the coverage those tests have over the rewritten surface.]

Self-improvement: the `analyzeCommonJS`-throws-on-ESM finding came from running the function rather than reading the design's description of it, which is what the seat's verified-claim discipline already prescribes; nothing new to route.
