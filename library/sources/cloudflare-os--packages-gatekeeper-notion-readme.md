---
source: packages/gatekeeper-notion/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 657aa96504f23fda775df46a5a6a95eaf135ec6d
source_date: 2026-08-17
source_authors: [Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
section_count: 2
status: current
---

The Notion Gatekeeper README covers OAuth-mediated access to a user's Notion pages and databases at workspace or per-page granularity, and the connector's approval model where reads simulate a Gadget's own pending writes and the newer data-source split is hidden behind per-operation API versions.

| Section | Topics | Status |
|---|---|---|
| [Notion workspace, page, and database resources](../sections/cloudflare-os--packages-gatekeeper-notion-readme--workspace-page-and-database-resources.md) | capability-mediated-integrations, oauth-credentials, cloudflare-workers-agent-hosting | current |
| [Notion approvals, write simulation, and the data-source split](../sections/cloudflare-os--packages-gatekeeper-notion-readme--approvals-simulation-and-data-sources.md) | capability-mediated-integrations, cloudflare-workers-agent-hosting | current |
