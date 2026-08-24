---
title: Collaborator resource isolation
source: docs/sharing.md
source_repo: cloudflare/cloudflare-os
source_commit: 814bdc7ebe2454067b4c48e195fccd37979bb0aa
source_date: 2026-08-03
source_authors: [Phillip Jones, Kenton Varda, Dan Carter]
ingested: 2026-08-24
ingested_by: scholar
topics: [collaborative-workspace-sharing, capability-mediated-integrations]
status: current
---

Collaborators share gadget code, storage, and chat history while retaining separate authority over model credentials and third-party accounts.

An AI model binding stores the configuration of the user who created it, so billing and credentials follow the person who prompted the model. Agent spawners record the creating User Durable Object ID and resolve the model from that account at trigger time.

Gatekeeper bindings likewise connect through the account of the collaborator who creates them rather than through the gadget owner's account. Sharing a gadget therefore does not implicitly share a collaborator's unrelated external accounts.

Source: [docs/sharing.md](https://github.com/cloudflare/cloudflare-os/blob/814bdc7ebe2454067b4c48e195fccd37979bb0aa/docs/sharing.md) at commit `814bdc7e`.
