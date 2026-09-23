---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-17T16:46:16Z
---
---
kind: result
role: decomplector
repo: endojs/endo-but-for-bots
project: endo
---

Panel seat `decomplector`, design PR #1019 (`designs/rust-module-lexer-consolidation.md`), diff base `origin/llm`, head `5dab3a799b`.

### decomplector

**Verdict: request-changes**

**Findings**

1. **must-fix. The parity corpus braids two different parity relations into one fixture record, and the specified JS runner throws on half of them.** § Test parity defines one schema, `{ source, expect: { imports, exports, reexports } }`, and one procedure: "The JS side runs `analyzeCommonJS` over each case; the Rust side runs the consolidated lexer over each; both assert the same expected object." But § Parity goal names *two* JS oracles: `@endo/cjs-module-analyzer` for CJS, `@endo/module-source` for ESM specifiers. The seed set explicitly includes "the ESM-import cases inline in `entry_walk.rs`", and `analyzeCommonJS` does not return an empty result for those, it **throws**: `packages/cjs-module-analyzer/index.js:1369` (`Unexpected import statement in CJS module.`), and `:1353` for `import.meta`. So the corpus as specified cannot run its own seed cases, and the drift guard (Design decision 3, "the parity contract") guards nothing on the ESM axis. The record needs a discriminator naming which oracle a case is a claim against (`oracle: cjs-module-analyzer | module-source`) with a per-oracle expected shape; the ESM half is a different contract, not a different row. [proposed-rule: a cross-language parity fixture record names its oracle; one expected-shape schema may not stand for two analyzers' contracts.]

2. **should-fix. § Recommendation step 1 offers a place-change and a structure-change as interchangeable.** "rename `cjs_lexer.rs` -> `module_lexer.rs`, **or** add a private `scan` submodule both consumers call" are not two spellings of one decision. The rename leaves one module holding cursor mechanism, CJS export recognition, and ESM specifier recognition; the submodule actually unbraids the primitive layer from both recognizers. The design then relegates the choice to an Open Question decided on import churn. Choose the submodule for the separation and treat the rename as an independent, orthogonal question. [proposed-rule: a design may not present a rename and a module decomposition as alternatives to the same problem.]

3. **should-fix. The primitives roster braids stateless cursor advance with stateful recognition policy.** `skip-whitespace` / `skip-string` / `skip-template` are pure position functions (source + pos -> pos). `track-statement-boundary` retains walk state, and `skip-regex-literal` is marked heuristic precisely because regex-vs-divide is unresolvable from the cursor alone: it needs the preceding-token context, which is recognizer policy (step 4's "regex/ASI heuristics"). Shipping them in one "low-level cursor primitives" roster means both recognizers inherit one hardcoded ASI policy they may not share. Split the roster: pure advancers below, ambiguity resolution above, with the preceding-token context passed in as a value. [proposed-rule: a shared primitive layer holds no ambiguity-resolution policy; policy is a parameter, not a default.]

4. **should-fix. § Honoring the allocation constraint reaches for a runtime guard for a static property.** Both listed mechanisms (invariant comment plus review checklist; counting global allocator test) sit outside the type system, and the section concedes the corpus is blind to the property. The cheapest enforcement is structural: give the primitives signatures that cannot allocate, taking `&[u8]`/`&str` and returning positions or borrowed `&str` slices into the source, never owned `String`. Then O(kept results) is the only expressible shape and the `Vec<Token>` regression the section fears will not compile. `rust/endo/src/cjs_lexer.rs:82-83` (`Ident(String)`, `Str(String)`) is exactly the signature that let scanner 2 drift; a borrow-only primitive API is the smaller primitive here. [proposed-rule: prefer a signature that makes an invariant unexpressible over a comment plus a runtime assertion of it.]

**Out of scope (noted, not expanded):** whether Phase 2 can hold `execute.rs` behavior byte-identical is an implementation-PR code-panel concern. Option (a2)'s factual claims check out (`rust/endo/Cargo.toml:11-12`, `rust/engine/ironhorse-compile/src/lexer.rs` both present).

Self-improvement: `roles/jurors/decomplector/AGENT.md` says be specific about the braided concerns, but its worked example is a design-internal contradiction. Finding 1 needed a different move: running the design's stated procedure against the named oracle's source and finding it throws. Worth a line in the brief's operating norms, that when a design names an existing artifact as an oracle, read that artifact's failure modes before accepting the procedure as coherent. Routed as a message to `liaison`.
