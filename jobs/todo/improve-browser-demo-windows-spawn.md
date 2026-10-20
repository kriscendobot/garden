---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
dev/new-clip-browser-demo.mjs
`dev/new-clip-browser-demo.mjs:46` directly spawns `npx`, which fails on Windows where the executable is `npx.cmd`. Select the platform command or invoke the local runner through `process.execPath` so browser acceptance automation works across checkouts.
