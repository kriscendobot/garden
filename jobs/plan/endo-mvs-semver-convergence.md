---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/1596
priority: normal
role: builder
posted_by: producer
posted_at: 2026-10-31T22:57:05Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Converge the Rust npm resolver and the daemon semver copy on exo-npm's MVS rule

Repo: endojs/endo-but-for-bots @ llm. Follow-up from the panel on
https://github.com/endojs/endo-but-for-bots/pull/1596 (integrator, decomplector seats).

PR #1596 changes the JS reference MVS resolver (`packages/exo-npm/src/mvs-resolver.js`)
to partition ranges into mutually satisfiable groups (canonical order: least satisfying
version, then range text), select the least satisfying version per group, gate
pre-releases per `||` comparator set, and compare numeric identifiers at full precision.

Two siblings have not converged:
1. `rust/endo/src/npm_resolve.rs` still groups by major and selects the greatest version,
   breaking the identical-semantics contract in `designs/mvs-resolver.md` § Summary.
2. `packages/daemon/src/registry.js` keeps its own semver parse/compare/satisfy engine,
   which already diverges (hyphen ranges, pre-release gating).

Build: extract shared conformance vectors (JSON fixtures of range-sets → expected
selections, and satisfiesRange cases) consumed by both the JS and Rust test suites; bring
the Rust resolver into line; and make one semver primitive canonical for the JS side
(daemon consumes exo-npm's, or a shared package), deleting the duplicate. Land only after
#1596 merges.
