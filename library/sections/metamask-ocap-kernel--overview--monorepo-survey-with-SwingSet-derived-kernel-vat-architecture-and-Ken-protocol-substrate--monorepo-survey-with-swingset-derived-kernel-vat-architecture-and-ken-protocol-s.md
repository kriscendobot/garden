---
section: monorepo-survey-with-SwingSet-derived-kernel-vat-architecture-and-Ken-protocol-substrate
source: metamask-ocap-kernel--overview
topics: [daemon, captp, persistence]
status: current
title: Monorepo survey with SwingSet-derived kernel/vat architecture and Ken-protocol substrate
parent: metamask-ocap-kernel--overview--monorepo-survey-with-SwingSet-derived-kernel-vat-architecture-and-Ken-protocol-substrate
---

> *The OCAP Kernel is a powerful object capability-based system
> that enables secure, isolated execution of JavaScript code
> in vats (similar to secure sandboxes).*
>
> — `docs/usage.md` opening

`MetaMask/ocap-kernel` is a TypeScript monorepo implementing
an object-capability kernel-and-vat architecture derived from
the same Agoric SwingSet lineage as `@endo` and the garden's
slot-machine work in `endojs/endo-but-for-bots`. This source
is **ingested as a reference shelf entry**: the library will
draw on it for comparison, contrast, and synthesis of
requirements where ocap-kernel's choices differ from ours.
