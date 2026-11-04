I'm letting the gauntlet go ahead: PR #1651 has not been superseded, and the problem it fixes still exists.

Deciding question: Is PR #1651 still the only open change that makes upstream 401/429/404 refusals reach callers as their own codes and charges a cut-short stream its full reservation, and do both faults still exist on its base?

Evidence:
- **PR state:** #1651 is open, not merged and still a draft. It was opened today (2026-11-04T15:30Z) and has no comments or reviews yet.
- **Its base still has both faults:** #1651 is stacked on a frozen copy of #1575's head (`feature/api-key-provider-adapters-0b8d24a`). #1575 is still an open draft. The diff adds `revealUpstreamRefusal`, the refusal codes, and the `complete: false` charging rule. So none of them exist on the base, and the two faults it describes are still there.
- **Nothing newer replaces it:** Three other PRs build on the same work:
  - #1648 (agent factory) sits on the same base and changes only factory files.
  - #1649 (pinned responder) is stacked on #1648. A search of its diff found no refusal-reporting or settlement change.
  - #1587 (OAuth-backed inference providers) is a separate change.

  A GitHub search for the new refusal code names finds only #1651.
- **The motivating design still stands:** Design #1543 is still open. #1651 is phase 2 of it, and its description says later phases are owned by `orchestrate-build-api-key-agents-20261104`. The extra phase-2 tests it adds are still needed.

Before merging, two things in the PR description need attention:
- **Merge order:** #1651 can't land before #1575, which is itself still a draft.
- **Maintainer question:** a refused upstream turn is still charged its full reservation, so retries against a bad key can use up a daily budget. The design's "ends without usage" rule asks for this, and the PR flags it for a maintainer to look at.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1651-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (184729 cached reads)
- Output: 1545 tokens
- Cost: $0.4532938
- Wall-clock: 27s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
