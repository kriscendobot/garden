Viability gate for PR #1347: **proceed**. Nothing has replaced the PR, and the need it fills is still there.

**Deciding question:** Is the per-user daemon side of the gateway bootstrap registrar (`designs/gateway-package.md` Feature 4) still missing from the main code and from any newer PR, with the design and the PR it stacks on (#388) still current?

**Answer:** Yes.

**Evidence:**
- **PR state:** #1347 is open, a draft, and not merged. Its head is `f7f478eeca`. Its base is the frozen `design/gateway-package-phase-2-386866c`, which still matches `design/gateway-package-phase-2` (#388's head) exactly at `386866c0939b`, so the stack has not drifted.
- **The PR it stacks on:** #388 (the UDS bootstrap registrar plus proof-of-possession) is still open and a draft. Nothing has replaced it, and #1347 adds the half #388 lacks.
- **Main code:** on `llm`, `packages/gateway/src` contains only `config.js`, `types.ts` and `vhost.js`. There is no `user-daemon.js` and no registrar code. Recent `llm` commits under `packages/gateway` are only dependency bumps and lint changes, with no gateway or registrar work.
- **Design:** `designs/gateway-package.md` § Feature 4 still specifies a per-user daemon that registers once and then publishes weblets through the returned handle. The file's last change (2026-08-27) is unrelated cbor/framing work, so the premise still holds.
- **Competing work:** searching all PRs for gateway / user-daemon / registrar turned up only the sibling phase PRs (#389, #393, #394, #410, #356, #610, #674) and the new MCP work (#1499, #1500). None of them implements the daemon-side registrar.
- **Discussion:** the PR has no comments or reviews, so no one has raised an objection or pointed elsewhere.

Caveat: #1347 can only land after #388, so the gauntlet's later stages may stall on that dependency.

I spent no clean, panel, fix, CI-wait or un-draft budget.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1347-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (156361 cached reads)
- Output: 1698 tokens
- Cost: $0.40659219999999996
- Wall-clock: 32s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
