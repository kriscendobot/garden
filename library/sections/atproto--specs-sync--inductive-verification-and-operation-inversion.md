---
title: "Inductive verification: operation inversion as a chain of consistency checks"
source_kind: web
source_url: https://atproto.com/specs/sync
source_content_sha256: 89ca28398c1c5f6353ed17ca7c5c521f0970f9a1f94118647c7f6c1984044105
source_authors: [Bluesky Social PBC]
source_date: 2026-07-29
retrieved: 2026-07-29
ingested: 2026-07-29
ingested_by: scholar
topics: [content-addressed-storage, local-first-sync]
status: current
---

> Abstract: The design argument for why a consumer does not need to hold the whole Merkle Search Tree. Holding a full copy and re-verifying the tree per commit is "resource intensive in both compute and storage, and unrealisticly expensive at scale", so instead each `#commit` is checked against the *previous* state, "creating a chain of verification. Only a small amount of state needs to be stored for each repository" — just the revision and the tree root. The mechanism is **record operation inversion**: apply the claimed `ops` in reverse against the partial tree in the diff blocks, and the recomputed root should be exactly the previous commit's `data` field. The honest caveat is stated too: `since` and `prevData` "are neither authenticated (signed) nor self-certifying", so they check internal consistency, not authenticity.

> "If a service receives and processes every `#commit` message from a repository, it should have a complete and coherent view of all records in the repository. If messages are missing or mangled, the receiving service might have an incomplete or incorrect view of some records. How can a service be confident it has successfully synchronized a complete repository?"

> "If the receiving service maintained a full copy of the repository data structure (MST), it could apply the diff from each `#commit` and verify the integrity of the complete tree structure. But this process is resource intensive in both compute and storage, and unrealisticly expensive at scale."

> "Instead, receiving services can verify that each `#commit` diff is consistent with the previous state of the repository, creating a chain of verification. Only a small amount of state needs to be stored for each repository."

## Operation inversion

> "The trick to this process is record operation inversion. `#commit` messages contain both a repo diff (CAR slice), and an array of record operations. The operations can be applied in reverse against a copy of the partial repo tree contained in the diff blocks. If the list of operations is complete, the root of the tree should be exactly that of the previous commit object of the repository. Note that the tree root (`data` field) is different from the hash of the signed commit object itself. The `#commit` message contains both a reference to the previous repo revision (in the `since` field), and a copy of the previous root tree hash (in the `prevData` field). Those fields are neither authenticated (signed) nor self-certifying, but they can be used to check the consistency of the `#commit` message in isolation."

> "To check that the 'chain' of messages is consistent, receiving services should track the repo revision and tree root (`data`) for each repository. If a `#commit` message is received which is internally consistent, but the `since` and `prevData` references do not match the previous state of the repository, then something has gone wrong."

## Recovery, and the thundering herd

> "If the chain of `#commit` messages is found to have broken, or a `#sync` message indicates that the repository state has changed, then the service will need to re-synchronize the repository. This often means fetching the full repo CAR export."

> "If many services attempt to re-synchronize a repository at the same time, the upstream PDS host may be overwhelmed with a 'thundering herd' of requests. To mitigate this, receiving services should first attempt to fetch the repo CAR file from their direct upstream (often a relay instance). That gives the upstream an opportunity to coalesce and cache the repository export, which distributes load. The upstream may instead simply use an HTTP redirect to the PDS instance."

Content addressing is what makes the coalescing safe: a relay's cached CAR is verifiable against the same root the PDS would have served, so caching a copy of an authenticated export costs nothing in trust.

Source: [https://atproto.com/specs/sync](https://atproto.com/specs/sync), content SHA-256 `89ca2839`.
