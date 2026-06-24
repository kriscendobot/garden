---
source: designs/chat-command-bar.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
ingested: 2026-05-15
ingested_by: scholar
section_count: 4
status: current
notes: **Status: Complete** upstream. Largest of the chat designs ingested so far (255 lines). The *operational unfolding* of the chat-invariants' *modeline completeness* + *keyboard-manual parity* invariants — converts the abstract rules into a state-by-state, key-by-key specification. Same upstream commit as chat-invariants, chat-components, and chat-spaces-gutter — extracted together when `packages/chat/DESIGN.md` was split.
---

> Abstract: The chat command bar's complete operational spec — 9 distinct states each with modeline + keyboard table + manual equivalents (Empty/Send Mode; Token Autocomplete Visible; Token Only; Token + Message Text; Text Only; Command Selecting; Inline Command Form; Eval Command Inline; per-command variants). The value modal renders inspected values along two axes — has-ID / has-pet-names crossed with has-message-context / ephemeral — giving four title-bar shapes, with both message-context and pet-name chips allowed simultaneously. Eight typed field types (`petNamePath`, `petNamePaths`, `messageNumber`, `text`, `edgeName`, `locator`, `source`, `endowments`) — the chat client's *typed-input vocabulary* that lets the command system avoid text-parsing. Single-path autocomplete uses `.`-drilling (build path one segment per key); multi-path uses chip-composition with distinct `.` (drill) vs `Space` (fresh path) grammars. Nine command categories (Messaging / Execution / Storage / Connections / Workers / Agents / Profile / Bundles / System) covering ~20 commands with Unix-shell-style aliases. Inline-hint discipline: modeline shows command-bar state, autocomplete dropdowns show menu-navigation hints — *complement, not duplicate*. Three categories of acknowledged known gaps: modeline-coverage gaps (inline command forms), keyboard-manual-parity exceptions (Space-for-last-recipient, `:`-for-edge-name, both deliberate), and unimplemented affordances (command history; chip-× visibility).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [command-bar-states-and-modeline](../sections/endo-but-for-bots--llm-designs-chat-command-bar--command-bar-states-and-modeline.md) | chat-ui, agent-conventions | current |
| [value-modal-and-states](../sections/endo-but-for-bots--llm-designs-chat-command-bar--value-modal-and-states.md) | chat-ui | current |
| [field-types-and-autocomplete-mechanics](../sections/endo-but-for-bots--llm-designs-chat-command-bar--field-types-and-autocomplete-mechanics.md) | chat-ui, agent-conventions | current |
| [command-categories-and-known-gaps](../sections/endo-but-for-bots--llm-designs-chat-command-bar--command-categories-and-known-gaps.md) | chat-ui, agent-conventions | current |

## See also

- `chat-invariants.md` — the invariants this design operationalizes
- `chat-components.md` — package-level architecture; `chat-bar-component.js`, the autocomplete components, and the command-system files referenced throughout this design
- `chat-spaces-gutter.md` / `chat-spaces-home.md` — siblings; the `/enter` and `/exit` commands listed under the *Profile* category are the chat-bar surface for the same affordance the spaces gutter provides
- `packages/chat/DESIGN.md` — the source this document was extracted from
