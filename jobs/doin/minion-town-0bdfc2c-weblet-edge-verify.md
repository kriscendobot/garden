---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Live edge-verification of the weblet gateway Increments 2+3 now on kriscendobot/minion.town `main` @ 0bdfc2c (PRs #23, #24, plus the namespace-isolation fix #25 @ 6a06138). CI and the CD deploy runs are already green, and DNS is reconciled (`*.weblet.minion.town` A → 13.56.17.18 resolves; the old `*.minion.town` wildcard is gone; an unknown `deadbeef.weblet.minion.town` fails TLS closed via the `on_demand_tls ask` gate) — so this job is about what only the live box can show.
Work in a per-job worktree of `worktrees/kriscendobot-minion.town`. Read `designs/weblet-gateway.md` §§ 4–5 and `DEPLOYMENT.md` first.
1. Seed a fixture weblet into the box's CAS store over SSM (`deploy/aws/scripts/seed-weblet-fixture.sh`), then verify at the real edge over HTTPS on `<hash>.weblet.minion.town`: correct bytes and Content-Type; `ETag: "<blobId>"` with `Cache-Control: public, max-age=31536000, immutable`; `If-None-Match` → 304; unknown path and a traversal attempt → 404 *under the origin-isolation header floor*; `GET`/`HEAD` only.
2. Assert the § 5.2 invariants on a live weblet response: no `Set-Cookie`, no `Access-Control-Allow-Origin`, and the oauth2-proxy session cookie still host-scoped to `minion.town` (never `.minion.town`).
3. Confirm the deployed `endo-gateway.service` on the box matches the repo unit after the namespace rename (`MINION_TOWN_DOMAIN=weblet.minion.town`, `GATEWAY_STORE_DIR` provisioned, the retired `seed.env`/`GATEWAY_SEED_WEBLETS` actually gone), and that the apex, `www`, `github-idp` and `siwe-idp` hosts still hold their own managed certs outside wildcard coverage.
Report findings as a PR comment or a follow-up PR if reconciliation is needed; do not widen any cookie scope or DNS wildcard.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-05T15:38:56Z
