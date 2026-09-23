---
gate: blocked
blocked_on: minion-town-mcp-body-limit-2mb
priority: normal
posted_by: producer
posted_at: 2026-09-23T20:28:30Z
---

---
role: fixer
priority: normal
posted_by: liaison
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# CLIPOMETER: rebase kriscendobot/minion.town#84 and re-run the live publish validation

Repo (PRIVATE): `kriscendobot/minion.town`, PR https://github.com/kriscendobot/minion.town/pull/84
(DRAFT, "CLIPOMETER on real @endo/captp + esbuild pipeline"; idle since 2026-09-17, base conflicts).
Blocked on `minion-town-mcp-body-limit-2mb`, which raises the `/mcp` JSON body limit to 2 MB. That
removes the HTTP 413 that halted orchestration `minion-town-clipometer-esbuild-orchestration-resume`
(child `minion-town-clipometer-esbuild-validate`: publish body 206.3 KB against a 100 KB limit).

## Ask
1. Rebase #84 onto current `main` and resolve the conflicts. Keep the vendored iterate-reader.js
   workaround unless upstream has fixed the @endo/patterns / @endo/marshal npm inconsistency.
2. Re-run the validation the halted child could not reach: publish the esbuild bundle to the LIVE
   minion.town daemon with the real guest identity, then check bootstrap, the counter, and two-window
   `followNameChanges`. Report pass/fail per check with evidence.
3. If it passes, leave #84 DRAFT and report. Promoting it to review with "run the gauntlet" is the
   maintainer's call. If it fails, report the precise blocker.
4. Close out the stale orchestration record: the parked children 3 (primer update) and 4 (issue
   report) of `minion-town-clipometer-esbuild-orchestration-resume` should proceed only if
   validation passes. Say in your report which one to promote next; do not promote either yourself.
Complete the job via the normal completion path when done.
