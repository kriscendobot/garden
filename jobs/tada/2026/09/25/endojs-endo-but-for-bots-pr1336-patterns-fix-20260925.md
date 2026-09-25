I added an integer matcher to `@endo/patterns` and replaced the hand-written check on endojs/endo-but-for-bots PR #1336 with it. I pushed the two commits to the PR head and replied on the review thread. I only ran tests locally; I didn't wait for CI after the push.

**No built-in matcher existed.** `M.number()` takes no options that could require an integer, and `M.nat()` only matches bigints. So I made the small addition to `@endo/patterns` that the comment allowed for.

**Before pushing.** The gauntlet's fix-5 stage was running, so I waited until it finished (without pushing anything) and the head was still `5f01c570f3`. I pushed with `safe-push-pr-head.sh` as a fast-forward to `ba172a64fa`. The next gauntlet stage is panel-6, which only reviews, so it will see these commits.

**Commits on `build/endo-guest-stdio-mcp`:**
1. `ec290401c5` feat(patterns): add `M.safeInteger()`. The new matcher accepts a number exactly when `Number.isSafeInteger` does, so it rejects `NaN`, Infinity, fractions and anything past ±(2⁵³−1). You combine it with `M.gte`/`M.lte` to set a range. The commit also updates the types and README, adds tests and a minor changeset.
2. `ba172a64fa` refactor(agent-mcp-stdio): removes `requireIntegers` and its three call sites. The argument shapes for `grep`, `glorp` and `readFollower` now use `M.and(M.safeInteger(), …)`, so the pattern alone does the checking. Bad values are still refused with the `argument-scope` reason. `readFollower` keeps its own integer check for code that calls it directly.

**Local checks:**
- **`@endo/patterns`:** all 639 tests pass under each ses-ava config, and lint (tsc plus eslint) has 0 errors.
- **`agent-mcp-stdio`:** all 47 tests pass unchanged, and lint has 0 errors. These include the test that every integer bound is enforced and the `readFollower` bounds test over `tools/call`.
- **Not checked:** I didn't run the separate `test:types` script. It fails with a missing `index.d.ts`, and I didn't check whether that also happens without my change.

**Reply:** posted on thread 4101301555, citing both commits: https://github.com/endojs/endo-but-for-bots/pull/1336#discussion_r4101529433

The PR is still a draft; I didn't un-draft or merge it. The rest of the approval (shepherd, retcon, conduct) belongs to the parent orchestration and the panel-6 stage.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1336-patterns-fix-20260925.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 100 tokens (3610465 cached reads)
- Output: 16669 tokens
- Cost: $1.7288890000000001
- Wall-clock: 1681s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
