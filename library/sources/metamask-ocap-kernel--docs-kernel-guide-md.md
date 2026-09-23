---
source: docs/kernel-guide.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/kernel-guide.md
source_branch: main
source_commit: 175b7c0663ce37c2626d33e08134346d4cdd17bf
source_date: 2026-04-23
source_authors: [Dimitris Marlagkoutsos, MetaMask ocap-kernel team]
ingested: 2026-06-27
ingested_by: scholar
section_count: 11
status: current
notes: |
  **Sixth ocap-kernel ingest** (job `ingest-ocap-kernel`, 2026-06-27),
  extending the cycle-161–165 §ocap-kernel-mini-series. This is the
  §queued-doc *kernel-guide.md* from the cycle-161 overview's plan — the
  689-line **host-application developer guide** and the most direct source
  for the kernel/vat model the ingest job asked to curate (kernel API,
  vat code, endowments, kernel services, system subclusters, eventual
  send, exos, baggage, revocation, key types).

  External sibling implementation: MetaMask/ocap-kernel is a
  SwingSet-lineage object-capability kernel **distinct from @endo** (same
  root, different code). Every section carries an honest *Lineage note*
  flagging where ocap-kernel and Endo solve the same problem differently:
  - **Shared substrate**: `E()` is imported directly from
    `@endo/eventual-send`; exos wrap `@endo/exo`'s `makeExo`.
  - **Divergences**: kref/vref/rref/eref four-scope name-space vs Endo's
    single formula identifier; revocation as a first-class kernel verb
    (`kernel.revoke(kref)`) vs Endo's compositional caretaker/membrane;
    kernel services registered by name + access-validated at subcluster
    launch vs Endo's powers handed through the formula graph; `Far()`
    forbidden in favor of `makeDefaultExo`.

  Cross-links to the six-sections ocap material (job
  `ingest-ocap-library-sections`): **distributed confinement** (vat
  endowments + globals/network allowlist), **three-party hand-off /
  introduction** (bootstrap receiving `vats`/`services`; see
  [[granovetter-operator]], [[four-ways-to-acquire-references]]),
  **eventual send** ([[eventual-send]], [[promise-pipelining]]),
  **sturdyrefs** (baggage-stored cross-vat references as durable
  capabilities). Synthesizing concept page: [[ocap-kernel]].
---

## Abstract

The **Ocap Kernel Guide for Host Application Developers** is MetaMask/ocap-kernel's 689-line operational guide to building services and vats in a host application — the parts of the kernel relevant to registering kernel services, writing vat code, and wiring up system subclusters, without needing the kernel's internals. It is the **canonical statement of ocap-kernel's kernel/vat model** at the developer-facing layer, and the most directly cross-comparable ocap-kernel document for the garden's Endo/SES/Agoric corpus: it walks the kernel API surface, the `buildRootObject(vatPowers, parameters, baggage)` vat contract and its once-only `bootstrap` introduction point, the SES-compartment endowment allowlist (globals + per-vat network host allowlist) that enacts distributed confinement, kernel services as the kernel-context capability bridge, system subclusters and the privileged kernel facet, `E()` eventual-send, exos via `makeDefaultExo` (with `Far()` forbidden), baggage as durable per-vat state (and the home of sturdyref-like persistent references), first-class kernel revocation, and the `ClusterConfig`/`VatConfig`/`SubclusterLaunchResult`/`KernelStatus` type surface.

This source is ingested as a **reference-shelf / sibling-implementation entry**: the library reads ocap-kernel's choices to inform Endo work, never imports its code.

## Sections

| Section | Topics | Status |
|---|---|---|
| [core-concepts](../sections/metamask-ocap-kernel--docs-kernel-guide-md--core-concepts.md) | daemon, capability-security, persistence | current |
| [kernel-api](../sections/metamask-ocap-kernel--docs-kernel-guide-md--kernel-api.md) | daemon | current |
| [writing-vat-code](../sections/metamask-ocap-kernel--docs-kernel-guide-md--writing-vat-code.md) | daemon, persistence | current |
| [vat-endowments](../sections/metamask-ocap-kernel--docs-kernel-guide-md--vat-endowments.md) | hardened-javascript, capability-security | current |
| [kernel-services](../sections/metamask-ocap-kernel--docs-kernel-guide-md--kernel-services.md) | daemon, capability-security | current |
| [system-subclusters](../sections/metamask-ocap-kernel--docs-kernel-guide-md--system-subclusters.md) | daemon, capability-security | current |
| [eventual-send-with-e](../sections/metamask-ocap-kernel--docs-kernel-guide-md--eventual-send-with-e.md) | eventual-send | current |
| [exos-remotable-objects](../sections/metamask-ocap-kernel--docs-kernel-guide-md--exos-remotable-objects.md) | exo, capability-security | current |
| [baggage-persistent-state](../sections/metamask-ocap-kernel--docs-kernel-guide-md--baggage-persistent-state.md) | persistence, capability-security | current |
| [revocation](../sections/metamask-ocap-kernel--docs-kernel-guide-md--revocation.md) | capability-security | current |
| [key-types-and-complete-example](../sections/metamask-ocap-kernel--docs-kernel-guide-md--key-types-and-complete-example.md) | daemon, persistence | current |

Source: [docs/kernel-guide.md](https://github.com/MetaMask/ocap-kernel/blob/175b7c0663ce37c2626d33e08134346d4cdd17bf/docs/kernel-guide.md) at commit `175b7c0`.
