---
created: 2026-06-29
updated: 2026-06-29
author: gardener
---

# Skill: css-design-tokens-and-theming

Express a UI's colors (and spacing, elevation, radii) as CSS custom properties
("design tokens") declared on `:root`, **derived from a named source of
authority** (a brand asset, an accessibility standard), with scheme-aware
overrides (light / dark / high-contrast) and a **per-token rationale table** so
theme drift is reviewable and auditable. The tokens are the single point of
change; every component references `var(--token)` rather than a hardcoded value.

Grounded in the garden's own web work, **not** in the Goldilocks essay: the chat
client's color-schemes design (library:
`endo-but-for-bots--llm-designs-chat-color-schemes--dark-mode-palette-and-rationale--{pattern-brand-derived-color-palette,per-token-rationale-the-design-s-interpretive-document}`
and `--motivation-and-current-state--{existing-root-custom-properties-light-theme,pattern-scheme-aware-tokens-with-intentional-exceptions}`).

A [web-designer](../../roles/web-designer/AGENT.md) authors the token set and the
rationale; a [web-builder](../../roles/web-builder/AGENT.md) lands it and migrates
the hardcoded values. The scheme-gating mechanics (`@supports`, intentional
exceptions documented inline) are shared with
[supports-feature-query-progressive-enhancement](../supports-feature-query-progressive-enhancement/SKILL.md).

## When to use

- Any multi-scheme or brandable web surface: a client with a dark mode, a
  high-contrast mode, a themeable embed, a GitHub Pages SPA (the bulletin under
  `docs/bulletin/`).
- A stylesheet is accumulating hardcoded hex colors that need to vary by scheme or
  track a brand.
- A design needs theme changes to be **reviewable**: a maintainer should be able
  to tell whether a token edit preserves the design's intent or breaks it.

If the surface is single-scheme and will never be rebranded, a small fixed
palette may not need the full token-plus-rationale apparatus; scale the discipline
to the surface.

## The token layer

Declare semantic tokens on `:root`. Name them by **role**, not by appearance, so a
component reads as its intent and a re-theme does not require renaming:

```css
:root {
  /* backgrounds */
  --bg-primary:   #ffffff;   /* main content background */
  --bg-secondary: #f8f9fa;   /* chat bar, headers, hints */
  --bg-hover:     #e9ecef;   /* hover-state backgrounds */
  /* text */
  --text-primary:   #212529; /* primary body text */
  --text-secondary: #495057; /* secondary labels */
  --text-muted:     #868e96; /* placeholders, hints */
  /* accent */
  --accent-primary: #228be6; /* links, focus rings, interactive elements */
  --accent-hover:   #1c7ed6;
  /* borders + elevation */
  --border-color: #dee2e6;
  --shadow-lg:    0 10px 25px rgba(0, 0, 0, 0.1); /* modals, dropdowns */
}
```

Every component then references the token: `color: var(--text-primary)`,
`background: var(--bg-secondary)`. The default policy is **no hardcoded color
outside `:root`** — every color a component uses is a `var(--*)`.

## Scheme-aware overrides

A second scheme is a second `:root` block that **re-binds the same token names**
under a scheme selector, so no component CSS changes:

```css
@media (prefers-color-scheme: dark) {
  :root {
    --bg-primary:     #1a1a1a;
    --text-primary:   #e0e0e0;
    --accent-primary: #d4455a; /* burgundy, brand-derived (see rationale) */
  }
}

/* or an explicit user toggle */
:root[data-theme="dark"] {
  --bg-primary:     #1a1a1a;
  /* ... */
}
```

A high-contrast scheme is a third such block. The components are scheme-agnostic;
only the token bindings change.

## Derive the palette from a named authority

Do not invent the scheme from raw primaries. **Name the source of authority** and
seed the tokens from it, so token edits are constrained and drift is detectable in
both directions (a token that no longer matches the brand, a brand change the UI
has not picked up). The chat design's dark scheme is derived from the endojs.org
brand (its link color, button color, gradient); the dark `:root` block names which
brand color seeds each token. The same discipline generalizes: the authority can
be a brand guide, a WCAG contrast target, or a documented user preference, but it
must be **stated**.

## The per-token rationale table (a first-class artifact)

Pair the token set with a table that gives, per token, its value in each scheme
and the reason for that value. This is the design's interpretive document: without
it a `:root` block is opaque numbers; with it the block is auditable.

| Role         | Light     | Dark      | Rationale                                              |
| ------------ | --------- | --------- | ----------------------------------------------------- |
| Accent       | `#228be6` | `#d4455a` | Brand color from endojs.org links, lightened for dark |
| Code strings | `#0a3069` | `#fb923c` | Orange from endojs.org brand gradient                 |
| Backgrounds  | Cool gray | Warm gray | Warm tones complement the burgundy/coral accent       |
| Danger       | Reds      | `#f87171` | Brand coral; lighter reds read better on dark         |

Each row gives a reviewer enough context to judge whether a future change
preserves intent. A PR that edits a token must explain why its rationale row
should change, not just flip the value.

## Intentional exceptions, documented inline

A few elements are legitimately **not** scheme-varying: text rendered on a
saturated accent background (a sent-message bubble, an active row) is designed
against the accent, not against the page, so it keeps a hardcoded
`white`/`rgba(255,255,255,...)` in **every** scheme. Record each such exception
inline at the declaration, so a later audit that greps for hardcoded colors treats
every survivor as either a documented exception or a regression. This is the same
gate-and-document discipline as
[supports-feature-query-progressive-enhancement](../supports-feature-query-progressive-enhancement/SKILL.md);
here the gate is "varies by scheme vs. fixed against the accent."

## Procedure

1. **Inventory the hardcoded values** the surface currently uses and group them by
   semantic role (background, text, accent, border, elevation, danger).
2. **Name the source of authority** (brand asset, contrast standard) and derive a
   palette from it; do not invent from raw primaries.
3. **Declare role-named tokens on `:root`** for the default scheme; replace every
   component-level hardcoded value with `var(--token)`.
4. **Add a scheme block per alternate scheme** (`prefers-color-scheme`, a
   `[data-theme]` toggle, or both) that re-binds the same token names.
5. **Write the per-token rationale table** as a first-class section of the design,
   one row per token, value-per-scheme plus the reason.
6. **Document each intentional hardcoded exception inline** so an audit grep can
   classify every survivor.
7. **Verify** per the checklist below.

## Verification

- Toggle every scheme (light, dark, any high-contrast): every surface re-themes
  with no component CSS change, and nothing is left at a default-scheme color by
  accident.
- Grep the stylesheet for hardcoded color literals outside `:root`: every hit is a
  documented intentional exception; an undocumented hit is a regression.
- Spot-check contrast in each scheme (text on its background) against the stated
  accessibility authority.
- Confirm each rationale row matches the value actually shipped in each scheme
  (the table is the source of truth, not stale documentation).

## Limitations (call these out in the design)

- **Tokens centralize change; they do not guarantee contrast.** A scheme can be
  fully tokenized and still fail WCAG. Verify contrast per scheme; the token layer
  is the mechanism, the accessibility standard is the authority.
- **Intentional exceptions accumulate.** Each hardcoded survivor is debt that a
  future audit re-examines; keep the set small and documented, not a loophole.
- **A rationale table drifts if not maintained.** It is only auditable while it
  matches the shipped values; treat a token edit and its rationale row as one
  change.

## Output

The deliverable is the `:root` token declarations (default plus one block per
alternate scheme), the components migrated to `var(--token)`, the per-token
rationale table in the design, and the inline-documented intentional exceptions,
plus a design note naming the source of authority the palette derives from.

## Notes from the field

(Append; terse and dated.)

- _2026-06-29_: initial write (job `author-web-designer-css-skills`, scholar
  proposal). Grounded entirely in the garden's own chat color-schemes design
  (`endo-but-for-bots--llm-designs-chat-color-schemes`), not the Goldilocks essay:
  brand-derived palette, the per-token rationale table as a first-class artifact,
  and scheme-aware tokens with inline-documented intentional exceptions.
