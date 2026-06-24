---
kind: result
role: liaison
host: endolin
timestamp: 2026-06-10T16:09:06Z
dispatch-root: dispatches/liaison--943a8f
cycle: 271
lane: designs
---

# librarian cycle 271 result — designs-lane endor-bus-tui.md

Ingested `endojs/endo-but-for-bots:designs/endor-bus-tui.md` (1148 lines, scoped to structural-pattern observations). **The worker-facing complement to cycle 269's endor-tui.md** — closes a design-to-design dual. Library now at **777 sections** across **318 source documents**.

## §The single most structurally interesting move

§The-host-side-and-the-worker-side-of-the-same-subsystem-as-two-separate-designs-each-deferring-to-the-other:

| Cycle | Side                | Design                                    |
|-------|---------------------|-------------------------------------------|
| 269   | Host (user-facing)  | `endor-tui.md` (Chat + Debugger panes)    |
| 271   | Worker (worker-facing)| `endor-bus-tui.md` (bus verbs + XS handles + Exo wrapper) |

§Each design explicitly defers to the other. §Two-cycles-with-symmetric-non-duplication-discipline (269 + 271; both directions of the deferral promise observed in the same week). §Six-cycles-with-spec-and-instance-or-validator-and-constructor-or-host-and-worker-discipline-alignment (263 + 265 + 267 + 269 + 270 + 271).

## §First-explicit-observations from cycle 271 (twelve)

1. §the-host-side-and-the-worker-side-of-the-same-subsystem-as-two-separate-designs-each-deferring-to-the-other.
2. §the-capability-mediated-TUI-architecture (worker declares; daemon renders; events flow other direction).
3. §five-named-non-exposures-as-named-confinement-discipline-for-XS-workers.
4. §the-"this-is-by-design"-acknowledgment-as-named-design-motivation.
5. §three-layers-not-one-as-named-design-rationale (bus verbs + XS handles + Exo wrapper).
6. §a-decision-that-rules-out-two-alternatives-before-naming-the-chosen-approach (X-over-Y-and-Z-because-W).
7. §state-at-the-daemon-verbs-at-the-worker.
8. §named-reference-to-an-existing-pattern-as-design-rationale-rather-than-inventing-a-new-discipline.
9. §deterministic-ID-discipline (line numbers, not pointers).
10. §abstraction-over-renderer-as-named-design-discipline (regions, not raw terminal access).
11. §five-named-`@`-prefix-system-pet-names-listed-in-one-place + §the-cluster-now-has-six (counting `@tui-screen`).
12. §named-escape-hatch-for-when-the-abstraction-doesn't-fit (Canvas regions).

Plus: §the-no-fighting-for-foreground-discipline + §three-named-failure-modes-as-first-class-error-codes + §the-Dependencies-table-size-correlates-with-the-design's-fan-in-not-its-complexity + §seven-named-Known-Gaps + §two-cycles-with-host-side-and-worker-side-as-named-design-pair + §two-cycles-with-symmetric-non-duplication-discipline.

## Recurring meta-pattern counters bumped

- §**six-cycles-with-spec-and-instance-or-validator-and-constructor-or-host-and-worker-discipline-alignment** (263 + 265 + 267 + 269 + 270 + 271).
- §**two-cycles-with-host-side-and-worker-side-as-named-design-pair** (269 + 271).
- §**two-cycles-with-symmetric-non-duplication-discipline** (269 + 271).
- §**two-cycles-with-daemon-mediates-X-where-X-IS-a-platform-resource** (269 debugger-traffic + 271 TUI-rendering-and-events).
- §**three-cycles-with-named-non-exposures-as-design-feature-not-limitation** (259 Page + 261 HttpClient + 271 XS-worker).
- §**three-cycles-with-named-`@`-prefix-system-pet-name-convention** (250 + 257 + 271).
- §**sixteen-design-docs-from-endo-but-for-bots-designs-cluster-ingested**.
- §**one-hundred-and-fourth consecutive designs-chat alternation cycles 166-250 + 252-271** (251 was out-of-band).

## Synthesis target

Slot machine library §game-engine-display (host side) + §game-engine-bus-display (worker side); §capability-mediated-game-display; §three-layers (bus verbs + JS handle API + Exo CapTP wrapper); §named non-exposures for game-rule-workers; §deterministic-ID-discipline for game-events that may scroll out; §abstraction-over-renderer; §canvas-regions-as-escape-hatch for cell-level game-rule rendering; §no-fighting-for-foreground.

## Files

- `journal/library/sections/endo-but-for-bots--llm-designs-endor-bus-tui--worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-daemon-verbs-at-worker.md`
- `journal/library/sources/endo-but-for-bots--llm-designs-endor-bus-tui.md`
- `journal/library/sections/README.md` — new row inserted; Total: 776 → 777; sources: 317 → 318.
- `journal/library/sources/README.md` — new row inserted above cycle 270's row.
- `journal/library/keywords.md` — 30 new keyword entries; `library-reaches-777-sections at cycle 271` counter row.
- `journal/inboxes/endolin/scholar.md` — drain marker bumped `pending-cycle-270` → `pending-cycle-271`.

## Next cycle

Cycle 272 will be chat-lane (continuing the alternation).
