---
title: Binding edges and workpiece capabilities
source: plans/multi-gadget.md
source_repo: cloudflare/cloudflare-os
source_commit: e8132b07f2c4fe79d3c9a75e4e3f0b3c932f8d33
source_date: 2026-07-29
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [agent-workspaces, capability-mediated-integrations, capability-security]
status: current
---

Binding names move from Gatekeeper records onto per-gadget edges, allowing multiple gadgets to name and annotate the same resource differently while keeping authority represented by workpiece capabilities.

Each `GadgetRecord` carries a small map from binding name to target workpiece and optional blueprint annotation. A shared `WorkpieceClient` base holds identity and lifecycle surface, while `GadgetClient` and `GatekeeperClient` expose type-specific authority. Removing a UI connection deletes one edge rather than destroying the Gatekeeper. Workspace-wide policy such as auto-approval remains on the shared Gatekeeper, and reverse lookup scans the small gadget registry.

Source: [plans/multi-gadget.md](https://github.com/cloudflare/cloudflare-os/blob/e8132b07f2c4fe79d3c9a75e4e3f0b3c932f8d33/plans/multi-gadget.md) at commit `e8132b07`.
