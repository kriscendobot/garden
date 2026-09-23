---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-23T18:46:04Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Validate the re-export policy automation on a synthetic endo-but-for-bots PR

The build child landed the `no-plain-reexport` probe, the `reexport-auditor`
seat, and the `re-export-deprecation-policy` skill on garden `main2`. Validate
them end-to-end on a SYNTHETIC pull request against the fork
`kriscendobot/endo-but-for-bots` (a bot repo — safe). Get an isolated project
worktree with
`scripts/jobs/ensure-project-worktree.sh <this-job-base> kriscendobot/endo-but-for-bots <branch>`
and open the PR ONLY through `scripts/jobs/gardening/ensure-pr.sh` as a DRAFT.

Construct a synthetic fixture branch that exercises every Decision and prove:
- a bare `export { x } from './y.js'` with NO adjacent `@deprecated` → the
  pre-push probe FAILS the gate (blocks the push);
- the same line under a compliant `@deprecated` JSDoc naming the original →
  PASSES;
- a barrel `index.js` `export * from './internal.js'` → FLAGGED (Decision 1, not
  exempt);
- a type-only `export type { T } from './t.js'` → NOT flagged (Decision 5);
- run the code panel (or the seat-gate directly) and confirm the
  `reexport-auditor` seat spends a `claude -p` only when a candidate exists and
  files a must-fix complaint for the plain re-export while approving the compliant
  shim.

This is a VALIDATION artifact: keep the PR DRAFT, never merge it, and NEVER merge
or push to endojs/endo (upstream). Report the PR URL and a pass/fail line per
bullet. If a decision's behaviour is wrong, emit the orchestration-failed signal
so the campaign halts and surfaces to the maintainer rather than silently passing.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-23T18:46:08Z
