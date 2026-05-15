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
---

> Abstract: The Chat application currently uses a hardcoded light color scheme; this design parameterizes all colors in `index.css` using CSS custom properties, introduces a dark mode scheme derived from the endojs.org palette, respects the user's system preference via `prefers-color-scheme`, and preserves the existing light theme as the default. The current-state inventory surfaces ~17 existing `:root` semantic custom properties (`--bg-primary`, `--text-primary`, `--accent-primary`, `--border-color`, three `--shadow-*` levels, and several `--bubble-*`) plus approximately **94 hardcoded color values outside of `:root`** that the design enumerates across 8 semantic categories (Error/Danger, Success, Message Bubbles, Code Syntax Highlighting, Tooltips and Popups, Badges and Indicators, Backdrops, Button Colors, Active Conversation Highlight). The inventory becomes the basis for **~25 new semantic variables** (`--danger`, `--danger-hover`, `--danger-bg`, `--danger-border`, `--success`, `--success-hover`, six `--code-*`, `--tooltip-bg`, `--tooltip-fg`, `--backdrop`, plus relocations of the bubble variables into scheme-aware `:root` defaults).

## Goals

1. Parameterize all colors in `index.css` using CSS custom properties.
2. Introduce a dark mode scheme derived from the endojs.org palette.
3. Respect the user's system preference via `prefers-color-scheme`.
4. Preserve the existing light theme as the default.

## Existing `:root` Custom Properties (light theme)

| Variable | Value | Semantic Role |
|---|---|---|
| `--bg-primary` | `#ffffff` | Main content background |
| `--bg-secondary` | `#f8f9fa` | Chat bar, headers, hints |
| `--bg-sidebar` | `#f1f3f5` | Inventory sidebar background |
| `--bg-hover` | `#e9ecef` | Hover state backgrounds |
| `--bg-active` | `#dee2e6` | Active/pressed backgrounds, gutter |
| `--text-primary` | `#212529` | Primary body text |
| `--text-secondary` | `#495057` | Secondary labels, descriptions |
| `--text-muted` | `#868e96` | Placeholders, hints, separators |
| `--accent-primary` | `#228be6` | Links, focus rings, interactive elements |
| `--accent-hover` | `#1c7ed6` | Accent hover state |
| `--accent-light` | `#e7f5ff` | Accent backgrounds, token chips, focus glow |
| `--border-color` | `#dee2e6` | Primary borders |
| `--border-light` | `#e9ecef` | Subtle borders between sections |
| `--shadow-sm` | `0 1px 2px rgba(0,0,0,0.05)` | Subtle elevation |
| `--shadow-md` | `0 4px 6px rgba(0,0,0,0.07)` | Medium elevation |
| `--shadow-lg` | `0 10px 25px rgba(0,0,0,0.1)` | Modals, dropdowns |

## The 8 hardcoded-color categories

The hardcoded-color inventory partitions into 8 semantic categories. Each category lists the hardcoded values with occurrence counts and usages, then proposes new semantic variables.

### Error / Danger (reds)

Roughly 22 occurrences across `#e03131`, `#c92a2a`, `#e53e3e`, `#dc2626`, `#b91c1c`, `#fff5f5`, `#ffc9c9`, `#fca5a5`, `rgba(224,49,49,0.1)`, `rgba(224,49,49,0.3)`. Proposed: `--danger`, `--danger-hover`, `--danger-bg`, `--danger-border`.

### Success (greens)

4 occurrences across `#059669`, `#37b24d`. Proposed: `--success`, `--success-hover`.

### Message Bubbles

Bubbles define local `--bubble-*` custom properties but set them to hardcoded values. Proposed: move received-message defaults into `:root` as scheme-aware properties; sent-message overrides remain on saturated blue regardless of scheme.

### Code Syntax Highlighting

6 hardcoded values for keywords (`#cf222e`), strings (`#0a3069`), comments (`#6e7781`), numbers (`#0550ae`), code-fence background (`#e9ecef`), code-fence text (`#24292f`). Proposed: `--code-bg`, `--code-fg`, `--code-keyword`, `--code-string`, `--code-comment`, `--code-number`.

### Tooltips and Popups

`#2d3748` and `#f7fafc`. Proposed: `--tooltip-bg`, `--tooltip-fg`.

### Badges and Indicators

`#000000` (badge bg) and `#ffffff` (badge text). Proposed: reuse `--tooltip-bg` / `--tooltip-fg` (same visual role: small overlays on contrasting backgrounds).

### Backdrops

`rgba(0,0,0,0.4)` (3x modal) and `rgba(0,0,0,0.5)` (2x eval/counter-proposal). Proposed: `--backdrop`.

### Button Colors and Active Conversation Highlight

Most button colors map to existing `--accent-primary` / `--accent-hover`. Active-conversation-highlight (`.pet-item-wrapper.active-conversation`) uses `white` and `rgba(255,255,255,...)` because the row has a blue accent background — these remain hardcoded because they are designed against `--accent-primary`, the same exception applied to sent-message bubbles.

## Pattern: scheme-aware tokens with intentional exceptions

The design is a worked example of the **scheme-aware tokens with intentional exceptions** discipline:

- *Default policy*: every hardcoded color outside `:root` is replaced with a `var(--*)` that varies by scheme.
- *Intentional exceptions*: elements rendered on saturated `--accent-primary` backgrounds (sent-message bubbles, active-conversation rows) keep hardcoded `white`/`rgba(255,255,255,...)` because they are designed against the accent, not against the page background. The exception is recorded inline in the design and re-asserted in [[endo-but-for-bots--llm-designs-chat-per-space-color-scheme--scheme-values-and-css-application]].

The discipline keeps `index.css` searchable: any hardcoded color that survived the migration is documented as an intentional exception, so a future audit can grep for hex literals and treat each survivor as either a regression or a documented exception. See [[sentinel-with-rationale]] for the parallel pattern in other parts of the system.

Source: [designs/chat-color-schemes.md](https://github.com/endojs/endo-but-for-bots/blob/4e7e623ef841f5d23f985bc57386195c93a709af/designs/chat-color-schemes.md) at commit `4e7e623e`.
