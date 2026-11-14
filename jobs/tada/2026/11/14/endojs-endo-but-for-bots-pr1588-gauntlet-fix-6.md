# Gauntlet fix round 6: endojs/endo-but-for-bots PR #1588

I fixed all three failing style-prepass probes in one follow-up commit and pushed it. CI is green: all 36 checks finished, none failed.

**What changed** (commit `5d727f1dd1`, pushed with `safe-push-pr-head.sh` as a fast-forward from `5ca2ce64d0`):

- **`no-inline-import-jsdoc`:**
  - In `packages/fetch/index.js` and `packages/confined-fetch/index.js`, the inline `import('./src/types.js')` typedefs now come from a top-of-file `@import { X as XType }` with a matching `@typedef {XType} X`. This is the same pattern `packages/http-confine/index.js` uses.
  - In `packages/exo-http-client/test/http-client.test.js`, line 557 now uses a top-of-file `@import { PolicySnapshot }`.
- **`no-plain-reexport`:** both package entry points now carry a `reexport-policy-exempt` marker. They are each package's own public entry point, not compatibility shims, so there is no older home to deprecate. This matches what `packages/npm-registry-server/index.js` does.
- **`prefer-endo-primitives`:** the test's `Far('PolicyAuthority', …)` is replaced with `makeExo` from `@endo/exo`, guarded by `M.interface('PolicyAuthority', { decide: M.call(M.any()).returns(M.string()) })`. `@endo/exo` and `@endo/patterns` were already dependencies of the package.
- **Pruner comment advisory:** this one is non-blocking. I left the comment in `confined-fetch/src/index.js` as it is, because it states a revival requirement rather than describing the code next to it.

**Checks run locally:**
- All three probes now pass against the merge base.
- `ava` on the exo-http-client test: 49 passed.
- `tsc --noEmit` was clean for the three packages and for the repo-root `tsconfig.json`.
- `eslint` and `prettier` were clean on the changed files.

**Follow-up:** the job's standard `yarn install --immutable` failed on the native build. I installed with the node-modules/no-scripts workaround (`YARN_NODE_LINKER=node-modules YARN_NM_MODE=classic YARN_ENABLE_SCRIPTS=0`) to get the tooling. That install changed `packages/relay-server/src/index.js` (no line changes), and I reverted it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1588-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2049342 cached reads)
- Output: 8646 tokens
- Cost: $1.1065804000000001
- Wall-clock: 4012s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
