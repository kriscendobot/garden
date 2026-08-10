---
gate: deferred
priority: normal
posted_by: producer
posted_at: 2026-08-10T23:00:57Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build / deploy / validate: isolated weblets on ocap.site (design #34)

Follow-on implementation for the APPROVED design PR kriscendobot/minion.town#34
(`designs/ocap-site-weblet-isolation.md`), per kriskowal's review directive
"Proceed to build, deploy, and validate." The DNS-record answer for the ask was
delivered on the PR: kriscendobot/minion.town#34#issuecomment-5246983148.

PARKED (deferred) because the program is gated on an owner-only, non-delegable
prerequisite: **`ocap.site` is not yet registered** (verified — apex does not
resolve). The bot cannot acquire the domain or make the PSL owner attestations
(design §4.2, §7). Promote the code-only units below immediately if desired; the
deploy/validate/PSL units unblock only after the owner acquires the domain and
delegates its zone.

Decomposition (design §7 follow-on units):

1. [OWNER-GATED] Domain acquisition + operator controls: register `ocap.site`
   (>2yr term), dedicated hosted zone delegated from registrar, registrar lock,
   auto-renew, MFA, DNSSEC, role mailboxes (security@/abuse@), abuse surface.
2. [CODE — unblocked now] Gateway/publish config rename `MINION_TOWN_DOMAIN` →
   `WEBLET_PARENT_DOMAIN` (default `ocap.site`) across minion-mcp, endo-gateway,
   publish tool, fixture seeder, host parser, powers plane, tests, service
   descriptions, DNS script, Caddy config; add browser-isolation headers
   `Cross-Origin-Embedder-Policy: require-corp` and `Origin-Agent-Cluster: ?1`
   (design §2.2, §3.3). Parser grammar must NOT widen.
3. [CODE + DEPLOY] Dedicated Route53/Caddy deployment: `deploy-weblet-dns.sh`
   takes content zone + parent domain as explicit inputs (default that cannot
   write `*.ocap.site` into the minion.town zone); apex 302-redirect site block;
   `*.ocap.site` Caddy block → existing gateway; DNS-01 wildcard cert for
   `ocap.site` + `*.ocap.site` with a SCOPED ACME role (edge holds no general
   Route53 write). Retire public `/gateway/ask` on-demand-TLS path (design §3.2).
   DNS records to publish once zone is live (edge EIP 13.56.17.18):
   `ocap.site A 13.56.17.18`, `*.ocap.site A 13.56.17.18`.
4. [DEPLOY + VALIDATE] Dual-namespace migration: publish emits `<hash>.ocap.site`,
   keep legacy `*.weblet.minion.town` read-only for a stated window; browser-edge
   verification per design §5 step 5 (apex redirect cookie-free, canonical live
   hash, unknown/non-canonical fail-closed, ETag/304, powers endpoints, header
   floor, no cookie/CORS).
5. [OWNER/OPS] Operating-history + PSL-readiness review (user-scale gates §4.1).
6. [OWNER-GATED] Domain-owner PSL patch + `_psl.ocap.site` TXT + review
   follow-through (design §4.2) — owner attestations, not delegable to the fleet.

Route units 2–4 to a builder; units 1/5/6 need the maintainer.
