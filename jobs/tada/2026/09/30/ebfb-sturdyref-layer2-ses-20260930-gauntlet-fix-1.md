Gauntlet fix round 1 for endojs/endo-but-for-bots#1391 is done, and CI is green on head `c78271e1f1` (33/33 checks passed, 0 failed; `ci-wait-merge.sh --no-merge` returned rc 0).

**What I found:** The panel reviewed head `a0ef0c4320` and asked for changes. When I claimed the job, the PR head already had three follow-up commits from a previous run of this job that addressed the code must-fix items. I checked each item against the diff and pushed no new code commits:
- **b6cbc3ac0f** — Renames `desc` to `descriptor` (stylist). The first-wins skip in `global-object.js` is now limited to an explicit list containing only `SturdyRef` (breaker, spec-keeper, wire-watcher, saboteur). The skip also requires the shim's exact property descriptor: value matched with `is()`, non-writable, non-enumerable and non-configurable. The code comment is reworded as purist asked.
- **571b976bcd** — Adds tests that pin the old fail-closed behavior (breaker, corner-prober): a pre-lockdown locked `JSON` still makes `lockdown()` throw (`global-locked-universal.test.js`), and so does a locked but enumerable `SturdyRef` (`sturdyref-misshapen.test.js`). It also adds a `SturdyRef` smoke test to the `ses` package's XS run (`test:xs`), which covers the engine-realist and coverage-auditor requests on the `ses` side.
- **c78271e1f1** — Narrows a type in the XS smoke test so `lint:types` passes.

**What I changed this run (PR text only):**
- **PR body rewritten** (pruner's must-fix): I removed the 9-layer stack index, which now points to the arc issue, and folded the one-sentence sections together. I also corrected stale statements: the base is now `ef4662f` rather than `95609a7`, and #774 now has a pre-lockdown install path.
- **Explained the `sturdyref` XS stub:** `packages/sturdyref`'s `test:xs` is still `exit 0`, and the body now explains why, as coverage-auditor's option (b) allows. Its tests are ava suites with no XS harness, and the `ses` XS smoke already covers the engine behavior this PR depends on.
- **Summary comment posted** on the PR mapping each panel item to the commit that fixes it: https://github.com/endojs/endo-but-for-bots/pull/1391#issuecomment-5908569660

**Follow-ups:**
- The panel-2 stage (posted by the driver) should confirm that the rationale in the PR body is enough for coverage-auditor, since the `sturdyref` XS test is still a stub.
- Items the panel marked optional were not done: fast-checker's property tests and the other smaller suggestions.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 108 tokens (4358076 cached reads)
- Output: 24962 tokens
- Cost: $2.6757752
- Wall-clock: 7576s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
