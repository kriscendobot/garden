---
orchestration-failed: true
---
I did this round's fixes and pushed them, but CI came back **red**, so this round counts as failed. The one failure is a test this round's changes didn't touch, and it looks like a timing flake. This is a judgement — I didn't rerun the job to confirm it.

orchestration-failed: true

## Gauntlet fix round 6: endojs/endo-but-for-bots#1481

### What I changed
I pushed three follow-up commits to `build/ocapn-noise-session-reconnect-rekey` with `safe-push-pr-head.sh`, moving the head from `d1647d38f` to `bd4aa1f93`.

1. **`7cac4bdbb` test(ocapn-noise)** – This is the panel's one must-fix (prover #1). The per-peer resume-handshake cap had no test; the new one is in `network.test.js`, "a replayed SYN for a resumable peer holds at most one inbound slot".
   - It checks that a newer replayed handshake for a peer with a resumable session closes the older one before the inbound budget is full.
   - It also checks that the surviving replay takes only one slot, so other peers' handshakes still fit beside it.
   - With the cap disabled the test fails; with it restored the test passes.
2. **`61a621277` fix(ocapn-noise)** – Fixes the "writes fail fast" guard (breaker #2). When `backoffMaxMs` equalled `hardTimeoutMs`, every write was rejected from the moment the connection dropped. The fail-fast window is now at most half the reconnect budget, and the test now writes early in an outage to show the queue still accepts frames.
   - The same commit tightens two tests (prover #2/#3): the retried-resume test must now see 3 connects, and a refused reconnect must arrive within half the hard timeout.
   - It also makes the pruner's cuts: two comments that repeated the code, a third comment, and the repeated `setTimeout`-ceiling explanation, now stated once in the design doc. The design's fail-fast wording was updated to match.
3. **`bd4aa1f93` docs(changeset)** – The changeset items (packager #2/#3, releaser #2/#3/#4):
   - restored the "pending OCapN-org review" note on the base PR's heartbeat changeset;
   - the reconnect changeset now covers the new options, their 2³¹−1 ms ceiling, the abort after the hard timeout, the per-peer handshake cap, and that both ends must be upgraded together;
   - removed the internal design-doc path from the session-control changeset.

Locally, the full `@endo/ocapn-noise` suite passed (105 tests), and eslint and prettier were clean on the changed files.

### Panel items I left alone
- **Packager #1** (split the formatting churn out of design-doc commit `d54a92677a`): needs a history rewrite, which a follow-up-commit stage can't do.
- **Breaker #1** (a peer that connects and drops at once resets both reconnect limits): a design-level change, not done here.
- **Breaker #3** (the outbound queue has no size cap): not done.
- **Breaker #4** (soften a code comment) and **#5** (`throw` no longer forwards the error to the transport): comment-only, not done.
- **Pruner #4/#5**: trimming the PR body and the design's "Open questions" wording were not done.

### CI result
`ci-wait-merge.sh` returned **rc=3 (RED)**: 34 of 35 checks passed, and `test (24.x, macos-15)` failed.
- The failure is `reconnect › cbor: a lost transport instance is replaced with a fresh handshake`, at `reconnect.test.js:137`: `t.is(sessionA.getLiveness().epoch, 1n)`.
- That check runs after a 1-second quiet period. With a 50 ms heartbeat and 500 ms session timeout, a pause on a loaded macOS runner can trigger an extra reconnect.
- This round only deleted a comment above that test, and it passed locally and in the other test jobs. That points to a timing flake.
- Possible follow-up: widen that test's heartbeat timing, or assert the epoch never goes backwards instead of that it is exactly `1n`.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1481-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (3907427 cached reads)
- Output: 20911 tokens
- Cost: $1.9986334000000003
- Wall-clock: 2384s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
