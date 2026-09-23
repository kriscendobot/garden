---
section: app-UI-manifest-with-three-sandbox-tiers-and-exo-binding-rule
source: endo-but-for-bots--llm-designs-familiar-app-ui-hosting
topics: [agent-conventions, capability-security]
status: current
title: The §reuse-the-weblet-substrate discipline
parent: endo-but-for-bots--llm-designs-familiar-app-ui-hosting--app-UI-manifest-with-three-sandbox-tiers-and-exo-binding-rule
---

The §Design Decision 1 is the design's *minimalist promise*:

> *This design deliberately owns no HTTP server or iframe
> mechanics — only the `{ entry, assets, sandbox, bridge }`
> shape and the exo-binding rule.*

The §thin-app-UI-layer-over-existing-weblet-substrate
discipline. Three existing designs provide the substrate:

- **`familiar-unified-weblet-server`** (cycle 114) — one HTTP
  server that routes by virtual host to weblet handlers
- **`familiar-chat-weblet-hosting`** (unindexed) — embedding
  a weblet as an iframe pane inside Chat with a chrome/guest
  barrier
- **`daemon-weblet-application`** (unindexed) — serving a
  `readable-tree` of static files plus a powers reference
  over CapTP

This design adds *only*:

1. A **UI manifest** on the app handle (entry HTML + assets
   tree + sandbox tier + bridge transport)
2. A small **sandbox-level policy** (the three tiers)
3. The **CapTP wiring** binding the UI back to *that app's*
   exo (not ambient daemon authority)

The §minimalist-design discipline: *defers all core hosting
mechanics to the three documents above*.
