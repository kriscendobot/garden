I opened draft PR [endojs/endo-but-for-bots#1513](https://github.com/endojs/endo-but-for-bots/pull/1513) with the next unbuilt slice of `designs/ocapn-network-transport-separation.md`: the `tcp+cbor` TCP transport. CI is green on the final head (25 pass, 10 skipped).

**Audit against `llm` @ 92b91a7:**

| Migration step | State |
|---|---|
| 1. Single `tcp:url` hint | Draft #1072, not landed |
| 2. `@endo/cbor-frame` + `makeTcpCborTransport` | cbor-frame landed (#288); the transport was unbuilt — **this PR** |
| 3. `addTransport` registers only, explicit `listen` | Draft #1507 |
| 4. `.np` sessions keyed on network + key | #1477; combined `<transport>+<codec>` hint keys, ordered fallback and duplicate-combination rejection are still unbuilt |
| 5–6. Fixture migration, then resuming #684 | Unbuilt; they depend on 3–4 |

**What the PR does:**
- **New transport:** `makeTcpCborTransport()` in `@endo/ocapn-noise/transport/tcp` sends each Noise message as one CBOR byte string. It rejects oversized length claims before allocating memory, with the same 65,551-byte cap as the netstring transport.
- **Coexistence with netstring:** it registers under the scheme `tcp+cbor`, so one network can hold both TCP transports. The two formats are incompatible, and a peer never sends CBOR frames to a netstring port.
- **Interface:** it uses the transport interface on `llm` today, so for now locations carry `tcp+cbor:host` / `tcp+cbor:port` hints. The single `tcp+cbor: host:port` hint from the design comes with steps 3–4.
- **Other files:** README, a changeset, the `@endo/cbor-frame` dependency and a regenerated `tsconfig.composite.json`, with `yarn.lock` in a separate `chore: Update yarn.lock` commit.
- **Out of scope as asked:** it doesn't touch `network.js`, the session-reconnect work, or #1482/#1483/#1487.

**Tests:** four new tests in `test/network-tcp.test.js`:
- an encrypted exchange between two `tcp+cbor` peers;
- a peer with both transports, reached separately by a CBOR-only peer and a netstring-only peer;
- a CBOR-only peer given only netstring hints is refused instead of misdialing;
- raw-socket checks that frames split mid-header or mid-payload reassemble, and that an oversized length is rejected.

Locally, the package's 82 tests pass, `yarn lint` has 0 errors, and the root `tsc -p tsconfig.json` is clean. The first CI lint run failed on Prettier formatting in the test file; I folded the fix into the feature commit and force-pushed.

**Follow-ups:**
- **Bug elsewhere:** in `@endo/stream-node`, when a framing error tears down the socket, `makeNodeWriter` causes an unhandled promise rejection unless the consumer closes the writer. The netstring path has the same problem. OCapN-Noise sessions are unaffected because the network does close the writer. I noted it in the PR body but didn't fix it or post a job for it.
- **Rebase:** if #1507 lands first, this PR needs a rebase onto the new listener API. It should be routine because the CBOR path shares the netstring transport's socket and listener code.
- **Next slice:** step 4's combined hint keys and fallback, once #1507 and #1477 land.

The PR is a draft on frozen base `llm-92b91a7`. The review gauntlet is staged automatically when this job completes.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-but-for-bots-ocapn-network-transport-separation-completion.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (4210346 cached reads)
- Output: 22931 tokens
- Cost: $2.1315852000000004
- Wall-clock: 3321s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
