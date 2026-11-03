**Viability report: kriscendobot/minion.town PR #229, "feat: add API-key provider management UI"**

The gauntlet can start. The PR is open, unmerged and still a draft. Head is `793d1c2bc0`, on frozen base `main-443519e` (`443519ebee`). Nothing has replaced it, and the reason for it still holds.

Deciding question: Is the Phase 3 API-key provider management UI and endpoint for endojs/endo-but-for-bots#1543 still missing from `main`, with nothing newer covering it, while the daemon-side contract it waits on is still on track?

Answer: yes.

Evidence:
- **Nothing on `main` replaces it.** None of the PR's new files exist on `main`: `deploy/aws/www/provider-ui.js`, `src/auth/inference-provider-endpoint.ts` and `src/endo/inference-provider-service.ts` all return 404. `main` is 9 commits past the frozen base. Those commits are a claude-code dependabot bump (#232) and the MCP invite/cancelInvite tools (#233), and none of them touch the provider UI.
- **No competing PR.** Searching the repo's PRs for "provider" finds no other open or merged PR that implements this surface. #115 is a separate Codex prototype. #228 is the agent-chat Clip design, which builds on top of this work.
- **The tracking work is still live.** The tracking issue #227 ("Arc: minion.town Claude API — API-key providers and pinned agents") is still open. The PR's evidence ledger hands Phases 4–7 to the successor orchestration `claude-api-build-20261027`, so this PR is still the Phase 3 slice of that work.
- **The dependency it was waiting on has landed.** A 2026-11-03 comment on the PR says endojs/endo-but-for-bots#1575 now has the Phase 3 operation-management contract (commit `1f08aaab73`). That contract is `getOperationStatus`, `listPendingOperations`, `cancelOperation`, `reattach` and `assertUpstreamRevoked`. The PR description named exactly these as missing, so the reason for the PR still holds and its off-by-default rollout gate can now be evaluated. #1575 is still a draft itself.
- **It still matches current priorities.** It fits the stated minion.town direction for 2026-10-29 and 2026-11-03: an API-key agent with endowments.

I made no changes and spent no clean, panel, fix or CI budget.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr229-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (124546 cached reads)
- Output: 1458 tokens
- Cost: $0.42857320000000004
- Wall-clock: 26s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
