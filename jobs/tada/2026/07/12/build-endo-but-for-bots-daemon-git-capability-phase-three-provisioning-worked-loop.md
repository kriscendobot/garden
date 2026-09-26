The PR diff is clean and entirely within `packages/agent-tools/` — the #705 push-tier files (stacked) plus my Phase-3 additions. No Phase-2 daemon/git files leak in. Everything is verified. The build is complete.

Draft PR #707 is open against the Phase-2 branch, in draft state, ready for the gauntlet its supervising gardener runs; I did not un-draft it.

---

**Completion report**

Built **Phase 3 of the git-capability stack** in `endojs/endo-but-for-bots` per `daemon-git-next-steps` § Phased Build Plan (sequenced by #691) / `daemon-agent-tools` § Phase 4: **capability-based git provisioning plus the worked end-to-end version-controlled-filesystem loop that is M3's exit criterion.** Opened **draft PR #707** (`build/git-capability-phase3-provisioning-worked-loop`).

**Stack.** Based the PR on the Phase-2 branch `feat/git-commit-identity-boundary` (draft #706), so the diff is only the new work, and merged **#705** (Phase 1, `makeGitRemoteTool` push tier) as a `--no-ff` stack commit so the loop can push through the granted `GitRemote` tool. Both deps share the frozen base `llm-f7932ed`. (Note: I read "against its frozen `llm` base" as lineage context and chose base=Phase-2-branch for the cleanest review surface; re-basing to `llm-f7932ed` is a one-line change if the panel prefers it.)

**What I built** (all under `packages/agent-tools/`):
- New `src/workspace.js` — the thin provisioning adapter over granted capabilities, replacing the path-root Fae git provisioning (`packages/fae`'s `run-command` tool runs `git` as a shell subprocess rooted at `FAE_CWD`/`cwd`). Exports `makeWorkspaceTools` (conditional composition, fail-closed on duplicate tool names), `provisionWorkspaceTools` (derives the file-tool `Filesystem` from the granted `Git`'s worktree mount, so one `Git` grant yields edit + versioning tools over the same worktree), and `provisionHistoryTools` (read-only file tools over `filesystemAt(ref)`). Commit attribution rides the granted `Git`'s formula-owned Phase-2 identity; the adapter never re-states it.
- New `test/git-worked-loop.test.js` — the M3-exit loop driven **entirely through the provisioned catalog**: branch → edit via file tools → real `node` shell build step → status/diff/commit via git tools → push via the #705 remote tool → inspect the pushed ref via `filesystemAt`, asserting the pushed commit's author+committer carry the granted identity; a paired regression test proves the default `Endo <endo@invalid.local>` fallback (the identity thread is load-bearing).
- New `test/workspace.test.js` — 9 composition-semantics unit tests.
- Wiring: `src/types.ts` (new grant types + declarations), `src/index.js`, `types-index.{js,d.ts}`, the `.d.ts` sidecars (force-added per the gitignore convention), `package.json` exports; extended `test/git-remote-fixtures.js` with an additive `{ identity }` option; a changeset.

**Verification (by execution, in `packages/agent-tools`):** `ava` — **113 tests pass** (2 worked-loop + 9 provisioning unit + the pre-existing #705/git-flow/mount-fs suites). `tsc -p tsconfig.json` — **0 errors**. eslint — **0 errors** on changed files; prettier clean. Toolchain note for this sandbox: deps installed via `corepack yarn install` (only `better-sqlite3`'s native build fails, which agent-tools does not need); `tsc`/`eslint`/`prettier` bins were invoked node-directly (their `.bin` shims returned permission-denied). `yarn.lock` unchanged (no dep added).

**A seam this surfaced:** `makeShellTool` and `makeGitRemoteTool` (#705) both emit a bounds-legibility tool named `inspect`, so a single flat catalog cannot carry both `shell` and `remote` grants — the adapter fails closed on the collision (tested), and the loop composes them as two catalogs. Follow-up recorded in the PR: reconcile the two makers' `inspect` naming.

**Follow-ups:** (1) the `inspect` naming reconciliation; (2) per-persona commit identity, still deferred per the Phase-2 note; (3) the draft PR auto-runs the gauntlet under its supervising gardener — I did not run the panel or un-draft.

Self-improvement: worth recording in the endo-but-for-bots journal README — a build-test that needs a real subprocess spawner without `@endo/host-spawner` as a dep must wrap child stdio in an async-iterable closure, never expose raw sockets in a `harden`ed object, or SES freezes the socket and Node's `onReadableStreamEnd` throws `Cannot assign to read only property 'write'`.
