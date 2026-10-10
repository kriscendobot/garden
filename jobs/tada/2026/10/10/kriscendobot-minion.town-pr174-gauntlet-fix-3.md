Fix round 3 is already on the PR head, and CI is green. I pushed nothing in this run.

- **Existing fix:** commit `3e088a1` ("hold concurrent publish settlements, reject zero amounts, panel-3 items") was pushed by an earlier claimant of this stage. The latest review on file is the panel round 3 verdict on `f7dfa80`. `3e088a1` answers its must-fix items:
  - Concurrent duplicate publishes now hold the shared settlement. It is refunded only when the last holder releases it and none confirmed.
  - Zero-amount grants and charges are rejected.
  - The new tests cover the refund after a failed registration, the upgrade paths, `AggregateError`, and the interleavings.
  - The renames the panel asked for are done, and the `designs/ertp-credits.md` and JSDoc edits are in.
- **What I checked:** I confirmed the head, `3e088a1`, is the commit I read. I did not diff each panel finding against the code.
- **CI:** `ci-wait-merge.sh` returned rc 0: 3 of 3 checks, none failed.
- **Earlier halt note:** a terminal comment on the PR says the gauntlet halted because the earlier fix-3 run was doom-parked (`requeue-exhausted`, cause unknown). That run's push was already in place, so the work was done even though the stage record failed. The driver can re-post panel-4 against `3e088a1`.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr174-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (231770 cached reads)
- Output: 1600 tokens
- Cost: $0.26129800000000003
- Wall-clock: 24s

<!-- garden-usage-end -->
