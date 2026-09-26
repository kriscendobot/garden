Everything is complete and validated. No garden-repo (main2) changes were needed — this was a project build already merged by the prior run; my work was completing the deploy verification, DNS/edge validation, and reporting. Let me write the completion report.

Job complete. Summary report:

---

## Completion report: `fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1`

**Outcome: the ocap.site weblet isolation is built, deployed, and validated LIVE.** This is the `-1` requeue of the job; a prior run of the same base had already landed the code and provisioned DNS before being interrupted. I resumed, confirmed/recovered the deploy, and ran full edge validation against the design's §6 acceptance criteria.

### State found (from the prior run, verified real)
- Design `designs/ocap-site-weblet-isolation.md` (merged via kriscendobot/minion.town#34, maintainer-APPROVED: *"the DNS record needed on the `ocap.site` nameserver to direct traffic to the gateway. Proceed to build, deploy, and validate."*).
- Implementation merged to `main`: `feat bd5a54b` (isolate weblets on ocap.site) + `fix 2dcc271` (serialize certificate issuance). CI green on both.
- Dedicated Route53 zone `ocap.site` (`Z048672026UQWLGHNEQE0`) with apex A + wildcard `*.ocap.site` A → `13.56.17.18`, plus NS/SOA.

### What I did
- **Verified DNS + delegation:** apex and wildcard publicly resolve to the gateway edge; NS delegation to the AWS nameservers is active. This is the record the maintainer asked for — live.
- **Confirmed deploy:** the `feat` push-deploy (23:19) deployed the gateway; the `fix` push-deploy (23:23) hit a *transient oauth2-proxy 403 before the Caddy steps ran*, and a prior run recovered it with a `caddy`-targeted `workflow_dispatch` (23:28) that installed the Route53 Caddy module and validated+reloaded the serialized-cert config. Confirmed on-box: `endo-gateway` active, `WEBLET_PARENT_DOMAIN=ocap.site`, powers plane armed (`GATEWAY_ENDO_SOCK`).
- **Validated the edge (all green):**
  - Apex `https://ocap.site/` → 302 `https://minion.town/`, path+query discarded, no `Set-Cookie`.
  - Live weblet → 200 with the complete isolation floor: full CSP, `COEP require-corp`, `COOP same-origin`, `CORP same-origin`, `Origin-Agent-Cluster: ?1`, `Referrer-Policy: no-referrer`, `X-Frame-Options: DENY`, nosniff, `immutable` caching + ETag/304; **no** cookie, **no** CORS.
  - Fail-closed: unknown / non-canonical / short labels → 404 (TLS completes on the wildcard cert).
  - Two independent certs: apex `CN=ocap.site` (ordinary) and wildcard `CN=*.ocap.site` (DNS-01) — the serialize-cert fix; no per-weblet certs, hashes never enter CT logs.
  - Powers plane rides the new namespace (`/.well-known/ocapn-bootstrap` → `endo:<powers>`, `/.well-known/endo-captp` → 426 WS-upgrade).
- **Messaged the maintainer** with the go-live/validation summary (explicitly-requested milestone).
- **Updated memory** `minion-town-deployed-topology.md` with the ocap.site go-live (supersedes prior `*.weblet.minion.town` notes).

### Changes
- No garden-repo (`main2`) changes — nothing to commit/push there.
- No project code or DNS changes were needed; the implementation was already merged and the records already correct. My contribution was deploy-recovery confirmation, edge validation, maintainer report, and memory.

### Gaps / follow-ups (authority this host does not hold)
- **PSL PRIVATE-section submission is deferred by design** (design §4/§7, unit 6): admission gates (~2k–3k distinct publishers, >2-year registration term) are unmet and the owner attestations cannot be delegated to a bot. Not a blocker — the origin/header/cert defenses stand independently.
- **Registrar controls** (lock, DNSSEC, auto-renewal) belong to the domain owner. The zone is already delegated and resolving, so domain acquisition (unit 1) appears handled; verifying/hardening registrar settings needs registrar authority not held here.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 68 tokens (2484723 cached reads)
- Output: 27530 tokens
- Cost: $2.7244184999999996 (1 engagement(s) unpriced)
- Wall-clock: 1798s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
