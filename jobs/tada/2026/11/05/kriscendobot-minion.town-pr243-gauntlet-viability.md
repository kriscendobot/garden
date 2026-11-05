**Viability for kriscendobot/minion.town PR #243: proceed.** I found nothing that supersedes the PR, and the reason it was opened still holds. I spent no clean, panel, fix or CI budget, and I changed nothing.

**Deciding question:** Does `main` still carry the `invite`/`cancelInvite` MCP tools and the per-guest inviter, with no newer change removing them or moving the design away from minting invitations through `evaluate`?

**Answer:** Yes. They are still there and nothing has displaced them.

**Evidence:**
- **PR state:** #243 is OPEN, a draft, mergeable and unreviewed. Its head is `0e8813c8` and it is stacked on the frozen base `garden/mcp-invite-tool-removal-base-86612c6`.
- **The tools are still on `main`:** `src/endo/mcp-tool-names.ts` at lines 78–79 still maps `invite: "invite"` and `cancel: "cancelInvite"`. The last commits touching `src/endo/guest-tools.ts` are #233's invite and `cancelInvite` work from 2026-11-03. The PR exists to remove exactly that.
- **No newer replacement:** the 15 most recent commits on `main` (`7a0bcc90` and earlier) are agents and stack-integration work, and none of them touch the invite tools. Searching PRs with "invite" in the title finds only #243 open, plus the merged #233 and #81 that it builds on.
- **The stack it depends on is still open and unmerged:** #239 (accept a locator minted by `evaluate` on the web page), #242 (remove the guest tools `evaluate` already covers) and #235 (the guide and primer centered on `evaluate`). The design `designs/mcp-resources-getting-started.md` is still the one in force.

**Before it can land:** the PR body says #243 must not land until #239 has merged and deployed and the production browser proof passes. That proof has not run, and the successor job `build-minion-town-tool-removal-landing-20261104` owns it. This limits when it can merge, not whether the gauntlet can start, but the un-draft step should respect it.

**Possible early fix:** the PR fixes a bug in `deploy/aws/www/home.js` that also affects production today: a visitor who already holds a guest never sees the invitation card. The maintainer may want that small fix landed separately, ahead of this PR.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr243-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (184573 cached reads)
- Output: 1729 tokens
- Cost: $0.4503106
- Wall-clock: 47s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
