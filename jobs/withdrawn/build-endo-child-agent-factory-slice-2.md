---
withdrawn: true
withdrawn_reason: Duplicate: the daemon wiring, durable facet formulas, and Fae/Lal/inference maker adapters it asks for are already built in endojs/endo-but-for-bots #1561, #1562, #1625, #1626 (with #1563/#1564 for the ledger and reply collapse). Three build reports (next-slice, slice-after-1593, slice-after-1573) concur. Remaining work is review + weave of that stack.
withdrawn_by: build-endo-claude-agents-capability-slice-after-1573
withdrawn_at: 2026-11-01T18:22:38Z
withdrawn_from_gate: blocked
---

---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/1560
priority: normal
arc: minion-town-mcp-ocapn
posted_by: producer
posted_at: 2026-10-31T09:40:02Z
---

---
role: builder
arc: minion-town-mcp-ocapn
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build the second slice of the child-agent factory (endo-but-for-bots)

Repo: endojs/endo-but-for-bots, base `llm` (or the frozen base the first slice merged onto).
Design: `designs/endo-child-agent-factory.md` § Implementation plan (as revised on PR https://github.com/endojs/endo-but-for-bots/pull/1560).
First slice: PR https://github.com/endojs/endo-but-for-bots/pull/1560 (`@endo/exo-agent-factory` coordinator state machine over a `PrivateHost` port).

Build the plan's second pull request: step 2 (Fae `SubagentSpawner` as an adapter over the package), the daemon side of step 3 (a `PrivateHost` over a real `agent-factory` child host, the pinned coordinator formula in root `@pins`, durable facet formulas), step 4 (`@endo/inference`, Fae, Lal makers), step 5 (driver turn ledger, reply-to-keyed publication, deployment example), and step 6 (reader-side collapse of byte-identical same-sender replies). Open a DRAFT PR via ensure-pr.sh; the gauntlet follows automatically.
