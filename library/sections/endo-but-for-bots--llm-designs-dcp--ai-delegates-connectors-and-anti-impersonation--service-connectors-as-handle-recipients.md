---
title: Service connectors as Handle recipients
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

A **service connector** is a plugin that bridges Endo Handles to an
external platform. From the agent's perspective, a connector is just
another pet name in its directory — a Handle it can `send()` messages
to. The agent uses the standard mail API; the connector translates
Endo mail into platform API calls:

```
Agent calls:
  E(agent).send("design-channel", ["Bug fixed in abc123"], [], [])

The agent's directory resolves "design-channel" to a Handle backed by
the Slack connector.  The connector:
  1. Receives the envelope via its Handle's receive()
  2. Opens and validates the message via E(senderHandle).open(envelope)
  3. Reads the sender's epithet chain via E(senderHandle).epithets()
  4. Renders the epithet chain into platform disclosure
  5. Posts to #design via the Slack API using the stored bot token
```

No platform-specific methods on the agent side. The connector is the
boundary translation layer.
