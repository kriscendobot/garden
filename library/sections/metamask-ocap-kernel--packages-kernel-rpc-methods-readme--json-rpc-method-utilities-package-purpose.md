---
title: "@metamask/kernel-rpc-methods: JSON-RPC method utilities (package purpose)"
source: packages/kernel-rpc-methods/README.md
source_kind: repo
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/kernel-rpc-methods/README.md
source_path: packages/kernel-rpc-methods/README.md
source_commit: d5a703d3f3ebcf5ba7034b51ab4572d4f3355def
source_date: 2025-05-02
source_authors: [Erik Marks]
ingested: 2026-06-27
ingested_by: scholar
topics: [captp, daemon]
genre: sibling-implementation-comparison
status: current
---

> Abstract: `@metamask/kernel-rpc-methods` is described upstream as
> **"Utilities for implementing Ocap Kernel JSON-RPC methods."** Its README is
> a pure boilerplate stub. The reference-relevant fact is the architectural
> one the name implies: ocap-kernel exposes a **JSON-RPC** control surface
> between its host runtimes (browser extension, Node) and the kernel — a
> different boundary technology from Endo's CapTP-over-syrups, and a point of
> contrast worth holding when comparing how each system frames its host/kernel
> control plane.

`@metamask/kernel-rpc-methods` provides "utilities for implementing Ocap
Kernel JSON-RPC methods." The README carries no further detail.

The contrast it surfaces: ocap-kernel's host↔kernel control plane is
**JSON-RPC** (a request/response method protocol), distinct from the
capability-passing CapTP transport that carries object references between
vats. Endo, by comparison, tends to use CapTP for both inter-vat references
and the daemon's control surface. Knowing ocap-kernel splits a plain JSON-RPC
control plane (this package, plus `kernel-rpc` method definitions used by
`KernelServiceManager.ts` and the runtime hosts) from the capability transport
is useful when comparing the two systems' boundary designs.

External-lineage flag: read for reference; not imported.

Source: [packages/kernel-rpc-methods/README.md](https://github.com/MetaMask/ocap-kernel/blob/d5a703d3f3ebcf5ba7034b51ab4572d4f3355def/packages/kernel-rpc-methods/README.md) at commit `d5a703d`.
