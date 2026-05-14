# Topic: streams

> Abstract: Endo's async-iterator-based stream abstraction. Pull-based, hardenable, and SES-friendly. The streams family includes `@endo/stream` (the core abstraction) and `@endo/stream-node` (Node.js-specific transport bindings). Used as the transport substrate beneath OCapN netlayers and the @endo/ocapn-noise integrity-and-confidentiality layer.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo-but-for-bots--llm-designs-cbors--design-scope-and-api](../sections/endo-but-for-bots--llm-designs-cbors--design-scope-and-api.md) | endo-but-for-bots designs/cbors.md | **Scope**: byte-string framing only, just enough of RFC 8949 to read/write CBOR major-type-2 heads (optionally wrapped in tag 24, major type 6 argument 24). |
| [endo-but-for-bots--llm-designs-cbors--overview-and-naming](../sections/endo-but-for-bots--llm-designs-cbors--overview-and-naming.md) | endo-but-for-bots designs/cbors.md | **Problem**: the Endo daemon's bus protocol uses a hand-rolled length envelope; a second consumer (Rust endor daemon, XS worker snapshot pipeline) is coming. |
| [endo-but-for-bots--llm-designs-cbors--reader-writer-behavior](../sections/endo-but-for-bots--llm-designs-cbors--reader-writer-behavior.md) | endo-but-for-bots designs/cbors.md | **Reader**: a small state machine reading `Uint8Array` chunks. |
| [endo-but-for-bots--llm-designs-cbors--relationship-and-design-decisions](../sections/endo-but-for-bots--llm-designs-cbors--relationship-and-design-decisions.md) | endo-but-for-bots designs/cbors.md | **Relationship**: three peer framing packages — `@endo/netstring` (`<digits>:<bytes>,`), `@endo/syrup-frame` (proposed; `<digits>:<bytes>`; will be renamed `@endo/syrups`), `@endo/cbors` (this design; CBOR byte-string head ± tag 24). |
| [endo-but-for-bots--llm-designs-cbors--wire-format](../sections/endo-but-for-bots--llm-designs-cbors--wire-format.md) | endo-but-for-bots designs/cbors.md | The wire is a concatenation of length-prefixed CBOR byte strings, each one of: **(1) plain byte-string head + payload** — major type 2 with argument = payload length (CBOR's short forms: 0-23 inline; 24/25/26/27 followed by 1/2/4/8 length bytes), followed by payload bytes; **(2) tag-24-wrapped byte string** — major type 6 with argument 24 (Encoded CBOR data item) followed by a plain byte string as in (1). |
| [endo-but-for-bots--llm-designs-ocapn-noise-network--concrete-transports-and-network-impl](../sections/endo-but-for-bots--llm-designs-ocapn-noise-network--concrete-transports-and-network-impl.md) | endo-but-for-bots designs/ocapn-noise-network.md | **WebSocket transport** (`ocapn-noise-websocket`): browser-compatible WebSocket API; Noise handshake bytes are binary WebSocket messages; each encrypted OCapN message is one WebSocket binary frame; **no additional framing** because WebSocket provides message boundaries. |
| [endo-but-for-bots--llm-designs-ocapn-noise-network--transport-plugins-and-hints](../sections/endo-but-for-bots--llm-designs-ocapn-noise-network--transport-plugins-and-hints.md) | endo-but-for-bots designs/ocapn-noise-network.md | **Transport plugin interface** (`OcapnNoiseTransport`): `scheme` (e.g., |
| [endo-but-for-bots--llm-designs-syrups--overview](../sections/endo-but-for-bots--llm-designs-syrups--overview.md) | endo-but-for-bots designs/syrups.md | This design records a correction. |
| [endo--pkg-stream-node-readme--overview](../sections/endo--pkg-stream-node-readme--overview.md) | endo packages/stream-node/README.md | Node.js-specific transport bindings for @endo/stream. |
| [endo--pkg-stream-readme--combinators](../sections/endo--pkg-stream-readme--combinators.md) | endo packages/stream/README.md | Four stream combinators consolidated: map (transform each value), pipe (connect input to output), pump (push values through), prime (initialize a stream with a value). |
| [endo--pkg-stream-readme--hardening](../sections/endo--pkg-stream-readme--hardening.md) | endo packages/stream/README.md | How @endo/stream interacts with SES: streams are themselves harden()'d, and the combinators preserve hardening across transforms. |
| [endo--pkg-stream-readme--overview](../sections/endo--pkg-stream-readme--overview.md) | endo packages/stream/README.md | @endo/stream defines an async-iterator-based stream abstraction with deliberate hardening properties. |
| [endo--pkg-stream-readme--writing-reading](../sections/endo--pkg-stream-readme--writing-reading.md) | endo packages/stream/README.md | How to create a stream from a writable side and how to consume it from a readable side. |

## See also

- [`ocapn`](ocapn.md): streams are the transport beneath OCapN netlayers.
- [`hardened-javascript`](hardened-javascript.md): hardening rules apply to streams.
- [`tooling`](tooling.md): broader developer-facing tooling.
