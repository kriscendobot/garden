---
handed-off: endo-but-for-bots-ocapn-noise-cryptographic-review-open-pr
deliverable-complete: false
---
## Completion report: `endo-but-for-bots-ocapn-noise-cryptographic-review-design-build`

**Handoff, not a clean completion.** I wrote and pushed the code, but the draft PR is not open yet. This host's bot token gets a 403 when it tries to create a PR on endojs (`createPullRequest`: "Resource not accessible by personal access token"). A successor job pinned to an endolin host now owns opening the PR.

### What I built
Branch `build/ocapn-noise-cryptographic-review` on `endojs/endo-but-for-bots`, at `8e4b72fef`, is pushed. Its base is the frozen `llm-a794753`. I chose `llm` because master's `packages/ocapn-noise` has no `network.js` and the reconnect design file does not exist there. The branch has three commits:

1. **R1 test.** `test(ocapn-noise): a key-compromise-impersonation SYN never graduates`, in `packages/ocapn-noise/test/network.test.js`.
   - The test plays an attacker who holds the responder's private key and forges a SYN claiming to be a victim peer, using the existing `_noise-ik-msg1.js` builder.
   - The responder answers the SYN. The test then checks that the responder hangs up and never hands out a session for the victim.
   - The test is load-bearing: I changed the responder to accept the peer even when the `op:start-session` check fails, and the test failed ("A hangs up on the forger"). It passes with the change reverted.
   - `network.js` already behaves correctly, so there is no source change.
2. **R4 wire contract, plus R1 and R5 as rules.** `docs(ocapn-noise): write down the np/1 wire contract`.
   - Adds a "Wire contract" section to the package README covering:
     - the protocol name and prologue bytes
     - how the X25519 keys are derived from Ed25519
     - the byte layout of each message (SYN 164, SYNACK 49, 213 bytes in total)
     - the weak-key checks and the `-A` alias
     - the handshake hash and how the location signature is bound to it
   - Two "must" rules:
     - a responder treats nobody as authenticated until their `op:start-session` verifies (R1)
     - no application data goes in message 1 (R5)
3. **R3 Rekey.** `docs(designs): settle session-reconnect C1 as Rekey and drop Resume`.
   - In `designs/ocapn-noise-session-reconnect.md`, removes the Resume option, the `RESUME`/`RESUME-ACK` records, the rekey cap and Phase 4.
   - Rewrites §4 as "Rekey on Every Reconnect", describing the reconnect handshake.
   - Updates the diagrams, security section, test plan, decisions and open questions to match.
   - The new text stays general enough to fit #1481, which already implements reconnect with Rekey.

### Checks
- `yarn test` in `packages/ocapn-noise`: everything passed except `ws-transport.test.js`, which exited non-zero in one run. That file passes when run on its own; #1481 reports the same intermittent failure from test configs sharing a cache.
- `eslint` and `tsc` are clean.
- The pre-push gates pass after I replaced a "≤" character in the README with "at most".
- The related-design check against #1475 and #1481 came back clear, and the phase-evidence gate was clear.

### Not built: R2
R2 makes the `sessionId` unique per connection or keeps the replay state across connections. It depends on the design's open question Q2, which the maintainer has not answered. I parked it as `endo-but-for-bots-ocapn-noise-session-id-r2-build` in `plan/`, waiting on that answer. It points at #1475 as the place the question is asked. Its body asks for the cross-connection replay test first and notes that #1481 uses the opening handshake hash as its session token.

### Follow-ups
- **`endo-but-for-bots-ocapn-noise-cryptographic-review-open-pr`** (in `todo/`, pinned to `endolin-garden-ece02cb4`): opens the draft PR with `ensure-pr.sh`, carrying the title and the full PR body word for word. When that job finishes, its report names the PR and the review gauntlet is staged.
- The design PR #1475 is still open with no maintainer review. The reconnect-design commit assumes R3 stands; if the review changes R3, that commit should be dropped. The PR body says so.
- I added today's 403 to the existing memory note about this host's token.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-but-for-bots-ocapn-noise-cryptographic-review-design-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 136 tokens (8723649 cached reads)
- Output: 41883 tokens
- Cost: $3.9709098
- Wall-clock: 1012s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
