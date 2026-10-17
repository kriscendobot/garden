---
role: gardener
tier: mentor
requires: host=endolin-garden-ece02cb4
dispatch: automatic
pr: https://github.com/endojs/endo-but-for-bots/pull/1476
fallback-tier: minion
---

# Apply the trimmed PR body to endojs/endo-but-for-bots#1476

Handed off from `endojs-endo-but-for-bots-pr1476-gauntlet-fix-3`: the
oros-studio host's PAT gets a 403 on `updatePullRequest` for endojs, so
this host-pinned job only applies the body edit. It answers the panel-3
must-fix (missing `### Documentation Considerations` heading; body over
300 words; Phase 2 ledger line misstated as satisfied).

Write everything between the BODY markers below to a file and run:

    gh pr edit 1476 -R endojs/endo-but-for-bots --body-file <file>

Then confirm with `gh pr view 1476 -R endojs/endo-but-for-bots --json body`
that the body starts with the `garden-job` marker and contains
`### Documentation Considerations`. Do not change anything else (no
pushes, no reviews).

-----BEGIN BODY-----
<!-- garden-job: endo-but-for-bots-ocapn-noise-session-reconnect-build -->
Refs: #252

## Description

Phase 1 of `designs/ocapn-noise-session-reconnect.md`. The OCapN codec adds `op:ping` and `op:pong`, which an OCapN session ignores. The Noise network gains an opt-in `heartbeat` option: each session exchanges heartbeats inside the Noise channel, the session reader skips them, and a read that waits a full session timeout with no frame from the peer rejects and closes the session. `session.getLiveness()` reports the received and acknowledged nonces.

`src/network.js` is the file to review most closely.

<!-- garden-phase-evidence-ledger:v1 -->
## Phase and evidence ledger

Design: `designs/ocapn-noise-session-reconnect.md`
Disposition: orchestrated-slice
Successor: endo-but-for-bots-ocapn-noise-session-reconnect-phases-3-5
Phase 1: satisfied | op:ping/op:pong in the shared syrup+CBOR operation codec (codec table + snapshots); heartbeat liveness in the Noise network; idle loss detected in one session timeout (`packages/ocapn-noise/test/heartbeat.test.js`)
Phase 2: in-progress | stacked draft #1478 (session-level outbound queue and stall fault injector); not in this diff
Phase 3: not-started | reconnect with Rekey
Phase 4: not-started | reconnect with Resume; gated on Open question C1 and the cryptographic review
Phase 5: not-started | crossed-hellos tiebreaker on reconnect
Acceptance: partial | Phase 1's acceptance holds (both codecs round-trip both operations; an idle session is detected as lost in seconds); the reconnect, nonce-monotonicity, replay-idempotence, and hard-timeout tests belong to Phases 2–5
<!-- /garden-phase-evidence-ledger -->

### Security Considerations

Heartbeats travel only inside the authenticated Noise channel. A peer's `op:pong` can only raise the recorded acknowledgment, and only up to nonces this side has used.

### Scaling Considerations

At the defaults, an idle session sends about 0.4 small encrypted frames per second in each direction.

### Documentation Considerations

The `@endo/ocapn-noise` README gains a "Session heartbeats" section, the one place the option's behavior is described.

### Testing Considerations

- The codec tests round-trip both operations in syrup and CBOR; `heartbeat.test.js` covers idle survival, silent-peer loss, timer teardown, malformed frames, the acknowledgment bound, and option bounds.
- Not run on XS or endor: both packages stub `test:xs`, and no XS harness exists for the Noise WASM yet.
- The snapshot `.md` report is deliberately unchanged (it carries literal NUL bytes); the `.snap` file has the new entries.

### Compatibility Considerations

Heartbeats are off by default. `OcapnNoiseSession` implementers and mocks must add `getLiveness()`.

### Upgrade Considerations

None until the successor adds the handshake capability bit that lets heartbeats default on.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
-----END BODY-----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-17T03:02:09Z
