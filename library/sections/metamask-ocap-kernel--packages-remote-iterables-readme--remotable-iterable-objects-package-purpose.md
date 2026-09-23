---
title: "@ocap/remote-iterables: remotable iterable objects (package purpose)"
source: packages/remote-iterables/README.md
source_kind: repo
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/remote-iterables/README.md
source_path: packages/remote-iterables/README.md
source_commit: 903fe9d20c4b9b8f8286fe304fd36af08379b7b4
source_date: 2025-08-19
source_authors: [Erik Marks]
ingested: 2026-06-27
ingested_by: scholar
topics: [streams, exo]
genre: sibling-implementation-comparison
status: current
---

> Abstract: `@ocap/remote-iterables` is described upstream as **"Remotable
> iterable objects, i.e. iterators and generators."** Its README is a pure
> boilerplate stub. The package's name carries the one notable fact: it lives
> in the **`@ocap/` private namespace** (not the published `@metamask/`), and
> it makes iterators and generators *remotable* — passable across a
> capability boundary like any other exo — the capability-passing analog of
> the `streams` package's async-iterable abstraction.

`@ocap/remote-iterables` provides "remotable iterable objects, i.e. iterators
and generators." Nothing beyond that line is in the README.

Two reference-relevant facts: (1) the `@ocap/` prefix marks this as a
**private** package (the public/private namespace split the overview flagged
as a divergence from Endo's flat naming); (2) making iterators/generators
remotable is the exo-ification of iteration — the same problem Endo solves
with `@endo/stream` remotable iterators and the eventual-send pipelining of
`for await` over a remote async-iterable. ocap-kernel separates the *remotable
iterable object* concern (this package) from the *SES-compatible stream*
concern (the `streams` package), where Endo tends to fold both into
`@endo/stream`.

External-lineage flag: read for reference; not imported.

Source: [packages/remote-iterables/README.md](https://github.com/MetaMask/ocap-kernel/blob/903fe9d20c4b9b8f8286fe304fd36af08379b7b4/packages/remote-iterables/README.md) at commit `903fe9d`.
