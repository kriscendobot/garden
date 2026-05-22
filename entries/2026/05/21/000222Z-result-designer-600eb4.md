---
ts: 2026-05-22T00:02:22Z
kind: result
role: designer
project: endo-but-for-bots
refs:
  - entries/2026/05/21/235025Z-dispatch-liaison-600eb4.md
---

# Result: designer drafts overarching @endo/gateway design

## Deliverables

- **PR**: <https://github.com/endojs/endo-but-for-bots/pull/343> (DRAFT, base `llm`, head `design/gateway-package`).
- **Head SHA**: `6bbd0cbecf0e2f16b211681e4f203e5c07bfc740`.
- **Design file on `llm` (post-merge)**: `designs/gateway-package.md`. New design, 1190-line addition.
- **Existing `endo-gateway.md`**: **superseded in place** (status flipped from Proposed to Superseded, *Superseded by* metadata row added, prose superseded note at top citing the supersession date, the carry-forward of all prior decisions except the `/ocapn` → `/ocapn-cbor-np` path rename, and retention as historical reference). Sibling shape, not in-place rewrite: the new file is `designs/gateway-package.md`, the old file remains as a redirect.
- **`designs/README.md` synced**: `endo-gateway` row updated to Superseded; new `gateway-package` row added; *See also* preamble updated; Remote Access subgraph extended with `gpkg` and `egw` nodes plus edges to `gauth`, `onoise`, `ddock`; M1 milestone assigned; XL per-design estimate at 6-10 weeks across four phases; totals row updated (2 Superseded, 105 designs).

## Phased rollout shape

| Phase | Features |
|-------|----------|
| 1 | Package skeleton; virtual hosting (#2); `/ocapn-cbor-np` (#8) |
| 2 | UDS bootstrap (#4); Chat hosting (#1, ledger but not payment-processor adapter); admin daemon (#7) |
| 3 | Familiar-bundled variant (#5); Git over HTTP (#3) |
| 4 | Public relay (#6); HTTPS terminating proxy support (#9); OS packaging deb/rpm/PKGBUILD/Dockerfile (#10); reference payment-processor adapter |

Phases are sequential because each builds on its predecessor; phase 1 and phase 2 are on the critical path to feature parity with the existing in-daemon gateway, then phases 3 and 4 are independently order-able.

## Open questions surfaced rather than answered

1. **Payment-token mechanism** (which payment processor, what wire shape for `paymentProof` the `ResourceLedger.purchaseTokens(tokens, proof)` validates).
2. **Abuse-prevention model for the public relay** (per-public-key rate limit, per-IP rate limit, billing-tied gating via the resource ledger, closed-allowlist by default; combination is operator policy).
3. **Virtual-host name allocation across users** (first-bind-wins vs. per-user prefix `<user>.chat.example.com` vs. operator-administered allowlist per user).
4. **Rotation story for formula-identifier bearer tokens** (inherits the Pass-Invariant-Eq follow-up from `endo-gateway` Open Question 1; token-rotation that preserves E `Eq` across key changes is unsolved).
5. **Multi-tenant filesystem isolation for the per-user CAS** held by the gateway (per-user subdirectory vs. shared dedup-by-content-hash with reference counts; first implementation lands the latter, refinement deferred).
6. **Package naming** (`@endo/gateway` per the directive vs. `@endo/web-gateway`; design uses the former but flags the alternative).
7. **Migration timing for the existing in-daemon `web-server-node.js`** (builder-level question; surfaced so the phase-1 builder plans the transition rather than discovering the need mid-PR).

Granularity of the resource counters (per-request vs. per-session vs. per-weblet) and whether the gateway itself owns the metering or delegates to the per-user daemon also surfaced as a sub-question under open question 1.

## Self-improvement

`Self-improvement: nothing this time.` The dispatch brief was unusually thorough (corpus list pre-enumerated, section-by-section guidance, decisions called out for special attention) and the designer role file gave a clean process for the supersede-vs-extend decision (the "if supersede in place, name the branch cleanly; if sibling, add the Supersedes/Superseded-by cross-links" guidance applied directly). The em-dash sweep at write time caught all dashes in one pass.
