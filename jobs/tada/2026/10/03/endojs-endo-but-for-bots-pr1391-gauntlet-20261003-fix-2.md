---
orchestration-failed: true
---
orchestration-failed: true

**Fix round 2 for endojs/endo-but-for-bots#1391: all four panel items are fixed and pushed, but CI is red on one cell.** The failing test is a macOS daemon test that looks unrelated to this PR.

**The fixes.** An earlier claimant of this job had already pushed three follow-up commits (11:21Z) onto the round-2 head `61a08fd144`, so I applied nothing new. The current head is `d9042f635d`. I checked each panel item against that diff:

1. **saboteur (Proxy re-pointing):** `assertSturdyRefShape` is now `sampleSturdyRef`. It returns the value it validated, and `makeIntrinsicsCollector(reporter, presampled)` admits that exact value instead of reading `globalThis` again. New test `sturdyref-reentrant.test.js` covers this, using a Proxy whose trap re-points the global.
2. **breaker (shape check too loose):** the check now also requires an own `prototype` property holding an object, and the error message says so. New test `sturdyref-arrow.test.js` checks that an arrow function carrying the two statics is refused.
3. **spec-keeper (changeset wording):** the changeset now separates what throws (a non-configurable binding with the wrong attributes, or any accessor) from what doesn't (a configurable binding of the right shape is overwritten as writable and configurable, keeping the same value).
4. **coverage-auditor (XS claim):** the PR body now says XS coverage lives in `packages/ses`'s `test:xs`, and that `packages/sturdyref`'s own `test:xs` is a stub.
- **engine-realist (should-fix):** `getOwnPropertyDescriptor` in `setGlobalObjectMutableProperties` now runs only after the `firstWinsPropertyNames` membership check.

**CI.** `ci-wait-merge.sh --no-merge` returned **rc 3 (RED)**. 32 of 33 checks passed. The one failure is `test (24.x, macos-15)`, in `@endo/daemon`'s `daemon-teardown › an orphaned daemon shuts itself down instead of lingering`. It fails at `daemon-teardown.test.js:196` because `endo.pid` reads 0 right after the launcher exits. I reran the failed job once and it failed again in exactly the same way.

**Why it looks unrelated.** The PR only touches `packages/ses`, `packages/sturdyref` and a changeset. The daemon doesn't install a `SturdyRef` shim, and `ocapn.js` only uses the `makeSturdyRef` and `enlivenSturdyRef` client methods. The other `daemon-teardown` tests pass on macOS, and every Ubuntu cell is green. That test reads the pid file once with no retry, so a slow macOS start can make it fail by timing alone. The earlier run at `61a08fd` (08:29Z) passed. So the failure is consistent across two runs on this head, but I haven't proven it is a flake.

**Follow-ups:**
- Rerun or investigate the macOS daemon cell once more before panel-3.
- If it keeps failing, give the test's `readPid` a retry loop, as a separate daemon fix (the test came from #1309).

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-gauntlet-20261003-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 112 tokens (4247075 cached reads)
- Output: 29214 tokens
- Cost: $2.8036629999999994
- Wall-clock: 6832s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
