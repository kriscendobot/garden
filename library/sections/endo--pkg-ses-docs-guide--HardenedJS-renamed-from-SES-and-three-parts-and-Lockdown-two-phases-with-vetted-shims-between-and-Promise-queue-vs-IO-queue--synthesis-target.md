---
title: Synthesis target
section-slug: endo--pkg-ses-docs-guide--HardenedJS-renamed-from-SES-and-three-parts-and-Lockdown-two-phases-with-vetted-shims-between-and-Promise-queue-vs-IO-queue
source-slug: endo--pkg-ses-docs-guide
url: https://github.com/endojs/endo/blob/master/packages/ses/docs/guide.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/ses/docs/guide.md
total-lines: 652
ingest-cycle: 293
ingest-date: 2026-06-11
lane: designs
scope: full
parent: endo--pkg-ses-docs-guide--HardenedJS-renamed-from-SES-and-three-parts-and-Lockdown-two-phases-with-vetted-shims-between-and-Promise-queue-vs-IO-queue
---

Slot machine library `@game/replay/docs/guide.md`: TypeDoc-style frontmatter with `group: Documents` + `category: Guides`; named rebranding acknowledgment (e.g., "old name X, now Y"); three named primitives of GameEngine (e.g., InitializeGame + HardenRules + Compartment); GameEngine-OCap-three-requirements; historical narrative of why deterministic replay matters; `require('@game/lockdown'); lockdownGame();` shim pattern; UMD build for browser script-tag; two named queues (Promise + I/O); named source-of-truth file for permitted globals (e.g., `permits.js`); three named distribution shapes (CJS + ESM + UMD); named bootstrap compartment vs constructed compartments; out-of-band time source via `TimerService`-style capability; capability hardened at the boundary before passing into compartment; tc39-style external glossary link for shared terminology.
