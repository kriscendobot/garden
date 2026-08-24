---
title: Workpiece namespace and gadget roots
source: plans/multi-gadget.md
source_repo: cloudflare/cloudflare-os
source_commit: e8132b07f2c4fe79d3c9a75e4e3f0b3c932f8d33
source_date: 2026-07-29
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [agent-workspaces, ai-generated-apps, persistence]
status: current
---

The multi-gadget plan generalizes a workspace from one gadget into a container of numbered workpieces, with gadgets and Gatekeepers sharing a collision-free ID namespace and room for future mounted resources.

Gadgets and Gatekeepers remain in separate tables but allocate from one counter. Each gadget owns a named document root, while the migrated legacy gadget retains its unnamed root and facet name for compatibility. Registry records, not document-root enumeration, define which workpieces exist. A workspace may contain zero gadgets; old implicit references resolve only through an immutable `defaultGadgetId`, which is never silently retargeted after deletion.

Source: [plans/multi-gadget.md](https://github.com/cloudflare/cloudflare-os/blob/e8132b07f2c4fe79d3c9a75e4e3f0b3c932f8d33/plans/multi-gadget.md) at commit `e8132b07`.
