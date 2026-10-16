---
handed-off: endo-but-for-bots-ocapn-noise-session-reconnect-open-prs
deliverable-complete: false
---
## Completion report: `endo-but-for-bots-ocapn-noise-session-reconnect-phases-3-5`

The code for Phases 3 and 5 and the heartbeat capability bit is built, tested and pushed as three stacked branches. The pull requests are not open yet: this host's bot token gets a 403 when it tries to create PRs on endojs (`ensure-pr.sh` → `createPullRequest`). I posted a successor job, pinned to an endolin host, that only opens them. Phase 4 is deferred because the maintainer has not settled Open question C1.

**Pushed branches** (endojs/endo-but-for-bots; each frozen base is pushed too)

| Item | Head | Base |
|---|---|---|
| Phase 3: reconnect with Rekey | `build/ocapn-noise-session-reconnect-rekey` (4d8b59b6e) | `build/ocapn-noise-session-queue-2a16357` (frozen #1478 head) |
| Phase 5: crossed-hellos tiebreaker | `build/ocapn-noise-session-reconnect-crossed-hellos` (9376e7e05) | `build/ocapn-noise-session-reconnect-rekey-4d8b59b` |
| Heartbeat capability bit, on by default, daemon wiring | `build/ocapn-noise-heartbeat-capability` (9cc41693a) | `build/ocapn-noise-session-reconnect-crossed-hellos-9376e7e` |

**Phase 3**
- **New records:** `op:session-hello` (features, epoch, session token, frames received) and `op:session-end`, in `@endo/ocapn/operations`, with a changeset. Every transport instance exchanges the hello right after `op:start-session`. This changes the OCapN-Noise wire exchange, so both peers must run this version or later.
- **Opt-in:** reconnect is enabled with `reconnect` (needs `heartbeat` on both sides). On loss, the session keeps its queue and redials with a fresh Noise IK handshake, and the epoch advances.
- **Exactly-once replay:** each side keeps sent frames until the peer's `op:pong` acknowledges them. The reconnect hello carries how many frames each side has received, and only frames past that point are replayed. No CapTP-level dedup is needed.
- **Hard timeout (§ 5):** if no new instance is up within `SESSION_HARD_TIMEOUT`, the session aborts with an error its reader surfaces. Writes fail fast near the end of that budget.
- **Refusal:** a peer that no longer holds the session (restarted or closed) refuses the reconnect, and the dialer aborts at once instead of waiting out the hard timeout.
- **Fault injector:** new `test/_loss-injector.js` partitions a transport's open streams and can refuse new connections.

**Phase 5**
- Either side now redials after a loss, not only the side that opened the session.
- When both redial at once, the two x25519 ephemerals from the handshake that opened the session are compared (§ 3). The winning side closes the peer's crossed dial without an answer; the losing side accepts it. Exactly one transport instance survives.
- Late or stale dials are closed unanswered, so the two sides always converge.

**Capability bit**
- Heartbeats run on a session only when both hellos advertise them.
- `heartbeat` now defaults on (`heartbeat: false` opts out); reconnect stays opt-in.
- The daemon passes `heartbeat: {}` in `packages/daemon/src/networks/ocapn.js`.

**Evidence**
- New `test/reconnect.test.js` (13 tests, both codecs): reconnect with in-order, exactly-once replay; three reconnects in a row; hard-timeout abort; fail-fast writes; refusal; clean close without reconnect; a peer without reconnect; crossed hellos ending with one stream seen from each side; the accepting side reconnecting when the opener can't dial out.
- `integration.test.js`: a CapTP call made during the partition is answered exactly once on the new instance.
- I confirmed with debug logging that the crossed-hellos test really triggers the tiebreaker (the winning side drops the peer's dial). The reconnect suite passed six runs in a row.
- `@endo/ocapn-noise` passed 102–106 tests per config across the three branches; `@endo/ocapn` passed 563; daemon `networks-ocapn.test.js` passed 9 of 9; lint and type checks report no errors.
- Full-suite runs sometimes report an "uncaught exception": an `ENOENT .cache/ava/import-from-project.mjs` error caused by the three ses-ava configs sharing one ava cache. Every affected file passes when run alone.

**Not done (deliberately)**
- **Phase 4 (Resume) is not built.** It is marked deferred in every new ledger, gated on C1 and the cryptographic review (#1475).
- **#1476 and #1478 ledgers stay at partial, not `deliverable`.** The job allows that update only once Phase 4 has evidence or a deferral the maintainer settled, and C1 is still open.
- I messaged the maintainer asking them to decide C1.

**Handoff**
- The successor job `endo-but-for-bots-ocapn-noise-session-reconnect-open-prs` (`requires: host=endolin-garden-ece02cb4`; confirmed in `jobs/todo/` on origin/journal2) opens the three draft PRs with `ensure-pr.sh`. Each PR has its own marker key (`<this-base>-phase-3`, `-phase-5`, `-heartbeat-capability`).
- Its body contains all three PR bodies, each with the phase-and-evidence ledger.

**Follow-ups**
- Phase 4 and the #1476/#1478 ledger update, once C1 is settled.
- Optional: turning reconnect on in the daemon. This work only enables heartbeats there.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-but-for-bots-ocapn-noise-session-reconnect-phases-3-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 188 tokens (15780403 cached reads)
- Output: 104477 tokens
- Cost: $7.0869886000000015
- Wall-clock: 3020s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
