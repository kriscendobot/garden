Clean stage for endojs/endo-but-for-bots PR #1425 is done: nothing needed changing, and CI is green.

- **PR:** "fix(ses): build the XS lockdown Compartment from lockdown intrinsics". It is still a draft, its head is `2db6a81714`, and its base is `fix/zizmor-paths-filter-pin-comment-1b1ead4`.
- **Coverage:** The new branch in `repairIntrinsics` (the `onShimStartCompartment` callback, `packages/ses/src/lockdown.js`) is exercised by the new XS checks in `packages/ses/test/_xs.js`. Those checks cover deleted, replaced and added globals and the secure-mode `Date`/`Math` behavior. The path where no callback is passed is the normal path on every other engine, so the existing suites already run it. No tests to add.
- **Dead code:** None. The PR stops importing `ShimStartCompartment` in `lockdown-shim.js`, but `src-xs/compartment.js` still uses it for `shimCompartmentPrototype` and the `globalThis` getter, and `compartment-shim.js` still imports it.
- **Pushes:** None, since nothing changed.
- **CI:** `ci-wait-merge.sh --no-merge` returned 0, with all 15 checks finished and none failed.

Follow-ups: none from this stage. Panel review comes next.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1425-gauntlet-20261030-run-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (239514 cached reads)
- Output: 1663 tokens
- Cost: $0.4674908
- Wall-clock: 31s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
