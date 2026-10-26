I opened draft PR **endojs/endo-but-for-bots#1570**, "feat(exo-git): structured Git.rebase with a rebaseText porcelain sibling". It stacks on #1569 through a new frozen base branch, `build-daemon-git-next-steps-structured-merge-c497ec6` (#1569's head, `c497ec6efd`). The head branch is `build-daemon-git-next-steps-structured-rebase`, one commit `37492343d3`.

**What changed**
- **`Git.rebase(input)`** now returns a structured result instead of Git's text output:
  - `completed`, with the new head and the commits Git actually rewrote, oldest first. A branch that is already up to date reports none.
  - `conflicts`, with the stopped commit and the same conflict records `merge()` returns.
  - `aborted`, with the restored head.
  - `in-progress`, when Git stops without a conflict.
  
  Failures that happen before a rebase is under way still reject with Git's own error: a dirty worktree, starting while another rebase is stopped, or continuing when none is in progress.
- **`Git.rebaseText(input)`** keeps the old text output and the old reject-on-stop behavior.
- **Capability boundaries:** both methods exist only on the rewriter facet, so the history-rewrite permission is unchanged. Tests confirm the reader and writer facets advertise neither method. Conflict entries are created through the caller's own worktree mount, using a helper now shared with `merge`, so a conflict report grants no extra authority. The existing safety checks still run before both methods.
- **`GitRemote.pull({ strategy: 'rebase' })`** relied on `rebase()` rejecting at a conflict. With a structured result it would have recorded a stopped rebase as a successful integration. It now rejects unless the result is `completed`.
- The help text, guards, TypeScript types and type tests, generated code-mode declarations, the agent tool's `rebase` description, the design progress ledger and a changeset are all updated. The changeset is major for `@endo/exo-git` and `@endo/git`, minor for `@endo/agent-tools`.

**Testing**
- New tests:
  - `@endo/git`: three tests covering completed/up-to-date/text output, conflict then continue, skip, abort, and the error cases above.
  - `@endo/daemon`: a test that conflict entries come from the mount and resolve through `checkoutConflict`.
  - `@endo/exo-git`: a test for the pull change.
- I broke the code on purpose to confirm the tests catch it: reverting the pull fix fails the pull test, and removing the original-branch exclusion fails two rebase tests.
- Passing locally: `@endo/git` (34 tests), `@endo/exo-git` (59 tests, lint, type tests), `@endo/agent-tools` lint, the repo-root `tsc`, the related-design and phase-evidence checks, and the pre-push gates against the frozen base.
- One `@endo/agent-tools` test still fails locally, the git-flow rewriter-catalog test. It also fails on #1569's code without my change, and it fails before reaching `rebase`.
- Some daemon git tests (reword, cherry-pick, the merge fast-forward test, and the `provideGitClone` tests) fail locally for two reasons. This host's global `branch.autosetupmerge=always` rewrites `.git/config` and trips the "repository identity changed" check. The clone tests hit the long-socket-path limit. #1569's CI shows only the usual bwrap failures, so I expect these to pass in CI.

**Follow-ups**
- **#1569 has a bug I didn't fix here:** a conflicted `merge` now returns instead of rejecting, so `GitRemote.pull` with the `merge` or `ff-only` strategy records the conflict as `up-to-date`. It belongs to #1569 and is noted in the #1570 PR description.
- Remaining Phase 7 work: structured `stashList`/`stashShow` with `*Text` siblings, and narrowing mutation methods out of the `readOnly()` type. No job for this is on the board yet.
- #1570 stays draft; completing this job starts the usual review gauntlet.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-git-next-steps-structured-rebase.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 182 tokens (13474111 cached reads)
- Output: 50820 tokens
- Cost: $5.268710199999998
- Wall-clock: 1639s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
