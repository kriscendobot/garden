**Viability gate: kriscendobot/minion.town PR #183** (head `78df7d85`, base `main-bc11010`)

The gauntlet may begin. The PR is still the only implementation of this work, and the need behind it still holds.

**PR state:** open, not merged, not draft. It was un-drafted on 2026-10-13 for the proxy screen after fix round 7, and CI is green.

**Deciding question:** Does live `main` (or any other open or merged PR) already store Claude credentials on `@secrets` with the prompt-origin gate at the Endo `204033b398` pin, making #183 redundant? Or has the phase-3 need in kriscendobot/garden#89 item 4 lapsed? The answer is no on both counts.

**Evidence:**
- **Base history:** `main` is only 3 commits ahead of the frozen base `bc11010`. All three are a dependabot `@anthropic-ai/claude-code` bump (merge of #185), and they touch only `tools/claude-harness/*`. None of #183's files (`src/endo/claude/*`, `DEPLOYMENT.md`, `deploy/aws/*`) changed.
- **No duplicate on main:** `src/endo/claude/secrets-credential-vault.ts` does not exist on `main`, so #183's vault and gate work has not landed by another route.
- **No competing PR:** searching minion.town PRs finds nothing else that implements secrets-backed credentials or the prompt-origin gate. The nearby open PRs (#167 canary-principal design, #105 probe, #184) cover different scope.
- **Premise still holds:**
  - The arc issue kriscendobot/garden#89 is still OPEN.
  - Both PRs #183 builds on are MERGED: endojs/endo-but-for-bots#1403 (provider-neutral seam) and #1412 (Claude backends, merged 2026-10-12).
  - The PR's phase ledger still marks phase 3 as partial; this PR supplies the secret storage and gate. The named successor `minion-town-claude-kriscendobot-canary-after-connect-20261006` owns the canary, so the PR is still needed.

I made no changes and spent no clean, panel, fix, or CI budget.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr183-screen-78df7d85-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (177969 cached reads)
- Output: 1582 tokens
- Cost: $0.4317778000000001
- Wall-clock: 24s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
