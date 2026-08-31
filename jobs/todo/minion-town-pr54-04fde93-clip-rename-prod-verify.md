---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repository: kriscendobot/minion.town. Verify the live deployment against the weblet→clip rename merged in PR #54 (commit `04fde93`).

The rename changed externally-observable surfaces that persisted host state and external clients depend on:
- MCP tool names `weblet_*` → `clip_*` (`clip_publish`, `clip_list`, `clip_unpublish`, `clip_upgrade`) with **no back-compat aliases** — any existing client, runbook, or e2e recipe calling `weblet_publish` now gets tool-not-found.
- Env var names `WEBLET_*` → `CLIP_*` (`CLIP_PARENT_DOMAIN`, `CLIP_SITES_LIVE`, `CLIP_LEGACY_PARENT_DOMAINS`), read in `src/config.ts` and `src/endo/gateway/config.ts` with **silent defaults** and no old-name fallback: a stale `WEBLET_SITES_LIVE=1` left anywhere in host env would silently revert live `@sites` serving to off. The in-repo systemd units are installed wholesale by the deploy scripts and already carry the new names, so this is a check for out-of-band env sources (`/etc/minion-mcp/*.env`, any hand-set drop-in), not a known break.
- Renamed deploy scripts (`deploy-weblet-dns.sh` → `deploy-clip-dns.sh`, `seed-weblet-fixture.sh` → `seed-clip-fixture.sh`) — any external automation or runbook invoking the old paths is now broken.

Do:
1. Confirm the three deliberately frozen literals are still intact end to end on the live box: the `weblet.minion.town` legacy DNS domain (already-published `<hash>.weblet.minion.town` capability URLs must still resolve and serve), the `endo-weblet-store` unix group owning `/var/lib/endo-gateway/store`, and the `"weblet-v1"` hash-preimage domain-separation tag (derived content ids must not have shifted).
2. Grep the deployed host env / drop-ins for surviving `WEBLET_*` assignments and reconcile.
3. Run the post-deploy `CLIP_SITES_LIVE` first-boot confirmation DEPLOYMENT.md prescribes, plus a smoke of the renamed `clip_*` tool surface against `/mcp`.
4. Report which external references to the old `weblet_*` tool names still exist (docs, e2e recipes, garden-side notes) so they can be updated.

This is verification and reconciliation, not a re-rename: do not touch the frozen literals.

<!-- garden-transient-elapsed: kind=signature through=0 values=3 -->

<!-- garden-reaped: 1 -->
