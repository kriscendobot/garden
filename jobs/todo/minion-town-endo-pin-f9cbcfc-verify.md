---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repository kriscendobot/minion.town, commit 920ffcc ("chore(endo): pin daemon after registry migration") bumped the pinned Endo daemon commit from `f66505034aaa54ac46294347b2bf0e14655b088a` to `f9cbcfc426f726858a671bcb09f7c2c774cc659e` in `.github/workflows/test.yml`, `deploy/aws/scripts/deploy-endo-daemon.sh`, and `src/endo/captp-client.ts` (PINNED_ENDO_COMMIT), and updated `test/endo-daemon-integration.test.ts` for new daemon surface (listValues, readOnly, accept, invite, loadContent).

This repeats a prior incident: a previous pin bump to `89481580` crash-looped production because `HostFormula.registry` became a required field with no upgrade/migration pass for pre-existing formulas (reverted in PR #111, commit 8e9f2be). This commit's message claims the registry migration has now landed upstream, but that has not been independently verified.

Shepherd this pin bump: confirm the pinned-Endo CI job (`.github/workflows/test.yml`) is green, run `test/endo-daemon-integration.test.ts` against the new pin, and verify the AWS deploy (`deploy/aws/scripts/deploy-endo-daemon.sh`) rolls out on the daemon host without a crash-loop (check daemon logs/process status post-deploy, not just CI). If it crash-loops, revert `ENDO_COMMIT` / `PINNED_ENDO_COMMIT` in all three files back to `f66505034aaa54ac46294347b2bf0e14655b088a`, matching the prior revert pattern, and report back so the standing memory on this recurring failure mode can be updated.
