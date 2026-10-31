fix=still-pending

I applied the panel-2 must-fix items to endojs/endo-but-for-bots#1586 and pushed. CI had not finished at the one-hour deadline: 34 of 36 checks passed, including lint and both Ubuntu test legs. The two macOS test legs were still running or queued (`ci-wait-merge.sh` rc 4), so the driver should re-post this stage.

**What changed** (new head `a5e663926`, five follow-up commits on top of `d42122a9a`):

- **`makeFile` type (typist):** `EndoMount.makeFile` now returns `Promise<EndoMountFile>` instead of the platform `File`. A mount file's `snapshot()` has an async `sha256()`, so it isn't a platform `File`. As a result an `EndoMount` no longer counts as a git worktree to the type checker. The tests that pass one to `makeGit` now cast it explicitly, the same cast `manager.js` already uses. That covers a documented helper in the daemon's `git.test.js` and `git-remote.test.js`, plus five fixture sites in `agent-tools` and `agentry`.
- **`makeFile` accepting trees (saboteur, corner-prober):** `makeFile` now rejects anything that isn't a `ReadableBlob` before it touches the filesystem, so a `ReadableTree` can no longer create a directory. There's a regression test that checks nothing gets created.
- **Help text (curator, migrator, surfacer, corner-prober):** `help.md` and the generated `help-text-data.js` now document `makeFile`'s returned file and blob content. A new test checks `help('makeFile')`.
- **Path shape (spec-keeper, purist):** the platform `Directory.subView` and `makeFile` now take `string[]` in both the guard and the types, matching the design catalog and the sibling methods. `EndoMount` still also accepts a single name. I regenerated the `agent-tools` code-mode declarations.
- **Conformance test (prover):** the expected `Directory` and `ReadableTree` method lists are now read from the platform guards. Reverting `subView` or `makeFile` in the guard now fails the test.
- **Snapshot tests (corner-prober):** new tests cover `SnapshotTree.subView([])`, nested array paths, a nested blob, and a missing name.
- **Changeset (packager, curator, migrator, changeset-auditor, releaser):** added one covering `@endo/platform` (major, since it adds required interface methods, following the repo's earlier fs-types changeset), `@endo/exo-git` and `@endo/daemon` (minor), and `@endo/agent-tools` (patch).
- **Design doc (archivist, benchmarker):** removed the stale "unimplemented minimal vocabulary" claim. Added a note that the round-trip claims are message counts, not measurements, and why the design doesn't benchmark them.

**Checked locally:** the platform tests (382) and the agent-tools code-mode type tests (28) pass. The mount, conformance and snapshot tests pass. The per-package type checks pass for platform, daemon and agent-tools, and so does the repo-root `tsc`. Prettier and eslint report no errors.

- **Failing tests (local only):** five `git.test.js` cases failed with git merge/identity errors, likely the local git 2.43. My change to that file is a type-only cast and the CI Ubuntu legs passed.
- **Environment, unrelated to the PR:** three `git-remote` tests couldn't start the daemon because the local `better-sqlite3` build doesn't match this Node version.

**Not changed:**

- **Naming (decomplector):** the maintainer asked on endojs/endo-but-for-bots#464 (2026-06-18) to name this attenuator `mount`, but the design's D5 records `subView` without citing a reversal. Renaming it everywhere doesn't belong in a fix round, so I kept `subView`. I added the question to the design doc and messaged the maintainer; a follow-up can do the rename if they choose `mount`.
- **Integrator finding:** a false positive. The read-only mount view uses the platform `ReadableTreeInterface`, not the daemon's, so it doesn't claim `subView` or `followNameChanges`.
- **Purist's `followNameChanges` comment:** marked should-fix and conflicts with D6, so I left it.

**Follow-up:** the platform `File` type says a snapshot's `sha256()` is synchronous, but the daemon's returns a promise, so mount files don't match it. That's why the casts above are needed; aligning the two would be its own change.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1586-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 196 tokens (14016738 cached reads)
- Output: 45262 tokens
- Cost: $5.1720516
- Wall-clock: 5561s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
