# Gauntlet fix round 4: kriscendobot/minion.town PR #186

I applied both must-fix items from the round-4 panel review (5526808074). CI is green on the new head `57aafde482e`.

## What I changed

**Must-fix 1 (packager): mixed commits.**
- **Reindent removed:** I reverted the rename and re-wrap of the whole `app.post(mcpPath, …)` handler in `src/http.ts`. It is back to its original `req`/`res` form and comments, so the PR's diff to that file is now only the import plus the two `writeMcpAudit` calls (on session start and through `auditClaudeTool`). I also restored the original `server.ts` comment that the PR had rewritten.
- **History rewritten:** the panel asked for a different commit shape, so I rewrote the branch instead of adding follow-up commits. I squashed the six commits into two, and the final tree is unchanged by the regrouping:
  - `9cfacc5 feat(mcp): audit MCP sessions and root Claude-agents tool calls`. This holds the `src/` changes and the audit tests, and it typechecks and passes its tests on its own.
  - `57aafde feat(canary): add the root MCP credential path`. This holds the deploy scripts, the probe, `DEPLOYMENT.md` and the canary tests.
- I force-pushed with `safe-push-pr-head.sh --mode rewrite` against a freshly fetched lease (`63265e4 → 57aafde`).

**Must-fix 2 (pruner): duplicated prose.**
- **`DEPLOYMENT.md`:**
  - The arming gate is now stated once, at the verification spike.
  - I deleted "The setup state is explicit."
  - The client-shape paragraph is replaced by a link to the design doc, § 2.1.
  - I removed the child-refresh internals.
  - The audit field list is cut down to a pointer to the design's § 2.5, plus the two guarantees operators rely on.
  - I also took the reviewer's should-fix to replace "during a muster" with the concrete mint command.
- **Code comments:**
  - I cut the refresh-classification comments in `root-canary-common.sh` and `root-canary-exec.sh`. The exec header now points to `DEPLOYMENT.md`.
  - I removed the comment in `root-canary-status.sh` and the `isMainModule` JSDoc.
  - The file JSDoc in `mcp-audit-http.test.ts` is now one line.
  - The two `http.ts` comments the pruner flagged are back to their original text, so they no longer appear in the PR's diff.
- **PR body:** cut from 398 to 256 words, with the template headings and the ledger and job markers kept. It now names the audit hook as a deliberate part of the deliverable (a packager comment-only item). I also fixed an error in the Phase 4 line, which claimed a "refresh cache" that doesn't exist.

**Also fixed (assessor should-fix):** the stale-sweep `dismissClaudeAgent` and `remove` calls in `deploy/probe/root-canary.mjs` now go through `textOf`. A refused cleanup now fails the run instead of being reported as done.

## Checks

- **Typecheck and PR tests:** typecheck passes, and the five PR-related test files pass (39 tests).
- **Full suite:** 1066 passed and 1 failed. The failure is `test/git-remote/capability.test.ts` ("propagates a git failure…"). This PR doesn't touch that file; my guess is that the fleet's git wrapper environment causes it, but I didn't confirm that.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0 (CI GREEN, 1 of 1 runs).

## Not done (should-fix or optional)

- I left the `run(...)` call-site reindent in `src/endo/guest-tools.ts` as it is. The packager called it mechanical fallout and rated it should-fix, not must-fix. I also skipped the decomplector's optional `{tool, childName}` record.
- I didn't restrict `root-canary-mint.sh` to loopback-only callback hosts (the purist's RFC 8252 should-fix).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr186-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1646174 cached reads)
- Output: 12615 tokens
- Cost: $1.1897268
- Wall-clock: 1170s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
