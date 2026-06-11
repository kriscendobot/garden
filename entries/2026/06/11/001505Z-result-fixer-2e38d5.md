---
ts: 2026-06-11T00:15:05Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 403
    role: target
refs:
  - entries/2026/06/11/000900Z-dispatch-fixer-2e38d5.md
  - entries/2026/06/10/235730Z-result-barrister-5a67ca.md
  - https://github.com/endojs/endo-but-for-bots/pull/403
  - https://github.com/endojs/endo-but-for-bots/pull/403#pullrequestreview-4458261628
  - https://github.com/endojs/endo-but-for-bots/pull/403#issuecomment-4675920572
---

# result: fixer 2e38d5 -- address #403 barrister verdict (4 MFL + 6 summary-fix)

## Pre-dispatch state check

- Fetched `feat/registry-capability` and checked out `c0d348497`
  per the dispatch brief (the worktree was stale at `584d06da3`).
- `gh pr view 403 -R endojs/endo-but-for-bots --json state,isDraft,mergedAt`:
  `state=OPEN`, `isDraft=true`, `mergedAt=null`. Proceeded.
- Baseline test run on `c0d348497`: 39 tests pass.

## Work done

### Must-fix-loop items

1. **PR body redraft per template** (MFL #1).
   `gh pr edit 403 --body-file /tmp/pr-403-body.md` applied. The new
   body follows `.github/PULL_REQUEST_TEMPLATE.md` section-for-section:
   Description, Security / Scaling / Documentation / Testing /
   Compatibility / Upgrade Considerations, plus an "Out of scope
   (follow-ups)" trailer for the four follow-up ledger items. The
   "Design departures" content from the prior body folded into
   *Compatibility Considerations*.

2. **`snapshot-mapper.js` `entryDependencies` dead binding** (MFL #2).
   Commit `9c249ede0`. The mapper computed an `entryDependencies`
   table but never assigned it to the entry compartment. Wired
   `entryDependencies` into the entry compartment's `scopes` table.
   Regression assertion in `test/snapshot-mapper.test.js`
   (`buildCompartmentMap binds entry compartment dependency edges as
   scopes`) covers both registry-resolved and workspace-member
   bindings; fails closed without the fix. Folds summary-fix item 5.

3. **`mvs-resolver.js` offline transitive walk broken** (MFL #3).
   Commit `818390c2c`. The offline path called
   `decodePackageJson('{}')`, silently producing an empty edge set.
   Extended `PackageCacheRow` and `RegistryResolutionEntry` with an
   optional `packageJson` snapshot; the online path snapshots the
   packument's dependency tables; the offline path decodes the cached
   snapshot and walks. Caller-supplied row without the snapshot
   surfaces on `unmetOptionals` rather than producing a silent empty
   closure. Workspace selections also carry their snapshot for
   symmetry. Regression assertion in `test/mvs-resolver.test.js`
   (`resolve in offline mode walks transitive deps of a cached
   entry`) fails closed without the fix. Folds summary-fix item 6.
   Also threads `packageJson` through `cacheEntry` in
   `reference-backend.js`.

4. **`package.json:4` stale layer-1 description** (MFL #4).
   Commit `ce9dd2f84`. Refreshed the description to "EndoRegistry
   exo capability, MVS resolver, and snapshot-mapper for the
   daemon-worker importLocation flow" naming the layer-1+2+3 scope.

### Summary-fix bundle (`a7d8a14b7`)

1. **Workspace-version-mismatch on its own diagnostic channel.** The
   MVS resolver no longer reuses `unmetOptionals` for the
   workspace-mismatch case; a new `workspaceMismatches` channel
   surfaces it. Both channels documented on `RegistryResolution` in
   `types.d.ts`.
2. **Misplaced `// eslint-disable-next-line no-continue` directives
   removed.** Both instances in `snapshot-mapper.js`. The second loop
   reshaped to `if (compartments[dirKey] === undefined)` with no
   empty true-branch.
3. **Multi-major coexistence: satisfies-range selection.** The entry
   scope binding for a dependency now picks the candidate whose
   version satisfies the entry's declared range rather than the
   first matching key in `resolution.keys`. Imports `satisfiesRange`
   from `./mvs-resolver.js`. Regression assertion in
   `test/snapshot-mapper.test.js` covers the case.
4. **`nohash-` prefix documented on `resolutionHash`.** Lands in the
   public `RegistryResolution.resolutionHash` JSDoc in `types.d.ts`.
5. (Folded into MFL #2 commit.)
6. (Folded into MFL #3 commit.)

## Push and review actions

- `git push origin HEAD:feat/registry-capability` succeeded; the new
  head is `a7d8a14b7`.
- Top-level summary comment posted:
  https://github.com/endojs/endo-but-for-bots/pull/403#issuecomment-4675920572
- PR body redraft applied via `gh pr edit 403 --body-file ...`.
- Did NOT re-request maintainer review: CI is pending on the new
  head; per the fixer's "drive CI to green BEFORE re-requesting
  maintainer review" norm, this is the wrong moment. The orchestrator
  dispatches justice for the re-run next (per the dispatch brief);
  the justice's panel re-run is the appropriate next signal.

## Test, lint, typecheck state on the new head

- `packages/exo-npm && npx ava`: **42 passed** (39 prior + 3 new).
- `packages/exo-npm && npx corepack yarn lint`: clean.
- `packages/exo-npm && npx corepack yarn lint:types`: clean.
- Pre-push-gates: my files pass every probe. The script auto-fixed
  prettier/eslint findings in unrelated files (`packages/9p-server`,
  `packages/daemon`, `packages/endo-fs`, `packages/ses`, etc.) — I
  reverted those to keep my push scoped to the dispatch.

## CI state at result-write time

CI on `a7d8a14b7` is pending across the full matrix
(`test`, `cover`, `lint`, `build`, `test-xs`, `test-hermes`,
`test-async-hooks`, `test262`, `viable-release`, etc.). The
`build-wasm` and `zizmor` jobs already passed. No observed failures.

## Disposition of orchestrator-owned actions

- Justice dispatch for the re-run: orchestrator's next action per
  the dispatch brief.
- Follow-up ledger items (4): not addressed in this dispatch; the
  panel's post-loop action lands them on
  `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--403.md`
  at terminal-round close.
- Layer-4 deferral assessment: the prior barrister verdict already
  validated this as a `follow-up` disposition, not a `must-fix-loop`.
  No fixer action.

## Self-improvement

The summary-fix #3 fix (satisfies-range multi-major selection)
imported `satisfiesRange` from `./mvs-resolver.js` into
`./snapshot-mapper.js`. That's a slight intra-package coupling that
the build module did not previously have: the two modules now share
the range-predicate code path. The cleaner alternative would be a
small `range-predicate.js` shared module between them; the simpler
import path was the right call for the must-fix-loop round but a
future cleanup pass could split the predicate out. Not promoting to a
gardener message: this is a single-package concern, not a garden-level
rule.

Self-improvement: nothing this time. The dispatch brief was precise,
the barrister's must-fix-loop items had clear file:line citations,
and the summary-fix bundle's six items each had a tractable shape.
The fold-the-test-into-the-must-fix-commit shape from the
regression-evidence skill came up twice and worked cleanly both times.
