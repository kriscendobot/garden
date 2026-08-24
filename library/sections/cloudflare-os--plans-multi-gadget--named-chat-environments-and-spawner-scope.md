---
title: Named chat environments and spawner scope
source: plans/multi-gadget.md
source_repo: cloudflare/cloudflare-os
source_commit: e8132b07f2c4fe79d3c9a75e4e3f0b3c932f8d33
source_date: 2026-07-29
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [agent-workspaces, capability-mediated-integrations, agent-conventions]
status: current
---

Part 2 makes chat environments name-first: agents address gadgets and resources through stable JavaScript identifiers rather than numeric workpiece IDs, and each chat freezes its own binding map at creation.

Workspace defaults are derived from permanent gadgets and edges, with gadgets taking precedence and lower gadget IDs resolving edge-name collisions. Agent tools accept these names, gadget creation claims a unique workspace name, and connection requests reserve their intended name. Spawner environments remain explicit restricted maps rather than inheriting workspace defaults. Blueprint export translates workspace-local IDs into symbolic gadget or binding targets, and instantiation resolves those symbols into fresh capabilities.

Names must be valid JavaScript identifiers, excluding reserved words, `Object.prototype` properties, and `prototype`; ALL_CAPS is guidance rather than enforcement.

Source: [plans/multi-gadget.md](https://github.com/cloudflare/cloudflare-os/blob/e8132b07f2c4fe79d3c9a75e4e3f0b3c932f8d33/plans/multi-gadget.md) at commit `e8132b07`.
