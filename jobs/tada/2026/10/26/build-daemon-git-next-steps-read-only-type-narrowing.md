I opened draft PR **endojs/endo-but-for-bots#1572**, "feat(daemon,exo-git): narrow read-only Git provisioning to ReadOnlyEndoGit". It is one commit, `15507c93bf`, on head branch `build-daemon-git-next-steps-read-only-type-narrowing`. It stacks on the structured stash PR, #1571, through a new frozen base `build-daemon-git-next-steps-structured-stash-9e885d3` (#1571's final head).

**What I found**
- `readOnly()` was already narrowed in `@endo/exo-git`: every facet returns `ReadOnlyEndoGit`, which has no mutation methods. So that part needed a firmer test, not new code.
- The real gap was `EndoHost.provideGit(mount, name, { readOnly: true })`. It was typed as returning a writable Git. Over a writable mount it also returned a writable Git at runtime, because the option only skipped the check that rejects read-only mounts. `designs/endo-workflow.md` uses exactly this call to give reviewers read-only access, so a reviewer could have committed through it.

**What changed**
- **Daemon fix:** the `git` formula now records `readOnly: true`. The formula maker returns the read-only facet if either the mount is read-only or the formula says so. This holds after reincarnation, and `readOnly` wins over `allowHistoryRewrite` when both are set.
- **Daemon types:**
  - `provideGit` has a new first overload: `{ readOnly: true }` returns `ReadOnlyEndoGit`.
  - The existing overloads now require `readOnly?: false`.
  - An options bag chosen at runtime now types as the full `EndoGit` union.
  - The interface guard lists `readOnly` as a boolean.
- **Runtime checks kept:** mutation methods are still absent from the read-only facet itself. `provideGit` still rejects a writable request over a read-only mount unless `readOnly: true` is passed.
- **exo-git type tests:** they now check that `keyof ReadOnlyEndoGit` is exactly the set of read methods. `mergeText`, `rebaseText` and `cherryPick` are added to the list of mutators that must stay off it.
- **Docs and changeset:** the design doc is updated (interface sketch, `readOnly()` text, Design Decision 8, progress ledger), as is the `readOnly()` help text. The changeset is minor for `@endo/daemon` and patch for `@endo/exo-git`.

**Testing**
- A new daemon test checks that a declared read-only Git over a writable mount:
  - has the same methods as `readOnly()`, including when `allowHistoryRewrite` is also set;
  - rejects `commit` and `stashPush` at runtime;
  - stays read-only after reincarnation.
  
  With the formula fix reverted, this test fails.
- The exact key-set check failed after rebasing onto #1571 until I added its new `stashListText`/`stashShowText` methods, so it does catch new methods on the read-only type.
- Passing locally:
  - `@endo/exo-git`: type checks and tests (59 passed).
  - `@endo/daemon`: `tsc`, type tests, the `provideGit` tests (8 passed), and `git.test.js` plus `git-remote.test.js` (179 passed, run with an isolated global git config).
  - The repo-root `tsc` (no errors) and the pre-push gates.
- Three daemon git tests (reword, cherry-pick noCommit, merge fast-forward) fail on this host only because of its global `branch.autosetupmerge=always`. They pass with an isolated git config.

**Follow-ups**
- #1572 is marked as the deliverable for Phase 6. #1571's ledger still says it is a partial slice with this job as successor. I left that as is, because #1571 does not contain the type narrowing; the stack completes Phase 6 when it merges as a whole.
- A `git` formula created earlier with `{ readOnly: true }` over a writable mount never stored the flag, so it stays writable. Provisioning it again fixes it; the PR's upgrade notes say so.
- #1572 stays draft; completing this job starts the review gauntlet.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-git-next-steps-read-only-type-narrowing.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 216 tokens (13539898 cached reads)
- Output: 49538 tokens
- Cost: $5.101443600000001
- Wall-clock: 1968s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
