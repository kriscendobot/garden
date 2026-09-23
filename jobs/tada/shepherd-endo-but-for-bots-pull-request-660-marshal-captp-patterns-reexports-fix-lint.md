All 25 checks pass; `mergeStateStatus: CLEAN`, `mergeable: MERGEABLE`. The PR is fully green.

## Completion report

**Job:** Shepherd endo-but-for-bots PR #660 (`refactor: repoint @endo/marshal, @endo/captp, @endo/patterns consumers…`, branch `refactor/inter-package-reexports-marshal-captp-patterns`) to green.

**Diagnosis.** The sole failing check `lint` was not an ESLint failure (ESLint reported 0 errors) — it failed at the `yarn build:types:check` step with `Drift detected: packages/goblin-chat/tsconfig.composite.json`. Two distinct drifts, one self-inflicted and one merge-induced:

1. **goblin-chat drift (the PR's own bug):** the PR added `@endo/pass-style` to `packages/goblin-chat/package.json` dependencies but never regenerated the auto-generated `tsconfig.composite.json`, so its project-references list was missing `../pass-style/...`.
2. **daemon-cas drift (base moved forward):** the branch was forked one commit behind `origin/llm`, which had since landed `@endo/daemon-cas` (#442). CI tests the PR-merged-with-base tree, which surfaced a latent drift: `daemon-cas/tsconfig.composite.json` (committed on base) was missing its `../platform/...` reference.

**Fix.**
- Ran `node scripts/generate-composite-tsconfigs.mjs` in an isolated project worktree (via a `corepack yarn` shim, since the generator invokes `yarn` directly and it wasn't on PATH). This regenerated only the goblin-chat composite; committed it.
- Rebased the branch onto current `origin/llm` (`08f5accf67`, clean 3-commit rebase) — the fixed-lint baseline the job hint anticipated — then regenerated again, which produced the daemon-cas composite fix; committed that.
- Force-pushed the rebased branch (2 new `chore(...): regenerate composite tsconfig` commits on top of the rebased history).

**Verification.** `build:types:gen --check` reports "All composite tsconfig files are up to date" locally. CI settled to **25/25 checks passing, 0 failures**; PR is now `isDraft:false`, `mergeable:MERGEABLE`, `mergeStateStatus:CLEAN`.

**Follow-ups.** None required for this PR. Note: the daemon-cas composite drift is a latent issue that originated on the `llm` base itself (#442 committed a composite missing the `@endo/platform` reference); this PR now carries the corrected file, so merging #660 also fixes that latent drift on the base.
