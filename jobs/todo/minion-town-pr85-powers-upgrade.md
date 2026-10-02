---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Implement in-place powers (`back`) upgrade on kriscendobot/minion.town PR #85

Repo: kriscendobot/minion.town, PR #85 (https://github.com/kriscendobot/minion.town/pull/85), head `feat/clip-upgrade-in-place`.
Context: kriskowal review 5393724080 asked why this PR defers upgrading a clip's powers. The answer (https://github.com/kriscendobot/minion.town/pull/85#issuecomment-5955947150) is that the deferral rests on a stale premise. The PR says the prod powers plane is off, but the tracked endo-gateway.service arms GATEWAY_ENDO_SOCK, the containment drop-in was disabled 2026-08-27 (issue #58), and powers-plane.ts reads directory `back` live for each session.

Before starting, check this PR's thread for a maintainer reply to that comment. If kriskowal says to keep powers out of scope, only correct the stale rationale (code comments, test comment at test/gateway/gateway.test.ts:163, PR body) and record the powers rewrite as a follow-up.

Otherwise:
1. Implement `resolvePowerReference` and the `back` rewrite in `makeDaemonGuestSiteAuthority` (src/endo/gateway/daemon-site-registry.ts). Re-designate `back` inside the CALLER's own guest, the same way publish does (`E(self).copy([powerPetName],[dir,'back'])`). Keep the `assertPowerPetName` refusal of @-names, and require the `powers` right on the upgrade capability.
2. Drop the "powers plane off" rejection in `assertUpgradable`/`writeDirectory` and update module header R2.
3. Add tests: unit coverage for the powers rewrite through publish.ts, a rejection test for a content-only attenuation, and extend the ENDO_CHECKOUT integration test so the live `back` changes after upgrade.
4. Run CI-equivalent checks locally (typecheck, lint, npm test), then push and update the PR body's Scope/residuals.
