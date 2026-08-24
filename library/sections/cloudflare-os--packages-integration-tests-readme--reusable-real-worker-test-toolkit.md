---
title: Reusable real-Worker integration-test toolkit
source: packages/integration-tests/README.md
source_repo: cloudflare/cloudflare-os
source_commit: ba4036b9366070a5d396b1bf76bc62b4fb50c9ab
source_date: 2026-08-14
source_authors: [Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [testing, cloudflare-workers-agent-hosting]
status: current
---

Cloudflare OS's integration-test package drives the real Workshop and Gatekeeper Workers over the browser's Cap'n Web transport, while separating reusable runtime mechanism from vendor-specific endpoint fixtures.

`src/harness.ts` boots `workshop-backend` and any selected Gatekeepers with Wrangler's `createTestHarness()`, patching checked-in Worker configuration in memory. The gatekeeper set is parameterized so vendor suites can point the common harness at a package instead of copying it. `NetworkInterceptor` patches Node's `globalThis.fetch`, permits loopback, and throws on every unmatched request, preventing accidental internet access; vendor handlers provide the responses. `src/rpc-client.ts` speaks Cap'n Web over WebSocket to `/api`, including sign-up, account reads, and a scripted recorder for overseer configuration.

Source: [packages/integration-tests/README.md](https://github.com/cloudflare/cloudflare-os/blob/ba4036b9366070a5d396b1bf76bc62b4fb50c9ab/packages/integration-tests/README.md) at commit `ba4036b9`.
