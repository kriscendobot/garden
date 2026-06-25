once: 2026-06-30T23:00:00Z
job_basename_prefix: dependabotany-recheck-endo-but-for-bots-pr197
---
# One-time embargo reevaluation: endojs/endo-but-for-bots PR #197 (electron 40→42)

Scheduled per maintainer directive on PR #197
(https://github.com/endojs/endo-but-for-bots/pull/197#issuecomment-4803509507,
kriskowal 2026-06-25): "Please schedule a job to reevaluate the embargo at the
proposed time." The proposed time is the **EMBARGO-2026-06-30** maturity floor
set by the dependabotany verdict of 2026-06-24
(https://github.com/endojs/endo-but-for-bots/pull/197#issuecomment — the
"Dependabotany verdict: EMBARGO until 2026-06-30").

Wear the [botanist](../../roles/botanist/AGENT.md) role. Re-run the botany
workflow against PR #197's CURRENT head on base `llm`:

1. Confirm the PR is still OPEN. If merged/closed, no-op and report.
2. Re-enumerate the lockfile moved set for the electron 40→42 bump.
3. Re-run OSV + GHSA on the resolved electron and its moved transitive set
   (notably `@electron/get@5`, `@electron-internal/extract-zip`, `undici@7`).
4. Re-confirm the resolved versions are now **>=7 days mature** and that nothing
   fresher slipped in via the caret `^42.0.1` (the prior recheck resolved
   `42.5.0`, published 2026-06-23T19:55Z, with `extract-zip@1.0.4` at
   2026-06-23T22:43Z — both cross 7 days at 2026-06-30T22:43Z).
5. Shepherd CI to green against the current head (green is necessary, not
   sufficient).
6. Execute the now-due terminal verdict: MERGE-NOW → conduct onto `llm`;
   still-fresh/regressed → re-embargo to the new floor with an updated verdict
   comment; REJECT → close with the verdict. A terminal verdict removes PR
   #197's row from the dependabotany ledger.

This one-time schedule self-deletes after firing. The standing daily
`dependabotany-recheck-endo-but-for-bots` sweep remains the heartbeat backstop;
this targeted job exists to satisfy the maintainer's explicit ask that #197 be
reevaluated at exactly the proposed time.
