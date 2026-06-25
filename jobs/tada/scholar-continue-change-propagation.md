The follow-on was claimed immediately by another gardener (now in `doin`); its body carries the idempotency re-check so that gardener will skip or re-post if the PRs haven't moved. Everything is verified on `origin/journal2`. Here is my completion report.

---

# scholar-continue-change-propagation — complete

Continued the maintainer-endorsed change-propagation curation as the scholar. Grounded every claim in source, flagged what could not be grounded, cited everything. All library writes are on `origin/journal2` (commit `b4eaa529`); the job is in `tada/`.

## What I did

**Direction 1 — ingested the two missing pubsub sources** (both still on unmerged PR branches, recorded with `source_pr` / `source_pr_state` and the unmerged-PR lifecycle `notes:` block per `conventions.md`):
- `endo-but-for-bots--pkg-pubsub-readme` — the `@endo/pubsub` README (PR #513 `feat/endo-pubsub`, file-commit `d15e34cb`), 4 sections.
- `endo-but-for-bots--llm-designs-notifier-pubsub-migration` — the design (PR #507 `design/notifier-pubsub-migration`, **revision 5**, file-commit `8c2a46be`), 8 sections (problem + local-layer reorientation; asymmetric passability; vocabulary + layering; local pubsub foundations; exo-pubsub topic-facet adapters; exo-pubsub publisher-facet adapters; back-pressure + wire protocol; cross-design coordination + compatibility; future evolution toward FRB collection-change propagation).

**Direction 2 — folded the FRB Endo/Exo research into `sliding-window-topic`.** The `research-frb-endo-exo-collections` job had already landed (draft `projects/endo/drafts/frb-reactive-exo-collections.md`); wired its findings into the concept (the ordered-set observable contract; `SortedSet` splay tree vs `SortedArraySet` sorted array; `makeViewObserver`'s five-branch splicer; the proposed `makeWindowTopic` with `query()` pull + `subscribe()` push; the SES-cleanliness gap) plus the now-ingested design future-evolution section. Flagged `makeWindowTopic` as proposed (draft-for-maintainer-triage), not shipped.

**Direction 3 — gtor:** already fully ingested (9 sections; `scholar-ingest-gtor` and `-recap` both in `tada/`, including the Promise Queues/Buffers substrate the job prioritized). No remainder; no follow-on needed.

**Direction 4 — through-lines deepened** in place via the new sources, honesty flags preserved.

## What changed

- **2 honesty corrections forced by source:** (1) `makeCancelKit` is **not** an `@endo/pubsub` export — the bundled cancel kit + barrel index were dropped per review (commit `d15e34cb`); its home is `@endo/cancel`, a prerequisite package not yet on `llm`. The prior `endo-pubsub` concept page wrongly asserted it as a package export; corrected on the concept page, in Common confusions, and in `keywords.md`. (2) **Factory-name divergence**: #513 uses `makeChangeTopic`/`makeLatestTopic` + `{ publisher, subscribe }`; #507 uses `makeChangesPubSub`/`makeLatestPubSub` + `{ sink, makeSpring, finish, fail }` — both recorded from source and flagged.
- **Propagator flag preserved intact** (FRB two-way bindings the one in-corpus multi-directional instance; Sussman/Radul lattice-merge model cited as external lineage, never asserted from a garden source). The research independently confirmed no propagator artifact in the corpus.
- **Concepts:** `endo-pubsub`, `sliding-window-topic`, `change-propagation` updated.
- **Indexes:** `sources/README.md` (+2 rows with flags), `topics/change-propagation.md` (+13), `topics/streams.md` (+8), `keywords.md` (fixed 3 stale "not in library" entries; +~20 grep entry points). Generator-maintained flat `sections/README.md` left to its generator.
- **Bulletin synthesis** delivered to the maintainer inbox (`20260625T150946Z-9ec67f`).

## Follow-ups

- Posted `scholar-reingest-pubsub-on-stabilize` (already claimed by another gardener; in `doin/`): re-check both PR heads, re-ingest changed parts, reconcile the factory-name divergence, ingest `@endo/cancel` if it lands, and upgrade the `sliding-window-topic` citations if the FRB research is promoted to a landed design.

## Self-improvement

The library corpus uses em-dashes pervasively despite `skills/em-dash-style`; I matched the corpus voice for sibling consistency, but the skill and the library have drifted — a reconciliation call for the liaison, not something I land.
