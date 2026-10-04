Fix round 1 for kriscendobot/minion.town#150 is pushed, and CI is green: all 3 checks passed.

The new commit is `6dd243b` on `fix/claude-cli-production-enable`, on top of `f77663c`. I pushed it with `safe-push-pr-head.sh`, which only adds commits on top of the branch.

**What the panel asked for and what changed:**
- **`infer` race (breaker must-fix; assessor, purist, corner-prober and wire-watcher flagged the same thing):** `infer` used to check `agents.list()` and then call `agents.create(name)`. That had two problems:
  - `list()` returns `[]` on any error, so a brief listing fault made a live child look `not-found`.
  - `create` is get-or-create, so a dismiss that landed between the two calls could bring the child back, spending a quota slot.

  The tools now keep, per MCP session, the agent handles that `createClaudeAgent` returned. `infer` reads only those handles and never creates a child. A child dismissed in the meantime answers `unavailable`. A session that didn't create a child gets `not-found` and can call `createClaudeAgent` to pick up the existing child; calling it again for an existing name returns the same child, not a new one.
- **Child names (corner-prober):** the name schema now matches `isValidChildName` (1–128 characters of `[A-Za-z0-9._-]`, not `.` or `..`). All three tools now reject a bad name the same way, with a tool error. Before, `create`/`dismiss` said `unavailable` and `infer` said `not-found`. The allowlist-shrink concern also goes away, because `infer` no longer re-runs the admission check.
- **Memory limit (engine-realist):** the confinement probe that runs at connect time starts its own Claude process, outside the `ENDO_CLAUDE_CONCURRENCY=1` limit. So two processes can share the unit's 1G memory limit, which only allows for one. I raised `MemoryMax` to 1536M and corrected the unit comment and DEPLOYMENT.md, including the post-deploy check value (`1610612736`).
- **README (surfacer):** it no longer calls `status` the only composed tool; `claudeStatus` is now named as a second one.
- **Comment trims (pruner):** I shortened the design reasoning in the `registerClaudeAgentsTools` JSDoc, the systemd unit comment, and the DEPLOYMENT.md "Root endowment" bullet.
- **Tests:** three new tests in `test/claude-agents-tools.test.ts` cover a session that never created the child, a dismissed child not coming back, and the set of rejected names (plus the 128-character limit). Typecheck is clean, and the two Claude-tools test files pass (33 tests).

**Not changed:**
- **"cancelled" (orthographer):** I left it. It is the literal result tag `{ type: "cancelled" }` defined in `src/endo/claude/types.ts`, not prose, so changing it would misdescribe what the API returns.
- **PR-body edits (pruner #4/#5):** I didn't touch the PR description.

**Test suite:** the full run has one failure, in `test/git-remote/capability.test.ts` ("propagates a git failure…"), which these changes don't touch. My notes say it already fails on this host, but I didn't rerun it on the base commit to confirm. CI is green.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr150-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1613721 cached reads)
- Output: 12173 tokens
- Cost: $1.1979322000000003
- Wall-clock: 448s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
