---
source: docs/architecture/network-isolation.md
source_repo: opensandbox-group/OpenSandbox
source_commit: 08f6a6598045cfd6742f2d09304bb4ddb6f8d171
source_date: 2026-07-16
source_authors: [ruirui6946]
ingested: 2026-08-14
ingested_by: scholar
section_count: 3
status: current
---

> Abstract: OpenSandbox treats every Kubernetes sandbox as a security domain that must not reach another sandbox by Pod IP. Because label-based Kubernetes NetworkPolicy does not naturally track this dynamic per-sandbox boundary, OpenSandbox recommends a platform-owned egress sidecar with non-overridable deny overlays for cluster CIDRs and forces legitimate access through authenticated ingress endpoints. The mechanism is policy confinement at the network boundary, not Endo-style authority confinement inside the program's object graph.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [cross-sandbox-threat-model](../sections/opensandbox--docs-architecture-network-isolation--cross-sandbox-threat-model.md) | sandbox-platforms, networking | current |
| [platform-enforced-egress-confinement](../sections/opensandbox--docs-architecture-network-isolation--platform-enforced-egress-confinement.md) | sandbox-platforms, networking, capability-security | current |
| [compatibility-and-residual-trust](../sections/opensandbox--docs-architecture-network-isolation--compatibility-and-residual-trust.md) | sandbox-platforms, networking | current |

## Provenance

Source: [docs/architecture/network-isolation.md](https://github.com/opensandbox-group/OpenSandbox/blob/08f6a6598045cfd6742f2d09304bb4ddb6f8d171/docs/architecture/network-isolation.md) at file-specific commit `08f6a659`.
