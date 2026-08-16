The revision is landed. PR #995 head is now my commit `60e6c5bc`, still draft against `llm`.

## Completion report

**Job:** `design-endo-claude-mcp-groundwork` — the revision cycle folding the four peer-correction points into `designs/endo-claude.md` (`endojs/endo-but-for-bots` @ `llm`, draft **PR #995**).

**Re-derived state on this fresh worktree:** The predecessor `design-endo-claude` job completed (`tada` present) and produced PR #995 on branch `design/endo-claude`. It had already committed a mid-job fold ("ground MCP bridge on merged endo-gateway-mcp + stdio shim") that fully covered **points 1 and 2** (bearer-is-formula-id auth as the default remote shape with OAuth demoted to a minion.town variant; the stdio local-shim cited from `endo-gateway-mcp` as a sanctioned pattern, with stdio named as the local transport and why). Auditing against the source designs, I found **points 3 and 4 genuinely missing** — the design had zero mentions of Lal, `daemon-agent-tools`, capability-scoped tooling, or an explicit sequencing recommendation.

**What I changed** (one commit, +96 lines, `designs/endo-claude.md`):
- **Point 3 — new subsection "Which tool surface the catalog projects (a carried-over limitation)":** states the catalog/`executeTool` projection is lifted from `packages/lal/agent.js` into `@endo/agent-tools` and today covers only Lal's **static** namespace/mail/evaluate tools; names the limitation from `endo-gateway-mcp` Open Questions item 1 (*Capability-scoped tools timing*); makes `daemon-agent-tools` an explicit hard dependency for genuine per-guest, capability-scoped `--allowedTools`, and says the build targets whichever surface is live at build time.
- **Point 4 — new section "Build sequencing against the MCP bridge":** lays out options (a) wait on `endo-gateway-mcp`, (b) local stdio shim first, (c) both phased; **recommends (c) with (b) as the concrete v1** (shim needs no gateway `/mcp`, tightest confinement, shallowest dependency, stable harness contract across v1→v2), grounded in the verified groom **PR #400** Milestone B ordering (P0 gateway completion → P1 MCP termination → P2 AWS), where the remote path's P1 dependency sits behind a mostly-open P0.

**Verification:** file re-checked clean of non-ASCII prose, em-dashes, `§`, Unicode arrows, and Latin shorthand (I fixed several I had introduced); no mermaid fences added, so the four previously-validated fences are unchanged. Pushed via rebase CAS to `design/endo-claude`; PR #995 head is now `60e6c5bc`, still draft against `llm`.

**Follow-ups:** none new — the design's existing follow-ons stand (implement the `@endo/agent-tools` MCP adapter stub + hosting seam; the minion.town deployment companion design once this package design is accepted). PR stays draft as the review surface.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-endo-claude-mcp-groundwork.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s) (2 unmetered)
- Input: 61 tokens (2175178 cached reads)
- Output: 22345 tokens
- Cost: $2.343377 (2 engagement(s) unpriced)
- Wall-clock: 348s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
