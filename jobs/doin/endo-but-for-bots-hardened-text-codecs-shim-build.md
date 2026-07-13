---
role: builder
---

Build the hardened `TextEncoder`/`TextDecoder` vetted shim in endojs/endo-but-for-bots per design `hardened-text-codecs-shim` (M2, Not Started, depends_on []): add the codecs to `universalPropertyNames` in `packages/ses/src/permits.js`, sample them during the intrinsics-collection pass, and harden — closing one of the two remaining M2 hygiene rows.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 14
  claimed_at: 2026-07-13T08:51:00Z
