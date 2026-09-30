Panel round 2 on endojs/endo-but-for-bots PR #1392 (head `b8c830e71b`, base `a0ef0c4`) returned **must-fix**. I posted the verdict to the PR and stopped there, as the stage requires: no fixes and no un-drafting.

- **Checkout:** I made an isolated checkout of `endojs/endo-but-for-bots` `build/sturdyref-pass-style-recognition` in `scratch/project-wt-ebfb-st-e0b8e8953478-73e3c927`.
- **Panel run:** I ran `panel.sh` in single-round mode against the PR's base commit `a0ef0c4320`, not the branch name. All 33 seats finished with status `ok`, and the decider returned `must-fix`.
- **Exit code:** the run was detached, so I never captured its exit code directly. It was 0 because the script's single-round branch prints `single-round — must-fix` and then runs `exit 0`, and that line is what the log shows.
- **Seat verdicts:** 9 request-changes, 8 comment-only, 15 approve. One of the approves is the surfacer, whose verdict appears in its body rather than its heading.
- **Posted review:** the verdict went up as two COMMENTED reviews (5370006271 and 5370006510) on head `b8c830e7`, ordered with the request-changes seats first. The aggregate is 87 KB, over GitHub's review size limit, hence two parts. GitHub rejected request-changes because the bot can't request changes on its own PR, so these are comments, the same shape as round 1.

**Main must-fix findings, for the fix stage:**
- A SturdyRef now counts as passable, but `@endo/patterns` doesn't handle it. `isKey` and the other key/pattern predicates throw on a SturdyRef instead of returning false (`packages/patterns/src/keys/checkKey.js:93`).
- No test covers the checks in `packages/pass-style/src/sturdyref.js:53-62` that `SturdyRef.isSturdyRef` is a frozen function and `SturdyRef.prototype` is a frozen, non-null object.
- `packages/marshal`'s `test:xs` is not a real test entry.
- The push that answered the round-1 review has no top-level summary comment on the PR.
- The remaining findings, from the prover, migrator, warden, saboteur, breaker, purist, scribe, pruner and corner-prober seats, are in the posted review.

The full aggregate is in `scratch/panel-run-ebfb-sturdyref-l3-p2/round-1.md`.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (959692 cached reads)
- Output: 5736 tokens
- Cost: $0.7295463999999999
- Wall-clock: 583s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
