# Scholar: identify the through-lines in change propagation

Wear the **scholar** role (`roles/scholar/AGENT.md` — the library curator; if it has
not finished translating into v2, translate from `v1/roles/scholar/AGENT.md` first).
Identify and curate the **through-lines in change propagation** running through the
garden's recent and in-flight work, and capture them in the library
(`journal/library/`).

## The thread to pull

A cluster of recent work is converging on **change propagation** — how a change in
one place is incrementally and reliably reflected elsewhere, between data structures
and between agents. Synthesize the unifying concepts across (at least):

- **FRB** (functional reactive bindings; the forked `kriskowal/frb`) — operators and
  observers as incremental change propagation; see the in-flight
  `research-frb-endo-exo-collections` investigation (Endo/Exo reactive collections,
  the splay-tree / sorted-array-set interface, **sliding-window topics over an
  ordered collection**).
- **@endo/pubsub** (PR #513 — Sink/Spring async promise linked list, "changes" +
  "latest" variants) and the broader **pubsub-topics** work — topics as change
  streams; the changes-vs-latest duality.
- **Propagators** — constraint/dataflow propagation; how it relates to the reactive
  and pubsub models above.
- Adjacent: how these support **synchronization between agents** (queries +
  subscribers), and any earlier garden/endo designs on the same theme.

## What to produce

- **Identify the through-lines**: the shared abstractions and tensions — e.g.
  incremental vs full recomputation; push vs pull; "changes" (deltas/streams) vs
  "latest" (current value); ordered-collection windows as derived topics; idempotent
  convergence; how propagators, FRB observers, and pubsub topics are three faces of
  the same change-propagation idea; where they differ and why.
- **Curate library entries** for these through-lines per the library's conventions
  (`journal/library/{concepts,sections,topics}`, `conventions.md`) — concept pages
  for the unifying ideas, cross-linked to the relevant designs/PRs/research, so the
  connections are discoverable for future design and build work.
- **A short synthesis** naming the through-lines and the open questions, surfaced to
  the maintainer (a `message-user` summary so it reaches the bulletin), with the full
  curation in the library.

## Norms

- Ground every claim in the actual source (the forked FRB, the endo pubsub package /
  #513, the propagators material, the FRB/Endo-Exo research) — cite what you read; do
  not theorize from memory. Read-only on the source repos; write to the library on
  `journal2`. Scope is the garden's own library + public/bot-accessible source.

## Definition of done

Library entries capturing the change-propagation through-lines (FRB ↔ pubsub topics ↔
propagators, with the changes/latest and sliding-window-topic threads), cross-linked
to the relevant work, plus a synthesis surfaced to the maintainer via the bulletin.
Report what was curated and the through-lines identified. If a key relationship can't
be grounded in source, say so rather than asserting it.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 54
  claimed_at: 2026-06-24T23:07:21Z
