---
title: CSS custom-property theme tokens
source: designs/chat-components.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, capability-security]
status: current
parent: endo-but-for-bots--llm-designs-chat-components--css-variables-and-security
---

The UI uses CSS custom properties as the single source of truth for
visual theming:

| Token | Purpose |
|---|---|
| `--accent-primary` | Primary action color |
| `--accent-light` | Light accent for backgrounds |
| `--text-primary`, `--text-muted` | Text colors |
| `--bg-primary`, `--bg-secondary` | Background colors |
| `--border-color`, `--border-light` | Border colors |
| `--radius-sm`, `--radius-md`, `--radius-lg` | Border radii |
| `--shadow-sm`, `--shadow-md`, `--shadow-lg` | Box shadows |
| `--transition-fast` | Animation timing |
| `--sidebar-width` | Inventory panel width (resizable) |

The token-table-as-design-system pattern is the chat-UI version of
the producer-typed-shape-consumer-rendering discipline applied to
CSS — components author against tokens; the theme (or per-space
color scheme; see `scheme-picker.js`) supplies the values. The
sibling `chat-per-space-color-scheme.md` design is where the per-
space theme variations live and is not yet ingested.

The `--sidebar-width` token being resizable is the only token here
that is *user-visible-state* rather than pure theme — it persists
the user's sidebar choice.
