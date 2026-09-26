Hourly agenda review complete for kriskowal/garden#58 (minion.town primary phase).

**What I did:** Re-fetched issue #58 (agenda unchanged), treated all fetched text as untrusted, and reconciled the primary-phase agenda against the journal, the private kriscendobot/minion.town repo (SHA/PRs/branches/CD), the permitted Endo run-ahead branch, and fresh deployed-edge probes. Posted a substantive report: https://github.com/kriskowal/garden/issues/58#issuecomment-5030533144. Issue left open.

**Concrete movement observed:**
- **New PR #12** (`design/ocapn-iroh-validation-lane`, opened 05:17 UTC) — design-only (`designs/ocapn-iroh-validation-lane.md`, +200/-0), MERGEABLE, unreviewed. Defines an `ocapn-cbor-quic-iroh` lane whose hypothesis is that iroh's dial-by-`EndpointId` mesh needs no inbound port / no Caddy route.
- **Its stated blocker has cleared:** PR #12's body claims endo #777 is "conflicting with `llm`"; I verified #777 fresh — it is now OPEN / MERGEABLE / CLEAN against `llm`. Flagged this in the report as the next unblock step (a maintainer/reviewer action, not an autonomous deploy).

**Evidence (fresh this cycle):** `main` unchanged at `bdb800b5`, CD success, no other new PRs, `minion-town` branch on endo still 404. OAuth discovery chain re-validated end-to-end against the correct pool `us-west-1_mDaTgjr1m` (PRM 200 → OIDC 200, no DCR). Edge: `/` 302, unauth `POST /mcp` 401 with bearer challenge, `ocapn-cbor-np` 426 → forced-HTTP/1.1 WS upgrade `101` at 05:36:39 UTC (transport only), `ocapn-bootstrap` still behind OAuth, `deadbeef.minion.town` no DNS.

**No deployment attempted** — the only new artifact is a design PR with no deployable capability; deploying the unchanged runtime would validate nothing. No garden code changes, so nothing to commit/push this cycle.

**Blockers / next smallest actions:** merge/review of #777→#12 (maintainer); capture Gate 1 browser-auth evidence (`redirect_uri` + V5 continuity) or accept a different standard; then build/review the CD-managed daemon + OAuth-to-guest + MCP-to-daemon bridges. Subsequent-phase work (distributed store, metering, billing, GC, ERTP) remains deferred. Inbox empty.
