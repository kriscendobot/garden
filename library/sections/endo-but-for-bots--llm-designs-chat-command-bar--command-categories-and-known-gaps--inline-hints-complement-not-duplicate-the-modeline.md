---
title: Inline hints — complement, not duplicate, the modeline
source: designs/chat-command-bar.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-chat-command-bar--command-categories-and-known-gaps
---

The modeline at the bottom of the chat bar shows the **overall
command-bar state**. Autocomplete dropdown menus contain their own
**inline hints** specific to menu navigation:

| Autocomplete | Inline hint |
|---|---|
| Token autocomplete | `↑↓ navigate · Tab/Enter select · : add label · Esc cancel` |
| Pet name path autocomplete | `↑↓ navigate · Tab select · . drill down · Esc cancel` |
| Pet name paths autocomplete | `↑↓ navigate · . drill down · Space add · Enter submit · Esc cancel` |

> *These inline hints complement, rather than duplicate, the
> modeline.*

The discipline is two-layered:

- **Modeline (bottom of chat bar):** what the *whole command bar*
  is doing.
- **Inline hint (inside dropdown menu):** what *the menu* is doing.

Both are visible simultaneously; together they cover every
keystroke the user can use. This is the modeline-completeness
invariant from
[[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]]
factored across two surfaces: each surface covers its own scope,
and the union covers everything.
