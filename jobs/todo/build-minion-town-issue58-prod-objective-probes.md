---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build: automatic production validation for the checked issue-58 objectives

Posted by the minion.town arc supervisor (`minion-town-arc-press-20261007-205010`). Under the
maintainer's 2026-10-07 standing order (journal `entries/2026/10/07/203746Z-message-gardener-a253b1.md`)
an objective of https://github.com/kriscendobot/garden/issues/58 is done only when it is
**validated automatically in production**. Today the checked primary-phase boxes rest on one-off
manual probes; `kriscendobot/minion.town` has only `deploy.yml`/`test.yml` and no scheduled
production probe (the leader's `garden-minion-mcp-watchdog` only checks MCP liveness).

Build, in `kriscendobot/minion.town` (draft PR via `ensure-pr.sh`, then the gauntlet stages
automatically): a deterministic, no-LLM production objectives probe, run on a schedule
(GitHub Actions `schedule:` every few hours + `workflow_dispatch`, and after each successful
deploy), with one named check per checked issue-58 box, at least:

1. Daemon unit healthy (existing health endpoint / MCP status).
2. OAuth → guest mapping and authenticated MCP tool call (reuse the client-credentials test
   client recipe, `minion-mcp-test-cc` → Cognito → `/mcp`; secrets via repo/Actions secrets,
   never logged). If CI cannot hold that credential, make the check report `skipped: no-credential`
   loudly rather than pass.
3. A known live clip on `<hash>.ocap.site`: CSP `default-src 'self'` + `frame-ancestors 'none'`,
   COOP/COEP/CORP, `X-Frame-Options: DENY`, `Referrer-Policy: no-referrer`; no `minion.town` cookie.
4. Content-addressed hard cache: content-hash `ETag`, `Cache-Control: ... immutable`, and
   `If-None-Match` → 304.
5. `/.well-known/ocapn-cbor`, `ocapn-syrup`, `endo-captp` answer `426`; a clip with powers
   answers `/.well-known/ocapn-bootstrap` 200 with an `endo:` identifier.
6. `https://minion.town/.well-known/ocapn-cbor-np` accepts a WebSocket upgrade.

Keep fixture clips stable (publish a dedicated canary clip once, record its hash in the repo).
On failure the workflow must fail red and open or update a single tracking issue in
kriscendobot/minion.town (deduped), naming the failing check. Output a machine-readable
summary (JSON) per run. Keep it a thin script under `deploy/` or `scripts/` plus the workflow.
Do NOT edit the issue-58 checklist; the arc supervisor does that.
