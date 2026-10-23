# FIX round 2 for endojs/endo-but-for-bots#1538

I applied the must-fix items from the latest panel review (5624079301, a comment review headed "Must-fix before merge"). I also took most of its should-fix and summary-fix items. The job carried no deterministic pre-pass block. Four follow-up commits went to `build/daemon-git-clone` through `safe-push-pr-head.sh` (b1c190daa → 8ac572a3b). `ci-wait-merge.sh` returned rc 0: all 35 checks are green.

## What changed

- **`0fcca2dac` — fix(daemon): a failed `provideGitClone` now removes only what it created** (assessor, locksmith, saboteur, purist, wire-watcher, engine-realist, corner-prober, breaker, migrator, integrator, archivist).
  - **Staged clone:** the clone is built in a uniquely named staging directory inside the destination mount, then moved up entry by entry. If something already sits at a target name, the move fails. On failure, only the staging directory and the moved entries are removed. Anything another holder of the mount wrote meanwhile is kept. The core helpers `emptyMountHostPath` → `makeMountStagingEntry`, `moveMountEntries`, `removeMountEntries` replace the old empty-the-whole-mount helper.
  - **Origin name:** if `origin.petName` already pointed at something, that earlier entry is pinned and restored on failure. The restore happens only while the name still holds what this call stored, so a concurrent rebind wins. An `origin.petName` equal to the Git's pet name is now rejected before cloning.
  - **Cleanup errors:** these are now raised with `makeError(X…, AggregateError, { cause, errors })` instead of a bare `AggregateError`.
  - **XS symlinks:** the XS `removeDirectory` now unlinks symlinks instead of following them, so cleanup cannot reach outside the mount.
  - **Docs:** the `opts` → `options` rename is in this commit. The design note `designs/daemon-git-remotes.md` and the types doc now describe the new signature, the fetch-only default and the rollback behaviour.
  - **New tests:**
    - a write made during the clone survives discard;
    - an origin name the clone replaced is restored;
    - equal names are rejected;
    - a cloned symlink is not followed.
- **`c90f101a9` — fix(git): remote operations without a credential now kill the whole process group** (breaker). Clone, fetch and push without a credential now go through the same helper that signals the whole process group. It is renamed `runRemoteGitAt`/`runRemoteGit`, and GIT_ASKPASS is wired only when a credential is present.
- **`a6966d233` — fix(sandbox): the bwrap kill finds the sandbox init itself** (spec-keeper ×2, prover, transplanter, integrator, saboteur, breaker).
  - **No more `--info-fd`:** the kill no longer waits for bwrap's `--info-fd` report. It pauses the launcher with SIGSTOP, so the launcher can neither reap the init (which would free its PID for reuse) nor start a new one. It then finds the init as the launcher's child in `/proc`, SIGKILLs it, and sends the requested signal plus SIGCONT. Since `--info-fd` is no longer used, the finding that older bwrap releases pass the probe but fail every spawn goes away too.
  - **Close deadline:** `stop()` now starts its close deadline only after the signal is sent.
  - **Deterministic test:** a new test replaces bwrap with a stand-in launcher whose child has left the launcher's process group. I checked that it fails when the kill only signals the process group.
  - **Renames:** `ms` → `milliseconds` and `proc` → `sliceProcess`. I used `sliceProcess` rather than the `process` the stylist suggested, so the global `process` isn't shadowed.
- **`8ac572a3b` — chore(changeset): one changeset** (packager, changeset-auditor, releaser, archivist). The three changesets are now one. It adds `@endo/floot`, puts one sentence per line, describes what users see rather than how it works, and says the endpoint supplies the URL, credential and transport while the remote is always named `origin`.

## Local checks

- `tsc` passes for daemon, git and sandbox.
- All 12 `provideGitClone` tests pass (run twice).
- All 43 sandbox bwrap tests pass.
- All 15 git package tests pass.
- Locally, the daemon test files only ran with TMPDIR on tmpfs. On the virtiofs scratch mount, git intermittently rejects the clone source as "dubious ownership".
- One test, "GitRemote push round-trips to an independent fetcher over file://", times out on this host. It times out the same way without my git change, and it passed in CI.

## Follow-ups (not done)

- **Coverage:** corner-prober's summary-fix asks for timeout and output-overflow tests on the process-group kill. Those paths are unchanged in shape and still have no dedicated tests.
- **No pidfd or cgroup kill:** the PID-reuse fix relies on the stopped launcher keeping its child's PID reserved. That is sound, but it is not the pidfd or cgroup kill spec-keeper suggested.
- **Leftover staging directory:** if the daemon crashes mid-clone, a hidden `.endo-staging-*` directory stays in the mount. The mount then counts as non-empty, so a retry needs a fresh mount.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1538-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 196 tokens (12688220 cached reads)
- Output: 59321 tokens
- Cost: $5.163928000000001
- Wall-clock: 4785s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
