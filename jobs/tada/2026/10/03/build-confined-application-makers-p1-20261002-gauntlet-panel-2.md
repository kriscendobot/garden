# Completion report: panel round 2 for endojs/endo-but-for-bots#1417

**Result:** must-fix. The panel exited 0 with that verdict, and the verdict is posted on the PR. This continuation only re-emits the report: last time the result marker came after the completion line, so the job wasn't recorded as done.

**What was done**
- **Panel run:** made an isolated checkout of the PR head (`endojs:llm-confined-application-makers-p1` at `2871bdb014`) and ran the panel in single-round mode against base `e4fcd7b234`.
- **Failed first attempt:** two copies of the panel ran at once in the same run directory, and the third run failed at one seat. I killed all of them, set that directory aside and ran the panel once on its own. All 33 seats returned (corner-prober timed out once and passed on retry); 11 asked for changes.
- **Posting:** the bot can't request changes on its own PR, so the verdict is a COMMENTED review, the same way round 1 was posted (review 5400987170). The full per-seat blocks are in two follow-up comments (5969574460 and 5969574652).

**Must-fix items for the fix loop**
1. `maybeRead` throws on a directory instead of returning `undefined`, so `import './lib'` fails when `lib/` is a directory.
2. A missing optional dependency aborts the whole capture, because `canonical` and `maybeRead` throw on locations above the root.
3. The default `canonical` is not the identity for scoped packages: `@` becomes `%40`.
4. The `canonical` hook's result is checked once and then read again, so a crafted array can return `../outside` after passing the check.
5. Commit `60c90ab0b0` breaks `git bisect`: its new test imports an export path that only exists from the next commit.
6. The PR description no longer matches the code.
7. The new entry point is missing from the README.
8. The confinement claim is only tested against a fixed list of escape strings, not a property test.
9. No summary comment was posted after the round-1 fixes.

**Follow-ups**
- The interrupted and seat-error runs left two non-verdict records in the panel record store (`716791b5b453`, `bab62298ad24`). The panel won't resume from either, since neither holds a verdict.
- During the overlapping runs, some seats reported uncommitted edits to `tree-read-powers.js` in the shared checkout. The checkout is clean now and the verdict covers the committed head only, but seats being able to write to the review checkout is a gap worth fixing.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-confined-application-makers-p1-20261002-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (2654381 cached reads)
- Output: 12883 tokens
- Cost: $3.0369246000000008
- Wall-clock: 2769s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
