**Fix round 4 for endojs/endo-but-for-bots#1396 is done: all three of the panel's round-4 must-fix items are pushed and CI is green (33 of 33 checks, none failed).**

I pushed two commits to `build/sturdyref-captp-construct` (`13f96a7d89` → `117fc06c07`) with `safe-push-pr-head.sh`. They respond to the round-4 panel review (5378052284).

**Must-fix items:**
1. **Secret bytes leaking through `getSturdyRefData`:** `sturdyRefDetailsToData` in `packages/ocapn/src/client/sturdyrefs.js` used to hand back the same bytes the ref holds, so changing them changed which object the ref opens. It now returns a copy. A new test changes the returned bytes and checks that the ref is unchanged.
2. **Typedef location:** captp's `SturdyRefData` now lives in `packages/captp/src/types.js` and `captp.js` imports it from there. It also documents that the stored data always has `hints`, which covers the should-fix about `hints` being optional.
3. **Round-trip property tests:** new `fc.property` tests check that data survives `sturdyRefDataToDetails` followed by `sturdyRefDetailsToData`, and that `client.getSturdyRefData(client.makeSturdyRefFromData(d))` returns `d`. The object ids are both strings and byte arrays, and hints are sometimes present. A similar property covers captp's `getSturdyRefData(makeSturdyRefFromData(d))`.

**Should-fix items, also done:**
- Incoming bytes are now copied with `new Uint8Array(objectId)` instead of `.slice()`, which a subclass could override.
- Both packages now check every property on the data, including hidden (non-enumerable) ones, against the allowed set and reject any extras. A test was added in each package.

**Checks:**
- The captp (53) and ocapn (571) test suites pass locally.
- `yarn lint` reports no errors, only warnings.
- The repo-root `tsc -p tsconfig.json` showed no errors in captp or ocapn.

I also posted a summary comment on the PR (issuecomment-5929752706). I did not re-run the panel; the gauntlet driver posts panel round 5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2314909 cached reads)
- Output: 14333 tokens
- Cost: $1.4800498000000004
- Wall-clock: 2380s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
