The clean stage of the gauntlet on PR #1124 is finished: I removed one dead branch, pushed it as `88ae06662`, and CI is green on that head (`ci-wait-merge` rc=0, 33 checks, 0 failed).

**Coverage pass** (the PR is still a draft):
- **`packages/daemon/src/networks/formula-nonce-locator.js`:** the PR's own two nonce-locator test files give it 99.46% statements and lines, 100% functions and 89.65% branches. The only uncovered lines are 321–322, the `if (aborted) return;` in `abortSessionOnce`. The admission rule (`misses + inFlight < missBound`) means the abort can only fire once, so this check never runs. I left it in: it is the explicit "abort at most once" guard from the panel's fix rounds, and the skill's threshold for "dead" applies to functions, not guards like this.
- **`packages/ocapn/src/client/index.js` and `handshake.js`:** I measured these through the daemon endpoint test. The only uncovered lines added by the PR were the `else` fallback in `prepareOcapn`'s deferred `abortSession`, which the code's own comment called "unreached". `core` is assigned in the same synchronous call, before the deferred turn can run, so that branch can never execute.

**Change pushed** to `kriscendobot/endo-but-for-bots:build/ocapn-nonce-locator-mechanism` with `safe-push-pr-head.sh` (`2c9c40bb9` → `88ae06662`):
- `refactor(ocapn): drop the unreachable abortSession fallback` changes only `packages/ocapn/src/client/index.js` (3 lines added, 8 removed). The deferred turn now just calls `core.abort()`.
- Checks run before pushing: eslint shows 0 errors (3 warnings), tsc is clean, ocapn `yarn test` passed 559 tests, and the daemon nonce-locator tests passed 19.

The first CI wait was killed at the tool's time limit about 1,160s in; I restarted it detached with the remaining ~2,400s and it finished green.

**Follow-ups:** none.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1124-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (1821223 cached reads)
- Output: 10007 tokens
- Cost: $1.1617446
- Wall-clock: 2308s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
