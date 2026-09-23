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
title: §Tier-1 borrowing
parent: endo-but-for-bots--llm-designs-hex-package--ponyfill-with-native-fallthrough-cloned-from-base64-skeleton-and-design-after-implementation
---

- §sibling-package-cloned-file-for-file (canonical-leaf-package
  pattern from @endo/base64)
- §design-after-implementation-as-ratification-discipline
- §native-fallthrough-detection-bound-once-at-module-load
- §error-rewrapping-at-native-boundary-for-stable-error-contract
- §audit-drives-scope (exhaustive table for mechanical review)
- §three-way-classification-of-sites (migration / boundary /
  non-byte-array)
- §transitional-alias-pattern (re-export alias eliminates flaky
  window between package-landed and call-sites-migrated)
- §don't-pessimize-the-boundary (platform-native at the edge,
  portable in the middle)
- §belt-and-suspenders-for-input-but-not-for-output (input
  validation unconditional even when delegating output)
- §deliberate-omission-not-oversight (atob.js / btoa.js /
  shim.js named as not-cloned and why)
