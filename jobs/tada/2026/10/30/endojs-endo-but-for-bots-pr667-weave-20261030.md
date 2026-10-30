I wove PR #667 onto the current llm tip and asked kriskowal to re-review. It was not merged, and won't be without a fresh approval.

**What I did**
- **Base pinned:** the frozen branch `llm-9a14ddf` already existed at exactly the llm tip (9a14ddf660), so I used it. The PR's base now points at `llm-9a14ddf` instead of the moving `llm` branch.
- **Head rebuilt:** `feat/genie-stdio-jsonl-rpc-bridge` went from 4f9d899d50 to 7e7e4481b8, force-pushed with lease. GitHub now reports the PR as MERGEABLE (it was DIRTY).
- **Strategy change:** the branch was 5 ahead and 3099 behind. A commit-by-commit rebase failed straight away: the first three commits built the bridge in `packages/genie`, which llm has since deleted (42bc7d5161, "retire @endo/genie"). I aborted (once) and re-applied the branch's net `packages/agentry` and changeset changes as one commit on the pinned base. The commit message lists the five original commit subjects, and endolinbot is kept as author. The new branch has 14 files, all from the PR.

**Conflicts I resolved by hand** (no `--ours`/`--theirs`)
- **`packages/agentry/README.md`:** kept llm's new code-mode-provisioning and Pi-extension entries and section, plus the PR's `@endo/agentry/rpc` entry and "Stdio JSONL RPC bridge" section.
- **`packages/agentry/test/exports.test.js`:** kept llm's newer style, which checks each subpath's full list of exports, and added a matching check for `@endo/agentry/rpc`. The PR's older eval checks were already covered by llm's version.
- **Dropped with the deleted genie package:** genie's `rpc.js` runnable, its `resolveModel` export, its dependency on agentry, and the matching `yarn.lock` line. The bridge itself doesn't need genie: its session already resolves models through agentry's harness.
- **Genie mentions removed:** from the README, the `rpc/index.js` header and the changeset. I renamed the changeset to `.changeset/agentry-stdio-jsonl-rpc-bridge.md`, now `@endo/agentry: minor` only.

**Tests (local)**
- `yarn install --immutable` succeeds and `yarn.lock` is unchanged.
- The rpc and exports tests in agentry pass (38 tests).
- `yarn lint` in agentry has 0 errors.
- The full agentry suite has one failure: `eval › conflict-rebase › outcome assertion fails when conflicted worktree is left mid-rebase`. It shells out to `git rebase`, this PR doesn't touch it, and it most likely comes from our host's git setup. CI should confirm that.

**PR comment:** I posted a summary asking kriskowal to re-review, since their 2026-07-13 CHANGES_REQUESTED review (move into agentry) is still addressed: https://github.com/endojs/endo-but-for-bots/pull/667#issuecomment-6515203853

**Follow-ups**
- Once kriskowal re-approves, the merge (a conductor job) can go ahead.
- The PR body still mentions genie 8 times. The job didn't authorize editing it, so I left it; the comment explains the change. The branch name also still says "genie".
- Nothing in the tree now ships a ready-to-spawn stdio runnable for the bridge. If one is wanted, it would be a small follow-up in another agent package.
- CI on the new head hadn't been checked when I finished.

## Manual gauntlet handoff

The completion guard found https://github.com/endojs/endo-but-for-bots/pull/667 ready without gauntlet coverage. A deduplicated review-docket decision was recorded; the PR was not re-drafted and no gauntlet was staged.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr667-weave-20261030.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2266404 cached reads)
- Output: 12737 tokens
- Cost: $1.3672607999999997
- Wall-clock: 480s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
