---
section: app-UI-manifest-with-three-sandbox-tiers-and-exo-binding-rule
source: endo-but-for-bots--llm-designs-familiar-app-ui-hosting
topics: [agent-conventions, capability-security]
status: current
title: §Four design decisions codify the choices
parent: endo-but-for-bots--llm-designs-familiar-app-ui-hosting--app-UI-manifest-with-three-sandbox-tiers-and-exo-binding-rule
---

The §Design Decisions section names four:

1. **Reuse the weblet substrate; add only an app-facing
   manifest** — the minimalist discipline.
2. **Tiers widen reach, never relax origin isolation** — the
   §invariant-across-tiers discipline.
3. **The UI is bound to a specific app exo, not ambient
   authority** — the §capability-not-configuration discipline
   (cycle 105's principle).
4. **`connected` is the sensible default** — *most app UIs need
   exactly one thing: a confined back-channel to their own
   capability*.
