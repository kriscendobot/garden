Fix round 1 for endojs/endo-but-for-bots#1478 is pushed and CI is green (35 checks, 0 failed; `ci-wait-merge` rc 0). I did not run the package tests locally, because the change only touches comments and the PR body.

I applied the must-fix items from the latest panel verdict, review 5579757312 (2026-10-20). Two jurors had requested changes:

- **decomplector #1 — "remove the outbound queue or justify it in one sentence":** I kept the queue and stated the reason it exists. A chain of awaited `stream.writer.next` calls ties every accepted frame to the current transport. The design's later phases have to carry accepted frames across a transport swap and encrypt them for the new connection (`designs/ocapn-noise-session-reconnect.md`, reconnect steps 2/5 and the framer bridging section). That sentence replaces the queue comment in `packages/ocapn-noise/src/network.js`. The earlier version of that comment gave a reason the juror rejected.
- **pruner #2–#4 (test comments, `packages/ocapn-noise/test/session-queue.test.js`):**
  - The comment above the send-nonce assertion did not match what the assertion checks. It now says that frames queued behind the held write are not yet encrypted, so A's send nonce holds.
  - I deleted the two comments that restated the assertion beneath them.
  - I deleted the test comment that repeated the `.slice()` explanation already in `network.js`.
- **pruner #1 (PR body):** I removed the "stacked on #1476" prose (the `Refs:` line already gives the base), the sentence naming the changeset and test files, and the duplicated heartbeat-coalescing clause in Scaling Considerations. The paragraph explaining why `writer.next` resolves on acceptance is replaced by the reconnect justification. The job marker, the evidence ledger and the template headings are unchanged.

The commit is 750929d3b5 on `build/ocapn-noise-session-queue` (44389592bd → 750929d3b5), pushed with `safe-push-pr-head.sh`.

**Follow-ups:**
- Panel-2 will decide whether decomplector accepts the one-sentence justification. If it doesn't, the remaining option is the larger rewrite it proposed: replace the queue with a single promise chain plus a `writing` flag.
- I didn't address the should-fix and comment-only items. Those include decomplector #2/#3 and assessor's note that the stall timer measures one frame at a time rather than the whole backlog.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-but-for-bots-pr1478-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1363290 cached reads)
- Output: 6965 tokens
- Cost: $0.9352140000000002
- Wall-clock: 1917s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
