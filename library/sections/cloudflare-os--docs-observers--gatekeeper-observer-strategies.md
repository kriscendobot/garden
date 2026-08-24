---
title: Gatekeeper observer strategies
source: docs/observers.md
source_repo: cloudflare/cloudflare-os
source_commit: c6e15a0399372833405c9826f1d8764c7ebd0d76
source_date: 2026-08-04
source_authors: [Dan Carter, Kenton Varda, Nathan Disidore, Phillip Jones]
ingested: 2026-08-24
ingested_by: scholar
topics: [collaborative-workspace-sharing, capability-mediated-integrations, capability-security]
status: current
---

Gatekeepers choose observer enforcement per resource type from private-only, atomic ACL, observed-data-set tracking, low-stakes no-op, or not-applicable strategies.

Private-only resources reject every non-owner. Atomic resources verify one ACL that covers all reads. Broad resources with independently permissioned children and a usable access oracle track the data sets actually observed, verify new observers against the accumulated set, and exclude incompatible observers when a new set is first read. Low-stakes resources deliberately perform no information-flow tracking.

The design assigns atomic checks to repositories and individual documents, data-set tracking to broad workspaces and organizations, private-only handling to Gmail and ZoomInfo, and low-stakes handling where no meaningful per-user ACL oracle exists. A broad binding uses data-set tracking only when its subresources have distinct ACLs and each can be checked for the observer.

Source: [docs/observers.md](https://github.com/cloudflare/cloudflare-os/blob/c6e15a0399372833405c9826f1d8764c7ebd0d76/docs/observers.md) at commit `c6e15a03`.
