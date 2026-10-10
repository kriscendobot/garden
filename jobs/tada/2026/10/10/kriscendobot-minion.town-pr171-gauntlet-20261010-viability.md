**Viability report: kriscendobot/minion.town PR #171** ("feat(probe): validate the pinned Claude harness in production")

The PR is open, unmerged and still a draft. Its head is `cf86259` on branch `feat/claude-arc-prod-validation`. It is stacked on the frozen base `feat/prod-objectives-probe-f432a51`, a snapshot of open PR #166.

Deciding question: Is there still no runtime check on `main` that confirms the pinned Claude harness on the live box between deploys, and is the stack it builds on (#166 and arc kriscendobot/garden#89) still active? **Yes.**

Evidence:
- **Nothing on `main` replaces it.** `main` has no `deploy/probe/` directory, no `claude-harness-observe.cjs` and no `.github/workflows/prod-probe.yml`. Its tree has only the deploy-time harness tooling in `tools/claude-harness/`.
- **#122 adds to it rather than replacing it.** #122 merged on 2026-10-09 ("bind the Claude pin to Anthropic's signed manifest"). That strengthens the deploy-time gate, which runs once on the staged tree. The PR body explains why that is not enough: the goal is that the pin still holds on the live box between deploys. #171's check already compares against the signed-manifest digests.
- **The stack and its motivation are still open.** #166 (the base this PR stacks on) is open and a draft. Arc kriscendobot/garden#89 is open. Follow-up #172 (a probe-only role) is open, and the PR now implements that role.
- **The PR is current.** Gauntlet run `kriscendobot-minion.town-pr171-gauntlet` ended on 2026-10-09 with "review-budget-reached" after 6 rounds, CI green at `cf86259`, and the next step was "awaiting maintainer merge/undraft or re-run decision". No newer PR or design covers the same ground. A search for open and closed harness/probe PRs found only #171 and #166.
- **Two caveats, neither of which overtakes it.**
  - The PR must be rebased onto #166's eventual landing point, and possibly onto `main` after #122, before it can merge.
  - The probe-role and fixed-SSM-document path has not run live yet. It needs a maintainer to run `deploy-cd-iam.mjs` and a deploy that ships the observer.

I spent no clean, panel, fix or CI budget and changed nothing.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr171-gauntlet-20261010-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (228681 cached reads)
- Output: 2362 tokens
- Cost: $0.4859042
- Wall-clock: 34s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
