---
source: doc/design/membertable-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-25
ingested_by: scholar
section_count: 2
status: current
---

> Abstract: The member table is the persistent structure under the CASK root that gates session establishment: it answers "is this 32-byte `node_id` in the set?" Only members may complete `ini6`. It reuses the session table's parallel-array shape (minus expiry/data columns): a swap-to-end allocator, a `keys` array of node_ids, a `byKey` hashtreetouint64 index, and a `trafficClasses` uint8array, with operations `Has`/`Add`/`AddWithTrafficClass`/`Remove`/`Get-SetTrafficClass`/`ForEach`. It is driven by the `cask member add|rm|set-traffic-class|ls` CLI directly against the tip file and store, threaded through the CASK root's membership link (`Links[2]`, ZeroHash when empty) via `GetMembershipRoot`/`SetMembershipRoot`, and consulted by the server on each `ini6` (absent → `statusNotMember`, no session). This iteration keeps no in-memory cache; every `Has()` hits the store.

| Section | Topics | Status |
|---------|--------|--------|
| [structure-and-operations](../sections/cask--membertable-design--structure-and-operations.md) | networking, capability-security, content-addressed-storage, data-structures | current |
| [cli-root-and-server-integration](../sections/cask--membertable-design--cli-root-and-server-integration.md) | networking, capability-security, content-addressed-storage | current |
