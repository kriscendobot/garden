---
title: Pull-request CI and preview boundary
source: CONTRIBUTING.md
source_repo: cloudflare/cloudflare-os
source_commit: 33c4ac7d1dfacf001bbfb36b881af19030c63967
source_date: 2026-08-17
source_authors: [Kenton Varda, Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [repository-governance, testing, cloudflare-workers-agent-hosting]
status: current
---

Lint, build, and test workflows run for every pull request, including forks, while preview deployments intentionally do not run for fork heads.

Preview creation requires a Cloudflare API token with authority to create Workers and storage. GitHub withholds repository secrets from forked `pull_request` workflows, so a skipped preview is the security boundary working as designed rather than a CI defect. Maintainers create a preview when a change needs manual review.

Source: [CONTRIBUTING.md](https://github.com/cloudflare/cloudflare-os/blob/33c4ac7d1dfacf001bbfb36b881af19030c63967/CONTRIBUTING.md) at commit `33c4ac7d`.
