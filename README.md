# Garden bulletin

_As of 2026-06-25T14:44:30Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh, with a
journalist's narrative in the Latest section. This page (the journal's README.md)
IS the bulletin; the journal's layout and design narrative lives in [DESIGN.md](DESIGN.md).

## Messages to the maintainer

- `20260624T231841Z-f0e8dc` — from gardener:scholar-through-lines-change-propagation, reply_to `scholar-through-lines-change-propagation` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260624T231841Z-f0e8dc.md)

> Scholar synthesis — the change-propagation through-lines (job scholar-through-lines-change-propagation)
>
> Curated the cross-cutting *theory* the FRB / @endo/pubsub / propagators cluster instantiates, grounded in source (gtor README @ d2a238fc, the already-ingested FRB sections, and the #513/#507 pubsub result entries). New library home: topic `change-propagation` + 4 concept pages, with gtor ingested as the keystone source.
>
> The through-lines:
> 1. One idea, three faces — FRB observers (sync/in-process), @endo/pubsub topics (async/cross-vat), and propagators (multi-directional constraint) all propagate the DELTA, not a snapshot. gtor names the axes they differ on: producer/consumer dual · singular/plural · spatial/temporal · push/pull · broadcast/unicast.
> 2. changes vs latest — lossless order-significant deltas (signal / makeChangeTopic / notifier-lossless) vs lossy convergent current-value (behavior / makeLatestTopic / notifier-lossy). gtor shows they're two faces of one signal (forEach vs next). forward-lossless = changes + one-shot latest snapshot (composition, not a third mechanism) — matches the #507 design's makeUpdateTopic retirement.
> 3. Ordered-collection windows as derived topics — FRB's view(start,length) over a SortedSet is the synchronous precedent for the "collection-change propagation" future direction #507 names for pubsub.
> 4. Core tension: idempotent convergence (latest/behavior/propagator-cell tolerates loss+reordering) vs order-significance (changes/stream — every delta matters).
>
> Honesty flag: propagators are only PARTIALLY grounded in our corpus. The one in-corpus instance of multi-directional constraint propagation is FRB two-way (<->) bindings; the fuller Sussman/Radul lattice-merge propagator model is named as adjacent external lineage, NOT asserted from a garden source. Every concept page flags this.
>
> Open questions surfaced:
> - @endo/pubsub README + designs/notifier-pubsub-migration.md are not yet ingested as library sources (the endo-pubsub concept currently cites journal entries) — worth a follow-on once #513/#507 stabilize.
> - The in-flight Endo/Exo reactive-collections research (splay-tree / sorted-array-set interface) should feed sliding-window-topic's citations when it lands.
> - gtor is a partial ingest (2 keystone sections of ~20); posted scholar-ingest-gtor for the rest (Promise Queues/Buffers — the async-linked-list substrate under pubsub — first).
>
> Full curation on journal2: concepts/{change-propagation,changes-versus-latest,endo-pubsub,sliding-window-topic}, topics/change-propagation, sources/gtor--readme + 2 sections, 51 keyword shortcuts.


## Board
### todo (0)
(none)

### doin (9)
- `endojs-endo-but-for-bots-pr503-95390ef3` — attention directive on endojs/endo-but-for-bots PR #503
- `endojs-endo-but-for-bots-pr513-be1cd0d3` — attention directive on endojs/endo-but-for-bots PR #513
- `endojs-endo-but-for-bots-pr513-gauntlet` — gauntlet directive on endojs/endo-but-for-bots PR #513
- `endojs-endo-but-for-bots-pr519-f2f4c5ca` — attention directive on endojs/endo-but-for-bots PR #519
- `endojs-endo-but-for-bots-pr522-gauntlet` — gauntlet directive on endojs/endo-but-for-bots PR #522
- `finish-ebfb-pr96` — Finish endo-but-for-bots #96 implementation as designed
- `fix-watcher-verb-keyword-false-positive` — fix: comment/mention-watcher verb-keyword false-positive on review subject ma...
- `scholar-ingest-cask-13` — Scholar: continue the library ingest of kriskowal/cask (cycle 14)
- `scholar-ingest-cask` — Scholar: deepen the library ingest of kriskowal/cask

### tada (107)
- `endojs-endo-but-for-bots-pr526-rebase` — Done. Here is my completion report.
- `endojs-endo-but-for-bots-pr519-1d79f1bc` — Completion report: attention directive on endojs/endo-but-for-bots PR #519
- `endojs-endo-but-for-bots-pr519-147aa72c` — Completion report — attention directive on endojs/endo-but-for-bots PR #519
- `endojs-endo-but-for-bots-pr513-af11a4e0` — Completion report — endojs/endo-but-for-bots PR #513, barrel-module directive
- `scholar-ingest-cask-12` — Completion report — job scholar-ingest-cask-12 (scholar, cycle 13)
- … and 102 more

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners

## Recent progress
- 003414Z-error-gardener-2ff8de.md: gardener-30 on endolinbot: job scholar-ingest-cask-13 handler FAILED; output captured as e69de29bb2d1d6434b8b29ae775ad8c2e48c5391, escalated to the gardener inbox, left in doin for the reaper
- 143942Z-progress-gardener-629fb9.md: gardener-81 on endolinbot claimed job endojs-endo-but-for-bots-pr503-95390ef3
- 144005Z-progress-gardener-6ce88e.md: gardener-59 on endolinbot claimed job endojs-endo-but-for-bots-pr513-gauntlet
- 144019Z-progress-gardener-f3a624.md: gardener-27 on endolinbot claimed job endojs-endo-but-for-bots-pr513-af11a4e0
- 144032Z-progress-gardener-f73c68.md: gardener-17 on endolinbot claimed job endojs-endo-but-for-bots-pr519-f2f4c5ca
- 144040Z-progress-gardener-febcfc.md: gardener-87 on endolinbot claimed job endojs-endo-but-for-bots-pr513-be1cd0d3
- 144047Z-progress-gardener-ebc219.md: gardener-21 on endolinbot claimed job endojs-endo-but-for-bots-pr519-1d79f1bc
- 144117Z-progress-gardener-c444d6.md: gardener-6 on endolinbot claimed job endojs-endo-but-for-bots-pr526-rebase
- 144119Z-progress-gardener-86722f.md: gardener-16 on endolinbot claimed job endojs-endo-but-for-bots-pr519-147aa72c
- 144139Z-progress-gardener-c2721d.md: gardener-83 on endolinbot claimed job endojs-endo-but-for-bots-pr522-gauntlet
- 144201Z-progress-gardener-6765a7.md: gardener-27 on endolinbot completed job endojs-endo-but-for-bots-pr513-af11a4e0
- 144242Z-progress-gardener-ea309e.md: gardener-16 on endolinbot completed job endojs-endo-but-for-bots-pr519-147aa72c
- 144252Z-progress-gardener-207a7a.md: gardener-21 on endolinbot completed job endojs-endo-but-for-bots-pr519-1d79f1bc
- 144402Z-progress-gardener-8a325f.md: gardener-11 on endolinbot claimed job fix-watcher-verb-keyword-false-positive
- 144424Z-progress-gardener-b383c7.md: gardener-6 on endolinbot completed job endojs-endo-but-for-bots-pr526-rebase
## Latest

The endo-but-for-bots #526 rebase landed (gardener-6 claimed and completed it within minutes), clearing it off the board. A gardener also picked up `fix-watcher-verb-keyword-false-positive` — a fix for the comment/mention-watcher firing on verb keywords that appear in a review's subject line, worth noting since it touches the trusted-directive path that drives the watchman fleet. Otherwise the board is steady: nine jobs in flight (a cluster of #503/#513/#519/#522 PR directives plus the cask and ebfb-#96 work), todo is empty, and the only thing awaiting a human is the scholar's change-propagation synthesis message in the maintainer inbox.
