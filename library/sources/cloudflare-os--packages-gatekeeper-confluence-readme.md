---
source: packages/gatekeeper-confluence/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 657aa96504f23fda775df46a5a6a95eaf135ec6d
source_date: 2026-08-17
source_authors: [Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
section_count: 8
status: current
---

The Confluence Gatekeeper provides site-, space-, and content-scoped capabilities over a mixed-version Atlassian API, with rotating OAuth credentials, Markdown translation, deferred-action simulation, and multi-site selection.

| Section | Topics | Status |
|---------|--------|--------|
| [Confluence resource capability hierarchy](../sections/cloudflare-os--packages-gatekeeper-confluence-readme--resource-capability-hierarchy.md) | capability-mediated-integrations, capability-security | current |
| [Dual-scope OAuth and API versions](../sections/cloudflare-os--packages-gatekeeper-confluence-readme--dual-scope-oauth-and-api-versions.md) | capability-mediated-integrations, oauth-credentials | current |
| [Confluence credential and deployment configuration](../sections/cloudflare-os--packages-gatekeeper-confluence-readme--credential-and-deployment-configuration.md) | oauth-credentials, cloudflare-workers-agent-hosting | current |
| [OAuth connect and refresh flow](../sections/cloudflare-os--packages-gatekeeper-confluence-readme--oauth-connect-and-refresh-flow.md) | capability-mediated-integrations, oauth-credentials, cloudflare-workers-agent-hosting | current |
| [Session API and Markdown boundary](../sections/cloudflare-os--packages-gatekeeper-confluence-readme--session-api-and-markdown-boundary.md) | capability-mediated-integrations, agent-workspaces | current |
| [Deferred actions and simulation](../sections/cloudflare-os--packages-gatekeeper-confluence-readme--deferred-actions-and-simulation.md) | capability-mediated-integrations, agent-workspaces, capability-security | current |
| [Multi-site resource pickers](../sections/cloudflare-os--packages-gatekeeper-confluence-readme--multi-site-resource-pickers.md) | capability-mediated-integrations, agent-workspaces | current |
| [Limitations and verification](../sections/cloudflare-os--packages-gatekeeper-confluence-readme--limitations-and-verification.md) | capability-mediated-integrations, testing | current |
