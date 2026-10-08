Restructured and force-pushed PR #1343:

- Reduced the stack from 10 commits to 3 focused commits: implementation/caller migration (`2b573a73c9`), tests (`e59b1c63f7`), and documentation/changeset (`2df1a64933f`).
- Squashed all review follow-ups into the commits they revised.
- Confirmed the final tree hash is unchanged: `17888d683385cbfc50165ad45763a9d7adec7a09`.
- Ran `yarn build` successfully at each rewritten commit.
- Force-pushed with a fresh explicit lease and posted the commit mapping on the PR.
- CI had no failures after a 20-minute bounded wait; four platform test jobs remained pending. The PR was already un-drafted when this job began.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-endojs-endo-but-for-bots-pr1343-gauntlet-20261007-fix-6-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1574s

<!-- garden-usage-end -->
