All confirmed. The job is complete.

## Completion report

**Root cause (confirmed).** The failure is a **typescript-eslint project-service scaling ceiling**, not a config-glob gap. On `endojs/endo-but-for-bots@master` the per-package config `@endo/internal` already uses `useProjectService: true` (the job spec's `parserOptions.project: tsconfig.eslint-full.json` description was stale — that file is unused). A single `eslint .` builds **one** project service that must hold every package's TypeScript program at once; past the size this fork (a superset of upstream endo) crosses on large PRs, it drops its alphabetically-last packages and reports `packages/where/**` and `packages/zip/**` as "none of those TSConfigs include this file" even though each package's own `tsconfig.json` includes them. I ruled out the alternatives: total lintable JS is only ~847 KB (not a program-size/memory limit — node-heap caps OOM-crash rather than tail-drop), and the drop is not reproducible on the 125 GB dev host even at 133 packages, confirming it is an in-CI service ceiling.

**Fix (candidate remedy B — batched/sharded).** New `scripts/eslint-repo.sh` runs ESLint **one package per process** plus one batch per top-level non-package directory; `package.json` `lint:eslint` now delegates to it (`lint:fix` forwards `--fix` unchanged). Each service holds only one package's program, so the whole-repo ceiling can never be reached, regardless of repo size.

**What changed** (atomic lint-infra commit `998e88251` on branch `chore/lint-eslint-per-package-batches`):
- `scripts/eslint-repo.sh` (new, executable, heavily commented)
- `package.json` — `lint:eslint`: `eslint .` → `scripts/eslint-repo.sh`
- `.changeset/lint-eslint-per-package-batches.md` (new)

**Verification (real runs):**
- Batched run parses **exactly the same 1133 files** as `eslint .` — 0 missing, 0 extra (diffed via `-f json` file sets), including all 19 `where`/`zip` files; **same 0 errors / 5 warnings**, no phantom errors.
- `shellcheck scripts/eslint-repo.sh` clean.
- **CI `lint` job on PR #594: `completed success`** — the in-CI proof that the batched invocation works end-to-end (exec bit, PATH, coverage) and is green.

**Deliverable:** DRAFT PR **#594** → https://github.com/endojs/endo-but-for-bots/pull/594 (base `master`).

**Follow-ups (beyond gardener control):**
- #594 is DRAFT; it needs the gauntlet/maintainer to merge to master.
- Once merged, **#590** and **#581** should go green on rebase (the acceptance's final criterion — can only be confirmed after merge+rebase; I could not merge or force this from here).
- Not reproducible on the dev host, so the "large-PR drop disappears" criterion is proven by construction + the green #594 lint, not by observing the failure vanish locally. Honest caveat: this is the strongest evidence available pre-merge.
