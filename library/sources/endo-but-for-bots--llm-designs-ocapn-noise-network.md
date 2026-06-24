---
source: designs/ocapn-noise-network.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-28
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
section_count: 5
status: current
notes: Sibling to ocapn-network-transport-separation.md (same commit) — depends on that design's OcapnNetwork interface. The Noise handshake **replaces** op:start-session entirely; mutual auth, key agreement, encryption, encoding negotiation all roll into the SYN/SYNACK/ACK sequence (164/193/64 bytes). This is the driver design for why op:start-session can't be mandated by OCapN core.
---

> Abstract: Design for the OCapN-Noise **network** layer (designator `"np"`) atop the existing `@endo/ocapn-noise` cryptographic bindings. Today `@endo/ocapn-noise` provides Noise Protocol primitives (`asInitiator`, `asResponder`, encrypt/decrypt) but no OCapN network. The design adds: (1) a `OcapnNetwork` implementation registered as `np`; (2) a transport-plugin architecture (WebSocket + TCP-with-netstring); (3) connection-hint format with scheme prefixes (`ws:host`, `tcp:port`); (4) a network implementation that wires up signing keys + transports + listeners; (5) session establishment that replaces op:start-session with the Noise XX handshake (SYN 164b + SYNACK 193b + ACK 64b), delivering encrypt/decrypt + mutual auth + encoding negotiation; (6) package structure (`ocapn-noise-network` + `ocapn-noise-ws` + `ocapn-noise-tcp`). Depends on ocapn-network-transport-separation + ocapn-tcp-for-test-extraction.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview-and-identifier](../sections/endo-but-for-bots--llm-designs-ocapn-noise-network--overview-and-identifier.md) | ocapn, captp | current |
| [transport-plugins-and-hints](../sections/endo-but-for-bots--llm-designs-ocapn-noise-network--transport-plugins-and-hints.md) | ocapn, streams | current |
| [concrete-transports-and-network-impl](../sections/endo-but-for-bots--llm-designs-ocapn-noise-network--concrete-transports-and-network-impl.md) | ocapn, streams | current |
| [session-establishment](../sections/endo-but-for-bots--llm-designs-ocapn-noise-network--session-establishment.md) | ocapn, captp, capability-security | current |
| [package-structure-and-security](../sections/endo-but-for-bots--llm-designs-ocapn-noise-network--package-structure-and-security.md) | ocapn, repository-governance | current |

## Cross-references

- Depends on: `endo-but-for-bots--llm-designs-ntsep--*` (the OcapnNetwork interface).
- The Noise primitives this builds atop: `endo--pkg-ocapn-noise-readme--*`.
- The TCP transport's netstring framing: `endo--pkg-netstring-readme--*`.
- The handshake being replaced: `ocapn--implementation-guide--stage-0-foundation` (op:start-session).

## Source

[designs/ocapn-noise-network.md](https://github.com/endojs/endo-but-for-bots/blob/0ee0cbb3c7639985c971c30c2fb6f32e1944d55b/designs/ocapn-noise-network.md) at commit `0ee0cbb3` on branch `llm`.
