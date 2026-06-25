# Garden bulletin

_As of 2026-06-25T14:46:45Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

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

### doin (8)
- `endojs-endo-but-for-bots-pr513-be1cd0d3` — attention directive on endojs/endo-but-for-bots PR #513
- `endojs-endo-but-for-bots-pr522-gauntlet` — gauntlet directive on endojs/endo-but-for-bots PR #522
- `finish-ebfb-pr96` — Finish endo-but-for-bots #96 implementation as designed
- `fix-watcher-verb-keyword-false-positive` — fix: comment/mention-watcher verb-keyword false-positive on review subject ma...
- `harden-jq-and-loud-tool-failure` — Harden against the jq outage: add jq to the image, fail loudly on missing tools
- `reconduct-endo-cancel-507` — Verify @endo/cancel (#345) exists; reconduct if missing (endo-but-for-bots #507)
- `scholar-ingest-cask-13` — Scholar: continue the library ingest of kriskowal/cask (cycle 14)
- `scholar-ingest-cask` — Scholar: deepen the library ingest of kriskowal/cask

### tada (110)
- `endojs-endo-but-for-bots-pr513-gauntlet` — Fix pushed, review thread answered, CI in flight. I'll resume when the poller...
- `endojs-endo-but-for-bots-pr503-95390ef3` — The directive is fully addressed and recorded. Final report:
- `endojs-endo-but-for-bots-pr519-f2f4c5ca` — Review posted. The directive is satisfied.
- `endojs-endo-but-for-bots-pr526-rebase` — Done. Here is my completion report.
- `endojs-endo-but-for-bots-pr519-1d79f1bc` — Completion report: attention directive on endojs/endo-but-for-bots PR #519
- … and 105 more

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners

## Recent progress
- 144047Z-progress-gardener-ebc219.md: gardener-21 on endolinbot claimed job endojs-endo-but-for-bots-pr519-1d79f1bc
- 144117Z-progress-gardener-c444d6.md: gardener-6 on endolinbot claimed job endojs-endo-but-for-bots-pr526-rebase
- 144119Z-progress-gardener-86722f.md: gardener-16 on endolinbot claimed job endojs-endo-but-for-bots-pr519-147aa72c
- 144139Z-progress-gardener-c2721d.md: gardener-83 on endolinbot claimed job endojs-endo-but-for-bots-pr522-gauntlet
- 144201Z-progress-gardener-6765a7.md: gardener-27 on endolinbot completed job endojs-endo-but-for-bots-pr513-af11a4e0
- 144242Z-progress-gardener-ea309e.md: gardener-16 on endolinbot completed job endojs-endo-but-for-bots-pr519-147aa72c
- 144252Z-progress-gardener-207a7a.md: gardener-21 on endolinbot completed job endojs-endo-but-for-bots-pr519-1d79f1bc
- 144402Z-progress-gardener-8a325f.md: gardener-11 on endolinbot claimed job fix-watcher-verb-keyword-false-positive
- 144424Z-progress-gardener-b383c7.md: gardener-6 on endolinbot completed job endojs-endo-but-for-bots-pr526-rebase
- 144457Z-progress-gardener-651f8c.md: gardener-17 on endolinbot completed job endojs-endo-but-for-bots-pr519-f2f4c5ca
- 144515Z-result-gardener-9580e6.md: ---
- 144527Z-progress-gardener-4bffbe.md: gardener-24 on endolinbot claimed job harden-jq-and-loud-tool-failure
- 144538Z-progress-gardener-75491a.md: gardener-29 on endolinbot claimed job reconduct-endo-cancel-507
- 144542Z-progress-gardener-ee1e3a.md: gardener-81 on endolinbot completed job endojs-endo-but-for-bots-pr503-95390ef3
- 144640Z-progress-gardener-22199b.md: gardener-59 on endolinbot completed job endojs-endo-but-for-bots-pr513-gauntlet
## Latest

PR #513's gauntlet directive on endojs/endo-but-for-bots just landed in `tada` — gardener-59 pushed the fix, answered the review thread, and left CI in flight to resume on the next poller wake. That clears the last of a busy cycle that also retired the #519 attention directives (two passes), the #526 rebase, and the #503 directive. Eight jobs remain in flight with nothing queued: the #513/#522 PR directives, two cask library ingests, the jq-hardening and watcher-false-positive infra fixes, the @endo/cancel reconduct check, and the ebfb #96 finish. Worth a maintainer's eye: the scholar synthesis message in the inbox flags that propagators are only partially grounded in the corpus and that @endo/pubsub's README isn't yet ingested — a follow-on once #513/#507 stabilize.
