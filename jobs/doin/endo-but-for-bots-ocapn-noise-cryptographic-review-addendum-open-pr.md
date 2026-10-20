---
role: designer
tier: mentor
dispatch: automatic
requires: host=endolin-garden-ece02cb4
arc: minion-town-mcp-ocapn
fallback-tier: minion
---
PR-open handoff for job build-endo-but-for-bots-ocapn-noise-cryptographic-review (host oros-studio cannot create endojs PRs: PAT 403 on createPullRequest).

The design is done and pushed. Only task: open a DRAFT design PR on endojs/endo-but-for-bots with
    head  kriscendobot:design/ocapn-noise-cryptographic-review-transport-addendum   (commit c986cab1a3078cb389369744a65c9ff1b4d8b161)
    base  design-ocapn-noise-cryptographic-review-453413b   (frozen snapshot of #1475's head, already on endojs)
Run, with cwd = a project worktree from ensure-project-worktree.sh <this-base> endojs/endo-but-for-bots design/ocapn-noise-cryptographic-review-transport-addendum (fetch from the kriscendobot fork):
    scripts/jobs/gardening/ensure-pr.sh <this-base> endojs/endo-but-for-bots design/ocapn-noise-cryptographic-review-transport-addendum design-ocapn-noise-cryptographic-review-453413b --draft \
      --title "docs(designs): OCapN-Noise cryptographic review — transport nonces and session layer" --body-file <file holding the body below>
Do not edit the design. Leave the PR draft and name it in the completion report (the completion machinery stages the design panel).

----- PR BODY -----
Refs: #1475, #1476, #1481, #1483, #1506

## Description

Designer step for the plan record `ocapn-noise-cryptographic-review` (M4 Networking, size S). This adds to the OCapN-Noise cryptographic review in #1475. That PR reviewed the as-built IK handshake and key derivation. This one reviews the transport-message handling and the heartbeat, session-hello, and session-id layer that is landing now. It is stacked on #1475's head (the frozen base is `design-ocapn-noise-cryptographic-review-453413b`), so the diff shows only the new material in `designs/ocapn-noise-cryptographic-review.md`.

**New findings**
- **F1:** a failed AEAD decryption throws but does not close the session, so a tampered stream can keep being read (`buildSession` reader).
- **F2:** the WASM keeps `HS`, which holds the static and ephemeral X25519 private keys, for the life of the session. It also leaves the Ed25519 seed in `BUFFER`.
- **F3:** the initiator does not check that the accepted encoding byte was one it offered.
- **F4:** the #1481 reconnect token, the first connection's handshake hash, can be computed from public values. It is safe only because the responder looks it up together with the authenticated peer key.
- **F5:** once reconnect is transparent, the `sessionId` from #1506 should come from the session token (the first connection's hash), not from each connection's hash. Otherwise the handoff replay counters stop matching the ID.

**Ratified:** implicit ordered Noise nonces as the replay defense within a connection; the per-local-key cap on SYN replays; heartbeat-capability negotiation inside the tunnel, which an outside attacker cannot downgrade; and #1476's check that a peer cannot acknowledge more frames than were sent.

**Recommendations R6 to R10:** treat authentication failure as fatal; clear handshake key state and check the accepted encoding; look up reconnects by (authenticated peer, token); spell out exactly-once retransmission; derive `sessionId` from the session token. New open question **Q4**: should `sessionId` stay the same across Rekey reconnects?

The original deliverable also asks for sign-off from a contributor who knows cryptography. The fleet cannot provide that.

### Security Considerations

This changes documentation only. R6 and R8 close real gaps: continuing after a failed authentication, and a possible session takeover if a future refactor looks a session up by token alone. R10 keeps the handoff replay boundary consistent once reconnect lands.

### Scaling Considerations

None.

### Documentation Considerations

R6 to R10 belong in the `np/1` wire contract (R4) and the session-reconnect design.

### Testing Considerations

This PR changes no tests. The follow-up build adds a tampered-frame test (R6) and a foreign-token reconnect test (R8).

### Compatibility Considerations

None of R6 to R9 changes the wire. R10 changes `sessionId` values before `np` stabilizes, which #1506 already does.

### Upgrade Considerations

None.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-20T03:09:24Z
