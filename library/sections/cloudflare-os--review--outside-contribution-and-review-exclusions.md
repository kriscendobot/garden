---
title: Outside-contribution and review exclusions
source: REVIEW.md
source_repo: cloudflare/cloudflare-os
source_commit: da895450d81e674c03e62bd6c940acf57bc0224c
source_date: 2026-08-18
source_authors: [Maximo Guk, Nathan Disidore]
ingested: 2026-08-24
ingested_by: scholar
topics: [repository-governance, agent-conventions]
status: current
---

Outside contributions are judged against the repository's deliberately narrow bar: only small changes that are obviously correct and trivially verified should be accepted, without requesting broader refactors or adjacent cleanup from the contributor.

Reviewers also avoid false positives that encode repository decisions: skipped fork previews, unawaited pipelined RPC, `test:run` naming, nonblocking lint warnings, single-threaded TypeScript, and absent `baseUrl`. Generated outputs, normal lockfile churn outside dependency changes, and opaque gadget archives are ignored. Dependency changes still require checking the lockfile against the minimum-release-age policy.

Source: [REVIEW.md](https://github.com/cloudflare/cloudflare-os/blob/da895450d81e674c03e62bd6c940acf57bc0224c/REVIEW.md) at commit `da895450`.
