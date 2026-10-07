## Panel round 3: kriscendobot/minion.town PR #166, verdict must-fix

I ran one single-round code panel against head `15b146c`, using base `d750b09` (the PR's own fork point). All 34 seats finished without error. Three asked for changes (decomplector, breaker, typist); the others approved or left comments only. `panel.sh` exited 0 with disposition **must-fix**, and the run record is saved at `panel-runs/kriscendobot-minion.town-166/2d013f7153f3.md`.

**Must-fix (one item, decomplector):** the PR writes its own MCP client (`McpSession`, `parseMcpResponse`, `MCP_PROTOCOL_VERSIONS`, the DELETE `close()`). It should use `@modelcontextprotocol/sdk` instead, which the repo already depends on: `StreamableHTTPClientTransport` plus `Client`. Rounds 1 and 2 both patched this same client, and the panel's repeated-problem check flagged it. If the probe truly has to avoid dependencies, the PR body and `DEPLOYMENT.md` should say why.

**Should-fix:**
- **breaker:**
  - An MCP session leaks if setup fails after `initialize`.
  - The "durable guest" objective is never actually tested.
  - The CORS check sends no `Origin` header.
  - Failure reasons can include response header values.
- **typist:** a `→` (U+2192) arrow in `DEPLOYMENT.md` prose and `§` characters in `prod-objectives.mjs`.
- **archivist:** one should-fix.

**Review posted:** https://github.com/kriscendobot/minion.town/pull/166#pullrequestreview-5449658004
- It shows as COMMENTED, not request-changes, because GitHub won't let the bot request changes on its own PR. The header says `disposition: must-fix`.
- The full panel output was 89 KB, so I cut the review to about 62 K characters to fit GitHub's size limit. The 15 approve or comment-only seats left out are named at the end of the review, and their full text is in the run record.

Follow-ups: none from this stage. The fix-loop stage comes next.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr166-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (951362 cached reads)
- Output: 6009 tokens
- Cost: $0.7462444
- Wall-clock: 603s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
