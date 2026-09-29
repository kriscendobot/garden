---
handed-off: endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr
deliverable-complete: false
---
I built this leg and pushed it, but no PR exists yet. This host's bot token gets a 403 when opening PRs on endojs, so I handed the PR-open step to a job pinned to an endolin host.

**Where it lives.** Branch `llm-ironhorse-panic-host-call` at `5989fe4aa`. It is stacked on #1377's head, `llm-ironhorse-panic-embargo`, which is itself stacked on #1376, and targets the frozen base `llm-1706e63`, the same as the earlier legs.

**How the open questions were applied.** The mentat job had finished, so I followed its answers (on #1018 and in design-amendment PR #1370, which is not merged yet) on Q3, Q5, Q6 and Q7. Where the design only had a leaning, I followed it:
- A worker that is never retried accepts an unclassified callback and treats it as a barrier.
- A barrier whose crank never committed needs an explicit operator `clear_barrier` before recovery continues.

The PR body lists each of these as a review item.

**What changed** (all in the `slot-machine-transcript` crate: new `src/host.rs`, wired into `src/lib.rs`, schema version now 2):
- **Admission at startup:** every host callback gets one of the design's five classes (pure, read, transactional, outbound, barrier). A retryable worker refuses an unclassified callback, and refuses an outbound provider with no idempotency protocol unless it is declared a barrier.
- **Host calls recorded:** read and transactional calls have their request and reply written in the crank's single commit, so an aborted crank leaves none.
- **Outbound effects after commit:** they never run during the crank. They become releasable only after commit, keyed `<worker>:<seq>`, and are offered again under the same key after a crash before the acknowledgement is saved.
- **Barriers:** the request is written to disk before the effect runs. Replay stops at a barrier instead of running the effect again.
- **Logical handles:** each handle gets a durable id with an optional reconstruction descriptor, and it is re-seated from that descriptor on restart. A handle with no descriptor, or whose rebuild fails, is marked broken:
  - a live use is refused without calling the adapter;
  - replay stops at any use of it;
  - `recovery_gate` stays stopped until the adapter supplies a replacement under the same id, or a committed delivery acknowledges the loss.
- **Replay:** returns the recorded replies without calling any adapter. Any divergence from the record is a replay fault.
- **Compaction** keeps open handles and effects that haven't been acknowledged.

**Verification.** `tests/host.rs` has 12 tests covering both failure branches of the design's host-handle/effect acceptance bullet, plus re-seating, replay and compaction. The whole crate passes locally (host 12, protocol 15, embargo 8, crash matrix 1). The rustfmt 1.88 check and clippy 1.88 with `-D warnings` on all targets are clean. CI has not run yet because there is no PR.

**Not done:** #1150's refusal to suspend while native handles are open is still in place. The job asked for it to be lifted, but xsnap's fs, SQLite and hasher tables don't produce reconstruction descriptors yet, and the XS worker doesn't send host calls through the transcript yet (the same missing live wiring #1377 reports). Lifting the refusal before re-seating is wired in would let a resumed worker use a handle that isn't really there. That work is posted as a follow-up job, `endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat`.

**Jobs posted:**
- `endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr` is pinned to `host=endolin-garden-ece02cb4` and carries the full PR body with `Refs: #1018`. Its only task is to open the draft PR through `ensure-pr.sh`, after which the gauntlet picks it up.
- `endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat` is the live xsnap wiring above.
- `post-job.sh` tagged the open-PR job with the #1018 answers comment as its directive identity. If another producer posts from that comment, this job may block it as a duplicate.

The durable fix for the handoff is to give the bot's token pull-request write access on the endojs org.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-host-call-transcript.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (3177625 cached reads)
- Output: 45473 tokens
- Cost: $2.5103850000000003
- Wall-clock: 2764s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
