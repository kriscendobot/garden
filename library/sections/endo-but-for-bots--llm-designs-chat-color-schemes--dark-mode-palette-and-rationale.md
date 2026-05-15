---
title: Dark mode palette derived from endojs.org brand, with per-token rationale
source: designs/chat-color-schemes.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 4e7e623ef841f5d23f985bc57386195c93a709af
source_date: 2026-02-28
source_authors: [Kris Kowal]
topics: [chat-ui, patterns]
status: current
---

> Abstract: The dark scheme is derived from the **endojs.org brand palette**, not freshly invented: brand burgundy `#BB2D40` becomes the accent, the brand orange-to-coral gradient (`#fb923c` to `#f87171`) provides code-syntax accent colors, and the button-dark `#32373c` shapes the dark UI element family. The full dark `:root` block specifies warm-dark-gray backgrounds (`#1a1b1e`, `#212226`, `#18191c`, `#2c2d31`, `#35363b` ordered primary → active), off-white text (`#e1e3e6` / `#a1a5ab` / `#6b7078`), lightened burgundy accent (`#d4455a` over base `#BB2D40` for dark-background contrast), deeper shadows, warmer reds for danger (`#f87171` / `#ef4444`), light-on-dark tooltips (inverted from light scheme), and `rgba(0,0,0,0.6)` backdrop. Sent-message bubbles override to brand burgundy (`#BB2D40` / `#9e2436`) so they stay visually consistent with the brand. The Color Rationale table is the design's *interpretive document* — each role's value pair has one-line justification that future maintainers can audit.

## Dark `:root` block

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

## Per-token rationale (the design's interpretive document)

| Role | Light | Dark | Rationale |
|---|---|---|---|
| Accent | `#228be6` (blue) | `#d4455a` (burgundy) | Brand color from endojs.org links (`#BB2D40`), lightened for dark-bg contrast |
| Code strings | `#0a3069` | `#fb923c` | Orange from endojs.org brand gradient |
| Code keywords | `#cf222e` | `#f87171` | Coral from endojs.org brand gradient |
| Code numbers | `#0550ae` | `#60a5fa` | Lightened blue for contrast |
| Backgrounds | Cool grays | Warm dark grays | Warm tones complement the burgundy/coral accent palette |
| Danger | Various reds | `#f87171` | Uses the brand coral; lighter reds read better on dark |
| Tooltips | Dark on light | Light on dark | Inverted for contrast in each scheme |

The rationale table is intentionally a **first-class artifact** — each row gives a maintainer enough context to evaluate whether a future change to a token preserves the design's intent or breaks it. Without the rationale, the dark `:root` block would be opaque numbers; with it, the block becomes auditable.

## Sent-message bubble dark override

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

## Pattern: brand-derived color palette

The dark scheme is not invented from primary colors — it is **derived from a brand asset**. The endojs.org website's link color, button color, and gradient are the seeds; the design's dark `:root` block names exactly which brand color seeds each token, and the rationale table records the derivation. This makes the dark scheme:

- **Reviewable**: a maintainer who knows the brand can spot drift in either direction (a token that no longer matches the brand, or a brand change the chat client has not picked up).
- **Extendable**: introducing additional schemes (the [[endo-but-for-bots--llm-designs-chat-high-contrast-mode]] follow-up) starts from a known palette family rather than a fresh design exercise.
- **Auditable**: future PRs that touch a token must explain why the rationale row should change, not just the value.

The discipline is general: any system with a parametric color palette benefits from naming the design's source of authority (brand guide, accessibility standard, user preference) explicitly so token edits are constrained.

Source: [designs/chat-color-schemes.md](https://github.com/endojs/endo-but-for-bots/blob/4e7e623ef841f5d23f985bc57386195c93a709af/designs/chat-color-schemes.md) at commit `4e7e623e`.
