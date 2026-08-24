---
title: Dual-scope OAuth and API versions
source: packages/gatekeeper-confluence/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 657aa96504f23fda775df46a5a6a95eaf135ec6d
source_date: 2026-08-17
source_authors: [Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, oauth-credentials]
status: current
---

Confluence integration needs both granular and classic OAuth scopes because its primary v2 API and the remaining v1-only operations reject each other's scope family.

Spaces, pages, blog posts, child pages, and most reads use v2 with granular scopes. CQL search, label writes, attachment upload, restore, and related reads still fall back to v1 with classic scopes and degrade explicitly if Atlassian removes those endpoints. Identity and offline refresh add account-level scopes. The OAuth application's permission set therefore mirrors a split provider surface rather than one coherent API generation.

Source: [packages/gatekeeper-confluence/README.md](https://github.com/cloudflare/cloudflare-os/blob/657aa96504f23fda775df46a5a6a95eaf135ec6d/packages/gatekeeper-confluence/README.md) at commit `657aa965`.
