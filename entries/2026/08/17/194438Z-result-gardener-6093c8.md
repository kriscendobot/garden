---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-17T19:44:39Z
---
---
kind: result
role: critic
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

Design-panel seat `critic`, PR #1019 (`designs/rust-module-lexer-consolidation.md`), round 6, diff base `origin/llm`.

### critic

**Verdict:** request-changes

**Findings:**

- **must-fix.** § Recommendation step 1's `skip_template` premise is false. The design says `cjs_lexer.rs::tokenize`'s `depth: Vec<u32>` "already matches `@endo/cjs-module-analyzer`'s `templateStack`/`templateStackDepth`". It does not: `rust/endo/src/cjs_lexer.rs:137-166` skips the template *wholesale* (its own comment), whereas the oracle's `templateString()` (`packages/cjs-module-analyzer/index.js:1401-1407`) stops at `${`, pushes the depth, and returns to the main scan loop, so interpolation contents are scanned as ordinary source. `const a = ${'`'}${'${'}require('b')}${'`'}` yields `requires: ['b']` from the oracle and nothing from a wholesale skip. Fixing `skip_template` into the stateless-advancer tier (`fn(&str, usize) -> usize`) cements the wrong semantics into the canonical `scan` copy that Phase 1 lands on `llm` first and both consumers then depend on, so Phase 3's "match the JS fork" contract is unreachable at that layer. Shape it as the oracle does (advance-to-`${` plus a caller-threaded template-depth stack, a third piece of cross-token state), or scope interpolation recognition out explicitly with a corpus case. [rule: roles/jurors/critic/AGENT.md § Operating norms, secondary surface]

- **must-fix.** § Recommendation step 1's "the only cross-token state is these two `Copy` values" understates the oracle. Its regex-vs-divide decision consults `openTokenPosStack[openTokenDepth]` and `openClassPosStack[openTokenDepth]` (the token before the *matching* open paren/brace), `lastSlashWasDivision`, and specific-keyword tests (`index.js:262-276`), not merely the previous token's kind: `if (x) /re/.test(y)` and `(a+b) / c` both present `PrevToken::CloseParen` and resolve oppositely. The missing state is a per-depth stack of source *positions*, which allocates no owned strings, so the two-value minimalism forfeits the stated parity for no gain against the allocation constraint. [rule: roles/jurors/critic/AGENT.md § Operating norms, secondary surface]

- **should-fix.** § Recommendation step 4 and § Parity goal frame `openTokenDepth === 0` as the oracle's recognition gate. In the oracle only `import`/`export` *statement* detection is depth-gated; `require`, `module.exports`, and `exports.x` are recognized at any depth (`index.js:172-200`, the ungated switch). Phase 3 rewrites `detect_named_exports` from scratch on primitives whose only gate is `fold_nesting_depth`, so the omission invites under-recognition of the commonest CJS shape (a `require` inside a function body). State the gate's scope. [proposed-rule: a design that names an existing implementation as its parity oracle must derive its primitive signatures from that oracle's actual state requirements, read and cited, before fixing them]

- **should-fix.** Design decision 1 ("The VM interpreter is the wrong layer and allocates a full AST") and § Honoring the allocation constraint ("the criterion that rejects (a1)") contradict § (a1), which verified the crate carries no lexer, parser, or AST and rejects on layer grounds. Confirmed: `rust/engine/ironhorse-vm/src/` has no `ast.rs`; `ast.rs` is in `ironhorse-compile`. Restate both on layer grounds. [rule: roles/jurors/critic/AGENT.md § Operating norms, secondary surface]

**Notes (out of scope but worth flagging):**

- `designs/README.md` moves M11 from 6 rows to 7 and the total from 63 to 64 while leaving both week ranges unchanged. Consistent with the row's own "not on the M11 critical path", but the design should say so where the totals live. [rule: designs/AGENTS.md § Progress Tracking]
- Phase 4's real-world/fuzzed corpus widening is the mechanism that would catch findings 1 and 2 empirically; the curated seed set will not. [rule: skills/panel-review/SKILL.md § Follow-up ledger]

Self-improvement: the critic brief tells the seat to read the design end to end but not to read the *oracle* a parity design names. Three of four findings here came from reading `packages/cjs-module-analyzer/index.js`, not the diff. Proposed as a rule in finding 3.
