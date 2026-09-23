---
title: "Dark `:root` block"
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
  :root {
    /* Backgrounds - warm dark grays, not pure black */
    --bg-primary: #1a1b1e;
    --bg-secondary: #212226;
    --bg-sidebar: #18191c;
    --bg-hover: #2c2d31;
    --bg-active: #35363b;

    /* Text - off-whites for reduced glare */
    --text-primary: #e1e3e6;
    --text-secondary: #a1a5ab;
    --text-muted: #6b7078;

    /* Accent - brand burgundy from endojs.org */
    --accent-primary: #d4455a;
    --accent-hover: #BB2D40;
    --accent-light: rgba(187, 45, 64, 0.15);

    /* Borders */
    --border-color: #2e2f33;
    --border-light: #262729;

    /* Shadows - deeper in dark mode */
    --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.3);
    --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.4);
    --shadow-lg: 0 10px 25px rgba(0, 0, 0, 0.5);

    /* Danger - warmer reds that read well on dark backgrounds */
    --danger: #f87171;
    --danger-hover: #ef4444;
    --danger-bg: rgba(248, 113, 113, 0.1);
    --danger-border: rgba(248, 113, 113, 0.25);

    /* Success */
    --success: #4ade80;
    --success-hover: #22c55e;

    /* Code - dark editor theme */
    --code-bg: #141517;
    --code-fg: #e1e3e6;
    --code-keyword: #f87171;
    --code-string: #fb923c;
    --code-comment: #6b7078;
    --code-number: #60a5fa;

    /* Tooltips/badges - inverted from dark-on-light to light-on-dark */
    --tooltip-bg: #e1e3e6;
    --tooltip-fg: #1a1b1e;

    /* Backdrop - slightly lighter to distinguish from bg */
    --backdrop: rgba(0, 0, 0, 0.6);

    /* Message bubble defaults (received) */
    --bubble-code-bg: #141517;
    --bubble-code-fg: #e1e3e6;
    --bubble-code-inline-bg: rgba(255, 255, 255, 0.08);
    --bubble-chip-fg: #ffffff;
    --bubble-chip-bg: #d4455a;
  }
}
```

Source: [designs/chat-color-schemes.md](https://github.com/endojs/endo-but-for-bots/blob/4e7e623ef841f5d23f985bc57386195c93a709af/designs/chat-color-schemes.md) at commit `4e7e623e`.
