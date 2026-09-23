---
title: The `localKeys` set
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

The daemon maintains `localKeys`, a set of known local-agent public
keys, initialized with `localNodeNumber` (the daemon root key) and
extended each time a new agent is incarnated. The predicate
`isLocalKey(node)` returns `true` for any key in this set; all agents
share the same predicate so that a sibling agent's locator is correctly
recognized as local.
