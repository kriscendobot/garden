# Garden bulletin

_As of 2026-06-25T15:11:17Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

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

### doin (4)
- `finish-ebfb-pr96` — Finish endo-but-for-bots #96 implementation as designed
- `scholar-ingest-cask-13` — Scholar: continue the library ingest of kriskowal/cask (cycle 14)
- `scholar-ingest-cask` — Scholar: deepen the library ingest of kriskowal/cask
- `scholar-reingest-pubsub-on-stabilize` — Scholar: re-ingest the pubsub sources when #513 / #507 stabilize

### tada (119)
- `scholar-continue-change-propagation` — scholar-continue-change-propagation — complete
- `harden-git-fetch-timeout` — Completion report — harden-git-fetch-timeout
- `garden-comment-watcher-verb-imperative-gate` — Completion report
- `endojs-endo-but-for-bots-pr513-rebase` — Completion report: endojs-endo-but-for-bots-pr513-rebase
- `harden-jq-and-loud-tool-failure` — Completion report — harden-jq-and-loud-tool-failure
- … and 114 more

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners

## Recent progress
- 144825Z-progress-gardener-48bc31.md: gardener-87 on endolinbot completed job endojs-endo-but-for-bots-pr513-be1cd0d3
- 144918Z-progress-gardener-771a75.md: gardener-83 on endolinbot completed job endojs-endo-but-for-bots-pr522-gauntlet
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
## Latest

The scholar's change-propagation curation cycle completed (`scholar-continue-change-propagation` → tada) and left a maintainer message: it curated the two missing pubsub sources — the @endo/pubsub README (#513) and the notifier-pubsub-migration design (#507) — into the library, but both still live on unmerged branches and have diverged on factory names (`makeChangeTopic`/`makeLatestTopic` vs `makeChangesPubSub`/`makeLatestPubSub`), flagged for reconciliation. Two honesty corrections landed: `makeCancelKit` was dropped as an @endo/pubsub export (its home is @endo/cancel, not yet ingested), and the sliding-window-topic findings are marked draft, not shipped. A follow-on `scholar-reingest-pubsub-on-stabilize` job is already claimed and waits for #513/#507/@endo/cancel to settle before refreshing the sources. Four jobs remain in flight (the two cask ingests, ebfb #96, and the pubsub re-ingest); nothing currently needs the maintainer beyond reading that message.
