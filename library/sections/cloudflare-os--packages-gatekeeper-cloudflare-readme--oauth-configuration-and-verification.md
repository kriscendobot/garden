---
title: OAuth configuration and verification
source: packages/gatekeeper-cloudflare/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 1931a1b175d52ed88109d880b90e23d130cca2ad
source_date: 2026-08-18
source_authors: [Nathan Disidore]
ingested: 2026-08-24
ingested_by: scholar
topics: [authentication-gatekeepers, oauth-credentials, cloudflare-workers-agent-hosting]
status: current
---

Cloudflare OAuth deployment requires an exact Gatekeeper callback URL, package-local client credentials, and an explicit distinction between enabling sign-in, AI billing, and Observability scopes.

Local development defaults to `/gatekeeper/cloudflare/oauth`; production substitutes the public base URL without changing the callback suffix. Package-local credentials take precedence over root development variables. `AUTH_GATEKEEPERS` controls sign-in button availability and order, while billing and observability add their own configuration and scopes. Redirect mismatch and missing-credential failures are intentionally diagnosable as setup errors rather than generic authorization failures.

Source: [packages/gatekeeper-cloudflare/README.md](https://github.com/cloudflare/cloudflare-os/blob/1931a1b175d52ed88109d880b90e23d130cca2ad/packages/gatekeeper-cloudflare/README.md) at commit `1931a1b1`.
