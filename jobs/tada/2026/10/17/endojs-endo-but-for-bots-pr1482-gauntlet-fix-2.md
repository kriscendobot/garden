## Gauntlet FIX round 2: endojs/endo-but-for-bots#1482

I applied the must-fix items from panel round 2 (review 5555385328) and pushed them as one follow-up commit. CI is green on the new head (35 checks, 0 failed).

**Pushed:** head `55ff4a249c` → `6cace22ab6`, via `safe-push-pr-head.sh` (advance mode). The test changes are in `test/reconnect.test.js` and `test/_loss-injector.js`.

**What changed:**
- **Tiebreaker test (prover):** the crossed-hellos test now checks the rule directly. It reads both sides' handshake ephemerals off the opening handshake messages and asserts:
  - the session settles at epoch 1;
  - the side with the greater ephemeral keeps its own outgoing dial, and the other side keeps the incoming one;
  - the greater side closes exactly one dial from the other side without answering it.
- **Stale-epoch test (coverage-auditor):** a new test, run with both cbor and syrup, holds back the lesser side's dials for epochs 1 and 2 while the session moves to epoch 2. It then releases them and asserts:
  - both late dials are closed without an answer;
  - the session stays at epoch 2 and is not reconnecting;
  - data still flows.
- **Loss injector:** it now records each stream's direction, how many writes it made, and its first chunk. `getOpenStreams` takes an optional direction filter, and there is a new `getStreams()`.
- **Pruner:** I trimmed the repeated `wideHeartbeat` comment in `session-queue.test.js`. In the PR body I shortened the tiebreaker explanation and the file/symbol tour to one line each, removed the security bullet that repeated a code comment, and cut the Documentation and Testing sections to one sentence each.

**Mutation runs:** each was run 3×, with all three lockdown configs.

| Mutation | Result |
|---|---|
| `prefersOwnDial: () => false` (tiebreaker off) | crossed-hellos tests fail every time |
| Ephemeral comparison inverted (`< 0`) | crossed-hellos tests fail every time |
| Stale-epoch check `<=` changed to `<` | stale-epoch tests fail every time |
| Stale dial answered with a refusal (the old behavior) | stale-epoch tests fail every time |

Locally, the full package suite passes (107 tests × 3 configs). eslint reports 0 errors, and the remaining warnings were already there. Root `tsc` reports nothing for `ocapn-noise`.

**Follow-ups (should-fix / comment-only, not done):**
- No test yet shows that a dial for a *later* epoch is accepted (prover should-fix #2). A mutation that only accepts the next epoch, `!== getEpoch() + 1n`, still passes.
- The redial-discard branch (`epoch + 1n !== nextEpoch`) is only reached in a race (coverage-auditor #3).
- The "either side redials" test doesn't assert that A never made a successful dial.
- The coverage-auditor seat had no c8 report to read; that is a problem in the panel's pre-pass, not in this PR.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1482-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2600510 cached reads)
- Output: 21083 tokens
- Cost: $1.699506
- Wall-clock: 2310s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
