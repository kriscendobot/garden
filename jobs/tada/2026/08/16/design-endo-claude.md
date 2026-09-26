Inbox empty, PR #995 confirmed draft against `llm`. The design is complete, reviewed against companion designs and the peer correction, and the draft PR is the review surface. The auto-gauntlet machinery will stage the design panel on completion since I'm naming the draft PR and leaving it draft.

Self-improvement: nothing this time (the existing designer norms and skills covered this job cleanly; the mid-job peer correction about grounding against merged prior art rather than quoting an older doc's "does not exist yet" framing is a designer-craft point already covered by library-lookup's "reference rather than reinvent prior art" mandate).

---

## Completion report

**Deliverable:** `designs/endo-claude.md` in `endojs/endo-but-for-bots` @ `llm`, in **draft PR https://github.com/endojs/endo-but-for-bots/pull/995** (base `llm`, design-only diff: the new design file + `designs/README.md` sync).

**What the design specifies (`@endo/claude`):** an Endo package giving a guest LLM inference **from a Claude subscription**, via a hermetically-sandboxed `claude -p` whose only capability surface is one specified guest formula's granted facet, projected as MCP tools.
- Header makes the **direction distinction** explicit and cites both minion.town companions by full URL: this is the inverse of `mcp-endo-guest.md` / `mcp-daemon-guest-tools.md` ("the guest thinks with Claude," not "Claude drives a guest from outside").
- Grounds the confinement in the confirmed CLI mechanics: `--bare` as load-bearing (tool-permission flags do not suppress CLAUDE.md/hooks/settings/MCP auto-discovery), `--strict-mcp-config`, `--setting-sources ""`, never `--resume`/`--continue`, deny-all-built-ins, and the **`mcp__*`-is-silently-ignored** trap named as a concrete "compose the allow-list from the facet's method set" build step.
- Covers **local** (stdio shim preferred, loopback HTTP alternative) and **remote** (bearer=formula-id over streamable HTTP, not the browser OAuth stack) deployment; **multiplexing by guest id** (one endpoint discriminated by bearer); and **subscription pooling** (reusing `@endo/claude-sandbox`'s `ClaudeCredentials` caplet, borrowing the garden's own N-accounts allocation pattern).
- Distinguishes the sibling `@endo/claude-sandbox` (OS-sandbox + workspace confinement) from this package's tool-surface confinement, and notes they compose.
- Five `## Open questions` surface genuine ambiguity; a minion.town deployment companion is named as a **follow-on design job**, not written here.

**Mid-job peer correction incorporated:** revised the facet-to-MCP section to ground on the **merged** `endo-gateway-mcp` (PR #376) and the existing `@endo/agent-tools` MCP adapter **stub** (`packages/agent-tools/src/adapters/mcp.js`) rather than treating `@endo/mcp` as nonexistent, and adopted the project's stated **stdio local-shim** transport as the preferred local shape. Named `design-endo-claude-mcp-groundwork` as the tracking prerequisite job.

**Verification:** all four mermaid fences (2 in the design, plus the README flowchart + gantt I touched) parse via `mermaid.parse()`; authored prose checked clean of em-dashes, arrow/ellipsis code points, and Latin shorthand. `designs/README.md` synced per project convention (summary row, M6 constituent note, dependency-graph node/edge, per-design estimate, totals 151→152, layered note).

**Follow-ups:** (1) `design-endo-claude-mcp-groundwork` (peer-posted) owns implementing the MCP adapter stub + hosting seam; (2) the minion.town deployment companion design, to be filed once this package design is accepted. The design PR is left draft; its design-panel gauntlet arms automatically from this report.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-endo-claude.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 102 tokens (6950294 cached reads)
- Output: 46921 tokens
- Cost: $6.212889
- Wall-clock: 691s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
