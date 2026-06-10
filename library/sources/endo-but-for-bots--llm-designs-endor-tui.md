---
title: "endor-tui.md — Endor Terminal User Interface (Rust TUI for the forward-looking Rust daemon)"
source-slug: endo-but-for-bots--llm-designs-endor-tui
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endor-tui.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endor-tui.md
total-lines: 887
ingest-cycle: 269
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
---

# `endor-tui.md`

An 887-line **Not Started** design (Created 2026-04-23) for the Rust TUI that bundles with the forward-looking Rust `endor` daemon. **The largest fully-template-following design ingested** and the most-fanned-in (twelve-row Dependencies table).

## Key moves

- **§Canonical design-doc-template instantiation** — all seven sections present (Status absent because Not Started; Problem + Design + Dependencies + Phased + Decisions + Gaps + Prompt all present); §four-cycles-with-spec-and-instance-discipline-alignment (263 + 265 + 267 + 269).
- **§Two co-equal halves named at the top** — Chat (keyboard-driven analogue of `packages/chat/`) + Debugger (interactive stepping debugger for Moddable XS workers).
- **§The three-motivation convergence pattern** — Chat-becoming-the-debugger-of-last-resort + `xsbug`-not-viable-because-macOS-only-Xojo + Rust-crates-make-TUI-cheap.
- **§The named evolution of a system's purpose as design rationale** — Chat was not originally designed for debugging but has become the debugger of last resort; the design acknowledges the evolution.
- **§Reuse-protocol-but-not-implementation as named platform-decoupling discipline** — `mxDebug` protocol reused; `xsbug` tool replaced (Moddable's macOS-only Xojo application). §three-cycles-with-protocol-reuse-but-implementation-rewrite (245 panic + 246 lockdown + 269 xsbug).
- **§Eleven numbered Design Decisions** — the richest Design Decisions section ingested so far.
- **§Two named Design Decision rationale shapes** — `X-over-Y-because-Z` (comparative) + `X-because-Y` (positive).
- **§Twelve-row Dependencies table** — the highest fan-in observed in any design.
- **§Mirrors-X-exactly as named state-machine-equivalence discipline** — `chat-command-bar` and `chat-focus-message` are mirrored exactly; other chat-* designs are adapted; §two-named-relationship-strengths-in-the-cluster-graph (strict-mirror + adapt).
- **§The debugger mediation discipline** — daemon mediates debugger traffic; TUI speaks only bus verbs; capability-based access control (a guest cannot attach to another guest's worker).
- **§Daemon-durable breakpoints as named persistence discipline** — a developer's "I set a breakpoint here" must survive TUI restarts.
- **§Debugger opt-in per worker with greyed-out state** — prevents surprise pauses in production.
- **§The explicit non-duplication promise** — *"This document references that surface rather than duplicating it"*; §two-cycles-with-explicit-non-duplication-discipline (261 + 269).
- **§Three properties of process separation** — multi-client + isolation + remote-via-SSH-no-proxy.
- **§Six numbered Phases** with Phase 1 marked "foundational".
- **§The Known Gaps checklist discipline honored** with `- [ ]` items per the CLAUDE.md spec.
- **§The Prompt appendix honored** per the CLAUDE.md spec.

## Section files

- [§Canonical template instantiation + §two co-equal halves Chat plus Debugger + §adopt XS protocol not invent + §daemon mediates debugger traffic + §breakpoints are daemon-durable](../sections/endo-but-for-bots--llm-designs-endor-tui--canonical-template-instantiation-and-two-co-equal-halves-chat-plus-debugger-and-adopt-XS-protocol-not-invent-and-daemon-mediates-debugger-traffic-and-breakpoints-are-daemon-durable.md) — structural pattern observations (887-line file ingested in pattern-scope).

## Ingest scope

Cycle 269 (designs-lane after cycle 268's chat-lane tagged.js). 887-line file ingested in pattern-scope (structural observations of the design's shape rather than per-subsection enumeration). **First-explicit-observations (twelve)**: the-template-IS-instantiated-completely + two-co-equal-halves-as-named-design-shape + the-three-motivation-convergence-pattern + the-named-evolution-of-a-system's-purpose-as-design-rationale + reuse-protocol-but-not-implementation-as-named-platform-decoupling-discipline + eleven-numbered-Design-Decisions-IS-the-richest-Design-Decisions-section + two-named-Design-Decision-rationale-shapes + twelve-row-Dependencies-table-IS-the-highest-fan-in-observed + mirrors-X-exactly-as-named-state-machine-equivalence-discipline + two-named-relationship-strengths-in-the-cluster-graph + the-debugger-mediation-discipline + daemon-durable-breakpoints-as-named-persistence-discipline.
