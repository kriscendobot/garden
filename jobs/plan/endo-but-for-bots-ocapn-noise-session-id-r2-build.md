---
gate: awaiting-maintainer
maintainer_question: 'Q2 of designs/ocapn-noise-cryptographic-review.md: for R2, bind np sessionId to the Noise handshake hash, or persist handoff replay state per stable sessionId?'
asked_at: https://github.com/endojs/endo-but-for-bots/pull/1475
priority: normal
arc: endo-ocapn-background
posted_by: producer
posted_at: 2026-10-17T01:08:58Z
---

---
role: builder
arc: endo-ocapn-background
dispatch: automatic
tier: mentor
fallback-tier: minion
---
# Build: R2 of the OCapN-Noise cryptographic review (endojs/endo-but-for-bots#1475)

Repo: https://github.com/endojs/endo-but-for-bots. Design PR: https://github.com/endojs/endo-but-for-bots/pull/1475 (`designs/ocapn-noise-cryptographic-review.md` § 5, R2, open question Q2).

`makeSessionId` (packages/ocapn/src/cryptography.js) hashes only the two long-term keys, so every `np` session between the same two peers gets the same `sessionId`, while the handoff replay state (`nextHandoffCount`, `usedGiftHandoffs` in packages/ocapn/src/client/ocapn.js) is per connection. Implement whichever option the maintainer selects for Q2: (1) mix the final Noise handshake hash into the `np` sessionId, or (2) persist per-`sessionId` replay state across connections and restarts. First write the cross-connection handoff-replay test the panel asked for (skeptic finding 1 on #1475) so the exploitability is shown, then fix. Note the panel (critic, decomplector) observed option 1 is nearly free once R3 drops Resume; the reconnect PR #1481 uses the opening handshake hash as its session token, so check composition with it.

Sibling build that implemented R1, R3, R4 (and stopped short of R2 for want of Q2): job `endo-but-for-bots-ocapn-noise-cryptographic-review-design-build`. Open a DRAFT PR on a frozen `llm-<sha>` base.
