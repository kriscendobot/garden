---
source: docs/architecture/index.md
source_repo: opensandbox-group/OpenSandbox
source_commit: 02617e27f82409a0293012fe4c9acc2f6a67e262
source_date: 2026-08-14
source_authors: [lihaopeng]
ingested: 2026-08-14
ingested_by: scholar
section_count: 3
status: current
---

> Abstract: OpenSandbox's architectural map: language-specific clients call a protocol-first lifecycle control plane, which creates Docker containers or Kubernetes workloads and reaches an injected `execd` data plane for command, file, PTY, and code-interpreter operations. Isolation is layered rather than singular: container or pod boundaries, optional gVisor/Kata secure runtimes, an egress sidecar, ingress credentials, and nested bubblewrap sessions each cover different threats. The platform is a coarse, operating-system-level complement to Endo, not a replacement for SES's in-process JavaScript confinement or Endo's object-capability authority model.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [control-plane-data-plane-and-execution-boundary](../sections/opensandbox--docs-architecture-index--control-plane-data-plane-and-execution-boundary.md) | sandbox-platforms, networking | current |
| [layered-isolation-and-trust-boundaries](../sections/opensandbox--docs-architecture-index--layered-isolation-and-trust-boundaries.md) | sandbox-platforms, capability-security | current |
| [comparison-with-endo-ses-and-xsnap](../sections/opensandbox--docs-architecture-index--comparison-with-endo-ses-and-xsnap.md) | sandbox-platforms, hardened-javascript, compartments, capability-security | current |

## Provenance

Source: [docs/architecture/index.md](https://github.com/opensandbox-group/OpenSandbox/blob/02617e27f82409a0293012fe4c9acc2f6a67e262/docs/architecture/index.md) at file-specific commit `02617e27`.
