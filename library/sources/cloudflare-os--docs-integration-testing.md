---
source: docs/integration-testing.md
source_repo: cloudflare/cloudflare-os
source_commit: 0d1825625808d6855c99c530affb496eb050a7d2
source_date: 2026-08-12
source_authors: [Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
section_count: 6
status: current
---

The integration-testing design explains the real-Worker harness and the cross-process, persistent-storage, runtime-version, module-instance, and entrypoint constraints that determine its shape.

| Section | Topics | Status |
|---------|--------|--------|
| [real Worker integration-test harness](../sections/cloudflare-os--docs-integration-testing--real-worker-harness.md) | testing, cloudflare-workers-agent-hosting | current |
| [cross-process time and fixture control](../sections/cloudflare-os--docs-integration-testing--cross-process-time-and-fixture-control.md) | testing, cloudflare-workers-agent-hosting | current |
| [persistent harness storage isolation](../sections/cloudflare-os--docs-integration-testing--persistent-harness-storage-isolation.md) | testing, cloudflare-workers-agent-hosting | current |
| [Wrangler and workerd version coupling](../sections/cloudflare-os--docs-integration-testing--wrangler-workerd-version-coupling.md) | testing, cloudflare-workers-agent-hosting, node-packaging | current |
| [Cap'n Web instance boundary across repositories](../sections/cloudflare-os--docs-integration-testing--capnweb-instance-boundary.md) | testing, capability-security, node-packaging | current |
| [Worker entry-module export discipline](../sections/cloudflare-os--docs-integration-testing--worker-entry-module-export-discipline.md) | testing, cloudflare-workers-agent-hosting | current |
