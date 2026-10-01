Panel round 6 on endojs/endo-but-for-bots#1396 (head `be6579730c`) came back **must-fix**. `panel.sh` exited 0, and I posted the verdict as a review on the PR.

**How it ran:** single-round mode, in an isolated checkout of `endojs/build/sturdyref-captp-construct`. The base was the real merge-base SHA `7516782577`, the tip of `build/sturdyref-captp-wire-7516782`.

**Seats:** of 33 seats, 1 requested changes, 9 were comment-only and 23 approved.

**The one must-fix (surfacer seat):** the new `SturdyRefData` type can't be imported from `@endo/captp`.
- The type is declared in `packages/captp/src/types.js`, but `packages/captp/src/index.js` only does `export * from './captp.js'`, and that doesn't carry type declarations across from another file.
- The seat confirmed it with `tsc`: importing `SturdyRefData` from `@endo/captp` fails with `TS2724`.
- **Fix:** add a `@typedef {import('./types.js').SturdyRefData}` line to `packages/captp/src/index.js`, the same way the ocapn half of this PR already does.

**Advisory, not blocking:**
- The PR description is 726 words. The pruner seat suggests removing "Most important to review", shortening "This PR's place in the stack", and cutting "Testing Considerations" to one line.
- One seat found that the `CTP_DROP` guard accepts the reserved `'l-0'` slot. It's harmless today, but an explicit refusal would match the existing `CTP_CALL` check.

**Review:** https://github.com/endojs/endo-but-for-bots/pull/1396#pullrequestreview-5381142896
- It was posted as a COMMENTED review, not request-changes, because GitHub won't let the bot request changes on its own PR. Rounds 1–5 were posted the same way.
- The full write-up was about 80 KB, over GitHub's 65 KB limit for a review. The posted version (~35 KB) keeps the must-fix, the advisory notes and all ten non-approving seats in full, with the approving seats shortened to one line each.
- It ends with `<!-- garden-panel-verdict: must-fix round=6 head=be6579730c… -->`.

No code or garden changes were made, and the PR is still a draft.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (814418 cached reads)
- Output: 5915 tokens
- Cost: $0.8097436000000001
- Wall-clock: 665s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
