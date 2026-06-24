---
title: Motivation, goals, and current-state inventory (94 hardcoded colors)
source: designs/chat-color-schemes.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 4e7e623ef841f5d23f985bc57386195c93a709af
source_date: 2026-02-28
source_authors: [Kris Kowal]
topics: [chat-ui, patterns]
status: current
kind: index
section_count: 4
---

> Abstract: The Chat application currently uses a hardcoded light color scheme; this design parameterizes all colors in `index.css` using CSS custom properties, introduces a dark mode scheme derived from the endojs.org palette, respects the user's system preference via `prefers-color-scheme`, and preserves the existing light theme as the default. The current-state inventory surfaces ~17 existing `:root` semantic custom properties (`--bg-primary`, `--text-primary`, `--accent-primary`, `--border-color`, three `--shadow-*` levels, and several `--bubble-*`) plus approximately **94 hardcoded color values outside of `:root`** that the design enumerates across 8 semantic categories (Error/Danger, Success, Message Bubbles, Code Syntax Highlighting, Tooltips and Popups, Badges and Indicators, Backdrops, Button Colors, Active Conversation Highlight). The inventory becomes the basis for **~25 new semantic variables** (`--danger`, `--danger-hover`, `--danger-bg`, `--danger-border`, `--success`, `--success-hover`, six `--code-*`, `--tooltip-bg`, `--tooltip-fg`, `--backdrop`, plus relocations of the bubble variables into scheme-aware `:root` defaults).

Sections:

- [Goals](endo-but-for-bots--llm-designs-chat-color-schemes--motivation-and-current-state--goals.md)
- [Existing `:root` Custom Properties (light theme)](endo-but-for-bots--llm-designs-chat-color-schemes--motivation-and-current-state--existing-root-custom-properties-light-theme.md)
- [The 8 hardcoded-color categories](endo-but-for-bots--llm-designs-chat-color-schemes--motivation-and-current-state--the-8-hardcoded-color-categories.md)
- [Pattern: scheme-aware tokens with intentional exceptions](endo-but-for-bots--llm-designs-chat-color-schemes--motivation-and-current-state--pattern-scheme-aware-tokens-with-intentional-exceptions.md)

Source: [designs/chat-color-schemes.md](https://github.com/endojs/endo-but-for-bots/blob/4e7e623ef841f5d23f985bc57386195c93a709af/designs/chat-color-schemes.md) at commit `4e7e623e`.
