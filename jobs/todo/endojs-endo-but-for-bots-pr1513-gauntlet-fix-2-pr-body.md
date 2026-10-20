---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Update the PR body of endojs/endo-but-for-bots#1513 (gauntlet fix-2 hand-off)

The gauntlet fix-2 stage for https://github.com/endojs/endo-but-for-bots/pull/1513 could not edit the PR body from host oros-studio-garden-ce242c49 (`updatePullRequest` 403, bot PAT lacks PR write on endojs). Your only task: replace the PR body with the text between the BODY markers below, verbatim, with `gh pr edit 1513 -R endojs/endo-but-for-bots --body-file <file>`. Then confirm with `gh pr view 1513 -R endojs/endo-but-for-bots --json body` that it contains "composes with that direction". Do not change code, push, or post reviews.

The edit reconciles the integrator seat's must-fix (panel record f992354903a3): the "Audit" step-1 bullet now addresses kriskowal's outstanding changes-requested direction on #1072.

----- BODY -----
Refs: `designs/ocapn-network-transport-separation.md` (Migration Plan step 2)

## Description

`@endo/cbor-frame` landed on `llm` in #288, so this adds the `tcp+cbor` wire combination that Migration Plan step 2 calls for. `makeTcpCborTransport()` in `@endo/ocapn-noise/transport/tcp` frames each Noise handshake and ciphertext message as one definite-length (tag-24-wrapped) CBOR byte string. The 65 551-byte frame cap the netstring adapter already uses is enforced on the declared length, before any allocation.

The transport registers under the scheme `tcp+cbor`. The netstring `tcp` transport stays exactly as it is, and the two are not wire compatible. Because the network refuses a second transport with the same scheme and selects outbound hints by scheme prefix, one network can register both. A peer then dials only the listener whose hints match a transport it has, and never sends CBOR frames to a netstring port.

**Audit of the design against `llm` @ 92b91a7:**
- Step 1 (single `tcp:url` hint): open as draft #1072, not landed. kriskowal's changes-requested reviews on #1072 are still outstanding, and they set the target hint form: hints go in the path, not the query string (`endo://<designator>.np/@tcp+cbor:127.0.0.1:3469@wss+cbor:…`); each hint is one `<transport>+<codec>:host:port` word; hints form a priority-ordered list that may hold several hints for one combination (one per link-layer address); and a transport omits a hint rather than advertise localhost. This PR composes with that direction and does not pre-empt it. It adds only the `tcp+cbor` framing, and `tcp+cbor` is the same `<transport>+<codec>` word the reviewed hint form uses. The hint shape, its encoding in the location, and which addresses get advertised all stay as they are on `llm` (`{ host, port }` from the bound address). `tcp+cbor` builds those hints in the same `listen()` code as the netstring transport, so when #1072 is reworked to the ordered `tcp+cbor:host:port` list, both transports change together and nothing in this PR has to be undone.
- Step 2 (`@endo/cbor-frame` + `makeTcpCborTransport`): cbor-frame landed in #288; **this PR adds the transport.**
- Step 3 (`addTransport` registers only, explicit `listen`): open as draft #1507.
- Step 4 (`.np` identity on `(network, designator)`): open as #1477. Composite `<transport>+<codec>` single-hint keys, ordered fallback and duplicate-combination rejection are still unbuilt.
- Steps 5–6: unbuilt. They depend on 3–4.

**Scope and interaction with in-flight work:**
- This PR keeps the transport interface that is on `llm` today (constructor `port`/`host`, `listen(handler)`, hints `{ host, port }`). In the interim aggregation, a location therefore carries `tcp+cbor:host` / `tcp+cbor:port`.
- Under the design's target model, the `scheme`/`codecName` split and the single `tcp+cbor: host:port` hint follow with steps 3–4.
- If #1507 lands first, the rebase is mechanical: `tcp+cbor` shares `wrap()` and the listener code with the netstring adapter.
- It does not touch `network.js`, the session-reconnect work, or #1482, #1483 or #1487.

### Security Considerations

Noise IK still authenticates the peer whatever the carrier. The CBOR frame reader rejects a declared length above the cap before allocating anything, and rejects a malformed head (for example, a missing tag-24 prefix). Both cases close the stream. A test exercises a head that declares 2^32 − 1 bytes.

### Scaling Considerations

None. Framing cost is the same as netstring (one small head per message). Single-chunk frames are not copied.

### Documentation Considerations

The README's transport-plugin list now describes both TCP framings and their schemes. A changeset (`@endo/ocapn-noise` minor) is included.

### Testing Considerations

New tests in `packages/ocapn-noise/test/network-tcp.test.js`:
- A Noise handshake and an encrypted exchange between two `tcp+cbor` peers.
- A dual-registered peer reached by a `tcp+cbor`-only peer and by a netstring-only peer, each over its own listener. A `tcp+cbor`-only peer handed only netstring hints is refused rather than misdialed.
- Raw-socket wire checks: frames split mid-head and mid-payload reassemble to whole messages.
- An oversized declared length is rejected.

Local runs:
- `yarn test` in `packages/ocapn-noise`: 82 passed.
- `yarn lint` there: 0 errors.
- Root `tsc -p tsconfig.json`: clean.

Follow-up observation (pre-existing, not changed here): in `@endo/stream-node`, when a framing reader aborts the socket, `makeNodeWriter`'s `finalIteration` rejects with nobody observing it unless the consumer closes the writer. The netstring path has the same behavior. The OCapN-Noise network does close the writer, so sessions are unaffected.

### Compatibility Considerations

This is additive. The netstring `tcp` transport and its hints are unchanged. `tcp+cbor` is a new wire combination and does not interoperate with netstring peers, which is intended.

### Upgrade Considerations

None.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

<!-- garden-job: build-endo-but-for-bots-ocapn-network-transport-separation-completion -->


----- END BODY -----
