The panel ran and reached a **must-fix** verdict on PR #1525, but I couldn't post the review from this host, so this stage ends as `panel=panel-error` and the driver will retry it.

**Pinned pair.** PR #1525 (`endojs/endo-but-for-bots`, head branch `endor-tui-phase-1`, still a draft) has base `f02cd81b22887aae14e6db8f38e64f3a93ebc06a` and head `187ec74172a452351bebf3d88635cab058806878`. The isolated checkout is `scratch/project-wt-endojs--f936d8e29c39-fdecc01e`, and `git rev-parse HEAD` there matched the head.

**Style pre-pass.** `pre-push-gates.sh --no-auto-fix --probes-only` exited 0. Its only output was a non-blocking warning: a 6-line prose comment at `rust/endo/src/tui/bus.rs:1` that the pruner seat should judge.

**Panel attempts** (`GARDEN_PANEL_SINGLE_ROUND=1 panel.sh … 1525 f02cd81b…`):
1. **Stopped by me.** I had backgrounded it with a 10-minute timeout, so I stopped it after about a minute and relaunched it detached.
2. **Seats finished, verdict must-fix, then failed** with "review submission (cannot derive repository from worktree origin)". The fleet `git` wrapper takes an *exclusive* repo lock even for the read-only `git -C <wt> remote get-url origin`. On this host that call timed out after 10 s (rc=124, lock held by another process), which left `panel.sh`'s `wt_repo` empty.
3. **Two debugging reruns** with a no-post hook. I expected the cheap resume path, but there was no recorded run to resume from because the PR-body hash was empty, so both re-ran every seat. One hit "Permission denied" because `/tmp` is mounted noexec, and the other hit my 500 s timeout.
4. **Final run, with `GARDEN_PANEL_PR_REPO=endojs/endo-but-for-bots` set.** All seats finished, the verdict was **must-fix** (839-line aggregate headed `## Must-fix before merge`), and the run record `panel-runs/endojs-endo-but-for-bots-1525/5bac3991f0d8.md` was saved with a PR-body hash. Then `gh pr review` failed with a 403 (`addPullRequestReview`), and `panel.sh` exited 1. This is the known limit of this host's (oros-studio) bot token, which can't write PR reviews on endojs.

Because `panel.sh` exited non-zero and the review was never posted, the correct marker is `panel=panel-error`, not must-fix. With the PR head unchanged, a retry on a host whose token can write reviews (endolin) should rebuild the verdict from that saved record without re-running the seats. The posted aggregate would then be the shorter rebuilt version, not the full 839-line one.

**Follow-ups:**
- **Git lock bug:** the fleet `git` wrapper (`scripts/jobs/bin/git`) shouldn't need an exclusive repo lock for read-only commands like `remote get-url`. `panel.sh` should also fail loudly when `wt_repo` can't be determined, instead of running all the seats and only failing at the post. Until then, panel stages on oros need `GARDEN_PANEL_PR_REPO` set.
- **Wasted seat runs:** the full seat panel ran three times this attempt, two of them from my own debugging reruns.
- **Token:** the durable fix is still giving the bot token pull-request write access on endojs. Until then, panel rounds for endojs PRs only succeed on endolin hosts.
- **Memory:** I added a note about the lock timeout and this 403 to the `bot-pat-no-pr-write-endojs` memory.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1525-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (2408948 cached reads)
- Output: 13891 tokens
- Cost: $1.3916176000000005
- Wall-clock: 3574s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
