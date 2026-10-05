Panel round 6 on kriscendobot/minion.town#160 came back **must-fix**.

**What I did**
- Made an isolated checkout of the PR head (`kriscendobot/minion.town@claude-guest-scoped-mcp`, `0e00fb5`).
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against base `main-9ac858d`. It exited 0 with disposition `must-fix`.
- All 33 seats returned: 2 request-changes (engine-realist, scribe), 11 comment-only, 20 approve.
- Posted the result as review 5421035968 on head `0e00fb5`. It went up as a COMMENTED review starting `## Panel round 6 — must-fix`, the same as earlier rounds, because GitHub doesn't let the bot request changes on its own PR.
- The full aggregate was 80 KB, which is over GitHub's review size limit. To fit, I dropped the per-seat "Self-improvement" lines and collapsed the 18 labeled approve seats to a list of names. Every request-changes and comment-only section is posted in full, plus the breaker and curator sections.

**Blocking items for the fix loop**
1. **engine-realist (must-fix):** in `src/endo/claude/claude-guest-bridge.ts:159-176,183-202`, a broker whose `close()` throws leaves its socket directory behind until the process exits.
   - `closeBroker` removes the map entry before awaiting `close()`, and the failure is only logged through `diagnose`.
   - The directory sweep runs once per process, so nothing ever cleans these up later.
   - Repeated failures could fill the shared tmpfs `brokerDirectory` and stop new guests from starting.
   - Fix: on a failed close, try to remove that broker's own directory, or re-run the sweep; add a test.
2. **scribe (summary-fix):** post a top-level completion-summary comment for the round-5 fix push `0e00fb5`.

**Not blocking**
- prover suggests adding a test for the `makeAgentTools`-missing fail-closed path in `cli-deployment.ts`.
- locksmith, warden and breaker note that guests are kept away from each other's broker sockets only by tool confinement until #162 lands.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-claude-guest-scoped-mcp-gauntlet-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (951046 cached reads)
- Output: 5500 tokens
- Cost: $0.8222571999999999
- Wall-clock: 1037s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
