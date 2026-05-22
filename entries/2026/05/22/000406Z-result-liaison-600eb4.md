---
ts: 2026-05-22T00:04:06Z
kind: result
role: liaison
project: endo-but-for-bots
refs:
  - entries/2026/05/21/235025Z-dispatch-liaison-600eb4.md
  - entries/2026/05/21/000222Z-result-designer-600eb4.md
---

# Result: liaison — designer 600eb4 returned with overarching `@endo/gateway` design (PR #343)

The designer dispatch landed cleanly.
PR: <https://github.com/endojs/endo-but-for-bots/pull/343> (DRAFT, base `llm`, head `design/gateway-package` at `6bbd0cbe`).
Design file: `designs/gateway-package.md` (~1190 lines; sibling-with-supersession of `designs/endo-gateway.md`).

`designs/endo-gateway.md` flipped to `Status: Superseded` with a `Superseded by` row and a top-of-doc prose note pointing to the new file.
The single material change carried forward differently is the WebSocket path: the new design uses `/ocapn-cbor-np` (codec + transport encoded in the path so future siblings like `/ocapn-syrups-tcp` can coexist), where the old design used `/ocapn`.

The 10 maintainer-listed features are decomposed into a four-phase rollout (M1):

- Phase 1: package skeleton + virtual hosting (#2) + `/ocapn-cbor-np` (#8).
- Phase 2: UDS bootstrap (#4) + Chat hosting (#1, ledger-only) + admin daemon (#7).
- Phase 3: Familiar-bundled fallback (#5) + Git over HTTP (#3).
- Phase 4: public relay (#6) + HTTPS terminating proxy support (#9) + OS packaging deb/rpm/PKGBUILD/Docker (#10) + reference payment-processor adapter.

`designs/README.md` synced: new row, M1 milestone assignment, XL size estimate (6–10 weeks across four phases), Remote Access subgraph extended with `gpkg` and `egw` nodes (edges to `gauth`, `onoise`, `ddock`), totals row updated (2 Superseded, 105 designs).

Seven open questions surfaced (rather than answered) for maintainer resolution:

1. Payment-token mechanism (which processor, what `paymentProof` wire shape).
2. Abuse-prevention model for the public relay (rate-limit / billing / closed-allowlist combination).
3. Virtual-host name allocation across users (first-bind-wins vs. per-user prefix vs. operator allowlist).
4. Rotation story for formula-identifier bearer tokens.
5. Multi-tenant filesystem isolation for the gateway CAS.
6. Package naming (`@endo/gateway` per directive vs. `@endo/web-gateway`).
7. Migration timing for the existing in-daemon `web-server-node.js`.

The PR sits draft on `llm`, awaiting maintainer review.
The PR-creation-flow chain for the design-only PR variant (solicitor + design panel) is the natural next stage; the liaison can dispatch the solicitor on maintainer ask, or the steward's per-cycle PR-creation-flow scan will pick it up.

`Self-improvement: nothing this time.`
