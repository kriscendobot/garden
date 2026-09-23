---
title: Credential custody
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

The daemon holds credentials on behalf of connectors. **The delegate
never sees raw tokens, API keys, or passwords.** It holds Handles
that interact with connectors that use credentials internally:

```
Credential Store (daemon-internal, connector-scoped)
 ├─ "aifred/slack/bot-token"  → "xoxb-..."   (held by Slack connector)
 ├─ "aifred/google/svc-key"   → "{...}"      (held by Google connector)

Delegate's directory (pet names):
 ├─ "bob"              → Handle (Slack connector resolves to @bob)
 ├─ "design-channel"   → Handle (Slack connector resolves to #design)
 ├─ "carol"            → Handle (Google connector resolves to carol@acme.com)
    ↑ all Handles — delegate never touches credentials
```

This is the **structural confinement** that the pet-name directory
already provides, applied to credentials at the connector boundary:
the delegate operates on names, the connector operates on tokens,
neither sees the other's tier.
