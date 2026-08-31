---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repository: kriscendobot/minion.town (fork worktree). Fix a deploy-breaking residue of the weblet→clip rename that merged as PR #54 (commit `04fde93`, merge `b198f87`).

Problem: `deploy/aws/caddy/conf.d/weblet-gateway.caddy` was `git mv`d to `clip-gateway.caddy`, but `deploy/aws/scripts/deploy-caddy.sh` renders conf.d with one `tee` per file present in the repo (`for f in "$CADDY_SRC"/conf.d/*.caddy`) and **never prunes** files that disappeared from the repo. The live box therefore still holds `/etc/caddy/conf.d/weblet-gateway.caddy` alongside the newly written `clip-gateway.caddy`. The root Caddyfile does `import conf.d/*.caddy`, so both are imported and three site addresses are defined twice — `ocap.site`, `*.ocap.site`, and `*.weblet.minion.town`. `caddy validate` gates the reload in that script, so the next Caddy deploy (including the `deploy.yml` CD step) fails, blocking deploys until someone hand-removes the stale file.

Scope:
- Make `deploy-caddy.sh` reconcile conf.d rather than merely overlay it: after writing the repo's files, delete any `/etc/caddy/conf.d/*.caddy` not in the rendered set (do the deletion before `caddy validate` so validation reflects the final state), keeping the script idempotent and SSM-only.
- Confirm on the live host whether the stale `weblet-gateway.caddy` is in fact present (SSM Run Command; see DEPLOYMENT.md § Caddy config discipline) and remove it, then `caddy validate` + `systemctl reload caddy`.
- Check the same never-prunes pattern in the sibling deploy scripts (`deploy-caddy-route53.sh`, `deploy-www.sh`, any other conf.d/asset renderer) and note or fix equivalent orphan-on-rename hazards.
- Add a regression check if one is cheap; otherwise document the reconcile behavior in DEPLOYMENT.md.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-31T21:23:10Z
