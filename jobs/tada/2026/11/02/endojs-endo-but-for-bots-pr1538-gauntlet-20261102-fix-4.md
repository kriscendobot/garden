Fix round 4 for PR #1538 is pushed and CI is green (`ci-wait-merge` rc 0, 35 checks, 0 failed) at head `ae607f965`. The PR body update hasn't landed yet: this host's token can't edit PRs on endojs, so I posted `endojs-endo-but-for-bots-pr1538-gauntlet-20261102-fix-4-pr-body`, pinned to endolin. Until it runs, the live body still describes the old call shape.

**Applied (4 follow-up commits):**
- **`7cf660f97` (decomplector must-fix 1):** removed `origin.petName`, along with the prior-binding pin, the restore step and the must-differ rule.
  - `provideGitClone` now binds only the `Git`; callers name a remote with `provideGitRemote`.
  - The Floot prompt now uses one shape for minting and re-minting its remote.
  - The design section is updated, including pruner findings 2–3.
  - Tests for the removed mechanism are deleted, and the restart test now covers clone plus `provideGitRemote`.
- **`a861ec5e4` (coverage-auditor 1–3):** added a `content-store-gc` test that checks symlink handling on whichever manager the daemon runs, so `test:rust` reaches the XS manager's real host globals. The shim test also gains the missing-path case.
- **`f3d0d7ad3` (releaser 1–4, pruner 4):** changesets now state only user-visible behavior. I rewrote the Floot changeset rather than removing it, because the previous round's panel asked for it.
- **`ae607f965` (pruner 5–8):** cut comments that restated the code or narrated history. Pruner 9 is in `a861ec5e4`.
- **Pending PR body update (pruner 1, releaser 5):** the new body shortens the bullets and gives the `minor` reasoning: `@endo/sandbox` is private at 0.0.1.

**Decisions for the maintainer:**
- **`origin.petName` removal:** this departs from the open #709 design draft, which still specifies it. I found no maintainer request for that option, and the seat said it would withdraw if one exists. If you want the one-call bind, revert `7cf660f97`. #709 itself is not updated.
- **Native XS test doesn't run yet:** `yarn test:rust` can't start any daemon, because the XS manager throws `HTTP content plane requires fetch` at startup (since #792, not this PR), and no CI job runs that suite. So coverage findings 1–2 are met only by the new test plus local evidence. With an uncommitted guard around that registration, the new test passes on real `endor`, and fails against the base branch's `removeDirectory`, which deleted the symlink target's file. I posted `ebfb-xs-daemon-start-without-fetch` for the startup fix and a CI lane.

**Not applied (should-fix or comment-only):**
- **Decomplector 2:** splitting the bwrap and git fixes into their own PR.
- **Decomplector 3:** using a fresh scratch mount instead of the two new cleanup powers.
- **Decomplector 4:** comment-only; the `7cf660f97` change resolves it.

**Local verification:**
- **Passed:** focused daemon tests, type tests, Floot, bwrap (45 of 45), and `eslint` with no errors. `prettier` passed on the files I checked (not every changed file).
- **`git-remote.test.js`:** the `provideGitClone` tests I could see passed, but that output was truncated. One test failed locally both times, `GitRemote push round-trips…`; it has a 2s limit and doesn't touch the clone.
- **`native-git-backend.test.js`:** failed locally under either temp directory, in different tests each way (noexec `/tmp` in one, 2 failures under scratch in the other). This round only deleted a comment in that package's source.
- **CI:** its full `test` matrix passed on this head.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1538-gauntlet-20261102-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (4773251 cached reads)
- Output: 43278 tokens
- Cost: $3.129218200000001
- Wall-clock: 5223s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
