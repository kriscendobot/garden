# Skills (residual reference shelf)

The garden has adopted most reference skills into its own active library at `<garden-root>/skills/`. What remains here is the **residual set**: skills whose substance has not yet been folded in (or, for the endo-specific lore, whose right home is `journal/projects/endo/` rather than the generic skill library).

For how references work, see [`../../README.md`](../../README.md).

## Residual generic skills

These are not endo-specific; they could be adopted as garden skills when the relevant pattern next arises.

- [defer-stacking-on-in-flight-pr.md](./defer-stacking-on-in-flight-pr.md) — wait for the foundation PR to stabilize (CI green + maintainer review) before stacking dependents. Worth adopting when stacked PRs become routine.
- [design-precondition-discovery.md](./design-precondition-discovery.md) — verify the foundation package actually has the cited capability before forwarding a directive that assumes it. Useful when designs cite primitives that may not exist yet.
- [pr-cycle-state.md](./pr-cycle-state.md) — the two-file `PR-DISPATCH-STATE.md` + `PR-CYCLE-LOG.md` pattern and the no-op-rebase pitfall (compare commit content, not head SHA). The garden uses journal entries instead of state files, but the no-op-rebase content-check is novel and worth adopting into `pr-creation-flow` or a sibling skill.
- [pr-mirror-for-offline-review.md](./pr-mirror-for-offline-review.md) — strict-review vs working-mirror dispatch shapes for upstream PRs that the garden cannot monitor under the monitoring-safety constraint. Likely path for review of un-gated upstream repos.
- [ssh-fallback-workflow-scope.md](./ssh-fallback-workflow-scope.md) — swap to SSH push when an OAuth token lacks `workflow` scope and the diff touches `.github/workflows/`. Generic git-operations pitfall.
- [subagent-batching.md](./subagent-batching.md) — batch-list + parallel-wave dispatch with idempotent re-entry. Matters when corpus-wide sweeps land in the garden.
- [todo-link-classification.md](./todo-link-classification.md) — linked / unlinked / ambiguous TODO classification with the `@ts-expect-error XXX` reclassification gotcha. Useful for codebase-hygiene audits.

## Endo-specific lore

These are well-formed skill files whose right home is the journal's per-project context tree under `journal/projects/endo/` (per [context-library](../../../skills/context-library/SKILL.md)) rather than the generic `skills/` library. They are kept here until the migration happens.

- [babel-visitor-exhaustiveness.md](./babel-visitor-exhaustiveness.md) — `assertNever`-based Babel visitor sentinel discipline; `@endo/module-source` footguns.
- [fixture-naming-after-diagnostic.md](./fixture-naming-after-diagnostic.md) — endo `packages/<x>/{demo,test/_*,fixtures-*}/` shape; `import/no-relative-packages` lint rule.
- [lerna-ecycle-fix.md](./lerna-ecycle-fix.md) — Lerna + Turbo cyclic dependency diagnosis in the endo monorepo.
- [no-backward-compat-stage.md](./no-backward-compat-stage.md) — daemon / familiar / chat trio's no-backward-compat policy.
- [package-rename-cascade.md](./package-rename-cascade.md) — workspace package rename checklist for the endo monorepo (`.changeset/`, AVA test file rename, `repository.directory`, etc.).
- [ses-intrinsic-naming.md](./ses-intrinsic-naming.md) — `%Foo%` vs `Foo` vs `SharedFoo` in permits / code / prose contexts.
- [surface-module-pattern.md](./surface-module-pattern.md) — public-API surface modules in endo packages.
- [threat-model-jsdoc.md](./threat-model-jsdoc.md) — module-header threat-model JSDoc on ambient-authority attenuators.
- [ts-pin-skew-prepack-fail.md](./ts-pin-skew-prepack-fail.md) — endo monorepo TypeScript pin skew producing cross-workspace TS2578 errors.

## Adopted (no longer in this shelf)

The following reference skills have been fully adopted into the active library and the snapshots removed: adversarial-tests, autonomous-loop-pacing, benchmark-comparative-report, changeset-discipline, cherry-pick-followup, ci-runtime-comparison, ci-status-summary, conflict-resolution, coverage-driven-testing, dependency-graph-maintenance, design-queue-drift-check, em-dash-style-rule (renamed `em-dash-style`), groom-open-questions, panel-review-12-perspectives (substantially redesigned for the twelve-seat panel as `panel-review`), pre-pr-checklist, process-documents, prompt-section-discovery, pr-review-thread-replies, reactji-acknowledgment, rebase-before-followup, rebase-hygiene-audit, regression-evidence, relative-paths-rule (renamed `relative-paths`), review-feedback-followup-commits, roadmap-projection, saboteur-adversarial-review, self-improvement, velocity-recalibration, verify-upstream-state-before-pinning, worktree-per-pr, yarn-lock-separate-commit.

The full adoption history is in the journal; `git log -- references/endo-but-for-bots/skills/` on `main` traces the deletions.
