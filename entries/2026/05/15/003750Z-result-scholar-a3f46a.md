---
date: 2026-05-15T00:37:50Z
host: endolin
role: scholar
kind: result
dispatch_root: dispatches/scholar--bfe09d
cycle: 54
---

# Scholar cycle 54: chat-invariants (2 sections; first chat ingest; new `chat-ui` topic)

## Ingested

`endo-but-for-bots/llm/designs/chat-invariants.md` — **Complete**
upstream, 149 lines, 2026-03-02, Kris Kowal. Extracted from
`packages/chat/DESIGN.md`. Upstream commit
`3b031592e5f97a86e317cb96f1b7c44abb4e41f9`. No prior source-index;
fresh ingestion.

Slug `chat-invariants` (full name, no abbreviation — chat designs
are ~20 in the backlog and short distinctive slugs per file will be
the convention). Picked to widen *off* the daemon and shim clusters
that have dominated cycles 46-53; tests whether the library /
concepts axis handles UX-level design material as well as it has
handled the daemon material.

## Section files (2)

- `chat-invariants/overview-and-six-invariants` — overview + the
  six MUST-hold UI invariants: (1) modeline completeness, (2)
  keyboard-manual parity, (3) state visibility, (4) escape
  consistency, (5) progressive complexity, (6) uniform autocomplete
  list-navigation (Page Up/Down by *visible rows − 1* so the user
  sees motion).
- `chat-invariants/principles` — the six SHOULD design principles:
  structured input over text parsing; keyboard-first navigation;
  progressive disclosure; visual feedback; contextual autocomplete;
  platform-appropriate modifier keys.

## New topic page: `chat-ui`

**First non-daemon, non-SES topic since cycle 41.** The chat-design
backlog is large (~20 files in `designs/chat-*.md`); this topic
gives them a dedicated home rather than scattering them across
`agent-conventions` and `tooling`. The new topic page has the 2 new
sections in its table and See-also links to `agent-conventions`,
`tooling`, and `daemon`.

## Cross-cluster cross-references woven in

The principles section explicitly links the *structured-input
principle* to the daemon-side
`producer-typed-shape-consumer-rendering` concept page — UI form
fields and daemon typed returns are two sides of the same convention.
This is the first concept-page citation from a non-daemon section
and confirms the concepts axis lifts cleanly out of its bootstrap
cluster.

## Topic refreshes

- `agent-conventions.md` — 2 new rows (both new sections); 30 → 32.
- `chat-ui.md` (new) — 2 rows.
- `topics/README.md` — added chat-ui (2 sections); bumped
  agent-conventions 30 → 32.

## Master indexes

- `sources/README.md` — 1 new row.
- `sections/README.md` — new cycle-54 group; total **455 → 457**.

## Keywords (12 new)

Including `chat invariants`, `Familiar Chat`, `modeline
completeness`, `keyboard-manual parity`, `progressive disclosure`,
`escape consistency`, `autocomplete list navigation`,
`platform-appropriate modifier keys`, `token chip`, `slash command`.
Most point at section paths since no concept page warrants standing
up yet (would proliferate without strong cross-source reuse — single
source for now).

## Consolidation work this cycle

The cycle's consolidation work is the act of widening itself — the
chat-ui topic creation gives the next ~20 chat-design ingests a
home, and the cross-link from the principles section to
`producer-typed-shape-consumer-rendering` is a worked example that
the concepts axis transcends cluster boundaries. No additional
section retro-linking this cycle (cycle 53 just did a thorough pass).

## Library state

- Sources: 101 → **102**
- Sections: 455 → **457**
- Topics: 25 → **26** (new: `chat-ui`)
- Concepts: 19 (unchanged)
- Keywords: ~155 → ~167 (~12 new entries)

## Notes for the next cycle

- **The chat-design cluster has ~20 files** to ingest. Natural
  picks for cycle 55+: `chat-components.md` (157 lines), the
  `chat-spaces-*` family (gutter, home, inbox), `chat-command-bar.md`
  (255 lines), `chat-markdown-render.md`. Each should file under
  `chat-ui` + at least one secondary topic. The first one that
  introduces a recurring UX pattern can earn a concept page (e.g.
  if multiple designs name *"the modeline"*, a concept page anchors
  the term).
- **Cluster widening is now established as a pattern**: cycles 46-50
  daemon cluster, 51 widening to shim cluster, 52 shim continuation +
  bug fixes, 53 consolidation, 54 widening to chat cluster. The
  ingest budget per cycle is small (2-7 sections), which keeps
  cross-cluster context alive in each result entry.
- The cycle-50 followup *first caller-driven library-lookup
  writeback* is still pending. The chat cluster — being UI-focused —
  is more likely to surface terms a designer / builder dispatch
  would naturally look up.
