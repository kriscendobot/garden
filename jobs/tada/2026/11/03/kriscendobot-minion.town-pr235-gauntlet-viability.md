**Viability for kriscendobot/minion.town PR #235: proceed.** The PR has not been superseded, and the reason for it still holds. I spent nothing on clean, panel, fix, CI-wait or un-draft work.

**PR facts:** PR #235, "feat(mcp): a guide served as resources, and a primer, centered on evaluate", is OPEN, a draft, and not merged. It was opened at 2026-11-03T22:09Z, 17 minutes before this job was posted. Its base is the frozen branch `main-3f6c2b2`, which is the merge of #233. It has no reviews and no comments.

Deciding question: Has anything landed on `main` (or another open PR) that already delivers the MCP guide resources, recipes and primer centered on `evaluate`, or has the 2026-11-03 direction (keep the tool surface minimal and work through `evaluate`) been reversed?
Answer: No to both.

Evidence:
- **Nothing on `main` overlaps.** `resources/`, `src/resources.ts`, `primer/` and `tools/guide-recipes/` all return 404 there.
- **The only newer `main` change doesn't displace it.** Since the base, only #234 merged (22:17Z): a probe that checks an invitation round trip locally, plus web routes to forget a contact and dismiss a message. The PR's guide and primer don't cover that.
- **No other open PR competes.** An open-PR search found only unrelated designs (#88, #101, #177, #181).
- **The motivating direction still holds.** It is the 2026-11-03 maintainer direction the PR cites, and it matches the current sequence: prove invitations, give an API-key agent its endowments, then iterate the primer.
- **The `evaluate` fix is still needed.** The PR body says production still answers `evaluate` calls that return `undefined` with a protocol error, and #234 doesn't touch this.

**For the gauntlet:** the PR body asks the maintainer to decide whether to revert #233, which added the `invite` and `cancelInvite` tools. That is an open question for review, not grounds to stop.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr235-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (185481 cached reads)
- Output: 1671 tokens
- Cost: $0.4584762
- Wall-clock: 29s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
