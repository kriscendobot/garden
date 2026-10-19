---
role: builder
tier: mentor
requires: host=endolin-garden-ece02cb4
fallback-tier: minion
dispatch: automatic
arc: minion-town-mcp-ocapn
---
Open the DRAFT PR for R2 of the OCapN-Noise cryptographic review on https://github.com/endojs/endo-but-for-bots. That is the whole task. The code is already built and pushed. Job `build-ocapn-noise-session-id-round-two` ran on oros-studio, where the bot token cannot create PRs on endojs (`createPullRequest` 403).

Before opening it, check that:
- branch `build/ocapn-noise-session-id-r2` exists on endojs/endo-but-for-bots with head `9298cd9b1` (one commit, "fix(ocapn-noise): bind np sessionId to the Noise handshake hash");
- the frozen base `llm-330cf99` exists at `330cf996c0b9b3a2cd8a9c007751499286bb8a80`, which is the head's parent.

Then write the body below (between the BODY markers) to a file and run:

    scripts/jobs/gardening/ensure-pr.sh build-ocapn-noise-session-id-round-two endojs/endo-but-for-bots build/ocapn-noise-session-id-r2 llm-330cf99 --title "fix(ocapn-noise): bind np sessionId to the Noise handshake hash (R2)" --body-file <file>

Use the base `build-ocapn-noise-session-id-round-two`, not this job's base, so the `garden-job` marker matches the originating build. Keep the PR draft. Name the PR URL in your completion report, which stages the gauntlet. Local tests already passed (ocapn 560, ocapn-noise 79, tsc clean). Watch the first CI run and report its result.

----- BODY -----
<!-- garden-job: build-ocapn-noise-session-id-round-two -->
Refs: #1475, #1487, #1481

## Description

This PR implements R2 from the OCapN-Noise cryptographic review (`designs/ocapn-noise-cryptographic-review.md` § 5, design PR #1475).

`makeSessionId` hashed only the two long-term public keys. As a result, every `np` session between the same two peers got the same `sessionId`. The handoff replay state (`nextHandoffCount`, `usedGiftHandoffs` in `packages/ocapn/src/client/ocapn.js`) only lasts for one connection. A `HandoffReceive` signed during an earlier connection could therefore pass the duplicate check in a later one.

This PR takes **option 1 of Q2** and mixes the final Noise handshake hash into the `np` sessionId:

- `packages/ocapn/src/cryptography.js`: `makeSessionId(peerIdOne, peerIdTwo, channelBinding?)` takes an optional third argument, which is hashed after the sorted peer ids. If you leave it out, the derivation is unchanged.
- `packages/ocapn-noise/src/network.js`: `buildSession` gets the `handshakeHash` that is already used for location-signature channel binding, and passes it in on both the initiator and responder paths.

**Q2 is answered provisionally.** It is still open on #1475. I chose option 1 because:
- `resumeSession`, the one consumer that needs a stable id, is used only by thixotrope's `pipe-network`, which mints its own ids. It never sees an `np` id.
- R3, now on #1487, drops Resume for Rekey, so every reconnect is a new handshake anyway.
- Option 2 (persisting replay state for each stable `sessionId`) would need durable state across restarts.

If @kriskowal picks option 2 instead, close this PR.

### Security Considerations

This change closes a cross-connection replay window for handoff receipts. A gift handoff signed in one `np` connection now names a `sessionId` that no later connection between the same peers shares. The handshake hash is already the channel-binding value for location signatures, so this adds no new trust assumption.

### Scaling Considerations

One additional 32-byte input to an existing double SHA-256 per session. Negligible.

### Documentation Considerations

The changeset documents the new optional `channelBinding` argument and the `np` behavior change. The `np/1` wire-contract section that R4 adds on #1487 should say that `sessionId` covers the handshake hash.

### Testing Considerations

- `packages/ocapn-noise/test/network.test.js`: *each connection between the same two peers gets a fresh sessionId*. It connects, closes, and reconnects the same two peers. It checks that both sides agree on each id, that the two connections' ids differ, and that the key-only id (the old derivation) is the same across both. I confirmed this test fails with the binding removed.
- `packages/ocapn/test/cryptography.test.js`: the bound id does not depend on argument order and differs for a different binding or for no binding.
- `yarn test` passes in `packages/ocapn` (560) and `packages/ocapn-noise` (79). `tsc` is clean in ocapn-noise.

Still needed: an end-to-end test that replays a signed `HandoffReceive` across two connections through a three-party handoff. The test above covers its precondition: the ids collided before this change and now differ.

### Compatibility Considerations

`makeSessionId` callers that pass two arguments see no change. On `np`, both peers must run this version to agree on a `sessionId`. A mixed pair would compute different ids, and handoff signatures across them would fail to verify.

### Upgrade Considerations

Upgrade both peers of an `np` link together. A handoff certificate that is still in flight across an upgrade names the old id and will be rejected. It must be re-issued.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- END BODY -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-19T15:59:03Z
