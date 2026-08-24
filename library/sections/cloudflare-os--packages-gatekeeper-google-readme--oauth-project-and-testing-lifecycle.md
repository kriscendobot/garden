---
title: OAuth project and testing lifecycle
source: packages/gatekeeper-google/README.md
source_repo: cloudflare/cloudflare-os
source_commit: bead5469d7fc4d53adbcf0e942c9f4f34e913ac9
source_date: 2026-07-23
source_authors: [Kenton Varda, Phillip Jones, "Yo'av Moshe", byule@cloudflare.com]
ingested: 2026-08-24
ingested_by: scholar
topics: [oauth-credentials, cloudflare-workers-agent-hosting]
status: current
---

A local Google Gatekeeper needs an enabled API set, an external consent screen, an allowlisted test user, a Web OAuth client, and a callback whose origin matches the deployment.

The consent-screen configuration need not predeclare scopes during development because authorization requests carry them. Testing-mode accounts must be enrolled explicitly and receive Google's unverified-app warning. The Web client redirects to `/gatekeeper/google/oauth`; its ID and secret stay in the package's ignored `.env`. Most setup failures reduce to an exact redirect mismatch, a missing test user or denied consent, invalid credentials, or provider quota and project status.

Source: [packages/gatekeeper-google/README.md](https://github.com/cloudflare/cloudflare-os/blob/bead5469d7fc4d53adbcf0e942c9f4f34e913ac9/packages/gatekeeper-google/README.md) at commit `bead5469`.
