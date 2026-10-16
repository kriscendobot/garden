## Report: the `http-content-plane` failure on macOS is a recurring flake, and draft PR #1486 fixes it

**It recurs.** The failure is always on `test (24.x, macos-15)`, in `@endo/daemon`'s `test/http-content-plane.test.js`, and always the same unhandled rejection: `TypeError: Cannot assign to read only property 'message' of object 'ClientDestroyedError'`. I found it on four runs of unrelated PRs, and every one went green on a rerun:
- #1309 on 2026-09-22
- #1426 twice on 2026-10-06
- #1476 on 2026-10-16

**Cause.** The test imports `@endo/init/debug.js`, which locks down with `overrideTaming: 'min'`. That leaves `Error.prototype.message` read-only. The `ClientDestroyedError` constructor in Node 24's bundled undici, which backs `globalThis.fetch`, assigns `this.message`, so it throws when the fetch connection closes. The error happens on every Node 24 run. On Linux it is only logged; on macOS the timing often lets ava count it as a failure.

**The fix already existed but never landed.** A 2026-10-03 job (`ebfb-daemon-test-flakes-20261003`) diagnosed this and wrote the fix as commit `cb6c8e0778`, in draft PR #1418. That PR has sat untouched since 2026-10-03, and its other commit (in `endo.test.js`) now conflicts with `llm`.

**What I did:**
- Cherry-picked `cb6c8e0778` alone onto current `llm`. It is a one-file, test-only change: the test now imports `@endo/init` (moderate taming), the same as the daemon itself.
- Opened draft PR **https://github.com/endojs/endo-but-for-bots/pull/1486** through `ensure-pr.sh`. Head is `fix/daemon-http-content-plane-undici-teardown`, base is the frozen `llm-a794753`. There is no changeset because the change is test-only.

**Verification:**
- CI on #1486 is fully green, including all four test legs (22.x and 24.x on ubuntu and macos-15) and lint.
- In the logs, `ClientDestroyedError` appears 0 times in #1486's Node 24 Linux and macOS jobs. #1476's last passing Node 24 Linux job, without the fix, logged it 4 times.
- I couldn't reproduce or test locally, because this host runs Node 22.

No garden-repo changes.

**Follow-ups:**
- #1486 is a draft named in this report, so the completion edge should stage its gauntlet automatically.
- After #1486 merges, #1418 needs a weave onto `llm`. That would drop the duplicate commit and resolve the `endo.test.js` conflict in its remaining commit `654bdbcad4` (a fix for a teardown rejection in that test). Otherwise it can be closed and that commit re-landed separately.
- #1476 itself needs nothing; the earlier rerun already turned it green.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-endojs-endo-but-for-bots-pr1476-gauntlet-fix-1-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1483694 cached reads)
- Output: 8696 tokens
- Cost: $1.0076348000000002
- Wall-clock: 2223s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
