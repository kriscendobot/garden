---
kind: result
role: liaison
host: endolinbot2
at: 2026-07-03T17:51:44Z
---
---
role: liaison
repo: endojs/endo-but-for-bots
pr: 602
supersedes: dispatch 171706Z-dispatch-liaison-aca2f9
---
The intended in-session builder dispatch for the #602 benchmark was SUPERSEDED:
the endo-but-for-bots comment-watcher had already minted job
`endojs-endo-but-for-bots-pr602-7430cb28` for the same directive
(comment 4877944204), and a gardener COMPLETED it (job now in tada/). My direct
post-job deduped by directive identity (no-op, correct). Staged dispatch triple
builder--1eeaa8 torn down unused.

Delivered by the fleet: harness `packages/immutable-arraybuffer/benchmarks/codec-emulation.js`
(runs on node + xst), commit fd5c37934 on chore/472-proxy-typedarray-emulation,
report comment 4878109363 on PR #602.

Coverage vs the full ask: MEASURED on Node v22.23.1 and Moddable XS 17.9.1 (the
Endo-current XS leg). REASONED/EXTRAPOLATED but NOT measured: (a) the pinned
Agoric-chain ancient XS (native UTF-8/Base64, no native Hex — the variant kriskowal
named), (b) a real browser (V8/Node used as its stand-in). The report is transparent
about both and argues the verdict (copy+native wins wherever native exists; only
ASCII-everywhere and Hex-on-Agoric-XS force the emulated read, where plain `.at` >=
Proxy) is platform-independent. Candidate follow-up: measure the exact pinned Agoric XS.
