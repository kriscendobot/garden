---
title: OAuth connect and refresh flow
source: packages/gatekeeper-confluence/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 657aa96504f23fda775df46a5a6a95eaf135ec6d
source_date: 2026-08-17
source_authors: [Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, oauth-credentials, cloudflare-workers-agent-hosting]
status: current
---

The Confluence connect flow uses a two-phase nonce and a per-account Durable Object to carry authorization from initiation through callback without exposing a reusable public attempt identifier.

After code exchange, the Gatekeeper records rotating access and refresh tokens, all accessible Confluence sites with their cloud IDs, and the authorizing identity. Calls route through Atlassian's cloud-ID gateway. Access tokens refresh proactively before expiry and retry once after a 401, and every refresh persists the newly rotated refresh token so the Durable Object never falls back to a spent credential.

Source: [packages/gatekeeper-confluence/README.md](https://github.com/cloudflare/cloudflare-os/blob/657aa96504f23fda775df46a5a6a95eaf135ec6d/packages/gatekeeper-confluence/README.md) at commit `657aa965`.
