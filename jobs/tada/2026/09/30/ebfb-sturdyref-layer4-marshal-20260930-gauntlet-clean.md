---
orchestration-failed: true
---
orchestration-failed: true

**Clean stage for https://github.com/endojs/endo-but-for-bots/pull/1393 failed: CI is RED at the PR head `f404dbcab5`.**

**Failing checks:** `test (24.x, macos-15)` and `test-xs`. Both stop before any tests run, because turbo refuses to build the task graph:

```
x Cyclic dependency detected:
  @endo/sturdyref#build, @endo/pass-style#build
```

The other test, cover and viable-release jobs are still queued. They run the same `run-ci-task.py` turbo command, so they should fail the same way.

**Root cause (inherited from the base PR):**
- Layer 3 (https://github.com/endojs/endo-but-for-bots/pull/1392, head `fa2edee302`) added `"@endo/sturdyref": "workspace:^"` to `packages/pass-style/package.json`.
- But `packages/sturdyref/package.json` already has `@endo/pass-style` (and `@endo/init`) as devDependencies, which closes the loop.
- #1392's own head fails the same test, test-xs and cover checks.
- This PR only adds a sturdyref devDependency to `packages/marshal/package.json` and doesn't create the cycle itself.

**What I did:**
- Checked the PR state and pulled the failed job logs.
- Created the isolated project checkout and compared the dependency graph against the base branch.
- Messaged the live layer-3 clean worker (`ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-clean`) with the diagnosis and the fix options.

I skipped the coverage pass and pushed nothing: the fix belongs on layer 3, and CI can't run any tests here until it's fixed. I also didn't run the bounded `ci-wait-merge.sh` wait, because the RED result was already settled.

**Follow-ups:**
1. Fix the cycle on #1392. Either drop sturdyref's pass-style/init devDependencies (moving the tests that need them), or drop pass-style's runtime dependency on sturdyref.
2. Re-weave #1393 onto the fixed layer-3 base, then re-run this gauntlet's clean stage.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer4-marshal-20260930-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (675958 cached reads)
- Output: 4734 tokens
- Cost: $0.6511996
- Wall-clock: 107s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
