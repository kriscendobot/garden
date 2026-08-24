---
title: Verified-email login and resource scopes
source: packages/gatekeeper-google/README.md
source_repo: cloudflare/cloudflare-os
source_commit: bead5469d7fc4d53adbcf0e942c9f4f34e913ac9
source_date: 2026-07-23
source_authors: [Kenton Varda, Phillip Jones, "Yo'av Moshe", byule@cloudflare.com]
ingested: 2026-08-24
ingested_by: scholar
topics: [authentication-gatekeepers, identity, capability-mediated-integrations, oauth-credentials]
status: current
---

Google sign-in uses a transient verified-email grant, while each connected Google resource requests only its own API scopes from the same OAuth client.

Login asks for OpenID, email, and profile identity scopes and accepts the address only when Google reports `email_verified`. Connections add Gmail, Docs, Sheets, Calendar, or BigQuery authority according to the selected resource rather than requesting every integration at once. Identity scopes remain present so the account can be named consistently, but the capability-bearing resource grant is explicit and granular.

Source: [packages/gatekeeper-google/README.md](https://github.com/cloudflare/cloudflare-os/blob/bead5469d7fc4d53adbcf0e942c9f4f34e913ac9/packages/gatekeeper-google/README.md) at commit `bead5469`.
