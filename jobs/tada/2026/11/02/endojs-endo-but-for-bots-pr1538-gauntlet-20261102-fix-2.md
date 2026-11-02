Fix round 2 for endojs/endo-but-for-bots#1538 is done. I applied the panel's fixes from review 5732023689 except the decomplector's redesign, which went to the maintainer and is now its own job. I pushed four follow-up commits to `build/daemon-git-clone` (a54166c7b6 → 3a67b493f7), and CI came back green on all 35 checks (`ci-wait-merge` rc 0).

**Applied**
- **bwrap init kill (assessor, must-fix):** in `packages/sandbox/src/drivers/bwrap.js`, `killSliceNow` now signals the process group even when the targeted init kill throws something other than `ESRCH`, then re-throws that error.
- **Clone staging preconditions (assessor and breaker):**
  - If the staging directory beside the mount can't be created, the clone now fails with an error saying the mount's parent must be writable.
  - A mount on a different filesystem from its parent, such as a bind mount, is now refused before the clone runs, instead of failing at the rename after downloading.
  - The Node powers now report no-replace publication as unsupported on win32.
  - The design doc lists all three preconditions, including that a clone destination must not be nested inside another mount.
  - The `pathIdentity` type now documents its `<device>:<inode>` format, which both implementations already return.
- **XS removal test (coverage-auditor):** renamed and commented as shim-only, and added cases where the path being removed is itself a file or a symlink (the symlink's target must survive).
- **Pruner and releaser:**
  - Trimmed the `provideGitClone` JSDoc to a summary plus a link to the design.
  - Shortened the floot test comment.
  - Bumped the sandbox changeset to `minor` and split out the wider `DriverProcess.kill` contract for out-of-tree drivers.
  - Rewrote the daemon changeset so it no longer describes an unreleased earlier form, and moved the XS limit to its own line.
  - Added a patch changeset for `@endo/floot`.
  - Removed the duplicated sections from the PR body.

**Local checks:** daemon `mount-platform-fs-conformance` plus `git-remote` passed 84/84, sandbox `bwrap` 45/45, floot `machine-admin-workflows` 5/5. eslint reported no errors, and the package and repo-root type checks were clean. To run the daemon tests I had to replace the worktree's `better-sqlite3` binary, which was built for a different Node version.

**Not done**
- **Real-host test of the XS file powers (coverage-auditor must-fix):** I didn't build one. It needs the daemon suite running under `endor`, and no CI job does that. The PR body now says so and leaves it as follow-up work.
- **Marking `settled` in `runRemoteGitAt` (assessor, comment-only):** I reverted this change. Returning early there would stop the close handler from clearing the kill-escalation timer, so the timer could later signal a process group whose ID has been reused.
- **Decomplector must-fix (is the whole staging mechanism needed?):** this needed a maintainer decision, so I sent the question. The liaison proxy answered **simplify**, tentatively, in the maintainer's place: exclusive destination, clone straight into the mount, and remove only what the clone created. I posted successor job `endojs-endo-but-for-bots-pr1538-simplify-clone-staging-20261102` to make that change.

**Follow-ups**
- The panel-3 round will review the code as it stands, including the staging mechanism the successor job will strip out. It may be worth holding panel-3 until that job lands.
- The "simplify" ruling is tentative, so the maintainer may still want to confirm or overturn it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1538-gauntlet-20261102-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 124 tokens (6048175 cached reads)
- Output: 22224 tokens
- Cost: $2.5707309999999994
- Wall-clock: 3137s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
