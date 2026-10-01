Fix round 4 for endojs/endo-but-for-bots PR #1392 is finished: all panel-4 must-fix items are addressed, and CI is green on the new head `fe2d14b78`.

**Already on the PR head when I claimed the job.** An earlier claimant of this job pushed three follow-up commits (`a07558c22`, `915dd766e`, `bc562c284`) after the panel-4 review at `6571479f91`. I read them against each must-fix item and they cover all the code findings:
- **saboteur #1:** `getRankCover` in `patternMatchers.js` now checks the rank table first, so a SturdyRef gets an error naming its pass style instead of a raw `TypeError`. A test was added.
- **breaker:** `dot-membrane.js` now has its own `'sturdyRef'` case, which throws an error naming the pass style.
- **purist:** `Passable` now accepts `SturdyRefObject`, and the `Passable` doc comment explains why it is not a `PassableCap`. `types.test-d.ts` now checks that `SturdyRefObject` matches `@endo/sturdyref`'s `SturdyRef`.
- **corner-prober #1:** `compareRank(ref, ref)` returning 0 is kept on purpose, as for any two identical values. A comment in `rankOrder.js` and new tests in marshal's `sturdyref.test.js` cover it.
- **corner-prober #2:** a new test in `sturdyref-gated-global.test.js` checks that once a valid global has been captured, a later valid one does not replace it.
- **pruner:** the PR body no longer has the numbered stack list or the "Mined from #737" section, and the XS-testing note is one sentence.

**What I added.**
- **saboteur #2 (should-fix):** one commit, `fe2d14b78` (`docs(patterns): correct the stale note that getRankCover is not exported`). The old comment above `patternMatchers.js`'s exports said `getRankCover` was not exported, but it is exported publicly from `index.js`. The new comment says it is exported and that it rejects any pattern whose pass style has no rank, such as a SturdyRef.
- Prettier passes on the file. I pushed with `safe-push-pr-head.sh`, which moved the head forward from `bc562c284` to `fe2d14b78`.

**CI.** `ci-wait-merge.sh --no-merge` returned rc 0: 33 checks, none failed. The first wait was stopped by the session's 30-minute background limit with 4 checks still pending. I restarted it with a 1800 s deadline, and it went green before that ran out; the last check to finish was `test (24.x, macos-15)`.

**Not fixed.** These were comment-only items with no fix requested:
- spec-keeper suggested noting the unsafe-taming `isFrozen` caveat in `sturdyref.js`.
- wire-watcher suggested a cross-reference noting that the shim's check for an existing global is looser than pass-style's brand check.

**Environment.** On this host, the inbox drain and journal clones time out at 120 s, so I could not read this job's inbox. The first `ensure-project-worktree.sh` attempt also timed out; it succeeded on a retry with a longer limit.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 140 tokens (5610056 cached reads)
- Output: 27862 tokens
- Cost: $3.1036912
- Wall-clock: 8493s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
