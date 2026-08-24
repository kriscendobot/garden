---
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/workshop-backend/src/sharing.ts
source_line_range: "1-639"
source_commit: 91c830eb453e8ae65cf186247f7ef961f2275bc9
comment_subject: collaborator permission-graph, lazy reversible revocation, share-key redemption, and fixed-point effective-role computation
source_authors: [Dan Carter, Kenton Varda, Kieran Hulsman, Phillip Jones]
ingested: 2026-08-24
ingested_by: scholar
section_count: 3
status: current
---

`sharing.ts` implements collaborator authorization, sharing, and the permission graph for a Gadget's Overseer. Its comments describe access as reachability from the owner recomputed live at every open, which makes revocation lazy and fully reversible; share-key redemption that hashes the plaintext and collapses a link's keys and copies to a single edge; and a monotone fixed-point iteration that computes every collaborator's effective role and models hypothetical removals for previews. This is the implementation-side companion to the design-shaped `docs/sharing.md`; the two are soft-flagged as complementary, not contradictory.

| Section | Topics | Status |
|---------|--------|--------|
| [Lazy revocation model and reversibility](../sections/cloudflare-os--packages-workshop-backend-src-sharing--lazy-revocation-model.md) | collaborative-workspace-sharing, capability-security | current |
| [Share-key redemption and link/alias edges](../sections/cloudflare-os--packages-workshop-backend-src-sharing--share-key-redemption.md) | collaborative-workspace-sharing, capability-security | current |
| [Effective roles by fixed-point graph traversal](../sections/cloudflare-os--packages-workshop-backend-src-sharing--effective-role-fixed-point.md) | collaborative-workspace-sharing, capability-security | current |
