I applied the round-3 fixes to endojs/endo-but-for-bots PR #1388 (the OCapN-over-Cloudflare design doc, still a draft) and pushed them. CI is green: `ci-wait-merge.sh` returned rc=0 with 28 checks and 0 failures.

**What the panel asked for.** The round-3 review's overall disposition was must-fix, but no single juror marked an item must-fix. I applied the should-fix and most comment-only items as one follow-up commit, `b027ff77e9`, on `design/ocapn-cloudflare-netlayer`. It was pushed with `safe-push-pr-head.sh` as a fast-forward from `de75b72554`. All changes are to `designs/ocapn-cloudflare-netlayer.md`:
- **Supervisor trust model (critic):** removed the incorrect claim that the supervisor can read a DO facet's storage. The supervisor stays trusted because it loads the facet's code, not because it can read the facet's keys.
- **Hint naming (critic, ergonomist):** hints now follow the sibling design's one-hint-per-`<transport>+<codec>` rule: `do+tree` and `capnweb+tree`. The facet id is now a `#<facet id>` part of the `do+tree` dial string, and the separate `cf-facet` hint is gone.
- **Control frames (decomplector):** the mailbox call is now `deliver(seq, kind, frame)`, with kind `ocapn`, `finish` or `ping`. Only `ocapn` frames reach OCapN core.
- **Handshake records (decomplector):** `hello` and `reply` are now network-defined records (`CfHello`/`CfReply`) that don't depend on the vat's codec. The network's frame type is set by the codec it is registered with.
- **Crossed hellos (skeptic):** the doc now says when a crossed hello is detected (when a session finishes verifying the peer and before OCapN core sees it) and how the loser is thrown away. Matching network tests were added.
- **Heartbeat vs. keep-alive (skeptic):** the heartbeat is described as a plain timer that only runs while an exchange is in flight, not a keep-alive. Whether a pending timer delays Cloudflare's idle eviction isn't verified, so it's recorded under Known Gaps.
- **Durable state (decomplector):** any facet with durable state must be a DO facet. This settles the old open question 3, which is now design decision 7, and the ownership map was updated. I also added a note that facet storage survives a supervisor redeploy of the same facet id.
- **Smaller fixes:**
  - One `CloudflareNetworkOptions` block now lists all five settings and their defaults.
  - `atEnd(message, reader)` now takes its arguments in the same order as `diagnoseRemainder`.
  - Design decision 6 now says the Cap'n Web pass-through is still a hypothesis.
  - A prerequisites paragraph at the top defines OCapN, vat, designator, sturdyref/swissnum and grant matching.
  - The location scheme now opens with a framing sentence, and "The first design" now reads "This design".
- **PR body (pruner):** replaced the feature tour with one summary paragraph. It now points to the doc's open questions (four now) instead of repeating them, and each Considerations section is cut to a line or two.

**Not changed:**
- **Pedant's list punctuation:** every item in the Cloudflare vocabulary list already ends with a period, so there was nothing to fix.
- **Pedant's question-form heading:** "What is the Problem Being Solved?" comes from the designs template, so I left it.
- **Decomplector's comment-only suggestions:** a single dictionary shape and position-independent selector labels are still open question 3 in the doc. I didn't rename `deliver`, since the new `kind` argument now tells control frames from OCapN frames.

**Follow-up:** the driver posts panel-4 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1388-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1480544 cached reads)
- Output: 14538 tokens
- Cost: $1.3011967999999998
- Wall-clock: 1988s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
