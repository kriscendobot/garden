---
title: Round-trip invariant
source: designs/daemon-locator-terminology.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bccee2841e52eb5e42ec5b5be4fcbe1e66d60a42
source_date: 2026-03-17
source_authors: [Kris Kowal]
topics: [daemon, persistence, capability-security]
status: current
parent: endo-but-for-bots--llm-designs-dlt--dehydration-and-hydration
---

If a locator is dehydrated and then hydrated with no intervening hint
change, the resulting locator is identical to the original. If hints
have changed in the interim, the hydrated locator reflects the **new**
hints; the formula key (and therefore the resource identity) is
unchanged.
