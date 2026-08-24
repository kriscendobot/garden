---
title: Effective roles by fixed-point graph traversal
source: packages/workshop-backend/src/sharing.ts
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/workshop-backend/src/sharing.ts
source_line_range: "199-206, 552-639"
source_commit: 91c830eb453e8ae65cf186247f7ef961f2275bc9
comment_subject: effective role is the maximum owner-rooted role reachable through edges, computed by a monotone fixed-point iteration that also models hypothetical removals
source_authors: [Dan Carter, Kenton Varda, Kieran Hulsman, Phillip Jones]
ingested: 2026-08-24
ingested_by: scholar
topics: [collaborative-workspace-sharing, capability-security]
status: current
---

A collaborator's effective role is the maximum role reachable from the owner through valid permission edges, where each edge grants the minimum of its own role and the sharer's effective role. The engine computes this by a monotone fixed-point iteration (roles only ever increase, so it converges) and the same routine models hypothetical removals for the preview methods, so a UI can show exactly who would lose access before a revocation is committed.

## The grant rule

The owner is the implicit root at role `build`. Each edge grants `min(edge role, sharer's effective role)`:

- A `user` edge's sharer is the owner (effective `build`) or another collaborator.
- A `shareKey` edge's sharer is the key's creator; the edge grants the key's role bounded by the creator's effective role.

A collaborator absent from the returned map has no access. `getEffectiveRole(profileId)` returns the map lookup, short-circuiting the owner to `build`.

## Fixed-point iteration

`computeEffectiveRoles` first builds a link table (excluding revoked links, whether persisted `revoked` or the hypothetical `revokedLinkId`) and the collaborator set (excluding any removed user). It then iterates: for each collaborator it takes the best role over all incoming edges, using a `sharerRole` helper that roots the owner at `build`, and sets the collaborator's role whenever a strictly higher one is found. The loop repeats while any role changed. Because roles only increase, the iteration is guaranteed to converge.

## Modeling hypothetical changes for previews

Three optional modifications let the same routine answer "what would change if...", which the `previewRevokeShareLink` and remove-preview methods use to compute affected collaborators against a baseline:

- `removedUser`: a profileId excluded from the graph entirely.
- `removedEdge`: a single `user` edge (target and sharer) treated as removed.
- `revokedLinkId`: a link treated as revoked, so its edges contribute nothing.

Source: [packages/workshop-backend/src/sharing.ts](https://github.com/cloudflare/cloudflare-os/blob/91c830eb453e8ae65cf186247f7ef961f2275bc9/packages/workshop-backend/src/sharing.ts) at commit `91c830eb45` (lines 199-206, 552-639).
