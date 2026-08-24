---
title: OAuth App permission model
source: packages/gatekeeper-github/README.md
source_repo: cloudflare/cloudflare-os
source_commit: d85c36ba295361c5661847417fe65c72bd374f04
source_date: 2026-06-14
source_authors: [Kenton Varda, Phillip Jones, "Yo'av Moshe"]
ingested: 2026-08-24
ingested_by: scholar
topics: [authentication-gatekeepers, oauth-credentials, capability-security]
status: current
---

Cloudflare OS recommends a GitHub OAuth App because request-time scopes preserve the minimal-login/full-connection split; a GitHub App fixes permissions globally and cannot reproduce that attenuation.

An OAuth App honors the `scope` parameter and can request `user:email` only when identity is needed. A GitHub App client ignores that parameter: reading verified email requires the App-wide Email addresses permission, existing users must re-authorize after it is added, and every authorization carries the configured permission set. The provider object called an “App” is therefore materially different from OAuth's authorization-code application model for this design.

Source: [packages/gatekeeper-github/README.md](https://github.com/cloudflare/cloudflare-os/blob/d85c36ba295361c5661847417fe65c72bd374f04/packages/gatekeeper-github/README.md) at commit `d85c36ba`.
