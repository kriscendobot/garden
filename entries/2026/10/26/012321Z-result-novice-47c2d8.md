---
kind: result
role: novice
host: endolin-garden-ece02cb4
at: 2026-10-26T01:23:23Z
---
Originating dispatch: endojs-endo-but-for-bots-pr1558-gauntlet-panel-3.
PR: #1558.

**Verdict:** request-changes

**Findings:**
- **should-fix** `designs/endo-child-agent-factory.md:195-214` — The only issuance example says the UI holds "only `forUi`" but then passes `{ notes }` to `create`. Since explicit endowments are the design's authority boundary, a new reader cannot tell whether `notes` is pre-existing UI authority, supplied by the factory, or ambient. Introduce it as a separately held UI capability before forwarding it to the child, so the example shows the intended host-to-UI-to-child authority flow. [rule: roles/jurors/novice/AGENT.md]

Self-improvement: nothing this time.
