# Fix round 6: kriscendobot/minion.town PR #150

I pushed the round-6 fixes and CI is green. The PR still can't pass the panel without a maintainer decision: the phase-evidence gate returns `blocked` (rc 20), so panel-7 will very likely come back must-fix again.

**Code fixes** (head `fed9a62` → `c26dedf`, pushed with `safe-push-pr-head.sh`; typecheck and the four affected test files pass):
- `228565e` refactor:
  - **Purist:** the tool bundle is narrowed to `{ agents: ClaudeAgents; account: ClaudeAccountStatus }` and renamed `ClaudeHandles`. It now lives in `src/endo/claude/types.ts`, so `wiring.ts` no longer imports from `guest-tools.ts`, and `server.ts` and the test import it from there.
  - **Purist:** fixed the wrong type name in the `mcp-tool-names.ts` comment and removed the double blank line in `agents.ts`.
  - **Orthographer:** `cancelled` → `canceled`.
  - **Typist:** replaced the `→` arrows in the test prose.
- `c26dedf` docs: removed the "interim deviation" paragraph this PR had added to step 3 of `designs/claude-agents-capability.md`. The PR no longer changes the design compared with its base (integrator item 3).

**PR body changes:**
- Cut the "Scope" section (pruner).
- Reworded the deviation section to say the step-3 change is waiting on a maintainer decision. It also says the MCP tool names are expected to be renamed to the design's names once those land (integrator should-fix 4).
- Added a `## Phase and evidence ledger` with the required markers (integrator item 1). It is honest:
  - Phase 1 is blocked, because the Endo substrate hasn't landed.
  - Phase 2 is satisfied.
  - Phases 3–6 and Acceptance are open.

**Integrator items 2 and 3 are not resolved; only the maintainer can decide them.** I messaged the maintainer (msg-…-53506b77f538) with two options:
- **(a)** Sign off on running the step-3 canary through MCP composition before step 1 lands, and merge as a phase-2 enablement ("merge at current head").
- **(b)** Return the PR to draft as a non-deliverable probe.

No reply had arrived by the time I finished.

**CI:** `ci-wait-merge.sh --no-merge` returned rc 0, 3 of 3 checks passed.

**Follow-ups:**
- Until the maintainer answers, more panel/fix rounds are likely to repeat the same must-fix (about 20 minutes per panel). The driver or liaison should consider pausing the gauntlet.
- Gate bug: `phase-evidence-gate.sh` passes ledger rows to `xargs`, so an apostrophe in a row prints "unmatched single quote". I worked around it by rewording the row; the script should use `xargs -0` or trim another way.
- Not done, both comment-only: the breaker's should-fix (the 403 deploy smoke should forge the root `sub`) and the breaker and wire-watcher notes on memory sizing.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr150-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (2045884 cached reads)
- Output: 12085 tokens
- Cost: $1.3091487999999998
- Wall-clock: 333s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
