---
title: Two-tier conflict detection
source: notes/version-control.md
source_repo: dialog-db/dialog-db
source_commit: 682d4dcf2353874585ebc1444449e99df9bd39b0
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [local-first-sync, change-propagation]
status: current
---

> Abstract: When two claims A and B conflict on the same `(entity, attribute)`, resolution proceeds in tiers. **Tier 1 (direct cause check, O(1))**: if B's version is in A's `cause`, A supersedes B (and vice versa); else Tier 2. **Tier 2 (cause-chain traversal, O(k))**: follow the *higher-edition* claim's `cause` chain backward (it may have seen the lower; the lower cannot have seen a higher edition), looking for the lower claim's version — found = superseded; reaching an edition below the other's = concurrent; chain exhausted = concurrent. Traversal is bounded by k, the writes to that specific `(entity, attribute)`, not total history. **Incomplete replication** blocks resolution until missing claims arrive — expected for a partial replica. Worked example: Alice's `A:2` and Bob's `B:1` at the same edition-1 ancestor with different origins are concurrent; after Bob pulls and commits `B:3` with `A:2` in its cause, any later Bob claim supersedes Alice's via Tier 1.

When two claims A and B conflict on the same `(entity, attribute)`, resolution proceeds in tiers.

**Tier 1: Direct cause check, O(1):**
- If B's version is in A's `cause`, A supersedes B.
- If A's version is in B's `cause`, B supersedes A.
- If neither, proceed to Tier 2.

**Tier 2: Cause chain traversal, O(k):** follow the higher-edition claim's `cause` chain backward through the history index, looking for the lower-edition claim's version. Edition comparison bounds and guides the traversal:
- Found the other claim's version in the chain: superseded.
- Reached a claim whose edition is less than the other claim's edition: concurrent, stop.
- Chain exhausted: concurrent.

The traversal is bounded by k, the number of writes to that specific `(entity, attribute)`, not the total revision history; in practice k is small since most attributes are written infrequently.

**Incomplete replication:** if the cause chain is incomplete due to missing claims, causal ordering cannot be determined locally, and resolution blocks until the missing claims are replicated. This is expected: a partial replica does not have enough information to resolve conflicts it has not fully received.

**Illustrated.** Two authors work independently from the same revision, then sync — Alice makes two revisions, Bob one, then Bob pulls Alice's work before committing again:

| Author | Action | Edition |
|--------|--------|---------|
| Alice | commit | 1 |
| Alice | commit | 2 |
| Bob | commit | 1 |
| Alice | push | 2 |
| Bob | pull | max(2, 1) + 1 = 3, counter advances |
| Bob | commit | 3 |
| Bob | push | 3 |

When Alice's `A:2` and Bob's `B:1` meet during sync, neither version appears in the other's `cause`. Following Tier 2, we traverse `A:2`'s cause chain backward (checking the higher edition because it may have seen the lower one, while the lower cannot have seen a higher edition). The chain contains only `A:1` at edition 1, which matches `B:1`'s edition but has a different origin — neither is an ancestor of the other, so they are concurrent. After Bob pulls and commits `B:3`, his `cause` contains `A:2`'s version, so any subsequent Bob claim on an attribute Alice also wrote supersedes hers via the Tier 1 O(1) check.

Source: [notes/version-control.md](https://github.com/dialog-db/dialog-db/blob/682d4dcf2353874585ebc1444449e99df9bd39b0/notes/version-control.md) at commit `682d4dcf`.
