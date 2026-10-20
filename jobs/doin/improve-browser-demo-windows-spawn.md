---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
dev/new-clip-browser-demo.mjs
`dev/new-clip-browser-demo.mjs:46` directly spawns `npx`, which fails on Windows where the executable is `npx.cmd`. Select the platform command or invoke the local runner through `process.execPath` so browser acceptance automation works across checkouts.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-20T18:22:32Z
