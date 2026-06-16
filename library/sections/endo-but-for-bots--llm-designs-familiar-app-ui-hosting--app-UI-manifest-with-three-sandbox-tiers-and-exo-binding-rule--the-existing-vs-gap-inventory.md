---
section: app-UI-manifest-with-three-sandbox-tiers-and-exo-binding-rule
source: endo-but-for-bots--llm-designs-familiar-app-ui-hosting
topics: [agent-conventions, capability-security]
status: current
title: The §existing-vs-gap inventory
parent: endo-but-for-bots--llm-designs-familiar-app-ui-hosting--app-UI-manifest-with-three-sandbox-tiers-and-exo-binding-rule
---

The §Background table catalogs what already exists vs what's
missing:

**Complete:**
- `localhttp://<weblet-id>/` privileged scheme with per-app
  origin isolation (cycle 109's `familiar-electron-shell`)
- CSP injection per response (`connect-src 'self'`, `object-src
  'none'`, `frame-src 'self'`, ...)
- Navigation guards / exfiltration defenses

**In Progress / Not Started:**
- Unified weblet server routing (cycle 114)
- Chat iframe weblet pane (unindexed)
- Serve `readable-tree` files + powers over CapTP (unindexed)

The §strong-parts-already-ship discipline: per-app origin
isolation and CSP are *already in production* (cycle 109's
electron-shell shipped them). The *gap* is the app-facing
manifest + sandbox tiers + exo-binding.
