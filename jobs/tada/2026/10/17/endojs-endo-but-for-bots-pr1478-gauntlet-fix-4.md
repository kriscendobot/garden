Fix round 4 on endojs/endo-but-for-bots#1478 is pushed as `dc57f6fc62`, and CI is green: `ci-wait-merge.sh` returned rc 0, with all 35 checks passed or skipped and none failed. I applied every must-fix item from the round-4 panel except one, which I declined because the design requires what it asks me to remove.

**Declined: decomplector #1 ("remove the queue, use the transport's backpressure").** The session-level outbound queue is the Phase 2 deliverable in `designs/ocapn-noise-session-reconnect.md` § Phased Implementation. Phase 3 needs it to carry accepted frames across a reconnect. I added that reasoning to the PR body and the reply comment. If the panel insists again, a maintainer has to decide.

**Applied, all in `packages/ocapn-noise`:**
- **Send nonce read from the cipher (decomplector #2, must-fix).** The hand-kept `sentCount` is gone. A new `countSentNonces` wraps the sending side's `encrypt`, the same way `countReceivedNonces` already wraps the receiving side. `lastSentNonce` is now always a `bigint`, reported for every session, not only heartbeat sessions.
- **Simpler state (decomplector #3).** The `draining`/`drained` pair is now one `activeDrain` value. The placeholder `enqueueFrame` that did nothing is now `acceptFrame`, which is `undefined` for sessions that write directly.
- **Bad frames fail only their own call (saboteur #1).** `writer.next` now rejects a frame that isn't a `Uint8Array` or is too long to encrypt (over 65535−16 bytes) before queueing it. Before, such a frame ended the whole session. New test added.
- **Close releases a stuck write (saboteur #2).** Each transport write now races against session close, so a write that never finishes no longer keeps the drain loop waiting after the session ends. New test added. This release can't be seen from outside except through `return` settling, and `return` already raced close before, so the test does not fail on the old code.
- **Changeset wording (saboteur #3).** It now says `writer.return` sends the frames already accepted.
- **Pruner items.** I trimmed three test comments and one code comment. In the PR body I replaced the Documentation/Testing link sections with "None beyond the diff.", cut Security Considerations to one sentence and shortened the Acceptance row. I removed the concurrent-writers sentence from the Description.
- **Spelling (orthographer).** "acknowledgement" is now "acknowledgment".

**Checks run locally:** the full ocapn-noise test suite passed three times (97 tests), and the package type check passed. Lint shows no errors, only warnings in files this PR doesn't touch, plus one about an unused eslint-disable comment in `network.js`.

I posted a reply comment going through each finding: https://github.com/endojs/endo-but-for-bots/pull/1478#issuecomment-6228889618. I did not re-run the panel; the driver posts panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1478-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (3374055 cached reads)
- Output: 22250 tokens
- Cost: $1.9456830000000003
- Wall-clock: 2244s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
