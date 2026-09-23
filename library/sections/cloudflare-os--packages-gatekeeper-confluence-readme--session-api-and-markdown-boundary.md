---
title: Session API and Markdown boundary
source: packages/gatekeeper-confluence/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 657aa96504f23fda775df46a5a6a95eaf135ec6d
source_date: 2026-08-17
source_authors: [Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, agent-workspaces]
status: current
---

The Confluence capability surface follows resource granularity while translating page and blog bodies between agent-friendly Markdown and Atlassian storage-format XHTML.

Site, space, and content sessions expose only the operations appropriate to their selected resource. Content methods cover metadata, body and title changes, children, labels, comments, attachments, and lifecycle actions, with attachment downloads bounded to 16 KB. Conversion is best-effort and represents unsupported macros as labeled placeholders, making lossy provider boundaries visible instead of silently discarding them.

Source: [packages/gatekeeper-confluence/README.md](https://github.com/cloudflare/cloudflare-os/blob/657aa96504f23fda775df46a5a6a95eaf135ec6d/packages/gatekeeper-confluence/README.md) at commit `657aa965`.
