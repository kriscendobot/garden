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
title: §Endowment — security-as-attenuation
parent: metamask-ocap-kernel--docs-glossary-md--canonical-vocabulary-for-kernel-vat-baggage-exo-and-kref-vref-rref-eref-name-space
---

> *A host/Web API value — `setTimeout`, `Date`, `crypto`,
> `URL`, etc. — that is installed in a vat's SES Compartment
> at initialization. Compartments do not expose these APIs by
> default; vats request them by name via the `globals` field
> in their `VatConfig`. **Many endowments are _attenuated_
> for security or isolation (e.g., per-vat timer queues so
> one vat cannot clear another's timers, monotonically-
> clamped `Date.now()`) — they are callable but deliberately
> differ from host semantics.***

The single most semantically rich entry. §Callable-but-
attenuated stance: the surface looks like the host API; the
*behavior* deliberately differs. §Security-as-attenuation-
not-removal; §preserve-shape-mutate-semantics discipline.

Two named attenuations:

- §Per-vat-timer-queues: prevents §timer-cancellation-as-
  cross-vat-side-channel. Cycle 156's §gc-as-side-channel
  warning has a §timer-as-side-channel sibling here.
- §Monotonically-clamped-Date.now(): prevents §clock-as-
  side-channel; monotonicity rules out §non-determinism-by-
  rewinding-clock and §non-determinism-by-skipping-forward
  (depending on the clamping discipline). §Determinism-by-
  clamping observation; analog of cycle 100's deterministic-
  replay invariants.

§Compartments-expose-nothing-by-default: §explicit-globals-
via-VatConfig. §Capability-shape-discipline-applied-to-host-
endowments — the host APIs are themselves treated as
capabilities to be granted, not as ambient authority.

§Reference-to-other-glossary-entry: links to *Vat Endowments*
in kernel-guide.md (§queued-for-future-cycles doc-2).
