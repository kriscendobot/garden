Completion report:

**Job:** `design-gateway-bearer-token-auth-reconcile-endo-gateway` — reconcile the phantom `gateway-bearer-token-auth` design against the real `@endo/gateway` package and the actual daemon.

**Deliverable:** Draft PR **endojs/endo-but-for-bots#610** (`design/gateway-bearer-token-auth-reconcile` → `llm`), rewriting `designs/gateway-bearer-token-auth.md` and updating four stale `designs/README.md` entries (index row, M3 table row, effort row, totals line). Prettier-clean; every claim verified by grep at `origin/llm` HEAD `1132289`.

**What the investigation found (the design was only half-phantom, and the drift ran in both directions):**
- The record claimed Implemented, citing `ENDO_GATEWAY=remote` machinery in `web-server-node.js` — false. PR #608 countered that nothing exists and proposed Not Started — also false for the roadmap branch.
- Ground truth on `llm`: the `GatewayBootstrap.fetch(token)` bearer gate and the design's exact per-IP rate limiter shipped in `packages/daemon/src/ws-gateway.js` (via familiar-gateway-migration), and the complete local/CIDR/remote admission policy exists as `packages/daemon/src/cidr.js` (`makeAddressChecker`) with unit tests — **but nothing imports it**, no code reads `ENDO_GATEWAY`, and the gateway performs no peer-address check at all, so `ENDO_ADDR=0.0.0.0` today exposes the fetch gate with no opt-in (named as the top security finding). On the master lineage (#608's base) none of it exists — #608 was right for its base. Two never-true premises corrected: no `--addr` flag (it's `ENDO_ADDR`), and the "localhost IP check" belonged to Chat's deleted dev gateway.

**Ownership ruling:** `gateway-bearer-token-auth.md` keeps the bearer-token admission-control spec; the merged `gateway-package.md` (#343) owns the transport surfaces and hoists the machinery when `@endo/gateway` replaces the inline gateway. No "endo-gateway phase" can own it — that design was removed 2026-05-29 and absorbed into gateway-package.

**Buildable phases:** A — wire the existing tested `makeAddressChecker` into `startWsGateway` + remote-mode tests (small, pure wiring; the M3 remote-control keystone; status now honestly In Progress). B — #608's remote-access follow-up (blocked on A plus a named lineage open question: the Docker image builds from the master lineage, which has no gateway). C — the gateway-package hoist (Chat WS, weblet WS, Git smart-HTTP; `/ocapn-cbor-np` exempt via Noise).

**Follow-ups (for the liaison/maintainer):** (1) the two open questions in the PR (deployment lineage for #608's follow-up; loopback-enforcement behavior change); (2) a subsequent builder job can implement Phase A directly from the spec; (3) `familiar-gateway-migration.md`'s Status prose still cites the pre-migration filename — noted in the design, not edited (out of scope).
