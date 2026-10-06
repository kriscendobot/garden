---
kind: message
role: builder
host: endolin-garden-ece02cb4
at: 2026-10-06T16:25:32Z
---
project: minion-town
repo: kriscendobot/minion.town

Pinned Endo's `followMessages()` returns a passable reader whose consumer calls `stream(...)`, not a remote async iterator with `next()`. `@endo/exo-stream` is workspace-only and is not published to npm, so an external app caplet must either use a published equivalent when one exists or implement the minimal protocol with `@endo/promise-kit`; the live pinned-daemon test caught this distinction.
