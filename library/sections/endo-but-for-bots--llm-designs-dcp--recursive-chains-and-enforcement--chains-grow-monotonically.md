---
title: Chains grow monotonically
source: designs/daemon-capability-persona.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security, patterns]
status: current
parent: endo-but-for-bots--llm-designs-dcp--recursive-chains-and-enforcement
---

When a delegate creates its own subordinate, the subordinate
**inherits the delegate's entire epithet chain and must add at least
one new epithet** describing its relationship to the delegate. The
chain grows monotonically — it can never shrink.

```
Alice creates Aifred:
  Aifred's epithets: [(assistant to Alice)]

Aifred creates Jarvis:
  Jarvis's epithets: [(majordomo of Aifred), (assistant to Alice)]

Jarvis creates Minion:
  Minion's epithets: [(worker for Jarvis), (majordomo of Aifred), (assistant to Alice)]
```

The composite epithet reads naturally left to right as a chain of
delegation: *Minion is a worker for Jarvis, who is a majordomo of
Aifred, who is an assistant to Alice.* Each link is independently
verifiable by asking the referenced Handle.
