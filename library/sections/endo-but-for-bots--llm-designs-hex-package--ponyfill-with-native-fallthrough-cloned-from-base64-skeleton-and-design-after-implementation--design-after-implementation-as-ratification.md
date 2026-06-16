---
source: designs/hex-package.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/hex-package.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - hardened-javascript
  - tooling
status_at_ingest: Complete
genre: §endo-but-for-bots-design §canonical-leaf-package-pattern
cycle: 180
lane: designs
status: current
title: §Design-after-implementation-as-ratification
parent: endo-but-for-bots--llm-designs-hex-package--ponyfill-with-native-fallthrough-cloned-from-base64-skeleton-and-design-after-implementation
---

§The-roadmap-calibration paragraph is rare in this corpus:

> Active development: 2026-04-24 → 2026-05-14 (21 days, calendar).
> Design phase: 2026-04-29 (single commit `102a94bc9`, batch of
> seven proposals; the design was written **after** the initial
> package landed 2026-04-24 in `ad7a177e8`, ratifying the upstream
> implementation).

§Design-phase-after-implementation-phase. §The-package-shipped-
first, then the design was written. §Three-bursts-of-
implementation: Burst 1 (initial add 2026-04-24); Burst 2
(compartment-mapper/bundle-source routed through 2026-04-25);
Burst 3 (PR #211 dev-cycle break 2026-05-11 → 2026-05-14).

§This-is-§ratification-by-design — the artifact predates its
specification. §Compare-to-the-typical-design-then-implement
rhythm of cycle 178 daemon-xs-worker-snapshot (design written
2026-04-15, implementation phased after) or cycle 174 gateway-
package (design 2026-05-22 still §Proposed).

§Why-do-this? §The-implementation-was-simple-enough that the
design wasn't load-bearing for the build; §the-design-is-load-
bearing-for-the-record. §Future-developers-reading-only-the-
design will reconstruct intent the same as if it had been
written first.

§Compare-to-the-honesty-of cycle 178's "Revised Scope
Discussion 2026-04-15" subsection (§honest-design-evolution-
record). §This-design's-honest-confession is in its roadmap
calibration: "the design was written **after** the initial
package landed."
