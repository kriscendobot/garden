---
title: Database repair
source: designs/daemon-locator-terminology.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bccee2841e52eb5e42ec5b5be4fcbe1e66d60a42
source_date: 2026-03-17
source_authors: [Kris Kowal]
topics: [daemon, capability-security, patterns]
status: current
parent: endo-but-for-bots--llm-designs-dlt--local-node-sentinel
---

Pet-store entries created before the LOCAL_NODE migration contain
`{number}:{localNodeNumber}` identifiers. A startup repair pass
(`repairIds`) rewrites these to `{number}:{LOCAL_NODE}` in both
in-memory state and on-disk files. The `normalizeId` helper in
`daemon.js` also transparently rewrites old-format identifiers
encountered in formula dependency references at read time, so formula
files themselves do not need rewriting — repair is on-touch.

The whole sentinel-plus-localKeys-set scheme is a worked example of
the **stable internal id, externalized per identity** pattern that
recurs across the daemon — see also the formula-key/peer-key split in
[[endo-but-for-bots--llm-designs-dlt--terminology-rename]] and the
peer-mirror/local-set asymmetry in
[[endo-but-for-bots--llm-designs-dcpg--retention-set-model]].
