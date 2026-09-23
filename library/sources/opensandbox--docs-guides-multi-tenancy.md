---
source: docs/guides/multi-tenancy.md
source_repo: opensandbox-group/OpenSandbox
source_commit: 138ce5cb3bac6f3bb9dfcce3f72382b372c4cdd5
source_date: 2026-08-14
source_authors: [epha]
ingested: 2026-08-14
ingested_by: scholar
section_count: 3
status: current
---

> Abstract: OpenSandbox multi-tenancy maps API keys to pre-created Kubernetes namespaces and injects the resolved namespace into request-scoped server context. File and HTTP providers have different validation and availability properties. Namespace quotas, network controls, and RBAC remain Kubernetes responsibilities, while the server retains cross-namespace ClusterRole authority and pool APIs remain shared, so tenant naming and authentication do not by themselves produce object-capability confinement.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [tenant-identity-and-request-scoped-namespace-routing](../sections/opensandbox--docs-guides-multi-tenancy--tenant-identity-and-request-scoped-namespace-routing.md) | sandbox-platforms, multi-tenant-platform | current |
| [provider-caching-key-rotation-and-failure-modes](../sections/opensandbox--docs-guides-multi-tenancy--provider-caching-key-rotation-and-failure-modes.md) | sandbox-platforms, multi-tenant-platform, capability-security | current |
| [namespace-rbac-isolation-and-shared-authority](../sections/opensandbox--docs-guides-multi-tenancy--namespace-rbac-isolation-and-shared-authority.md) | sandbox-platforms, multi-tenant-platform, capability-security, networking | current |

## Provenance

Source: [docs/guides/multi-tenancy.md](https://github.com/opensandbox-group/OpenSandbox/blob/138ce5cb3bac6f3bb9dfcce3f72382b372c4cdd5/docs/guides/multi-tenancy.md) at file-specific commit `138ce5cb`.
