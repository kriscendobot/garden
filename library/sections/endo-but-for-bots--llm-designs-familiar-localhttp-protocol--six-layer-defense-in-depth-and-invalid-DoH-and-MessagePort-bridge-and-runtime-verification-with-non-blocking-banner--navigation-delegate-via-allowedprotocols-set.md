---
title: §Navigation-delegate via §allowedProtocols-set
source-slug: endo-but-for-bots--llm-designs-familiar-localhttp-protocol
section-id: six-layer-defense-in-depth-and-invalid-DoH-and-MessagePort-bridge-and-runtime-verification-with-non-blocking-banner
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/familiar-localhttp-protocol.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/familiar-localhttp-protocol.md
total-lines: 636
status: Partially implemented (Familiar-side Ready; Chat-side Not Yet)
ingest-cycle: 220
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-familiar-localhttp-protocol--six-layer-defense-in-depth-and-invalid-DoH-and-MessagePort-bridge-and-runtime-verification-with-non-blocking-banner
---

```js
const allowedProtocols = new Set([
  'file:',
  'localhttp:',
]);
```

§Two-named-allowed-protocols. §Dev-mode-exemption for the Vite dev server. §Three-cases:
1. allowedProtocols → continue.
2. dev-mode + Vite-origin → continue.
3. else → preventDefault + promptExternalNavigation.

§Borrowable-pattern: §allowlist-based-navigation-confinement + §named-dev-mode-exemption.
