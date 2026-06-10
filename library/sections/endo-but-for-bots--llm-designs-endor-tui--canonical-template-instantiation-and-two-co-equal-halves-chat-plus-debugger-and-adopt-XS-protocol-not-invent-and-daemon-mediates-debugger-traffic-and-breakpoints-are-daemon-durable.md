---
title: "endor-tui.md — canonical design-doc-template instantiation + two co-equal halves (Chat + Debugger) + adopt XS protocol not invent + daemon mediates debugger traffic + breakpoints are daemon-durable + eleven numbered Design Decisions + twelve-row Dependencies table"
source-slug: endo-but-for-bots--llm-designs-endor-tui
section-slug: canonical-template-instantiation-and-two-co-equal-halves-chat-plus-debugger-and-adopt-XS-protocol-not-invent-and-daemon-mediates-debugger-traffic-and-breakpoints-are-daemon-durable
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endor-tui.md
source-repo: endojs/endo-but-for-bots
source-path: designs/endor-tui.md
source-author: Kris Kowal (prompted)
total-lines: 887
ingest-cycle: 269
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
---

# `endor-tui.md` — canonical design-doc-template instantiation, two co-equal halves, Rust TUI for the forward-looking Rust daemon

An 887-line design that fully instantiates cycle 265's CLAUDE.md template. **The largest fully-template-following design ingested so far** and the most-fanned-in design observed: §twelve-row Dependencies table.

§First-explicit-observation in library: **§the-template-IS-instantiated-completely-with-all-seven-sections-and-the-Prompt-appendix — §the-endor-tui-design-IS-the-canonical-template-instance against which other instances can be compared**.

## §Two co-equal halves named at the top — Chat + Debugger

Lines 28-37 carry the §two-co-equal-halves naming:

> *It has two co-equal halves: 1. **Chat** — a keyboard-driven analogue of `packages/chat/`; 2. **Debugger** — an interactive stepping debugger for Moddable XS workers.*

§First-explicit-observation in library: **§two-co-equal-halves-as-named-design-shape — §when-a-design-encompasses-two-substantially-different-feature-sets, §the-design-names-them-as-co-equal-rather-than-foregrounding-one**.

§Sibling-pattern to capability-systems' two-facet pattern (cycle 226's canonical caretaker two-facet); §but-different-axis — §two-facets-divides-by-authorization (use + control); §two-co-equal-halves-divides-by-feature-set (Chat + Debugger).

§The-halves-share-infrastructure (one bus connection per design decision 10) + §the-halves-share-the-modal-input-system; §the-two-halves-IS-a-named-modeling-discipline-when-the-feature-sets-are-large-enough-to-be-independently-designed-but-share-substrate.

## §The three-motivation convergence pattern

Lines 50-73 carry §three-motivations-converge-on-the-need-for-a-TUI:

1. **Chat is becoming the debugger of last resort** — agents gain tool capabilities + developer wants to see inbound messages + tool call replies + pending commands + worker state in one place.
2. **`xsbug` is not a viable dependency** — Moddable's `xsbug` is a macOS-only Xojo application; reuse the protocol but not the UI.
3. **Rust crates make TUI cheap** — `ratatui` + `crossterm` have matured.

§First-explicit-observation in library: **§the-three-motivation-convergence-pattern — §when-a-design-is-justified, §three-named-motivations-IS-a-canonical-rationale-shape + §the-three-motivations-converge-rather-than-each-being-sufficient-alone**.

§The-Chat-is-becoming-the-debugger-of-last-resort-observation — §a-named-evolution-of-a-system's-purpose; §the-original-design-of-Chat-was-not-for-debugging-but-it-has-become-the-debugger-of-last-resort + §the-design-acknowledges-the-evolution-and-builds-on-it; §first-explicit-observation in library of §the-named-evolution-of-a-system's-purpose-as-design-rationale.

§The-`xsbug`-not-viable-because-macOS-only-Xojo — §named-platform-constraint-as-design-motivation; §the-existing-tool-IS-platform-bound + §reusing-the-protocol-but-not-the-UI-IS-the-canonical-response.

§Reuse-protocol-but-not-UI — §three-cycles-with-protocol-reuse-but-implementation-rewrite (245 panic + 246 lockdown + 269 xsbug); §the-discipline-IS-named-explicitly-here + §the-rewrite-respects-the-protocol-as-stable + §the-implementation-IS-replaced-because-platform-bound.

§First-explicit-observation in library: **§reuse-protocol-but-not-implementation-as-named-platform-decoupling-discipline**.

## §Eleven numbered Design Decisions (richest cycle-ingested so far)

Lines 756-822 carry **eleven** numbered Design Decisions, each with named rationale:

1. **`ratatui` + `crossterm` over `cursive`** — §immediate-mode-rendering-over-retained-widget-trees-for-streaming-data; §the-`cursive`-rejection-IS-named (would force synchronizing widget state with async daemon state, creating a second source of truth).
2. **Alternate-screen, full redraw on events rather than line log** — §random-access-vs-line-scrolling.
3. **Modal input** — §the-mode-set-IS-small (normal + insert + focus + modal); §the-modes-mirror-the-web-Chat's-implicit-states-rather-than-inventing-new-ones.
4. **Adopt XS's native debugger protocol rather than inventing one** — §the-`mxDebug`-protocol-IS-the-canonical-name; §`xsbug`-IS-existence-proof-that-the-protocol-IS-sufficient-for-production-debugging.
5. **Daemon mediates debugger traffic; TUI speaks only bus verbs** — §three-named-properties-of-the-daemon-mediation (multi-client + multi-TUI + reconnectable); §capability-based-access-control (a guest cannot attach to another guest's worker).
6. **Breakpoints are daemon-durable** — §when-a-developer's-mental-model-IS-"I-set-a-breakpoint-here", §the-breakpoint-must-survive-TUI-restarts + §the-agent-can-block-on-the-breakpoint-with-no-TUI-attached.
7. **Debugger opt-in per worker** — §workers-launched-without-the-debug-flag-show-a-greyed-out-state; §this-prevents-surprise-pauses-in-production-deployments.
8. **`endor tui` is a separate process, not embedded in the daemon** — §three-named-properties-of-the-process-separation (multiple TUIs + TUI crash cannot take down daemon + remote SSH operation works without proxying).
9. **No `xsbug` compatibility mode** — §named-non-goal; §the-protocol-IS-consumed + §the-tool-IS-not-committed-to-being-a-drop-in-replacement.
10. **Chat and debugger share one bus connection** — §the-two-views-multiplex-over-one-socket; §reconnect-logic-is-shared.
11. **Mouse capture off by default** — §native-terminal-selection-IS-a-workflow-developers-care-about + §mouse-IS-a-toggle.

§First-explicit-observation in library: **§eleven-numbered-Design-Decisions-IS-the-richest-Design-Decisions-section-cycle-ingested-so-far — §the-section-IS-the-cumulative-rationale-record-for-the-design-and-the-arity-correlates-with-the-design's-complexity**.

§Several-decisions-IS-of-the-shape-"X over Y, because Z" — §three-named-such-decisions-in-this-list (1 + 4 + 10); §the-`X-over-Y-because-Z`-rationale-shape-IS-the-canonical-form-for-comparative-decisions.

§Several-decisions-IS-of-the-shape-"X because Y" — §eight-named-such-decisions; §the-`X-because-Y`-rationale-shape-IS-the-canonical-form-for-positive-decisions.

§First-explicit-observation in library: **§two-named-Design-Decision-rationale-shapes (`X-over-Y-because-Z` for comparative + `X-because-Y` for positive)**.

## §Twelve-row Dependencies table — the most-fanned-in design observed

Lines 823-838 carry a §twelve-row Dependencies table — the highest fan-in observed in any design ingested. The dependencies span:

- §**Direct sibling**: endor-bus-tui (the bus verb surface).
- §**Five chat designs**: chat-command-bar + chat-focus-message + chat-pending-commands + chat-color-schemes + chat-per-space-color-scheme + chat-spaces-home + chat-view-edit-commands (the web Chat ancestor).
- §**Worker observability**: workers-panel.
- §**Daemon substrate**: daemon-value-message + daemon-mount + daemon-agent-tools.

§First-explicit-observation in library: **§twelve-row-Dependencies-table-IS-the-highest-fan-in-observed-in-any-design — §the-fan-in-correlates-with-the-design's-position-near-the-top-of-the-dep-graph-(consuming-but-not-yet-consumed-by-others)**.

§Each-dependency-row-carries-a-named-relationship — *"TUI command bar state machine mirrors the web command bar exactly"*; *"TUI focus mode mirrors the web focus mode"*; *"Tool-call messages are first-class transcript entries"*. §the-relationship-IS-the-non-obvious-part-+-the-table-encodes-it.

§the-`mirrors-X-exactly`-relationship-IS-named (web command bar → TUI command bar) — §the-TUI-design-EXPLICITLY-promises-state-machine-equivalence-with-the-web-design; §two-named-state-machine-equivalence-relationships (chat-command-bar + chat-focus-message); §first-explicit-observation in library of §mirrors-X-exactly-as-named-state-machine-equivalence-discipline-in-a-Dependencies-table.

## §Six numbered Phases

Lines 706-754 carry §six-numbered-Phases with named exit criteria:

1. **Skeleton and Chat transcript** — foundational.
2. **Spaces and focus mode**.
3. **Value inspection and forms**.
4. **XS debugger baseline**.
5. **Debugger richness**.
6. **Polish and escape valves**.

§Each-phase-IS-a-named-deliverable-with-implicit-or-explicit-exit-criteria; §sibling-pattern to cycle 265's CLAUDE.md spec's §Phased-implementation requirement; §the-design-honors-the-template's-Phased-section.

§The-"foundational"-marker-on-Phase-1 — §the-phase-IS-named-as-foundational-not-just-numbered + §the-rationale-IS-the-other-phases-build-on-it; §first-explicit-observation in library of §the-"foundational"-marker-on-Phase-1-as-named-rationale-for-phase-ordering.

§Six-phases IS the most-numerous Phased-implementation observed; §sibling-pattern to capability-systems' multi-step OAuth flows (cycle 234's six-step).

## §The XS Debugger section — adopt-but-replace discipline named at the protocol layer

Lines 456-668 carry a §XS-Debugger section detailed enough to be a sub-design.

### §`mxDebug` protocol named explicitly
The Moddable XS native debugger protocol. §the-protocol-IS-named-by-its-implementation-marker — §sibling-pattern to cycle 254's no-shim's named-shim-module discipline; §the-protocol-name-IS-the-stable-vocabulary + §the-tool-name-IS-not.

### §Daemon-mediated debugger traffic — capability boundary
Design Decision 5 names the architecture: §daemon-mediates-debugger-traffic + §TUI-speaks-only-bus-verbs. §The-daemon-IS-the-mediator + §the-TUI-IS-the-presentation; §the-direct-TUI-to-worker-debugger-socket-IS-rejected-because-it-bypasses-capability-based-access-control.

§First-explicit-observation in library: **§the-debugger-mediation-discipline — §daemon-mediates-debugger-traffic-because-it-can-enforce-capability-based-access-control + §TUI-speaks-only-bus-verbs**.

§The-capability-based-access-control-discipline names: *"a guest cannot attach to another guest's worker"*. §the-discipline-IS-an-instance-of-the-broader-capability-systems-isolation-discipline + §the-daemon-IS-the-policy-enforcement-point.

### §Daemon-durable breakpoints
Design Decision 6: §breakpoints-survive-TUI-restarts + §the-agent-can-stop-at-configured-breakpoints-even-with-no-TUI-attached. §the-breakpoint-IS-the-design's-named-persistence-anchor + §the-agent-blocks-at-the-breakpoint-rather-than-continuing-through-it.

§First-explicit-observation in library: **§daemon-durable-breakpoints-as-named-persistence-discipline — §a-developer's-mental-model-of-"I-set-a-breakpoint-here"-must-survive-process-restarts + §the-breakpoint-IS-the-named-persistence-anchor**.

### §Debugger opt-in per worker
Design Decision 7: §workers-launched-without-the-debug-flag-show-a-greyed-out-state. §the-opt-in-discipline-prevents-surprise-pauses-in-production; §the-greyed-out-state-IS-the-visible-evidence-of-the-non-debuggability + §the-developer-knows-which-workers-can-be-paused.

§First-explicit-observation in library: **§debugger-opt-in-per-worker-with-greyed-out-state-as-evidence-of-non-debuggability**.

## §Chat TUI section — mirrors-X-exactly discipline across the web Chat

Lines 164-454 carry the Chat TUI section, with subsections that each mirror a chat-* design from the cluster:

- **Concepts to adapt** (line 166) — §the-discipline-IS-adapt-not-copy.
- **Panel layout** (line 191).
- **Keybinding scheme** (line 225).
- **Modeline** (line 267).
- **Transcript rendering** (line 286).
- **Focus mode** (line 325) — mirrors `chat-focus-message`.
- **Pending commands region** (line 338) — mirrors `chat-pending-commands`.
- **Source editing** (line 358).
- **Value modal** (line 381).
- **Inventory** (line 410).
- **Spaces** (line 427).
- **Inbox vs. channel vs. forum modes** (line 440).

§First-explicit-observation in library: **§the-twelve-subsection-Chat-TUI-section-IS-a-direct-projection-from-the-twelve-chat-cluster-designs + §each-subsection-mirrors-or-adapts-a-named-web-Chat-feature**.

§The-mirror-discipline-IS-strict for `chat-focus-message` (Design Decision Dependencies row says "mirrors the web focus mode") and `chat-pending-commands` (same). For other chat-* designs the relationship is "adapted from" or "ported to terminal idiom" rather than strict mirror.

§Two-named-relationship-strengths-in-the-cluster-graph:
- §**Strict mirror** — TUI feature is state-machine-equivalent to web feature.
- §**Adapt** — TUI feature is the terminal-idiomatic version of the web feature.

§First-explicit-observation in library: **§two-named-relationship-strengths-in-the-cluster-graph (strict-mirror + adapt) — §the-Dependencies-table-encodes-relationship-strength-not-just-relationship-presence**.

## §The "this document references that surface rather than duplicating it" discipline

Lines 45-48:
> *The bus/verb surface required to carry TUI traffic — including the debugger protocol frames — is a sibling design, [endor-bus-tui](endor-bus-tui.md). This document references that surface rather than duplicating it.*

§First-explicit-observation in library: **§the-explicit-non-duplication-promise-as-named-design-discipline — §when-two-designs-could-share-a-substrate-description, §one-of-them-explicitly-defers-to-the-other-rather-than-duplicating + §the-deferral-IS-named-in-prose-at-the-design's-introduction**.

§Sibling-pattern to cycle 261's substrate-Use-Cases-omission — §two-cycles-with-explicit-non-duplication-discipline (261 substrate-defers-to-derivative + 269 derivative-defers-to-substrate).

§the-relationship-IS-symmetric — §each-design-can-defer-to-the-other-depending-on-which-aspect-is-being-documented + §the-deferral-IS-the-named-discipline-not-the-direction.

## §"endor tui is a separate process, not embedded in the daemon" — three properties

Design Decision 8 names §three-properties-of-the-process-separation:

1. **Multiple TUIs can attach at once** — §the-bus-IS-multi-client-already + §the-TUI-doesn't-need-to-be-singleton.
2. **A TUI crash cannot take down the daemon** — §process-isolation-IS-a-named-reliability-property + §the-daemon-IS-the-system's-availability-anchor.
3. **Remote operation over SSH works without proxying** — §the-SSH-endpoint-IS-the-bus-client + §the-TUI-runs-locally-on-the-SSH-endpoint.

§First-explicit-observation in library: **§three-properties-of-process-separation-as-named-architectural-rationale (multi-client + isolation + remote-via-SSH-no-proxy)**.

## §The Known Gaps section uses `- [ ]` checklist items per the CLAUDE.md spec

Lines 840-857: §two-checklist-items in the Known Gaps section, each marked `- [ ]`:
- Decide bespoke vs. `termimad` Markdown renderer once `chat-markdown-render.md` settles.
- Research whether XS has a protocol verb for pause-on-request.

§the-Known-Gaps-section-honors-the-CLAUDE.md-spec's-`- [ ]`-checklist-convention — cycle 265 noted this convention at the spec level; cycle 269 observes the instance-level honoring.

§First-explicit-observation in library: **§the-Known-Gaps-checklist-discipline-honored-at-the-instance-level — §cycle-265's-spec-prescription + §cycle-269's-instance-honoring + §two-cycles-of-spec-and-instance-alignment-at-the-checklist-discipline**.

## §The Prompt appendix — per the CLAUDE.md spec

Line 857: `## Prompt` heading appears. §the-design-honors-the-CLAUDE.md-spec's-Prompt-section-at-the-end — §the-LLM-collaboration-record-IS-present + §the-spec-and-the-instance-agree-at-this-discipline-too; §three-cycles-with-spec-and-instance-loops-closed-or-aligned (263 fragment-deviates + 265 spec-prescribes + 267 README-instantiates + 269 design-honors-Prompt-section); §four-cycles-with-spec-and-instance-discipline-alignment (counting cycle 269 as a fourth instance).

## §Cycle 269 first-explicit-observations roundup (twelve)

1. **§the-template-IS-instantiated-completely-with-all-seven-sections-and-the-Prompt-appendix**.
2. **§two-co-equal-halves-as-named-design-shape** (Chat + Debugger).
3. **§the-three-motivation-convergence-pattern**.
4. **§the-named-evolution-of-a-system's-purpose-as-design-rationale** (Chat-becoming-the-debugger-of-last-resort).
5. **§reuse-protocol-but-not-implementation-as-named-platform-decoupling-discipline**.
6. **§eleven-numbered-Design-Decisions-IS-the-richest-Design-Decisions-section-cycle-ingested-so-far**.
7. **§two-named-Design-Decision-rationale-shapes** (`X-over-Y-because-Z` for comparative + `X-because-Y` for positive).
8. **§twelve-row-Dependencies-table-IS-the-highest-fan-in-observed-in-any-design**.
9. **§mirrors-X-exactly-as-named-state-machine-equivalence-discipline-in-a-Dependencies-table**.
10. **§two-named-relationship-strengths-in-the-cluster-graph** (strict-mirror + adapt).
11. **§the-debugger-mediation-discipline** — daemon mediates debugger traffic; TUI speaks only bus verbs.
12. **§daemon-durable-breakpoints-as-named-persistence-discipline**.

Plus: §debugger-opt-in-per-worker-with-greyed-out-state-as-evidence-of-non-debuggability + §the-twelve-subsection-Chat-TUI-section-IS-a-direct-projection-from-the-twelve-chat-cluster-designs + §the-explicit-non-duplication-promise-as-named-design-discipline + §three-properties-of-process-separation-as-named-architectural-rationale + §the-Known-Gaps-checklist-discipline-honored-at-the-instance-level + §the-"foundational"-marker-on-Phase-1-as-named-rationale-for-phase-ordering.

## §Recurring meta-pattern counters bumped at cycle 269

- §**four-cycles-with-spec-and-instance-discipline-alignment** (263 + 265 + 267 + 269).
- §**three-cycles-with-protocol-reuse-but-implementation-rewrite** (245 panic + 246 lockdown + 269 xsbug).
- §**two-cycles-with-explicit-non-duplication-discipline** (261 substrate-defers-to-derivative + 269 derivative-defers-to-substrate).
- §**fifteen-design-docs-from-endo-but-for-bots-designs-cluster-ingested** (cycle 267's count + the endor-tui design).
- §**one-hundred-and-second consecutive designs-chat alternation cycles 166-250 + 252-269** (251 was out-of-band).

## §Synthesis target — slot machine library

§The-canonical-design-doc-template-instantiation applies to the §game-engine-rule-cluster:

- §**game-engine-TUI** design as §two-co-equal-halves (Game + Replay-Debugger) — §the-discipline-IS-name-the-halves-when-the-design-encompasses-two-substantially-different-feature-sets.
- §**three-motivation-convergence** for §game-engine-TUI: §game-IS-becoming-the-replay-tool-of-last-resort + §existing-replay-tool-IS-platform-bound + §Rust-crates-make-game-TUI-cheap.
- §**Adopt game-state-protocol but not implementation** — when an existing tool's protocol is sufficient but its UI is platform-bound.
- §**Daemon-mediates-replay-traffic** + §game-TUI-speaks-only-bus-verbs — for capability-based access control on game state.
- §**Daemon-durable-game-breakpoints** — a developer's "I set a game-rule breakpoint here" survives TUI restarts.
- §**Twelve-row Dependencies table** for the game-engine-TUI projecting from the game cluster.
- §**Eleven numbered Design Decisions** documenting the game-TUI's rationale comprehensively.

## §Tier-1 borrowing

§the-template-IS-instantiated-completely-with-all-seven-sections-and-the-Prompt-appendix + §two-co-equal-halves-as-named-design-shape + §the-three-motivation-convergence-pattern + §the-named-evolution-of-a-system's-purpose-as-design-rationale + §reuse-protocol-but-not-implementation-as-named-platform-decoupling-discipline + §eleven-numbered-Design-Decisions-IS-the-richest-Design-Decisions-section + §two-named-Design-Decision-rationale-shapes + §twelve-row-Dependencies-table-IS-the-highest-fan-in-observed + §mirrors-X-exactly-as-named-state-machine-equivalence-discipline + §two-named-relationship-strengths-in-the-cluster-graph + §the-debugger-mediation-discipline + §daemon-durable-breakpoints-as-named-persistence-discipline.

## §Tier-2 borrowing

§debugger-opt-in-per-worker-with-greyed-out-state + §the-twelve-subsection-Chat-TUI-section-IS-a-direct-projection-from-the-twelve-chat-cluster-designs + §the-explicit-non-duplication-promise-as-named-design-discipline + §three-properties-of-process-separation-as-named-architectural-rationale + §the-Known-Gaps-checklist-discipline-honored-at-the-instance-level + §the-"foundational"-marker-on-Phase-1-as-named-rationale-for-phase-ordering.

## §Tier-3 borrowing

§four-cycles-with-spec-and-instance-discipline-alignment (263 + 265 + 267 + 269) + §three-cycles-with-protocol-reuse-but-implementation-rewrite (245 + 246 + 269) + §two-cycles-with-explicit-non-duplication-discipline (261 + 269) + §fifteen-design-docs-from-endo-but-for-bots-designs-cluster-ingested + §library-reaches-775-sections at cycle 269 + §one-hundred-and-second consecutive designs-chat alternation cycles 166-250 + 252-269.

## Pattern summary (tag-prefixed)

§the-canonical-design-doc-template-instantiation + §two-co-equal-halves-Chat-plus-Debugger + §three-motivation-convergence + §the-named-evolution-of-a-system's-purpose-as-design-rationale (Chat-becoming-the-debugger-of-last-resort) + §reuse-protocol-but-not-implementation-as-named-platform-decoupling-discipline (mxDebug-protocol-reused; xsbug-tool-replaced) + §eleven-numbered-Design-Decisions + §two-named-Design-Decision-rationale-shapes (`X-over-Y-because-Z` + `X-because-Y`) + §twelve-row-Dependencies-table-IS-the-highest-fan-in-observed + §mirrors-X-exactly-as-named-state-machine-equivalence-discipline + §two-named-relationship-strengths-in-the-cluster-graph (strict-mirror + adapt) + §the-debugger-mediation-discipline (daemon-mediates + TUI-speaks-only-bus-verbs) + §capability-based-access-control-on-debugger-attach + §daemon-durable-breakpoints + §debugger-opt-in-per-worker-with-greyed-out-state + §six-numbered-Phases + §the-"foundational"-marker-on-Phase-1 + §the-twelve-subsection-Chat-TUI-section + §the-explicit-non-duplication-promise + §three-properties-of-process-separation + §the-Known-Gaps-checklist-discipline-honored + §the-Prompt-appendix-honored + §four-cycles-with-spec-and-instance-discipline-alignment.
