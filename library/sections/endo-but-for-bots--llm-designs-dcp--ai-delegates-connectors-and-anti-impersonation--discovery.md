---
title: Discovery
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

When a delegate starts up, it discovers its identity through standard
operations:

```js
const myHandle = await E(powers).lookup('@self');
const myEpithets = await E(myHandle).epithets();
// [(AI assistant to aliceHandle)]
```

The delegate's system prompt (for an LLM-backed agent) should include
its epithet chain:

```
## Your Identity
You are Aifred (AI assistant to Alice Chen).
You can send messages to: bob, carol, design-channel.
All messages carry your epithet chain. You cannot suppress it.
```

The same `@self` lookup pattern used elsewhere in the daemon (see
[[endo-but-for-bots--llm-designs-d256--per-agent-keypairs]] for
`@keypair`, `@self`, `@host`, `@agent`, `@main`, `@endo`) is what
makes self-introspection a normal capability rather than a
privileged one.
