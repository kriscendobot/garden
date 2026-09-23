---
title: "endor-bus-tui.md — Endor Bus TUI (Worker-Programmable Terminal UI), the worker-facing complement to endor-tui"
source-slug: endo-but-for-bots--llm-designs-endor-bus-tui
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endor-bus-tui.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endor-bus-tui.md
total-lines: 1148
ingest-cycle: 271
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
---

# `endor-bus-tui.md`

A 1148-line design (Status Not Started; Created 2026-04-23). **Closes a design-to-design dual with cycle 269's `endor-tui.md`**: that design was the host-facing side; this design is the worker-facing side. Both explicitly defer to each other.

## Key moves

- **§The host side and the worker side as two separate designs each deferring to the other** — §two-cycles-with-symmetric-non-duplication-discipline (269 + 271; both directions of the deferral promise observed in the same week).
- **§The capability-mediated TUI architecture** — worker declares what it wants to render; daemon produces the actual ANSI bytes; events flow the other direction (daemon decodes; worker reacts).
- **§Five named non-exposures** as named confinement discipline for XS workers — no FD they weren't given + no stdout + no controlling terminal + no TTY size/mode + no ANSI escapes.
- **§The "this-is-by-design" acknowledgment** — *"confinement is the whole point"*.
- **§Three layers, not one** — bus protocol verbs (wire) + XS handle API (local) + Exo CapTP wrapper (capability model); §each layer solves a different problem.
- **§A decision that rules out two alternatives before naming the chosen approach** — X-over-Y-and-Z-because-W rationale shape.
- **§State at the daemon, verbs at the worker** as named source-of-truth discipline — imperative verbs (setText, appendLines, etc.); daemon keeps full state for reattach.
- **§Named reference to an existing pattern as design rationale** — *"This mirrors the existing message-hub pattern where the daemon is the source of truth"*.
- **§Deterministic-ID discipline** — line numbers, not pointers, for buffer edits; survives scrollback eviction; eviction-error-as-protocol.
- **§Abstraction over renderer** — regions, not raw terminal access; three named alternative renderers (Windows console + tmux control mode + remote web terminals).
- **§Named escape hatch for when the abstraction doesn't fit** — Canvas regions provide cell-level control without reintroducing ANSI; abstract cell format `{char, fg, bg, attrs}`.
- **§The no-fighting-for-foreground discipline** — *"Agents do not fight for foreground"*; the daemon owns stacking.
- **§Three named failure modes as first-class error codes** — `window-revoked` + `screen-lost` + `wrong-role`; the `whenRevoked` dedicated promise for racing against the main loop.
- **§Five named `@`-prefix system pet names listed in one place** — `@agent` + `@self` + `@host` + `@keypair` + `@mail`; plus `@tui-screen` as the sixth member of the convention.
- **§Ten numbered Design Decisions + five numbered Phases + four-row Dependencies table + seven-named Known Gaps**.

## Closing-the-pair: design-to-design loops

| Cycle | Side                | Design                                    |
|-------|---------------------|-------------------------------------------|
| 269   | Host (user-facing)  | `endor-tui.md` (Chat + Debugger panes)    |
| 271   | Worker (worker-facing)| `endor-bus-tui.md` (bus verbs + XS handles + Exo wrapper) |

§Each-design-explicitly-defers-to-the-other; §two-cycles-with-host-side-and-worker-side-as-named-design-pair (269 + 271); §six-cycles-with-spec-and-instance-or-validator-and-constructor-or-host-and-worker-discipline-alignment (263 + 265 + 267 + 269 + 270 + 271).

## Section files

- [§Worker-facing complement to endor-tui + §three-layer architecture (bus verbs + XS handles + Exo wrapper) + §capability-mediated TUI + §state-at-daemon-verbs-at-worker](../sections/endo-but-for-bots--llm-designs-endor-bus-tui--worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-daemon-verbs-at-worker.md) — structural pattern observations (1148-line file ingested in pattern-scope).

## Ingest scope

Cycle 271 (designs-lane after cycle 270's chat-lane makeTagged.js). 1148-line file ingested in pattern-scope. **First-explicit-observations (twelve)**: the-host-side-and-the-worker-side-of-the-same-subsystem-as-two-separate-designs-each-deferring-to-the-other + the-capability-mediated-TUI-architecture + five-named-non-exposures-as-named-confinement-discipline-for-XS-workers + the-"this-is-by-design"-acknowledgment + three-layers-not-one-as-named-design-rationale + a-decision-that-rules-out-two-alternatives-before-naming-the-chosen-approach + state-at-the-daemon-verbs-at-the-worker + named-reference-to-an-existing-pattern-as-design-rationale + deterministic-ID-discipline + abstraction-over-renderer + five-named-`@`-prefix-system-pet-names-listed-in-one-place + named-escape-hatch-for-when-the-abstraction-doesn't-fit.
