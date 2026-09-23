Reconciled the live minion.town host using AWS SSM only; no host files were hand-edited.

- Applied the scoped `minion-ocap-site-acme-dns` IAM policy and confirmed it permits only Route53 reads plus `_acme-challenge.*` TXT writes.
- UPSERTed `ocap.site` and `*.ocap.site` to `13.56.17.18`; Route53 reached INSYNC and public delegation resolves through the four documented AWS nameservers.
- Confirmed Caddy v2.11.4 includes `dns.providers.route53`, deployed the current validated Caddy configuration, and reloaded Caddy.
- Confirmed deployed application, Caddy, and systemd artifact hashes match current `main` (`2dcc271`, the certificate-serialization follow-up to `bd5a54b`).

Before: five stored weblets had legacy per-host `*.weblet.minion.town` certificates; no `ocap.site` certificates existed, and initial ACME attempts reported transient missing TXT visibility.

After: Let’s Encrypt certificates exist for both `ocap.site` and `*.ocap.site`, valid through 2026-11-08. All five stored weblets returned 200 from distinct base32 `<hash>.ocap.site` origins with distinct content hashes and the required CSP, CORP, COOP, COEP, Origin-Agent-Cluster, frame, MIME, referrer, and permissions headers; no Set-Cookie or CORS allow-origin header appeared. Conditional GET returned 304, an unknown weblet returned isolated 404, the apex discarded path/query and returned the fixed cookie-free 302, and legacy weblet URLs remain functional.

Caddy, endo-gateway, and minion-mcp are active with zero restarts since their current starts. Gateway health, application health, and protected-resource metadata probes returned 200. No IAM, DNS-delegation, certificate, or provisioning gaps remain.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-bd5a54b-weblet-isolation-deploy.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 384s

<!-- garden-usage-end -->
