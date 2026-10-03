# Gauntlet fix round 6 for endojs/endo-but-for-bots#1419: fixes pushed, CI green

I applied all three must-fix items from the round-6 panel review and pushed two commits to `llm-confined-application-makers-p2`, moving the head from `8d7eda22b3` to `4c833373a0`. CI finished green: all 33 checks are terminal and none failed (`ci-wait-merge` rc 0).

**Must-fix items applied:**
- **corner-prober:** three edge cases are fixed in `450c7be02a`, each with a new test.
  - **Empty `entry`:** `entry: ''` is now refused with a clear error instead of quietly capturing the wrong module. The entry check is now one shared `assertEntryAppliesToLayout` helper in `tree-layout.js`, called from both `host.js` and `manager.js`. That also clears purist's should-fix about the check being written twice. `captureNodeModules` refuses an empty entry as well.
  - **Empty compartment map:** a `node-modules-with-map` map with `compartments: {}` is now refused ("names no compartments").
  - **Mount at `/`:** `makeMountCanonical` now works for a mount rooted at `/`.
- **integrator:** in `4c833373a0`, the design doc `designs/agent-confined-application-makers.md` now says the `node_modules` layouts run only on a Node daemon supervisor. This is stated in the Phase 2 text and in a new Design decision 7, with a Phase 2b planned to close the gap. I also corrected the design's claim that it "adds no new XS gap". The PR stays draft.
- **pruner:** I removed the "files most critical to review" sentence from the PR body and cut the Scaling Considerations line to one sentence. I also posted a summary comment on the PR describing this round's fixes.

**Checks run locally:** the two capture and tree-layout test files pass (32 tests), `yarn lint:types` produces no errors, eslint reports no errors (warnings only), and prettier is clean.

**Not addressed (should-fix items, left for later):**
- removing the `'package'` layout value, which is always refused;
- renaming `runningAs`/`treeLayoutRunningAs` to one name and narrowing the bare `string` return types;
- keeping lookup-failure errors structured so mount host paths aren't joined into a plain message;
- using the `X` template in `refuse`;
- folding the `fix(daemon):` commits into the commits they correct, and dropping the `(#1339)` commit-subject suffix.

The gauntlet driver will post panel round 7.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-confined-application-makers-p2-makefromtree-20261003-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 66 tokens (2682754 cached reads)
- Output: 13670 tokens
- Cost: $1.5309187999999998
- Wall-clock: 2082s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
