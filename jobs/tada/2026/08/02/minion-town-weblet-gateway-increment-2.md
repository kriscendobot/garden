Working tree clean, branch pushed, PR #23 open, CI green and mergeable. Job complete.

---

## Completion report — `minion-town-weblet-gateway-increment-2`

**Built the Increment-2 CAS content plane** for the `*.minion.town` weblet gateway (`designs/weblet-gateway.md` § 5), replacing the Increment-1 placeholder with a real content-addressed origin. **PR: kriscendobot/minion.town#23** (commit `08c53f0`), **CI green** (typecheck + 178 vitest), mergeable.

### What changed (`src/endo/gateway/`, transplant discipline)
- **`content-store.ts`** — filesystem CAS: content-addressed blobs + manifests; blob-id validation blocks path traversal; content-type sanitized against header injection.
- **`content-server.ts`** — the § 5.1 request path: manifest resolution via an **exact map key** (a request path never joins the filesystem, so `../` traversal is structurally impossible), strong `ETag: "<blobId>"` + `Cache-Control: …immutable` + `If-None-Match → 304`, direct blob streaming, fail-closed `404` under the isolation floor, GET+HEAD only.
- **`ttl-cache.ts`** — async TTL memo (single-flight, negative caching) for the § 5.1 cached lookup.
- **`captp-vhost-table.ts`** — the CapTP-backed vhost table **seam** (the design's source of record), TTL-cached, built + tested against an in-memory daemon fake; the forward source that supersedes the fs source once the daemon weblet directory (Increment 4) exists.
- **`vhost-table.ts`** — record now carries `contentRoot`; fs source (out-of-band seedable) **retires the `GATEWAY_SEED_WEBLETS` env seed**; TTL wrapper.
- **`seed-weblet.ts` + `dev/seed-weblet.ts`** — out-of-band fixture seeder (the Increment-4 publish stand-in).
- Rewired `gateway.ts` / `config.ts` / `main.ts`; floor comment updated.

### minion.town-owned
- **Cookie-scope CI guard** (`test/gateway/cookie-scope.test.ts`): static-asserts `cookie_domains`/`cookieDomains` is never widened to `.minion.town`, runtime-asserts a weblet response sets no cookie. New `.github/workflows/test.yml` runs it; `vitest.config.ts` excludes the self-contained `deploy/thunks/*` sub-packages so **`npm test` == CI, both green** (fixed a pre-existing parity gap — the SIWE thunk's `viem` tests were being globbed by root vitest).
- Deploy: `endo-gateway.service` (`GATEWAY_STORE_DIR`, seed.env retired), `deploy-endo-gateway.sh` (store provisioning + seed.env removal), `seed-weblet-fixture.sh` (SSM out-of-band seeder), DEPLOYMENT.md.

### Tests + local edge evidence
47 new/updated gateway tests pass; full suite 178 pass. **Live local probe** (real `endo-gateway` process, seeded fixture): `GET /index.html` → correct bytes + `text/html; charset=utf-8` + `ETag "183ddc…51a1"` + `immutable`; re-`GET If-None-Match` → `304`; CSS asset → `text/css`; unknown path + raw/encoded `../` traversal → `404` (no leak) under the floor; `ask(live/dead/apex)` → `200/404/404`; **no `Set-Cookie`, no `Access-Control-Allow-Origin`** (incl. cross-origin `Origin: minion.town`); every § 5.2 header exact.

### Deferred (coordinated follow-up, not incomplete)
**Merge / CD / live edge-verify is intentionally deferred.** A peer's Increment-1 edge-verify (over the bus) reported the merged `*.minion.town` on-demand-TLS wildcard broke managed subdomains (`github-idp`/`siwe-idp`/`www` — **login down in prod**), and the weblet **namespace is under maintainer arbitration** (`<hash>.minion.town` vs `<hash>.weblet.minion.town`, owned by PR #21/#22). I confirmed and flagged (peer reply, PR comment, issue #58 comment) that **this PR's content code is namespace-agnostic** — it keys off `MINION_TOWN_DOMAIN` and follows either decision with a deploy-time env change only, touching neither the Caddy wildcard block nor DNS. Merging into the active incident would be irresponsible; the deploy step should run once the namespace decision lands.

**Reported:** peer reply (recipient had completed → dead-lettered + promoted, intent preserved); PR #23 namespace note; **issue kriscendobot/garden#58** status comment (SHA + PR + probe evidence + deferral; issue not closed). Memory updated with the increment arc + blocker.

**Follow-ups:** set `MINION_TOWN_DOMAIN` per the namespace decision → merge → CD → live edge-verify; Increment 3 (powers plane), Increment 4 (publish cap + the daemon weblet directory the CapTP table binds).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-weblet-gateway-increment-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 161 tokens (12438439 cached reads)
- Output: 102124 tokens
- Cost: $10.697660500000001
- Wall-clock: 1432s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
