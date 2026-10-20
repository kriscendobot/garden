---
handed-off: endo-but-for-bots-ocapn-noise-cryptographic-review-addendum-open-pr
deliverable-complete: false
---
## Completion report: build-endo-but-for-bots-ocapn-noise-cryptographic-review

The review is written and pushed, but its draft PR is not open yet. This host's token is refused when it tries to create a PR on endojs (403 on `createPullRequest`), so I posted a successor job, pinned to the endolin host, to open it.

**I did not write a second version of the review.** The review of the as-built IK handshake already exists as endojs/endo-but-for-bots#1475 (open, passed one design-panel round, recommendations R1–R5, open questions Q1–Q3). It already covers the handshake pattern, deriving the X25519 keys from Ed25519, channel binding, the cross-connection `sessionId` problem (R2), and Rekey versus Resume (R3). A new PR rewriting the same file would have duplicated it and conflicted with it.

**What I added** is a commit stacked on #1475's head that covers what #1475 does not: transport nonce and replay handling, and the heartbeat, session-hello and session-id layer now landing in #1476, #1481, #1483 and #1506.
- **§8, transport nonces, replay and failures:**
  - Ratifies the ordered implicit Noise nonces as the replay defense within a connection, and the per-local-key cap on replayed SYNs.
  - **F1:** a failed decryption throws, but the session reader in `buildSession` neither closes the stream nor marks the session closed, so reading can continue after tampering.
  - **F2:** the Rust handshake state (`HS`) keeps the static and ephemeral X25519 private keys for the whole session, and the Ed25519 seed stays in `BUFFER[64..96]`.
  - **F3:** `initiatorReadSynack` does not check that the encoding the responder picked was one the initiator offered.
- **§9, the session layer:**
  - Ratifies feature negotiation inside the tunnel (an outside attacker cannot downgrade it) and #1476's check that a peer cannot acknowledge more frames than were sent.
  - **F4:** the reconnect token in #1481 is the first connection's handshake hash, which anyone who saw that handshake can compute. #1481 is safe only because the responder also checks the authenticated peer key.
  - **F5:** once reconnect is transparent, the `sessionId` in #1506 should come from the session token, not from each connection's hash; otherwise the handoff replay counters stop matching the ID.
- **R6–R10:** treat any authentication failure as fatal; clear the handshake keys after use and check the encoding; look up reconnects by authenticated peer plus token, never token alone; spell out exactly-once retransmission; derive `sessionId` from the session token. Known-gaps checkboxes, a new open question **Q4**, and a Dependencies row were added to match.

**Where things are:**
- The design commit is `c986cab1a`, on `kriscendobot:design/ocapn-noise-cryptographic-review-transport-addendum`.
- The frozen base is `design-ocapn-noise-cryptographic-review-453413b`, a snapshot of #1475's head pushed to endojs, so the PR diff will show only the addendum.
- The PR open was refused as expected. The successor job **`endo-but-for-bots-ocapn-noise-cryptographic-review-addendum-open-pr`** (`requires: host=endolin-garden-ece02cb4`) runs `ensure-pr.sh` with the full PR body embedded and leaves the PR draft for the design panel.

**Follow-ups:**
- Once #1475 and this addendum are accepted, the build covers R6 and R7 (code fixes in `network.js`, `bindings.js` and `rust/ocapn_noise`, with a tampered-frame test). R8–R10 are amendments to #1481 and #1506: a foreign-token reconnect test and switching the `sessionId` source.
- Q4 and #1475's Q1–Q3 need the maintainer's answers.
- The plan still requires sign-off from a contributor who knows cryptography, which the fleet cannot provide.
- I added today's 403 to the memory note on this host's endojs PR-write limit (`bot-pat-no-pr-write-endojs.md`).

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-but-for-bots-ocapn-noise-cryptographic-review.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (2188380 cached reads)
- Output: 22842 tokens
- Cost: $1.7587
- Wall-clock: 485s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
