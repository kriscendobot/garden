---
source: designs/chat-reply-chain-visualization.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-01)
source_date: 2026-02-28
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-01
ingested_by: scholar
section_count: 2
status: deprecated
notes: |
  **Status: Deprecated** — superseded by `designs/chat-focus-message.md`
  (already ingested as 5 sections). The 502-line design captures the
  *MOI spotlight model* for reply-chain visualization: exactly one
  *message-of-interest* at a time + automatic-on-pinned + click-to-
  change + bidirectional line-drawing to parent and replies. Phases
  1-5 ✅ (state mgmt, layout computation, indentation, CSS line
  drawing, click interaction); Phase 6 (polish + a11y + keyboard nav)
  unfinished — and the deferred keyboard-navigation feature became
  the motivating feature of the *successor* chat-focus-message
  design. Two sections honestly decompose: (1) MOI algorithm + layout
  computation (the focus-as-alignment-decision insight; single-indent-
  level invariant); (2) CSS-gutter pseudo-element rendering + the
  §Decisions Made 13-row knob-by-knob rationale table + the explicit
  Deprecated status + successor pointer.
  
  Twenty-first chat-cluster source. Canonical *deprecated-but-
  preserved* design-doc pattern — the doc is not deleted; it remains
  as historical rationale for what was tried before chat-focus-message.
  Pairs structurally with chat-rename-dismiss-to-clear (cycle 95) as
  *single-decision-with-deprecation-or-retrospective* design docs;
  pairs with chat-focus-message ingest as the *deprecated predecessor*
  whose Out-of-Scope item (keyboard navigation) became the successor's
  motivating feature.
---

> Abstract: `designs/chat-reply-chain-visualization.md` is the
> *deprecated* design for visualizing chat reply relationships in
> the Familiar Chat client. The doc specifies the *MOI spotlight
> model*: exactly one *message-of-interest* at a time, never indented,
> auto-promoted on scroll-pinned new-message arrival, changed by
> click. The MOI's parent and replies form a *vertical spine* at
> indent 0 (parent + MOI + chronologically-last reply); earlier
> replies and intermediate messages between MOI and last-reply are
> indented to a single indent level. The *focus is the alignment
> decision* observation: vertical alignment emerges from the rule
> that MOI + parent + last-reply share indent 0, eliminating the
> need for layout heuristics. The `computeLayout(messages, moiId)`
> pseudocode returns a `Map<id, { indent, lines }>` consumed by a
> CSS pseudo-element renderer. The CSS-over-SVG choice is rationalized
> explicitly with a three-criterion test: SVG wins for animation,
> gradients, or cross-virtualization continuity — none of which
> apply here, so CSS pseudo-elements (`::before` for vertical,
> `::after` for horizontal branch) suffice. The §Decisions Made
> table captures 13 granular choices (2ex indent unit, 2px stroke,
> `#9ca3af` light / `#6b7280` dark, simple right-angle nodules
> with no ornamentation, off-screen-rendering-without-breaking,
> instant MOI-change animation, CSS over SVG). Phases 1-5 ✅
> mark the implemented work; Phase 6 (polish + a11y + keyboard
> nav) is unfinished — and the deferred *keyboard navigation*
> Out-of-Scope item became the motivating feature of the successor
> design `chat-focus-message.md`. The deprecation status + successor
> pointer captures the canonical *implemented-then-superseded*
> design-doc lifecycle: the doc is preserved as historical
> rationale rather than deleted.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [message-of-interest-spotlight-algorithm-and-layout-computation](../sections/endo-but-for-bots--llm-designs-chat-reply-chain-visualization--message-of-interest-spotlight-algorithm-and-layout-computation.md) | chat-ui | deprecated |
| [css-gutter-rendering-and-deprecation-rationale](../sections/endo-but-for-bots--llm-designs-chat-reply-chain-visualization--css-gutter-rendering-and-deprecation-rationale.md) | chat-ui | deprecated |

The 502-line file decomposes into two argument-cluster sections. Lines 1-200 (Motivation + Data Model + MOI Algorithm + Indentation) are the algorithmic core → section 1. Lines 202-502 (Line Drawing + Vertical Alignment + Interactive Selection + Performance + Accessibility + Implementation Phases + Alternatives Considered + Files + Decisions Made + Out of Scope) are the rendering + lifecycle surface → section 2.

## Provenance

- Fetched 2026-06-01 from `endojs/endo-but-for-bots` `origin/llm` via the local bare-clone (the design lives in the `llm` branch's `designs/` folder, like other chat-* designs).
- Last touched 2026-02-28 by Kris Kowal (*prompted* — i.e., LLM-collaborated authoring).
- Verified file existence via bare-clone listing: 502 lines. The §Status header explicitly says **Deprecated — see `designs/chat-focus-message.md`**.
- **Twenty-first chat-cluster source** (after the cycle 95 cohort completed). Identified as a candidate in the cycle 96 *future cycles* notes (*chat-reply-chain-visualization (Deprecated, 502 lines, design-rationale-history candidate)*).
- Sources ingested 2026-06-01; the cycle 92 branch-family-aware bare-clone-verification discipline (scan BOTH `origin/llm/designs/*` AND `origin/design/chat-*` branches) was followed — `chat-reply-chain-visualization` is the only chat-* file in `origin/llm/designs/` not yet ingested as of this cycle.
- Section status set to *deprecated* (not *current*) to match the source's own §Status header. The library treats this as historical rationale documentation, not an active design.
- Two-section cohesion-honest count. The 502-line file genuinely decomposes into algorithm-side and rendering-side; forcing it into 3 sections would create artificial splits (the alternatives-considered, performance, accessibility, and phases-tracker sections all naturally cluster with the rendering side).
