---
ts: 2026-06-25T15:08:01Z
kind: result
role: scholar
project: endo
refs:
  - jobs/doin/scholar-continue-change-propagation.md
---

# Scholar cycle: continue the change-propagation curation (maintainer-endorsed)

Continued the change-propagation library curation per the maintainer-endorsed open
questions (`scholar-through-lines-change-propagation`, maintainer msg
`20260624T231841Z-f0e8dc`). Grounded every claim in source; flagged what could not
be grounded; cited everything.

## Sources ingested (2 new, both from unmerged PR branches)

- **`@endo/pubsub` README** (`packages/pubsub/README.md`, PR #513 `feat/endo-pubsub`,
  file-commit `d15e34cb`, 4 sections): `endo-but-for-bots--pkg-pubsub-readme`. The two
  topic factories (`makeChangeTopic` / `makeLatestTopic`), the sink/spring
  decomposition, the Reader/Writer termination contract, and the cancellation /
  layering / provenance close.
- **`notifier-pubsub-migration` design** (`designs/notifier-pubsub-migration.md`,
  PR #507 `design/notifier-pubsub-migration`, revision 5, file-commit `8c2a46be`,
  8 sections): `endo-but-for-bots--llm-designs-notifier-pubsub-migration`. Problem +
  local-layer reorientation; asymmetric passability; vocabulary + layering; local
  pubsub foundations; exo-pubsub topic-facet adapters; exo-pubsub publisher-facet
  adapters; back-pressure + wire protocol; cross-design coordination + compatibility;
  future evolution toward FRB collection-change propagation.

Both recorded with `source_pr` / `source_pr_state` and an unmerged-PR `notes:` lifecycle
block (re-check the PR head; re-ingest on force-push; rewrite branch on merge; mark
stale on close-without-merge) per `library/conventions.md` § Sources from unmerged PRs.

## Honesty flags raised by the new sources

- **`makeCancelKit` is NOT an `@endo/pubsub` export.** Commit `d15e34cb` ("drop
  bundled cancel-kit and barrel index per review") removed the bundled cancel kit and
  the barrel index; its home is now `@endo/cancel` (a prerequisite package not yet on
  `llm`). The prior `endo-pubsub` concept page asserted `makeCancelKit` / `nullSink` /
  `nullSpring` as package exports — corrected on the concept page, in Common confusions,
  and in `keywords.md`.
- **Factory-name divergence between #513 and #507.** The implementation names its
  factories `makeChangeTopic` / `makeLatestTopic` returning `{ publisher, subscribe }`;
  the design names them `makeChangesPubSub` / `makeLatestPubSub` returning
  `{ sink, makeSpring, finish, fail }`. Unreconciled as of 2026-06-25; both forms
  recorded from source and flagged for the next cycle.
- **Propagators stay partially-grounded.** Left the existing propagator honesty flag in
  `concepts/change-propagation.md` fully intact (FRB two-way bindings are the one
  in-corpus multi-directional-constraint instance; the Sussman/Radul lattice-merge
  propagator model is adjacent EXTERNAL lineage, never asserted from a garden source).
  The `research-frb-endo-exo-collections` draft independently confirmed no propagator
  artifact exists in the corpus.

## Concepts deepened

- **`endo-pubsub`**: corrected the cancel-kit claim; updated revision-4→revision-5;
  added the full adapter set, the `@endo/cancel` gating, the latest-always-replays
  decision, the hot/cold variants; replaced the "not yet ingested as sources" note with
  the 15-row ingested-section table; expanded aliases and Common confusions.
- **`sliding-window-topic`** (direction 2): folded in the landed
  `research-frb-endo-exo-collections` findings (the ordered-set observable contract;
  `SortedSet` splay tree vs `SortedArraySet` sorted array; `makeViewObserver`'s
  five-branch splicer; the proposed `makeWindowTopic` operator with `query()` pull +
  `subscribe()` push; the SES-cleanliness gap) and wired the now-ingested design
  future-evolution section as a proper source citation. Flagged `makeWindowTopic` as
  proposed (draft-for-maintainer-triage), not shipped API.
- **`change-propagation`**: added the README + design sections to the section table,
  mapped onto the existing through-lines (producer/consumer dual, changes-vs-latest,
  idempotent-convergence-vs-order-significance, windows-as-derived-topics). Propagator
  flag untouched.

## Indexes updated

`sources/README.md` (2 new rows with the unmerged-PR + naming-divergence flags),
`topics/change-propagation.md` (13 new section rows), `topics/streams.md` (8 new section
rows + a change-propagation See-also), `keywords.md` (fixed 3 stale "open question: not
in library" entries for `makeChangeTopic` / `makeLatestTopic` / `makeUpdateTopic`; added
~20 grep entry points for the adapters, hot/cold, `@endo/cancel`, `makeWindowTopic`, the
ordered-set contract). Left the generator-maintained flat `sections/README.md` to its
generator (precedent from the gtor cycles).

## Directions 3 and 4

- **gtor ingest (direction 3):** already complete. The gtor README is fully ingested
  (9 sections across 3 cycles; `scholar-ingest-gtor` and `scholar-ingest-gtor-recap`
  both in `tada/`), including the Promise Queues/Buffers async-linked-list substrate the
  job named as priority. No remainder to chase; no follow-on needed.
- **Through-lines (direction 4):** deepened in place via the ingested sources; honesty
  flags preserved.

## Pending upstream stabilization (follow-on jobs posted)

- `scholar-reingest-pubsub-on-stabilize` — when #513 merges (or #507 lands its design),
  re-check both PR heads, re-ingest changed parts, reconcile the factory-name
  divergence, and flip the source frontmatter from unmerged-PR to default-branch shape.

Self-improvement: see report.
