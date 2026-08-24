---
source: packages/gatekeeper-slack/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 657aa96504f23fda775df46a5a6a95eaf135ec6d
source_date: 2026-08-17
source_authors: [Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
section_count: 2
status: current
---

The Slack Gatekeeper README covers read-only mediation of a user's Slack workspace through a user token scoped so the agent sees exactly what the user can, and the three grant granularities (workspace, conversation, thread) whose URL patterns drive both OAuth scope requests and a conversation-scoped search hard-restriction.

| Section | Topics | Status |
|---|---|---|
| [Slack read-only mediation and user-token scopes](../sections/cloudflare-os--packages-gatekeeper-slack-readme--read-only-user-token-auth.md) | capability-mediated-integrations, oauth-credentials, cloudflare-workers-agent-hosting | current |
| [Slack resource granularities and session API](../sections/cloudflare-os--packages-gatekeeper-slack-readme--resource-granularities-and-api.md) | capability-mediated-integrations, cloudflare-workers-agent-hosting | current |
