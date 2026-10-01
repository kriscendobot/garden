**Viability report: endojs/endo-but-for-bots PR #1412**

PR #1412 ("feat(claude): add the Claude CLI and Agent SDK inference backends (#1357)") is open, unmerged and in draft. It was opened 2026-10-01T18:53Z and has no comments or reviews yet. Its base is the frozen `llm-80054c3`.

Deciding question: Is there a newer PR, or code already on `llm`, that delivers phase 2 of the merged #1357 design (the Claude CLI and Agent SDK `InferenceBackend`s over `@endo/inference`), or has the phased design been abandoned?

Answer: no to both, so the PR is still viable.

Evidence:
- **Design still current.** #1357 (`designs/endo-claude-inference-backends.md`) is merged. The PR delivers its phase 2, and phases 3–6 have not started.
- **Phase 1 is still in flight.** The phase 1 seam is #1403, open as a draft. This PR stacks on it with a `--no-ff` merge.
- **Nothing on the base replaces it.**
  - `packages/inference` does not exist on `llm` (404).
  - `packages/claude/src` on `llm` has only the #1015/#1371 harness files (`confined-turn.js`, `harness.js`, `argv.js` and so on). There is no `cli-backend.js`, `sdk-backend.js`, `confinement-options.js`, `stream-reducer.js` or `response-shapes.js`.
- **No competing implementation.** I searched open and closed PRs for "inference" and "claude backend":
  - #1369 is a gap-revealing prototype probe, which the PR body cites as input.
  - #1406 (pin Claude Code 2.1.280 with dontAsk) and #1408 (bwrap slice) are follow-ups from #1371. They harden the existing #1015 harness and don't implement phase 2's backends.
  - No other PR delivers phase 2.

**For later stages:**
- **Stale phase-1 merge.** The PR merged #1403's head at `34a4a0b`, but #1403's head is now `66a1be9`. A restack or weave onto the current #1403 head (or onto `llm` once #1403 lands) may be needed before or during the gauntlet. This doesn't affect viability.
- **Possible overlap with #1406.** That PR also moves toward `dontAsk`. Watch for conflicts in `@endo/claude` if it lands first.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-backends-1357-open-pr-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (196579 cached reads)
- Output: 2167 tokens
- Cost: $0.3890958
- Wall-clock: 125s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
