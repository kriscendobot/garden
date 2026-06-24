---
title: Dehydration and hydration — stable formula keys vs ephemeral hints
source: designs/daemon-locator-terminology.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bccee2841e52eb5e42ec5b5be4fcbe1e66d60a42
source_date: 2026-03-17
source_authors: [Kris Kowal]
topics: [daemon, persistence, capability-security]
status: current
kind: index
section_count: 4
---

Locators bundle two things with different lifetimes: a stable formula
key (durable, content of pet store entries, references in formula
files) and ephemeral connection hints (current network addresses, may
change between sessions). The design *separates them at ingestion* and
*recombines them at presentation*.

Sections:

- [Dehydrate at ingestion](endo-but-for-bots--llm-designs-dlt--dehydration-and-hydration--dehydrate-at-ingestion.md)
- [Hydrate at presentation](endo-but-for-bots--llm-designs-dlt--dehydration-and-hydration--hydrate-at-presentation.md)
- [Round-trip invariant](endo-but-for-bots--llm-designs-dlt--dehydration-and-hydration--round-trip-invariant.md)
- [Why this matters](endo-but-for-bots--llm-designs-dlt--dehydration-and-hydration--why-this-matters.md)
