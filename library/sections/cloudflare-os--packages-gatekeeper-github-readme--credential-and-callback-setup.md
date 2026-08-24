---
title: Credential and callback setup
source: packages/gatekeeper-github/README.md
source_repo: cloudflare/cloudflare-os
source_commit: d85c36ba295361c5661847417fe65c72bd374f04
source_date: 2026-06-14
source_authors: [Kenton Varda, Phillip Jones, "Yo'av Moshe"]
ingested: 2026-08-24
ingested_by: scholar
topics: [oauth-credentials, cloudflare-workers-agent-hosting]
status: current
---

The GitHub Gatekeeper's deployment contract is a provider callback URL plus locally held client credentials, with troubleshooting reducible to permission, redirect, one-use code, or missing-secret failures.

Local registration uses `http://localhost:8787/gatekeeper/github/oauth`, replaced by `PUBLIC_BASE_URL` outside development. `CLIENT_ID` and `CLIENT_SECRET` live in the package's ignored `.env` file. A mismatched callback produces `redirect_uri_mismatch`; stale authorization codes produce `bad_verification_code`; missing secrets produce the Gatekeeper's “Not configured” page; and a GitHub App without email permission produces `Resource not accessible by integration`.

Source: [packages/gatekeeper-github/README.md](https://github.com/cloudflare/cloudflare-os/blob/d85c36ba295361c5661847417fe65c72bd374f04/packages/gatekeeper-github/README.md) at commit `d85c36ba`.
