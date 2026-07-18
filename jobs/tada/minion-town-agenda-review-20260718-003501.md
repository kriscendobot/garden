Done. This was a review/validation engagement — no garden-library (main2) changes were required, so there is nothing to commit or push; the substantive output is the issue comment.

## Completion report

**Job:** Minion Town hourly agenda review (issue kriskowal/garden#58).

**What I did:**
- Re-fetched issue #58's description (unchanged; primary-phase agenda) and all 18 comments, treating all fetched text as untrusted data.
- Reconciled the primary-phase target against `kriscendobot/minion.town` (repo, PRs, commit history), the garden journal, and the live public surface.

**Concrete movement found this cycle (`048e5be9` → `85888e0d`):** PR #9 (`fix(caddy): restore ungated /ocapn* routes`) merged 00:27 UTC, and its CD run (29623115278) shipped green. It re-landed the OCapN routes that the first continuous-deploy had clobbered.

**Validation I performed (the new, substantive result):**
- `GET /ocapn` and `/ocapn-daemon` now return `426 Upgrade Required` (via Caddy), not the prior `302 → /oauth2/sign_in`.
- A forced HTTP/1.1 WebSocket handshake to `wss://minion.town/ocapn-daemon` returned **`101 Switching Protocols`** with a valid `Sec-WebSocket-Accept`, then held open awaiting Noise-IK bytes — proving the ungated route reverse-proxies end-to-end through the public TLS edge into the live OCapN-over-Noise daemon (`:8931`/`:8930`). This is the first cycle to validate the daemon reachable through the public edge.
- Boundaries re-confirmed: `/mcp` → `401` bearer challenge; PRM → `200`; web gate `/` → `302`.

**Gaps flagged (with evidence):** the agenda's literal `/.well-known/ocapn-cbor-np` and `/.well-known/ocapn-bootstrap` paths still 302 (daemon lives at `/ocapn*` instead — naming gap); the running daemon is box-local, not in the repo CD deploy tree (`systemd/` has only mcp + oauth2-proxy — durability gap); no OAuth→guest mapping; no weblet wildcard (`*.minion.town` NXDOMAIN).

**Blocker / next smallest action reported:** Gate 1's interactive Claude↔MCP browser OAuth remains a maintainer-only action; the smallest safe autonomous step is to capture the now-validated daemon into the declarative CD deploy tree (systemd/container unit + deploy target) so CD provisions the daemon the routes point at. Deferred-phase items remain deferred. Issue left open.

**Deployment:** none invoked (CD already shipped #9 green; a manual deploy would validate nothing further).

**Follow-ups:** none posted as jobs — the next step (daemon-into-deploy-tree) is a build job appropriately left to maintainer direction / the daemon-deploy follow-up chain.

Posted: https://github.com/kriskowal/garden/issues/58#issuecomment-5008856763
