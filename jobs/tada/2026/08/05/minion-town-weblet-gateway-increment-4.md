CI on PR #27 is green (`test` workflow: typecheck + test, pass). The job is complete.

## Completion report

**Job:** Weblet gateway Increment 4 — the publish capability (+ stubbed charge seam) for `kriscendobot/minion.town`, per `designs/weblet-gateway.md` § 7 (tracks kriscendobot/garden#58).

**What I built** (in an isolated project checkout, following the design's `@endo/*`-vs-minion.town split):

- **`@endo/gateway` seed** (`src/endo/gateway/`):
  - `publish.ts` — `makeWebletPublisher`: normalizes/validates the manifest and **rejects the reserved `gateway/` and `.well-known/` prefixes at the call site** (§ 4.3/§ 5.1); computes the `{ byteCount, blobCount }` **measure** and **draws the charge before interning** (§ 7.1 step 2); interns blobs + manifest → `contentRoot`; derives the `{ contentRoot, powers }`-only id (§ 3); **pins** (GC-deferral seam); registers `hash → record` **first-writer-wins** (§ 3). Plus owner-scoped `list` + owner-gated `unpublish` returning clean distinguishable results (`no-such-weblet` / `not-owner`).
  - `weblet-store.ts` — the write half of the CAS/vhost index behind a `WebletStore` interface; `makeFsWebletStore` writes the **same** store the Increment-2/3 gateway reads.
  - `vhost-table.ts` — added `listVhostRecords` + `removeVhostRecord`.
- **`@endo/mcp` seed** (`src/endo/guest-tools.ts`): `registerWebletTools` mounts `weblet_publish` / `weblet_list` / `weblet_unpublish`, exercising the facet's new `publish` capability composed at the one grant site (`guest-control.ts`).
- **minion.town wiring**: `weblet-payment.ts` stub `PaymentProcessor` (`cost = 0n`, logs `{ identity, cost, measure }`); `http.ts` builds the fs publisher and threads a per-caller owner-bound publish facet through the guest service; `config.ts` gates on `GATEWAY_STORE_DIR` + `MINION_TOWN_DOMAIN`; `server.ts` mounts the tools; admission is the unchanged `mcp/guest` gate (§ 7.3). `DEPLOYMENT.md` updated (incl. the new app-writes-the-store requirement).

**The charge seam (§ 7.2)** is decomplected: the mechanism emits only a measure; the operator's processor prices+draws; an unfunded draw fails at the capability before interning. The stub↔real swap rebinds only the processor.

**Verified (real execution):** `npm run typecheck` + `npm run build` clean; `npm test` → **209 pass** (18 new), including an **end-to-end check that the gateway serves the just-published content** and the MCP tool round-trip with the stubbed zero-cost charge log. **PR CI (`test`) is green.**

**Delivered:** PR kriscendobot/minion.town#27 (head `8b514e5`); report posted to kriscendobot/garden#58 (comment `5194061479`). I did **not** close the issue (submitter kriskowal closes it).

**Not verified / remaining (honestly flagged, not claimed done):** the live § 7 edge-verification (PKCE MCP client against production → live `<hash>` origin + `endo-captp` powers bootstrap + second-identity unpublish refusal + app charge log) requires **merge→CD**, which deploys to live minion.town — an outward-facing action I left for the maintainer/conductor. The **DNS-01/stable-alias TLS-at-scale cutover** (§ 4.2 open question 1) remains the open Increment-4 precondition before publish is exercised at volume.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-weblet-gateway-increment-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 137 tokens (11591341 cached reads)
- Output: 81397 tokens
- Cost: $9.875179499999998
- Wall-clock: 1143s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
