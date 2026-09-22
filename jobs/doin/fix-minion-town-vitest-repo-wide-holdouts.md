---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Finish the repo-wide vitest migration in minion.town (node:test holdouts)

Origin: maintainer directive on kriscendobot/minion.town#87 (issue comment
5770443815, kriskowal, 2026-09-22): "Repo-wide migration to vitest. The Endo
repository dictates house style." This supersedes an earlier "this house uses
ava" review (5273122355), which was reversed — the runner is **vitest**, not
ava. (See the withdrawn job `fix-minion-town-migrate-tests-to-ava-20260922`.)

## Why this job exists (the gap the reversal left)

The app's main suite is already vitest (root `vitest.config.ts`, `npm test` ==
`vitest run`, ~51 test files). But the migration is **not** actually repo-wide:
two self-contained sub-packages still run `node --test` and are deliberately
**excluded** from the root vitest surface. Finishing "repo-wide migration to
vitest" means bringing these onto vitest too, per Endo house style (each Endo
package carries its OWN vitest config + `"test": "vitest run"`).

The holdouts (verified on kriscendobot/minion.town @ main, 2026-09-22):

1. **`tools/claude-harness/`** — `package.json` `"test": "node --test *.test.mjs"`;
   2 files `install.test.mjs`, `release-verifier.test.mjs` (import `node:test` +
   `node:assert/strict`). Run in CI via the root `claude-harness:test` script
   (`.github/workflows/test.yml`, "Check Claude harness pin and verifier" step).
   `type: module`, currently zero devDeps.
2. **`deploy/thunks/siwe/`** — `package.json` `"test": "node --test \"test/*.test.js\""`;
   2 files `test/oidc-face.test.js`, `test/siwe-verify.test.js` (import `node:test`
   + `node:assert/strict`). NOT invoked in CI today (no siwe test step exists);
   `type: module`, own deps (`jose`, `viem`).

Root exclusions to reconcile once converted:
- `package.json` root `"test"`: `vitest run --exclude 'deploy/thunks/siwe/test/**'
  --exclude 'tools/claude-harness/**'`.
- `vitest.config.ts` `test.exclude`: `.endo-checkout/**`, `deploy/**`, `infra/**`.

## What to do

Follow Endo house style: **per-package vitest**, keeping each sub-package
self-contained (its own install, its own runner) rather than folding their globs
into the root vitest (the root config comment explains why the root must NOT glob
their tests — a plain root install lacks their deps).

Per holdout package:
- Add `vitest` as a devDep to that package's `package.json`.
- Add a minimal `vitest.config.ts` (or `.mts`/`.js` matching Endo's chosen
  form) scoped to that package.
- Change its `"test"` script to `vitest run`.
- Convert its `node:test` files to vitest: `test('name', ...)` /
  `describe`/`it` per Endo's flat-vs-nested convention; `node:assert/strict`
  (`assert.equal`/`deepEqual`/`throws`/`rejects`) → vitest `expect(...).toBe /
  toEqual / toThrow / rejects.toThrow`; any `before/after` hooks →
  `beforeAll`/`afterAll`/`beforeEach`. Rename files if house style prefers
  `.test.ts`; keep them JS/mjs if that's cleaner — the SIWE thunk is bundled by
  esbuild for a lambda, so avoid adding a TS build burden it doesn't already carry.
- Update the root wiring so CI still runs each package's tests: the
  `claude-harness:test` script (`npm --prefix tools/claude-harness test`) now
  runs vitest; decide whether the SIWE thunk's vitest suite should be added to CI
  (it currently isn't — reasonable to add a step, or at minimum leave it runnable
  locally via `vitest run`). Remove the now-obsolete root `--exclude` flags /
  `vitest.config.ts` excludes only where the corresponding globs are genuinely
  gone; keep `.endo-checkout/**` excluded (it's a fixture checkout).

## Gates (both must be green — the two CI gates)
- `npm run typecheck` (root) clean.
- `npm test` (root vitest) green AND each converted sub-package's `vitest run`
  green. In CI, `npm run claude-harness:check` + `claude-harness:test` must pass.

## Mechanics
- minion.town PR #87 is MERGED — do NOT reopen it. Open a **fresh dedicated PR**
  against `main` via `ensure-pr.sh` (draft; run the gauntlet is a separate
  maintainer trigger).
- If, on inspection, you conclude a holdout must legitimately stay on `node:test`
  to honor Endo house style (e.g. a zero-dep lambda bundle Endo keeps on the
  platform runner), do NOT force it — surface that one exception to the
  maintainer via the inbox and convert the rest; state the reasoning in the PR.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-22T04:24:19Z
