---
title: Confluence resource capability hierarchy
source: packages/gatekeeper-confluence/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 657aa96504f23fda775df46a5a6a95eaf135ec6d
source_date: 2026-08-17
source_authors: [Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, capability-security]
status: current
---

The Confluence Gatekeeper turns an account grant into three progressively narrower resource capabilities: a site, a space, or one page or blog post.

Site sessions search and open broadly, space sessions create and enumerate within one space, and content sessions edit one item and manage its labels, comments, attachments, and page-only children. One OAuth account can span several Atlassian sites, but URL resolution must pass through a single host-to-cloud-ID chokepoint that proves the selected site belongs to the connection. Pages and blog posts share a session type while retaining type-specific operations.

Source: [packages/gatekeeper-confluence/README.md](https://github.com/cloudflare/cloudflare-os/blob/657aa96504f23fda775df46a5a6a95eaf135ec6d/packages/gatekeeper-confluence/README.md) at commit `657aa965`.
