Opened draft PR https://github.com/kriscendobot/minion.town/pull/237, which fixes the flake in the guest-pinned responder restart test. CI on the PR had not been checked when I wrote this; the gauntlet takes it from here.

**Change:** only `test/endo-daemon-integration.test.ts` changed (commit `b942fb97` on `fix/responder-test-mailbox-poll`). The single mailbox check now polls with the same bound as the effect wait above it: 100 attempts, 20 ms apart. The caplet's write-then-dismiss order is untouched, and I added no sleep or whole-test retry.

**Verification:** I ran these locally against a real daemon at the pinned Endo commit `1706e632`, temporarily patching only the gitignored `dist` caplet for cases A to C:

| Case | Caplet | Test | Result |
| --- | --- | --- | --- |
| A | 500 ms delay before dismiss | old | fails with `expected true to be false`, the reported failure |
| B | 500 ms delay before dismiss | new | passes |
| C | dismiss removed | new | fails, so the test still catches a message that is never dismissed |
| D | unmodified | new, full file | 8 of 8 pass |

- **Limit of the evidence:** the natural race did not reproduce on demand, so A and B widen the window rather than measure the flake rate.
- **Other checks:** `pre-push-gates.sh` exited 0 with the same diff staged. I did not run the separate `test/web/guest-web-daemon.test.ts` step, which this change doesn't touch.

**Base branch:** the job didn't name a base, and `ensure-pr.sh` refuses a floating `main`. The PR targets the frozen `main-9196892`, which is the current tip of `main` and already existed for #236.

**Other changes:**
- Removed my temporary Endo checkout from scratch.
- Added a pointer to the PR in the `minion-town-responder-test-dismiss-race` memory.
- Added no changeset, since nothing user-visible changes.

**Follow-up:** none beyond the gauntlet. Once #237 merges, the same failure on a branch containing the fix is a real signal, not this race.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-responder-test-mailbox-poll.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1375140 cached reads)
- Output: 12896 tokens
- Cost: $1.117772
- Wall-clock: 1903s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
