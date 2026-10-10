# Fix round 1 report: endojs/endo-but-for-bots#348

I applied the panel-1 fixes, pushed them to the PR head, and CI is green. The head is now `f79e37a021` and all 15 checks passed.

**Blocking items**
- **PR body follows the upstream template (integrator).** I rewrote it with Description and the six Considerations sections in template order. It now tells the "dedup, then restore `syncModuleTransforms`" story and lists every commit.
- **Cuts the pruner asked for.** I removed the test tallies, the "Relationship to existing mirrors" section and the old Provenance section. The old body was also out of date: it described a `captp` file and a default-chaining commit that are no longer in the diff.

**Should-fix items**
- **The unrelated `ci:` commit.** The body now says why the `dorny/paths-filter` comment change from `# v3` to `# v3.0.3` is included: zizmor was failing on it. The pinned SHA does not change.
- **No test for the restored option.** `b07ee9ba33` adds two tests in `test/bundle.test.js` that pass a counting `syncModuleTransforms` to `makeScript` and `makeFunctor`. They check that the transform runs and that the bundle still evaluates correctly. With the restore in `bundle-lite.js` reverted, both tests fail.
- **Duplicate typedefs in `bundle.js`.** `81c444255d` removes the unused `BundlerKit`, `BundleModule`, `BundleExit`, `GetBundlerKit` and `BundlerSupport` typedefs from `bundle.js`, along with the type imports only they used.
- **Missing changeset (integrator).** `f79e37a021` adds a patch changeset for `@endo/compartment-mapper`. Before this PR, the lite entry points (`functor-lite.js`, `script-lite.js`) ignored `syncModuleTransforms`; now they apply it. I checked the base: `bundle.js` used the option and `bundle-lite.js` did not.

**Checked locally:** the compartment-mapper bundle tests (14 pass, plus 1 test already marked as expected to fail), package `tsc`, root `tsc` (no errors in the changed files), eslint and prettier.

**Not done:** I did not add the corner-prober's suggested test that tampers with `Array.prototype[Symbol.iterator]`; the panel did not require it. The archivist's JSDoc concern needed no change: `bundle-lite.js` already documents the two functions, and `bundle.js` keeps the JSDoc on its own exports.

I pushed with `safe-push-pr-head.sh` in advance mode, so no existing commits were rewritten. There was no garden repo change.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr348-gauntlet-20261007-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (2642934 cached reads)
- Output: 11257 tokens
- Cost: $1.4061588
- Wall-clock: 582s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
