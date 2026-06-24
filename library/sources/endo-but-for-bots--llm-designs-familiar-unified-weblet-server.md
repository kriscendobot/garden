---
source: designs/familiar-unified-weblet-server.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-02)
source_date: 2026-05-06
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-02
ingested_by: scholar
section_count: 1
status: current
notes: |
  Thirtieth endo-but-for-bots design ingest. **Status: In Progress**
  (*Partially implemented; design under revision*). The 259-line
  design documents the unified weblet server — replacing per-weblet
  random-port HTTP servers with a single gateway-port server that
  uses Host-header routing to demux requests to the correct weblet.
  
  **This cycle completes the Familiar dependency triangle**:
  cycle 109 named three required dependencies for the Familiar
  Electron Shell; cycle 111 ingested familiar-gateway-migration,
  cycle 113 ingested familiar-daemon-bundling, and cycle 114 (this
  ingest) ingests familiar-unified-weblet-server. The triangle is
  3/3 complete.
  
  Four structurally interesting moves: (1) the **Key design
  revision (2026-04-17)** identifies the *two-mode split* —
  Familiar weblets (Electron's `protocol.handle('localhttp', ...)`
  intercepts) can use Host-header routing on a single port vs Chat
  weblets (standalone browser; browsers can't intercept scheme)
  need separate ports per weblet for origin isolation; (2) the
  §*deeper problem* enumeration — *hierarchical multiplexing*
  (user → persona/agent → weblet routing) and *session
  confidentiality* (`127.0.0.1` traffic trust breaks in multi-user
  or weblet-isolated scenarios) — point toward OCapN
  Network/Transport separation and Noise Protocol Network as
  resolution; (3) the *Implemented* + *Not implemented* + *Previous
  status note* discipline — honest current-state inventory + explicit
  correction of an earlier *prospective-status* section that claimed
  implementation in a file *which does not exist on origin/llm as
  of 2026-04-17*; (4) the *RFC-6761-`*.localhost`-resolution*
  discipline — modern browsers resolve `*.localhost` to 127.0.0.1
  per RFC 6761, so no DNS configuration needed for standalone-
  browser-mode access.
  
  Single-section cohesion-honest ingest. Cycle 114 pivoted from
  papers-lane (tenth consecutive papers-lane block since cycle 97)
  to familiar-design-lane to complete the Familiar dependency
  triangle.
---

> Abstract: `designs/familiar-unified-weblet-server.md` documents
> the unified weblet server — *third and final of cycle 109's
> three named dependencies for the Familiar Electron Shell*. The
> §Status block opens *Partially implemented; design under
> revision*. The §**Key design revision (2026-04-17)** identifies
> the two-mode split: *Familiar weblets* (Electron protocol
> handler intercepts) use Host-header routing on the gateway
> port; *Chat weblets* (standalone browser; can't intercept
> scheme) still need separate ports per weblet. The §deeper
> problem identifies *hierarchical multiplexing* (user →
> persona/agent → weblet routing) and *session confidentiality*
> (`127.0.0.1` trust breaks in multi-user / weblet-isolated
> scenarios) — pointing to OCapN Network/Transport separation
> and Noise Protocol Network as architectural answers. The
> §Dependencies-added: `ocapn-network-transport-separation` +
> `ocapn-noise-network`. The §*Implemented* enumeration names
> three shipped Familiar-side modules (protocol-handler.js +
> exfiltration-defense.js + navigation-guard.js); the §*Not
> implemented* enumeration names six daemon-side gaps. The
> §*Previous status note* explicitly corrects a prospective
> status that claimed implementation that *does not exist on
> origin/llm as of 2026-04-17* — the honest-design-correction
> discipline. The §Design replaces per-weblet `servePortHttp`
> with a single gateway-port server; `webletHandlers = new
> Map()` keyed by hostname; routes by Host header
> (`<weblet-id>.localhost`); falls through to gateway WebSocket
> for unmatched requests; `webletId.slice(0, 32)` truncates the
> 128-char hex for hostname length. The §weblet location format
> changes from `http://127.0.0.1:<random-port>/<token>/` to
> `http://<weblet-id>.localhost:<gateway-port>/` (or
> `localhttp://<weblet-id>/` via Familiar). The §RFC-6761-
> `*.localhost`-resolution discipline lets modern browsers
> resolve to 127.0.0.1 without DNS. The §`makeWeblet` signature
> evolves: port → server-registrar; returns `Weblet` with
> `getLocation()` returning virtual host URL. The §Security via
> unguessable weblet identifiers (128-char hex) + per-weblet
> WebSocket isolation + browser SOP cookie isolation.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [single-port-virtual-host-routing-with-key-revision](../sections/endo-but-for-bots--llm-designs-familiar-unified-weblet-server--single-port-virtual-host-routing-with-key-revision.md) | daemon | current |

The 259-line file is honestly one cohesive argument-cluster despite its substantial Status block — *one design proposal* with rich design-evolution history (the 2026-04-17 Key revision + Previous-status correction) flowing into the unified-server design proper. Single-section ingest preserves the unified narrative.

## Provenance

- Fetched 2026-06-02 from `endojs/endo-but-for-bots` `origin/llm` via the local bare-clone.
- Last touched 2026-05-06 by Kris Kowal (*prompted* — LLM-collaborated authoring).
- Verified file existence via bare-clone listing: 259 lines.
- **Thirtieth endo-but-for-bots design ingest**. Cycle 114 ingests this as the **third and final** of cycle 109's three named dependencies (cycle 111 was the first, familiar-gateway-migration; cycle 113 was the second, familiar-daemon-bundling).
- Cycle 114 was scheduled for papers-lane (tenth consecutive papers-lane block since cycle 97) and pivoted to familiar-design-lane to complete the Familiar dependency triangle.
- Single-section cohesion-honest count. The 259-line file is *one unified design proposal* with substantial Status block, deeper-problem identification, and design proper. The size is at the boundary where two sections could be argued, but the design-evolution history is *part of the same narrative* as the current proposal.

## Familiar dependency triangle complete

Cycle 109's `familiar-electron-shell` named three required dependencies. **All three are now ingested**:

- **Cycle 111** `familiar-gateway-migration` (Complete) — gateway in-daemon.
- **Cycle 113** `familiar-daemon-bundling` (Complete) — daemon as Electron-packageable artifact.
- **Cycle 114** `familiar-unified-weblet-server` (In Progress, this ingest) — single-port weblet serving with virtual host routing.

The library now has the full Familiar Electron Shell architecture documented: the Familiar (cycle 109) consumes all three dependencies (cycles 111 + 113 + 114).
