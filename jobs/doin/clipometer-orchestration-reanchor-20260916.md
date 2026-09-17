---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Re-anchor the clipometer orchestration and un-archive PR #84's gauntlet.
MAINTAINER DECISION (kriskowal, liaison muster 2026-09-16): the live-CLIPOMETER
replacement is still wanted.

THE HALT RECORD WAS STALE. `minion-town-clipometer-esbuild-orchestration` reported
"0/4 children done" because child 1 (`...-pipeline`) stalled 2501s against a
2400s handler-timeout. But child 1 SUBSEQUENTLY RECOVERED on a reaper requeue and
COMPLETED: draft PR kriscendobot/minion.town#84 (`CLIPOMETER on real @endo/captp +
esbuild pipeline`) is OPEN with CI green. Its own gauntlet reached panel-3 and was
then archived 2026-09-05 by the liaison during a fleet drain ("archive all
scheduled gauntlets during the drain") — which is why #84 never un-drafted. True
state: child 1 DONE, children 2-4 still parked. Drain-parked, not failed.

TASK:
1. Un-archive kriscendobot/minion.town#84's gauntlet and carry it to un-draft.
   Do NOT restart it from the beginning — it had reached panel-3.
2. Re-anchor the orchestration to RESUME AT CHILD 2
   (`minion-town-clipometer-esbuild-validate`). Do not re-run child 1; its
   deliverable already exists as #84. Remaining children in order:
   minion-town-clipometer-esbuild-validate,
   minion-town-clipometer-primer-esbuild-update,
   minion-town-clipometer-esbuild-issue-report.
3. Raise child 2's budget to `handler-timeout: 3600`. It is heavier than child 1
   (which itself took 2501s): a full build PLUS a live publish to prod PLUS a
   two-window Playwright validation. The 2400s default will not fit it.
4. CREDENTIAL CAVEAT — child 2's canonical publish needs the REAL guest MCP
   identity, not the disposable `minion-mcp-test-cc`. That credential is
   currently one of the maintainer's deferred items and may NOT be present in the
   job environment. If it is absent, do exactly what child 1's report prescribed:
   hand the publish step to the liaison/maintainer rather than publishing with
   the disposable identity or improvising. Say so plainly in your report.
5. Carry forward child 1's unresolved finding for child 2's live run to settle:
   the published `@endo/patterns@2.0.0` / `@endo/marshal@1.10.0` npm version
   inconsistency, worked around by vendoring `iterate-reader.js`. Child 2's live
   run against the real daemon is the checkpoint that confirms the vendored
   approach holds. Report what it shows.

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-17T03:13:38Z
