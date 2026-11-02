I applied panel round 3's findings to PR #1538 as follow-up commits. The head is now `4a4d360d99` and CI is green: `ci-wait-merge.sh` returned rc 0 with 35 checks and none failed.

**Incident: I briefly overwrote a peer's commits on the PR head, then restored them.** A parallel job, `endojs-endo-but-for-bots-pr1538-simplify-clone-staging-20261102`, pushed `ba98e011eb` and `125ffdabda` at 05:34. Those commits make the clone destination exclusive and drop the staging mechanism. My worktree was older than that push. My rewrite push, which squashed the five `fixup!` commits and added the `(#1538)` suffixes, replaced their head `125ffdabda` with `d9a200f7ff`; rewrite mode allows a diverged head. I noticed within about a minute, pushed `125ffdabda` back, and checked that `ls-remote` showed it. I messaged that job's inbox about it. After that I added only plain follow-up commits on top of their head. So the squash and the suffix fix are **not done**; they need a retcon once the other job finishes.

**Pushed on top of `125ffdabda`:**
- **`92842cf3ea` – changesets:**
  - **Daemon:** now says `Changed:`. It also says the one-argument `provideGitClone` form never shipped in a release (it is in no CHANGELOG), so `minor` covers it. It notes that `origin` is now fetch-only by default, names `GitCloneOriginOptions`, and states the exclusive empty destination. It also says the XS manager throws before cloning and that XS directory removal no longer follows symbolic links.
  - **Sandbox:** split into `Fixed:`, `Behavior change:` (bwrap `SIGTERM`) and a `Migration:` note for out-of-tree drivers. It stays `minor` because the package is 0.0.1.
  - **Git:** now states the user-visible symptom.
  - **Floot:** I kept this changeset, because the other job's instructions say to keep it.
  - This commit also contains the `runRemoteGit` JSDoc trim in `native-git-backend.js`, which now points to `runRemoteGitAt`. That file was already staged, so it went into this commit rather than its own.
- **`0a82aab45b` – design:** restored `≥ 2.30` and recorded #1538 on the Status line.
- **`4a4d360d99` – test:** the shim-only XS removal test now skips when real XS host globals are present.
- **PR body:** now names all four packages, explains why the git and sandbox fixes ride with this PR, describes the exclusive-destination contract, and is shorter. I posted a round summary as a PR comment.

The other job's simplification also settles the decomplector findings and the pruner's comments in `manager.js` and `manager-node-powers.js`. I didn't split the PR by package, but the body now explains why the fixes are bundled.

Before pushing I ran prettier, eslint (0 errors), the root `tsc -p tsconfig.json`, and the daemon tests in `mount-platform-fs-conformance.test.js` (all passed).

**Follow-ups:**
- Retcon #1538 to squash the five `fixup!` commits and add `(#1538)` to the early commits that lack it. Do this only after the simplify job has finished, so it doesn't race another push.
- `safe-push-pr-head.sh --mode rewrite` accepts a diverged head even when the remote gained commits after the worktree was checked out. That is how I overwrote the peer's push. It should refuse when the live head isn't the commit the rewrite was based on.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1538-gauntlet-20261102-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 128 tokens (6487503 cached reads)
- Output: 29536 tokens
- Cost: $2.8730126
- Wall-clock: 3115s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
