---
title: High-contrast adjustments (vs. the base scheme)
source: designs/chat-high-contrast-mode.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 7706eefb443675838806fea0d209d7bb1359df83
source_date: 2026-02-28
source_authors: [Kris Kowal]
topics: [chat-ui, patterns]
status: current
parent: endo-but-for-bots--llm-designs-chat-high-contrast-mode--scheme-extension-and-css-structure
---

| Property | Standard | High Contrast |
|---|---|---|
| Borders | 1px subtle gray | 2px solid, higher contrast |
| Text contrast ratio | >= 4.5:1 (AA) | >= 7:1 (AAA) |
| Focus rings | 3px accent glow | 3px solid outline + offset |
| Muted text | Low contrast | Medium contrast (still distinguishable) |
| Hover states | Background tint | Background tint + border |
| Shadows | Soft blurs | Replaced with solid borders |
| Backdrop | Semi-transparent | Higher opacity |

The most architecturally interesting row is **shadows → borders**. In standard schemes, elevation is conveyed by soft `box-shadow` blurs. In high-contrast, **all `box-shadow` variables are set to `none`** and elevated elements rely on `--border-color` and `--border-light` instead. This is a *substitution of channel*: the visual cue (this element is elevated) is preserved, but the rendering channel changes (soft blur → hard border). Users with low vision read the border channel reliably where they would miss the blur channel.

Source: [designs/chat-high-contrast-mode.md](https://github.com/endojs/endo-but-for-bots/blob/7706eefb443675838806fea0d209d7bb1359df83/designs/chat-high-contrast-mode.md) at commit `7706eefb`.
