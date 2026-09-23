---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-17T16:46:53Z
---
---
kind: result
role: critic
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

Design-panel round 2, seat `critic`, on `endojs/endo-but-for-bots` PR #1019
(`design/rust-module-lexer-consolidation`, head `5dab3a799b`, base `origin/llm`).
Diff: `designs/rust-module-lexer-consolidation.md` (308 lines) plus one
`designs/README.md` index row. Premises spot-checked against the worktree:
`cjs_lexer.rs::tokenize` does materialize `Vec<Token>` of owned `String`s with a
`depth: Vec<u32>` template stack; `@endo/cjs-module-analyzer` does carry
`templateStack`/`templateStackDepth`; `ironhorse-compile` is a separate crate
depending only on `ironhorse-regexp` and is listed in `rust/endo/Cargo.toml`
behind the default `ironhorse-engine` feature, with a pull `Lexer::next()`;
`entry_walk.rs` on `feat/endor-run-entry-point-deps` does use a single template
counter with the "templates inside templates would slip through" concession;
`09e5736da4` is on that branch and not an ancestor of `llm`. All check out.

### critic

**Verdict:** request-changes

**Findings:**

- (must-fix) § Test parity item 1 cannot execute as specified. It defines one
  corpus of `{ source, expect: { imports, exports, reexports } }` where "the JS
  side runs `analyzeCommonJS` over each case; the Rust side runs the
  consolidated lexer over each; both assert the same expected object." Two
  breaks: (a) no Rust producer exists for two of the three fields, since
  `detect_named_exports` returns export names only (`rust/endo/src/cjs_lexer.rs:418`)
  and CJS `imports`/`reexports` are explicitly deferred to Phase 4 ("`require`
  reexports, `__exportStar`"); (b) the ESM cases seeded from
  `scan_static_imports`'s tests are run through `analyzeCommonJS`, while
  § Parity goal names `@endo/module-source` as the ESM parity target. Phase 3
  needs a per-case oracle selector (`cjs` vs `esm`) and a stated rule for fields
  the Rust side does not implement yet (subset assertion or capability tag).
  [rule: roles/jurors/critic/AGENT.md § Operating norms, "will the implementation
  as sketched actually work"]

- (should-fix) The regression net lands after the rewrites it should guard.
  Phases 1 and 2 are the behavior-preserving rewrites; Phase 3 builds the
  cross-language corpus that is the only oracle able to catch drift.
  § Honoring the allocation constraint correctly argues a test blind to a
  property does not guard it, yet Phase 2 leans on "the existing `cjs_lexer` and
  `execute.rs` tests" (written against the `Vec<Token>` implementation being
  deleted) to hold a from-scratch cursor rewrite byte-identical. Land the corpus
  before Phase 2. [rule: skills/regression-evidence/SKILL.md § Equivalence claims
  need a backing test]

- (should-fix) § Phased implementation targets `feat/endor-run-entry-point-deps`
  for all four phases, but Phase 2 (`rust/endo/src/cjs_lexer.rs`) and Phase 3
  (`packages/cjs-module-analyzer/test/`) touch `llm`-resident files unrelated to
  #282. Stacking them behind an unmerged CHANGES_REQUESTED PR blocks the
  allocation win, inflates #282's diff, and leaves unstated how Phase 1's new
  primitives module (an `llm` file edited on the feature branch) reconciles with
  Phase 2 on `llm`. Name a per-phase branch target and a merge order.
  [rule: skills/stacked-pr-build/SKILL.md]

- (should-fix) § Survey (b) converts the review's "borrow the Rust version of
  the lexer from Node.js" into "write a Rust port" without recording whether an
  existing Rust `cjs-module-lexer` was searched for and not found (or found and
  rejected). The one option the reviewer named by name deserves an explicit
  disposition. [rule: roles/jurors/critic/AGENT.md § Secondary surface]

**Notes (out of scope but worth flagging):**

- Phase 4 is marked "(Optional, as needs grow)" yet also absorbs the
  real-world/fuzzed corpus widening that § Test parity names as the remedy for a
  gap it acknowledges ("drift on a shape neither list includes would go
  undetected"). An optional remedy for a named gap tends not to land.
  [proposed-rule: a design may not route the remedy for a gap it names into a
  phase it marks optional; either the phase is non-optional or the gap is
  accepted in writing.]

- Round-1's `skip-template` must-fix is well addressed: the depth-stack choice is
  now named, justified against the JS fork, and pinned by a required corpus case.
  No further critic objection there.

Self-improvement: the round-1 critic block checked the *chosen approach* but not
the *deliverability of the test contract*, which is where this round's must-fix
sits. Worth carrying into the seat's norms: when a design names a cross-language
parity corpus, check that every asserted field has a producer on both sides and
that each seed case has a valid oracle, before assessing the approach itself.
Below the threshold for a role-file edit on its own; if a second design panel
hits the same shape, route it to `roles/jurors/critic/AGENT.md` § Operating norms.
