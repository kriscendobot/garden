---
source: docs/glossary.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/glossary.md
source_path: docs/glossary.md
source_commit: a3eff0efb70ba5f4c5919290aa295fe32138df4f
section_kind: doc
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - captp
  - capability-security
genre: §sibling-implementation-comparison
cycle: 163
lane: comments
status: current
title: §Exo — the canonical remotable
parent: metamask-ocap-kernel--docs-glossary-md--canonical-vocabulary-for-kernel-vat-baggage-exo-and-kref-vref-rref-eref-name-space
---

> *A remotable object created with `makeDefaultExo()` from
> `@metamask/kernel-utils/exo`. Exos are the standard way to
> create objects that can be passed between vats, stored in
> baggage, and invoked via `E()`. Do not use `Far()` from
> `@endo/far`.*

§Forbid-direct-Far concretized: the glossary itself is
prescriptive — *Do not use Far() from @endo/far*. §Wrap-not-
bypass discipline. §Makedefaultexo-is-the-only-blessed-
remotable-constructor (cycle 161 surfaced this from
AGENTS.md; the glossary confirms it as canonical, not just a
contributor-norm).

§Why-wrap-not-import: §exo-internalizes-kernel-utils-
conventions (durable-by-default, baggage-aware, error-
message-discipline). §wrap-gives-a-place-to-attach-future-
discipline; §wrap-gives-a-bottleneck-for-audit.
