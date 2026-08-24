---
title: Multi-site resource pickers
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

Confluence resource selection treats pasted URLs, agent connection requests, and interactive pickers as entrances to the same site-aware capability selection flow.

Space and content pickers search across every site accessible to a connected Atlassian account, and each option carries its originating site identity. Pasted URLs prefill the same configurator and still pass through site resolution. The UI therefore avoids accidentally binding a same-shaped page from the wrong tenant when one OAuth grant spans multiple Confluence sites.

Source: [packages/gatekeeper-confluence/README.md](https://github.com/cloudflare/cloudflare-os/blob/657aa96504f23fda775df46a5a6a95eaf135ec6d/packages/gatekeeper-confluence/README.md) at commit `657aa965`.
