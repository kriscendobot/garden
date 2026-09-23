---
ts: 2026-06-18T22:05:35Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/17
---

Fixer round 1 on PR #290 (barrister 5fa8a5 must-fix list).

Five items addressed:

1. Dropped `runAgentRound` import from `@endo/genie` and inlined the async-generator locally in agent.js. Removed `@endo/genie` from package.json. Commit: adc3ebb69.

2. Updated the stale comment about genie's Ollama handling to describe the local resolveModel helper instead. Addressed by the same commit as item 1.

3. Narrowed toAgentTool executeTool param type from `any` to `(name: string, args: Record<string, unknown>) => Promise<unknown>`. Commit: adc3ebb69.

4. Rewrote PR #290 body via gh pr edit: removed references to pi-turn-N, agent-round.js, scripted-pi-agent.js, and cross-restart persistence (none landed). Body now describes the harness adoption, genie removal, and workerEnv.provider removal.

5. Expanded changeset body and bumped @endo/lal from patch to minor. Commit: b1885dcd6.

Bonus fixes in commit adc3ebb69: converted inline import() in LalToolDef typedef to @import tag (pre-push gate); fixed pre-existing s.length > 200 lint error with explicit string cast.

yarn.lock updated in separate commit f7e9d0452.

All lal tests pass (17 pass, 1 skipped). Top-level PR comment posted at-mentioning @kumavis.

Self-improvement: the no-inline-import-jsdoc probe catches pre-existing violations in changed files even when those lines were not touched by the current commit -- the gate scans the whole file, not just the diff lines. Fixer should sweep changed files for pre-existing inline imports before committing.
