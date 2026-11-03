---
orchestration-failed: true
---
**Clean stage for #1643: failed. CI is RED at head `a4bc0f6c7`, and neither failure comes from this PR's code.**

**Coverage and dead code: no changes, nothing pushed**
- **CI coverage:** the `cover (22.x)` log shows `@endo/skills` at 100% for statements, branches, functions and lines on all four source files.
- **Local coverage:** the `yarn test:c8` run passed all 23 tests with 99.66% line coverage. The only gap is `src/node.js:56-57`, the arm that stops at the filesystem root when no `.git` is found. I attribute that to the temp directories on this host sitting under the garden's `.git`, though I didn't test that; CI does reach the arm.
- **Dead code:** the change orphans nothing. Outside `packages/skills`, `designs/`, `.changeset/` and `yarn.lock` it touches no files, and every export in `src` is public API. The last commit on the PR had already removed the one unreachable arm.

**CI: `ci-wait-merge.sh --no-merge` returned rc 3 (36 checks, 2 failed, run 41573997385)**
1. **`test-xs`:** `sesNode/module` now fails `test/intrinsics/ThrowTypeError/intrinsic-metadata.js`, reported as "Result baseline changed".
   - The job log shows "Attempting to download 26", because `.node-version` is `lts/*` and that now resolves to Node 26.
   - `.node-version` on `llm` is still `lts/*`, so any PR that triggers `test-xs` is likely to hit this. The maintainer was told earlier today, and the fix was awaiting their decision.
2. **`cover (22.x, ubuntu-latest)`:** `@endo/sandbox#test:c8` fails on `bwrap timeout and repeated cancellation reap process groups` with "process group 13857 survived bounded cleanup".
   - This intermittent failure has hit other PRs, including #1586 and #1476. The proposed fix, #1591, is still open and unmerged.
   - The `@endo/sandbox` tests are in the affected set this PR's CI ran, but the PR doesn't change that package. In the same job, `@endo/skills:test:c8` passed.

I didn't rerun CI: a rerun can't clear the `test-xs` failure, and no garden skill authorizes one. No clean=done marker is emitted, so the driver should halt the gauntlet and surface this.

**Follow-ups**
- **Unblock:** the gauntlet needs a maintainer decision on the Node 26 `test-xs` baseline (pin Node 24, relax the assertion, or update the baseline). Landing #1591 would remove the bwrap failure. Once both are settled, re-weave #1643 if the fix is on a newer base and rerun this stage.
- **Memory:** I added this recurrence to the fleet memory note on the sandbox CI failures.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1643-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s) (1 unmetered)
- Input: 60 tokens (2210740 cached reads)
- Output: 30145 tokens
- Cost: $2.289824 (1 engagement(s) unpriced)
- Wall-clock: 5358s

<!-- garden-usage-end -->
