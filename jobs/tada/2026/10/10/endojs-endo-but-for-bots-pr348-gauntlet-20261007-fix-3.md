I applied the round-3 panel fixes to endojs/endo-but-for-bots#348 and pushed them. CI is green at head `4c26146932`. One blocking item could not be done as asked: the unrelated `ci:` commit is still in the PR, because CI fails without it.

**Blocking item (packager: drop `ci:` commit `496b4ffa42`):**
- I dropped the commit with a history rewrite and force-pushed (head `24b18786a9`). zizmor then failed: `ci.yml:270: action's hash pin has mismatched or missing version comment` (run 38066380100).
- So the commit is needed for CI on the frozen base `master-6ee3fda`. Six other open PRs also sit on that base (#1427, #1425, #1349, #972, #893, #586), so I left the base alone. I cherry-picked the commit back on top (now `4c26146932`) and added a paragraph to the PR body explaining why it rides along, citing that run.
- Panel-4's packager may block on this again. Clearing it for good means landing the comment fix on the frozen base or in a separate PR, and that is a maintainer call.

**Other items:**
- **Typedef check (should-fix):** nothing public was lost. `BundlerKit`, `BundleModule`, `BundleExit`, `GetBundlerKit` and `BundlerSupport` are all still in `src/bundle-lite.js`. Public types come only from `src/types-external.js`, and `package.json` `exports` has no `./src/*` path. No changeset change was needed.
- **PR body (pruner):** Scaling and Upgrade Considerations now each read just "None." I also removed the old drive-by `ci:` paragraph (replaced by the one above) and described the new tests under Testing.
- **Tests (corner-prober):** new commit `24b18786a9` adds two cases to `packages/compartment-mapper/test/bundle.test.js`:
  - When `moduleTransforms.cjs` and `syncModuleTransforms.cjs` are both set, the async transform's marker is in the bundle and the sync one is not.
  - `syncModuleTransforms: {}` and `undefined` each produce a bundle identical to omitting the option.

Locally the bundle tests pass (17, plus 1 known failure), and eslint, package `tsc` and root `tsc` are clean. `ci-wait-merge` returned rc 0: 15/15 checks green, none failed.

The coverage-auditor's note (no c8 report) was comment-only, so I left it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr348-gauntlet-20261007-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1382701 cached reads)
- Output: 8346 tokens
- Cost: $1.0155242
- Wall-clock: 674s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
