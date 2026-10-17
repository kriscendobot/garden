---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Apply panel-5 PR-body edit to endojs/endo-but-for-bots#1482

The bot PAT on oros-studio cannot `updatePullRequest` on endojs. Your only task: run
`gh pr edit https://github.com/endojs/endo-but-for-bots/pull/1482 --body-file <file>` with the body between the markers below, written verbatim to a file. Do not push or change anything else.

----- BODY -----
Refs: #252, #1476, #1478

## Description

Phase 5 of `designs/ocapn-noise-session-reconnect.md` (design PR #252), stacked on #1481. It adds the crossed-hellos tiebreaker for reconnect.

- Either side redials, as design § 3 and its prompt ask ("reestablished with a TCP reconnect by either side"). A deterministic loser that never dials cannot recover a one-way partition where only it can reach the winner; the `sessionTimeoutMs` bound on the winner's deference covers a winner whose dial hangs.
- Tiebreaker (§ 3): the side with the greater handshake ephemeral initiates; see the comments at the responder's reconnect branch in `src/network.js`.

<!-- garden-phase-evidence-ledger:v1 -->
## Phase and evidence ledger

Design: `designs/ocapn-noise-session-reconnect.md`
Disposition: orchestrated-slice
Successor: endo-but-for-bots-ocapn-noise-session-reconnect-phases-3-5
Phase 1: satisfied | op:ping/op:pong in every codec plus heartbeat liveness, #1476
Phase 2: satisfied | session outbound queue + stall fault injector, #1478
Phase 3: satisfied | reconnect with Rekey, PR #1481 (this PR's base)
Phase 4: deferred | reconnect with Resume; gated on Open question C1 and the cryptographic review (#1475), not settled by the maintainer
Phase 5: satisfied | `packages/ocapn-noise/test/reconnect.test.js`, "crossed hellos on reconnect converge on one transport instance" (cbor and syrup)
Acceptance: partial | the design's crossed-hellos test holds; Resume (Phase 4) is deferred on C1
<!-- /garden-phase-evidence-ledger -->

### Security Considerations

- The tiebreaker input is already exchanged in the Noise IK handshake, so the comparison leaks nothing new. Open question P3 still asks whether a transcript-based value is preferable.
- A crossed dial is closed without an answer, never with a refusal, so the tiebreaker cannot make a peer abort a session it still holds.
- Every reconnect is still a full Noise IK handshake (Rekey), so no `(key, nonce)` pair is reused.

### Scaling Considerations

At most one extra handshake per crossed reconnect, closed as soon as its hello is read.

### Testing Considerations

See CI.

### Compatibility Considerations

Same wire format as #1481.

### Upgrade Considerations

None beyond #1481.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

<!-- garden-job: endo-but-for-bots-ocapn-noise-session-reconnect-phases-3-5-phase-5 -->



----- END BODY -----
