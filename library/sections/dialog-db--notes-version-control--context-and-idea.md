---
title: Context and idea (edition/origin causal encoding)
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

> Abstract: The [divergence-clock] design encodes causal position as `{since, at, drift}` for cheap concurrency detection, but its `since` counter is *local to one repository's sync history* — `since: 3` from repo A is incommensurable with `since: 3` from repo B, so cross-repo merges would force renumbering (losing provenance) or accepting incomparable clocks. This design instead derives causal position from the **revision DAG** directly: a revision's **Edition** is the count of revisions in its causal chain (incremented locally, advanced to `max(seen)+1` on sync) — isomorphic to a Lamport timestamp, so a higher edition has seen at least as much history regardless of repository. Edition alone can collide across authors, so it is paired with **Origin** = `Blake3(issuer + subject)` (both signing key and repository DID, so one principal on two repos yields two origins). Together `Origin`+`Edition` form a **Version** that sorts by causal depth and uniquely addresses any revision across all repositories.

The [divergence-clock] design encodes causal position as `{ since, at, drift }` where `since` increments at synchronization points, enabling cheap concurrency detection: two changes with the same `since` and different `at` values are concurrent by inspection, no traversal required. This works well for a single collaborative repository, but the `since` counter is local to a repo's synchronization history — there is no meaningful way to compare `since: 3` from repo A with `since: 3` from repo B, since they count different sync events. A cross-repo merge would require renumbering one history (losing provenance) or accepting that the clock values are incommensurable. A desired property of Dialog's collaboration model is that **forks and follows work as first-class operations across independent repositories**.

**Idea.** Instead of deriving causal position from a logical counter, derive it from the structure of the revision DAG directly. Every revision has a natural position: the count of revisions in the causal chain leading to it — its **Edition**. An author increments their edition with each local revision and advances it to `max(seen) + 1` on sync. This is isomorphic to a Lamport timestamp: a higher edition has seen at least as much causal history as any lower one, regardless of which repository it came from.

Edition alone cannot identify a revision globally (two authors could independently reach the same edition), so it is paired with **Origin**, a repository-scoped identity derived as `Blake3(issuer + subject)`. Deriving origin from both the signing key and the repository DID ensures the same principal acting on two different repositories produces two distinct origins, preventing colliding identifiers when independent repositories later merge. Together, `Origin` and `Edition` form a **Version**: a compact revision identifier that sorts naturally by causal depth and uniquely addresses any revision across all repositories.

[divergence-clock]: https://github.com/dialog-db/dialog-db/blob/682d4dcf2353874585ebc1444449e99df9bd39b0/notes/divergence-clock.md

Source: [notes/version-control.md](https://github.com/dialog-db/dialog-db/blob/682d4dcf2353874585ebc1444449e99df9bd39b0/notes/version-control.md) at commit `682d4dcf`.
