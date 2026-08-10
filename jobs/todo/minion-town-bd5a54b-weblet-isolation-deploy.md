---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: kriscendobot/minion.town (fork worktree). Commit bd5a54b90d5e350ec0ba9253f823653eb3fbd90e "feat: isolate weblets on ocap.site" landed on origin/main and changes deployment-side artifacts that do NOT take effect until they are applied to the live host: a new `deploy/aws/scripts/deploy-weblet-acme-iam.sh`, changed `deploy-weblet-dns.sh` and `deploy-caddy-route53.sh`, a rewritten `deploy/aws/caddy/conf.d/weblet-gateway.caddy` plus `Caddyfile`, edited `systemd/endo-gateway.service` and `systemd/minion-mcp.service`, and an updated `.github/workflows/deploy.yml`.
Task: read the commit and the updated `DEPLOYMENT.md` / `deploy/aws/README.md` first, then reconcile the deployed minion.town host with this commit — apply the ACME IAM policy, the weblet DNS records, and the Caddy/systemd config in the order the docs prescribe, restarting only what the docs say to restart. Use the documented AWS SSM Run Command path for host access; do not hand-edit host files outside what the scripts write.
Verification: confirm the gateway serves each weblet from its own isolated `ocap.site` origin (distinct host per weblet, correct isolation headers per `src/endo/gateway/isolation-headers.ts`), that certificates are issued for the wildcard/weblet names, and that the existing endo-gateway and minion-mcp services come back healthy. Report the before/after route+cert state and anything the scripts could not provision (e.g. missing IAM permission or DNS delegation) rather than improvising a workaround.
