---
role: builder
---

Build the Endor in-process Git CAS implementation described by the merged design PR https://github.com/endojs/endo-but-for-bots/pull/740.

Scope: implement the design on the appropriate implementation base, beginning with its Phase 1 validated GitCas capability. Follow the design decisions: gix is the sole runtime backend; daemon-owned repositories use SHA-256; ordinary git is test-only cross-validation; object storage belongs in Endo state storage. Determine the smallest independently shippable Phase 1 slice, provide load-bearing tests for it, and open a draft PR.

The maintainer directive at https://github.com/endojs/endo-but-for-bots/pull/740#issuecomment-5084077705 authorized dispatch after the design was integrated, squashed, and merged as f6d2efbbb98c38973dcc98d6bd1bf44fc217dfe2.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: hermit
  claimed_at: 2026-07-26T19:24:45Z
