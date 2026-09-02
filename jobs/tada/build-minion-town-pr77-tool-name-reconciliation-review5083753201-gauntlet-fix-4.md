CI is green (rc 0). The fix stage is complete.

## Completion report

**Job:** Gauntlet FIX round 4 — kriscendobot/minion.town PR #79 (`feat/tool-name-reconciliation`).

**What I did:** Read the round-4 panel verdict (disposition must-fix, 11 request-changes seats), applied its must-fix items plus the strongest-consensus should-fixes in one push to the PR head, then watched CI to green.

**Changes (commit `96de5cc`, 2 files — `src/endo/mcp-tool-names.ts`, `test/endo-mcp-tool-names.test.ts`):**
- **Rename `MAXIMAL_*` → `RECONCILED_*`** (stylist must-fix): constant, collector, throw text, and docstrings. The manifest is the *reconciled portion* of the maximal surface, not maximal-among-designed — the old name misled.
- **Enforce case-confusability** (breaker must-fix + 5 seats): added `findCaseConfusableToolNames` / `assertNoCaseConfusableToolNames`, wired into `collectReconciledToolNames`, so `readText`/`readtext` twins now throw at import — the grammar docstring's advertised property is now real.
- **Grammar length bound `{0,63}` (64-char cap) + corrected rationale** (saboteur/spec-keeper/wire-watcher): stopped misciting a nonexistent MCP-protocol constraint; cite README rule 1 and provider function-name length ceilings.
- **Literal-union typing** (typist/curator/warden/locksmith): generic collector + `ReconciledToolName` export; a membership typo is now a compile error.
- **`REGISTERED_MCP_TOOL_NAMES` doc** (typist/breaker): reworded to "maximal registered surface" since `sites` is conditionally mounted.

**Verification:** `npm run typecheck` clean; full vitest suite `324 passed | 5 skipped`; CI on the pushed head **GREEN** (rc 0).

**Deferred (recorded on the PR, not silently dropped):** chokepoint-typing every `registerTool` call and driving `createMcpServer` in the coherence test (larger structural should-fixes across `guest-tools.ts`/`server.ts`/`endo-clip-tools.test.ts`); benchmarker's O(n²) follow-up; migrator's README precedence-prose comment-only. Posted a round-4 fix-summary comment (`#issuecomment-5515672306`) addressing the scribe seat.

Did NOT re-run the panel (the driver re-posts panel-5).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-pr77-tool-name-reconciliation-review5083753201-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 65 tokens (2875442 cached reads)
- Output: 24960 tokens
- Cost: $2.9659539999999995
- Wall-clock: 412s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
