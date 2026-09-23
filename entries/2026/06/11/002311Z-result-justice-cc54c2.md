---
ts: 2026-06-11T00:23:11Z
kind: result
role: justice
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 403
    role: target
refs:
  - entries/2026/06/11/001505Z-result-fixer-2e38d5.md
  - entries/2026/06/10/235730Z-result-barrister-5a67ca.md
  - https://github.com/endojs/endo-but-for-bots/pull/403
  - https://github.com/endojs/endo-but-for-bots/pull/403#pullrequestreview-4472627220
---

# result: justice cc54c2 -- code panel round 2 on #403 (terminating)

## Pre-dispatch state check

- `gh pr view 403 -R endojs/endo-but-for-bots --json state,isDraft,mergedAt`:
  `state=OPEN`, `isDraft=true`, `mergedAt=null`. Proceeded.
- Fetched `feat/registry-capability` and checked out the brief's
  target SHA `a7d8a14b7` (worktree was stale at `584d06da3`).
- HEAD oid via `gh pr view 403 --json headRefOid`:
  `a7d8a14b717b2b3a8c83c53254218fe777c68931`. Matched.

## Panel composition

- Mode: **in-band-fallback** (the justice composed seat blocks
  sequentially against the per-seat role files and the delta diff; no
  `Agent` fan-out).
- Panel-hints output on the round delta (verbatim from
  `bash garden/skills/panel-hints/panel-hints.sh --base c0d348497`):

```
Panel-kind: code-panel

Always-on core (9): assessor, typist, stylist, packager, archivist,
  prover, saboteur, integrator, corner-prober
Always-fire (2): scribe, releaser

Path-triggered (4): breaker, curator, fast-checker, surfacer
  breaker  packages/exo-npm/src/reference-backend.js (M.interface / makeExo / ## Invariants)
  curator  packages/exo-npm/types.d.ts
  fast-checker  packages/exo-npm/test/mvs-resolver.test.js
  surfacer  packages/exo-npm (2 surface files touched)

Content-triggered (3): purist, warden, wire-watcher
  purist  matched: harden
  warden  matched: harden(
  wire-watcher  matched: sha256

Cross-panel (0): -

Suppressed (10): benchmarker, changeset-auditor, gateway, migrator,
  pruner, engine-realist, locksmith, spec-keeper, copyeditor, pedant

Recommended total: 18 of 26 code-panel seats (+ 0 cross-panel).
```

- Justice-side overrides: none. The recommendation was honored as is.
  The in-band fallback covered all 18 seats sequentially against the
  four-commit delta; each seat opened its block with prior-round
  closure confirmations on its primary surface before scanning the
  delta for new findings.

## Closure status of prior round-1 must-fix-loop items

All four `must-fix-loop` items from `barrister 5a67ca` are addressed:

1. **PR body redraft per upstream template.** `addressed (no SHA;
   PR-body edit via gh pr edit)`. The PR body now follows
   `.github/PULL_REQUEST_TEMPLATE.md` section-for-section: Description,
   Security / Scaling / Documentation / Testing / Compatibility /
   Upgrade Considerations, plus an "Out of scope (follow-ups)"
   trailer.
2. **`packages/exo-npm/src/snapshot-mapper.js` `entryDependencies`
   dead binding.** `addressed at SHA 9c249ede0`. The entry compartment
   now binds `harden(entryDependencies)` into `scopes`. Regression test
   `buildCompartmentMap binds entry compartment dependency edges as
   scopes` folded into the same commit per regression-evidence.
3. **`packages/exo-npm/src/mvs-resolver.js` offline transitive walk
   broken.** `addressed at SHA 818390c2c`. The `PackageCacheRow` shape
   carries an optional `packageJson` snapshot; the offline path decodes
   it and walks. Snapshotless cache rows surface on `unmetOptionals`.
   Regression test `resolve in offline mode walks transitive deps of a
   cached entry` folded into the same commit.
4. **`packages/exo-npm/package.json:4` stale layer-1 description.**
   `addressed at SHA ce9dd2f84`. Description refreshed to name the
   layer-1+2+3 scope.

## Closure status of prior round-1 summary-fix items

All six items in the summary-fix bundle (`a7d8a14b7`) or folded:

1. Workspace-version-mismatch on its own `workspaceMismatches`
   channel. Closed.
2. Both misplaced `eslint-disable-next-line no-continue` directives
   removed. Closed.
3. Multi-major coexistence: satisfies-range selection. Closed with
   regression test `buildCompartmentMap picks the entry-declared
   major for multi-major coexistence`.
4. `nohash-` prefix documented in `RegistryResolution.resolutionHash`
   JSDoc. Closed.
5. (Folded into MFL #2 commit `9c249ede0` per regression-evidence.)
6. (Folded into MFL #3 commit `818390c2c` per regression-evidence.)

## Disposition counts (this round)

- **Must-fix-loop**: 0 (terminating verdict)
- **Summary-fix**: 0
- **Follow-up**: 1 (new fast-check property test for multi-major
  satisfies-range selection)
- **Acknowledge**: 0
- **Drop**: 0

## New findings on the delta

One new `follow-up` finding from the `fast-checker` seat:

- `test/snapshot-mapper.test.js` — a property-test-shaped pass
  (`fast-check`-style; random candidate sets + random declared range)
  would be the maximalist form of the multi-major satisfies-range
  assertion. The current example-case test covers the load-bearing
  inversion (first-match to satisfies-range); out of scope for this
  PR. Lands as item 5 on the followup ledger.

No new `must-fix-loop`, `summary-fix`, `acknowledge`, or `drop`
findings. The delta is small and the fixer's fixes were disciplined
fix + test pairs.

## Formal review submission

- `gh pr review 403 -R endojs/endo-but-for-bots --comment --body-file
  /tmp/panel-403-round2.md`: success.
- Review ID: `PRR_kwDORRE4FM8AAAABCpYqlA` (REST id `4472627220`).
  State: `COMMENTED`. Submitted at `2026-06-11T00:22:26Z`.
- URL:
  https://github.com/endojs/endo-but-for-bots/pull/403#pullrequestreview-4472627220
- Used `--comment` (not `--approve`): the gh CLI is authed as
  `kriscendobot`, which is the PR author. GitHub's GraphQL rejects
  `--approve` on a self-authored PR per `skills/panel-review/SKILL.md`
  § Pitfalls. The verdict is preserved in the body's "Verdict"
  heading as `approve`.

## Post-loop actions (this round, terminating)

1. **`summary-fix` job post**: NOT posted. The round-1 summary-fix
   bundle is already addressed in `a7d8a14b7`; no new summary-fix
   findings this round.
2. **Follow-up ledger**: created
   `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--403.md`
   with `status: parked` and five items: the four round-1 follow-ups
   from `barrister 5a67ca` (layer-4 wiring, Phase 5 Rust backend,
   SQLite `PackageCacheTable`, `compartment-mapper` extension point)
   plus this round's new `fast-check` property-test follow-up.
3. **Proposed-rule message to gardener**: NOT written. No
   `[proposed-rule]` tag fired this round; all findings carry
   `[rule: ...]` citations.
4. **Appellate dispatch**: NOT triggered. No `follow-up` or
   `acknowledge` disposition this round qualifies as "small and in
   context"; the new follow-up is genuinely a future-work item
   (property-test refinement), and the four prior follow-ups are
   layer-4 / Phase-5 / SQLite-table / extension-point items that are
   each substantial work in their own right and not appellate-shaped.
5. **`@copilot` reviewer add**: `gh pr edit 403 --add-reviewer
   @copilot`: success (idempotent on this PR; was already a requested
   reviewer earlier in the chain).
6. **`gh pr ready 403`**: success. PR is now `draft: false`.
7. **Re-request kriskowal review**: `POST
   repos/endojs/endo-but-for-bots/pulls/403/requested_reviewers
   reviewers[]=kriskowal`: success. `requested_reviewers` now lists
   `kriskowal`.

## CI state at result-write time

CI on `a7d8a14b7` reports 12 pass / 13 pending / 0 fail. Passing
jobs: `test`, `lint`, `build`, `test-xs`, `test-hermes`,
`test-async-hooks (22, ubuntu-latest)`, `test262 (20.x,
ubuntu-latest)`, `test262 (24.x, ubuntu-latest)`,
`check-action-pins`, `build-wasm`, `familiar-bundle`,
`test-ocapn-python`, `zizmor`. Pending: the slower per-Node-version
matrix (`cover`, `test (20.x/22.x/24.x, ubuntu-latest)`,
`test (20.x/22.x/24.x, macos-15)`), `sandbox-drivers`, and
`viable-release`. No observed failures.

The panel does not block on CI; the un-draft is the load-bearing
signal the maintainer reads, and CI continues in parallel. The
maintainer reads the un-drafted PR at their next review window.

## Panel kind / execution mode

- Panel kind: **code-panel**.
- Panel execution: **in-band-fallback**.
- Round: **2** (the justice's first dispatch is round 2 by
  definition; the barrister `5a67ca` was round 1).

## Verdict and termination

**Verdict**: `approve` (preserved in body verdict heading; submitted
as `COMMENTED` per self-PR pitfall).

**Termination**: terminating round. The jury-fixer loop exits this
round; all `must-fix-loop` items from round 1 are closed and no new
`must-fix-loop` items surfaced on the round-2 delta. The PR is
un-drafted and kriskowal is re-requested.

**Next stage owed**: none from the bot side. The PR is ready for
the maintainer's substantive review at the maintainer's next review
window. The follow-up ledger is parked at `status: parked`; the
steward's per-cycle survey will revisit on the PR's merge event
(or its upstream mirror's merge event when boatman ferries).

## Self-improvement

The in-band fallback worked cleanly on a small delta. The pattern
that emerged: when the round-1 verdict's must-fix-loop items have
file:line citations and the fixer's `result` lists per-MFL SHAs,
the round-2 closure verification reduces to one `git show` per
SHA plus reading the regression test the fix introduced. The
`skills/regression-evidence/SKILL.md` discipline (fold the test
into the must-fix commit) made each item's closure confirmation a
two-line read: the implementation diff and the test that fails
without it. This is the documented expected behavior; no skill
update needed.

One observation worth a future gardener thought: the
`panel-review/SKILL.md` § Pitfalls names the self-PR
`--request-changes` rejection but does not explicitly name the
`--approve` rejection on a self-PR. The fallback is the same
(`--comment` with the verdict preserved in the body), but a future
justice on a clean re-run round will hit this same wall and an
explicit "self-PR rejects both `--request-changes` and `--approve`;
fall to `--comment` regardless of verdict" line in the Pitfalls
section would save a 30-second probe. Not promoting to a gardener
message: the existing Pitfalls text is close enough that a careful
reader infers the rule, and the fallback is correct.

Self-improvement: nothing this time.
