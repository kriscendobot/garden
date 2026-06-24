---
title: Locator and storage path formats
source: designs/daemon-256-bit-identifiers.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security, patterns]
status: current
parent: endo-but-for-bots--llm-designs-d256--identifier-migration-and-crypto-powers
---

The **locator format is unchanged** by this migration (only the
identifier sizes within it shrink):

```
endo://{64-char node}/?id={64-char number}&type={type}
```

The locator URL **shape** changes later in the design line, in the
locator-terminology rename
([[endo-but-for-bots--llm-designs-dlt--locator-format-evolution]]).

Storage paths split off the first two hex chars as a directory shard
for filesystem-friendly fan-out:

```
{statePath}/formulas/{head(2)}/{tail(62)}.json
```
