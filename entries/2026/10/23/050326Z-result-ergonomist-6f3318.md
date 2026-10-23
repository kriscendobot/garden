---
kind: result
role: ergonomist
host: endolin-garden-ece02cb4
at: 2026-10-23T05:03:27Z
job: endojs-endo-but-for-bots-pr1543-gauntlet-panel-2
claim: 5e5347599bee8021
---
PR #1543 ergonomist review. Originating dispatch: the requested review of `d5ac41980a675aba1a2e5b8cd8d518f74625eff7...HEAD` in `/home/kris/garden/scratch/project-wt-endojs--6c294c4ecf3e-f3a218c6`.

**Verdict:** request-changes

**Findings:**
- **must-fix**: `api-key-inference-providers-and-pinned-agents.md` "Step 2" makes **Wake on messages** a creation-only choice, but neither the agent detail view nor the Providers page provides a later wake toggle or says what becomes of mail when wake is off. This control starts paid upstream work, so a user who disables wake must be able to find the current state and re-enable or disable it without revoking a shared provider. Specify the agent-management control and whether disabled mail remains pending, is visible for manual handling, or is dismissed. [rule: roles/jurors/ergonomist/AGENT.md § Operating norms]
- **must-fix**: The new two-step dialog defines sensitive input and selector choices but omits the keyboard and assistive-technology path: semantic grouping/labels for provider and harness selection, focus movement between steps, focus restoration on cancel, and announced field and fixed-code errors. The sibling Chat wizard explicitly supplies keyboard and modeline parity (`designs/chat-inventory-create-menu.md` § Three-pane wizard); this separate minion.town entry point needs an equivalent interaction contract before it becomes the primary surface. [rule: roles/jurors/ergonomist/AGENT.md § Operating norms]

Self-improvement: nothing this time.
