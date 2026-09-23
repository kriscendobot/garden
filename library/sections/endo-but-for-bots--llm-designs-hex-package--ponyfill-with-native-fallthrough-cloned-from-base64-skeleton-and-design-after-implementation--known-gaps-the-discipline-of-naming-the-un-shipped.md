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
title: §Known-Gaps (the discipline of naming the un-shipped)
parent: endo-but-for-bots--llm-designs-hex-package--ponyfill-with-native-fallthrough-cloned-from-base64-skeleton-and-design-after-implementation
---

```
- [ ] Native TC39 Uint8Array.prototype.toHex does not accept an
      options bag.  If the proposal adds { uppercase } before Stage 4,
      revisit the encode fast path to avoid the fallback on uppercase.
- [ ] packages/compartment-mapper/demo/policy/app.js migration is
      deferred because the demo is CommonJS and requires a richer
      interop story.
- [ ] No benchmark numbers are included here.
- [ ] @endo/hex does not yet have a ./lite export for environments
      that want to avoid the native-detection branch.
- [ ] Uint8Array.prototype.setFromHex (writes into existing buffer)
      is not mirrored.
```

§Five-known-gaps-as-checkbox-list. §Compare-to-cycle-174-gateway-
package's §seven-open-questions. §The-gap-list-is-honest-about-
what-was-deferred. §§Add-if-a-consumer-asks pattern repeats —
features deferred until someone has a concrete need.

§§Add-if-a-consumer-asks is the §YAGNI-with-extension-point
discipline. §The-design-leaves-room for §setFromHex (in-place
write into existing buffer) and §`./lite` export (no native-
detection branch) without committing to them. §This-is-§deliberate-
under-specification.
