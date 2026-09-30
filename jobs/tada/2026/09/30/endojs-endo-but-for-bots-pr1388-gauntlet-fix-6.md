I applied the round-6 panel fixes to PR endojs/endo-but-for-bots#1388 and pushed them. CI is green: all 28 checks passed (`ci-wait-merge.sh` rc 0).

The fixes are one commit, `175024aa0a`, on `design/ocapn-cloudflare-netlayer` (it advances the head from `6f463d3e35`). It was pushed with `safe-push-pr-head.sh`. Only `designs/ocapn-cloudflare-netlayer.md` changed (+129/−38), and it passes Prettier.

**Input caveat.** The round-6 review and panel record `3d56e3cf6779` shorten each item to about 120 characters. They also list only the first 20 items, all from the critic. The findings from the decomplector, ergonomist and skeptic seats are not in any stored record, so I could not address them. The critic's three findings were clear enough to fix:

1. **A crossed hello could not be told apart from a reconnect.** I rewrote the check:
   - It now notes that `sessionId` is the same for every session between one pair of vats.
   - The comparison key is now the initiator designators, so it never ties.
   - Three cases:
     - **Same initiator:** the newer session replaces the older one.
     - **Different initiators, existing session still pending:** it is a crossed hello, and the comparison rule decides.
     - **Different initiators, existing session verified:** the network first sends one `ping` on the existing session. If the ping fails or times out, the new session replaces it. If it succeeds, the comparison rule decides.
   - The loser is aborted and its stubs are disposed.
   - A slow peer that misses the ping timeout can cause both sessions to be aborted. That costs a reconnect but is still safe; it is listed under Known Gaps.
   - I added test-plan cases for the evicted-peer reconnect and the same-initiator case.
   - I first tried putting a `held` field in the hello. I dropped it because in a true crossed hello both hellos would carry `null` and each side would drop a different session.
2. **Mailbox stub lifetime across `open` was never stated.** The design now says the responder calls `initiatorMailbox.dup()` inside `open`, and the initiator owns the returned `responderMailbox`. Each side disposes only the stub it keeps. I added verification item 10, citing the Workers RPC lifecycle page and the Cap'n Web README, plus a workerd harness test and a Known Gaps entry. I wrote item 10 from memory of those docs, not from rereading them, so it is worth a quick check of the cited pages.
3. **The case for the tree codec as default was weak.** The design now says plainly that bytes mode is cheaper on its own comparison table, and that dckc's explicit request is the deciding reason. **Bytes mode is now the default.** The tree codec becomes the default only when three conditions hold:
   - the cross-codec equivalence tests pass;
   - the core change stays within the codec envelope and the `signingCodec` split;
   - no deployment on these carriers needs Noise.

   I updated the carrier table, the hint examples (`do+syrup`/`capnweb+syrup` versus `+tree`) and Design Decision 5 to match.

**Follow-up:** the panel-7 driver should rerun the decomplector, ergonomist and skeptic seats in full, since their findings were not available to this round.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1388-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (1910167 cached reads)
- Output: 18719 tokens
- Cost: $1.3952293999999998
- Wall-clock: 1172s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
