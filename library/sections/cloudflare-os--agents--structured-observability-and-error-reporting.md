---
title: Structured observability and error reporting
source: AGENTS.md
source_repo: cloudflare/cloudflare-os
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
source_date: 2026-08-21
source_authors: [Cloudflare OS contributors]
ingested: 2026-08-24
ingested_by: scholar
topics: [agent-conventions, capability-security, cloudflare-workers-agent-hosting]
status: current
---

Server observability uses package-owned typed fields, stable component names, concrete event names, immutable child loggers, and bounded operation context; external issue reporting is optional and follows the same no-secrets contract.

Caught values travel as `error`, with intentionally shallow normalization. Logs and reports never include secrets, prompts, headers, tokens, or bodies. Browser reporting is a separate opt-in path routed through the Workshop's same-origin endpoint and rate limiter. Opaque-origin Gatekeeper frames report through a window-checked `postMessage` bridge rather than directly. Client-supplied user IDs remain diagnostics only, and page locations are reconstructed as origin plus pathname so credentials and bearer fragments cannot leak.

Source: [AGENTS.md](https://github.com/cloudflare/cloudflare-os/blob/1ef6020a42fbabb6d27dd1063db3a075ba95c974/AGENTS.md) at commit `1ef6020a`.
