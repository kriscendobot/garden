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

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-16T05:54:24Z
