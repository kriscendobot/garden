Fix round 3 for PR #1594 (https://github.com/endojs/endo-but-for-bots/pull/1594) is pushed and CI is green: 36 checks, 0 failed.

**The finding:** the style pre-pass flagged one item. `packages/daemon/src/interfaces.js:1025` re-exported `WorkerFacetForManagerInterface` from `./worker-facet-interface.js` without a `@deprecated` tag. The probe counts it as a new re-export because the rename changed the name from `WorkerFacetForDaemonInterface`.

**The fix** (commit `50b82489fd`, pushed with `safe-push-pr-head.sh --mode advance` on top of `3c20a5820a`):
- **Removed the re-export.** Both workers (`worker.js` and `bus-worker-xs-facet.js`) already import the guard from `./worker-facet-interface.js`, and the rename already breaks anything that imported the old name from `interfaces.js`. Keeping an undeprecated stand-in for the new name served no purpose. A short comment in its place says where the guard now lives.
- **Updated the header comment** in `worker-facet-interface.js`: it no longer says `interfaces.js` re-exports the guard, and tells importers to import it from this file.
- **Removed one test** from `test/xs-worker-facet.test.js`. It only checked that the copy from `interfaces.js` was the same object as the original, and that copy no longer exists. The other 12 tests in the file pass.

**Checks:**
- The `no-plain-reexport` probe passes, both on the staged change and against the base `origin/llm-9a14ddf`.
- eslint on the three changed files reports 0 errors (7 warnings).
- `ci-wait-merge.sh` returned rc 0 after about 34 minutes.

**For review:** `./src/interfaces.js` is a public export of `@endo/daemon`, so outside code can no longer get this guard from the package. `worker-facet-interface.js` is not in the package's exports. No package in the repo imports the guard. If outside code needs it, add an export entry for `worker-facet-interface.js`.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1594-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1090404 cached reads)
- Output: 6144 tokens
- Cost: $0.8141688000000001
- Wall-clock: 2785s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
