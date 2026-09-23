Report posted to issue #58 (https://github.com/kriskowal/garden/issues/58#issuecomment-5031383449). This is a monitoring/validation engagement — no garden-repo changes to commit. Done.

## Completion report

**Job:** Minion Town hourly agenda review (kriskowal/garden#58), 2026-07-21 07:36 UTC engagement.

**What I did:**
- Re-fetched issue #58 description + all 45 comments (treated as untrusted data); the primary-phase agenda is unchanged, no newer maintainer directive since the 06:37 UTC predecessor cycle.
- Reconciled against the minion.town repo, its PRs/branches, the permitted Endo run-ahead branch, the journal, and fresh deployed-edge probes.

**Concrete finding (new movement this cycle):** Positively validated the agenda-literal OCapN listener at the public edge. `GET https://minion.town/.well-known/ocapn-cbor-np` returns `426` (dedicated route, outside the login gate), and a real HTTP/1.1 RFC 6455 handshake completes with **`101 Switching Protocols`** + correct `Sec-WebSocket-Accept`. The sibling `/ocapn-daemon` returns the identical 101 (same `:8931` endo-pet-daemon container). Prior cycles called the daemon "box-local"; this cycle records the OCapN-CBOR-over-Noise WebSocket listener as **publicly reachable and handshake-complete at the literal agenda path** (WSS/transport layer).

**Gaps noted:** `http://` variant force-redirects (308) to https, so no plaintext-HTTP Noise listener publicly (agenda literal says both); the standalone `/ocapn` (`:8930`) listener 426s but its WS upgrade hangs, unlike `:8931`.

**State otherwise quiet:** `main` unchanged at `bdb800b5`; only open PR is #12 (design-only, clean, unreviewed); its dep endo-but-for-bots#777 is OPEN/CLEAN; run-ahead `minion-town` branch still 404; SIWE/open-signup build jobs remain parked behind maintainer go-aheads. No deployment attempted (surface healthy; remaining gaps are unposted build work needing maintainer direction).

**Evidence posted:** issue #58 comment 5031383449. Issue left open.

**Follow-ups:** Next smallest validation rung — a Noise-speaking OCapN-CBOR client probe against the confirmed `wss://.../.well-known/ocapn-cbor-np` to exercise the Noise IK handshake + bootstrap fetch (no deploy). Movement levers beyond that are maintainer actions (merge #12 / #777, or promote a parked build).
