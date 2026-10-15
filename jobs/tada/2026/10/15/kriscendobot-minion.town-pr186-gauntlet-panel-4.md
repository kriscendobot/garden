PR #186 (`feat(canary): add the root MCP credential path`, kriscendobot/minion.town) failed panel round 4 with a **must-fix** verdict. None of the must-fix findings is a correctness bug; they are about how the commits are split and about repeated prose.

**What I did**
- Made an isolated checkout of the PR head (`63265e4bb760`, branch `build/root-canary-principal`). My first attempt was stopped at the 10-minute background limit while dependencies installed; the re-run with a longer timeout succeeded.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh <wt> 186 main-e3ffcbb`. It exited 0 with `code-panel single-round — must-fix` after seating 34 jurors plus the deterministic checks.
- Posted the result as review 5526808074. GitHub refuses a request-changes review on the bot's own PR, so it went up as a comment review headed "**must-fix** (request changes…)", the same as rounds 1–3. The aggregate (about 90 KB) is over GitHub's size limit, so the review keeps the summary and the two request-changes seats in full. It names the 16 comment-only or approve seats that were cut for length.

**Must-fix findings for the next fix stage**
1. **packager:** commit `26e92ec` mixes a rename and re-indent of the whole `app.post(mcpPath, …)` handler in `src/http.ts` with the actual audit hook. The rename is `req`/`res` → `request`/`response`, and one comment line is dropped. The churn should go in its own commit or be reverted.
   - It also asks (should-fix) to squash the `fix(canary)` and `test(audit)` follow-up commits into their parents.
   - It also asks (should-fix) to keep the `src/` audit wiring in a separate commit from the deploy and canary tooling.
2. **pruner:** remove repeated statements.
   - `DEPLOYMENT.md` states the arming gate three times and the refresh-failure classification in four places.
   - Several code comments only restate the code next to them.
   - The JSDoc at the top of `test/mcp-audit-http.test.ts` repeats the two test names.
   - The PR body is 384 words and should come in under 300.

**Also worth fixing (should-fix, not blocking)**
- **assessor:** in `runRootCanary`, the cleanup of stale canaries (`dismissClaudeAgent`/`remove`) never checks for an error result. A refused cleanup is therefore reported as done. The fix is to wrap those calls in `textOf(...)`, as `cleanUpRootCanary` already does.

Nothing changed in the garden repo, so there was no commit.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr186-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1059673 cached reads)
- Output: 6032 tokens
- Cost: $0.8439666
- Wall-clock: 1208s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
