---
source: designs/chat-components.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
ingested: 2026-05-15
ingested_by: scholar
section_count: 4
status: current
notes: **Status: Complete** upstream. Sibling of [[endo-but-for-bots--llm-designs-chat-invariants]]; this is the *architecture* counterpart to invariants' *interface contract*. Extracted from `packages/chat/DESIGN.md`. Same commit SHA as chat-invariants (both files committed together at `3b031592`).
---

> Abstract: Familiar Chat's per-concern file layout (Core / UI / Utilities / Command system / Autocomplete / Eval / Message / Spaces / Other), result of *extracting* components from a previously-monolithic `chat.js`. Nine high-level component responsibilities (`chat.js` orchestrator; `chat-bar-component.js` carries the modeline; `inventory-component.js` does pet-name listing with expansion; etc.). The inventory panel uses disclosure-triangle expansion + a SPECIAL toggle for system names; expansion uses **wrapped powers** for sub-directory scoping and cleans up subscriptions on collapse. Three message kinds — package (sender + markdown + token chips), eval-proposal (proposer + source + endowments table + Grant/Counter/Reject buttons), request (description + Resolve/Reject inputs). Profile system uses breadcrumb + `/enter` + `/exit` + per-profile inventory views; surfaces the daemon's `@self`/`@host` special names. Errors render as red speech-bubble pointers above the source row and auto-clear on next input. CSS uses 13 custom-property tokens as the single source of truth for theming; `--sidebar-width` is the one token that persists user state. Seven security claims: Monaco-in-sandboxed-iframe; pet-name resolution via daemon APIs only; no direct FS access; WebSocket authenticated via daemon; eval proposals need explicit grant; guest evaluate gated by host approval; **counter-proposal endowments rely on user review** (the one soft item, explicitly flagged in the design as worth revisiting).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [file-structure-and-component-map](../sections/endo-but-for-bots--llm-designs-chat-components--file-structure-and-component-map.md) | chat-ui, agent-conventions | current |
| [inventory-and-messages](../sections/endo-but-for-bots--llm-designs-chat-components--inventory-and-messages.md) | chat-ui | current |
| [profile-system-and-error-handling](../sections/endo-but-for-bots--llm-designs-chat-components--profile-system-and-error-handling.md) | chat-ui, agent-conventions | current |
| [css-variables-and-security](../sections/endo-but-for-bots--llm-designs-chat-components--css-variables-and-security.md) | chat-ui, capability-security | current |

## See also

- `chat-invariants.md` — the invariants + principles counterpart (same upstream commit)
- `chat-edit-message-ui.md`, `chat-command-bar.md`, `chat-markdown-render.md`, `chat-spaces-*.md`, `chat-per-space-color-scheme.md` — sibling chat designs not yet ingested; many reference component names introduced here
- `packages/chat/DESIGN.md` — the source both this and chat-invariants were extracted from
