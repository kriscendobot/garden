**PR #1412 viability: proceed.** The PR is open, unmerged and still a draft. It was opened 2026-10-01 and is titled "feat(claude): add the Claude CLI and Agent SDK inference backends (#1357)".

**Deciding question:** Is phase 2 of `designs/endo-claude-inference-backends.md` (the Claude CLI and Agent SDK backends over the `@endo/inference` seam) still unbuilt on `llm`, and does the merged design still call for it?

**Evidence:**
- **Nothing on `llm` replaces it.** Neither `packages/inference/` nor `packages/claude/cli-backend.js` exists on `llm`. No commit on `llm` since 2026-10-01 touches claude or inference code.
- **The design still calls for this work.** The design file was last changed on `llm` at 2026-10-01T02:57Z, which is before this PR was opened. Its status is still "Draft, awaiting production evidence", and phase 2 is still the next step. No newer design displaces it.
- **The related PRs don't overtake it.** #1403 (phase 1, which this PR is stacked on) is still an open draft. #1369 is a gap-revealing prototype that this PR builds on, not a competing implementation. #1357 (the design) is merged.
- **There are no reviews and no maintainer comments.** The only comment is from an earlier gauntlet (`build-endo-claude-backends-1357-open-pr-gauntlet`): it halted with 0 rounds run because its clean stage failed and declared that outcome, and CI was red at head `be116c5f`. That says the branch needs fixing, not that its premise has lapsed. Commits pushed since then are titled "fix(claude): spawn with a mutable env copy…" and "test(claude): ignore macOS's __CF_USER_TEXT_ENCODING…".

For the gauntlet:
- **Review the last commits only.** The stack includes #1403's diff, so review this PR's own commits.
- **Expect a weave.** One will be needed once #1403 lands.
- **The earlier halt was on red CI.** Expect to fix CI in this round.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1412-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (229437 cached reads)
- Output: 2005 tokens
- Cost: $0.4506914
- Wall-clock: 29s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
