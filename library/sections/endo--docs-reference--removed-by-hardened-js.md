---
title: Removed by HardenedJS summary
source: docs/reference.md
source_repo: endojs/endo
source_commit: bffadcab8a39be8529406b22574e25cf64dec755
source_date: 2026-04-26
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript]
status: current
---

> Abstract: Inventory of JS globals SES removes or restricts: Date.now() returns NaN by default, Math.random() is removed from compartments, locale-sensitive methods aliased to non-locale equivalents, RegExp.prototype.compile deleted under safe taming, ambient-authority sources removed. Companion to docs/lockdown.md per-option detail; this is the one-screen summary.

## Removed by HardenedJS summary

The following are missing or unusable under HardenedJS:
- Most [Node.js-specific global objects](https://nodejs.org/dist/latest-v14.x/docs/api/globals.html)
- All [Node.js built-in modules](https://nodejs.org/dist/latest-v14.x/docs/api/) such as `http` and
  `crypto`.
- [Features from browser environments](https://developer.mozilla.org/en-US/docs/Web/API) presented as names in the global scope including `atob`, `TextEncoder`, and `URL`.
- HTML comments
- Dynamic `import` expressions
- Direct evals


Source: [docs/reference.md](https://github.com/endojs/endo/blob/bffadcab8a39be8529406b22574e25cf64dec755/docs/reference.md) at commit `bffadcab`.
