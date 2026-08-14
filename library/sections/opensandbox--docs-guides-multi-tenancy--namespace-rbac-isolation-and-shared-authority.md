---
title: Namespace, RBAC isolation, and shared authority
source: docs/guides/multi-tenancy.md
source_repo: opensandbox-group/OpenSandbox
source_commit: 138ce5cb3bac6f3bb9dfcce3f72382b372c4cdd5
source_date: 2026-08-14
source_authors: [epha]
ingested: 2026-08-14
ingested_by: scholar
topics: [sandbox-platforms, multi-tenant-platform, capability-security, networking]
status: current
---

> Abstract: Kubernetes namespaces are the tenant partition, but quotas, default limits, network isolation, and RoleBindings are operator-installed mechanisms rather than server-enforced invariants. The default server has a ClusterRole spanning namespaces, and pool routes remain shared in the default namespace, leaving the control plane and pool surface outside the tenant boundary.

Cluster administrators must create namespaces before issuing keys. `ResourceQuota` and `LimitRange` are recommended for CPU, memory, storage, and pod-count bounds. The egress sidecar supplies per-sandbox outbound policy, and namespace RoleBindings can constrain API access. The OpenSandbox server itself does not enforce those controls.

The default Helm deployment grants the server ServiceAccount cross-namespace ClusterRole authority. This is a trusted-deputy design: tenant callers rely on the server to wield broad ambient Kubernetes authority using the namespace selected by authentication middleware. Pool APIs are explicitly not tenant-scoped and operate in the configured default namespace. Separate server deployments are required when shared pools are unacceptable.

Endo object-capability confinement avoids this particular confused-deputy shape by handing a component only references it may use. Namespace/RBAC isolation can still be a strong outer boundary, but tenant authentication, server authority, Kubernetes policy, and pool scoping must be audited separately.

Source: [docs/guides/multi-tenancy.md](https://github.com/opensandbox-group/OpenSandbox/blob/138ce5cb3bac6f3bb9dfcce3f72382b372c4cdd5/docs/guides/multi-tenancy.md) at commit `138ce5cb`.
