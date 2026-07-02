# fix lint-infra: typescript-eslint program scaling ceiling drops where/zip on large PRs (endojs/endo-but-for-bots master)

## Problem

The root `yarn lint:eslint` (`eslint .`) fails on **large PRs** with 9 identical
parsing errors, all on the **alphabetically-last packages** `packages/where/**`
and `packages/zip/**`:

```
0:0  error  Parsing error: ESLint was configured to run on
`<tsconfigRootDir>/packages/where/test/where-endo-cache.test.js`
using `parserOptions.project`:
However, none of those TSConfigs include this file.
```

The root eslint config points `parserOptions.project` at `tsconfig.eslint-full.json`,
whose `include` globs (`**/*.js`, `**/*.ts`) DO cover where/zip. The files are not
excluded — the whole-repo typescript-eslint program simply fails to hold the entire
repo's file set, and the tail packages fall off. This is a **program/projectService
scaling ceiling**, not a config-glob gap or a code defect.

## Evidence it is infra, not any one PR's diff

- Two independent large PRs hit the **identical** where/zip tail-drop with entirely
  different diffs: **#581** (js-suffix export-key migration, 2026-07-01) and **#590**
  (repoint @endo/far consumers, 2026-07-02). Same tail, different diffs → size-driven.
- Base `master@eecc68` (2026-06-29) whole-repo lint is **green**; #590 is based on it
  and fails deterministically (verified across 2 re-runs of the lint job).
- The failing packages (where, zip) are **not touched** by #590's 100-file diff.
- Field note (memory reference_endo_lint_projectservice_scaling_ceiling): these
  packages lint **clean in isolation**; only the aggregate `eslint .` run fails.
- `ci.yml` does not re-run on merges to master, so trunk lint drift goes uncaught —
  master's last green lint predates the growth that crossed the ceiling.

## What to do (lint-infra scope — do NOT bundle into a feature/refactor PR)

Investigate and raise/remove the ceiling so large whole-repo `eslint .` runs include
every package. Candidate remedies for the fixer/builder to evaluate:

- Switch typescript-eslint to `EXPERIMENTAL_useProjectService` (or the stabilized
  `projectService`) with an adequate `maximumDefaultProjectFileMatchCount`, replacing
  the single monolithic `parserOptions.project: tsconfig.eslint-full.json` program.
- Or split the whole-repo lint into batched/sharded runs (e.g. per-package or
  chunked globs) so no single TypeScript program has to hold the entire repo.
- Or raise whatever program-size limit is being hit and confirm where/zip resolve.

## Acceptance

- `eslint .` on master (and on a large PR the size of #590) parses **all** packages,
  including where/zip — 0 parsing errors. Warnings unaffected.
- Change is its own atomic lint-infra commit + changeset; no feature/refactor code.
- Once landed on master, PR #590 (and #581, if still open) go green on rebase.

## Context

Surfaced by the shepherd on PR #590 (job endojs-endo-but-for-bots-pr590-shepherd),
which could not drive #590 green because the red is this pre-existing infra ceiling,
out of scope for the #590 refactor.
