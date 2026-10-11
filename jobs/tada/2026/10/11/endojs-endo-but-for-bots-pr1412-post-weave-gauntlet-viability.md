**Viability report: endojs/endo-but-for-bots PR #1412** ("feat(claude): add CLI and Agent SDK inference backends (#1357)")

**Verdict: proceed.** I spent no clean, panel, fix, CI-wait or un-draft budget on this check.

**PR facts:** The PR is open, unmerged and still a draft. Its base is the frozen `llm-dc96042` (`dc960427fe`) and its head is `b744bacbe0` on `build/endo-claude-backends-1357`. The PR was woven onto that base today, 2026-10-11T22:17Z, after #1403 merged. The weave dropped the phase-1 commits and moved the backends to phase 1's final `CredentialGrant.env` shape.

**Deciding question:** Now that phase 1 (#1403) has landed on `llm`, is phase 2 of `designs/endo-claude-inference-backends.md` still unimplemented on the base? That is, the CLI and Agent SDK backends of `@endo/claude` over `@endo/inference`, with nothing newer having taken over that work. **Answer: yes.**

**Evidence:**
- **The base is exactly phase 1.** The tip of `llm` is `dc960427fe`, "feat(inference): add the provider-neutral @endo/inference interface (#1403)", merged 2026-10-11. #1412 builds directly on it.
- **Nothing on `llm` duplicates phase 2.** `packages/claude/src` on `llm` contains only the earlier confined-turn modules (`argv.js`, `confined-turn.js`, `launch.js`, …). There is no `makeClaudeCliBackend` or `makeClaudeSdkBackend`, and no commits since #1403 touch this area.
- **The design still calls for this work.** It is still in Draft status on `llm`. Its § Phased Implementation lists phase 2 as exactly what this PR delivers: the `@endo/claude` core plus the two backends.
- **No competing PR exists.** The only related open PR is #1369. It is a gap-revealing probe meant to stay draft, and this PR cites it as evidence. #1357 is the design PR that this one implements, and it merged on 2026-10-01. #1102, the agents factory, is closed and does not touch the `InferenceBackend` interface.
- **Prior state:** the previous gauntlet ended at `review-budget-reached` after 6 rounds with CI green on head `aa09ea465a`. Its last review round still had must-fix findings. Nothing since then has superseded the PR. The only change is the weave onto the merged phase 1, so a post-weave gauntlet is warranted.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1412-post-weave-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (275429 cached reads)
- Output: 2194 tokens
- Cost: $0.4642298
- Wall-clock: 168s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
