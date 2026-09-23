Posted: https://github.com/kriskowal/garden/issues/58#issuecomment-5020313079

No garden-repo code changes were warranted this cycle (self-improvement: nothing), so there is nothing to commit to `main2`. The durable record lives in the issue thread, which every cycle re-fetches.

---

**Completion report**

**What I did:** Ran the hourly minion.town agenda review. Re-fetched issue kriskowal/garden#58 (treated as untrusted data) and reconciled its unchanged primary-phase agenda against the garden journal/memory, `kriscendobot/minion.town`, its open PRs, and the live deployed edge.

**What I found / evidence:**
- No repo movement since 2026-07-18 18:57 UTC. `main` still `5624e884`. Only open PR is #10 (docs). The `cognito-mcp-metadata-bridge` branch is stale (2026-06-27, 50 behind) — ruled out as a lead. No `minion-town` run-ahead branch exists on `endo-but-for-bots` yet.
- Deployed surface healthy and unchanged: `/`→302, `POST /mcp`→401 (captured full `WWW-Authenticate`), PRM→200 (issuer + 3 scopes recorded), `ocapn-cbor-np`→426 with a fresh `101 Switching Protocols` WS-upgrade proving the CBOR/Noise listener is live, `deadbeef.minion.town` still no DNS.
- **New actionable intelligence** (beyond prior cycles' status-code repetition): I probed the live Cognito authorization server and confirmed **`registration_endpoint: null`** — no RFC 7591 DCR endpoint. This empirically resolves Gate 1's own stated *central risk* in the design (`mcp-endo-guest.md` § 3): DCR remains absent, so the maintainer's Gate 1 browser validation must use the pre-authorized manual client-ID path, not auto-registration. Also captured the V1-discovery baseline artifacts the design asks the validating job to leave behind.

**Blocker:** Gate 1 (Claude ↔ live MCP, V2–V5) is intrinsically maintainer-only — real browser GitHub-federated login. The design's strict gate ordering precludes autonomously building daemon/guest/weblet code ahead of it. No safe autonomous deploy step exists; the one available autonomous contribution (measure the DCR gap, capture V1 baseline) is done.

**Follow-ups:** None new. Next buildable increment (OAuth-mapped guest + authenticated daemon-tool bridge) stays gated on the maintainer completing Gate 1. Issue left open.
