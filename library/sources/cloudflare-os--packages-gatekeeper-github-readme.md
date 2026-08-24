---
source: packages/gatekeeper-github/README.md
source_repo: cloudflare/cloudflare-os
source_commit: d85c36ba295361c5661847417fe65c72bd374f04
source_date: 2026-06-14
source_authors: [Kenton Varda, Phillip Jones, "Yo'av Moshe"]
ingested: 2026-08-24
ingested_by: scholar
section_count: 3
status: current
---

The GitHub Gatekeeper README distinguishes transient verified-email login from persisted repository access, explains why that split requires a GitHub OAuth App, and records the credential and callback setup.

| Section | Topics | Status |
|---|---|---|
| [identity grant versus resource grant](../sections/cloudflare-os--packages-gatekeeper-github-readme--identity-grant-versus-resource-grant.md) | authentication-gatekeepers, identity, capability-mediated-integrations, oauth-credentials | current |
| [OAuth App permission model](../sections/cloudflare-os--packages-gatekeeper-github-readme--oauth-app-permission-model.md) | authentication-gatekeepers, oauth-credentials, capability-security | current |
| [credential and callback setup](../sections/cloudflare-os--packages-gatekeeper-github-readme--credential-and-callback-setup.md) | oauth-credentials, cloudflare-workers-agent-hosting | current |
