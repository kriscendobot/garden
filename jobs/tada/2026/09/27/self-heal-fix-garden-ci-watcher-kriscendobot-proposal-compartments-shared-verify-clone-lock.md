Job done. The code fix itself was already on `main2`: commit `5620bdbe5f6` ("fix: isolate CI watcher clones per slug") landed a few minutes before I pushed, and a peer made the same change. What I added is the regression test that commit lacked.

**What happened**
- I made the change the job asked for in `scripts/jobs/ci-watcher.sh`: `GARDEN_CI_VERIFY_CLONE` now defaults to `$GARDEN_STATE/ci-watcher/verify-$slug` and `GARDEN_CI_RETIRE_CLONE` to `.../retire-$slug`. I also added a comment explaining the shared-lock contention, modeled on receipt-watcher's. Both variables can still be overridden.
- When I rebased to push, it conflicted with `5620bdbe5f6`, which already made those exact default changes with an equivalent comment. It also conflicted with a follow-up that added a VLOCK test case (checking the verify fetch holds the clone lock).
- I kept the upstream `ci-watcher.sh` exactly as it is, so my commit changes no code.

**What changed (commit `02adfdaf324`, pushed to `main2`)**
- `scripts/jobs/test/ci-watcher-test.sh` has a new case **V**, modeled on receipt-watcher's per-slug assertion. Two slugs (`endojs-endo-but-for-bots` and `kriscendobot-proposal-compartments`) run against one shared `GARDEN_STATE` with the clone variables unset. Each goes red then green, so both the verify clone and the retire clone get used.
- It checks that each slug gets its own `verify-<slug>` and `retire-<slug>` clone, and that the old shared `ci-watcher/verify` and `ci-watcher/retire` are never created.
- It sits next to upstream's VLOCK case. The first letter I picked, Q, and its `q.git` fixture were already taken, so I renamed it to V.

**Tests**
- The full `ci-watcher-test.sh` suite passed on the rebased tree: 85 passed, 0 failed (VLOCK and V included).
- I did not confirm that case V fails against the old shared defaults. My one attempt got mixed up with a second test run that used the same fixed test directory, so its failures mean nothing.

`GARDEN_CI_JOURNAL_OUTAGE_LATCH` was left alone, as the job specified.

**Follow-ups:** none for the code. The FATAL should stop once hosts deploy past `5620bdbe5f6`. If the clone-lock FATAL appears again on a host, check whether that host has deployed past it before posting another fix job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-ci-watcher-kriscendobot-proposal-compartments-shared-verify-clone-lock.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1195219 cached reads)
- Output: 8228 tokens
- Cost: $0.9568118000000003
- Wall-clock: 371s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
