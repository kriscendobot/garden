---
title: Layered isolation and trust boundaries
source: docs/architecture/index.md
source_repo: opensandbox-group/OpenSandbox
source_commit: 02617e27f82409a0293012fe4c9acc2f6a67e262
source_date: 2026-08-14
source_authors: [lihaopeng]
ingested: 2026-08-14
ingested_by: scholar
topics: [sandbox-platforms, capability-security]
status: current
---

> Abstract: OpenSandbox does not claim that one mechanism supplies the whole sandbox. The container or pod is the tenant/workspace boundary; gVisor or Kata can strengthen the host-kernel boundary; `execd` mediates execution and filesystem APIs; ingress credentials mediate inbound access; the egress sidecar mediates outbound destinations; resource limits bound CPU, memory, and GPUs; and nested bubblewrap sessions can separate tasks inside one sandbox. The operator and these control components are in the trusted computing base.

The architecture assigns policy to different layers. The lifecycle server owns API-key authentication, validation, runtime choice, endpoint formatting, and persistent records. Runtime providers own platform-specific creation. `execd` owns operations inside the sandbox filesystem and network namespace. The egress sidecar owns outbound DNS and network policy. Ingress and secure-access headers own exposed service routes.

These layers defend different boundaries and can interfere: the egress sidecar needs control of outbound interception, while secure runtimes change the kernel implementation beneath the pod. Optional secure runtimes and egress controls mean an installation's actual threat model is configuration-dependent. The architecture's “secure defaults with explicit escape hatches” principle names server guardrails, capability drops, resource limits, optional secure runtimes, endpoint headers, and network isolation, but ordinary runc and less restrictive development modes remain available.

Source: [docs/architecture/index.md](https://github.com/opensandbox-group/OpenSandbox/blob/02617e27f82409a0293012fe4c9acc2f6a67e262/docs/architecture/index.md) at commit `02617e27`.
