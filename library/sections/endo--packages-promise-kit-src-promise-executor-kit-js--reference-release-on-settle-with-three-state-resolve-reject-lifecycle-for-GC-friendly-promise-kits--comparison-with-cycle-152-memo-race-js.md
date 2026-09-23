---
source: packages/promise-kit/src/promise-executor-kit.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/promise-kit/src/promise-executor-kit.js
source_path: packages/promise-kit/src/promise-executor-kit.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - patterns
  - async-flow
genre: §endo-source-comment-fragment
cycle: 173
lane: chat
status: current
title: §Comparison-with-cycle-152-memo-race.js
parent: endo--packages-promise-kit-src-promise-executor-kit-js--reference-release-on-settle-with-three-state-resolve-reject-lifecycle-for-GC-friendly-promise-kits
---

§Cycle-152 memo-race.js implements `memoRace`: race a list
of promises, returning the first to settle. Both files are
in @endo/promise-kit; both deal with §promise-lifecycle.

| File | Primary concern | Lifecycle pattern |
|------|----------------|-------------------|
| memo-race.js (cycle 152) | §Racing-with-cleanup | First-settler wins; losers signal abandonment |
| promise-executor-kit.js (this) | §Reference-release-on-settle | Captured executor refs cleared after settlement |

§Both-named-cleanup-disciplines for §async-resource-
hygiene. Cycle 152 cleans up §racing-promises; this cleans
up §kit-internal-references.

§Common-author: both are Kris Kowal authored — same author
discipline across @endo/promise-kit.
