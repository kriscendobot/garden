---
title: Supabase project and organization resource grants
source: packages/gatekeeper-supabase/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 657aa96504f23fda775df46a5a6a95eaf135ec6d
source_date: 2026-08-17
source_authors: [Maximo Guk, Yo'av Moshe]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, cloudflare-workers-agent-hosting]
status: current
---

The Supabase Gatekeeper prefers a project-shaped capability for one hosted database and its adjacent services, while retaining a broader organization capability for cross-project discovery and operations.

A project resource is identified by its Supabase dashboard project URL and covers read-only or approval-gated SQL, schema introspection, edge-function listing, and storage-bucket listing. An organization resource is identified by its organization dashboard URL and reaches every project in that organization. The connected account corresponds to the organization selected during OAuth consent.

Source: [packages/gatekeeper-supabase/README.md](https://github.com/cloudflare/cloudflare-os/blob/657aa96504f23fda775df46a5a6a95eaf135ec6d/packages/gatekeeper-supabase/README.md) at commit `657aa965`.
