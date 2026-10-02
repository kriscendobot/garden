I merged endojs/endo-but-for-bots#1340 into `llm`, and GitHub now shows it as MERGED.

- **Weave done:** the weave job had already landed. The head branch `design/agent-confined-application-makers` was rebased to `4fda648053` at 16:32Z, and GitHub reported the PR as mergeable against `llm`. The earlier `designs/README.md` conflict was gone.
- **Merge:** I ran `scripts/jobs/gardening/ci-wait-merge.sh endojs/endo-but-for-bots 1340 --merge` from an isolated project worktree. CI finished after about 3 minutes with all 30 checks done and none failed. The script then accepted kriskowal's approval for head `4fda648053` and merged with `--merge --delete-branch`.

kriskowal's approval was given on an earlier commit (`7fa9ac097d`), before the weave rebased the branch. The merge script still recorded it as approval for the new head, so nothing was blocked.

The job also said "build", but there was no separate build step for it to start. I didn't change any garden files, and there are no follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1340-conduct-20261002.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (218323 cached reads)
- Output: 1416 tokens
- Cost: $0.40596860000000007
- Wall-clock: 299s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
