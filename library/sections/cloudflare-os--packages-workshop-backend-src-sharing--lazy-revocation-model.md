---
title: Lazy revocation model and reversibility
source: packages/workshop-backend/src/sharing.ts
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/workshop-backend/src/sharing.ts
source_line_range: "1-22, 363-379, 520-547"
source_commit: 91c830eb453e8ae65cf186247f7ef961f2275bc9
comment_subject: revocation is lazy and reversible because access is reachability from the owner recomputed live, never destructive pruning
source_authors: [Dan Carter, Kenton Varda, Kieran Hulsman, Phillip Jones]
ingested: 2026-08-24
ingested_by: scholar
topics: [collaborative-workspace-sharing, capability-security]
status: current
---

The sharing module implements revocation lazily: access is defined as reachability from the owner in a permission graph, recomputed live at every `open()`, so removing a collaborator or revoking a share link only severs the granting edges (or flags the link revoked) rather than deleting records or cascading. Users who lose their only path to the owner simply become unreachable and are denied at open time. Because the graph is never destructively pruned, revocation is fully reversible: re-adding a removed collaborator restores them and, transitively, everyone they had shared with. This is the implementation-side account of the same lazy-revocation semantics the sharing design describes; see the `docs/sharing.md` sections for the design-level framing.

## The module boundary: no RPC, graph only

The module owns all manipulation of the `collaborators` and `shareKeys` storage collections and the permission graph linking them. It deliberately performs no RPC: anything requiring a User Durable Object (resolving a profile from a username, fetching the owner's profile, notifying a user a gadget was opened) stays in the Overseer, which passes resolved values (or, where laziness matters, a callback) into this module.

The `prohibitAllSharing` policy flag deliberately does *not* live here. It is a broader "may this gadget communicate with anyone other than the owner?" policy (it also gates gatekeeper writes and web fetches) expected to grow into a separate policy engine. The Overseer enforces it; this module only exposes `hasAnyShares()` so the policy can ask about current state.

## Removing a collaborator is lazy and reversible

`removeCollaborator` severs the edges granting the target access; nothing cascades and no records are deleted. The target's record, and crucially any edges where the target is the *sharer* of access to others, are left intact. Dependents who lose their only path to the owner become unreachable and are denied at open time, not pruned here. Re-adding the target restores the target and, transitively, everyone they had shared with.

- The owner severs *all* incoming edges to the target (owner-removal means "gone now").
- A non-owner severs only their own `user` edge to the target; if the target retains other edges they keep access, possibly at a lower role.

`keepUsers` is optional re-root sugar: any listed dependent who would otherwise lose access or be downgraded is granted a fresh edge from the caller at their prior role. The method returns the collaborators whose access actually changed, excluding kept users.

## Revoking a share link is the lazy counterpart

`revokeShareLink` soft-revokes by setting a `revoked` flag rather than deleting. The link record and every `shareKey` edge referencing it stay intact (no dangling references), but the link contributes nothing to the permission graph and its keys can no longer be redeemed. Its *copies* (aliases) are deleted outright since no edge ever names an alias. Records and revoked keys accumulate in storage; a future GC could reclaim long-dead entries.

Source: [packages/workshop-backend/src/sharing.ts](https://github.com/cloudflare/cloudflare-os/blob/91c830eb453e8ae65cf186247f7ef961f2275bc9/packages/workshop-backend/src/sharing.ts) at commit `91c830eb45` (lines 1-22, 363-379, 520-547).
