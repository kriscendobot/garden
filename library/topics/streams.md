# Topic: streams

> Abstract: Endo's async-iterator-based stream abstraction. Pull-based, hardenable, and SES-friendly. The streams family includes `@endo/stream` (the core abstraction) and `@endo/stream-node` (Node.js-specific transport bindings). Used as the transport substrate beneath OCapN netlayers and the @endo/ocapn-noise integrity-and-confidentiality layer.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--pkg-stream-node-readme--overview](../sections/endo--pkg-stream-node-readme--overview.md) | endo packages/stream-node/README.md | Node.js-specific transport bindings for @endo/stream. |
| [endo--pkg-stream-readme--combinators](../sections/endo--pkg-stream-readme--combinators.md) | endo packages/stream/README.md | Four stream combinators consolidated: map (transform each value), pipe (connect input to output), pump (push values through), prime (initialize a stream with a value). |
| [endo--pkg-stream-readme--hardening](../sections/endo--pkg-stream-readme--hardening.md) | endo packages/stream/README.md | How @endo/stream interacts with SES: streams are themselves harden()'d, and the combinators preserve hardening across transforms. |
| [endo--pkg-stream-readme--overview](../sections/endo--pkg-stream-readme--overview.md) | endo packages/stream/README.md | @endo/stream defines an async-iterator-based stream abstraction with deliberate hardening properties. |
| [endo--pkg-stream-readme--writing-reading](../sections/endo--pkg-stream-readme--writing-reading.md) | endo packages/stream/README.md | How to create a stream from a writable side and how to consume it from a readable side. |

## See also

- [`ocapn`](ocapn.md): streams are the transport beneath OCapN netlayers.
- [`hardened-javascript`](hardened-javascript.md): hardening rules apply to streams.
- [`tooling`](tooling.md): broader developer-facing tooling.
