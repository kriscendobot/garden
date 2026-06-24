---
title: What HardenedJS adds to standard Javascript
source: docs/guide.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript]
status: current
notes: Overlaps with endo--docs-reference--removed-by-hardened-js and endo--docs-reference--added-changed-by-hardened-js. Guide-shaped vs reference-shaped; kept both.
parent: endo--docs-guide--what-lockdown-does-removes-adds
---

The following anticipate additional proposed standard-track features. If they become standards,
future JavaScript environments will include them as global objects. So the current Agoric SES shim
makes those global objects available.

- `console` is available for debugging. While not in the official spec, since all implementations
  add it, leaving it out would cause confusion. Note that `console.log`’s exact
  behavior is up to the host program; display to the operator is not guaranteed. Use the
  console for debug information only. The console is not obliged to write to the POSIX standard output.

- `assert` is also a debugging tool that allows programs to express assertions
  and defer the construction of error objects and computed messages until an
  assertion fails.

- `repairIntrinsics` adds, removes, and replaces various properties of the
  global environment and shared intrinsics.
  Introduces `hardenIntrinsics`.

- `hardenIntrinsics` freezes the transitive own properties and prototypes of
  the shared intrinsics.
  Introduces `harden`.

- [`harden()`](#harden) provides a shorthand for reliably freezing the
  transitive properties and prototypes of other objects, such that the API
  surface of these objects are tamper-proof when shared between otherwise
  isolated programs.

- [`lockdown()`](#lockdown) is a shorthand for `repairIntrinsics` and `hardenIntrinsics`.

- [`Compartment`](https://github.com/endojs/endo/tree/SES-v0.8.0/packages/ses#compartment)
  Code runs inside a `Compartment` and can create sub-compartments to host
  other code (with different globals or code transforms).
  The globals in a child compartment include the shared intrinsics including
  `harden` and a batch of evaluators that run programs that will also be
  confined to the compartment including `eval`, `Function`, and `Compartment`
  itself.
  Compartments can be created with support for loading modules.
  Comaprtments constructed after `repairIntrinsics()` and `hardenIntrinsics()`
  also confine the evaluation of modules.

Source: [docs/guide.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/guide.md) at commit `fe81477b`.
