Comment posted successfully via REST (`#issuecomment-4861879786`). The GraphQL quota was exhausted; core REST quota is healthy.

All in-scope shepherd work is complete and validated with real evidence. No garden `main2` changes were needed (this was project-repo work; changes are pushed to the PR branch).

---

## Completion report

**Job:** shepherd (auto: red CI) on endojs/endo-but-for-bots PR #318 (`ci(familiar): trigger per-platform build`).

**Two distinct failures found; both in-scope ones fixed and verified:**

1. **`Make (darwin-arm64/x64, linux-x64)` failed — missing package stage.** The make matrix staged inputs via `prepare-package.sh` then jumped straight to `step:make`, which fails fast: *"Packaged app not found … Run the package step first."* The canonical pipeline (`packages/familiar/scripts/build.mjs`) is prepare → **`step:package`** (`@electron/packager`) → `step:make`; the package stage was omitted. **Added a `Package app` step.** Verified green via a `workflow_dispatch` run on the branch: **Make (darwin-arm64) ✅ and Make (linux-x64) ✅** both built with the added step. (macos-13/darwin-x64 was runner-queue-starved — infra, not a workflow error.)

2. **`lint` (prettier) failed — stale-branch merge artifact.** The branch was **~1038 commits behind `llm`**, which had independently rewritten `familiar-release.yml`; the PR-merge auto-combined both rewrites and **duplicated the `concurrency:` key** (prettier: *"Map keys must be unique"*). **Rebased onto current `llm`** (force-push `a8f72fe1b`→`bc44f453b`, lease-anchored), rebuilding on `llm`'s hardened workflow and keeping only the PR's genuine deltas: the `pull_request`/`push` triggers (the PR's purpose), `fail-fast: false`, and the `step:package` fix — while **preserving `llm`'s security hardening** (`persist-credentials: false`, `package-manager-cache: false`, `TARGET_OS`/`TARGET_ARCH` env indirection, scoped `release` perms, `contents: read`). Verified: merge ref now has a single `concurrency` key and **prettier passes on CI** (*"All matched files use Prettier code style!"*).

**Remaining red is out of scope / pre-existing:** `lint`'s eslint step still errors, but *only* on 5 `packages/zip/*` files with the typescript-eslint `projectService` ceiling (*"none of those TSConfigs include this file"*) — repo-wide base-branch lint drift on `llm` (CI never runs on `llm` pushes, so it accumulates uncaught; matches the known reference note). It is unrelated to this YAML-only change and cannot/should not be fixed inside this PR.

**What changed:** `endojs/endo-but-for-bots` branch `feat/familiar-ci-build-pipeline` rebased onto `llm` with the corrected `familiar-release.yml`. Posted a summary comment on PR #318. No garden `main2` changes.

**Follow-ups:**
- The `packages/zip` typescript-eslint `projectService` ceiling is a repo-wide lint-infra blocker for *all* PRs against `llm` (and would keep this PR's `lint` red). Warrants a dedicated lint-infra fix (tsconfig `include`s / eslint project config) — a separate concern from this shepherd job.
- When #318 merges, it also fixes the same missing-`step:package` bug on `llm`'s own `familiar-release.yml`.
