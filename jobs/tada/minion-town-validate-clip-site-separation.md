Everything checked out clean. Report follows.

---

## Completion report — `minion-town-validate-clip-site-separation`

**Result: PASS (clean).** The `designs/clip-ocap-synthesis.md` § 3.4 clip-identity claim is now **proven live** against the production `minion.town` daemon (`CLIP_SITES_LIVE=1`). No gap found; no follow-up fix job needed.

### What I exercised
Live MCP over `https://minion.town/mcp` (streamable-HTTP), authenticating with the designated client-credentials client `minion-mcp-test-cc` (`52ivub…`, secret from Cognito) — which **now advertises `mcp/guest`+`mcp/tools`** (the 2026-08-23 scope drift is fixed; no workaround needed). Token scope confirmed `mcp/guest mcp/tools`. Code path read first: `publish.ts` / `site-registry-exo.ts` / `daemon-site-registry.ts` / `site-registry.ts`. MCP tools driven: `writeText`, `publish`, `readText`, `listSites`, `upgrade`, `unpublish`, plus a native `@endo/captp`-over-WebSocket probe.

### Evidence (2026-09-04 ~05:26–05:29 UTC)
- **Byte-identical front**, distinct back: one `index.html`, sha256 `33743669d39701b1652be6834a9f18d7a1daccf96c55308f903bd0bb3a55acaf` (82 bytes), published twice — clip A bound to power `verify-power-alpha-…` (text "ALPHA-back-state-…"), clip B to `verify-power-bravo-…` ("BRAVO-back-state-…").
- **Distinct, non-colliding origins** (the core claim):
  - A → `j7kntdckxq37ia7l7vb4zwln2hshs2mls4vnnethoipv5gpwdoqa.ocap.site`, `serving:true`
  - B → `xipt2suw3xvnkghne5y4palnqcb4fry5g6spzrdbwxqjyp3rvq5a.ocap.site`, `serving:true`
  - Hashes **differ** despite identical front — confirms identity keys on the per-publish fresh directory formula id, not a content digest.
- **Both origins serve the identical bytes** at their own distinct DNS labels (HTTP 200, sha256 of each body = the published front). ETag is identical (`"33743669…"`) — correct: the CAS blob store is content-addressed and dedupes the *bytes*, while the *origins/directories* stay distinct. Full isolation headers present (COEP/COOP/CORP, `X-Frame-Options: DENY`, immutable Cache-Control), no `Set-Cookie`, no `Access-Control-Allow-Origin`.
- **No cross-talk on `back`** (strongest check): the powers plane is armed. Each origin's `/.well-known/ocapn-bootstrap` returned a **distinct** `endo:<id>` designator (A `4fd4d98c…`, B `ba1f3d4a…`), and a native `@endo/captp` WS bootstrap to each `/.well-known/endo-captp` resolved **only its own** back — origin A = a readable file with SHA-256 `1421210b…`, origin B = `4512330c…`. These match, byte-exact, the SHA-256 of the ALPHA and BRAVO texts I stored respectively. Origin A never saw B's back or vice-versa.
- **`listSites`** returned both A and B, owner-scoped.
- **`upgrade`** on the live path returned the clean, documented error *"upgrade is not yet supported on the live daemon @sites path"* — this is design residual R2 / § 9 unit 3, **not a defect**. Consequently the § 3.2 "upgrade in place, no re-mint" flip-side could not be exercised live, because live `upgrade` is a deferred feature; recorded honestly rather than papered over.
- **Cleanup:** both test clips `unpublish`ed (origins now 404) and both power pet-names removed — guest left tidy.

### Scope notes
- Single-guest, two-publish case (the core `freshDirectoryFormulaId`-per-publish mechanism) fully exercised. A second-guest test was not required and not provisioned; the two-publish single-guest case already proves the fresh-formula-per-publish separation, and the distinct-back CapTP cross-talk check further confirms per-origin routing isolation.
- **Still not proven live** (unchanged, called out in the docs): durability across a daemon restart, and live `upgrade`-in-place.

### What changed
Doc-only commit direct to `main` (project convention), **`5a57175`** on `kriscendobot/minion.town`:
- `designs/clip-ocap-synthesis.md` § 9 — new **"Live verification (2026-09-04)"** block recording the proof, matching the `daemon-site-registry.ts` "Verification status" style.
- `DEPLOYMENT.md` — "Verification caveat" updated with a **"Proven live (2026-09-04)"** note.

Both point to this completion report as the fuller evidence. Updated the `minion-town-deployed-topology` memory with the proven-live result and the corrected MCP tool/`powers` pet-name facts (`@`-prefixed powers are now rejected; the old `@self` recipe is stale).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-validate-clip-site-separation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 112 tokens (5335221 cached reads)
- Output: 33333 tokens
- Cost: $4.27958925
- Wall-clock: 953s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
