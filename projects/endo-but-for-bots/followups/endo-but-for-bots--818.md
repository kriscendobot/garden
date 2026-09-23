---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 818
upstream_mirror_repo: null
upstream_mirror_pr: null
created_at: 2026-07-21T22:11:11Z
last_appended_at: 2026-07-21T22:11:11Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#818

Created from the code-panel verdict (16 seats, design-assessment posture) on the full CommonJS `require` linkage in the archive loader (`feat/endor-cjs-require-linkage`, base `llm`). Two must-fix items and a should-fix bundle were addressed in the fixer commit `6ca13e396`; the items below are dispositioned follow-up and revisited when the PR (or its upstream mirror) merges.

## Items

- [ ] **Regression tests for documented-but-unpinned invariants**.
  **Source juror(s)**: breaker, corner-prober, prover, pruner, engine-realist.
  **Round**: 1.
  **Recommended action**: add tests for the require-cycle throw-eviction retry path; a builtin `require('fs')` clean cannot-find; the CJS wrapper `this === module.exports` binding (fixed in 6ca13e396, no test yet); `require.resolve`/`__filename`/`__dirname`; bare-subpath `.json`/`index.json` completion; a `require`-conditions dual-package *subpath*; and a negative test pinning ESM-import-of-CJS binding only `default`.

- [ ] **Completion-set asymmetry between require and import subpaths**.
  **Source juror(s)**: corner-prober.
  **Round**: 1.
  **Recommended action**: align `__lookupRequire` (relative, completes `.json`/`index.json`) with the bare-subpath path through `__resolveExports`/`__lookupSource` (does not), or document the divergence. `require('dep/data')` and `require('dep/dir')` currently miss `.json`/`index.json` completion.

- [ ] **Relative-specifier detection and require.resolve identity**.
  **Source juror(s)**: saboteur, gateway, pruner.
  **Round**: 1.
  **Recommended action**: `__resolveRequire` treats any leading-`.` specifier as relative (Node uses only `./`,`../`,`/`), so `require('.foo')` misresolves; and `require.resolve` returns the bare compartment-local key, dropping the compartment, so a cross-package resolve is ambiguous. Make relative detection Node-faithful and return a compartment-qualified id.

- [ ] **API/robustness hygiene: non_exhaustive, JSON parse, ESM shebang, shared resolver**.
  **Source juror(s)**: surfacer, saboteur, breaker, integrator, pruner.
  **Round**: 1.
  **Recommended action**: consider `#[non_exhaustive]` on the `pub LoadedArchive`; parse `.json` via `JSON.parse` rather than object-literal eval (`__proto__`/U+2028-U+2029 divergence, pre-existing but now exercised by `require`); strip shebang/BOM before parser selection so ESM `#!` entries do not syntax-error; and factor the near-duplicate `__lookupRequire`/`__lookupSource` and CJS/ESM link-subpath resolution into one resolver parameterized by condition order.

- [ ] **Offline-fixture end-to-end test for a real CJS package graph**.
  **Source juror(s)**: assessor, skeptic.
  **Round**: 1.
  **Recommended action**: the `semver@7.5.4` -> `lru-cache` -> `yallist` path is proven by the PR's real-execution demo but only reachable via synthetic-registry/test-injected state in the suite. Add an offline-fixture test that fetches/caches/executes a real CJS package graph so the works-claim is pinned by CI.
