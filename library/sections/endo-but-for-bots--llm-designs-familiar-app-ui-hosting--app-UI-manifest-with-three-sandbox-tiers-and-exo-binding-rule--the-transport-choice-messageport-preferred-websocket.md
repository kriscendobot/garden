---
section: app-UI-manifest-with-three-sandbox-tiers-and-exo-binding-rule
source: endo-but-for-bots--llm-designs-familiar-app-ui-hosting
topics: [agent-conventions, capability-security]
status: current
title: The §transport-choice — MessagePort preferred, WebSocket
parent: endo-but-for-bots--llm-designs-familiar-app-ui-hosting--app-UI-manifest-with-three-sandbox-tiers-and-exo-binding-rule
---

fallback

The §Transport paragraph:

> *Transport is `MessagePort` for the in-Chat iframe (preferred,
> no network surface) with a `web-socket` fallback for an
> external browser.*

The §MessagePort-over-WebSocket-when-possible discipline:

- **MessagePort** — no network surface at all; bytes never
  leave the user's process. Used when the UI is hosted inside
  Chat's Electron renderer (cycle 109's familiar-electron-shell
  provides the substrate).
- **WebSocket** — fallback for *external browser* (when the
  user opens the app's URL in a separate browser window).
  Bytes cross localhost; the WebSocket terminates at the
  daemon's gateway (cycle 111's familiar-gateway-migration).

The §preferred-over-fallback shape lets the design *use the
cheapest secure transport* when available without preventing
external-browser use.
