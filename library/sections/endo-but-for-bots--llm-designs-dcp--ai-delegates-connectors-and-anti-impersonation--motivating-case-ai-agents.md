---
title: Motivating case — AI agents
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

AI coding agents today either *act as the user* (sending messages,
creating accounts, pushing code under the user's name) or *have no
external identity at all*. Both are problematic:

| Mode | Problem |
|---|---|
| **Acting as the user** | Enables impersonation. A prompt-injected agent sending Slack messages as "Alice" is indistinguishable from Alice herself. Other humans cannot tell they are interacting with an AI. |
| **No external identity** | Limits usefulness. An agent that cannot join a Slack channel, file a GitHub issue, or send an email cannot serve as an effective assistant for collaborative work. |

Delegates with epithets thread the needle: Alice creates Aifred with
epithet `(AI assistant to Alice)`. Aifred has external identity but
Aifred's Handle structurally carries the AI-ness claim, and anyone
Aifred messages can verify it directly with Alice.
