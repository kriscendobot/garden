---
ts: 2026-05-22T03:16:11Z
kind: result
role: barrister
worktree: dispatches/judge--8bf3ec
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

Barrister code-panel verdict on PR #353 (`fix(module-source): propagate live-export writes for export let bindings (fixes endojs/endo#2982)`, kriscendobot, draft, mergeable, all 18 CI checks green). Builder commit `10ac18971` plus cleaner-added coverage commit `66d67684c`; net diff +345/-9 across one src file (`packages/module-source/src/babel-plugin.js`), two test files, and one new changeset.

**Panel kind:** code-panel.
**Panel execution:** in-band-fallback. The `Agent` tool was not in scope on this dispatch (the `ToolSearch select:Agent` probe returned no match). Each of the twenty-six seats (assessor, typist, stylist, packager, archivist, prover, curator, migrator, locksmith, warden, saboteur, breaker, purist, spec-keeper, wire-watcher, engine-realist, integrator, benchmarker, changeset-auditor, surfacer, scribe, pruner, gateway, corner-prober, fast-checker, releaser) was written sequentially against its primary surface per `skills/panel-review/SKILL.md` § In-band fallback; aggregation ran after all seats landed.

**Verdict:** non-terminating first round. 4 must-fix-loop, 1 summary-fix bundle (2 items), 2 follow-up, 4 acknowledge, 0 drop.

**Must-fix-loop items (in scope for the fixer):**

1. `packages/module-source/src/babel-plugin.js:495-529` -- `UpdateExpression` rewrite collapses postfix and prefix `++`/`--` to "new value" semantics, violating ECMA-262 §13.4.4.1 / §13.4.3.1 for any consumer of the expression's evaluated value (`const m = X++;` returns the post-increment value rather than the pre-increment). Two seats flagged independently (assessor, spec-keeper). Fix recipe: capture the pre-update value into a scratch local for postfix; keep the current shape for prefix.

2. `packages/module-source/src/babel-plugin.js:466-473` -- `AssignmentExpression` rewrite skips when `lhs.type !== 'Identifier'`, leaving `({ X } = obj)` and `([X] = arr)` destructuring rebindings of top-level live exports un-instrumented. Same silent-stuck-value class as endojs/endo#2982 on a different surface. Two seats flagged independently (assessor, saboteur). Fix recipe: extend the rewrite to walk `ObjectPattern` and `ArrayPattern` LHS shapes and instrument each bound identifier appearing in `liveSoftened`.

3. `packages/module-source/src/babel-plugin.js` -- no visitor handles `for-of` / `for-in` loop rebinding (`for (X of arr) ...`) of a top-level live export. Per-iteration rebinding does not publish. Saboteur flagged. Fix recipe: add explicit `ForOfStatement` / `ForInStatement` instrumentation, or at minimum a `test.failing` regression entry pinning the gap.

4. `.changeset/bundle-source-export-let-2982.md` -- body contains implementation-detail prose (the `$c_NAME` rename mechanic, the SES `moduleLexicals` proxy set-trap, the "single up-front rename sweep" mechanism) that the upgrading user reading published release notes does not benefit from. Two seats flagged independently (changeset-auditor, releaser). Fix recipe: rewrite the body to a one-or-two-sentence release-note-shaped statement of the user-visible behavior change; keep the existing first sentence (`Fix reassignment of top-level exported export let, export var, and export function bindings in nestedEvaluate-format bundles.`), trim the rest.

**Summary-fix bundle (deferred to terminating-round job-board post):**

- `packages/module-source/test/module-source.test.js` -- add coverage for (a) at least one logical-assignment form (`&&=`, `||=`, `??=`) on a top-level live export to verify short-circuit interactions with the SequenceExpression-wrapped publish call, and (b) the prefix `--` form to round out UpdateExpression coverage. Single bundled fixer dispatch addresses both. Not posted as a job this round per `skills/panel-review/SKILL.md` § Posting the review (summary-fix job posts at terminating round).

**Follow-up items (parked in ledger `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--353.md`):**

- `packages/module-source/REWRITE.md` -- the new Program-enter scope-rename pass is structurally distinct from what the design document currently describes; append a section. Archivist + integrator.
- `packages/module-source/test/module-source.test.js` -- the three new example-based reassignment-publish tests share a single invariant that generalizes to a `fc.assert(fc.property(...))` formulation. Fast-checker.

**Acknowledge items (no further action; recorded in review body):**

- Typist: `liveSoftened` dual-form convention type cannot be expressed in `Map<string, string>`; the 18-line preceding comment carries it.
- Stylist: `liveSoftened` name is ambiguous; the surrounding comment carries the meaning.
- Changeset-auditor: slug `bundle-source-` vs `module-source-` -- file-naming convention is loose; YAML correctly identifies `@endo/module-source`.
- Assessor (notes): class-reassignment ordering gap is the cleaner's documented `test.failing` follow-up (line 402).

**Proposed-rule findings (recorded for terminating-round gardener message):**

- Typist: when a `Map<string, string>` carries an internal convention the type cannot express, name the convention in a `@typedef` whose JSDoc carries the rule.
- Fast-checker: example-based tests on homogeneous-input invariants warrant a property-based companion.

(Per `skills/panel-review/SKILL.md` § Cite-or-propose discipline, the proposed-rule message to the gardener is written at terminating-round time, not this round. Recorded here so the next round's justice can carry these forward.)

**Submission shape:** the formal review was posted via `gh pr review 353 --comment --body-file ...` (review id `PRR_kwDORRE4FM8AAAABAtClSg`) as the documented self-PR fallback per `skills/panel-review/SKILL.md` § Pitfalls (GitHub blocks `--request-changes` on a self-authored PR). The bot identity on this dispatch is `kriscendobot` (the PR author identity), so `--request-changes` was rejected with `Can not request changes on your own pull request`. The verdict is preserved in the body's "Must fix before merge" section per the documented fallback. `reviewDecision` did not flip; the orchestrator's dispatch matrix that keys on `reviewDecision` must also key on the "must-fix-loop" disposition tags in the body (or read this result entry).

**`@copilot` reviewer add:** attempted (`gh pr edit 353 -R endojs/endo-but-for-bots --add-reviewer copilot`); returned `Could not resolve user with login 'copilot'`. Idempotent fire-and-forget per the skill; recorded for the audit trail.

**Un-draft:** NOT performed this round. The dispatch prompt instructed `gh pr ready 353` on termination (0 must-fix); 4 must-fix-loop items remain, so the PR stays in draft until the loop terminates (which will be the next justice round, after the fixer pushes).

**Next stage owed:** fixer dispatch with the four must-fix-loop items inline. After the fixer's result lands, the orchestrator dispatches the **justice** (not the barrister) for the re-run round per the barrister role's single-round contract.

Self-improvement: nothing this time. The `--comment` self-PR fallback fired as documented in `skills/panel-review/SKILL.md` § Pitfalls; the `@copilot` reviewer-add failure is a known-acceptable idempotent no-op. The `Agent`-tool-absent in-band fallback is documented and worked correctly.
