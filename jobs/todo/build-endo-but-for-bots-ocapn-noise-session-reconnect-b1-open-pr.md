---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
requires: host=endolin-garden-ece02cb4
---
Open the DRAFT PR for build slice B1 (reconnect protocol conformance tests) in endojs/endo-but-for-bots. The code is already pushed; the claiming host oros-studio-garden-ce242c49 cannot create endojs PRs (PAT 403 / rate-limited, ensure-pr INCONCLUSIVE). Do NOT edit code.

- head: `build/ocapn-noise-reconnect-protocol-conformance` (commit f8e6e488a)
- base: `build/ocapn-noise-heartbeat-capability-362dd9e` (frozen snapshot of the #1483 head 362dd9e, already pushed)

Get a project worktree (`ensure-project-worktree.sh build-endo-but-for-bots-ocapn-noise-session-reconnect-b1-open-pr endojs/endo-but-for-bots build/ocapn-noise-reconnect-protocol-conformance`), cd into it, write the PR body below (between the BODY markers) to a file, and run, with cwd = that project worktree:

    scripts/jobs/gardening/ensure-pr.sh build-endo-but-for-bots-ocapn-noise-session-reconnect-b1-conformance-tests endojs/endo-but-for-bots build/ocapn-noise-reconnect-protocol-conformance build/ocapn-noise-heartbeat-capability-362dd9e --title "test(ocapn-noise): reconnect protocol conformance tests (B1)" --body-file <file>

Use the ORIGINAL job base (`build-endo-but-for-bots-ocapn-noise-session-reconnect-b1-conformance-tests`) as ensure-pr's first argument so the durable marker matches the producing job and the gauntlet is staged as for any build. Keep the PR a draft. Report the PR URL.

----- BODY -----
Build slice **B1** of [`designs/ocapn-noise-session-reconnect-protocol.md`](https://github.com/endojs/endo-but-for-bots/pull/1512) (design PR #1512, § Build Breakdown): protocol conformance tests for the reconnect rules, with no production code changes.

Base: `build/ocapn-noise-heartbeat-capability-362dd9e`, a frozen snapshot of the #1483 head (`362dd9e`). The design names `9cc4169`, but #1483 has moved since. B1 touches no file the stack edits, so it can sit on that frozen head now.

## What it adds

One new file, `packages/ocapn-noise/test/reconnect-protocol.test.js`. Each test runs under both the CBOR and the Syrup codec:

| Rule | Assertion |
|---|---|
| R1 | Across three reconnects, every transport instance on both sides has its own x25519 ephemeral. The IK transcript hash mixes in both ephemerals, so each epoch gets a new handshake hash and new CipherStates. |
| R3 | A hello naming an epoch the session has already reached is closed with no answer (the SYNACK and greeting are written, the hello is not), and the session stays resumable. |
| R3 | A hello that skips epochs is accepted. B takes A's epoch-1 dial, but B's answer is lost. B then redials at epoch 2, and A takes that dial while still at epoch 0, without ever passing through epoch 1. |
| R4 | A refusal aborts the session well before `SESSION_HARD_TIMEOUT`, and afterwards neither side dials again. |
| R5 | A peer that claims in its hello to have received more frames than were sent aborts the session. This is tested with the dialer lying and with the responder lying. |
| R9 | `op:session-end` ends the session on both sides with no redial. |

## How it injects faults

- The test reads `test/_loss-injector.js` and does not edit it.
- The test defines a **hello-tampering codec wrapper**. It intercepts each `op:session-hello` the network encodes, before encryption, so a real peer can be made to send a stale epoch or an inflated `received`.
- The test defines a **reply dropper**. It loses the hello a responder writes in answer to a dial, then ends that stream.

## Not in this PR

B2 (bounded retention, after #1483 merges), B3 (`sessionId` across epochs, after #1506 and #1481), B4 (daemon turns reconnect on, after #1482 and Open question D), and D1 are left to the parked build job.

## Verification

`yarn test test/reconnect-protocol.test.js` passes all 14 tests, on three runs. `yarn lint:types` is clean. eslint reports no errors; it gives two `safe-await-separator` warnings on the `eventually` and `readBytes` helpers, the same warnings those helpers already get in `reconnect.test.js`.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- END BODY -----
