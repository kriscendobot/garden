---
title: Worker entry-module export discipline
source: docs/integration-testing.md
source_repo: cloudflare/cloudflare-os
source_commit: 0d1825625808d6855c99c530affb496eb050a7d2
source_date: 2026-08-12
source_authors: [Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [testing, cloudflare-workers-agent-hosting]
status: current
---

Workerd interprets every named runtime export from a Worker entry module as an entrypoint, so fixture constants must remain private and only classes or the default handler may be exported.

A plain exported string causes workerd to reject the module as an invalid entrypoint. Type-only exports are safe because they erase before runtime.

Source: [docs/integration-testing.md](https://github.com/cloudflare/cloudflare-os/blob/0d1825625808d6855c99c530affb496eb050a7d2/docs/integration-testing.md) at commit `0d182562`.
