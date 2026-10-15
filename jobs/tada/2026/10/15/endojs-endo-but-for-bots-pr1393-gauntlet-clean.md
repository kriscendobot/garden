---
orchestration-failed: true
---
orchestration-failed: true

**Clean stage for endojs/endo-but-for-bots#1393 failed.** CI on the final head `55bcd7235` is red: 32 of 33 checks pass, and `test (24.x, ubuntu-latest)` fails. The bounded `ci-wait-merge.sh` wait returned rc 3.

**The failure:** `packages/daemon/test/endo.test.js` exits non-zero because of an unhandled rejection, `Error: Termination requested`, during daemon teardown. The PR doesn't touch the daemon or that test, and the same suite passed on 22.x ubuntu, 22.x macOS and 24.x macOS, so it is probably a flake. I couldn't rerun the job: the bot token gets "Resource not accessible by personal access token". Someone with rerun rights should retry `test (24.x, ubuntu-latest)` in run 38678986955. If it goes green, re-post this clean stage.

**What I pushed** (with `safe-push-pr-head.sh`, head moved from `d4f9539f4` to `55bcd7235`):

1. **`82b52c453` — fixes for the two failures on the original head:**
   - **rankCover test:** `packages/patterns/test/rankCover.test.js` drew array elements from Passables that now include Parcels. By design, `getRankCover` throws "A parcel cannot be rank-ordered" when a Parcel is the first non-Key element, so the property test failed. That one test now draws its elements from a Parcel-free arbitrary. It passed 3 times locally.
   - **Lint:** Prettier-formatted `packages/patterns/test/rankCover.test.js` and `packages/pass-style/test/parcel-gated-global.test.js`, the two files lint flagged. The second one comes from the stacked base branch, not this PR.
2. **`6900d61a1` — coverage pass on the marshal changes.** New tests in `packages/marshal/test/parcel.test.js`:
   - the check that a `decodeParcel` hook returns a Parcel, for both capdata and smallcaps;
   - the check that an ordered Parcel encoding starts with "t".
3. **`55bcd7235`** fixes a TypeScript error in one of those new tests (`tsc` is clean in the marshal package).

**Dead code:** I found nothing the change orphaned. The Parcel rejection in `getRankCover` still matters because Parcels can't be patterns.

**Not covered:** the internal shape checks on the encode side in the smallcaps and capdata encoders are still untested. `makeMarshal` can't reach them because it always produces the right shape.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1393-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 14 tokens (708423 cached reads)
- Output: 2662 tokens
- Cost: $3.136026600000001 (1 engagement(s) unpriced)
- Wall-clock: 7278s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
