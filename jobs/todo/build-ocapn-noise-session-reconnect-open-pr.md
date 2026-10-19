---
role: builder
tier: mentor
fallback-tier: minion
requires: host=endolin-garden-ece02cb4
dispatch: automatic
---
# Open the DRAFT PR for OCapN session-reconnect Phase 1 (endojs/endo-but-for-bots)

Handoff from job `build-ocapn-noise-session-reconnect`. Its claimant
(host oros-studio-garden-ce242c49) finished and pushed the work, but that
host's bot PAT gets a 403 on `createPullRequest` for endojs. This job only
opens the PR.

- Head branch: `llm-ocapn-session-heartbeat` (commit `e8e42fbea`), already pushed.
- Base: the frozen `llm-330cf99` (the `llm` tip at build time), already pushed.
- Do NOT rebuild or edit code. Get a project checkout with
  `ensure-project-worktree.sh build-ocapn-noise-session-reconnect-open-pr endojs/endo-but-for-bots llm-ocapn-session-heartbeat`,
  cd into it (the phase-evidence gate resolves `designs/*.md` from cwd), save
  the PR body below to a file, and run:

      ensure-pr.sh build-ocapn-noise-session-reconnect-open-pr endojs/endo-but-for-bots llm-ocapn-session-heartbeat llm-330cf99 --draft \
        --title "feat(ocapn): op:ping / op:pong session-liveness heartbeat (session-reconnect Phase 1)" \
        --body-file <file>

  First run it with `--find-only` in case a peer already opened the PR.
- Leave the PR as a DRAFT. Successful completion stages the normal gauntlet.

## PR body (verbatim between the markers)

----- PR BODY -----
Refs: `designs/ocapn-noise-session-reconnect.md` (Phase 1)

## Description

Implements **Phase 1** of the OCapN-Noise session-reconnect design: `op:ping` and `op:pong` on the wire in every codec, plus a heartbeat that detects a silent peer within seconds instead of TCP's hours.

- **Wire format** (`packages/ocapn/src/codecs/operations.js`): `<op:ping epoch sequence>` and `<op:pong epoch sequence last-acked-recv-nonce>` join the OCapN operation union. Their fields use a new `Uint64Codec` (`subtypes.js`), and one record definition serves both syrup and CBOR.
- **Heartbeat** (`packages/ocapn/src/client/heartbeat.js`, the file most worth reviewing): sends a ping and a pong every interval (5 s by default, allowed range 1 s to 60 s). Any incoming operation restarts a sliding session timeout (30 s by default, at least 3 × the interval). When the timeout lapses, the session is declared lost. Stale-epoch heartbeats are dropped and do not count as liveness. The peer's pong acknowledgment only moves forward. The `timer` can be injected.
- **Wiring** (`makeOcapn({ heartbeat })`, `client/ocapn.js`): `true` uses the defaults; an object tunes them. A lapsed timeout aborts the session (pending answers reject, and the session is dropped so the next `provideSession` reconnects). Every session absorbs incoming `op:ping` / `op:pong` whether or not it runs a heartbeat.

Choices made against the design:
- The heartbeat sits in the CapTP client rather than in `packages/ocapn-noise`. Phase 1 needs no CipherState, and this placement covers every network, including the tcp-test-only one the design names for Phase 1. Reconnect, resume, and crossed hellos (Phases 3–5) still belong in the network.
- `last_acked_recv_nonce` reports `0` until the network exposes its receive nonce (Phase 4, whose RESUME handshake is the field's only consumer).
- The epoch stays at `0` because a session has exactly one transport instance until reconnect lands.

The design's status is now *In Progress (Phase 1 implemented)*. Phases 2–5 and the CapTP replay-dedup requirements are left for follow-up PRs.

### Security Considerations

This change grants no new authority. The heartbeat runs inside the already-authenticated session. Over Noise, it is encrypted like any other operation. Liveness loss uses the existing `abort` path. Under SES, a compartment without ambient timers must pass `heartbeat.timer` explicitly; `makeHeartbeat` throws rather than silently falling back.

### Scaling Considerations

An enabled session sends two small operations per interval (by default about 0.4 messages/s per session) and holds two timers, both `unref`'d so they don't keep Node alive. The feature is off by default, so there is no cost unless enabled.

### Documentation Considerations

The `heartbeat` option is documented in `makeOcapn`'s JSDoc and in the changeset. The two operations are tentative OCapN extensions pending OCapN spec-group consensus (see the design's open questions T1/T2 on default timings).

### Testing Considerations

`test/heartbeat.test.js` covers:
- option ranges, emit cadence, loss at exactly the timeout, liveness reset, monotonic ack, survival after a send failure;
- a TCP integration test where, with mutual heartbeats, a session stays up through 2 minutes of idle time and still answers a call;
- a TCP integration test where a peer without the extension absorbs the heartbeats, and the heartbeating side tears down 30 s after the peer goes quiet.

`test/codecs/operations.test.js` round-trips both ops in syrup and CBOR, including the uint64 maximum. The full `@endo/ocapn` suite passes under all three ses-ava configs (572 each), `@endo/ocapn-noise` passes (78 × 3), and `yarn lint` is clean.

Reviewer note: in this environment, ava running under SES writes `.snap` files whose `data` is a CBOR map rather than a byte string, and then can't read them back. The committed `.snap` was re-encoded with byte-string `data`, the format of the existing file. The `.md` snapshot diff is additions only.

### Compatibility Considerations

Nothing breaks for existing callers. The heartbeat is opt-in, so peers that predate the extension (Goblins, older Endo) never receive an operation they cannot decode. Endo peers on this version accept heartbeats from a peer that sends them.

### Upgrade Considerations

None. There is no persisted state, and the feature is opt-in. A `minor` changeset is included for `@endo/ocapn`.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- END PR BODY -----
