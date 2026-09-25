Merged kriscendobot/minion.town PR #81, "Build: web bearer guest invite and accept workflow".

**Checks before merging:** the PR was open, a draft, and mergeable (state CLEAN). kriskowal's approval was on the current head `842ac612`, from a maintainer, and had not been dismissed or superseded. All 4 checks were green: test, Claude harness amd64 and arm64, and dependabot.yml. The repo is the bot's own, so the upstream guards don't apply.

**What I did:**
1. Took the PR out of draft with `gh pr ready 81`.
2. Got an isolated project worktree with `ensure-project-worktree.sh`.
3. Ran the merge script `ci-wait-merge.sh kriscendobot/minion.town 81`. The base was already the live `main` branch, so no base change or rebase was needed. CI confirmed green, the maintainer approval matched the exact head, and the script merged with `--merge`. It exited 0.
4. Confirmed on GitHub: the PR is MERGED at 2026-09-25T05:28:49Z with merge commit `27a6e2bf44051f3bd484d8788b8ced3a103b3cc5`.

**Cleanup:** there were no frozen base branches to sweep. No open PR is based on #81's head branch, so the merge left no downstream PR needing a rebase or retarget.

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr81-conduct.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (264648 cached reads)
- Output: 1701 tokens
- Cost: $0.4280136
- Wall-clock: 76s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
