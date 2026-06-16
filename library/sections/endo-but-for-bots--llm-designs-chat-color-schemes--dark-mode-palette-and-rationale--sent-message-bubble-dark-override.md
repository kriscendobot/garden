---
title: Sent-message bubble dark override
source: designs/chat-color-schemes.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 4e7e623ef841f5d23f985bc57386195c93a709af
source_date: 2026-02-28
source_authors: [Kris Kowal]
topics: [chat-ui, patterns]
status: current
parent: endo-but-for-bots--llm-designs-chat-color-schemes--dark-mode-palette-and-rationale
---

```css
@media (prefers-color-scheme: dark) {
  .message.sent {
    --bubble-bg: #BB2D40;
    --bubble-border: #9e2436;
    --bubble-chip-bg: rgba(255, 255, 255, 0.2);
  }
}
```

Brand burgundy preserves the *light-on-saturated* readability pattern in dark mode. The light-mode sent-message blue (`#3b82f6`) shifts to brand burgundy; the **white text on saturated background** discipline is preserved across both schemes.

Source: [designs/chat-color-schemes.md](https://github.com/endojs/endo-but-for-bots/blob/4e7e623ef841f5d23f985bc57386195c93a709af/designs/chat-color-schemes.md) at commit `4e7e623e`.
