---
section: app-UI-manifest-with-three-sandbox-tiers-and-exo-binding-rule
source: endo-but-for-bots--llm-designs-familiar-app-ui-hosting
topics: [agent-conventions, capability-security]
status: current
title: App UI manifest with three sandbox tiers and exo-binding rule
parent: endo-but-for-bots--llm-designs-familiar-app-ui-hosting--app-UI-manifest-with-three-sandbox-tiers-and-exo-binding-rule
---

> *Reuse the weblet substrate; add only an app-facing manifest.
> This design deliberately owns no HTTP server or iframe
> mechanics — only the `{ entry, assets, sandbox, bridge }`
> shape and the exo-binding rule.*
>
> — `designs/familiar-app-ui-hosting.md` §Design Decisions

`familiar-app-ui-hosting.md` (146 lines, *Proposed* status,
created 2026-06-01) is authored by Aaron (with *(prompted)*
attribution — a third distinct attribution shape after Kris
Kowal's and Joshua T Corbin's). The design adds a **thin
app-UI layer** on top of three existing weblet-substrate
designs (cycle 114's `familiar-unified-weblet-server`, the
unindexed `familiar-chat-weblet-hosting`, and `daemon-weblet-
application`).
