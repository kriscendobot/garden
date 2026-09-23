---
title: Service roles and resource boundaries
source: packages/gatekeeper-cloudflare/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 1931a1b175d52ed88109d880b90e23d130cca2ad
source_date: 2026-08-18
source_authors: [Nathan Disidore]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, authentication-gatekeepers, ai-usage-billing, worker-observability]
status: current
---

The Cloudflare Gatekeeper deliberately composes three roles over one provider connection: verified-email sign-in, persistent AI Gateway billing authority, and read-only Workers Observability capabilities bounded to an account or one Worker.

Observability uses one indivisible provider OAuth scope, so the resource binding supplies the finer capability boundary. Account bindings cover logs, events, invocations, aggregate metrics, and traces. Worker bindings inject a service constraint and exclude account-wide trace summaries because cross-service names, timing, and counts disclose more than one Worker. Connections can acquire the observability grant incrementally, telemetry is retained for at most seven days, and discovery defaults are chosen around that retention window.

Source: [packages/gatekeeper-cloudflare/README.md](https://github.com/cloudflare/cloudflare-os/blob/1931a1b175d52ed88109d880b90e23d130cca2ad/packages/gatekeeper-cloudflare/README.md) at commit `1931a1b1`.
