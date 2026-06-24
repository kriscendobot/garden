---
title: The caretaker for verification policy
source: designs/daemon-capability-persona.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security, patterns, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-dcp--verification-and-handle-extensions
---

The Host (or delegate-creator) may want to control verification
policy separately from the Handle itself. The **caretaker pattern**
applies (see [[caretaker-pattern]]):

| Facet | Holder | What it does |
|---|---|---|
| **Handle** | Delegate-held, publicly reachable | Carries epithets; supports `verify()` with whatever policy the creator set. |
| **HandleControl** | Creator-held | Updates verification policy (`confirm-all` / `deny-all` / `selective`); revokes the Handle entirely. |

The delegate holds its Handle but cannot influence how its principal's
Handle responds to verification queries about it. **Alice controls
whether she confirms Aifred's epithet, not Aifred.**

The split is the same identity/action facet split that connectors
rely on for credential custody (see
[[endo-but-for-bots--llm-designs-dcp--ai-delegates-connectors-and-anti-impersonation]]).
The delegate has the *action* facet (send messages); the principal
has the *identity* facet (decide what's confirmable).
