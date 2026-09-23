---
title: Epithet
source: designs/daemon-capability-persona.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security, patterns]
status: current
parent: endo-but-for-bots--llm-designs-dcp--delegates-and-epithets
---

An **epithet** is a structured claim carried by a Handle:

```js
Epithet = {
  relationship: string,       // e.g., "assistant", "majordomo", "ci-runner"
  principal: Handle,          // the Handle this relationship is relative to
}
```

An epithet says: *"this Handle stands in the named relationship to
that Handle."* The relationship is human-meaningful — it describes
how the delegate relates to its principal in terms that a person (or
an LLM) can understand.
