I replaced the clone staging machinery on endojs/endo-but-for-bots#1538 with the simpler exclusive-destination contract. CI was fully green (35 checks, 0 failed) at my head `125ffdabda`. A peer job has since added commits on top, and I have not re-checked CI on those.

**What changed** (two commits on `build/daemon-git-clone`: `ba98e011eb` for code and tests, `125ffdabda` for docs):
- **New behavior:** `provideGitClone` refuses a non-empty mount and clones straight into it. If the clone fails, it removes every entry under the mount root and leaves the root itself. Under the exclusive assumption the mount started empty, so only what the clone created is removed, and a retry into the same mount works.
- **Removed:**
  - the sibling staging directory and the persistent `mount-staging` records;
  - the five staging helpers in `manager.js`, replaced by one function, `clearMountHostEntries`;
  - `renameNoReplace`, `supportsRenameNoReplace`, `removeEmptyDirectory` and `entryIdentity`, with their `FilePowers` types and their Node and XS implementations;
  - `rename-no-replace.test.js`, the stale-staging tests, and the changeset line about those four methods.
- **XS:** still refuses a clone before anything is cloned, because the XS supervisor supplies no `gitClone` host tool. No separate up-front check is needed.
- **Docs:** `designs/daemon-git-remotes.md` § clone and the `provideGitClone` JSDoc now state the exclusive-destination assumption. The staging rationale, the precondition list and the "simpler shapes considered" paragraph are gone.
- **Tests:**
  - The existing refuse-non-empty test still checks that the caller's content survives.
  - A new test makes a clone into a host mount fail and checks three things: the mount root survives, a sibling file in the parent is untouched, and the mount ends up empty.
  - The two tests that wrote to the mount during a clone (the credential-rotation and name-rebind tests) no longer do; they now expect an empty mount after the failure. The pet-name rebind check in the second test still holds.
- **Kept:** the bwrap init-kill → group-kill ordering, the git SIGKILL escalation, the changeset edits, the floot changeset, and the XS `removeDirectory` fix that stops it following symlinks.

**Checks:** type-check passed. ESLint showed no errors and prettier was clean. Locally, `git-remote.test.js` and `mount-platform-fs-conformance.test.js` passed (78 tests). The local run needed node 24 from `/usr/local/n/versions/node/24.21.0/bin`, because the default node 22 cannot load the worktree's better-sqlite3 build. I posted a round summary as a PR comment (issuecomment-6570569098).

**Follow-ups:**
- The maintainer did not send a "keep staging" override.
- A peer job (gauntlet fix-3) is answering panel review 5732433133: changeset wording, the `≥` spelling, and the XS test skip guard. Its autosquash push briefly replaced my head, and it restored it. The branch now carries three of its commits on top of mine (head `4a4d360d99`); my commits are intact.
- A panel re-review of the simplified contract is next.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `3a67b493f7d953775cc5be223475d92f5e77b858`; this job presented `4a4d360d9917c7464b36907b2e64dd106c58ee51`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1538-simplify-clone-staging-20261102.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 112 tokens (6722525 cached reads)
- Output: 25100 tokens
- Cost: $3.002641
- Wall-clock: 3224s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
