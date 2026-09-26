99 tests pass (including my 4 new ones); the same 5 env-only failures exist on the pristine base (fake-git askpass harness + global `rerere.enabled`), so no regressions. The build is complete.

The build job is done: draft PR #706 is open against its frozen base, the identity-threading behavior is verified by execution against real git, and both packages typecheck cleanly.

---

**Completion report**

Built **Phase 2 of the git-capability stack** — the commit-identity boundary — in `endojs/endo-but-for-bots`, per `daemon-git-next-steps` § Phased Build Plan (sequenced by #691). Opened **draft PR #706** (`feat/git-commit-identity-boundary` → frozen base `llm-f7932ed`).

**What I did**
- Determined the base branch is **`llm`** (not `master`): `packages/git` and the daemon's git-formula surface exist only on the roadmap branch.
- Added a formula-owned, guest-immutable `{ identity: { authorName, authorEmail } }` construction option to **`provideGit`** and **`provideGitClone`**, threaded end-to-end: host-boundary validation → persisted in the `git` formula (survives deincarnation/restart) → captured by `makeNativeGitBackend({ repoRoot, identity })` → projected onto the git author/committer environment and merged into every mutating invocation through the existing **`withGitEnvOverrides`** seam.
- Omitted, the identity falls back to today's hardcoded `Endo <endo@invalid.local>`, so the change is **strictly additive**. `reword`'s author-preservation is unchanged (per-call `GIT_AUTHOR_*` overrides still win at the seam; only the committer is re-attributed).

**Files changed** (`@endo/git`, `@endo/daemon`)
- `packages/git/src/native-git-backend.js` — `commitIdentityEnvOverrides` helper + constructor `identity` param + threading into `runGit`/`runGitRaw`; exposed helper in `internalHelpers`; README doc.
- `packages/daemon/src/{host.js,daemon.js,interfaces.js,types.d.ts}` — `normalizeGitIdentity` validation, `formulateGit` identity param, `git` formula maker + `GitFormula` type, `provideGit` interface guard, `EndoHost`/`DaemonCore` type signatures.
- `packages/daemon/test/{git.test.js,endo.test.js}` — new tests. `.changeset/git-commit-identity-boundary.md`.

**Verification**
- **Backend behavior — verified by execution** (real `git`, 4 new git.test.js tests all pass): identity attributed to author+committer; default fallback when omitted; reword preserves original author while re-attributing committer; construction-time validation rejects a malformed identity. 99 tests pass; the 5 failures are pre-existing environment artifacts (fake-git askpass harness + global `rerere.enabled`) confirmed identical on the pristine base — no regressions.
- **Typecheck** — `@endo/daemon` and `@endo/git` `tsc` both pass with **0 errors**. Prettier + eslint clean (0 errors) on changed files.
- **Formula persistence** — a `provideGit persists the commit identity in its formula` integration test is included and typechecks but **could not be executed here**: the daemon's Unix-domain socket path (derived from this job's long worktree path) exceeds the 108-char `sun_path` limit, and the pnpm node-linker is incompatible with `--preserve-symlinks`. It runs on a normal-length checkout.

**Follow-ups**
- The design notes a tracking issue should be filed for **per-persona identity** (deriving the policy from `daemon-capability-persona` instead of per-`provideGit` options) when Phase 2 is dispatched — not filed by me (would be an upstream issue-open, which needs explicit authorization).
- The draft PR auto-runs the gauntlet (panel → fix → un-draft) under its supervising gardener; I did not un-draft it.
