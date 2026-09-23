---
title: Network compatibility and residual trust
source: docs/architecture/network-isolation.md
source_repo: opensandbox-group/OpenSandbox
source_commit: 08f6a6598045cfd6742f2d09304bb4ddb6f8d171
source_date: 2026-07-16
source_authors: [ruirui6946]
ingested: 2026-08-14
ingested_by: scholar
topics: [sandbox-platforms, networking]
status: current
---

> Abstract: The egress boundary depends on network-namespace interception and is not runtime-neutral in practice. It works with runc and Kata variants, but gVisor's netstack lacks the iptables `nat` behavior the sidecar uses. Service meshes can also collide with OpenSandbox because both want to rewrite outbound traffic. Deployments must choose compatible enforcement layers rather than assume every advertised isolation feature composes.

For gVisor plus FQDN policy, the source recommends Kata instead or a CNI-level policy such as Cilium. For service meshes, it recommends excluding sandbox pods from mesh injection or moving outbound enforcement to the platform network layer. Pool mode adds another limitation: per-request policy cannot inject a sidecar into an already-created pool pod, so the pool template must carry the policy.

Residual trust includes the sidecar image and rules, hot-reload path, cluster CIDR accuracy, namespace interception, ingress authentication/authorization, and the runtime's packet behavior. A misconfiguration can restore ambient cluster reach even when the workload remains container-isolated.

Source: [docs/architecture/network-isolation.md](https://github.com/opensandbox-group/OpenSandbox/blob/08f6a6598045cfd6742f2d09304bb4ddb6f8d171/docs/architecture/network-isolation.md) at commit `08f6a659`.
