---
role: weaver
tier: mentor
fallback-tier: minion
arc: minion-town-mcp-ocapn
dispatch: automatic
---
**Role: weaver.** Weave https://github.com/kriscendobot/minion.town/pull/130 ("fix(deploy): avoid daemon health-probe spawn race", APPROVED) onto the current `main`, using the frozen-base-branch procedure.

Maintainer decision (kriskowal, liaison muster 2026-10-07): weave rather than close. It's a distinct race from the EADDRINUSE port-reaper fix (#137, landed). If while rebasing you find `main` already fixes the spawn race, stop and report "superseded" instead of forcing it.

After a clean weave with CI green, post a conductor job to merge it. That job must re-validate CD and production after the deploy: guest API, the landing page rendered in a real browser, and the guest-locator section still hidden as before (see the original ask in job `kriscendobot-minion-town-pr130-conduct-prod-validate-20260928-resume`). Deploy facts and the EADDRINUSE orphan recovery recipe are in the minion.town memory notes on this host.
