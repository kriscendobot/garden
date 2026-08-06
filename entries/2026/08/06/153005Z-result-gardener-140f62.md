---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-06T15:30:07Z
---
project: endo-but-for-bots
prs: https://github.com/endojs/endo-but-for-bots/pull/946

Job consolidate-test262-fixtures. Refined the maintainer's follow-up refactor into a code-grounded design + rollout step 1, opened DRAFT PR #946 against `llm`.

Findings: the convergence design's steps 1-5 already landed (sibling `xs2rust-endor-262-*` jobs). ironhorse-xst already reads the single upstream `packages/test262-runner/test262` tree with a single shared YAML annotation parser (`frontmatter.rs`); `run-ironhorse-host.js` delegates to it. The real gap was the committed parameterized expected-pass/fail/skip lists (job's core) and a genuine architectural fork: the 1712 `ironhorse-262/cases` are bespoke bit-exact metering micro-cases, not upstream duplicates, so the directive's "fold into upstream tree" sketch conflicts with the parent design's proprietary-metering decision and would lose the byte-identity/compile-diff coverage. Surfaced to the maintainer (inbox/maintainer) with recommendation A (keep two trees, unify only the expectation accounting).

Delivered + verified: new `expectations` module (Outcome/Mode/Header/compare -> ratchet) with 9/9 unit tests; XstReport per-(case,mode) observed capture; `ironhorse-xst --expectations/--update-expectations/--strict-skip-reasons`. Oracle-backed proof on language/expressions/addition (48 files): 95-entry baseline, re-run 0 ratchet events exit 0 (no-net-change equivalence), injected drift fires ratchet exit 1. Full-corpus baselines deferred to a batched per-subtree oracle sweep (whole-tree run is the known OOM concern).

Self-improvement: nothing this time.
