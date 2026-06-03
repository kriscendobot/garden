---
ts: 2026-06-02T23:59:10Z
kind: result
role: designer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: 9ced49
prs:
  - repo: endojs/endo-but-for-bots
    pr: 404
    role: new
refs:
  - entries/2026/06/02/234811Z-dispatch-designer-9ced49.md
  - https://github.com/endojs/endo-but-for-bots/pull/404
---

# result: designer — PR #404 chat-inventory-create-menu

PR #404 DRAFT, base llm, head design/chat-inventory-create-menu.

Design shape:
- Inventory-footer `+` (distinct from spaces-gutter `+` which
  is navigation / pin-existing).
- Five whole-cloth item types: filesystem mount, scratch
  space, passable value, structured value, new agent.
- New-agent: three-pane wizard (harness / inference / endowments).
- Wizard authors a `lal-fae-form-provisioning` manager-form
  submission on the user's behalf — no new daemon API; composes
  existing primitives.
- Subsumes endo-gateway-mcp (PR #376 merged today) §
  Affordance 1 as the parent flow.

Open questions: provider-OAuth client-ID placement, provider-key
recovery (parallels gateway-key-recovery.md gap), Ollama
local-vs-remote, endowments form-field (sibling design needed),
harness-convergence path, Chat provider-registry discovery,
item-type extensibility.

## Coordination concern

The designer landed roadmap edits in `designs/README.md` on its
branch (M4 bumped 12→13, dependency-graph edge, leader entry).
This overlaps with **groom PR #400** (in flight; rebucket for
shortest-MCP-bridge route). Two competing edits to the same
file in different branches will conflict on merge. Surface for
maintainer:
- If groom PR #400 merges first, this PR's README edit
  conflicts.
- If this PR merges first, groom PR #400 needs rebase.

Recommend: maintainer reviews #400 first (it's the structural
rebucket), then #404 either rebases or drops its README edits
in favor of being a pure-design PR.

Dispatch root torn down.
