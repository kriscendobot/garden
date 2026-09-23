---
title: Secret-safe logging and reporting review
source: REVIEW.md
source_repo: cloudflare/cloudflare-os
source_commit: da895450d81e674c03e62bd6c940acf57bc0224c
source_date: 2026-08-18
source_authors: [Maximo Guk, Nathan Disidore]
ingested: 2026-08-24
ingested_by: scholar
topics: [repository-governance, capability-security, cloudflare-workers-agent-hosting]
status: current
---

Reviewers reject logs, exceptions, and reports that may disclose secrets, prompts, headers, tokens, request bodies, response bodies, credentials, or bearer-capability URL fragments.

Server code uses the shared structured logger with stable components and passes caught values as `error`. Gatekeeper frames report through the Workshop host, which checks the known frame window and opaque origin before forwarding to the same-origin endpoint. Client-supplied `reportedUserId` is never authority, and `pageLocation` is reconstructed from origin and pathname. Automatic capture is limited to trusted first-party surfaces, excluding gadgets and user-authored code.

Source: [REVIEW.md](https://github.com/cloudflare/cloudflare-os/blob/da895450d81e674c03e62bd6c940acf57bc0224c/REVIEW.md) at commit `da895450`.
