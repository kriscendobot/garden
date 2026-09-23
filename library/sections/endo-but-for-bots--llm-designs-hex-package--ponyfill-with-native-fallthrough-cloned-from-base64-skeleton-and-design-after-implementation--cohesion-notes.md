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
title: §Cohesion notes
parent: endo-but-for-bots--llm-designs-hex-package--ponyfill-with-native-fallthrough-cloned-from-base64-skeleton-and-design-after-implementation
---

- §Sibling-extract-pattern to cycle 172 @endo/bytes (also a leaf
  ponyfill extracted from consumer call sites) and cycle 174
  gateway-package (subsystem-package extracted as a junction).
- §Canonical-leaf-package-skeleton: `packages/base64/` is the
  template; future leaf ponyfills should clone its shape.
  §Three-files-omitted (atob.js / btoa.js / shim.js) are
  §deliberate-omission-not-oversight.
- §Design-after-implementation-as-ratification-discipline: the
  artifact predates its specification. §Honest-roadmap-
  calibration in the Status section names this.
- §Module-load-runtime-detection bound to module-private const
  — same shape as cycle 179 lp32 host-endian probe + cycle 175
  harden/make-selector.js' race-to-install.
- §Error-rewrapping-at-native-boundary for §stable-error-
  contract — explicit Design Decision 6 with named cost/benefit.
- §Eight-Design-Decisions canonical format matches cycle 174
  gateway-package's eight + cycle 178 daemon-xs-worker-
  snapshot's six.
- §Audit-drives-scope: 32 rows total (23 byte-array + 5
  boundary + 9 non-byte-array) lets migration review be
  mechanical. §Test-files-included in the audit lets §portability-
  by-removing-Node-specific-imports proceed.
- §Five-phases-mostly-S: leaf package with simple migration
  rhythm. §Transitional-alias-pattern in Phase 2 eliminates the
  flaky-window between package-landed and call-sites-migrated.
- §Boundary-sites-explicitly-named-and-defended: §don't-
  pessimize-the-boundary; use the platform's hex directly
  where it already produces hex.
- §Status-Complete with shipped commits cited (ad7a177e8 +
  68246ad92) — §design-ratifies-implementation-then-cites-it.
