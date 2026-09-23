Confirmed: the lint failure is identical on both runs — 5 parsing errors, all on `packages/zip/*` (the alphabetically-last package), the known typescript-eslint `useProjectService` scaling ceiling. It is unrelated to this PR's far-only diff and recurs deterministically. This is a lint-infra impasse, not a PR-scoped failure.

My substantive shepherd work is complete: the fix commit is pushed and every PR-caused red is now green. The one remaining red is a pre-existing repo-wide lint-infra issue that must not be bundled into a breaking refactor PR. Reporting the escalation.

## Shepherd report — endojs/endo-but-for-bots PR #591

**PR:** refactor!: remove @endo/far's deprecated plain re-exports (#548 follow-up, stage 2) — DRAFT, deliberately deferred (not for merge until importer-safety is confirmed).

**Diagnosis.** CI was red on 7 checks. Root cause of 6 of them: this PR removed all of `packages/far/test/*` (the tests exercised the now-removed re-exports), leaving the far `test`/`test:c8` scripts (`ses-ava`) with no files to run — ava exits 1 (`@endo/far#test` / `#test:c8`: "Couldn't find any files to test"), reddening the four `test (…)` matrix jobs and both `cover (…)` jobs. The 7th, `lint`, is a separate pre-existing issue (below).

**Fix applied** (commit `44590be94`, pushed to `refactor/inter-package-far-remove`): in `packages/far/package.json`, pointed `test` at `exit 0` and dropped `test:c8` entirely — the package now has no runtime code or tests to exercise, matching the no-test packages already in the repo (`git`, `conversation-tree`, `lockdown`). One atomic commit, in-scope, PR-caused.

**Result — re-run on the fix SHA:** all 6 previously-failing test/cover jobs are now green (`test 22.x/24.x × ubuntu/macos`, `cover 22.x/24.x ubuntu`), along with every other check (build, test262, test-xs, test-hermes, sandbox-drivers, viable-release, familiar-bundle, zizmor, …).

**Remaining red — `lint` (escalated, not fixed):** 5 parsing errors, all on `packages/zip/*` (`reader.js`, `src/deflate.js`, `src/inflate.js`, `test/zip.test.js`, `writer.js`) — "ESLint was configured to run … using `parserOptions.project` … However, none of those TSConfigs include this file." This is the known typescript-eslint `useProjectService` scaling ceiling that drops the alphabetically-last package on a large whole-repo `eslint .` run (isolation is clean; it is not a real lint fault in zip). It is **unrelated to this PR's far-only diff** — zip is untouched — recurs identically across both CI runs, and is a repo-wide **lint-infra** concern. Per standing guidance it must not be bundled into a breaking refactor PR, and the fix is not within this PR's diff, so a fixer working the PR's own scope cannot resolve it.

**Escalation classification: `next: liaison`.** The lint red is a lint-infrastructure impasse (projectService scaling ceiling), needing a separate lint-infra job / maintainer decision, not a PR-scoped fix. No PR comment was posted — this auto-dispatched job carries no commenting authorization. No maintainer inbox message sent (issue/PR-scoped comms are via comments only, and none is authorized here).

**Follow-up:** a dedicated lint-infra job to raise/repair the endo/ebfb whole-repo `eslint .` `useProjectService` ceiling so alphabetically-last packages (zip/where) stop being dropped on large PRs; it affects every large whole-repo PR, not just #591.
