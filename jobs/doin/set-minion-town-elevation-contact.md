# Set minion.town ELEVATION_CONTACT to kriskowal@kriskowal.com (amend -> commit -> push -> deploy)

Maintainer directive (2026-07-17): the elevation contact for minion.town is
**kriskowal@kriskowal.com**. Set it in `kriscendobot/minion.town` per DEPLOYMENT.md
§ "Set the instance administrator contact".

## 1. Amend (the tracked unit template — the ONLY file with the real value)
- In `deploy/aws/systemd/minion-mcp.service` (line ~51) replace the placeholder:
  `Environment="ELEVATION_CONTACT=TODO: set ELEVATION_CONTACT"`
  ->
  `Environment="ELEVATION_CONTACT=mailto:kriskowal@kriskowal.com"`
  Use the **`mailto:`** form so the app renders a clickable link (a bare email renders as plain
  text; DEPLOYMENT.md: only `mailto:`/`http(s)` become links). Preserve the outer quotes. Do NOT put
  the real value in `.env.example` (keep its placeholder) and do not touch `src/config.ts` (it only
  reads the env var).

## 2. Commit + push to `main`
- Commit and push to `kriscendobot/minion.town` `main`. The value lives in the tracked unit template
  on purpose, so a later `deploy-app.sh` cannot silently restore the placeholder.

## 3. Deploy (needs a host with AWS/SSM access to the minion.town infra)
- From a fresh `main` checkout, run `deploy/aws/scripts/deploy-app.sh` (installs the changed unit via
  SSM, reloads systemd, restarts `minion-mcp`).
- **Assess Phase C first.** DEPLOYMENT.md marks the styled privilege surfaces that RENDER
  `ELEVATION_CONTACT` (Phase C) as **BUILT, NOT YET DEPLOYED**, with the full live deploy deferred
  pending Phases A+B live:
  - If Phase C is already live: `deploy-app.sh` restarting `minion-mcp` with the new env suffices.
  - If Phase C / Phases A+B are NOT live yet: do NOT force the whole Phase-C deploy order blindly.
    Ship the committed value and run `deploy-app.sh`, then **surface to the maintainer** that the
    rendered elevation-contact surface still awaits the Phase A+B/C live deploy (a separate,
    maintainer-gated step).
- If this host lacks AWS/SSM access to minion.town, complete the amend+commit+push and surface the
  deploy step as needing the AWS-capable host.

## 4. Verify (only if deployed live)
- Per DEPLOYMENT.md post-deploy check: confirm the role panel / 403 page renders the intended
  `mailto:kriskowal@kriskowal.com` link. The contact is PUBLIC — inspect the rendered destination,
  not just service status.

## Done
`ELEVATION_CONTACT=mailto:kriskowal@kriskowal.com` committed + pushed to `kriscendobot/minion.town`
`main` in `deploy/aws/systemd/minion-mcp.service`, and either shipped live via `deploy-app.sh` or the
deploy surfaced as maintainer-/host-gated (Phase C or AWS access not ready). The `tada` report states
what was pushed, the deploy outcome, and the rendered-contact verification (or why it is deferred).

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 6
  worker_kind: cleric
  claimed_at: 2026-07-17T04:36:18Z
