---
title: The 8 hardcoded-color categories
source: designs/chat-color-schemes.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 4e7e623ef841f5d23f985bc57386195c93a709af
source_date: 2026-02-28
source_authors: [Kris Kowal]
topics: [chat-ui, patterns]
status: current
parent: endo-but-for-bots--llm-designs-chat-color-schemes--motivation-and-current-state
---

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

Source: [designs/chat-color-schemes.md](https://github.com/endojs/endo-but-for-bots/blob/4e7e623ef841f5d23f985bc57386195c93a709af/designs/chat-color-schemes.md) at commit `4e7e623e`.
