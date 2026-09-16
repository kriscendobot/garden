---
tier: mentor
handler-timeout: 9000
token-budget: 100000
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:15:21Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Pin the merge base of endojs/endo-but-for-bots#1100 onto current `llm`, resolve
the resulting conflict, then resume its halted gauntlet from the fix stage.

WHY (triage job triage-halted-gauntlets-20260916, 2026-09-16): the
`ebfb-exo-stream-drop-base64-stream-methods-gauntlet` fix-2 stage correctly
declared `orchestration-failed`. This is a REAL, non-transient failure — a plain
gauntlet re-post would re-fail identically — caused by BASE DRIFT:

- endojs/endo-but-for-bots#1100 migrated `@endo/exo-stream`
  `stringLengthLimit` -> `byteLengthLimit`.
- Current `llm`'s `packages/9p-server/src/server.js` still calls the REMOVED
  `stringLengthLimit` API at 3 sites.
- GitHub tests the merge ref, so llm's stale call sites plus this PR's renamed
  type produce tsc + runtime failures. CI is confirmed RED right now (lint +
  test FAILURE on every leg).
- The branch is ~360 commits behind.

TASK, in order:
1. Pin the merge base per skills/frozen-base-branch and
   skills/verify-upstream-state-before-pinning: repoint the PR's base onto a
   pinned `llm-<sha>` branch, then rebase the head onto it.
2. Resolve the `9p-server` conflict. This is a SEMANTIC PORT, not a rename —
   `stringLengthLimit` and `byteLengthLimit` do not mean the same thing, so
   carry the intent at each of the 3 call sites rather than sed-ing the
   identifier. Say in your report what you concluded the correct byte limit is
   at each site and why.
3. Verify CI green on the rebased head before handing on.
4. Then resume the gauntlet from the FIX stage (not from clean/panel).

The PR premise is LIVE: endojs/endo-but-for-bots#1100 is OPEN draft, not merged,
not superseded.

<!-- garden-annotation: key=handler-budget-20260916 by=producer at=2026-09-16T23:15:15Z -->

handler-timeout: 9000

BUDGET CORRECTION (liaison, 2026-09-16): this job was doomed at the 2400s fleet
default after one wall hit with no productive progress. That default was never
right for this work: pinning a merge base on a branch ~360 commits behind, then
resolving a SEMANTIC port (stringLengthLimit -> byteLengthLimit across 3 call
sites in 9p-server, where the two names do not mean the same thing), then
verifying CI green, does not fit a 40-minute claim. Raised to 9000s.

If it still will not fit, SPLIT it rather than raising again: stage 1 pin + rebase,
stage 2 conflict resolution + CI verification, stage 3 resume the gauntlet from fix.
