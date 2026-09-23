---
title: Pass-invariant equality of Handles
source: designs/daemon-capability-persona.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security, agent-conventions, patterns]
status: current
parent: endo-but-for-bots--llm-designs-dcp--ai-delegates-connectors-and-anti-impersonation
---

Each connector maintains its own mapping from formula identifiers to
platform identifiers. The connector **guarantees pass-invariant
equality of Handles** — requesting a Handle for the same backing
identity returns the same formula identifier:

```js
const bobHandle1 = await E(slackConnector).handleFor('@bob');
const bobHandle2 = await E(slackConnector).handleFor('@bob');
// Same formula identifier — the agent can detect this via identify()
```

This lets the agent's directory reliably detect that two pet names
point to the same person. See [[pass-invariant-handle-equality]] for
the broader convention.
