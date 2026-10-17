Fix round 6 for endojs/endo-but-for-bots#1478 is pushed and CI is green (35 of 35 checks passed).

The panel had two request-changes seats, pruner and decomplector. Their requests pulled in opposite directions: decomplector's must-fix wanted the PR to state why it needs an outbound queue rather than one write in flight at a time, while pruner wanted the "Why a queue" paragraph cut from the PR body. I kept a short version of the reason and dropped the long one.

**Pushed:** one follow-up commit, `44389592bd` (fast-forward from `385e99301d`, via `safe-push-pr-head.sh`).
- **Queue comment in `network.js`:** it now says what one in-flight write can't do. `writer.next` resolves when the session accepts a frame, so a stalled transport only holds a writer back once 64 frames are queued. Waiting on a single write instead would hold every writer for the whole stall. This replaces the old "the queue can outlive the transport" reason, which decomplector pointed out nothing in this PR uses yet.
- **Restating comments removed:** pruner items 3–6 — the `stall` JSDoc in `_stall-injector.js`, the "three writes are queued" sentence and the held-write comment in `session-queue.test.js`, and the error-routing sentence on `acceptFrame`.
- **PR body:** the long "Why a queue and not a serialized write chain" paragraph is replaced by one sentence giving the same reason.

The `@endo/ocapn-noise` tests pass locally (99), and eslint reports no errors.

**Not done (should-fix items, deliberately skipped):**
- Decomplector #2 (stop handing frames through the waiting-writer list) is a refactor, not a must-fix.
- Decomplector #3 claimed `writer.return` can race with a failure between its wait and setting `closed`. It can't: the `closed` check and the assignment run in the same turn, so nothing can get in between.
- Decomplector #4 (count sent nonces from the cipher) was comment-only.

**Next:** the driver re-posts panel-7.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1478-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1286815 cached reads)
- Output: 6606 tokens
- Cost: $0.9062669999999999
- Wall-clock: 2122s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
