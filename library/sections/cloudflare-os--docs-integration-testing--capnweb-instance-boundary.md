---
title: Cap'n Web instance boundary across repositories
source: docs/integration-testing.md
source_repo: cloudflare/cloudflare-os
source_commit: 0d1825625808d6855c99c530affb496eb050a7d2
source_date: 2026-08-12
source_authors: [Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [testing, capability-security, node-packaging]
status: current
---

A consumer and a vendored public workspace can install separate Cap'n Web copies, so RPC stubs must be created by the toolkit instance that owns the session.

A stub is serializable only by its originating Cap'n Web instance. Separate package-manager stores can therefore expose a CI-only `Cannot serialize value: [object RpcStub]` failure that a deduplicated developer install hides. The toolkit owns this boundary through `stubFor()` from its RPC client; consumers may import `RpcStub` as a type but not as a runtime value.

Source: [docs/integration-testing.md](https://github.com/cloudflare/cloudflare-os/blob/0d1825625808d6855c99c530affb496eb050a7d2/docs/integration-testing.md) at commit `0d182562`.
