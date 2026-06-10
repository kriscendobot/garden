---
title: "endor-bus-tui.md — worker-facing complement to endor-tui + three-layer architecture (bus verbs + XS handles + Exo wrapper) + capability-mediated TUI + state-at-daemon-verbs-at-worker + ten Design Decisions"
source-slug: endo-but-for-bots--llm-designs-endor-bus-tui
section-slug: worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-daemon-verbs-at-worker
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endor-bus-tui.md
source-repo: endojs/endo-but-for-bots
source-path: designs/endor-bus-tui.md
source-author: Kris Kowal (prompted)
total-lines: 1148
ingest-cycle: 271
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
---

# `endor-bus-tui.md` — the worker-facing complement to cycle 269's `endor-tui.md`

A 1148-line design. **Closes another design-to-design dual with cycle 269's `endor-tui.md`** — that design was the host-facing side ("This document references that surface rather than duplicating it"); this design is the worker-facing side ("the **internal** side of the TUI...The **external** side...is specified in the companion document `endor-tui.md`, which this design depends on and does not duplicate").

§First-explicit-observation in library: **§the-host-side-and-the-worker-side-of-the-same-subsystem-as-two-separate-designs-each-deferring-to-the-other — §the-non-duplication-promise-IS-symmetric + §each-side-defers-to-the-other + §the-two-designs-IS-the-canonical-shape-for-a-multi-party-protocol**.

§Two-cycles-with-host-side-and-worker-side-as-named-design-pair (269 endor-tui host + 271 endor-bus-tui worker); §two-cycles-with-symmetric-non-duplication-discipline (269 + 271; both directions of the deferral promise observed in the same week); §six-cycles-with-spec-and-instance-or-validator-and-constructor-or-host-and-worker-discipline-alignment (263 + 265 + 267 + 269 + 270 + 271).

## §The capability-mediated TUI architecture

Lines 36-41 carry the canonical statement:

> *The solution is a **capability-mediated TUI** in which the worker declares what it wants to render and the daemon produces the actual ANSI bytes on the user's terminal. Events flow the other direction: the daemon decodes keyboard, mouse, and resize events and forwards them to whichever worker owns the region that currently has focus.*

§First-explicit-observation in library: **§the-capability-mediated-TUI-architecture — §the-worker-declares-what-it-wants-to-render + §the-daemon-produces-the-actual-ANSI-bytes + §events-flow-the-other-direction + §the-daemon-routes-events-to-the-region-with-focus**.

§Two-asymmetric-flows:
- §**Render-flow** — worker → daemon (worker declares; daemon renders).
- §**Event-flow** — daemon → worker (daemon decodes; worker reacts).

§the-asymmetry-IS-load-bearing — §the-confinement-discipline-precludes-the-worker-from-touching-the-terminal-directly + §the-daemon-IS-the-mediator-for-both-directions; §sibling-pattern to cycle 269's §the-debugger-mediation-discipline; §two-cycles-with-daemon-mediates-X-where-X-IS-a-platform-resource (269 debugger-traffic + 271 TUI-rendering-and-events).

## §The "confinement is the whole point" acknowledgment

Lines 20-25 name the underlying constraint:

> *XS workers are confined JavaScript processes. They cannot write to a file descriptor they were not given. They have no access to `stdout`, no access to the controlling terminal, no knowledge of the TTY's size or mode, and no way to produce ANSI escape sequences that would reach the user. **This is by design: confinement is the whole point.***

§Five-named-non-exposures:
1. **No file descriptor they were not given**.
2. **No access to `stdout`**.
3. **No access to the controlling terminal**.
4. **No knowledge of the TTY's size or mode**.
5. **No way to produce ANSI escape sequences**.

§First-explicit-observation in library: **§five-named-non-exposures-as-named-confinement-discipline-for-XS-workers — §sibling-pattern to cycle 259's three-named-non-exposures-on-Page-interface and cycle 261's three-named-non-exposures-on-HttpClient**.

§The-"this-is-by-design-confinement-is-the-whole-point"-acknowledgment — §the-design-NAMES-the-constraint-rather-than-treating-it-as-a-problem; §the-named-non-exposures-IS-the-feature-not-the-limitation; §three-cycles-with-named-non-exposures-as-design-feature-not-limitation (259 + 261 + 271); §first-explicit-observation in library of §the-"this-is-by-design"-acknowledgment-as-named-design-motivation.

## §Three layers, not one — the explicit layering rationale

Lines 43-77 name §three-layers:

1. **Layer 1: Bus protocol verbs** — wire protocol (CBOR envelope bus); serializable + versioned + survives worker restart.
2. **Layer 2: XS handle API** — small JavaScript module; local JS convenience; per-worker state (pending draw buffers + event subscriptions); §NOT-capability-safe-by-itself.
3. **Layer 3: Exo-based CapTP wrapper** — `makeExo` remotables with `M.interface` method guards; the capability model; §delegatable + revocable + storable-in-pet-store.

§First-explicit-observation in library: **§three-layers-not-one-as-named-design-rationale — §each-layer-solves-a-different-problem (wire-protocol + local-convenience + capability-model) + §a-direct-Exo-only-API-would-couple-the-bus-protocol-to-the-capability-model-and-preclude-non-Exo-users**.

§Design Decision 1 (line 1041) makes the rationale explicit:

> *Three layers, not one. A direct Exo-only API would couple the bus protocol to the capability model and preclude non-Exo users (internal tooling, tests) from driving the TUI. A bus-only API would force every consumer to re-implement the handle bookkeeping. Three layers let each do one job.*

§The-X-over-Y-because-Z-rationale-shape from cycle 269 instantiated here three times in one decision; §the-design-explicitly-rules-out-two-alternatives-before-naming-the-chosen-three-layer-approach.

§First-explicit-observation in library: **§a-decision-that-rules-out-two-alternatives-before-naming-the-chosen-approach — §the-X-over-Y-and-Z-because-W-pattern + §when-a-design-faces-three-or-more-alternatives, §rule-out-the-non-chosen-ones-explicitly-rather-than-just-naming-the-chosen-one**.

## §"State at the daemon, verbs at the worker" — the source-of-truth discipline

Design Decision 2 (lines 1048-1054):

> *State at the daemon, verbs at the worker. The bus protocol is imperative ("setText", "appendLines") because workers emit a stream of small updates, but the daemon keeps full state for reattach and recompose. This mirrors the existing message-hub pattern where the daemon is the source of truth for message identity even though workers produce messages.*

§First-explicit-observation in library: **§state-at-the-daemon-verbs-at-the-worker — §the-imperative-verbs-pattern (setText, appendLines, etc.) + §the-daemon-IS-the-source-of-truth-for-reattach-and-recompose + §workers-emit-deltas + §the-daemon-keeps-the-full-state**.

§Sibling-pattern to many client-server architectures — but §named-here-as-a-design-discipline-not-just-an-implementation-detail.

§"This mirrors the existing message-hub pattern" — §named-reference-to-an-existing-pattern-in-the-system + §the-design-doesn't-invent-a-new-discipline-but-aligns-with-an-existing-one; §first-explicit-observation in library of §named-reference-to-an-existing-pattern-as-design-rationale-rather-than-inventing-a-new-discipline.

## §"Line numbers, not pointers, for buffer edits" — deterministic ID discipline

Design Decision 3 (lines 1056-1061):

> *Line numbers, not pointers, for buffer edits. `editLine` takes a numeric line ID rather than a handle-to-a-line because line numbers survive scrollback eviction deterministically and require no cleanup on the worker side. A line that has scrolled out returns an error on edit; the worker decides whether to append instead.*

§First-explicit-observation in library: **§deterministic-ID-discipline — §when-a-resource-may-be-evicted, §use-a-numeric-ID-rather-than-a-handle-because-the-ID-survives-eviction-deterministically + §the-eviction-IS-implicit + §the-worker-handles-the-eviction-error-rather-than-tracking-the-eviction**.

§Sibling-pattern to many database systems' row-ID conventions; §three-cycles-with-deterministic-ID-discipline (would need cross-check; this is the first explicit observation in the library).

§the-eviction-error-discipline — §when-the-resource-IS-gone, §the-operation-returns-an-error + §the-worker-decides-whether-to-recover-by-appending; §three-cycles-with-error-as-the-protocol-for-evicted-resources-where-the-worker-decides-whether-to-recover (would need cross-check).

## §"Regions, not raw terminal access" — abstraction over renderer

Design Decision 5 (lines 1068-1074):

> *Regions, not raw terminal access. The daemon never exposes cursor-move or SGR sequences. Doing so would bind the protocol to ANSI and preclude alternative renderers (Windows console, tmux control mode, remote web terminals). High-level region content is translated to whatever the renderer speaks.*

§First-explicit-observation in library: **§abstraction-over-renderer-as-named-design-discipline — §the-protocol-doesn't-expose-raw-terminal-bytes + §the-daemon-translates-region-content-to-whatever-the-renderer-speaks + §three-named-alternative-renderers (Windows console + tmux control mode + remote web terminals)**.

§Sibling-pattern to cycle 269's §reuse-protocol-but-not-implementation but applied differently — here it's §abstract-the-protocol-so-the-implementation-can-vary; §two-cycles-with-protocol-decoupling-disciplines-of-different-kinds (269 + 271).

## §Ten numbered Design Decisions

Lines 1039-1104 carry §ten-numbered-Design-Decisions (one fewer than cycle 269's eleven):

1. **Three layers, not one** — §the-X-over-Y-and-Z-because-W-rationale.
2. **State at the daemon, verbs at the worker** — §source-of-truth-discipline.
3. **Line numbers, not pointers, for buffer edits** — §deterministic-ID-discipline.
4. **Events are fire-and-forget envelopes with subscription IDs** — §reuse-existing-bus-primitives.
5. **Regions, not raw terminal access** — §abstraction-over-renderer.
6. **Canvas regions are the escape hatch** — §named-escape-hatch-for-when-the-abstraction-doesn't-fit.
7. **Exo wrapper is optional** — §the-Exos-exist-specifically-for-delegation-and-capability-storage-not-as-the-on-ramp.
8. **The `@tui-screen` reserved name** — §named-pet-name-conventions (cycle 250's @-prefix pattern + cycle 257's @-prefix pet-name observation).
9. **No cross-window z-order in the bus** — §the-no-fighting-for-foreground discipline.
10. **Failure modes are explicit** — §three-named-error-codes (window-revoked + screen-lost + wrong-role).

§The-five-named-`@`-prefix-system-pet-names (line 1088-1089): `@agent` + `@self` + `@host` + `@keypair` + `@mail` — §sibling-pattern to cycle 250's @-prefix observation and cycle 257's @host observation; §three-cycles-with-named-`@`-prefix-system-pet-name-convention (250 + 257 + 271); §the-`@tui-screen`-name-IS-the-sixth-known-member-of-the-convention.

§First-explicit-observation in library: **§five-named-`@`-prefix-system-pet-names-listed-in-one-place + §the-cluster-now-has-six-named-`@`-prefix-system-pet-names-counting-`@tui-screen`**.

## §"Canvas regions are the escape hatch" — named escape hatch discipline

Design Decision 6:

> *Canvas regions are the escape hatch. When a worker genuinely needs cell-level control (an in-buffer cursor, a progress bar inside a line of text), `canvas` provides it without reintroducing terminal escape sequences. The cell packing format is still abstract: no ANSI, just `{char, fg, bg, attrs}`.*

§First-explicit-observation in library: **§named-escape-hatch-for-when-the-abstraction-doesn't-fit — §the-canvas-region-IS-the-escape-hatch-but-it-doesn't-reintroduce-ANSI + §the-escape-hatch-IS-its-own-abstraction-not-a-bypass**.

§The-cell-packing-format (`{char, fg, bg, attrs}`) — §abstract-cell-not-raw-byte; §the-escape-hatch-stays-within-the-design's-abstraction-discipline; §sibling-pattern to many systems' "raw mode" features that still go through a controlled API.

## §"No cross-window z-order in the bus" — agents don't fight for foreground

Design Decision 9:

> *No cross-window z-order in the bus. The layout engine owns stacking. A worker requests a `dock: 'float'` window and accepts whatever stacking order the daemon assigns. Agents do not fight for foreground.*

§First-explicit-observation in library: **§the-no-fighting-for-foreground-discipline — §when-multiple-workers-could-request-foreground, §the-protocol-DOESN'T-expose-stacking-order-as-a-worker-controllable-property + §the-daemon-IS-the-policy-authority + §agents-accept-whatever-the-daemon-assigns**.

§Sibling-pattern to capability-systems' principle-of-least-authority — §the-worker-doesn't-need-to-control-stacking + §the-daemon-can-implement-fair-policy-without-cooperation-from-workers.

§First-explicit-observation in library: **§a-design-decision-named-"agents-do-not-fight-for-foreground"-encodes-the-no-fighting-for-resources-discipline-explicitly**.

## §Three explicit failure modes

Design Decision 10:

> *Failure modes are explicit. `window-revoked`, `screen-lost`, and `wrong-role` are first-class error codes. The worker is expected to handle each; the Exo wrapper surfaces `whenRevoked` as a dedicated promise so code can race it against its own main loop.*

§Three-named-error-codes:
1. **`window-revoked`** — the daemon revoked the window.
2. **`screen-lost`** — the screen was lost (TUI process terminated).
3. **`wrong-role`** — the worker tried to use a region with a role it doesn't have.

§First-explicit-observation in library: **§three-named-failure-modes-as-first-class-error-codes (window-revoked + screen-lost + wrong-role) — §each-failure-mode-IS-a-named-protocol-event-the-worker-must-handle + §the-Exo-wrapper-surfaces-them-as-`whenRevoked`-promise-for-racing-against-the-main-loop**.

§The-`whenRevoked`-dedicated-promise — §the-promise-IS-the-canonical-mechanism-for-cancel-style-events; §sibling-pattern to many cancellation-token systems.

## §Five numbered Phases

Lines 991-1037 carry §five-numbered-Phases (one fewer than cycle 269's six):

1. **Bus verbs for text and buffer regions** — foundational.
2. **Input events and buffer editing**.
3. **Canvas regions**.
4. **Exo wrapper and pet-store advertisement**.
5. **Hardening and diagnostics**.

§Each-phase-builds-on-the-prior; §sibling-pattern to cycle 269's six-numbered-Phases with Phase-1-foundational.

## §Four-row Dependencies table — much smaller than cycle 269's twelve

Lines 982-989 carry §four-row Dependencies:
- **endor-tui.md** — host side of the same subsystem (the explicit non-duplication partner).
- **daemon-engo-supervisor.md** — the CBOR envelope bus.
- **daemon-value-message.md** — `sendValue` for cross-agent advertisement.
- **workers-panel.md** — itself a TUI consumer.

§First-explicit-observation in library: **§the-Dependencies-table-size-correlates-with-the-design's-fan-in-not-its-complexity — §endor-bus-tui-has-substantially-more-content-than-endor-tui-but-only-a-third-the-Dependencies-table-because-the-design-is-more-self-contained**.

§The-design's-substantial-content-IS-its-internal-vocabulary (bus verbs + XS handle methods + Exo interfaces) rather than dependencies on prior designs; §a-design's-fan-in-and-its-complexity-are-different-axes.

## §Seven Known Gaps with named technical concerns

Lines 1106-1133 carry §seven-named-Known-Gaps:

1. **Bidirectional text + combining characters + grapheme cluster widths** across region boundary.
2. **Image protocols** (Kitty, iTerm, Sixel) — out of scope; future `image` region role.
3. **Accessibility** — screen-reader annotations need orthogonal channel.
4. **Multi-screen arbitration** — multiple `screenId`s admitted but not specified.
5. **Persistence of window layout** across daemon restart — currently lost.
6. **Clipboard and selection** — could expose OSC 52-style verbs.
7. **Performance envelope** — no rate limits or backpressure for `drawCells`.

§First-explicit-observation in library: **§seven-named-Known-Gaps-IS-the-richest-Known-Gaps-section-cycle-ingested + §each-gap-IS-named-with-a-technical-concern-and-a-tentative-future-direction**.

§The-"future X-role could be added without protocol changes elsewhere" pattern (line 1115) — §the-protocol-IS-extensible-via-new-role-types-without-touching-existing-verbs; §sibling-pattern to cycle 268's tagged.js extensibility.

## §Cycle 271 first-explicit-observations roundup (twelve)

1. **§the-host-side-and-the-worker-side-of-the-same-subsystem-as-two-separate-designs-each-deferring-to-the-other**.
2. **§the-capability-mediated-TUI-architecture** (worker-declares + daemon-renders; two asymmetric flows).
3. **§five-named-non-exposures-as-named-confinement-discipline-for-XS-workers** (no FD + no stdout + no controlling terminal + no TTY size/mode + no ANSI escapes).
4. **§the-"this-is-by-design"-acknowledgment-as-named-design-motivation** — confinement is the whole point.
5. **§three-layers-not-one-as-named-design-rationale** — wire protocol + local convenience + capability model.
6. **§a-decision-that-rules-out-two-alternatives-before-naming-the-chosen-approach** (X-over-Y-and-Z-because-W).
7. **§state-at-the-daemon-verbs-at-the-worker** as named source-of-truth discipline.
8. **§named-reference-to-an-existing-pattern-as-design-rationale-rather-than-inventing-a-new-discipline**.
9. **§deterministic-ID-discipline** — line numbers, not pointers, for buffer edits.
10. **§abstraction-over-renderer-as-named-design-discipline** — regions, not raw terminal access.
11. **§five-named-`@`-prefix-system-pet-names-listed-in-one-place** + §the-cluster-now-has-six-named-`@`-prefix-system-pet-names-counting-`@tui-screen`.
12. **§named-escape-hatch-for-when-the-abstraction-doesn't-fit** — Canvas regions.

Plus: §the-no-fighting-for-foreground-discipline + §three-named-failure-modes-as-first-class-error-codes + §a-design-decision-named-"agents-do-not-fight-for-foreground" + §the-Dependencies-table-size-correlates-with-the-design's-fan-in-not-its-complexity + §seven-named-Known-Gaps + §two-cycles-with-host-side-and-worker-side-as-named-design-pair + §two-cycles-with-symmetric-non-duplication-discipline.

## §Recurring meta-pattern counters bumped at cycle 271

- §**six-cycles-with-spec-and-instance-or-validator-and-constructor-or-host-and-worker-discipline-alignment** (263 + 265 + 267 + 269 + 270 + 271).
- §**two-cycles-with-host-side-and-worker-side-as-named-design-pair** (269 + 271).
- §**two-cycles-with-symmetric-non-duplication-discipline** (269 + 271; both directions of the deferral promise).
- §**two-cycles-with-daemon-mediates-X-where-X-IS-a-platform-resource** (269 debugger + 271 TUI).
- §**three-cycles-with-named-non-exposures-as-design-feature-not-limitation** (259 Page + 261 HttpClient + 271 XS-worker).
- §**three-cycles-with-named-`@`-prefix-system-pet-name-convention** (250 + 257 + 271).
- §**sixteen-design-docs-from-endo-but-for-bots-designs-cluster-ingested** (cycle 269's fifteen + cycle 271 endor-bus-tui).
- §**one-hundred-and-fourth consecutive designs-chat alternation cycles 166-250 + 252-271** (251 was out-of-band).

## §Synthesis target — slot machine library

§The-host-side-and-the-worker-side-of-the-same-subsystem applies to the §game-engine-cluster:

- §**game-engine-display** (host side) — owns the game screen; renders game state to the user; receives input events.
- §**game-engine-bus-display** (worker side) — game-rule workers declare what they want to render; events flow the other direction.
- §**§capability-mediated-game-display** — game-rule-workers don't touch the display directly; daemon mediates both rendering and events.
- §**§three-layers** — bus verbs (wire) + JS handle API (local) + Exo CapTP wrapper (capability model).
- §**§named non-exposures** — game-rule-workers can't access game-state-directly + can't write to game-state-storage + can't observe other-player-actions.
- §**§deterministic-ID-discipline** for game-events that may scroll out of view.
- §**§abstraction-over-renderer** — game-engine-display doesn't expose raw rendering bytes.
- §**§canvas-regions-as-escape-hatch** for cell-level game-rule rendering.
- §**§no-fighting-for-foreground** — game-rule-workers accept whatever stacking the daemon assigns.

## §Tier-1 borrowing

§the-host-side-and-the-worker-side-of-the-same-subsystem-as-two-separate-designs-each-deferring-to-the-other + §the-capability-mediated-TUI-architecture + §five-named-non-exposures-as-named-confinement-discipline + §the-"this-is-by-design"-acknowledgment + §three-layers-not-one-as-named-design-rationale + §a-decision-that-rules-out-two-alternatives-before-naming-the-chosen-approach + §state-at-the-daemon-verbs-at-the-worker + §deterministic-ID-discipline + §abstraction-over-renderer + §named-escape-hatch-for-when-the-abstraction-doesn't-fit + §the-no-fighting-for-foreground-discipline + §three-named-failure-modes-as-first-class-error-codes.

## §Tier-2 borrowing

§named-reference-to-an-existing-pattern-as-design-rationale-rather-than-inventing-a-new-discipline + §five-named-`@`-prefix-system-pet-names-listed-in-one-place + §the-Dependencies-table-size-correlates-with-the-design's-fan-in-not-its-complexity + §seven-named-Known-Gaps + §"future X-role could be added without protocol changes elsewhere" extensibility pattern.

## §Tier-3 borrowing

§six-cycles-with-spec-and-instance-or-validator-and-constructor-or-host-and-worker-discipline-alignment (263 + 265 + 267 + 269 + 270 + 271) + §two-cycles-with-host-side-and-worker-side-as-named-design-pair (269 + 271) + §two-cycles-with-symmetric-non-duplication-discipline (269 + 271) + §two-cycles-with-daemon-mediates-X (269 + 271) + §three-cycles-with-named-non-exposures-as-design-feature-not-limitation (259 + 261 + 271) + §three-cycles-with-named-`@`-prefix-system-pet-name-convention (250 + 257 + 271) + §sixteen-design-docs-from-endo-but-for-bots-designs-cluster-ingested + §library-reaches-777-sections at cycle 271 + §one-hundred-and-fourth consecutive designs-chat alternation cycles 166-250 + 252-271.

## Pattern summary (tag-prefixed)

§worker-facing-complement-to-cycle-269's-endor-tui + §the-host-side-and-the-worker-side-of-the-same-subsystem-as-two-separate-designs-each-deferring-to-the-other + §the-capability-mediated-TUI-architecture + §two-asymmetric-flows (render-flow worker→daemon + event-flow daemon→worker) + §five-named-non-exposures-as-named-confinement-discipline (no FD + no stdout + no controlling terminal + no TTY size/mode + no ANSI escapes) + §the-"this-is-by-design"-acknowledgment + §three-layers-not-one (bus verbs + XS handles + Exo wrapper) + §each-layer-solves-a-different-problem + §a-decision-that-rules-out-two-alternatives-before-naming-the-chosen-approach + §state-at-the-daemon-verbs-at-the-worker + §named-reference-to-an-existing-pattern + §deterministic-ID-discipline (line numbers, not pointers) + §abstraction-over-renderer (regions, not raw terminal access) + §three-named-alternative-renderers (Windows console + tmux control mode + remote web terminals) + §named-escape-hatch (Canvas regions) + §abstract-cell-format (`{char, fg, bg, attrs}`) + §the-no-fighting-for-foreground-discipline + §three-named-failure-modes-as-first-class-error-codes (window-revoked + screen-lost + wrong-role) + §`whenRevoked`-dedicated-promise + §five-named-`@`-prefix-system-pet-names + §three-cycles-with-named-`@`-prefix-system-pet-name-convention (250 + 257 + 271) + §ten-numbered-Design-Decisions + §five-numbered-Phases + §four-row-Dependencies-table + §seven-named-Known-Gaps + §the-extensible-protocol-via-new-role-types-without-touching-existing-verbs + §six-cycles-with-spec-and-instance-or-validator-and-constructor-or-host-and-worker-discipline-alignment.
