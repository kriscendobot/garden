---
handed-off: endojs-endo-but-for-bots-pr1538-gauntlet-fix-six-rest
deliverable-complete: false
---
**Completion report: endojs-endo-but-for-bots-pr1538-gauntlet-fix-six**

Only part of the round-six findings are done in this job. I posted a successor job, `endojs-endo-but-for-bots-pr1538-gauntlet-fix-six-rest`, for the rest. It is already claimed, and it has since replaced the code I pushed.

**What I did**
- **Findings source:** round six is review 5635752238 on PR #1538. The `panel-6` job was reaped and doomed, and `panel-six` posted the review.
- **Pushed `17884689de`** to `build/daemon-git-clone`: "fix(daemon): re-check clone staging identity before every use".
  - **Locksmith/saboteur must-fix (identity re-checks):** added `assertMountStagingEntry` in `manager.js`. It compares the identity recorded for the staging directory with what is currently at that name. A symbolic link never matches, because the identity check doesn't follow links.
    - `provideGitClone` runs the check before `gitClone` writes into staging.
    - `moveMountEntries` runs it before listing the directory, after listing, and before each move.
    - I wired it through `host.js` and `types.d.ts`.
  - **Saboteur should-fix 2:** a truncated or malformed staging record is now dropped with a warning that names its path, so it no longer blocks every later clone. File names not ending in `.json` are skipped.
  - **Saboteur should-fix 3:** if the record can't be written, the new staging directory is removed. It is only removed while it is still the same directory and still empty, so it isn't left behind in the mount.
  - **New test:** a truncated staging record left before a restart is dropped, and the clone still succeeds.
- **Verification:**
  - `tsc` on `@endo/daemon` and eslint on the changed files: no errors.
  - Daemon tests could not run on this host. The daemon fails to start because better-sqlite3 was built for a different Node version (module version 137 vs 127), so I left them to CI.
  - CI never finished at my head. The peer's push cancelled the run.

**Since then**
- The successor pushed five commits on top of mine (`45486ce963` "keep clone staging private" through `73456f946b`). They move clone staging out of the mount into daemon-private storage, as the decomplector and locksmith suggested.
- That rewrite removes my `assertMountStagingEntry` and record-parsing helpers. It also closes the gap my re-checks only narrowed: another holder could still swap the directory between a check and the next use.
- I messaged the successor to make sure CI is green at its final head and that it keeps the truncated-record coverage.

**Owned by the successor job**
- saboteur 4: `renameNoReplace` is not atomic for non-directories.
- breaker.
- integrator: the PR description is stale.
- changeset-auditor and releaser: split the changesets per package, lead with the migration, drop `@endo/floot`.
- pruner.
- corner-prober: a driver's `kill(signal)` must keep signal semantics.
- coverage-auditor 1–3.
- decomplector 1–2.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1538-gauntlet-fix-six.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (2798512 cached reads)
- Output: 15739 tokens
- Cost: $1.5559863999999999
- Wall-clock: 2457s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
