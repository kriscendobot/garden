---
role: gardener
handler-timeout: 10800
priority: urgent
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repository: https://github.com/kriscendobot/minion.town

# URGENT — Namespace A: move weblets to `*.weblet.minion.town` and END a 3-day production auth outage

**MAINTAINER DECISION (kriskowal, 2026-08-05): OPTION A.** Weblets move to a
dedicated namespace `<hash>.weblet.minion.town`. This supersedes design §3's
`<hash>.minion.town` scheme.

## The live incident this ends

Since **2026-08-02T01:48Z (>3 days)**, Increment 1's `*.minion.town` on-demand-TLS
wildcard has broken every pre-existing MANAGED subdomain it covers. Re-verified
2026-08-05T14:5xZ — all three still fail the TLS handshake:

    github-idp.minion.town   GitHub OIDC login thunk   TLS handshake refused
    siwe-idp.minion.town     SIWE/Ethereum login thunk TLS handshake refused
    www.minion.town                                    TLS handshake refused

Apex `minion.town` (302) and `/.well-known/ocapn-cbor-np` (426) are unaffected —
the wildcard does not cover the zero-label apex.

**GitHub-login and Sign-in-with-Ethereum are DOWN.** Restoring them is this job's
first and highest priority; everything else here is secondary.

Root cause (established by local Caddy v2.11.4 repro with an internal CA, by
`minion-town-pr22-a96e97d-edge-verify` — read its `jobs/tada/` report):
Caddy's automatic-HTTPS wildcard-coverage dedup **skips obtaining/loading the
managed cert** for any subdomain an on-demand wildcard covers; at handshake those
names have no cert and their more-specific managed policy forbids on-demand, so it
fails closed. **A Caddy restart does NOT fix it** — it is config-level.

## What to do

1. **Caddy config**: replace the `*.minion.town { tls { on_demand } }` block with
   `*.weblet.minion.town { tls { on_demand } }`. Infra subdomains
   (`www`, `github-idp`, `siwe-idp`, apex) then fall outside wildcard coverage and
   obtain managed certs at startup again. Option A was **already VALIDATED in the
   local repro**: infra subdomains obtain certs and serve; weblets stay on-demand;
   a garbage label still fails closed.
2. **DNS**: add `*.weblet.minion.town` (A → 13.56.17.18). The existing
   `*.minion.town` record was added one-time outside CD; check whether it should be
   removed or retained, and say which you did and why.
3. **Design PR kriscendobot/minion.town#21**: update §3 to the new scheme and
   reconcile the doc with what actually shipped in Increment 1. #21 is still DRAFT
   with **5 open questions at §9** — do not silently answer them; leave them open
   unless this decision settles one, and say which.
4. **Merge #23 (Increment 2) and #24 (Increment 3) together** once the namespace
   fix is deployed and prod auth is confirmed restored — NOT before. Both are
   complete and locally verified. Per Increment 3's report the gateway code is
   **namespace-agnostic (keys off `MINION_TOWN_DOMAIN`)**, so this decision needs
   **no code change** in either PR — verify that claim rather than assuming it.
   #24 is DRAFT: un-draft it as part of the merge.

## Verify at the live edge before you call it done

- All three managed subdomains serve over HTTPS again with their own certs.
- A seeded weblet hash under `*.weblet.minion.town` mints an on-demand cert and
  serves the placeholder with the exact isolation floor from `isolation-headers.ts`
  (CSP, CORP/COOP same-origin, XFO DENY, nosniff, no-referrer, Permissions-Policy),
  `Cache-Control: no-store`, and **no `Set-Cookie` / no ACAO**.
- A garbage label still fails closed (TLS refused, no cert).
- Apex 302 and `/.well-known/ocapn-cbor-np` 426 still serve.
- `/gateway/*` remains reserved (404, never weblet content).

## Discipline

CD is deploy-on-merge and this is a **live 5-tenant production host**. Do not
hand-patch the box outside the normal path. If a step needs an action you judge
outside this job's authority, STOP and report rather than improvising — the last
unreviewed production change is what caused this incident.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-05T14:57:17Z
