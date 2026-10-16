# Completion report: endo-but-for-bots-ocapn-noise-cryptographic-review-design

**Design PR:** https://github.com/endojs/endo-but-for-bots/pull/1475 is open as a draft against the frozen base `llm-61cd656`. The head branch is `kriscendobot:design/ocapn-noise-cryptographic-review`, and the slug is `ocapn-noise-cryptographic-review`.

## What I found
The plan record still described the old handshake: Noise XX, plus signatures linking a separate X25519 key to the Ed25519 identity key ("bonding"). The code on `llm` had already moved on. It runs `Noise_IK_25519_ChaChaPoly_BLAKE2s`, derives both X25519 keys from the Ed25519 identities, and has no bonding signature and no third handshake message. `designs/README.md` had marked the document "Deprecated" without recording any review. So I rewrote the document as a review of the protocol as built.

## What changed (3 files)
- **`designs/ocapn-noise-cryptographic-review.md`** (rewritten, status Proposed):
  - It sets out the threat model implied by OCapN locators.
  - It compares XX, XK and IK using the Noise spec's ratings for identity hiding (§7.8) and message protection (§7.7).
  - It **keeps IK and the derived X25519 keys**. The derived keys rest on Thormarker's proof that one key can safely do both jobs (ePrint 2021/509).
  - It notes a side effect of the key conversion: anyone holding key A can also present the negated key −A. That is a second name for the same holder, not an impersonation of anyone else, so it is accepted.
  - It confirms that each peer's location signature is correctly tied to its own session.
- **Recommendations before the `np` netlayer stabilizes:**
  - **R1:** Make it a written rule that a responder treats an initiator as authenticated only after the initiator's first encrypted message decrypts. The code already does this. The rule blocks an attacker who has stolen the responder's key from posing as another initiator. Add a test with a forged handshake.
  - **R2:** `sessionId` is built only from the two long-term keys, so it is the same for every session between the same two peers. The handoff anti-replay state (`nextHandoffCount`, `usedGiftHandoffs`) resets on every connection, so a handoff from an earlier connection can pass the duplicate check in a later one. The fix is either to bind the ID to the handshake, or to keep that state across connections.
  - **R3:** This settles the reconnect design's open question C1: on reconnect, do a fresh handshake ("Rekey") rather than continuing the old encryption state ("Resume"). With IK a fresh handshake costs only 213 bytes and one round trip, while Resume risks reusing a key/nonce pair.
  - **R4:** Write down the wire contract.
  - **R5:** Never send application data in the first handshake message.
- **`designs/ocapn-noise-network.md`:** I corrected the stale XX and third-message text in the connect sketch, the Session Establishment section and the Security Considerations, and bumped Updated to 2026-10-16.
- **`designs/README.md`:** I updated this row and the other noise-network row, the dependency-graph label, the status table, and the totals (Proposed 30→31, Deprecated 4→3).

## Open questions in the design (for the maintainer)
- **Q1:** Hiding the initiator's identity even if the responder's key leaks later would mean switching to XK, at a cost of half a round trip. The review recommends against it; please confirm.
- **Q2:** For R2, should `sessionId` be bound to the handshake hash, or should the handoff replay state persist per `sessionId`?
- **Q3:** When should a post-quantum hybrid `np/2` suite be scheduled?

The original deliverable also requires sign-off from a contributor who knows cryptography. The bot fleet cannot provide that, so it is listed under Known Gaps in the document.

## Follow-ups
- **Build: `build-ocapn-noise-cryptographic-review`.** This is one builder job to implement R1, R2 (once Q2 is answered) and R4 in `packages/ocapn-noise` and `packages/ocapn`. It should also amend `designs/ocapn-noise-session-reconnect.md` to drop the Resume path (R3). The design-build handoff machinery should post or park it behind the design gauntlet.
- PR #1475 is left as a draft for the automatic design-panel gauntlet.

<!-- garden-design-build-handoff: successor=endo-but-for-bots-ocapn-noise-cryptographic-review-design-build state=recheck:endojs-endo-but-for-bots-pr1475-gauntlet pr=https://github.com/endojs/endo-but-for-bots/pull/1475 -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-but-for-bots-ocapn-noise-cryptographic-review-design.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (3463260 cached reads)
- Output: 28326 tokens
- Cost: $2.2637080000000003
- Wall-clock: 346s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
