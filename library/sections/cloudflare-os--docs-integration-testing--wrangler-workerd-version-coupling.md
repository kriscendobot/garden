---
title: Wrangler and workerd version coupling
source: docs/integration-testing.md
source_repo: cloudflare/cloudflare-os
source_commit: 0d1825625808d6855c99c530affb496eb050a7d2
source_date: 2026-08-12
source_authors: [Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [testing, cloudflare-workers-agent-hosting, node-packaging]
status: current
---

The integration harness must move its pinned Wrangler and root-overridden workerd versions together because Wrangler's Miniflare dependency assumes a matching runtime compatibility ceiling.

If Wrangler advances while the override still collapses workerd to an older release, the harness fails before tests with an unsupported compatibility-date error. Cloudflare OS consequently pins Wrangler to the release matching its workerd override and treats a bump as one coordinated dependency change.

Source: [docs/integration-testing.md](https://github.com/cloudflare/cloudflare-os/blob/0d1825625808d6855c99c530affb496eb050a7d2/docs/integration-testing.md) at commit `0d182562`.
