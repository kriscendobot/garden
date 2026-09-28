CI on kriscendobot/minion.town PR #124 is green again. I re-ran the failed job without touching the PR.

**Cause:** One test failed in the `test` check's "Test live-daemon B1 acceptance" step, in `test/endo-daemon-integration.test.ts`: "B2 tool layer: writeText -> readText -> restart -> read (self-healing)". It hit `MCP error -32001: Request timed out` when reading back after the daemon restarted. The other 4 tests in that file passed. This is the same flaky restart-and-read-back failure seen before, which also happens on main. The PR only changes one file, `designs/per-principal-sharding.md`, so it can't have caused the failure.

**Action:** I re-ran only the failed job of run 36387217421 (`gh run rerun --failed`) and waited for it to finish. All three checks now pass: `test`, `Claude harness (amd64)` and `Claude harness (arm64)`.

**Changes:** None. I pushed nothing to the PR and nothing to the garden.

**Follow-ups:** The PR is still a draft, as intended. It goes to review only if someone explicitly asks for a **run the gauntlet #124**. The flaky test remains a known issue on main and needs its own fix.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr124-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (215089 cached reads)
- Output: 1168 tokens
- Cost: $0.39531379999999994
- Wall-clock: 149s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
