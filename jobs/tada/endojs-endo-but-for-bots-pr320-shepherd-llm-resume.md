CI is fully green — **24/24 checks pass, `mergeStateStatus: CLEAN`** on the corrected head `18836dc69`, base `llm`. The job is complete.

## Completion report

**Task:** Rebase endojs/endo-but-for-bots PR #320 onto current `origin/llm`, unfreeze its base from the frozen `llm-b1c3f4d` snapshot to live `llm`, and drive CI to green (the PR had been blocked by the typescript-eslint projectService lint ceiling, now fixed on `llm` by the bucketed `scripts/eslint-repo.sh` in #597).

**What I did:**
- Re-fetched live PR state: OPEN, base `llm-b1c3f4d`, `lint` red — real work needed.
- Rebased the 5 head commits onto `origin/llm` in an isolated project worktree. Resolved conflicts in 3 files (`bundle.mjs` doc-comment: merged llm's ESM rationale with the PR's daemon-control mention; `daemon-manager.js`: took the PR's `verb`/`settleReject` semantics with llm's `30_000` numeric-separator style; `resource-paths.js`: kept llm's `endo-cli.mjs` rename plus the PR's `daemon-control.cjs` line). The two `ocapn` test commits (`makeClient`→`makeOcapn` migration + prettier) collapsed to empty — `llm` had independently landed the canonical migration — so I took llm's version and they dropped out. Net stack: 3 commits (feat + yarn.lock + timeout fix).
- Changed the PR base to `llm` (unfroze) via `gh pr edit --base llm`.
- Pushed; CI re-ran. `lint` **still failed — but on a genuinely different, in-scope issue**: `yarn build:types:check` flagged composite-tsconfig drift (`packages/familiar/tsconfig.composite.json`) because the new `daemon-control.js` introduced `@endo/daemon`/`@endo/init` imports. Ran `scripts/generate-composite-tsconfigs.mjs` (via a corepack yarn shim), which added exactly the two missing references; `--check` then passed. Folded the regenerated tsconfig into the feature commit via autosquash (which also carried the stack onto a further-advanced `origin/llm`) and force-pushed head `18836dc69`.

**Result (verified):** `gh pr checks 320` → 24 pass, 0 pending, 0 fail; `gh pr view` → `mergeStateStatus: CLEAN`, base `llm`. The lint ceiling is gone (eslint reports 0 errors) and the drift is resolved. No comment posted (none needed to drive CI green).

**Follow-ups:** None. The PR is green and mergeable; ready for the next chain stage (judge/merge) at the maintainer's discretion.
