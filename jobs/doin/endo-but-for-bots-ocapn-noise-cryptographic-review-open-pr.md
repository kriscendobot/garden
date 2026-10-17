---
role: builder
tier: mentor
fallback-tier: minion
requires: host=endolin-garden-ece02cb4
arc: endo-ocapn-background
dispatch: automatic
---
# Open the draft PR for the OCapN-Noise cryptographic-review build (endojs/endo-but-for-bots#1475)

The predecessor builder job `endo-but-for-bots-ocapn-noise-cryptographic-review-design-build` finished the implementation on host oros-studio-garden-ce242c49, whose bot PAT gets 403 on `createPullRequest` for endojs. Your only task is to open the DRAFT PR from an endolin host.

- Head branch (pushed to origin `endojs/endo-but-for-bots`): `build/ocapn-noise-cryptographic-review` at `8e4b72fefb036841fe95aa0b112c3b4db88657a1` (three commits).
- Base: the frozen `llm-a794753` (already on origin, = `llm` at a7947533c).

Do not rewrite the branch. Get a project checkout with `scripts/jobs/ensure-project-worktree.sh <this-job-base> endojs/endo-but-for-bots build/ocapn-noise-cryptographic-review`, cd into it (the phase-evidence gate resolves design paths from cwd), write the body below to a file verbatim, and run:

    scripts/jobs/gardening/ensure-pr.sh <this-job-base> endojs/endo-but-for-bots build/ocapn-noise-cryptographic-review llm-a794753 \
      --title 'feat(ocapn-noise): key-confirmation test, np/1 wire contract, and Rekey-only reconnect (cryptographic review R1, R3, R4)' \
      --body-file <file>

If the head moved since this was posted, open the PR anyway on the current head. Name the PR number in your completion report so the gauntlet is staged.

## PR body (verbatim, between the markers)

-----BEGIN BODY-----
Refs: #1475

## Description

This builds the recommendations of the OCapN-Noise cryptographic review (`designs/ocapn-noise-cryptographic-review.md`, design PR #1475) that need no further maintainer decision. It is based on the frozen `llm-a794753`, because the `np` network code and the session-reconnect design exist only on `llm`.

- **R1, key confirmation (test).** `packages/ocapn-noise/test/network.test.js` adds "a key-compromise-impersonation SYN never graduates". The test holds the responder's private key and forges a Noise IK message 1 that claims a victim initiator. It computes `ss` from the responder's side, using the existing independent message-1 builder `test/_noise-ik-msg1.js`. The responder accepts the SYN and answers it. The forger cannot compute `se`, so it can only guess at `op:start-session`. The test asserts that the responder hangs up and never graduates a session for the victim. `network.js` already behaves this way, so no source change was needed. The test guards the rule against future refactors.
- **R1 and R5, normative text; R4, wire contract.** `packages/ocapn-noise/README.md` gains a "Wire contract" section for `np/1`. It covers the protocol name, the prologue bytes, the derivation of X25519 keys from Ed25519, the SYN, SYNACK, payload and transport-message layouts and the encoding offer, the weak-key and torsion checks on both sides, and the `-A` alias. It also defines the handshake hash and the location-signature binding (`"ocapn-location-v1\0" || uint32(len(h)) || h || my-location`). Two rules are normative: a responder must not treat an initiator as authenticated before its `op:start-session` verifies (R1), and an initiator must not send application data in message 1, so there is no 0-RTT (R5).
- **R3, Rekey.** `designs/ocapn-noise-session-reconnect.md` settles C1 as Rekey on every reconnect. It removes the Resume option, the `RESUME` / `RESUME-ACK` records, the rekey cap, and Phase 4. Section 4 now describes the reconnect handshake: a fresh IK handshake and `op:start-session`, then a record that names the session and `epoch + 1`, then replay of the frames the peer did not receive. The diagrams, security considerations, test plan, decisions and open questions are updated to match. The new text stays abstract about the record's encoding, so it composes with #1481, which implements Phase 3 with an `op:session-hello` that carries the opening handshake hash as the session token.

**Not built: R2.** R2 is the per-connection `sessionId` or the persisted handoff replay state. It waits on the design's open question Q2, which the maintainer has not answered. The garden has parked it as job `endo-but-for-bots-ocapn-noise-session-id-r2-build`, gated on that answer. The panel on #1475 noted that option 1 (binding the handshake hash into the `sessionId`) becomes nearly free once Resume is dropped. The cross-connection replay test belongs with that job.

This PR assumes that #1475's recommendations stand. In particular, the reconnect-design amendment applies R3. If the review changes R3, that commit should be dropped.

<!-- garden-related-design: 1475,1481 -->

### Security Considerations

This PR changes no behavior. It pins, with a regression test, the property that makes IK's key-compromise impersonation weakness harmless: a forged SYN never yields a session. It also makes that property and the no-0-RTT rule normative for any second implementation. The reconnect-design amendment removes the only path that could have reused a ChaCha20-Poly1305 `(key, nonce)` pair.

### Scaling Considerations

None. Under the amended reconnect design, each reconnect costs one IK handshake: 213 bytes and one round trip.

### Documentation Considerations

The `np/1` wire contract is now in the package README, and the session-reconnect design no longer describes Resume.

### Testing Considerations

The new test passes, and it fails when the responder is mutated to graduate after a failed `op:start-session` exchange: "A hangs up on the forger" fails. Locally, `yarn test` in `packages/ocapn-noise` passed. One run hit the known intermittent `ws-transport.test.js` worker exit that comes from concurrent ses-ava configs; the file passes when run alone. `eslint` and `tsc` are clean.

### Compatibility Considerations

None. There is no wire or API change.

### Upgrade Considerations

None.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
-----END BODY-----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-17T01:30:53Z
