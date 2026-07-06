---
title: Tiered access levels (L0–L3)
source: notes/privacy.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [ucan-authorization]
status: current
---

> Abstract: DialogDB's privacy RFC targets full infrastructure privacy (storage and coordination see no user data), tiered access, selective sharing, UCAN-style authorization, and user-chosen privacy/efficiency tradeoffs. It defines four monotone access levels, each strictly more revealing than the last: **L0 No Access** — blob store and mutable pointer handle fully-encrypted opaque blobs and references, deriving no value from data or metadata; **L1 Structure Access** — an actor can follow links between blobs (bundle a user's missing connected nodes for efficient sync) without seeing content or key ranges; **L2 Range Access** — an actor can see key ranges to validate Probabilistic-B-Tree structure and retrieve subtrees for selective replication, still without fact values; **L3 Data Access** — a collaborator can decrypt and query actual facts, with **group-based encryption** so different facts can be readable by different groups.

DialogDB implements a layered privacy model with four distinct, monotone access levels (each includes the ones below it):

**Level 0 — No Access** (the base infrastructure level):

- The **blob store** stores fully encrypted, opaque blobs with no knowledge of content or relationships.
- The **mutable pointer** manages references with no knowledge of what is referenced.
- No data visibility; infrastructure providers cannot derive any value from user data or metadata.
- Access only through proper authorization credentials.

**Level 1 — Structure Access** (limited structural visibility):

- **Blob traversal**: authorized actors can follow links between blobs.
- **Sync assistance**: an L1 actor can bundle all connected nodes a user is missing into a single compressed package, improving transfer efficiency without revealing content.
- No content or key-range insight; the only visibility is blob connectivity.

**Level 2 — Range Access** (tree-structure visibility):

- **Key-range awareness**: can see key ranges to verify proper tree structure.
- **Tree validation**: can validate the consistency of the Probabilistic B-Tree.
- **Range-based retrieval**: can retrieve subtrees covering specific key ranges (selective replication).
- Reveals some metadata (key distribution) but no actual fact values; allows server-side structural validation while keeping content private.

**Level 3 — Data Access** (content visibility with group-based access):

- **Fact decryption**: can decrypt and view actual facts, enabling full local querying.
- **Group-based encryption**: different facts can be encrypted for different access groups; members of one group cannot see facts encrypted for other groups.
- Primarily for collaborators who need to work with the actual data; fine-grained access control within L3 itself.

The layering means each delegation reveals strictly more, so an owner can hand a sync service L1, a validator L2, and a collaborator L3 (optionally group-scoped) from a single database.

Source: [notes/privacy.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/privacy.md) at commit `f777fe7c`.
