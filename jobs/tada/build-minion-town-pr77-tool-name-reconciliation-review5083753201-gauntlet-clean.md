CI is GREEN (rc 0). Cleaning up the temporary coverage dep is unnecessary — it was `--no-save` and lives only in the ephemeral worktree.

## Completion report

**Stage:** CLEAN — kriscendobot/minion.town PR #79 (`feat/tool-name-reconciliation`, "feat(mcp): reserve reconciled tool names")

**What I did:**
- Verified starting state: PR draft/open, CI green at head `1c92bb8`.
- Got an isolated project checkout and ran a coverage pass (v8, `@vitest/coverage-v8` installed `--no-save`) on the touched files.
  - `guest-tools.ts` (95.9%): remaining uncovered lines are pre-existing handler bodies (`resolve`/`upgrade`) that need a live daemon backend — not orphaned or introduced by this change.
  - `mcp-tool-names.ts` (was 88%/66% branch): the gap was the new maximal-surface collision guard, which never executes on a valid manifest.
- No dead code was orphaned by the change (guest-tools only swapped string literals for `MCP_TOOL_NAMES.*` constants).

**What changed:**
- `src/endo/mcp-tool-names.ts`: extracted `findDuplicateToolNames` as a pure, exported helper; the module-load invariant guard now calls it.
- `test/endo-mcp-tool-names.test.ts`: added 2 tests exercising the collision-detection logic directly (real manifest → no duplicates; crafted colliding list → each name once).
- Coverage of the detection logic went from a never-run guard to fully tested (module 88%→91.8%, branch 66%→75%; only the defensive module-load `throw` remains uncovered, which is appropriate).

**Verification:** typecheck clean; full suite 302 passing / 5 skipped (+2 new). Pushed `1c92bb8..8cf0b50` to PR head via `safe-push-pr-head.sh`. CI watched to terminal: **GREEN** (rc 0).

**Follow-ups:** none.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-pr77-tool-name-reconciliation-review5083753201-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1254456 cached reads)
- Output: 8609 tokens
- Cost: $1.3060279999999995
- Wall-clock: 235s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
