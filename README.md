# Garden bulletin

_As of 2026-06-25T00:09:14Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

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

### doin (4)
- `finish-ebfb-pr96` — Finish endo-but-for-bots #96 implementation as designed
- `scholar-ingest-cask-10` — Scholar: continue the library ingest of kriskowal/cask (cycle 11)
- `scholar-ingest-cask-11` — Scholar: continue the library ingest of kriskowal/cask (cycle 12)
- `scholar-ingest-cask` — Scholar: deepen the library ingest of kriskowal/cask

### tada (100)
- `scholar-ingest-cask-9` — Completion report — scholar-ingest-cask-9 (cask ingest cycle 10)
- `scholar-ingest-gtor-recap` — scholar-ingest-gtor-recap — cycle 3 complete: gtor README fully ingested
- `scholar-ingest-cask-8` — scholar-ingest-cask-8 → cask library ingest cycle 9 complete
- `scholar-ingest-cask-7` — Cycle 8 complete. Report:
- `address-review-ebfb-pr513` — Completion report: address-review-ebfb-pr513
- … and 95 more

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners

## Recent progress
- 232801Z-result-scholar-5ea427.md: # scholar-ingest-gtor — cycle 2 complete (gtor README async/queue substrate)
- 232840Z-progress-gardener-fb0f3c.md: gardener-61 on endolinbot completed job scholar-ingest-gtor
- 233228Z-progress-gardener-e498e3.md: gardener-16 on endolinbot claimed job scholar-ingest-cask-8
- 233243Z-progress-gardener-ecf406.md: gardener-76 on endolinbot completed job address-review-ebfb-pr513
- 233301Z-result-scholar-gtorrcp.md: # scholar-ingest-gtor-recap — cycle 3 complete (gtor README FULLY ingested)
- 233311Z-progress-gardener-2de347.md: gardener-30 on endolinbot completed job scholar-ingest-cask-7
- 233437Z-progress-gardener-32a5fb.md: gardener-75 on endolinbot completed job scholar-ingest-gtor-recap
- 234020Z-result-scholar-cf7398.md: # Scholar cask ingest cycle 9: the protocol family (protocol.md, protocol2.md, protocol2-arch.md)
- 234200Z-progress-gardener-f36ea0.md: gardener-99 on endolinbot claimed job scholar-ingest-cask-9
- 234241Z-progress-gardener-a6b37d.md: gardener-16 on endolinbot completed job scholar-ingest-cask-8
- 235331Z-result-scholar-fad5b1.md: # Scholar cycle 10: cask `doc/design/` dir cluster ingested (job `scholar-ingest-cask-9`)
- 235511Z-progress-gardener-5be133.md: gardener-31 on endolinbot claimed job scholar-ingest-cask-10
- 235540Z-progress-gardener-b2c144.md: gardener-99 on endolinbot completed job scholar-ingest-cask-9
- 000735Z-result-scholar-cd1dcb.md: # Scholar cycle 11: cask array/columnar machinery cluster ingested (job `scholar-ingest-cask-10`)
- 000853Z-progress-gardener-702330.md: gardener-30 on endolinbot claimed job scholar-ingest-cask-11
## Latest

Scholar's cask ingest rolled forward another cycle: gardener-30 completed `scholar-ingest-cask-10` (cycle 11, the cask array/columnar-machinery cluster) and immediately claimed the follow-on `scholar-ingest-cask-11` (cycle 12), which is now in flight. The board is otherwise quiet — todo is empty and the four in-flight jobs are all scholar ingest work plus the long-running endo-but-for-bots #96 implementation. Nothing here needs a maintainer's hand; the one unread message remains the scholar's change-propagation through-lines synthesis awaiting review.
