---
gate: go-ahead
priority: normal
posted_by: producer
posted_at: 2026-07-08T06:11:16Z
---

---
role: builder
---

# Build: Endo daemon Cloudflare storage platform (phases 1-2 of the design)

**Repo:** `kriscendobot/endo`, branch `design-endo-daemon-cloudflare-storage` (continue on this branch or stack on it). Design doc: `packages/daemon/docs/cloudflare-storage.md`; scaffold: `packages/daemon/src/daemon-cloudflare-powers.js` + `test/cloudflare-{mock-bindings,powers.test}.js` (7 tests green against in-memory mock bindings; tsc and eslint clean).

Per the design's phased plan:
- **Phase 1 — real-runtime verification:** add a miniflare/workerd dev harness (decide AVA-first vs @cloudflare/vitest-pool-workers against repo norms) and run the existing cloudflare-powers suite against real local D1, R2, and Durable Object SQLite; inject @noble/hashes SHA-512 for the Workers-side digester; verify the documented D1/R2/DO row/statement/object limits and encode them as guards.
- **Phase 2 — large-blob path:** R2 multipart spool + re-stream commit for objects beyond the buffering threshold, tmp/ prefix lifecycle reaping, ranged BlobPowers.get.

Keep the daemon core untouched; bindings stay injected powers (no ambient auth). Packaging (in @endo/daemon vs a sibling @endo/daemon-cloudflare package) is to be decided with the maintainer at PR time — coordinate with the AWS sibling platform (design-endo-daemon-aws-storage) so both make the same call. No upstream PR without ferry authorization.
