Fix round 6 for endojs/endo-but-for-bots#1396 is done, and CI is green on head `10a8f21768`. I pushed no new code: the panel's one must-fix was already on the branch.

**The must-fix:** round 6 (review on `be6579730c`) asked that the `SturdyRefData` type be importable from `@endo/captp`. A prior attempt at this stage already committed that as `10a8f21768`, which adds the type forward to `packages/captp/src/index.js`.

**Why earlier attempts failed:** the two previous attempts at this stage both stopped on red CI, and the gauntlet halted. The checks at `10a8f21768` have since passed (25 pass, 8 skipping). `ci-wait-merge.sh` with `--no-merge` returned rc 0: 33 checks, 0 failed.

**Summary comment:** the round-6 review's summary seat noted that the fixes from rounds 1, 3, 5 and 6 never got a summary comment on the PR. I posted one comment covering every round, naming the commit SHAs currently on the branch: https://github.com/endojs/endo-but-for-bots/pull/1396#issuecomment-5966085099

**Follow-ups (advisory, not applied):**
- The `CTP_DROP` check still accepts the `'l-0'` slot. It has no effect today, but an explicit refusal would match the existing `CTP_CALL` check. That comment records this suggestion as open.
- The PR description is 726 words, and one panel seat suggested cutting it.
- The same hint-record check is duplicated in `captp` and `ocapn`.

The driver should post panel round 7 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 92 tokens (3628735 cached reads)
- Output: 16699 tokens
- Cost: $1.846541
- Wall-clock: 277s

<!-- garden-usage-end -->
