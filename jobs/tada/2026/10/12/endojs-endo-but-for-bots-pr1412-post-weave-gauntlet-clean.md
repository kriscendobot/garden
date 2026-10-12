The clean stage for endojs/endo-but-for-bots PR #1412 is done: CI is green at head `66dc87ac56` (`ci-wait-merge.sh` rc 0, 33 checks, 0 failed).

**Lint fix:** Lint was failing at the previous head `b744bacbe0`. The `yarn build:types:check` step reported drift in `packages/claude/tsconfig.composite.json`. Running `scripts/generate-composite-tsconfigs.mjs` fixed it by swapping the order of the `init` and `inference` references; no other file changed. I committed this as `66dc87ac56` ("chore(claude): regenerate composite tsconfig reference order") and pushed it to `build/endo-claude-backends-1357` with `safe-push-pr-head.sh`, which fast-forwarded from `b744bacbe0`.

**Coverage and dead code:** The touched package is `@endo/claude`.
- Its 175 tests pass locally. `c8` isn't installed in the worktree, so I couldn't get a local coverage number; CI's `cover` legs passed earlier.
- The three exports used nowhere else in the package (`assertNoTranscriptResume`, `resultResponse`, `usageFromResult`) are each still called inside their own module, so nothing was orphaned and nothing was removed.

**Flaky test, cleared by a rerun:** After the push, the `test (22.x, ubuntu-latest)` leg failed on a randomized property test, `copySet › setIsSuperset` in `@endo/patterns` (seed -749548072). This PR doesn't touch that package, and the other entries in the log were just the "Exiting due to SIGINT" fallout from that one failure. I reran only the failed job (run 38185379196) and it passed.

**Follow-up:** That `setIsSuperset` test can fail on some random inputs regardless of the PR, so it may be worth a separate look.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1412-post-weave-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2416013 cached reads)
- Output: 7909 tokens
- Cost: $1.2639105999999998
- Wall-clock: 4261s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
