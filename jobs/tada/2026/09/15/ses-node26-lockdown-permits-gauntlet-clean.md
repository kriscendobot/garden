CI is GREEN after the re-run — confirming the earlier `write EPIPE` was a daemon flake, not diff-attributable. The clean stage is complete.

## Completion report

**Job:** `ses-node26-lockdown-permits-gauntlet-clean` — CLEAN stage of the `ses-node26-lockdown-permits-gauntlet` on endojs/endo-but-for-bots PR #1281 (*fix(ses): silence lockdown intrinsics report for URL blob statics*).

**What I did**

- **Assessed the diff.** The PR touches only `packages/ses/src/permits.js` (a whitelist/permit-table addition: `fnWithUndeletablePrototype` for the URL blob statics + three `RegisteredSymbol(nodejs.util.inspect.custom): false` exclusions) plus a changeset. No code was orphaned by the change — nothing to remove.
- **Coverage pass on the touched package.** The change had no regression guard locking in the silencing it delivers. I added a focused assertion to the existing `packages/ses/test/error/permit-removal-warnings-node.test.js` (which already spawns a real `lockdown()` subprocess) asserting the intrinsics-removal report contains **no** line for `createObjectURL.prototype`, `revokeObjectURL.prototype`, or `RegisteredSymbol(nodejs.util.inspect.custom)`. A future `permits.js` regression now surfaces as a test failure. Verified locally under Node 22.23.2 (test passes; eslint clean; manual grep confirmed the child's stderr is silent for these lines).
- **Pushed** the test as one commit (`695eea804`) to the PR head `endojs/endo-but-for-bots:fix/ses-node26-lockdown-permits` via `safe-push-pr-head.sh` (advance mode).
- **Watched CI.** First rollup came back RED on `test (24.x, macos-15)` — but the sole failure was `@endo/daemon` `endo › lifecycle` with `write EPIPE` (a known daemon-teardown flake, in a package untouched by this diff). I re-ran only the failed job; the re-run went **GREEN** (14/14, 0 failed), confirming the flake.

**State:** PR #1281 CI is GREEN at head `695eea804`. PR remains draft (un-drafting is a later gauntlet stage). No follow-ups needed.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ses-node26-lockdown-permits-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (2063589 cached reads)
- Output: 12622 tokens
- Cost: $1.9691265
- Wall-clock: 1056s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
