---
title: Share-key redemption and link/alias edges
source: packages/workshop-backend/src/sharing.ts
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/workshop-backend/src/sharing.ts
source_line_range: "208-229"
source_commit: 91c830eb453e8ae65cf186247f7ef961f2275bc9
comment_subject: redeeming a raw share key hashes it, adds a shareKey edge, and collapses a link's keys and copies to one grant
source_authors: [Dan Carter, Kenton Varda, Kieran Hulsman, Phillip Jones]
ingested: 2026-08-24
ingested_by: scholar
topics: [collaborative-workspace-sharing, capability-security]
status: current
---

Redeeming a raw share key turns a bearer secret into a durable permission edge without ever storing the plaintext, and it minimizes RPC by only resolving a profile when a genuinely new collaborator must be created. Permission edges point at the *link*, not the individual key, so all of a link's keys (and any aliased copies of it) collapse to a single grant in the graph.

## Redemption path

`redeemShareKey` takes a raw key, a `profileId`, and a `fetchProfile` callback. It hashes the raw key internally (the plaintext is never stored) and looks up the key record; an unknown key does nothing. When the key exists, it ensures the user is a collaborator with a `shareKey` edge for its link, adding the edge if missing or creating the collaborator record if they are new. `fetchProfile` (an RPC in production) is invoked only when a brand-new collaborator must be created, so existing collaborators are redeemed with no RPC. A key whose link is revoked behaves like an unknown key and cannot be redeemed.

## Edges name the link, so keys and copies collapse

Because edges point at the link rather than the individual key, a link's multiple keys collapse to one grant. A *copy* of a link is an alias; redemption follows the alias to the link that owns the metadata. This is why revocation can delete a link's aliased copies outright (no edge ever names an alias) while keeping the link and its `shareKey` edges intact.

Source: [packages/workshop-backend/src/sharing.ts](https://github.com/cloudflare/cloudflare-os/blob/91c830eb453e8ae65cf186247f7ef961f2275bc9/packages/workshop-backend/src/sharing.ts) at commit `91c830eb45` (lines 208-229).
