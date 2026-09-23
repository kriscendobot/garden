---
title: "Ocap Kernel Guide for Host Application Developers (MetaMask/ocap-kernel) — kernel/vat model, kernel API, vat code, endowments, kernel services, subclusters, eventual send, exos, baggage, revocation"
source: docs/kernel-guide.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/kernel-guide.md
source_branch: main
source_commit: 175b7c0663ce37c2626d33e08134346d4cdd17bf
source_date: 2026-04-23
source_authors: [Dimitris Marlagkoutsos, MetaMask ocap-kernel team]
ingested: 2026-06-27
ingested_by: scholar
topics: [daemon, capability-security, persistence, eventual-send, exo, hardened-javascript]
status: current
kind: index
section_count: 11
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo (same root, different code). Sixth ocap-kernel ingest (job `ingest-ocap-kernel`). See [[ocap-kernel]] concept for the lineage flag and the §ocap-kernel-mini-series.
---

## Abstract

The **Ocap Kernel Guide for Host Application Developers** is MetaMask/ocap-kernel's 689-line operational guide to building services and vats in a host application — the parts of the kernel relevant to registering kernel services, writing vat code, and wiring up system subclusters, without needing the kernel's internals. It is the **canonical statement of ocap-kernel's kernel/vat model** at the developer-facing layer, and the most directly cross-comparable ocap-kernel document for the garden's Endo/SES/Agoric corpus: it walks the kernel API surface, the `buildRootObject(vatPowers, parameters, baggage)` vat contract and its once-only `bootstrap` introduction point, the SES-compartment endowment allowlist (globals + per-vat network host allowlist) that enacts distributed confinement, kernel services as the kernel-context capability bridge, system subclusters and the privileged kernel facet, `E()` eventual-send, exos via `makeDefaultExo` (with `Far()` forbidden), baggage as durable per-vat state (and the home of sturdyref-like persistent references), first-class kernel revocation, and the `ClusterConfig`/`VatConfig`/`SubclusterLaunchResult`/`KernelStatus` type surface.

This source is curated as a **reference-shelf / sibling-implementation entry**: the library reads ocap-kernel's choices to inform Endo work, never imports its code. Each child section carries an honest *Lineage note* flagging where ocap-kernel and Endo solve the same problem differently (shared substrate `@endo/eventual-send` + `@endo/exo`; divergences in the kref/vref/rref/eref four-scope name-space, first-class `kernel.revoke(kref)`, name-registered access-validated kernel services, and `makeDefaultExo` in place of `Far()`).

## Sections

- [Core Concepts](metamask-ocap-kernel--docs-kernel-guide-md--core-concepts.md)
- [The Kernel API](metamask-ocap-kernel--docs-kernel-guide-md--kernel-api.md)
- [Writing Vat Code](metamask-ocap-kernel--docs-kernel-guide-md--writing-vat-code.md)
- [Vat Endowments](metamask-ocap-kernel--docs-kernel-guide-md--vat-endowments.md)
- [Kernel Services](metamask-ocap-kernel--docs-kernel-guide-md--kernel-services.md)
- [System Subclusters](metamask-ocap-kernel--docs-kernel-guide-md--system-subclusters.md)
- [Eventual Send with E()](metamask-ocap-kernel--docs-kernel-guide-md--eventual-send-with-e.md)
- [Exos (Remotable Objects)](metamask-ocap-kernel--docs-kernel-guide-md--exos-remotable-objects.md)
- [Baggage (Persistent State)](metamask-ocap-kernel--docs-kernel-guide-md--baggage-persistent-state.md)
- [Revocation](metamask-ocap-kernel--docs-kernel-guide-md--revocation.md)
- [Key Types and Complete Example](metamask-ocap-kernel--docs-kernel-guide-md--key-types-and-complete-example.md)

## See also

- Source index: [metamask-ocap-kernel--docs-kernel-guide-md](../sources/metamask-ocap-kernel--docs-kernel-guide-md.md)
- Synthesizing concept: [[ocap-kernel]]
- Shared substrate: [[eventual-send]], [[promise-pipelining]]; introduction/hand-off: [[granovetter-operator]], [[four-ways-to-acquire-references]]

Source: [docs/kernel-guide.md](https://github.com/MetaMask/ocap-kernel/blob/175b7c0663ce37c2626d33e08134346d4cdd17bf/docs/kernel-guide.md) at commit `175b7c0`.
