---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: kriscendobot/minion.town (commit bc4ef70 on main, "fix(deploy): wire weblet publishing into CD", following the Increment-4 merge 65e655f / PR #27).

The commit changes only deployment surface — a new `endo-weblet-store` system group, `/var/lib/endo-gateway/store` reconciled as `minion-mcp:endo-weblet-store` with setgid 2775, `SupplementaryGroups` on both units, and `ReadWritePaths=/var/lib/endo-gateway/store` under `minion-mcp.service`'s `ProtectSystem=strict`. None of it is exercised by `.github/workflows/test.yml`; it can only be proven on the box. Verify it, and fix what does not hold.

Verification to perform (SSM-only, no interactive host login; see DEPLOYMENT.md § weblet gateway and deploy/aws/README.md):
1. Confirm the CD `deploy` workflow run for bc4ef70 succeeded through both the `app` and `endo-gateway` steps; if it has not run, dispatch it (target `all`) and watch it.
2. On the instance, confirm `getent group endo-weblet-store`, that `minion-mcp.service` and `endo-gateway.service` are both active after restart (a missing `ReadWritePaths` target makes systemd fail the namespace setup, so a start failure here is the expected first symptom), and that `/var/lib/endo-gateway/store` is `minion-mcp:endo-weblet-store` mode 2775 with `blobs/` and `vhosts/` reconciled.
3. Check for pre-Increment-4 leftovers the reconcile does NOT cover: files sitting directly under `store/` (not under `blobs/`/`vhosts/`) still owned `endo-gateway:endo-gateway`, and any path the publish code writes outside `store/` — those would fail closed under `ProtectSystem=strict`.
4. Exercise the real loop end to end: publish a weblet through the minion-mcp publish capability, then fetch it through the gateway at its `*.weblet.minion.town` vhost and confirm 200 + expected content. Confirm the gateway can read blobs/dirs the running minion-mcp process just created (the file modes there come from minion-mcp's umask, not from the deploy script's `find … chmod`, so this is the step that catches a group-readability gap the static reconcile hides).
5. Re-run `deploy/aws/scripts/seed-weblet-fixture.sh` and confirm it is still idempotent under the new ownership.

If any step fails, land the fix on `main` (this repo deploys from `main`; the preceding commit went direct) with the evidence in the commit message. If everything holds, report the verification — including the publish→serve transcript — as a comment on kriscendobot/minion.town#27 so the Increment-4 thread carries the proof.
