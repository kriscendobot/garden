# Topic: chat-ui

> Abstract: Familiar Chat — the web-based keyboard-first UI for the Endo daemon. Command-driven (slash commands + `@`-prefixed pet-name token chips + structured forms), with a modeline showing available keyboard actions. Distinct from `tooling` (which collects general developer-facing tooling) and from `agent-conventions` (which collects repository-internal agent rules); this topic covers user-interface invariants, principles, and component designs for the chat client specifically. Will populate as the ~20-file chat-design backlog is ingested.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo-but-for-bots--llm-designs-chat-components--css-variables-and-security](../sections/endo-but-for-bots--llm-designs-chat-components--css-variables-and-security.md) | endo-but-for-bots designs/chat-components.md | 13 CSS custom-property theme tokens (`--accent-primary`, `--bg-*`, `--radius-*`, `--shadow-*`, `--sidebar-width`); 7 security claims (Monaco sandbox, eval-grant flow, daemon-mediated pet-name resolution); one soft item flagged: counter-proposal endowments rely on user review. |
| [endo-but-for-bots--llm-designs-chat-components--file-structure-and-component-map](../sections/endo-but-for-bots--llm-designs-chat-components--file-structure-and-component-map.md) | endo-but-for-bots designs/chat-components.md | Per-concern package layout (Core / UI / Utilities / Command system / Autocomplete / Eval / Message / Spaces / Other); 9 high-level component responsibilities (chat.js orchestrator; chat-bar carries the modeline; inventory does pet-name expansion; etc.). |
| [endo-but-for-bots--llm-designs-chat-components--inventory-and-messages](../sections/endo-but-for-bots--llm-designs-chat-components--inventory-and-messages.md) | endo-but-for-bots designs/chat-components.md | Inventory panel with disclosure-triangle expansion + SPECIAL toggle; wrapped powers for sub-directory scoping + subscription cleanup. Three message kinds: package (markdown + token chips), eval-proposal (proposer + source + endowments table + Grant/Counter/Reject), request (description + Resolve/Reject). |
| [endo-but-for-bots--llm-designs-chat-components--profile-system-and-error-handling](../sections/endo-but-for-bots--llm-designs-chat-components--profile-system-and-error-handling.md) | endo-but-for-bots designs/chat-components.md | Profile breadcrumb + `/enter` + `/exit` + per-profile inventory; surfaces the daemon's `@self`/`@host` special names. Errors render as red speech-bubble pointers above the source row; clear on next input. |
| [endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants](../sections/endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants.md) | endo-but-for-bots designs/chat-invariants.md | **Six MUST-hold UI invariants** — modeline completeness; keyboard-manual parity; state visibility; escape consistency; progressive complexity; uniform autocomplete list navigation (Page Up/Down by *visible rows − 1* so motion is visible). Violations are bugs. |
| [endo-but-for-bots--llm-designs-chat-invariants--principles](../sections/endo-but-for-bots--llm-designs-chat-invariants--principles.md) | endo-but-for-bots designs/chat-invariants.md | **Six design principles** (aesthetic guidelines, not contracts): structured input over text parsing; keyboard-first navigation; progressive disclosure; visual feedback; contextual autocomplete; platform-appropriate modifier keys. |

## See also

- [`agent-conventions`](agent-conventions.md): the chat invariants are conventions for the chat-client codebase, in the same spirit as the agent-conventions topic's repository-side rules.
- [`tooling`](tooling.md): chat is the daemon's user-facing tool; tooling collects developer-facing tools that may also have UI conventions.
- [`daemon`](daemon.md): everything chat does ultimately routes through the daemon's host/agent APIs.
