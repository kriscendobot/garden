Completion report: fix-endojs-endo-but-for-bots-pr1646-node-twenty-six-compatibility

PR #1646 now keeps the `.node-version` pin at 24 and still tests Node 26. The panel finding is resolved and the Node 26 CI lane is green. Two ironhorse-oracle checks are still red for a reason this PR doesn't cause (see CI below).

**Panel finding:** breaker (must-fix) and engine-realist (should-fix) said the pin dropped all Node 26 coverage, although the packages declare support for Node `>=22.9.0`.

**Commit c377ad8607** (`ci(hardened262): keep a Node 26 sesNode lane with a version-scoped baseline`):
- **Version-scoped baseline:** `packages/hardened262/scripts/test.js` now applies `baseline-overlays/node<major>/` on top of `baseline/` when comparing. The overlay has the same layout and lists only the results that differ on that Node major.
- **The Node 26 overlay** has one entry: `sesNode/module failed test/intrinsics/ThrowTypeError/intrinsic-metadata.js`. It fails because Node 26 gives `Function.prototype.caller` its own get/set accessors.
- **Updating the baseline on Node 26** keeps `baseline/` unchanged for overlaid entries, so Node 26 results can't leak into it.
- **`--baseline` with `--agent`** now compares only the selected agents' scenarios. The `zeroCoverage` list depends on which agents ran, so it is compared only on full runs.
- **CI:** the `test-xs` job gets two new steps. They set up Node `26.x` and run `node scripts/test.js --agent sesNode --baseline baseline`.
- **Tests and docs:** five new unit tests, one of which checks that every overlay entry actually differs from `baseline/`. The README section on baselines is updated.

**Commit 0e55ba8d09:** changes the `create-pull-request` version comment from `# v8` to `# v8.1.1` in both `update-action-pins` workflows. The `v8` tag has moved, so zizmor failed on the base branch too; this clears it.

**Local checks:**
- With the real downloaded binaries, `sesNode --baseline baseline` exits 0 on Node v24.22.3 and on v26.13.1.
- On v26.13.1 without the overlay it exits 1 and names exactly that one entry.
- `node --test` passes 34/34; `yarn lint` and prettier pass.

**CI on head 0e55ba8d09:**
- **Passing:** `test-xs` (including both Node 26 steps), zizmor, android, and the full test matrix.
- **`test (24.x, ubuntu-latest)`:** failed once on the known `@endo/sandbox` bwrap reap flake and passed on rerun.
- **Still failing:** `test-ironhorse-oracle` and `ironhorse-oracle-sanitizers`, on stage3-math 054/055. This is the known ubuntu-26.04 glibc divergence, fixed in #1613. These jobs only ran because this PR touches `ci.yml`.

The PR title and body are updated, and I posted a reply to the finding on the PR.

**Follow-ups:**
- Once #1613 lands on the base branch, the PR needs a weave to clear the two oracle reds.
- A later deliberate SES-side fix for `caller` on Node 26 would delete the overlay entry.
- The PR needs a fresh panel round.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-endojs-endo-but-for-bots-pr1646-node-twenty-six-compatibility.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 130 tokens (6106511 cached reads)
- Output: 28726 tokens
- Cost: $2.6728942
- Wall-clock: 8264s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
