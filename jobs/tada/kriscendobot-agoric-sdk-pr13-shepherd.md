Empty inbox. My shepherd work is complete: I fixed the tractable failure myself and handed off the rest with a precise diagnosis. Here's the report.

---

## Shepherd report — kriscendobot/agoric-sdk PR #13

Drove CI on PR #13 ("build(xsnap): integrate Moddable 5.5.0 through the legacy/latest variant split"). Re-fetched live check state (head `2dc7ed735`); **7 checks failing**, which resolved into three classes:

### 1. Lint OOM — FIXED and pushed (shepherd's own fix)
`lint-primary` + `lint-rest` were dying with a Node **heap out-of-memory** (`ESLint killed by signal: SIGABRT`). Root cause: the PR adds a from-source Moddable 5.5.0 tree under `packages/xsnap/latest/{moddable,xsnap-native}/` (fetched+compiled at postinstall) and excluded it from **prettier** (`.prettierignore`) and **typecheck** (`tsconfig.build.json`, `tsconfig.quickcheck.json`) — but **missed `eslint.config.mjs`**, which only ignored the legacy `packages/xsnap/{moddable,xsnap-native}/` trees. The repo-wide `yarn lint:eslint` (`scripts/eslint-repo.mjs`, no target args → whole tree governed by the config's ignore list) therefore walked thousands of vendored Moddable tool sources and exhausted the heap.
- Added the two `latest/` paths to the `eslint.config.mjs` ignore list, mirroring the PR's existing prettier/tsconfig exclusions.
- Committed atomically (`151be9e70`) and pushed to `xst/integrate-variant-bump` (fast-forward). Fresh CI dispatched on the new SHA. Fix verified by static analysis of exactly what the failing job runs; convergence handed to the fixer to confirm.

### 2. chain-info baggage/vstorage snapshots — ESCALATED → `next: fixer`
`test-quick (node-new)`, `test-quick2 (node-old)`, `test-portfolio-contract (node-old)`, `test-boot (node-old, 2, 4)` fail on AVA snapshot diffs (e.g. `- 'agoric-3_injective-1': Object {…}`). Root cause: commit `333a12e52 chore(orchestration): refresh fetched-chain-info from registry` (added by a peer to satisfy `verify-codegen-idempotence`) added new IBC connections to `fetched-chain-info.js`; that data flows into every chainHub-using contract's baggage, but the downstream snapshots were never regenerated. Affected suites: `fast-usdc.contract`, `portfolio.contract`, `send-anywhere › baggage`, `vstorage-chain-info › config`.

This is **in-scope and fully diagnosed**, but the remedy (regenerate snapshots across ~4 packages via `yarn test --update-snapshots`) requires a full agoric-sdk workspace install whose xsnap `postinstall` compiles Moddable 5.5.0 **from source** — an environmental impasse in the gardener worktree. Posted a fixer job **`kriscendobot-agoric-sdk-pr13-fix-chaininfo-snapshots`** (shepherd→fixer auto-chain) with the exact package list, root cause, the "already-fixed lint, don't redo" note, and a flagged scope judgment (keep+regenerate here vs. split the unrelated chain-info refresh into its own PR).

### 3. test-ymax-planner-build — NOT fixable (fork infra)
`depot build` fails with `permission_denied: Invalid token` — the fork lacks the `DEPOT_TOKEN` secret. Not PR-caused, expected-red on any fork PR. Documented in the fixer job as out-of-scope; leave it.

**Net:** one tractable failure fixed and landed by the shepherd; the mechanical snapshot regeneration handed to a fixer with a complete diagnosis; one fork-infra failure classified as unfixable. PR CI will remain red until the fixer regenerates the chain-info snapshots.

**Changed:** `eslint.config.mjs` (+2 ignore lines), commit `151be9e70` on `xst/integrate-variant-bump`.
**Follow-up job posted:** `kriscendobot-agoric-sdk-pr13-fix-chaininfo-snapshots`.
