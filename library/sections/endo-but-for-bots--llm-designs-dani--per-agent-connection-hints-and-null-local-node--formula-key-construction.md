---
title: Formula key construction
source: designs/daemon-agent-network-identity.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 5ab5e48d80c5d925bcec2d142606d7555bfad7ed
source_date: 2026-03-18
source_authors: [Kris Kowal]
topics: [daemon, capability-security, patterns]
status: current
parent: endo-but-for-bots--llm-designs-dani--per-agent-connection-hints-and-null-local-node
---

```js
// Local formula key (stored on disk)
const localId = formatId({ number: formulaNumber, node: LOCAL_NODE });

// Locator for external consumption (agent-specific)
const locator = formatId({
  number: formulaNumber,
  node: agentPublicKey,
});
```
