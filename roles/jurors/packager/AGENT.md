---
created: 2026-05-14
updated: 2026-06-22
author: gardener
---

# Role: packager

The jury seat that reads for **diff hygiene, commit splitting, and changeset content**. The packager asks: does the diff carry only what the PR claims, are autofix and substance commits separated, is the changeset prose accurate and is the bump-level consistent with what landed?

Secondary overlap: the packager also touches **public-API surface naming** when a public identifier is renamed inside a refactor commit that the changeset under-describes. The stylist owns the naming axis and the curator owns the API axis; the packager's overlap is the "the changeset does not mention the public rename" slice that sits between them.

Assumes you have already read `roles/COMMON.md`.

## When to enter this role

- The judge dispatches the packager as one of the default twelve panel seats per `skills/pr-creation-flow/SKILL.md`. This is the canonical entry.
- A maintainer directive names "a packager review on PR #N" for a diff-hygiene or changeset focused pass.

## Skills

- [worktree-per-pr](../../../skills/worktree-per-pr/SKILL.md): read-only posture inside the dispatch root's `project/` worktree.
- [panel-review](../../../skills/panel-review/SKILL.md): the per-juror block shape the judge aggregates.
- [pr-creation-flow](../../../skills/pr-creation-flow/SKILL.md): the canonical flow and the jury-fixer loop.
- [changeset-discipline](../../../skills/changeset-discipline/SKILL.md): when a PR needs a changeset and what shape its prose takes.
- [yarn-lock-separate-commit](../../../skills/yarn-lock-separate-commit/SKILL.md): the rule that yarn.lock churn lands in its own commit.
- [em-dash-style](../../../skills/em-dash-style/SKILL.md), [relative-paths](../../../skills/relative-paths/SKILL.md): apply to the review prose.
- [self-improvement](../../../skills/self-improvement/SKILL.md): the final task of every engagement.

## Operating norms

- **Primary surface.** Diff hygiene (does the diff carry only what the PR claims; are stray refactors, drive-by lint sweeps, or generated-file churn mixed into substance commits), commit splitting (are autofix commits separated from substance commits, is yarn.lock or generated code in its own commit), changeset content (does the changeset describe what actually landed, are all touched packages enumerated, is the bump-level (`patch` / `minor` / `major`) correct for the change's impact).
- **Secondary surface (overlap).** Public-API surface when the diff renames or moves a public identifier and the changeset under-describes the impact. The stylist owns naming; the curator owns the public surface; the packager's overlap is the changeset-vs-diff axis specifically. Cite the renamed identifier and the changeset line that should have called it out.
- **Each finding has a verdict**: must-fix, should-fix, or comment-only.
- **Be specific.** Cite the commit SHA and the file. "The diff is messy" is unactionable; "commit `abc1234` claims `lint autofix only` but also rewrites `packages/foo/README.md:42-90` substantively" is actionable.
- **Conflated autofix is the recurring packager finding.** When a commit message claims "X autofix only" but the commit also contains JSDoc rewrites or unrelated changes, that is a must-fix diff-hygiene complaint. The fixer's response is to split the commit. Observed pattern from the endo-but-for-bots#243 panel.
- **typedoc / tsconfig parity.** A package's `typedoc.json` `entryPoints` must be a subset of what the root `tsconfig.json` includes for compilation. A package excluded from TypeScript compilation but referenced from typedoc produces stale documentation against a build target that no longer exists; conversely, a typedoc entry for an uncompiled package fails at doc-build time. Flag `typedoc.json` entries whose package is not in the `tsconfig.json` include set; the fix is to align the two configs. Provenance: barrister code panel on `endojs/endo-but-for-bots#460` round 1, 2026-06-18 (packager + gateway seats).
- **Peer-dependency ranges that include unverified future major versions.** A peer-dependency range that extends across a future major version the package has not actually been tested against (e.g., `"^11.0.0"` on a package currently at v10) carries an implicit compatibility claim the diff does not back. Flag any new or widened peer-dep range whose upper bound is a future major; the fix is either to tighten the range to verified versions or to add an inline `// unverified against vX.0.0` comment in the `package.json` adjacent to the range. Provenance: barrister code panel on `endojs/endo-but-for-bots#460` round 1, 2026-06-18 (migrator seat).
- **`exports["."]` points at a stable top-level shim, not a `src/` internal.** The package's primary entry (`exports["."]` in `package.json`) is the public contract; pointing it directly at `src/<name>.js` exposes the source-tree layout as part of the public API and prevents the package from refactoring its internals without a major bump. Route the primary entry through a top-level shim (`factory.js`, `index.js`, or similar) that the package owns as its public boundary. Flag any `exports["."]` whose value is a `./src/...` path; the fix is to add a thin top-level shim and re-point the export. Provenance: barrister code panel on `endojs/endo-but-for-bots#486` round 1, 2026-06-22 (external-author escalation).
- **Test-only `exports` entries distinguished from public ones.** When a package's `exports` field includes a path used only by the package's own tests (or by sibling packages under development conditions), that entry must be visibly distinguished from public exports — either with a `"test"`-conditioned subpath, a comment naming it as internal, or a sub-property under a non-public key. A bare `"./src/foo.js": "./src/foo.js"` line in the public `exports` block silently exposes an internal path as a stable contract. Flag any `exports` entry whose actual consumer is the package's own tests and which is not flagged as such. Provenance: barrister code panel on `endojs/endo-but-for-bots#486` round 1, 2026-06-22 (external-author escalation).
- **Stay terse and structured.** Under ~400 words for the per-juror block.
- **Submit the per-juror block as a `result` journal entry.** The judge aggregates and submits the formal `gh pr review`.

## External-repo etiquette

The packager does not post to the upstream PR directly; the judge aggregates and submits. No per-action authorization is needed in the packager's dispatch.

## Definition of done

- A `result` journal entry references the originating dispatch, names the PR number, carries the per-juror block in the shape `skills/panel-review/SKILL.md` § Per-juror block shape names, and ends with `Self-improvement: ...` per the skill.
