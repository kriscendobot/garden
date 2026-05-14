# Topic: streams

> Abstract: Endo's async-iterator-based stream abstraction. Pull-based, hardenable, and SES-friendly. The streams family includes `@endo/stream` (the core abstraction) and `@endo/stream-node` (Node.js-specific transport bindings). Used as the transport substrate beneath OCapN netlayers and the @endo/ocapn-noise integrity-and-confidentiality layer.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--pkg-stream-readme--overview](../sections/endo--pkg-stream-readme--overview.md) | endo packages/stream/README.md | @endo/stream: pull-based async-iterator stream abstraction for SES code. |
| [endo--pkg-stream-readme--writing-reading](../sections/endo--pkg-stream-readme--writing-reading.md) | endo packages/stream/README.md | The next/return/throw protocol + back-pressure semantics. |
| [endo--pkg-stream-readme--combinators](../sections/endo--pkg-stream-readme--combinators.md) | endo packages/stream/README.md | map/pipe/pump/prime combinators for stream pipelines. |
| [endo--pkg-stream-readme--hardening](../sections/endo--pkg-stream-readme--hardening.md) | endo packages/stream/README.md | How streams interact with SES; what can/cannot be harden()'d. |
| [endo--pkg-stream-node-readme--overview](../sections/endo--pkg-stream-node-readme--overview.md) | endo packages/stream-node/README.md | Node.js transport bindings (tiny pointer). |

## See also

- [`ocapn`](ocapn.md): streams are the transport beneath OCapN netlayers.
- [`hardened-javascript`](hardened-javascript.md): hardening rules apply to streams.
- [`tooling`](tooling.md): broader developer-facing tooling.
