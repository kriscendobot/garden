---
title: Anti-impersonation by construction
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

The invariant: **every externally visible action taken through a
delegate's Handle carries its epithet chain.** This follows from
three properties:

1. **Epithets are immutable.** Set at Handle creation, stored in the
   formula, not modifiable by the delegate.
2. **Credentials are custodied.** The delegate never holds raw
   tokens. The connector does, and the connector reads the epithet
   chain before forwarding.
3. **Profile editing is separated.** The connector controls the
   external account's profile (display name, bio, avatar). The
   delegate holds only the *action* facet — it can send messages but
   cannot modify identity fields. This is the **identity / action
   facet split**, expressed through the Handle / HandleControl
   caretaker pattern (see
   [[endo-but-for-bots--llm-designs-dcp--verification-and-handle-extensions]]).

> *A prompt-injected agent with full control of its delegate powers
> still cannot send a message without its epithet chain, because the
> epithet is not something the agent adds — it is something the
> Handle is.*
