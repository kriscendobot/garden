---
section: app-UI-manifest-with-three-sandbox-tiers-and-exo-binding-rule
source: endo-but-for-bots--llm-designs-familiar-app-ui-hosting
topics: [agent-conventions, capability-security]
status: current
title: The §three-phase implementation plan
parent: endo-but-for-bots--llm-designs-familiar-app-ui-hosting--app-UI-manifest-with-three-sandbox-tiers-and-exo-binding-rule
---

The §Phased Implementation section breaks the work into three
phases:

1. **Manifest + `connected` tier** — serve `assets` at unique
   origin; bootstrap CapTP to app's exo over MessagePort
   inside Chat iframe pane. *Depends on unified-server and
   chat-weblet-hosting integration points landing.*
2. **Tiers `isolated` and `trusted`** — add no-bridge and
   author-allowlisted-origin tiers; *surface trusted origins to
   the user at install/open time*.
3. **External-browser path** — WebSocket fallback for opening
   an app UI outside Familiar.

The §user-surface-trusted-origins discipline (Phase 2): when
an app declares `trusted` tier with extra origins, the user
sees those origins *at install time*. The §inform-the-user-of-
extra-reach pattern.
