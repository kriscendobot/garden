CI on PR #1392 didn't finish within the 3600s deadline (`ci-wait-merge.sh` returned rc 4), so this stage is still pending and needs to be re-posted. All 30 other checks have passed, including lint and cover.

**What I did**
- **Starting point:** two `test (24.x)` jobs were failing at head 283927ab6. In `packages/marshal/test/parcel.test.js`, all five Parcel cases failed under the shims-only AVA config with `A tagRecord must be frozen: "[Parcel]"`. That config installs Parcel before lockdown without freezing it, so `passStyleOf` treats it as a remotable instead of a Parcel. The pass-style and patterns Parcel tests already skip in that case; the marshal test didn't.
- **f6695ee8b** `test(marshal): skip Parcel cases when the shim's Parcel is not frozen` adds the same `Object.isFrozen(Parcel) ? test : test.skip` gate. Locally, the five cases pass under the lockdown, unsafe and default configs and skip under shims-only.
- **5316b03b9** `style(pass-style): format parcel-gated-global test`: after my first push, CI lint failed on a Prettier error in `parcel-gated-global.test.js`, introduced by the PR's earlier commit baa3a4b17. I ran Prettier on it; eslint shows no errors on either test file, only two warnings that were already there.
- Both commits were pushed with `safe-push-pr-head.sh`; the PR head is now 5316b03b9.

**Coverage pass**
- No dead code is left orphaned by the change.
- The new `pass-style/src/parcel.js` is covered at about 96% of statements under shims-only and 93% under lockdown. The lines still uncovered (the early return for a missing or unfrozen global, the reentrancy guard, the `catch`) are what the dedicated adversarial-global tests exercise. Some test files crashed on this host under load, so I couldn't measure those lines here; when re-run alone they passed. No new tests were needed.

**Still pending at the deadline:** `test (24.x, ubuntu-latest)`, `test (24.x, macos-15)` and `test (22.x, macos-15)`. They queued for a long time; the ubuntu job started at 03:27Z and was still running at about 03:55Z, much longer than the roughly 4 minutes it took on the earlier failing run. If it still hasn't finished on the next check, it may be hung.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1392-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (3521237 cached reads)
- Output: 13531 tokens
- Cost: $1.6606994000000002
- Wall-clock: 6819s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
