I didn't push anything to PR #1571, because the failing check has nothing to do with the PR's changes. The cause is an intermittent bug in the sandbox code on the base branch `llm`, so I posted a separate job to fix it there. The red check stays red for now.

**The failure.** On run 41171740768 (head `5a3239c7c`, ubuntu-26.04 image), `test (22.x, ubuntu-latest)` failed on a single test, in `@endo/sandbox`:
`bwrap › bwrap timeout and repeated cancellation reap process groups`, with `process group 41823 survived bounded cleanup` (`packages/sandbox/test/bwrap.test.js:1099`).

**Why it isn't this PR.**
- The PR changes only exo-git, git, daemon git tests, agent-tools and docs. It doesn't touch `packages/sandbox`.
- On the same head, the Node 24 Ubuntu test, both macOS tests, `sandbox-drivers` and both `cover` checks all passed.
- The same test failed in recent CI runs on three unrelated branches: run 41195268283 (`daemon-worker-import-from-mount-phase-three`), run 41177911274 (`feat/lal-subscription-oauth`, three jobs) and run 41148036031 (`build/daemon-agent-tools-sandbox-shell`).
- The PR #1504 shepherd report from 2026-10-31 found the cause: an inner bwrap process can be left orphaned when its group is killed. Its fix is commit `17c61dd8e4` ("fix(sandbox): sweep the bwrap process group when the leader exits"), but that commit only exists inside open PR #1504. #1566, which raises the test's cleanup timeout, is also still open, and neither has landed on `llm`.

**What I did.**
- **Re-run:** I tried `gh run rerun --failed`, but the bot's token isn't allowed to (`Resource not accessible by personal access token`).
- **No push:** copying the sandbox fix into this PR would put unrelated sandbox changes into it, and an empty commit just to retrigger CI would only add noise. I also posted no comment on the PR.
- **Follow-up job:** the #1504 report suggested splitting the fix into its own PR, but no one had posted that job, so I posted `build-sandbox-bwrap-leader-exit-group-sweep`. It's a builder job pinned to `host=endolin-garden-ece02cb4` (this host can't open PRs on endojs) to open a PR against `llm` carrying `17c61dd8e4`, plus `2696934af6` if it applies cleanly.

**Still needed for #1571.**
- Once that fix merges into `llm`, #1571 needs a weave onto a fresh `llm` snapshot to get Ubuntu Node 22 green.
- Until then, someone with permission can run `gh run rerun 41171740768 --failed` to retry the job; the failure is intermittent.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-endojs-endo-but-for-bots-pr1571-ci.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1458647 cached reads)
- Output: 8188 tokens
- Cost: $1.0794894000000002
- Wall-clock: 1020s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
