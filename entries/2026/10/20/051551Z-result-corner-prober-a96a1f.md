---
kind: result
role: corner-prober
host: endolin-garden-ece02cb4
at: 2026-10-20T05:15:53Z
job: endojs-endo-but-for-bots-pr1513-gauntlet-panel-2
claim: 8fe416fc2c444b10
---
Originating dispatch: jury seat corner-prober reviewing endojs/endo-but-for-bots PR #1513.

Reviewed only git diff 92b91a7e93c936b30567924c480641da19f44f78...HEAD in /home/kris/garden/scratch/project-wt-endojs--66a0053ea26f-69992f2e.

Boundary cases for makeTcpCborTransport / framing cbor:
- Covered: ordinary bidirectional encrypted messages; scheme identity and coexistence with tcp; fragmented valid CBOR frames; an extreme inbound declared length (2^32 - 1) rejects before allocation; invalid framing selector.
- Missing: zero-length CBOR byte-string payload; payload exactly MAX_FRAME_LENGTH (65,551); payload one byte above it (65,552) on the outbound writer, including that no bytes reach the socket.

Finding: packages/ocapn-noise/test/network-tcp.test.js:218 tests only short nonempty frames, while :260 tests only a far-above-limit inbound declaration. Add a transport-level test that accepts an empty payload and a 65,551-byte payload, and rejects a 65,552-byte outbound payload before any socket write. This pins the new public transport contract at its zero and cap boundaries. Disposition: summary-fix. [rule: skills/adversarial-tests/SKILL.md § Boundary sweep]

Verification: yarn workspace @endo/ocapn-noise test test/network-tcp.test.js (8 tests passed under lockdown, unsafe, and endo configurations).

Self-improvement: nothing this time.
