**Completion report: endojs-endo-but-for-bots-pr1506-gauntlet-undraft**

PR https://github.com/endojs/endo-but-for-bots/pull/1506 ("fix(ocapn-noise): bind np sessionId to the Noise handshake hash (R2)") is now out of draft and ready for review.

**What I did**
1. **Advisory appellate pass (does not block the un-draft):** I ran a light `claude -p` review over the 214-line diff. Its notes for possible follow-up:
   - The session-id hash input joins its parts with no length markers. That is safe today only because every part is 32 bytes.
   - If `channelBinding` is `undefined`, the code quietly falls back to the old key-only id, which brings the replay bug back. It should fail closed instead.
   - **Cross-version interop:** the PR changes how session ids are derived on the wire, so old and new `np` peers will fail to verify each other's handoff signatures. The changeset is marked `minor`; it may need to be `major`, or at least documented.
   - **Behaviour change:** handoffs signed before a reconnect will no longer verify after it. No test covers whether any legitimate flow relied on that.
   - **Missing test:** nothing checks that a handoff signed in connection 1 is rejected in connection 2. The current test only checks that the two session ids differ.
2. **Check before changing anything:** state was OPEN, `headRefOid` was exactly `9298cd9b1843e28df822afaafa5ff697b7ba26c7` (the commit the panel passed), and `isDraft` was true.
3. Ran `gh pr ready`, which succeeded.
4. **Check afterwards:** `isDraft` is false and the head is still `9298cd9b1843e28df822afaafa5ff697b7ba26c7`.

**Follow-ups:** none required. The advisory notes are for the maintainer's review. The interop/changeset-level question and the missing cross-connection rejection test are the ones most worth a look.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1506-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (174287 cached reads)
- Output: 1468 tokens
- Cost: $0.4096734000000001
- Wall-clock: 35s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
