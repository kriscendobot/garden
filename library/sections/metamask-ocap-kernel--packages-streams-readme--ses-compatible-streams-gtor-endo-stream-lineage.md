---
title: "streams: SES-compatible streams in the gtor and @endo/stream lineage"
source: packages/streams/README.md
source_kind: repo
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/streams/README.md
source_path: packages/streams/README.md
source_commit: d5a703d3f3ebcf5ba7034b51ab4572d4f3355def
source_date: 2025-05-02
source_authors: [Erik Marks]
ingested: 2026-06-27
ingested_by: scholar
topics: [streams, hardened-javascript]
genre: sibling-implementation-comparison
status: current
---

> Abstract: the `streams` package (published `@metamask/streams`) is described
> upstream as **"SES-compatible streams, in the lineage of
> [gtor](https://github.com/kriskowal/gtor) and `@endo/stream`."** The README
> is otherwise a boilerplate stub, but that one lineage sentence is a
> high-value cross-comparable fact: ocap-kernel's stream abstraction descends
> from the *same* two ancestors as Endo's own `@endo/stream` — Kris Kowal's
> *General Theory of Reactivity* (gtor) and the Endo stream package itself.
> The package's `BaseDuplexStream.ts` is the queued comment-fragment ingest
> target named in the cycle-161 plan.

The full README description: "SES-compatible streams, in the lineage of gtor
and `@endo/stream`." The package's npm name is `@metamask/streams`.

This is the single most reference-relevant package-README fact in the cluster.
The garden's own streaming work (the `@endo/stream` `Stream` type, the
daemon-message-streaming design, the channel/stream distinction the
ocap-kernel glossary draws) shares ancestry with this package: **gtor** (the
async-iterator / promise-pipe reactivity model) and **`@endo/stream`** (the
Endo enactment). ocap-kernel did not import `@endo/stream` wholesale; it
re-implemented in the same lineage, adding `BaseDuplexStream.ts` (a duplex
stream base class with no `@endo/stream` analog). That re-implementation is
itself a sibling-implementation data point — where ocap-kernel kept the
lineage but diverged in shape.

The overview's glossary ingest already recorded ocap-kernel's
**channel-vs-stream distinction** (a channel is the lower-level transport; a
stream is the higher-level async-iterable). This README confirms the stream
side's pedigree.

External-lineage flag: read for reference. `BaseDuplexStream.ts` belongs in
the comment-fragment follow-on, not as a README source.

Source: [packages/streams/README.md](https://github.com/MetaMask/ocap-kernel/blob/d5a703d3f3ebcf5ba7034b51ab4572d4f3355def/packages/streams/README.md) at commit `d5a703d`.
