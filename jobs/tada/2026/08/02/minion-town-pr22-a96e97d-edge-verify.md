Everything is verified, reported, and coordinated. Final external re-check green (seeded weblet 200, apex 302).

---

## Completion report

**Job:** Verify the Increment-1 edge definition of done for the `*.minion.town` weblet gateway (kriscendobot/minion.town#22, merged `a96e97d`) against the live host, and close any gap.

### DoD result — all 5 checks PASS
Verified against `i-0380cd68b90020fad` / `13.56.17.18` on 2026-08-02:
1. **`endo-gateway.service`** — enabled + `active (running)`, `User=endo-gateway`, listening on `127.0.0.1:3002`, `/gateway/health` 200. *(host/SSM)*
2. **Caddy** — `conf.d/weblet-gateway.caddy` loaded; running config confirms global `on_demand_tls { ask http://127.0.0.1:3002/gateway/ask }` and `*.minion.town` `on_demand:true`. *(host/SSM)*
3. **Seeded weblet** — seed `a3f1…7f80` (`/etc/endo-gateway/seed.env`, 0600 root) → base32 label `upy4fngv…p6aa`; `https://<label>.minion.town/` mints a Let's Encrypt cert on demand, serves the placeholder with the **exact** isolation-header floor from `isolation-headers.ts`, `Cache-Control: no-store`, **no `Set-Cookie`, no `Access-Control-Allow-Origin`**. *(outside)*
4. **Fail-closed** — garbage label → TLS handshake refused; `/gateway/ask` 200 seeded / 404 garbage/apex; `/gateway/*` reserved (health 200, everything else 404, never weblet content). *(outside)*
5. **Untouched routes** — apex `minion.town` 302 to login gate (own cert), `/.well-known/ocapn-cbor-np` + `/ocapn*` 426/serving. *(outside)*

Checks (1)–(2) required SSM host access; (3)–(5) are fully reproducible from outside via `curl`/`openssl`.

### Gap found — a production regression outside the DoD checklist
The new `*.minion.town` on-demand-TLS wildcard **breaks every pre-existing managed subdomain it covers**: `github-idp.minion.town` (GitHub login thunk), `siwe-idp.minion.town` (SIWE login thunk), and `www.minion.town` all fail TLS (`no certificate available`). **GitHub-login and Sign-in-with-Ethereum are currently down.** The apex survives only because the wildcard does not cover the zero-label apex.

**Root cause** (host Caddy debug logs + a local Caddy v2.11.4 repro with the internal CA that reproduces it exactly): Caddy's automatic-HTTPS wildcard-coverage dedup skips obtaining/loading the managed cert for any subdomain the on-demand wildcard covers; at handshake those names have no cert and their more-specific managed policy forbids on-demand → fail closed. A clean Caddy restart does **not** fix it (config-level).

**Fix validated in the local repro:** moving weblets to a dedicated `*.weblet.minion.town` namespace makes the infra subdomains obtain certs at startup and serve, while weblets still work on-demand and garbage still fails closed.

### Actions taken
- Restarted Caddy on the host (authorized; did not resolve it — confirming config-level). **No hand-patching** of the host.
- Posted full evidence + regression analysis on PR #22: https://github.com/kriscendobot/minion.town/pull/22#issuecomment-5154556565
- Sent the maintainer a journal message (result + regression + an explicit A/B namespace **decision request**), plus an urgent heads-up earlier.
- Notified the two in-flight peers: `minion-town-pr21-a96e97d-design-land` (owns the design reconciliation where the namespace fix belongs) and `minion-town-weblet-gateway-increment-2` (builds on the wildcard).

### Follow-up (deferred by design, not dropped)
The fix is a design fork (weblet URL scheme) that I should not decide unilaterally while a design-landing peer is in flight. I recommended **A** (dedicated `<hash>.weblet.minion.town` namespace, keeps login-critical TLS independent of the gateway) over **B** (keep `<hash>.minion.town`, make infra on-demand + gateway-approved). The follow-up PR through the gauntlet is blocked on the maintainer's namespace decision, which I've requested; the design-reconciliation job (kriscendobot/minion.town#21) is the natural owner to encode it. Production auth stays down until a config fix is deployed via CD.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-pr22-a96e97d-edge-verify.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 103 tokens (6001537 cached reads)
- Output: 95991 tokens
- Cost: $7.092370499999999
- Wall-clock: 1497s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
