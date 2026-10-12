Completion report: kriscendobot-minion.town-pr182-gauntlet-undraft

PR #182 on kriscendobot/minion.town ("fix(probe): opt-in runner for the prod probe; report via github-script") is now ready for review. It is un-drafted at head `7c3a765ee2971c789d1e7891911678944bd833dc`, the head the panel passed.

**1. Advisory appellate pass (does not block the un-draft).** I reviewed the 2-file diff myself instead of through a separate `claude -p` call. Nothing blocking.
- **`prod-probe.yml`:** both jobs now take their runner from the `PROBE_RUNS_ON` setting, and fall back to `ubuntu-latest` when it is unset. The issue reporting moved from `gh` shell commands to `actions/github-script`, with the same behaviour:
  - On a failure it opens a tracking issue, or comments on the one already open.
  - On a fully passing run it closes that issue, and closes it before commenting, so a retried run doesn't post a second comment.
  - A missing or malformed summary file falls back to a generic message.
- **`DEPLOYMENT.md`:** I checked the claim that `deploy.yml` uses the `CI_RUNS_ON` switch against `deploy.yml` at this head (line 60), and it matches. The new trust note says which secrets reach the self-hosted runner, and the docs explain how to opt in to that runner and how to fall back to hosted runners.
- **Minor note:** if the probe job succeeds but its overall result is not `pass`, the report step is skipped and the issue stays as it is. The old workflow behaved the same way, so this is not a regression.

**2. Check before changing anything.** The PR was OPEN, still a draft, and its head was exactly `7c3a765ee2971c789d1e7891911678944bd833dc`.

**3. Un-draft.** `gh pr ready` succeeded.

**4. Check after.** The PR reports draft = false, it is still OPEN, and the head is still `7c3a765ee2971c789d1e7891911678944bd833dc`.

No garden repo changes and no follow-ups.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr182-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (250573 cached reads)
- Output: 2175 tokens
- Cost: $0.4287826
- Wall-clock: 258s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
