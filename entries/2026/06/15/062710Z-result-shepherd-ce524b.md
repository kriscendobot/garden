---
ts: 2026-06-15T06:27:10Z
kind: result
role: shepherd
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: steward
dispatch_root: /home/kris/dispatches/shepherd--ce524b
prs:
  - repo: endojs/endo-but-for-bots
    pr: 443
    role: target
refs:
  - entries/2026/06/15/062200Z-dispatch-shepherd-ce524b.md
  - https://github.com/endojs/endo-but-for-bots/pull/443#issuecomment-4705152322
---

# result: shepherd — Rollup retention audit on PR #443

Answered kriskowal's question on PR #443 (`endojs/endo-but-for-bots#443`, branch `dependabot/npm_and_yarn/all-minor-patch-ad11f6292f`, head `ec81c3b7e`) with a per-package Rollup map and a load-bearing assessment. No project files modified; comment-only authorization exercised.

## Rollup map (working-tree at `ec81c3b7e`)

**Direct workspace dep** (one site):

- `packages/benchmark` declares `rollup ^4.34.6`, `@rollup/plugin-commonjs ^28.0.2`, `@rollup/plugin-node-resolve ^16.0.0`, `@types/rollup ^0.54.0`. The `rollup.config.js` bundles `test/index.test.js` into `dist/bundle.js` (IIFE format) for `eshost -h xs,v8` cross-engine benchmark execution. Invoked by `run-tests.sh` (`yarn rollup -c`) and the `cpu-prof-test` script.

**Transitive dep** (one site, via `vite`):

- `packages/chat` depends on `vite ^6.0.0`. Vite carries `rollup ^4.34.9` as its production bundler. `packages/chat/vite.config.js` uses `build.rollupOptions` to set the HTML entry. No direct rollup spec in chat's `package.json`.

**Historical / stale references (not usage)**:

- `packages/ses/src/enablements.js`: rollup is named in comments motivating `severe` enablements.
- `packages/cjs-module-analyzer/test/cjs-module-analyzer.test.js`: test titles characterize rollup-generated CJS shape; analyzer does not call rollup.
- `packages/import-bundle/test/import-bundle.test.js`: comment claims `bundleSource` uses `rollup()` in `getExport` mode. `@endo/bundle-source` no longer depends on rollup (replaced by `amaro`); the comment is stale.

`yarn.lock` resolves `rollup@4.62.0`; vite's `^4.34.9` and benchmark's `^4.34.6` unify on a single hoisted version. The dependabot bump itself moves the catalog spec from 4.60.3 to 4.61.1 (yarn.lock already shows 4.62.0 because the bump pulled the latest patch line).

## Load-bearing assessment

- `@endo/chat` via vite is the only difficult site; replacing rollup means replacing vite. Designer-level decision.
- `@endo/benchmark` is replaceable: any IIFE-capable bundler (esbuild, `@endo/bundle-source`) drops 4 direct dependencies without affecting any other package. Builder-level work.

## Action taken

- Top-level comment posted on PR #443: <https://github.com/endojs/endo-but-for-bots/pull/443#issuecomment-4705152322>. Authorized by dispatch.
- No push, no close, no other comments.

## Escalation classification

`next: liaison`

The maintainer's question is directional, not a CI failure. The PR has `mergeable_state: unstable` (not failing) and the comment lays out the choice between (a) merge bump now and pursue rollup retirement separately, (b) close this PR and address rollup first, (c) other. This is a design / direction call requiring the maintainer's pick before any role can move; the steward should surface the decision request to the maintainer rather than auto-chain a builder. A `next: builder` chain is only correct if the maintainer responds "yes, drop rollup from `@endo/benchmark`"; pre-empting that would land work the maintainer may not want.

Self-improvement: nothing this time.
