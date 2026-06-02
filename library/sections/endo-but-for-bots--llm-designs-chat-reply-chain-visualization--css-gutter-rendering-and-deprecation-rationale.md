---
title: The CSS-gutter line-drawing implementation that uses `::before`/`::after` pseudo-elements rather than an SVG overlay (rationale: *since segments are simple verticals and horizontals in a fixed gutter column, CSS is simpler and requires no position recalculation*); the line-segment role table (`├`/`│` continue, `├──○` branch fork, `└` terminus); the gutter-layout ASCII spec (~2ex width with the line centered, 2px stroke, muted-grey `#9ca3af` light / `#6b7280` dark sourced from Tailwind gray-400/500); the *off-screen-messages don't break the rendering* invariant; the accessibility surface (visually-hidden *in reply to previous message* links); the performance triad (virtualization + RAF-debounced recalculation + computed-indent caching); the Phase-1-through-5-✅ implementation status; the explicit *Deprecated — see `designs/chat-focus-message.md`* status that captures the design's *implemented-then-superseded* lifecycle; the Decisions Made table that records the granular knob-by-knob choices (indent unit / MOI indication / line thickness / color / nodule styling / off-screen behavior / animation / rendering choice) as a permanent rationale-history artifact
source: designs/chat-reply-chain-visualization.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-01)
source_date: 2026-02-28
source_authors: [Kris Kowal (prompted)]
source_lines: "202-502 (Line Drawing + Vertical Alignment + Interactive Selection + Performance + Accessibility + Visual Design + Implementation Phases + Alternatives Considered + Files + Decisions Made + Out of Scope)"
topics: [chat-ui, ui-design, css]
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
---

## Abstract

The §Line Drawing section opens with the *gutter-locality* observation: *since lines run strictly along the left gutter, the implementation is straightforward*. The §Gutter Layout (lines 196-219) renders an ASCII column diagram with a 16px gutter beside the message content area; the §vertical line in the gutter *connects the three flush-left messages (Parent, MOI, Last reply) with a single straight stroke*. The §Line Segments table (lines 221-233) maps message-role to ASCII glyph (`├` parent / `├` MOI / `│` intermediate pass-through / `├──○` branch reply / `└` last-reply terminus). The §CSS Implementation (lines 235-285) uses `::before`/`::after` pseudo-elements on `.message[data-line]`-attributed elements: the `continue` value paints a full-height vertical via `::before`; the `end` value paints a top-half-only vertical that *terminates at message center*; the `branch` value adds a horizontal `::after` stub extending right from the spine to the indented reply. The §Alternative: SVG Overlay paragraph (lines 287-296) names SVG's three legitimate use cases (animation, complex styling, cross-virtualization-boundary lines) and explicitly *rejects them for this design* because none apply. The §Line Styling (lines 298-329) specifies 2px thickness, `#9ca3af` light / `#6b7280` dark (Tailwind gray-400/500), simple right-angle nodules with *no circles, squares, or other ornamentation*, and the *off-screen-messages don't break rendering* invariant. The §Interactive Selection section (lines 343-378) names click-to-change-MOI as the only interaction; *no special visual feedback* on the MOI beyond its position. The §Scroll Pinning (lines 363-378) uses the existing chat scroll-pinning logic. The §Performance Considerations (lines 380-405) names virtualization + RAF/debounce + caching. The §Accessibility surface (lines 407-430) provides visually-hidden *in reply to previous message* anchors. The §Implementation Phases section (lines 442-468) marks Phases 1-5 ✅ and Phase 6 (polish + a11y + keyboard nav) unfinished. The §Alternatives Considered (lines 470-487) evaluates four sibling approaches (flat-list-with-chips / separate-thread-view / GitHub-collapsed / Slack-side-panel). The §Files section (lines 489-498) lists the implementation artifacts (`packages/chat/moi-layout.js` + `reply-lines.css` + 13 unit tests; modified `inbox-component.js` + `index.html`). The §Decisions Made table (lines 500-516) captures 13 granular knob-by-knob choices as a permanent record. The §Out of Scope tail notes keyboard navigation as the deferred follow-on, eventually picked up by chat-focus-message.

## Body

### §The CSS-over-SVG implementation choice

The §framing comment (lines 235-236):

> Since lines are gutter-local, CSS pseudo-elements work well.

The §Alternative: SVG Overlay paragraph (lines 287-296) names the *honest-comparison-with-explicit-rejection* discipline:

> An SVG could draw all line segments at once, but since segments are simple verticals and horizontals in a fixed gutter column, CSS is simpler and requires no position recalculation.
>
> SVG may be useful if:
> - Lines need animation (drawing effect)
> - Complex styling (gradients, glow effects)
> - Line needs to span across virtualized/recycled message elements

The §three-criterion test:

| Use case | This design | SVG winner? |
|---|---|---|
| Static lines (no animation) | yes | CSS |
| Simple flat color | yes | CSS |
| Lines that fit within each message's gutter | yes | CSS |
| Animation | no | (would be SVG) |
| Gradients / glow | no | (would be SVG) |
| Cross-virtualization-boundary | no | (would be SVG) |

The §design intent: *prefer the simpler tool unless complexity is required*. CSS pseudo-elements are *one declaration per line-state*; SVG would require *position recalculation on every scroll/resize* plus a separate render-tree. The §discipline names the rejected alternative honestly so a future maintainer who needs animation (Phase 6) knows where to look.

### §The CSS implementation pattern

The §CSS Implementation section (lines 237-285) defines four CSS rules. The §root-level custom properties (lines 237-247):

```css
:root {
  --reply-line-color: #9ca3af;
  --reply-line-width: 2px;
  --indent-width: 2ex;
}

[data-theme="dark"] {
  --reply-line-color: #6b7280;
}
```

The §three-knob theming surface:

- **`--reply-line-color`** — muted grey, redefined under `[data-theme="dark"]` for dark-mode contrast.
- **`--reply-line-width`** — 2px stroke; not theme-dependent.
- **`--indent-width`** — 2ex (font-relative); shared between the gutter column width and the indent for branched/intermediate messages.

The §gutter element (lines 249-253):

```css
.message-gutter {
  width: var(--indent-width);
  position: relative;
  flex-shrink: 0;
}
```

The §design intent: every message gets a `.message-gutter` element whose width is exactly the indent unit. This puts the gutter *inside* the message's flex layout — when the renderer applies indent: 1 (via margin or padding), the gutter shifts with the rest of the message, but the line-rendering pseudo-elements still attach to the gutter element. Flush-left messages have gutter at the left edge; indented messages have gutter offset by the indent.

The §three line-segment classes (lines 255-285):

```css
/* Vertical line segment - continues through message */
.message[data-line="continue"] .message-gutter::before {
  /* ::before pseudo-element: full-height vertical line */
}

/* Vertical line segment - terminates at message center */
.message[data-line="end"] .message-gutter::before {
  /* ::before pseudo-element: top-to-center vertical */
}

/* Horizontal branch to indented reply */
.message[data-line="branch"] .message-gutter::after {
  /* ::after pseudo-element: horizontal stub from gutter center to right edge */
}
```

The §pattern:

- The renderer sets a `data-line="continue|end|branch"` attribute on each message based on its role.
- CSS selects on the attribute and paints the appropriate pseudo-element.
- The line position is *always* `calc(var(--indent-width) / 2 - var(--reply-line-width) / 2)` — center of the gutter, minus half the stroke width — so the line is horizontally centered regardless of theme or font-size.

The §`::before` vs `::after` choice: `::before` carries the *vertical* segment (the spine); `::after` carries the *horizontal branch* (the stub to indented replies). Each message has exactly two pseudo-element slots, and the design uses them for the two orientations.

### §The gutter-layout ASCII spec

The §Gutter Layout (lines 196-219) renders the layout in ASCII:

```
┌─────┬────────────────────────────────┐
│gutter│  message content area          │
│ 16px │                                │
├──┬──┼────────────────────────────────┤
│  │  │ Parent message (flush left)    │
│  │  ├────────────────────────────────┤
│  │  │ MOI (flush left)               │
│  │  ├────────────────────────────────┤
│  │  │       Intermediate (indented)  │
│  ├──┼──○ Earlier reply (indented)    │
│  │  ├────────────────────────────────┤
│  │  │       Another intermediate     │
│  │  ├────────────────────────────────┤
│  └──│ Last reply (flush left)        │
└─────┴────────────────────────────────┘
```

The §three structural zones the diagram captures:

- **Gutter column** (16px in the diagram; 2ex in code) — holds the line graphic.
- **Message content** — the actual message body.
- **Indent zone** (between gutter and content for indented messages) — produces the visual *aside* effect.

The §discipline: *the gutter is fixed-width across all messages*. The indent applies to the *content* via padding/margin, not by widening the gutter. This keeps the spine column stable across the conversation.

### §The line-segment role table

The §Line Segments table (lines 223-233) maps message-role to ASCII glyph + behavior:

| Role | Line segment | Behavior |
|---|---|---|
| Parent | `├` or `│` | Vertical line continues down from parent through gap to MOI. |
| MOI | `├` | Vertical line continues down from MOI to replies. |
| Intermediate | `│` | Pass-through vertical line (no connection to the message itself). |
| Branch reply | `├──○` | Vertical pass-through + horizontal stub extending right. |
| Last reply | `└` | Vertical line terminates here. |

The §five-role discipline: every message in the layout is *exactly one* of these five roles. The renderer maps `(message, MOI, layout)` to a role and sets `data-line` accordingly:

- `data-line="continue"` for Parent + MOI + Intermediate.
- `data-line="end"` for Last reply.
- `data-line="branch"` for Branch reply (adds the horizontal stub on top of `continue`).

The §`├──○` glyph is the design-doc author's stylized representation; the actual rendered nodule is a *simple right-angle junction* (no circle), as noted in the §Line Styling section (line 311):

> Simple right-angle junction where the branch meets the main line. No circles, squares, or other ornamentation.

### §The Decisions Made table — knob-by-knob rationale

The §Decisions Made table (lines 500-516) lists 13 granular choices:

| Aspect | Decision |
|---|---|
| Indent unit | ~2ex |
| MOI indication | None needed |
| Clickable indication | None needed |
| Scroll pinning | Use existing logic |
| Line thickness | 2px |
| Line color | Muted grey, light/dark mode aware |
| Nodule styling | Simple junction, no ornament |
| Off-screen parents | Render lines regardless |
| Grey color (light mode) | `#9ca3af` (Tailwind gray-400) |
| Grey color (dark mode) | `#6b7280` (Tailwind gray-500) |
| Gutter width | 2ex (same as indent unit; line centered within) |
| Animation on MOI change | Instant (no transition) |
| Line rendering | CSS pseudo-elements (not SVG) |

The §design-doc-as-decision-record discipline: each row captures *one knob* with *one chosen value*. The table is structurally a permanent rationale record — a future maintainer reading the deprecated design doc sees not just *what the design did* but *what alternatives were explicitly weighed and rejected at each granular point*.

The §recurring *None needed* answer (MOI indication, clickable indication) is honest about the discipline: *the line structure itself is the indication*. Adding visual feedback would be *redundant with the layout*; the design rejects it.

The §recurring *Use existing* answer (scroll pinning) reflects the *defer-to-incumbent-mechanism* discipline. The reply-chain visualization doesn't redesign scroll behavior; it reads from whatever the chat UI already has.

### §The off-screen invariant + accessibility

The §off-screen rule (lines 313-316):

> Lines render regardless of whether the parent or other connected messages are currently visible in the viewport. The line simply extends to the edge of the rendered message area.

The §discipline: *line rendering is local to each message; line continuity is implied across messages*. If the parent is scrolled off the top, the line still extends *up* from the MOI to the top edge of the viewport. The user sees *there is a parent somewhere up there* even when the parent itself is not on screen.

The §accessibility surface (lines 407-430) provides screen-reader-only navigation:

```html
<article class="message" id="msg-123">
  <a href="#msg-456" class="visually-hidden">In reply to previous message</a>
  <!-- message content -->
</article>
```

The §discipline:

- **Visually hidden, audibly present** — uses the `.visually-hidden` / `.sr-only` CSS pattern (`position: absolute; left: -10000px; ...`).
- **A real anchor, not an aria-label**. Screen-reader users can *activate* the link to navigate to the parent message.
- **Keyboard navigation is deferred** (§Keyboard Navigation Future): *A keyboard shortcut to exit the command line and navigate messages is desirable, with shortcuts for common reactions (reply, dismiss, etc.). This is out of scope for this design but noted as a related feature.*

The §deferred keyboard-navigation feature is what *eventually became* chat-focus-message — see the deprecation rationale below.

### §Performance triad — virtualization + RAF + caching

The §Performance Considerations section (lines 380-405) names three optimizations:

- **Virtualization** — only render messages in viewport + buffer; placeholder heights for off-screen messages. Standard technique for long-conversation lists.
- **Debouncing** — line recalculation on scroll/resize uses `requestAnimationFrame` or a debouncer. Avoids per-pixel-scroll re-layout.
- **Caching** — cache computed indent levels; only recompute when messages change.

The §discipline: the design *anticipates* performance concerns and names mitigations without committing to specific implementations. Each is a *standard technique* with a known shape; the actual choice of virtualization library or debouncer can be made at implementation time.

### §Implementation phases — what was actually built

The §Implementation Phases section (lines 442-468) marks five phases ✅ and one phase unfinished:

- **Phase 1: MOI State Management ✅** — MOI ID tracking, scroll pinning, auto-promote on pin + new-message, reset on reload.
- **Phase 2: Layout Computation ✅** — `computeLayout()` algorithm, role assignment.
- **Phase 3: Indentation Rendering ✅** — CSS margin/padding from computed indent.
- **Phase 4: Line Drawing ✅** — CSS pseudo-elements (the design chose CSS over SVG mid-implementation).
- **Phase 5: Click Interaction ✅** — click handler changes MOI; layout recomputes.
- **Phase 6: Polish** — not marked complete. Includes smooth animations on MOI change, line updates on scroll/resize, accessibility, keyboard navigation.

The §design-doc-as-implementation-tracker discipline: the doc *is the source of truth* for what was built. Phases ✅ are immutable historical record; Phase 6 unfinished is the unfinished work.

The §Files section (lines 489-498) names the artifacts:

```
Created:
- packages/chat/moi-layout.js — Pure computeLayout(messages, moiId) algorithm
- packages/chat/reply-lines.css — CSS gutter lines via pseudo-elements
- packages/chat/test/unit/moi-layout.test.js — 13 unit tests

Modified:
- packages/chat/inbox-component.js — MOI state, applyLayout(), gutter elements, click handler, dismiss cleanup
- packages/chat/index.html — Added <link> for reply-lines.css
```

The §implementation-trace discipline: the doc captures which files were created vs modified, with a one-line summary of each. A future maintainer of the chat package can trace from any of these files back to this design doc by filename or by comment reference.

### §The Alternatives Considered — sibling-approach catalog

The §Alternatives Considered section (lines 470-487) catalogs four sibling designs and their trade-offs:

- **Flat list with thread indicators**: render a small *in reply to: [preview]* chip on each reply, click to scroll. *Simpler layout; loses visual structure.*
- **Separate thread view**: clicking a thread opens a dedicated panel/modal showing just that thread. *Cleaner main view; context switch required.*
- **GitHub-style collapsed threads**: show only root messages by default; expand to see replies inline. *Compact; requires more clicks to read.*
- **Slack-style thread panel**: replies open in a side panel. *Main channel stays uncluttered; replies are second-class citizens.*

The §discipline: each alternative is named with its *pro* and *con* in one sentence. The chosen design (MOI spotlight) is implicitly contrasted: it preserves *visual structure* (unlike flat-list), keeps *one main view* (unlike separate-thread), is *always-expanded* (unlike GitHub-collapsed), and treats replies as *first-class spine members* (unlike Slack-panel).

### §The deprecation pointer + the implemented-then-superseded lifecycle

The §status header (lines 7):

> **Status** | Deprecated — see `designs/chat-focus-message.md`

The §lifecycle this captures:

- The design was *fully specified* (this 502-line doc).
- The implementation was *substantially completed* (Phases 1-5 ✅).
- Then the design was *superseded* by a successor design (chat-focus-message).
- The doc is *preserved as historical record* with a pointer to the successor.

The §superseding-design comparison (chat-focus-message is already ingested as 5 sections in the library):

- **Continuity**: chat-focus-message preserves the *focus is the alignment decision* insight. The successor design also picks a single focused message and renders its context.
- **Divergence**: chat-focus-message uses *keyboard navigation* (the deferred-here feature) as the primary interaction, and has an explicit *entry mode* / *exit mode* rather than scroll-pinned auto-promotion. The deprecated MOI-spotlight had click + scroll-pinned auto-promote; the successor has explicit-mode-entry + arrow-keys + shortcut-reactions.
- **Lesson learned**: the §scroll-pinned auto-promote (Core Rule 3) is implicitly the rule that pushed redesign — *automatic MOI changes during follow-along* turned out to be disorienting in practice, and the successor design moves to *explicit-only focus changes*. (This is inferred from the deprecation context; the doc itself doesn't say *why* it was deprecated.)

The §design-doc-as-rationale-history discipline: the *Deprecated* status with a pointer to the successor is the design's *honest acknowledgment of being superseded*. The doc is not deleted — it remains as a record of *what was tried* so the successor's choices have context. Reading the successor (chat-focus-message) alongside this doc explains *what changed and why*.

### §Out of Scope tail

The §Out of Scope tail (lines 501-502):

> **Keyboard navigation**: Shortcut to exit command line and navigate messages with reaction shortcuts (noted for future design)

The §design-doc-tail discipline: the *Out of Scope* section captures *what was deliberately deferred*. The keyboard-navigation deferral is structurally significant — that feature is what eventually motivated chat-focus-message. The design doc *anticipates its own successor* by naming the gap it leaves open.

## Connection to the wider library

This section is the **canonical *deprecated-but-preserved* design-doc worked example**. Four threads:

1. **The CSS-over-SVG implementation choice with explicit rejected-alternative table** is reusable for any *static-line-graphic-in-fixed-column* layout decision. CSS pseudo-elements win when lines are *gutter-local*; SVG wins when lines need animation, gradients, or cross-virtualization continuity.

2. **The §Decisions Made table** is the canonical *knob-by-knob rationale record* shape. Each row is one decision; the table is the permanent answer to *what choices were made at each granular point*.

3. **The §Implementation Phases ✅ / unfinished structure** is the canonical *design-doc-as-implementation-tracker* discipline. The doc is the source of truth for what was built; ✅ phases are immutable history; unfinished phases are the open work surface.

4. **The §Deprecated status with successor pointer** is the canonical *implemented-then-superseded* lifecycle. The deprecated design is preserved (not deleted) so the successor's choices have context. The deprecated doc names its own Out-of-Scope items, which often turn out to be what the successor addresses.

## Translation block (design idiom → contemporary practice)

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

## See also

- [[chat-ui]] (topic) — chat-interface design surface.
- [[ui-design]] (topic) — UI patterns; the implemented-then-superseded lifecycle pattern.
- [[css]] (topic) — CSS implementation; pseudo-element gutter-line drawing.
- `endo-but-for-bots--llm-designs-chat-reply-chain-visualization--message-of-interest-spotlight-algorithm-and-layout-computation` — the previous section: the MOI spotlight algorithm + layout computation.
- `endo-but-for-bots--llm-designs-chat-focus-message--*` (cycles ingesting the *superseding* design): five sections covering motivation/entry-exit, visual-design-and-data-model, indentation-algorithm-and-chain-lines, prefill-mechanism-and-key-files, navigation-and-shortcut-keys. Reading those alongside this section reveals what the successor kept (focus-is-layout) vs changed (keyboard-navigation; explicit-mode-entry; no scroll-pinned auto-promote).
- `endo-but-for-bots--llm-designs-chat-rename-dismiss-to-clear--rename-decision-record` (cycle 95) — sibling single-section design doc; the *dismiss-→-clear rename* decision was captured with similar §Decisions Made table discipline.

## Common confusions

- **"The SVG alternative was rejected for being slower."** It was *not*. The rationale is *simplicity-when-complexity-isn't-needed*: SVG would add a separate render-tree and require position recalculation on scroll/resize. The design notes SVG *may be useful if lines need animation, gradients, or cross-virtualization continuity* — none of which this design needs.
- **"`::before` + `::after` per message is too many pseudo-elements."** Each message has *at most two* pseudo-element slots filled (`::before` for the vertical, `::after` for the branch). For non-line messages, both slots are unused (the CSS selector `.message[data-line="..."]` doesn't match anything). The browser optimizes empty pseudo-elements aggressively.
- **"The 2ex gutter is too narrow for thick lines."** 2ex is the *gutter width*; the line is 2px stroke *centered* in the gutter. With a typical 16px font, 2ex ≈ 16px, so the line is at 7-8px from each edge — comfortable.
- **"`#9ca3af` and `#6b7280` are magic numbers."** They are *Tailwind gray-400 and gray-500*. The doc explicitly cites the source (Tailwind palette) so a maintainer using a different color system can substitute equivalents.
- **"The off-screen-rendering invariant means lines extend infinitely."** They extend *to the edge of the rendered message area*. If the parent is off-screen above, the line goes up to the *top of the viewport's rendered messages*. If virtualization is in use, the line ends at the placeholder height — which itself implies *continuity beyond*.
- **"`visually-hidden` is just CSS `display: none`."** It is *not*. `display: none` removes the element from the accessibility tree; the `visually-hidden` class uses `position: absolute; left: -10000px; ...` so screen readers *do* see the content and can navigate to it.
- **"The design was deprecated because the MOI algorithm was wrong."** The algorithm appears to have been *correct* (Phases 1-5 ✅ marked complete). The deprecation is captured in the *Status* header pointing to chat-focus-message. The successor changes *interaction model* (keyboard-driven explicit focus) more than *algorithm*; the *focus-is-layout* insight is preserved.
- **"`Out of Scope: Keyboard navigation` means the design rejects it."** It means the design *deferred* it. The deferred feature became the *motivating feature* of the successor. The §Out-of-Scope section is the *graceful hand-off-to-future-design* discipline.
- **"`Phase 6: Polish` was unfinished — that's a bug."** It is *the design's unfinished work surface*. Phases 1-5 ✅ delivered the core algorithm and rendering; Phase 6 (smooth animations + accessibility + keyboard nav) was never completed because the design was superseded. The unfinished phase is a *truthful record*, not a bug.
- **"The §Decisions Made table is just a summary."** It is *the canonical permanent answer* to *what was decided at each knob*. Future maintainers reading the deprecated doc can grep the table for any specific choice (indent unit, line color, animation behavior) and get the explicit answer without re-reading the prose.
