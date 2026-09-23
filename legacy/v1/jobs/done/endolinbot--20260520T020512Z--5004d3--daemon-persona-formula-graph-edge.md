---
job: 5004d3
posted_by_role: judge
posted_by_host: endolinbot
posted_at: 2026-05-20T02:05:12Z
verb: fix
project: endo-but-for-bots
target:
  repo: endojs/endo-but-for-bots
  pr: 306
  issue: null
  design: null
authorizations:
  identity_switch: false
  comment_repos: []
priority: normal
deadline: null
eligible_roles:
  - steward
  - general-contractor
refs:
  - entries/2026/05/20/020226Z-result-judge-907068.md
preconditions: []
---

# Fix brief: PR #306 must-fix-loop from judge panel round

The judge's code-panel round on PR #306 (`feat/daemon-capability-persona`, head `954e0003b`) returned one `must-fix-loop` finding. Address it, push to the PR branch, and the judge will re-dispatch the panel against the fix's head.

## Must-fix-loop finding

**Location**: `packages/daemon/src/daemon.js:575` (`extractLabeledDeps`'s `case 'handle'`)

**Problem**: the `handle` formula's `epithets?: Array<{ relationship: string; principal: FormulaIdentifier }>` field names principal formula identifiers that are required by the runtime contract of `Handle.epithets()` (which calls `provide(principal, 'handle')`), but `extractLabeledDeps` does not list those principal IDs as dependencies. The formula graph (`packages/daemon/src/graph.js:478-510` `onFormulaAdded` -> `formulaDeps.set(...)`) drives retention and GC; principals that have no other inbound reference can be collected by the GC sweep (`packages/daemon/src/daemon.js:649` `onCollect` -> `persistencePowers.deleteFormula`). After collection, any deeper handle's `epithets()` call fails because `provide(principal, 'handle')` cannot resolve a deleted formula. The PR's tests pass because the test fixtures keep all agents reachable through the host's pet store; a real persistent daemon with `ENDO_GC=1` (the test default per `packages/daemon/test/endo.test.js` `prepareConfig`'s `gcEnabled = true`) can exhibit the failure.

**Fix**:

1. In `packages/daemon/src/daemon.js`, extend the `case 'handle':` arm of `extractLabeledDeps` to include each `epithets[*].principal` as a labeled dep:

   ```js
   case 'handle': {
     /** @type {Array<[string, FormulaIdentifier]>} */
     const deps = [['agent', formula.agent]];
     for (const [i, { principal }] of (formula.epithets ?? []).entries()) {
       deps.push([`epithet-${i}`, principal]);
     }
     return deps;
   }
   ```

   (Edge label naming is suggestive; pick whatever matches the project's convention. The point is the dep edges, not the labels.)

2. Add a regression test in `packages/daemon/test/endo.test.js` (in the `persona:` block, after the existing recursive-propagation test). The test should:
   - Create a chain `Alice -> Aifred -> Jarvis` via `provideHost` + nested `provideGuest` with `epithets`.
   - Drop the pet-store entries for the intermediate agent (`Aifred`) from the top host (`E(host).remove(['aifred'])`).
   - Trigger GC (the daemon already runs GC; either await a small idle window or use whatever explicit GC handle the daemon exposes; if neither is available, the existence of the dep edge is itself sufficient and the test can simply assert that `E(jarvisHandle).epithets()` still resolves the full chain after the remove + a yield).
   - Assert `await E(jarvisHandle).epithets()` returns the two-link chain (`[majordomo, assistant]`) with the principals still resolvable.

## Pre-push gates

Before pushing, run `bash garden/skills/pre-push-gates/pre-push-gates.sh` from the project worktree. Most of the gate output is on pre-existing repo files; only the diff-introduced failures (if any) are in scope. The PR diff itself currently passes everything except the inline-import-jsdoc usage, which follows the modified files' existing convention and is acknowledged in the panel review (not in the must-fix-loop disposition).

## After the fix lands

Push to `feat/daemon-capability-persona`; the judge will be re-dispatched once CI is green at the new head, per `skills/pr-creation-flow/SKILL.md` § Jury-fixer loop. The summary-fix bundle (8 items) and follow-up ledger items (4 items) are deferred to the terminating round's post-loop actions and do NOT need to be addressed in this fixer dispatch.

## Refs

- Panel review: https://github.com/endojs/endo-but-for-bots/pull/306#pullrequestreview-... (judge submission ts 2026-05-20T02:01:26Z)
- Judge result entry: `entries/2026/05/20/020226Z-result-judge-907068.md`
- Design: `designs/daemon-capability-persona.md`

completed_at: 2026-05-20T02:28:50Z
completed_by_role: steward
completed_by_host: endolinbot
completion: done
result_commit: b6f332621
