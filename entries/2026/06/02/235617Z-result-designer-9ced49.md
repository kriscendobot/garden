---
ts: 2026-06-02T23:56:17Z
kind: result
role: designer
repo: endojs/endo-but-for-bots
project: endo
---

Designed `chat-inventory-create-menu` per the maintainer's prompt.
Single design file `designs/chat-inventory-create-menu.md` plus
README incorporations (summary row, milestone-list row, M4 list /
weeks bump from 12 / 8-11w / 10-13w to 13 / 9-12w / 11-14w,
dependency-graph edge from `dmount` to a new `cicmenu` node, leader
entry).

Design shape:
the inventory footer carries a `+` button distinct from the spaces
gutter's existing `+` (gutter = navigation / pin-existing; inventory
= mint-new), a pop-over menu enumerates five whole-cloth item types
(filesystem mount, scratch space, passable value, structured value,
new agent), and the new-agent flow is a three-pane wizard for
harness / inference-source / endowments. The wizard authors a
[lal-fae-form-provisioning](../../../../../../../home/kris/dispatches/designer--9ced49/project/designs/lal-fae-form-provisioning.md)
manager-form submission on the user's behalf rather than
introducing a new daemon API; the design composes existing
primitives only.

Reconciled with [endo-gateway-mcp](../../../../../../../home/kris/dispatches/designer--9ced49/project/designs/endo-gateway-mcp.md)
(merged today, PR #376): this design is the parent affordance,
gateway-mcp's `+ Add agent` Chat surface plugs into the wizard. An
edit to `endo-gateway-mcp.md` to cross-link is a follow-up, not a
blocker.

Branch `design/chat-inventory-create-menu` pushed; DRAFT PR
[#404](https://github.com/endojs/endo-but-for-bots/pull/404) opened
against `llm`.

Open questions surfaced:
provider OAuth client-ID placement (defer to endopi),
provider-key recovery (parallels gateway-key-recovery gap),
Ollama local-vs-remote reconciliation with "no URLs" framing,
endowments form field on the manager's form (Phase 5 dependency),
harness convergence-path coordination,
Chat-side discovery of the daemon provider registry,
item-type extensibility.

Re-polled `gh pr list --search "chat-inventory in:title"` after push;
no slug collision (existing matches are `feat/chat-inventory-dnd` PRs
#131 / #41).

Self-improvement: nothing this time.
