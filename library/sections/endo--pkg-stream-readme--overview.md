---
title: Endo Streams (overview)
source: packages/stream/README.md
source_repo: endojs/endo
source_commit: 1aafa86e
source_date: 2022-01-21
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [streams]
status: current
---

> Abstract: @endo/stream defines an async-iterator-based stream abstraction with deliberate hardening properties. Streams are pull-based; consumer requests values one at a time. Designed for use under SES where mutable state and ambient authority must be avoided.

# Endo Streams

Endo models streams as hardened async iterators.
Async iterators are sufficient to model back-pressure or pacing
since they are channel messages both from producer to consumer
and consumer to producer.
Streams are therefore symmetric.
The same stream type serves for both a reader and a writer.

These streams depend on full Endo environment initialization, as with `@endo/init`
to ensure that they are run in Hardened JavaScript with remote promise support
(eventual send).


Source: [packages/stream/README.md](https://github.com/endojs/endo/blob/1aafa86e/packages/stream/README.md) at commit `1aafa86e`.
