---
title: Translation block (design idiom → contemporary practice)
source: designs/chat-reply-chain-visualization.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-01)
source_date: 2026-02-28
source_authors: [Kris Kowal (prompted)]
source_lines: "202-502 (Line Drawing + Vertical Alignment + Interactive Selection + Performance + Accessibility + Visual Design + Implementation Phases + Alternatives Considered + Files + Decisions Made + Out of Scope)"
topics: [chat-ui]
status: deprecated
notes: |
  The rendering + lifecycle surface of the deprecated chat-reply-
  chain-visualization design. Four threads: (1) the §CSS-over-SVG
  choice with explicit rationale (*segments are simple verticals
  and horizontals in a fixed gutter column*); the SVG fallback is
  noted only for animation/gradient/virtualization cases that this
  design doesn't need; (2) the §line-segment role table (`│`
  continue, `├──○` branch, `└` terminus) plus the gutter-layout
  ASCII spec with 2ex width and 2px stroke and `#9ca3af`/`#6b7280`
  muted grey (Tailwind gray-400/500); (3) the §Decisions Made
  table — 13 granular choices (indent unit / line thickness /
  color / nodule styling / off-screen rendering / animation /
  CSS over SVG) captured as a permanent decision record; (4) the
  §explicit deprecation pointer to chat-focus-message — Phase 1-5
  ✅, Phase 6 (polish + a11y + keyboard) unfinished — captures
  the *implemented-then-superseded* lifecycle. Together this is
  the canonical *deprecated-but-preserved* design doc pattern.
parent: endo-but-for-bots--llm-designs-chat-reply-chain-visualization--css-gutter-rendering-and-deprecation-rationale
---

| Design idiom | Contemporary practice |
| ------------ | --------------------- |
| `CSS pseudo-elements work well` for gutter-local lines | The *static-line-graphic-in-fixed-column* discipline; prefer CSS over SVG when none of animation/gradient/cross-boundary applies. |
| `An SVG could draw all line segments at once, but since segments are simple ... CSS is simpler` | The *honest-comparison-with-explicit-rejection* discipline; name the unchosen alternative with the criterion for picking it. |
| `2ex` indent unit | The *font-relative-indent* choice; scales with text size. |
| `#9ca3af` light / `#6b7280` dark (Tailwind gray-400/500) | The *theme-aware-muted-grey* via CSS custom property; redefined under `[data-theme="dark"]`. |
| `Simple right-angle junction... no circles, squares, or other ornamentation` | The *minimalist-graphic-vocabulary* discipline; reject decorative ornaments. |
| `data-line="continue\|end\|branch"` attribute | The *renderer-sets-attribute-CSS-paints* idiom; clean separation between layout-computation output and style rendering. |
| `Lines render regardless of whether the parent... is visible in the viewport` | The *local-line-rendering-with-implicit-continuity* invariant. |
| `Use existing scroll pinning logic` | The *defer-to-incumbent-mechanism* discipline; don't redesign what already exists. |
| `Phase 1: ✅ Phase 2: ✅` checklist | The *design-doc-as-implementation-tracker* — phases ✅ become permanent historical record. |
| `Deprecated — see designs/chat-focus-message.md` | The *implemented-then-superseded* lifecycle; preserve the deprecated doc as rationale-history. |
| 13-row §Decisions Made table | The *knob-by-knob-rationale-record* shape; one row per choice; permanent answer. |
