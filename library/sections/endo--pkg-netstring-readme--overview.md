---
title: netstring (overview)
source: packages/netstring/README.md
source_repo: endojs/endo
source_commit: 08cca1f0
source_date: 2021-04-26
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [ocapn, tooling]
status: current
---

> Abstract: Netstring is a simple length-prefixed framing format: `<decimal-length>:<byte-sequence>,`. `@endo/netstring` exposes `makeNetstringReader(input, {name?, maxMessageLength?})` and `makeNetstringWriter(output, {chunked?})` as the encoder/decoder pair; both implement `@endo/stream`'s typed `Reader<Uint8Array, undefined, undefined>` / `Writer<Uint8Array, undefined, undefined>` shape (`next` / `return` / `throw` plus `[Symbol.asyncIterator]`) with **`Uint8Array` at every boundary** — never strings, the decimal length prefix is the only stringly-typed surface. Yielded chunks may be ranges of a ring buffer the stream owns until the next `next()` call. Used as the framing layer beneath OCapN; referenced by the upstream protocol's Netlayers spec.

# netstring

This is an implementation of asynchronous streams framed as [Netstrings][].
A netstring is a binary protocol for length-prefixed frames,
using decimal strings as variable width integers.
For example, the frame `5:hello,` corresponds to the message `hello`,
where `5` is the length of `hello` in bytes.

This implementation relies particularly on the pure JavaScript notion of a
stream, using async iterators of Uint8Arrays.
By convention, these may be ranges of a ring buffer, so a stream owns a byte
range it receives from `next` until the next time it calls `next`.


[Netstrings][] <br>
D. J. Bernstein, <djb@pobox.com> <br>
1997-02-01

[Netstrings]: https://cr.yp.to/proto/netstrings.txt

Source: [packages/netstring/README.md](https://github.com/endojs/endo/blob/08cca1f0/packages/netstring/README.md) at commit `08cca1f0`.
