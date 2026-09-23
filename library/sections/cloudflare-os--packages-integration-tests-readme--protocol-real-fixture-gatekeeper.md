---
title: Protocol-real fixture Gatekeeper
source: packages/integration-tests/README.md
source_repo: cloudflare/cloudflare-os
source_commit: ba4036b9366070a5d396b1bf76bc62b4fb50c9ab
source_date: 2026-08-14
source_authors: [Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [testing, capability-mediated-integrations, cloudflare-workers-agent-hosting]
status: current
---

The integration suite uses a real protocol-speaking fixture Gatekeeper whose verification result is controlled over HTTP, avoiding both vendor OAuth setup and test-only hooks inside production observer state.

Shipping OAuth Gatekeepers require a full mocked vendor surface before an account exists, while the Context Library Gatekeeper can refuse only after a singleton observation path. The fixture supplies denial on demand without bypassing production state inside those Workers. It points directly at source instead of generating a large validation declaration file, and exposes one `allow` control. Settled denial and expired credentials intentionally share the same thrown-error path; tests vary the reason string to cover both repair narratives.

Source: [packages/integration-tests/README.md](https://github.com/cloudflare/cloudflare-os/blob/ba4036b9366070a5d396b1bf76bc62b4fb50c9ab/packages/integration-tests/README.md) at commit `ba4036b9`.
