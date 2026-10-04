**Viability gate: kriscendobot/minion.town PR #150 ("feat(claude): enable the Claude CLI provider in production") — the gauntlet can proceed.**

The PR is open, unmerged and in draft. It is based on `main-a378bb3`, and its head is `f77663c0e7`. It was opened at 2026-10-04T16:01:05Z, about 20 minutes after #148 merged, and has no comments or reviews yet.

Deciding question: Is `main` still the same as the PR's base `a378bb3` (the #148 merge), still shipping the provider turned off (no `ENDO_CLAUDE_ENABLED`, `MemoryMax=256M`) with `agentsFor` not called from `src/`, and does no other open or merged PR enable it?

Evidence:
- **Base is current:** comparing `a378bb3...main` shows `ahead_by=0`, and `main`'s tip is the #148 merge. Nothing has landed since.
- **Provider still off on `main`:** `deploy/aws/systemd/minion-mcp.service` still says the unit "does NOT set" `ENDO_CLAUDE_ENABLED=1` and still has `MemoryMax=256M` at line 119. This is the premise the PR fixes.
- **`agentsFor` still not called from `src/`:** a code search finds it only in its definition (`src/endo/claude/wiring.ts`), the design doc and tests. The root guest still cannot call `create` and then `infer`.
- **Nothing supersedes it:** none of the other open Claude PRs enables the provider in production. #105 and #106 are older gap-revealing prototypes, which #148 and this PR build on. #122 binds the Claude pin to a signed manifest. #150 itself plans to close #105 after it lands.
- **Need still holds:** the canary blocked after #148 is still waiting on this enablement, as the PR body records.

Nothing was changed; this stage only reads.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr150-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (171297 cached reads)
- Output: 1442 tokens
- Cost: $0.41571539999999996
- Wall-clock: 23s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
