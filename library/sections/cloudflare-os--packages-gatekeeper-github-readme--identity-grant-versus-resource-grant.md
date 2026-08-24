---
title: Identity grant versus resource grant
source: packages/gatekeeper-github/README.md
source_repo: cloudflare/cloudflare-os
source_commit: d85c36ba295361c5661847417fe65c72bd374f04
source_date: 2026-06-14
source_authors: [Kenton Varda, Phillip Jones, "Yo'av Moshe"]
ingested: 2026-08-24
ingested_by: scholar
topics: [authentication-gatekeepers, identity, capability-mediated-integrations, oauth-credentials]
status: current
---

GitHub sign-in and GitHub resource access deliberately use different grants: login reads a verified email with transient minimal scopes, while an explicit connection persists broader repository authority.

When enabled by `AUTH_GATEKEEPERS`, sign-in requests `read:user user:email`, derives identity from the primary verified address, and discards the grant. Connecting GitHub requests `repo read:user user:email`, then attenuates gadget access to a selected repository, issue, or pull request. The same provider account can therefore authenticate a user without silently becoming a general repository capability.

Source: [packages/gatekeeper-github/README.md](https://github.com/cloudflare/cloudflare-os/blob/d85c36ba295361c5661847417fe65c72bd374f04/packages/gatekeeper-github/README.md) at commit `d85c36ba`.
