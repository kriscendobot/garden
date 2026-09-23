---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-31T22:38:40Z
---
Production verification for kriscendobot/minion.town PR #54 (`04fde93`, merge `b198f87`) completed against the live SSM-only host.

- Frozen literals: a live publish produced `adliqi3k5urpe3zix57u7r3pz7ru63lh2mryluh2wynenzmdrvtq`; both its `ocap.site` URL and the matching `weblet.minion.town` compatibility URL returned HTTP 200. The pre-rename persisted record `806fc2ea...b5a9f` recomputes byte-for-byte as SHA-256 of `"weblet-v1\n" + contentRoot + "\n" + powers`, confirming the frozen tag did not shift that id. Group `endo-weblet-store` remains GID 983, owns `/var/lib/endo-gateway/store` as `minion-mcp:endo-weblet-store` mode 2775, and GID 983 is present in both live service processes' supplementary groups.
- Environment/first boot: recursive audit of `/etc/environment`, `/etc/default`, `/etc/sysconfig`, `/etc/{minion-mcp,endo-gateway}`, and systemd unit/drop-in trees found no `WEBLET_*` assignment. Neither service has a drop-in. Effective env is `CLIP_PARENT_DOMAIN=ocap.site`, `CLIP_SITES_LIVE=1` on `minion-mcp`, and `CLIP_PARENT_DOMAIN=ocap.site`, `CLIP_LEGACY_PARENT_DOMAINS=weblet.minion.town` on `endo-gateway`. The latest boot log says `@sites registry installed ... clip publish is LIVE`.
- MCP smoke: authenticated `/mcp` `tools/list` returned `clip_publish`, `clip_list`, `clip_unpublish`, and `clip_upgrade`, with no `weblet_*` aliases. Publish returned `serving:true`; the new and legacy URLs both served; list contained the hash; unpublish returned `removed:true`; the cleanup list no longer contained it. An explicit `weblet_publish` call returned `Tool weblet_publish not found`.
- Reconciliation: `minion/test-cc-client` still advertised retired `mcp/minions:read mcp/minions:write` scopes, which made the documented machine smoke authenticate with only `mcp/tools`. Updated its `scopes` metadata to `mcp/tools mcp/guest` without changing credentials, then successfully ran `clip_list` using the secret metadata.
- External old-name references: no active occurrences remain in the project tree or garden `main2`. The append-only journal still contains historical recipes and reports, notably `jobs/tada/kriscendobot-minion-town-pr53-prod-validation-followup-20260827.md`, `jobs/tada/minion-town-browser-e2e-testing.md`, `jobs/tada/press-minion-town-e2e-prod-test-20260823.md`, and multiple old panel/result records. The active journal bulletin `README.md` and `inbox/maintainer/unread/20260828T194121Z-59223f.md` still say `weblet_upgrade`. Historical deploy-path references remain in archived gateway jobs; no active tree calls the removed scripts.
- Follow-up already owned elsewhere: production still has stale `/etc/caddy/conf.d/weblet-gateway.caddy` beside `clip-gateway.caddy`; job `minion-town-pr54-04fde93-caddy-confd-prune` owns that cleanup.

Self-improvement: nothing this time.
