# Garden bulletin

_As of 2026-06-24T23:21:44Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

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

### doin (6)
- `address-review-ebfb-pr513` — Address kriskowal's CHANGES_REQUESTED review on endo-but-for-bots #513
- `finish-ebfb-pr96` — Finish endo-but-for-bots #96 implementation as designed
- `scholar-ingest-cask-7` — Scholar: continue the library ingest of kriskowal/cask (cycle 8)
- `scholar-ingest-cask` — Scholar: deepen the library ingest of kriskowal/cask
- `scholar-ingest-gtor` — Scholar: full ingest of kriskowal/gtor (A General Theory of Reactivity)
- `teardown-live-wip-unwedge-watchman` — Tear down the live-tree partial WIP and unwedge the watchman (HIGH PRIORITY —...

### tada (93)
- `scholar-ingest-cask-6` — scholar-ingest-cask-6 (cask cycle 7) — done
- `scholar-through-lines-change-propagation` — All work landed and cleaned up. Final report:
- `scholar-ingest-cask-5` — Completion report — scholar-ingest-cask-5 (scholar cycle 6)
- `design-siwe-ymax-mcp-auth` — Completion report — design-siwe-ymax-mcp-auth
- `--help` — The full picture confirms the diagnosis. The job history (8c56609c todo(--hel...
- … and 88 more

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners

## Recent progress
- 230700Z-result-gardener-design-siwe-ymax-mcp-auth.md: # Design — Integrating SIWE with ymax so an MCP server authenticates the caller per tool call
- 230724Z-progress-gardener-30d727.md: gardener-54 on endolinbot claimed job scholar-through-lines-change-propagation
- 230740Z-progress-gardener-d39f64.md: gardener-60 on endolinbot completed job harden-producer-push-path
- 230821Z-result-scholar-1b6932.md: # Scholar cycle 6: cask cell/entry family ingest (job scholar-ingest-cask-5)
- 230834Z-progress-gardener-8e55fd.md: gardener-66 on endolinbot claimed job --help
- 231010Z-progress-gardener-55389b.md: gardener-14 on endolinbot claimed job scholar-ingest-cask-6
- 231050Z-progress-gardener-24fe0d.md: gardener-86 on endolinbot completed job design-siwe-ymax-mcp-auth
- 231116Z-progress-gardener-3c9576.md: gardener-35 on endolinbot completed job scholar-ingest-cask-5
- 231218Z-progress-gardener-192907.md: gardener-66 on endolinbot completed job --help
- 231219Z-progress-gardener-3e78f3.md: gardener-16 on endolinbot claimed job teardown-live-wip-unwedge-watchman
- 231703Z-result-scholar-chgprop.md: # result: scholar — change-propagation through-lines curated
- 231823Z-progress-gardener-f927ce.md: gardener-61 on endolinbot claimed job scholar-ingest-gtor
- 231912Z-progress-gardener-71f0e9.md: gardener-54 on endolinbot completed job scholar-through-lines-change-propagation
- 231935Z-result-scholar-69084d.md: # Scholar cycle 7: cask cell-capabilities.md ingest (job scholar-ingest-cask-6)
- 232130Z-progress-gardener-4b3d22.md: gardener-30 on endolinbot claimed job scholar-ingest-cask-7
## Latest

Scholar work dominated this tick: cask cycle 7 (`scholar-ingest-cask-6`) completed and cycle 8 (`scholar-ingest-cask-7`) was immediately claimed, keeping the cask ingest chain rolling. The change-propagation through-lines synthesis landed and was reported up to the maintainer inbox — a cross-cutting theory tying FRB observers, @endo/pubsub topics, and propagators to one delta-propagation model, grounded in a fresh gtor ingest (`scholar-ingest-gtor` now in flight). Note the honesty flag in that message: propagators are only partially grounded in the corpus. The board is otherwise drained (todo empty), with six jobs in flight — including the HIGH-PRIORITY `teardown-live-wip-unwedge-watchman`, which a maintainer should keep an eye on since a wedged watchman stalls the fleet's deploys.
