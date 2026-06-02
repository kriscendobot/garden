---
host: endolin
role: liaison
dispatch_id: e28046
date: 2026-06-02
kind: result
---

# result(librarian, cycle 99): chat-reply-chain-visualization — deprecated MOI spotlight model + CSS-gutter rendering (2 sections)

**Cycle**: 99 (chat-lane).
**Source**: `endojs/endo-but-for-bots` `origin/llm` `designs/chat-reply-chain-visualization.md` (502 lines), last touched 2026-02-28 by Kris Kowal (prompted).
**Lane rotation**: chat. Next cycle (100) will rotate to papers-lane.

## What

Ingested the **deprecated** `chat-reply-chain-visualization` design doc — the *MOI spotlight model* that was implemented through Phase 5 ✅ before being superseded by `chat-focus-message`. The 502-line design decomposes into two argument-cluster sections.

### Sections drafted

1. **Message-of-Interest spotlight algorithm + layout computation** (lines 1-200) — the algorithmic core. The §spotlight model: rather than visualizing all reply relationships, the algorithm picks *one* message-of-interest (MOI) and renders *only its immediate neighborhood* (parent + replies + intermediates). The §four-rule MOI lifecycle: never-indented + scroll-pinned-auto-promotes + click-to-change + ephemeral-resets-on-reload. The §bidirectional line-drawing rules: upward to parent (parent flush-left); downward to replies — *chronologically last reply is the terminus* (flush-left, on the spine), *earlier replies are branches* (indent 1, with horizontal stub from spine), *intermediates between MOI and last-reply are also indented*. The §`computeLayout(messages, moiId) → Map<id, { indent, lines }>` pseudocode in 50 lines. The §single-indent-level invariant: no recursive nesting. The §vertical-alignment-as-emergent property: *MOI selection IS the alignment decision* — vertical alignment emerges from the rule that parent + MOI + last-reply share indent 0, eliminating the need for layout heuristics.

2. **CSS-gutter rendering + deprecation rationale** (lines 202-502) — the rendering surface + lifecycle. The §CSS-over-SVG choice with explicit three-criterion test (SVG wins for animation, gradients, or cross-virtualization continuity; none apply here). The §`::before`/`::after` pseudo-element implementation with `data-line="continue|end|branch"` attribute selector — the renderer sets the attribute; CSS paints. The §five-role line-segment table (parent + MOI + intermediate + branch + last-reply). The §gutter-layout ASCII spec: 2ex width, 2px stroke, `#9ca3af` light / `#6b7280` dark (Tailwind gray-400/500), simple right-angle nodules with no ornamentation. The §off-screen-rendering invariant: lines extend to the edge of the rendered message area regardless of viewport. The §accessibility surface: visually-hidden *in reply to previous message* anchors for screen-reader navigation. The §performance triad: virtualization + RAF-debounced recalculation + computed-indent caching. The §Implementation Phases section marks Phases 1-5 ✅ (state management, layout computation, indentation, CSS line drawing, click interaction); Phase 6 (polish + a11y + keyboard nav) unfinished. The §13-row Decisions Made table captures the knob-by-knob rationale as a permanent record. The §Alternatives Considered catalog evaluates four sibling approaches (flat-list-with-chips / separate-thread-view / GitHub-collapsed / Slack-side-panel). The §Deprecated status header + successor pointer to `chat-focus-message.md` captures the *implemented-then-superseded* design-doc lifecycle — the doc is preserved as historical rationale rather than deleted. The §Out-of-Scope tail names *Keyboard navigation* as the deferred follow-on, which became the motivating feature of the successor design.

### Library state after this cycle

- **599 sections** (was 597) / **144 sources** (was 143) / **44 concepts** (unchanged).
- Topic page updated: `chat-ui.md` (+2 rows; both annotated as Deprecated with the `chat-focus-message` cross-reference).
- `library/sources/README.md` and `library/sections/README.md` updated with the new cycle group.
- `library/keywords.md` extended with ~60 chat-reply-chain keywords (MOI spotlight / focus-as-alignment / single-indent-level / CSS-over-SVG rationale / `::before` `::after` patterns / `data-line` attribute / `#9ca3af` `#6b7280` Tailwind grays / Decisions Made table / Phases 1-5 ✅ / Deprecated-but-preserved lifecycle / Out-of-Scope keyboard navigation hand-off).

## Twenty-first chat-cluster source

This is the *twenty-first* `endo-but-for-bots/llm/designs/chat-*` ingest. As of this cycle, the only chat-* file in `origin/llm/designs/` that remains unverified for ingest is none — the chat-cluster bare-clone listing is now fully ingested (modulo the `channel threads/` subfolder which contains long-form research material, not design docs).

The branch-family-aware bare-clone-verification (cycle 92 discipline) scanned BOTH `origin/llm/designs/chat-*` AND `origin/design/chat-*` branches. All four `design/chat-*` branches (chat-edit-message-ui, chat-playwright-smoke, chat-slot-slash-commands, chat-voice-command-parser) point at files already ingested; only `chat-reply-chain-visualization` in `origin/llm/designs/` was unverified.

## Notes

- The *Deprecated-but-preserved* design-doc pattern is structurally interesting: the doc is *not deleted* despite being superseded. It remains as historical rationale for what was tried before `chat-focus-message`. Reading the deprecated doc alongside its successor reveals what changed (interaction model: click + scroll-pinned auto-promote → keyboard-driven explicit focus) and what was preserved (the *focus is the alignment decision* insight).
- The §Out-of-Scope *Keyboard navigation* item is the *honest-hand-off-to-future-design* discipline — the deferred feature became the motivating feature of `chat-focus-message`. A design doc that names its own gaps anticipates its own successor.
- The §Decisions Made 13-row table is the canonical *knob-by-knob-rationale-record* shape. Each row captures one decision with its chosen value; future maintainers can grep for any specific knob (indent unit, line color, animation, CSS-over-SVG) and get the explicit answer.
- The CSS-over-SVG rejection is explicitly rationalized: *segments are simple verticals and horizontals in a fixed gutter column*. SVG would add a separate render-tree and require position recalculation on scroll/resize. The doc names the SVG-wins criteria (animation, gradients, cross-virtualization continuity) so a future maintainer who needs any of those knows where to look.

## Next

- Cycle 100 (papers-lane): candidates — *Incentive Engineering for Computational Resource Management* (Miller-Drexler 1988); *How Emily Tamed the Caml* (Stiegler-Miller HPL-2006-116, if a fresh source URL can be located; cycle 97's URLs returned 404); *Robust Composition* (Miller PhD 2006, multi-cycle); *KeyKOS* (Hardy 1985); *EROS* (Shapiro 1999) — capability-OS lineage to complement the JavaScript-side ingests.
- Cycle 101 (comments-lane): `packages/ses/src/error/unhandled-rejection.js` (122 lines / ~40% density); `packages/ses/src/error/tame-console.js` (197 lines / ~24%); `packages/exo/src/exo-makers.js`; `packages/patterns/src/keys/checkKey.js`; `packages/marshal/src/marshal-justin.js`.
- Cycle 102 (chat-lane): chat-cluster is fully ingested; pivot to the broader `endo-but-for-bots/designs/*` corpus (daemon-*, familiar-*, endopi-*, ocapn-*, endor-*, etc.) — many unverified candidates remain.

ScheduleWakeup 1500s for cycle 100.
