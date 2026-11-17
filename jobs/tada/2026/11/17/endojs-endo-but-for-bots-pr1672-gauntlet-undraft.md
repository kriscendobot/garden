**Un-draft stage, endojs/endo-but-for-bots#1672: done.** The PR is now ready for review on head `fff66514bb1b`, the commit the panel passed.

- **Check before un-drafting:** the PR was open, still a draft, and on the exact head the panel covered.
- **Un-draft:** ran `gh pr ready`. A fresh fetch afterwards shows `isDraft=false` with the same head.
- **Advisory appellate pass:** a light `claude -p` (sonnet) review of the diff. It was advisory only, so it did not hold up the un-draft. It looked only at the diff, not the repo or the linked PRs. Possible problems it raised in the design doc:
  1. The 500-character `compatibility` limit has no source. Its only citation is the doc's own heading.
  2. The "on by default" recommendation for the remaining cross-harness open question is weakly supported.
  3. The directory precedence order doesn't match the `10-`/`20-` numeric-prefix scheme. The doc doesn't say how the setup script maps directories to tiers or what happens when two directories land in the same tier.
  4. The doc links to the "Shared discovery walker" section from the unmerged PR #1671, so that link may not exist on the base branch. It also mentions #1640 inconsistently.
  5. The 200-skill cap and the 1 MiB limit are not in the test plan.

**Follow-up:** none required. The maintainer may want to look at items 3 and 4 when reviewing.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1672-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (185504 cached reads)
- Output: 1287 tokens
- Cost: $0.4295288
- Wall-clock: 56s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
