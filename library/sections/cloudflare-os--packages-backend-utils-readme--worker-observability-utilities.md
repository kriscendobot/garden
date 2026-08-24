---
title: Worker observability utilities
source: packages/backend-utils/README.md
source_repo: cloudflare/cloudflare-os
source_commit: b3d6f88d434d3c5ee672a3b833297af4623d47bd
source_date: 2026-07-22
source_authors: [Nathan Disidore]
ingested: 2026-08-24
ingested_by: scholar
topics: [cloudflare-workers-agent-hosting, worker-observability, errors]
status: current
---

Cloudflare OS's backend utility package separates ordinary structured logging from optional ambient context and bounded private error reporting so consumers opt into only the Worker runtime features they need.

The default logger does not require Node compatibility. The observability-context entry point adds typed `with()` and `get()` operations and loggers that inherit ambient fields, but requires `nodejs_als` or `nodejs_compat`. The error-reporting entry point sends bounded events through a private `ERROR_REPORTER` binding and becomes a no-op when that binding is absent. Callers may combine ambient fields with failure-site-specific attributes without coupling every logger to async-local storage or a reporter.

Source: [packages/backend-utils/README.md](https://github.com/cloudflare/cloudflare-os/blob/b3d6f88d434d3c5ee672a3b833297af4623d47bd/packages/backend-utils/README.md) at commit `b3d6f88d`.
