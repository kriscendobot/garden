---
title: Platform-enforced egress confinement
source: docs/architecture/network-isolation.md
source_repo: opensandbox-group/OpenSandbox
source_commit: 08f6a6598045cfd6742f2d09304bb4ddb6f8d171
source_date: 2026-07-16
source_authors: [ruirui6946]
ingested: 2026-08-14
ingested_by: scholar
topics: [sandbox-platforms, networking, capability-security]
status: current
---

> Abstract: OpenSandbox's recommended control is a platform-built egress sidecar image containing `deny.always` rules for Pod and Service CIDRs. These rules are prepended to user policy, hot-reloaded, and cannot be overridden through the SDK/API. Legitimate cross-sandbox service access is forced through `GetEndpoint()` and authenticated ingress, or opened narrowly by platform-managed allow rules.

The sidecar merges platform always-deny rules before always-allow and user rules, so first-match ordering makes the denial non-discretionary to guest callers. DNS filtering and nftables enforcement must both agree when default-deny is enabled: allowing a service hostname alone does not permit its ClusterIP if the Service CIDR remains denied.

This resembles capability discipline only at a distance. The operator retains broad authority and grants network destinations through policy, but the resulting channel is still ordinary ambient network access available to processes inside the sandbox unless further internal separation exists. Endo instead hands a specific object reference or attenuated service to a component, and that authority can remain confined to the recipient rather than becoming a namespace-wide route.

Source: [docs/architecture/network-isolation.md](https://github.com/opensandbox-group/OpenSandbox/blob/08f6a6598045cfd6742f2d09304bb4ddb6f8d171/docs/architecture/network-isolation.md) at commit `08f6a659`.
