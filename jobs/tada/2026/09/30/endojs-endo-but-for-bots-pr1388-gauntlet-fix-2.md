# Completion report: endojs-endo-but-for-bots-pr1388-gauntlet-fix-2

**PR:** https://github.com/endojs/endo-but-for-bots/pull/1388 (the design for OCapN over Cloudflare RPC and Cap'n Web; head branch `design/ocapn-cloudflare-netlayer`, base `llm-7ff30af`).

**Result:** I pushed one follow-up commit that addresses the panel's round-2 must-fix items. The head moved from `417e40391a` to `de75b72554`. CI is green: `ci-wait-merge` returned rc 0 with 28 checks and none failed.

**Limitation of the input:** The round-2 review only had the short titles of the critic's items. The saved panel-run record `0f0f9803a1c0` also has only the titles. The full critic text was lost when the job was requeued. The decomplector, ergonomist and skeptic seats also returned must-fix, but none of their findings were saved. I worked from the critic's list, which the review names as the main to-do list. The panel-3 re-review is where any separate items from those three seats will come back.

**Changes in `designs/ocapn-cloudflare-netlayer.md`:**
- **Handshake before authentication:**
  - A session stays pending until the peer's signature is checked.
  - While pending, the responder accepts only `finish` at seq 0 and the initiator accepts no frames. Anything else aborts the session and releases both mailboxes.
  - The initiator checks the responder's signature before it sends `finish`.
  - Unauthenticated `open` calls are capped (`maxPendingOpens`, default 16) and time out (`handshakeTimeout`, default 10 s). An `open` over the cap is rejected before any signing work.
- **Detecting a crashed peer:** a session that still has unanswered calls and has been idle for `idleProbe` (default 30 s) sends a `ping` over the same seq counter. A dead peer shows up as a failed delivery. An idle session sends nothing, so the Durable Object can still be evicted.
- **Ordering (comment-only item):** added a note on why `seq` stays even though the platform already orders calls on one stub. `maxReorder` can be set to 0 on carriers known to be ordered.
- **Supervisor trust model:** new subsection. It states that the supervisor is part of the facet's trusted base and sits in the middle of every `dial` and `open`. Confinement protects the world from the facet, not the facet from its supervisor. It also says what "never a vat" does and does not mean. The dial policy reads only `location` and passes `hello` through unchanged.
- **Tree codec versus plain bytes:**
  - New table comparing the tree codec with sending bytes through the carrier.
  - Phase 2 now ships a bytes mode first, since it needs no change to the `@endo/ocapn` core.
  - Bytes mode is the fallback if the tree codec turns out harder than described.
- **Cap'n Web pass-through:** the claim that our tagged arrays survive Cap'n Web unchanged is now marked as not yet tested. Phase 2's first Cap'n Web test is the round-trip that confirms or refutes it.
- **Crossed hellos (comment-only item):** phase 2 now factors the comparison rule into a shared helper, so it has one implementation instead of a copy.
- **Test plan:** new network tests for all of the above.
- **Metadata:** the author field is now `Dan Connolly (prompted)`, the format `designs/AGENTS.md` requires. In the `designs/README.md` index row, the em-dash is now `-` to match the neighboring rows.

**Follow-ups:** none from this stage. The driver re-posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1388-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1165197 cached reads)
- Output: 9076 tokens
- Cost: $1.0561753999999999
- Wall-clock: 1993s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
