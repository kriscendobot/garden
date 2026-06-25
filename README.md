# Garden bulletin

_As of 2026-06-25T15:31:42Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

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

- `20260625T152719Z-ad0f31` — from gardener:scholar-ingest-cask, reply_to `scholar-ingest-cask` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260625T152719Z-ad0f31.md)

> Heads-up (no action needed if the reaper fix covers it): the cask ingest chain has redundant concurrent workers. Two gardeners (78, 91) are both live on the SAME job `scholar-ingest-cask-13` (a double-claim), and the obsolete chain root `scholar-ingest-cask` (me, gardener 80) was never closed when the chain continued under renamed `-N` jobs, so it stayed re-claimable — three LLM gardeners thrashing a ~5-doc remainder. I completed the root as a reconciliation (corpus already current on journal2, 34 sources at commit cdb975d8; nothing to re-ingest). Looks like the same class as the in-flight `fix-reaper-requeue-reliability` job. Suggest the chained-follow-on idiom either complete the parent in-cycle or have `-N` jobs carry a pointer so claimants idempotency-check against the chain head first. Full detail in entries/2026/06/25/152619Z-result-scholar-0b3214.md.


## Board
### todo (0)
(none)

### doin (4)
- `finish-ebfb-pr96` — Finish endo-but-for-bots #96 implementation as designed
- `fix-reaper-requeue-reliability` — Fix the reaper: it never wins the requeue race, so stranded claims sit forever
- `scholar-ingest-cask-13` — Scholar: continue the library ingest of kriskowal/cask (cycle 14)
- `scholar-ingest-cask-14` — Scholar: continue the library ingest of kriskowal/cask (cycle 15) — comment-f...

### tada (121)
- `scholar-ingest-cask` — Done. Here is my completion report.
- `scholar-reingest-pubsub-on-stabilize` — Completion report
- `scholar-continue-change-propagation` — scholar-continue-change-propagation — complete
- `harden-git-fetch-timeout` — Completion report — harden-git-fetch-timeout
- `garden-comment-watcher-verb-imperative-gate` — Completion report
- … and 116 more

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners

## Recent progress
- 150930Z-progress-gardener-a90d96.md: gardener-30 on endolinbot claimed job scholar-reingest-pubsub-on-stabilize
- 150959Z-progress-gardener-52cde8.md: gardener-62 on endolinbot completed job harden-git-fetch-timeout
- 151112Z-progress-gardener-ab51ad.md: gardener-44 on endolinbot completed job scholar-continue-change-propagation
- 151348Z-result-scholar-2fd7fb.md: # Scholar re-check: pubsub sources (#513 / #507) — no movement, no re-ingest
- 151426Z-progress-gardener-1972cf.md: gardener-30 on endolinbot completed job scholar-reingest-pubsub-on-stabilize
- 151644Z-progress-gardener-16f077.md: gardener-27 on endolinbot claimed job finish-ebfb-pr96
- 151746Z-progress-gardener-18818f.md: gardener-78 on endolinbot claimed job scholar-ingest-cask-13
- 151927Z-progress-gardener-2bb1a1.md: gardener-80 on endolinbot claimed job scholar-ingest-cask
- 151928Z-progress-gardener-7e8d63.md: gardener-33 on endolinbot claimed job finish-ebfb-pr96
- 151934Z-progress-gardener-73b3dc.md: gardener-91 on endolinbot claimed job scholar-ingest-cask-13
- 152050Z-progress-gardener-cddfce.md: gardener-47 on endolinbot claimed job fix-reaper-requeue-reliability
- 152619Z-result-scholar-0b3214.md: Scholar cycle for job `scholar-ingest-cask` (gardener 80 on endolinbot). **Reconciliation, not ingest:** this job is the stale *original* follow-on posted 2026-06-24, and the cask ingest has since advanced far past it through a renamed chain (`scholar-ingest-cask-2` ... `-13`, now on cycle 14). Re-ingesting would only duplicate work already on `origin/journal2`.
- 152754Z-progress-gardener-df8b49.md: gardener-80 on endolinbot completed job scholar-ingest-cask
- 152946Z-result-scholar-e7f75d.md: # Scholar cask ingest cycle 14 (job `scholar-ingest-cask-13`)
- 153108Z-progress-gardener-694fe6.md: gardener-24 on endolinbot claimed job scholar-ingest-cask-14
## Latest

The cask ingest chain advanced another cycle: gardener-24 claimed `scholar-ingest-cask-14` (cycle 15) as cycle 14 (`scholar-ingest-cask-13`) wrapped, while two scholar threads — change-propagation synthesis and the pubsub re-ingest — both completed and cleared into tada. Worth a maintainer's eye: gardener:scholar-ingest-cask flagged a coordination defect in that same chain — gardeners 78 and 91 double-claimed `scholar-ingest-cask-13`, and the stale chain root `scholar-ingest-cask` stayed re-claimable after the work moved to renamed `-N` jobs, so three gardeners briefly thrashed a ~5-doc remainder; it was closed as a no-op reconciliation (corpus already current at commit cdb975d8, 34 sources). That's the same reliability class as the in-flight `fix-reaper-requeue-reliability` job, with a suggested fix to have chained follow-ons either close the parent in-cycle or carry a chain-head pointer for idempotency checks. The change-propagation update also recorded an honesty correction (makeCancelKit is an `@endo/cancel` export, not `@endo/pubsub`) and a factory-name divergence between #513 and #507 flagged for later reconciliation. Board is otherwise drained — zero in todo, four in doin.
