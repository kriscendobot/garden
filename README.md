# Garden bulletin

_As of 2026-06-25T15:14:43Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh, with a
journalist's narrative in the Latest section. This page (the journal's README.md)
IS the bulletin; the journal's layout and design narrative lives in [DESIGN.md](DESIGN.md).

## Messages to the maintainer

- `20260625T150946Z-9ec67f` — from gardener:scholar-continue-change-propagation, reply_to `scholar-continue-change-propagation` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260625T150946Z-9ec67f.md)

> Change-propagation library — synthesis update (scholar, maintainer-endorsed pursuit).
>
> Curated the two missing pubsub sources into the library as proper, idempotency-anchored
> source pages (both still on unmerged PR branches, flagged accordingly):
>
> - @endo/pubsub README (#513, feat/endo-pubsub) — 4 sections.
> - notifier-pubsub-migration design (#507, revision 5) — 8 sections, including the
>   asymmetric-passability framing, the full @endo/exo-pubsub adapter set, and the FRB
>   collection-change-propagation future direction.
>
> Two honesty corrections the new sources forced:
> 1. makeCancelKit is NOT an @endo/pubsub export — the bundled cancel kit + barrel index
>    were dropped per review (commit d15e34cb); its home is @endo/cancel, a prerequisite
>    package not yet on llm. The prior endo-pubsub concept page asserted it as a package
>    export; corrected.
> 2. #513 and #507 have diverged on factory names (makeChangeTopic/makeLatestTopic +
>    {publisher, subscribe} in the implementation vs makeChangesPubSub/makeLatestPubSub +
>    {sink, makeSpring, finish, fail} in the design). Recorded both from source and
>    flagged for reconciliation.
>
> Folded the landed research-frb-endo-exo-collections findings into sliding-window-topic
> (the ordered-set observable contract, SortedSet splay vs SortedArraySet, makeViewObserver's
> five-branch splicer, the proposed makeWindowTopic with query()+subscribe()) — flagged as
> draft, not shipped. Preserved the propagator honesty flag intact (FRB two-way bindings the
> one in-corpus instance; Sussman/Radul lattice-merge model cited as external lineage only).
> gtor is already fully ingested (9 sections), so direction 3 needed no new work.
>
> Posted follow-on job scholar-reingest-pubsub-on-stabilize to refresh both sources and
> reconcile the factory names when #513/#507/@endo/cancel stabilize. All on origin/journal2.


## Board
### todo (0)
(none)

### doin (3)
- `finish-ebfb-pr96` — Finish endo-but-for-bots #96 implementation as designed
- `scholar-ingest-cask-13` — Scholar: continue the library ingest of kriskowal/cask (cycle 14)
- `scholar-ingest-cask` — Scholar: deepen the library ingest of kriskowal/cask

### tada (120)
- `scholar-reingest-pubsub-on-stabilize` — Completion report
- `scholar-continue-change-propagation` — scholar-continue-change-propagation — complete
- `harden-git-fetch-timeout` — Completion report — harden-git-fetch-timeout
- `garden-comment-watcher-verb-imperative-gate` — Completion report
- `endojs-endo-but-for-bots-pr513-rebase` — Completion report: endojs-endo-but-for-bots-pr513-rebase
- … and 115 more

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners

## Recent progress
- 145023Z-progress-gardener-93d99f.md: gardener-11 on endolinbot completed job fix-watcher-verb-keyword-false-positive
- 145036Z-progress-gardener-672044.md: gardener-29 on endolinbot completed job reconduct-endo-cancel-507
- 145057Z-progress-gardener-024a2c.md: gardener-44 on endolinbot claimed job scholar-continue-change-propagation
- 145829Z-progress-gardener-056f3d.md: gardener-62 on endolinbot claimed job harden-git-fetch-timeout
- 150010Z-progress-gardener-90c42a.md: gardener-68 on endolinbot claimed job endojs-endo-but-for-bots-pr513-rebase
- 150013Z-progress-gardener-b35a3e.md: gardener-24 on endolinbot completed job harden-jq-and-loud-tool-failure
- 150349Z-progress-gardener-3ef588.md: gardener-99 on endolinbot claimed job garden-comment-watcher-verb-imperative-gate
- 150412Z-progress-gardener-d446f2.md: gardener-68 on endolinbot completed job endojs-endo-but-for-bots-pr513-rebase
- 150801Z-result-scholar-b0b09f.md: # Scholar cycle: continue the change-propagation curation (maintainer-endorsed)
- 150844Z-progress-gardener-6486fc.md: gardener-99 on endolinbot completed job garden-comment-watcher-verb-imperative-gate
- 150930Z-progress-gardener-a90d96.md: gardener-30 on endolinbot claimed job scholar-reingest-pubsub-on-stabilize
- 150959Z-progress-gardener-52cde8.md: gardener-62 on endolinbot completed job harden-git-fetch-timeout
- 151112Z-progress-gardener-ab51ad.md: gardener-44 on endolinbot completed job scholar-continue-change-propagation
- 151348Z-result-scholar-2fd7fb.md: # Scholar re-check: pubsub sources (#513 / #507) — no movement, no re-ingest
- 151426Z-progress-gardener-1972cf.md: gardener-30 on endolinbot completed job scholar-reingest-pubsub-on-stabilize
## Latest

The scholar's `scholar-reingest-pubsub-on-stabilize` job ran and completed without re-ingesting anything: the re-check found no movement on the two pubsub sources (#513 / #507), so the library stays as curated rather than refreshing against still-diverged branches. That closes out the change-propagation curation cycle the maintainer endorsed — its synthesis report (curated @endo/pubsub and notifier-pubsub-migration sources, two honesty corrections around makeCancelKit's true home and the #513/#507 factory-name divergence) is waiting unread in the maintainer inbox. The board is otherwise quiet: todo is empty, and the three in-flight jobs are all scholar/ebfb continuations.
