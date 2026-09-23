---
title: Notes
section-slug: endo--packages-hex-src-encode-js--polyfill-and-native-dispatch-pair-and-pre-lockdown-capture
source-slug: endo--packages-hex-src-encode-js
url: https://github.com/endojs/endo/blob/master/packages/hex/src/encode.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/hex/src/encode.js
total-lines: 60
ingest-cycle: 314
ingest-date: 2026-06-11
lane: chat
scope: full
parent: endo--packages-hex-src-encode-js--polyfill-and-native-dispatch-pair-and-pre-lockdown-capture
---

- The named-pre-lockdown-binding-capture (capture native intrinsic before SES freezes the prototype) IS a structurally important defense-in-depth pattern. The same idea applies to any other native prototype method the code depends on.
- The named-polyfill-and-dispatcher-pair-shape IS a clean way to expose both the canonical (slow but always-available) implementation AND the optimized (fast but optionally-available) dispatcher. Users can choose; benchmarks can compare; environments missing the native intrinsic still work.
- The named-Stage-4-TC39-proposal-citation marks a kind of "future-proofing acknowledgment" — the code knows about a proposal that may become spec; the polyfill IS the bridge until adoption IS universal.
- The named-rotate-after-pair-discipline (cycles 310-311 nat → cycles 312-313 memoize → cycle 314 hex) IS evidence the pivot IS pacing itself across the @endo package surface rather than over-investing in any single package.
- The named-quadratic-anti-pattern-named (with the explicit "quadratic-time string concatenation" comment) IS pedagogical: the code names the bug it IS avoiding, so future maintainers don't refactor it back into a string-concat loop.
