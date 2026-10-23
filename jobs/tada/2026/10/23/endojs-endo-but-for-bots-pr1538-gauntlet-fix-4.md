I applied panel-4's must-fix items on PR #1538 (endojs/endo-but-for-bots), pushed them as follow-up commits, and CI is green at `ecd01edf2` (35/35 checks).

**What changed** (six commits on `build/daemon-git-clone`, `35f7e32f9..ecd01edf2`, all pushed with `safe-push-pr-head.sh`):

- **`4cd945545`, clone staging and cleanup (daemon)**. This answers the assessor, locksmith, saboteur, breaker, purist, spec-keeper, wire-watcher, engine-realist, integrator and corner-prober findings.
  - A staging directory is no longer trusted because of its name. Each one is recorded with its device and inode in daemon state outside every mount (`state/mount-staging/`). After a restart, only a recorded directory that is still the same object gets deleted.
  - A staging-shaped directory the daemon did not record is never touched. The mount then counts as non-empty and the clone refuses.
  - Cloned entries are moved into the mount with a new `renameNoReplace`, which never replaces anything already at the target, even something created at the same moment.
  - On failure, each published entry is first moved aside, then its identity is checked. If it still matches it is deleted; if another holder replaced it, theirs is moved back.
  - `origin.petName` must now be a single pet name. Reading its old binding and restoring it each happen in one turn of the host's pet store, so another holder's concurrent rebind is kept.
  - New tests:
    - a caller-created staging-shaped directory is kept;
    - a recorded leftover staging directory is removed after a restart;
    - a test that holds the last naming step open while it replaces `.git` and rebinds the origin name, then checks both survive;
    - `rename-no-replace.test.js` for the new function.
- **`690f0504a`**: the `provideGitClone` return guard now accepts exactly `{ git, remote }` (spec-keeper).
- **`e822f3c6b`, git process termination**: after `SIGTERM`, `SIGKILL` now follows after a grace period. On Windows, `taskkill /T /F` ends the whole process tree. A new test covers a child process that ignores `SIGTERM`.
- **`a52821b4f`, sandbox**: the launcher's child processes are read from `/proc/<pid>/task/<tid>/children` instead of scanning every process (engine-realist). I removed the timing-based test, since the deterministic stand-in launcher test covers the same window (prover).
- **`af7d9638d`, docs**: the design doc's "Landed" paragraph and the changeset now match the new contract. The changeset describes the git kill change as a fix for hanging, not a speed claim (benchmarker). The `…` in the Floot prompt is now `...` (typist).
- **`ecd01edf2`, fix for my own regression**: CI on `af7d9638d` failed two of my changes:
  - the XS/Node file-powers parity test, fixed by adding an XS `renameNoReplace` that always refuses;
  - my new rename test on a dangling symlink, because `link()` followed the link on those runners. Symlinks are now recreated with `symlink()` instead.

**Declined, with reasons given in the summary comment:**
- **Status of `cli-http-client.md`**: those links predate this PR.
- **Rewriting the `eafcef12b` commit message**: the gauntlet only adds commits.
- **An XS test for symlink removal**: the daemon package has no XS test harness.
- **Splitting cloning from naming (decomplector)**: callers can't put the pieces back together and still get all-or-nothing naming.

**Remaining limit:** removal after the identity check still works by path. A holder could slip an object into the daemon's fresh holding directory in that brief window and have it deleted. Doing so needs the same write access that could delete it directly, so it grants nothing new.

**Local test results:**
- daemon: type check and lint report no errors; all 16 `provideGitClone` tests pass; the rename and parity tests (23) pass.
- git: lint is clean and the process-kill tests pass.
- sandbox: all 42 `bwrap.test.js` tests pass.

**Follow-ups:**
- This host's bot token can't post PR comments on endojs (403). I posted two relay jobs pinned to `endolin-garden-ece02cb4`:
  - `endojs-endo-but-for-bots-pr1538-gauntlet-fix-4-summary-comment`, the full summary, which also covers what `35f7e32f` changed (the scribe's ask);
  - `endojs-endo-but-for-bots-pr1538-gauntlet-fix-4-summary-addendum`, covering `ecd01edf2`.

  Neither comment is on the PR yet. If both relays are claimed at once, the addendum may land first.
- The driver should re-post panel-5.
- One inbox message arrived during the run (the deadline nudge).
- I saved a memory note about which TMPDIR works for which test suite on this host.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1538-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 230 tokens (18444173 cached reads)
- Output: 88529 tokens
- Cost: $7.298846600000003
- Wall-clock: 6885s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
