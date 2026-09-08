Inbox empty. The design is complete: a draft, design-only PR is open, and its design-panel gauntlet auto-stages from the completion machinery.

**Completion report**

Designed the stdio MCP server for arc `kriscendobot/garden#89` item 5, on `endojs/endo-but-for-bots` base `llm`.

**Create-or-evolve decision:** wrote a **new** document, `designs/endo-guest-stdio-mcp.md`. Justified in one paragraph in the doc: every neighbouring MCP design is HTTP-plus-OAuth and stops short of stdio (`endo-gateway-mcp` DD6 puts stdio out of scope; `daemon-agent-tools` owns capabilities not a transport; the minion.town trio is the browser OAuth deployment), and `endo-claude` is the client side that explicitly names this server (a claude-spawned adapter plus a harness-owned facet broker) as an out-of-scope "adapter-implementation prerequisite." So there was a real, named gap. The new doc fills it and composes with the `@endo/agent-tools` MCP-adapter projection rather than reinventing it.

**What the design covers (each required section):**
- **Scoping by formula identifier (centerpiece):** per-process isolation, not per-bearer. The harness-owned broker validates the 64-hex id and resolves it to one facet at construction, holds the attenuated CapTP connection with the raw fd never inherited into the confined tree; the id never rides the wire. Stated as a structural chain of why a compromised Claude reaches no other guest (no socket fd, no id, no bearer, adapter reaches only its one broker).
- **Tool catalog derivation:** one pinned pre-pruned `tools/list` snapshot drives both the server-side dispatch check (boundary) and the client `--allowedTools` (belt), honoring `endo-claude` DD2; `tools.listChanged` false; mid-session grant change deliberately not honored (fresh process per call picks it up next spawn), with the reused-broker wrinkle surfaced as an open question.
- **Stdio transport:** newline-delimited JSON-RPC framing (stderr never protocol, the endopi split-on-`\n`-only lesson), adapter (per call, claude-spawned) vs broker (per guest, harness-owned) topology, and child-death behavior for both processes.
- **Fail-closed:** empty/underivable/all-pruned catalog is a construction throw; unknown/malformed request is a JSON-RPC error; never an unscoped fallback.
- **Naming:** `mcp__<server>__<tool>` survives `--tools ""`; fixed `endo` server label; flat interface-native tool names honoring the reconciled namespace and the duplicate/case-confusable/malformed guard and reserved names (`submit`, `invite`, `cancelInvite`, `request`, `identify`, `listReminders`, `cancelReminder`) from `kriscendobot/minion.town#79`.

Four maintainer-facing open questions (manifest home, reused-broker re-pin, `logging` capability, broker code-home split).

**Verification (real-execution evidence):** mermaid diagram parses (`mm-1.mmd OK flowchart-v2` via the parse-only validator); README's two mermaid blocks still parse after my graph edit (`OK flowchart-v2`, `OK gantt`); house-style grep clean (no em-dashes, Latin shorthand, or non-typist code points after fixes). Registered the design in `designs/README.md` per conventions: summary-table row, dependency-graph node + edges (`eat --> estdio --> eclaude`), M3 milestone detail row, and a size-estimate row.

**PR:** opened draft, design-only PR **endojs/endo-but-for-bots#1226** (base `llm`, head `design/endo-guest-stdio-mcp`), confirmed `isDraft: true`, files limited to `designs/README.md` and `designs/endo-guest-stdio-mcp.md`. Left draft as required; its design-panel gauntlet auto-stages from the completion machinery.

**Follow-ups:** none blocking. The four open questions are for design review; if accepted, the build is the `@endo/agent-tools` MCP-adapter implementation plus the two-process seam (already counted under `endo-agent-tools`/`endo-claude`).

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-endo-guest-stdio-mcp.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (4872928 cached reads)
- Output: 34558 tokens
- Cost: $5.2377519999999995
- Wall-clock: 537s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
