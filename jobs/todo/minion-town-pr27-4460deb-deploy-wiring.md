---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Land the deployment wiring for weblet publish (Increment 4), merged to `main` as https://github.com/kriscendobot/minion.town/pull/27 (commit 4460deb, merge 65e655f). Work in a per-job worktree of kriscendobot/minion.town.

The merge shipped the publish capability but NOT its deployment wiring, so the feature is dark in production: `src/config.ts` gates `weblet_publish` / `weblet_list` / `weblet_unpublish` on `GATEWAY_STORE_DIR` (unset ⇒ tools do not mount) and shapes URLs with `MINION_TOWN_DOMAIN`, but `deploy/aws/systemd/minion-mcp.service` on `main` sets neither (only `endo-gateway.service` carries them), and the CD workflow (`.github/workflows/deploy.yml`, push-to-main) only redeploys existing units — it cannot invent the env. DEPLOYMENT.md § Weblet gateway states the requirement in prose only.

Do:
1. Set `GATEWAY_STORE_DIR=/var/lib/endo-gateway/store` and `MINION_TOWN_DOMAIN=weblet.minion.town` on the `minion-mcp` unit, alongside the existing `ENDO_SOCK`.
2. Grant `minion-mcp` WRITE access to the CAS store that `endo-gateway` reads — per DEPLOYMENT.md, a shared group owning `/var/lib/endo-gateway/store` with group-write + setgid, or store owned by `minion-mcp` and group-readable by `endo-gateway`. Keep both units' process isolation intact; check the unit's sandboxing (`ProtectSystem`/`ReadWritePaths` etc.) actually permits the write, and make `deploy/aws/scripts/deploy-endo-gateway.sh` (or the app deploy) create the ownership/mode idempotently rather than leaving it a hand-run.
3. Verify the wiring is reachable from CD alone — a fresh push-to-main deploy must leave the publish tools mounted with no manual step.

Then run the Increment-4 DoD edge verification DEPLOYMENT.md § Weblet gateway prescribes, against the live stack via the repo's PKCE MCP client at https://minion.town/mcp: `weblet_publish({content, powers})` returns a `<hash>.weblet.minion.town` URL; GET that origin serves the content; an `endo-captp` WS to it bootstraps the granted powers; a second identity's `weblet_unpublish` of the first's hash is refused; a manifest naming a reserved (`gateway/`, `.well-known/`) prefix is rejected at publish; and the app log shows the stubbed zero-cost `[weblet-charge]` line. Report the observed results, including on-demand-TLS behavior per publish (the § 4.2 DNS-01 / stable-alias cutover stays DEFERRED — do not attempt it here).

Out of scope: real ERTP charging and GC (deferred, § 8), and any Increment-5 work.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-58
issue_url: https://github.com/kriscendobot/garden/issues/58#issuecomment-5233033913
submitter: kriskowal
----- END ISSUE NOTE -----

Post issue-scoped progress only on https://github.com/kriscendobot/garden/issues/58 and PR-scoped work only on the PR. Never close the issue. Coordinate with the in-flight `minion-town-weblet-publish-land-pr27-20260809` job rather than duplicating its landing/review work.
