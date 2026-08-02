---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: https://github.com/kriscendobot/minion.town (fork worktree `kriscendobot-minion.town`). PR https://github.com/kriscendobot/minion.town/pull/22 ("feat(gateway): Increment 1 — *.minion.town reachability") merged to `main` at commit a96e97d; the CD run https://github.com/kriscendobot/minion.town/actions/runs/30727267159 finished green and `*.minion.town` already resolves to 13.56.17.18 (verified: `probe-test.minion.town` → 13.56.17.18).
Task: verify the **Increment-1 edge definition of done** recorded in `DEPLOYMENT.md` § Weblet gateway against the live host, and close any gap you find.
Check, from outside the host where possible and via SSM Run Command on the instance where not: (1) `endo-gateway.service` is installed, enabled and listening on loopback :3002 under the `endo-gateway` user; (2) Caddy loaded `conf.d/weblet-gateway.caddy` and the global `on_demand_tls ask` points at the gateway's `/gateway/ask`; (3) for a weblet id in the `GATEWAY_SEED_WEBLETS` seed set (read `src/endo/gateway/vhost-table.ts` for the seeds and `src/endo/gateway/base32.ts` for the label encoding), `https://<label>.minion.town/` mints a cert on demand and serves the placeholder page carrying the full origin-isolation header floor from `src/endo/gateway/isolation-headers.ts` and no auth cookie; (4) an unknown/garbage hash label fails closed — `/gateway/ask` answers 404 so Caddy mints no cert — and the reserved `/gateway/*` namespace is not otherwise reachable; (5) the apex `https://minion.town/` and the existing `/.well-known/ocapn-cbor-np` and `/ocapn*` routes are untouched and still serving.
If everything passes, record the result as a journal message to the maintainer and comment the evidence on PR #22. If anything fails, fix it in a per-job worktree and open a follow-up PR through the normal gauntlet — do not hand-patch the live host beyond restarting a unit. Note in your report which checks required host access versus which are reproducible from outside.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-02T01:37:01Z
