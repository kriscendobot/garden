**Viability report: endojs/endo-but-for-bots#1336** (`feat(guest-mcp-stdio): stdio MCP server scoped to one guest's tool surface`)

The PR is not superseded and its premise still holds, so the gauntlet can begin. This check spent no clean, panel, fix or CI budget.

**PR state:** OPEN and still a draft. Head `build/endo-guest-stdio-mcp` @ `3c3d8cfd3c`. Base `llm-6726b0f` @ `6726b0fba2`.

Deciding question: Is `origin/llm` still missing the stdio MCP server described in the merged design `designs/endo-guest-stdio-mcp.md` (design PR #1226), and is that design still the intended way forward, so that #1336 is still the implementation the maintainer wants?

Evidence:
- **The work is not on the base.** `origin/llm` HEAD is `6726b0fba2`, which is exactly this PR's base (the #1226 design merge). No newer commits have landed on `llm` since.
- **The adapter is still a stub.** `packages/agent-tools/src/adapters/mcp.js` on `llm` is still `export {};` ("Planned adapter shape only").
- **No competing package exists.** Neither `packages/guest-mcp-stdio` nor `packages/agent-mcp-stdio` exists on `llm`.
- **No competing PR exists.** A PR search for "mcp stdio" finds only #1226 (the design, merged) and #1336 (this PR).
- **The maintainer is actively backing this PR.** kriskowal's review 5307103246 on 2026-09-24 asked for changes to this PR: rename the package to `@endo/agent-mcp-stdio`, use `makeExo`/`makePromiseKit`, audit the tool surface, and more. The fixer handled them in `7d3cf4eb7f` plus a separate yarn.lock commit, `3c3d8cfd3c`. At 20:49Z kriskowal commented "Please run a gauntlet." So the motivating need (item 5 of arc kriscendobot/garden#89) is current, and the maintainer wants this PR to move forward.

Nothing was changed in the garden or on the PR.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1336-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (160573 cached reads)
- Output: 1788 tokens
- Cost: $0.40917059999999994
- Wall-clock: 26s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
