---
title: Supabase OAuth and approval boundary
source: packages/gatekeeper-supabase/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 657aa96504f23fda775df46a5a6a95eaf135ec6d
source_date: 2026-08-17
source_authors: [Maximo Guk, Yo'av Moshe]
ingested: 2026-08-24
ingested_by: scholar
topics: [oauth-credentials, capability-mediated-integrations]
status: current
---

Supabase uses an organization OAuth application's client credentials, while arbitrary mutating SQL remains approval-gated and intentionally unsimulated.

The registered callback is `${PUBLIC_BASE_URL}/gatekeeper/supabase/oauth`, with `http://localhost:8787/gatekeeper/supabase/oauth` as the local default. The authorization-code exchange requires the OAuth app's client ID and one-time-shown client secret, not a personal access token or project API key. Local development maps `SUPABASE_CLIENT_ID` and `SUPABASE_CLIENT_SECRET` into the Worker.

Reads become observations. Mutating `execute()` calls enter the approval queue and run only after approval. Because arbitrary statements cannot be previewed reliably through the stateless query endpoint, pending mutations do not overlay subsequent `query()` results.

Source: [packages/gatekeeper-supabase/README.md](https://github.com/cloudflare/cloudflare-os/blob/657aa96504f23fda775df46a5a6a95eaf135ec6d/packages/gatekeeper-supabase/README.md) at commit `657aa965`.
