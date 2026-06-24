---
ts: 2026-05-20T04:53:13Z
kind: result
role: fixer
dispatch_id: 18071c
dispatch_root: /home/kris/dispatches/fixer--18071c
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 306
    role: target
refs:
  - jobs/claimed/endolinbot--20260520T043741Z--24b50f--summary-fix-306.md
---

# Result fixer 18071c — PR #306 summary-fix bundle (8 items)

## Source

Job `24b50f`, posted by the judge after its 2026-05-20 terminating panel
round on PR #306 (`feat/daemon-capability-persona`). Eight `summary-fix`-
dispositioned items from round 1 that fell outside the must-fix-loop
bucket; the judge un-drafted on that round and these are the carried
remainder.

## Per-item disposition

1. **Method guards on `epithets` / `verify`**: tightened in
   `packages/daemon/src/interfaces.js`. The literal `M.promise(M.arrayOf(...))`
   form the brief cited is not a supported pattern in this codebase
   (`makePromiseMatcher` takes only an optional label string and rejects
   any payload pattern at `assertPattern`). The matching tightening that
   the framework supports is `M.callWhen(...).returns(<resolved-shape>)`,
   which awaits the implementation's promise and checks the resolved
   value against `M.arrayOf(EpithetShape)` (for `epithets`) and
   `M.boolean()` (for `verify`). This consumes the previously-exported-
   but-unused `EpithetShape`. Commit `f4aa40343`.

2. **`ExposedEpithet` drop**: removed from
   `packages/daemon/src/types.d.ts`. Zero `grep` consumers; its body
   (`{ relationship: string; principal: unknown }` plus a trailing
   "Handle remotable" comment) was the wrong shape for the actual API
   surface, which is documented in the implementation's JSDoc and in
   the runtime `EpithetShape`. Same commit `f4aa40343`.

3. **`HandleInterface` header rewrite**: replaced the "CRITICAL: ..."
   leading sentence (which read as a blanket prohibition on explicit
   guards) with a scoped explanation: the passable default exists for
   the envelope-carrying methods `receive` / `open`; the persona
   methods carry their own guards because they do not carry envelopes
   and the shape contract is well-defined. Same commit `f4aa40343`.

4. **`getFormulaForId(selfId).catch(...)` narrowing**: tightened in
   `packages/daemon/src/mail.js`. The catch now swallows only
   `ReferenceError` (the "No formula exists for number ..." signal from
   `daemon-database.js` `readFormula`) and re-throws every other error.
   Disk corruption (`TypeError: Corrupt formula for number ...`) and
   IO failures no longer silently fall through to an empty chain.
   Commit `520c4b629`.

5. **`verify` JSDoc**: added two restrictions to the JSDoc body
   (`packages/daemon/src/mail.js`). Local-node-only (pass-invariant
   Handle identity is the local exo cache; cross-node `===` denies
   even truthful claims) and top-link-only (the default checks the
   subordinate's most-recent epithet only; full-chain verification is
   the caller's responsibility via `epithets()` + per-link `verify`).
   Same commit `520c4b629`.

6. **`## Status` section on design doc**: added after the metadata
   table in `designs/daemon-capability-persona.md`. Lists what landed
   in PR #306 (file paths: `interfaces.js`, `types.d.ts`, `mail.js`,
   `host.js`, `daemon.js`, `endo.test.js`; backward-compatibility
   behavior; test coverage) and what is deferred (`HandleControl`
   caretaker plus pluggable verification policies, cross-node
   verification, service connectors, revocation, voluntary epithets).
   The metadata-table `Status: Not Started` stays as-is per the PR
   body's reasoning that the broader design has not landed. Commit
   `cb99e3332`.

7. **Changeset sentence-per-line**: rewrapped
   `.changeset/daemon-persona-epithets.md` so each sentence starts on
   its own line. Commit `ae8f80b6d`.

8. **Backward-compat persistence test + verify-self test**: two new
   tests at the tail of the `persona:` block in
   `packages/daemon/test/endo.test.js`. The first uses `openTestDb`
   to rewrite a guest's handle formula to drop the `epithets` field
   (simulating the pre-PR-#306 on-disk shape), restarts the daemon,
   and confirms the reincarnated Handle's `epithets()` returns `[]`.
   The second asserts `E(handle).verify(handle, ...)` denies for both
   the top-level host (empty-chain path) and a delegated guest
   (top-link principal is the creator, not self). Commit `a9dce3992`.

## Commits

```
f4aa40343 fixup(daemon-persona): tighten HandleInterface guards, drop ExposedEpithet, rewrite header
520c4b629 fixup(daemon-persona): narrow epithets() catch, expand verify() JSDoc
cb99e3332 fixup(daemon-persona): add Status section to design doc
ae8f80b6d fixup(daemon-persona): rewrap changeset sentence-per-line
a9dce3992 test(daemon-persona): backward-compat persistence and verify-self coverage
```

## Rebase

The PR's branch advanced from `954e0003b` (the brief's named base) to
`b6f332621` between job claim and dispatch start (two intervening
commits: `f4a8035a6` lint repair and `b6f332621` GC dep-edge fix). The
rebase carried one trivial conflict in `endo.test.js` (the new tests
appended after the GC test instead of after the recursive-chain test);
resolved by ordering: existing tests + GC test, then my two new tests.

## Local validation

- `npx ava test/endo.test.js --match 'persona:*' --timeout=120s` in
  `packages/daemon`: 11/11 pass (the existing 8 + GC test from
  `b6f332621` + my 2 new tests).
- Spot-checked broader subsets: `*Handle*` (6 pass), `*mail*` (5 pass),
  `*restart*` (7 pass). No regressions in the touched-file
  neighborhood.
- `yarn eslint` on the four changed files (`interfaces.js`, `mail.js`,
  `types.d.ts`, `endo.test.js`): 0 errors, 15 warnings (all
  pre-existing categories: `jsdoc/reject-any-type`,
  `@jessie.js/safe-await-separator`).
- `bash garden/skills/pre-push-gates/pre-push-gates.sh` (auto-fix
  enabled): the auto-fixers re-staged eight unrelated files with
  aggressive `@param` jsdoc insertions and an unrelated prettier sweep
  on `packages/ses/src/compartment.js`; I reverted those before
  committing. The remaining probe failures (`no-inline-import-jsdoc`,
  `security-md-hash-uniform`, `sentence-per-line-md`,
  `filename-no-stutter`, `no-pull-citations`) are all pre-existing
  repo-wide and unrelated to my diff. The probes scan the whole
  working tree rather than just the staged diff, so the baseline
  fails for everyone.

## Push and CI

Pushed `a9dce3992` to `feat/daemon-capability-persona` at
2026-05-20T04:52 UTC. CI is queued (25+ jobs pending at sample time);
the steward's CI watch will pick up the result.

## External-repo etiquette

This dispatch carried no per-action authorization for posting a
top-level summary, inline replies, or re-requesting review on PR #306.
The push is implicit in the fixer dispatch shape; per
`roles/fixer/AGENT.md` *Summary-fix dispatches are one-shot* and the
brief's framing ("the un-draft has already happened; the maintainer's
review is the next venue"), no judge re-dispatch follows from this
result.

## Cross-cutting observations

- **`M.promise(<payload>)` vs `M.callWhen`**: the design doc and the
  judge's brief both used the `M.promise(M.arrayOf(...))` form, which
  is not supported by `@endo/patterns` in this codebase
  (`makePromiseMatcher` takes only an optional label). The
  framework-correct way to tighten an async method guard so the
  resolved-value shape is checked is `M.callWhen(args).returns(shape)`,
  which awaits at the boundary. Worth a note in the design doc's
  *Handle extension* snippet next time it gets touched; the snippet
  as written would fail at `assertPattern` if anyone implemented it
  literally. (Not landing the design-doc correction in this dispatch
  because the dispatch's lane is the eight items in the bundle.)
- **`pre-push-gates.sh` auto-fix scope**: the gate's `yarn lint --fix`
  stage applies project-wide and produced eight unrelated files of
  noisy `@param` jsdoc inserts on this repo. The fixer needs to
  inspect what auto-fix touched before staging; the dispatch's
  framing ("auto-fixes land silently") under-states the discipline.
  The gate would be sharper if `yarn lint --fix` were scoped to the
  changed files (`git diff --name-only HEAD ../<merge-base>`) rather
  than the whole tree. Surfacing as a self-improvement message
  separately if the pattern reproduces.

## Self-improvement

Self-improvement: noted the `M.promise(<payload>)` non-support and the
`pre-push-gates.sh` auto-fix-scope friction above; the second may
warrant a message to the gardener if it reproduces on the next fixer
dispatch. Nothing structural to land from this round alone.
