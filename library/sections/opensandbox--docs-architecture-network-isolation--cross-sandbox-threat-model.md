---
title: Cross-sandbox network threat model
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

> Abstract: The Kubernetes threat is direct Pod-IP reachability between mutually suspicious sandboxes. Malicious code can scan cluster CIDRs, bypass OpenSandbox's authenticated endpoint path, connect to another tenant's listening ports, and leak data. OpenSandbox therefore treats each sandbox, not each label-selected pod set, as the desired network security domain.

The source rejects native Kubernetes NetworkPolicy as the primary answer for this workload. Sandbox labels are platform-generated and may not encode tenant boundaries; sandboxes appear and disappear rapidly; policy selectors name sets rather than one future-proof domain per sandbox; and inbound-only rules cannot stop a malicious sandbox from initiating connections to another Pod IP. Per-sandbox bidirectional policies would have to track each dynamic instance.

This threat model is about ambient network reach supplied by the cluster. It is coarser than Endo's claim that code initially has no I/O authority because no network object was endowed. OpenSandbox assumes a Linux workload with a network stack, then constrains its reachable destinations at the sidecar or platform layer.

Source: [docs/architecture/network-isolation.md](https://github.com/opensandbox-group/OpenSandbox/blob/08f6a6598045cfd6742f2d09304bb4ddb6f8d171/docs/architecture/network-isolation.md) at commit `08f6a659`.
