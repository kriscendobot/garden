---
source: packages/stream/index.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/stream/index.js
source_path: packages/stream/index.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - streams
  - patterns
  - captp
genre: §endo-source-comment-fragment
cycle: 171
lane: chat
status: current
title: §Why-this-file-exists (the opening comment)
parent: endo--packages-stream-index-js--symmetric-async-iterator-streams-with-makeQueue-makePipe-pump-and-prime-utilities
---

> *`makeQueue`, `makeStream`, and `makePipe` are utilities
> for creating async iterator "streams". A Stream is
> compatible with AsyncIterator and Generator but differ in
> that every method and argument of both is required. For
> example, streams always have `return` and `throw` for
> closing the write side. The `Stream` interface is
> symmetric, but a stream that sends data and receives
> undefined is conventionally a `Writer` whereas a stream
> that receives data and sends undefined is conventionally
> a `Reader`.*

§Compatible-with-AsyncIterator-and-Generator-but-stricter.
§Every-method-and-argument-required. §Standard-iteration-
protocols-have-optional-methods (`return`, `throw` are
optional in vanilla iterators); §streams-require-all-three.

§The-symmetric-stream-interface: §Reader-vs-Writer-by-
convention-not-structure. The same object shape serves both
ends; the §convention names §sends-data-and-receives-
undefined as Writer; §receives-data-and-sends-undefined as
Reader.

§This-symmetry-is-load-bearing: §makePipe creates two
streams from cross-wired queues; either end can be called
Reader or Writer depending on use.
