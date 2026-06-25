# Garden bulletin

_As of 2026-06-25T15:41:54Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

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

### doin (2)
- `scholar-ingest-cask-14` — Scholar: continue the library ingest of kriskowal/cask (cycle 15) — comment-f...
- `shepherd-ebfb-pr96` — Shepherd endo-but-for-bots #96 CI to green

### tada (124)
- `fix-reaper-requeue-reliability` — Report: fix-reaper-requeue-reliability
- `finish-ebfb-pr96` — Completion report: finish-ebfb-pr96
- `scholar-ingest-cask-13` — Completion report — scholar-ingest-cask-13 (gardener 91, endolinbot)
- `scholar-ingest-cask` — Done. Here is my completion report.
- `scholar-reingest-pubsub-on-stabilize` — Completion report
- … and 119 more

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners

## Recent progress
- 151927Z-progress-gardener-2bb1a1.md: gardener-80 on endolinbot claimed job scholar-ingest-cask
- 151928Z-progress-gardener-7e8d63.md: gardener-33 on endolinbot claimed job finish-ebfb-pr96
- 151934Z-progress-gardener-73b3dc.md: gardener-91 on endolinbot claimed job scholar-ingest-cask-13
- 152050Z-progress-gardener-cddfce.md: gardener-47 on endolinbot claimed job fix-reaper-requeue-reliability
- 152619Z-result-scholar-0b3214.md: Scholar cycle for job `scholar-ingest-cask` (gardener 80 on endolinbot). **Reconciliation, not ingest:** this job is the stale *original* follow-on posted 2026-06-24, and the cask ingest has since advanced far past it through a renamed chain (`scholar-ingest-cask-2` ... `-13`, now on cycle 14). Re-ingesting would only duplicate work already on `origin/journal2`.
- 152754Z-progress-gardener-df8b49.md: gardener-80 on endolinbot completed job scholar-ingest-cask
- 152946Z-result-scholar-e7f75d.md: # Scholar cask ingest cycle 14 (job `scholar-ingest-cask-13`)
- 153108Z-progress-gardener-694fe6.md: gardener-24 on endolinbot claimed job scholar-ingest-cask-14
- 153243Z-progress-gardener-25fcae.md: gardener-78 on endolinbot completed job scholar-ingest-cask-13
- 153454Z-progress-gardener-088800.md: gardener-91 on endolinbot completed job scholar-ingest-cask-13
- 153500Z-message-scholar-bef28b.md: # Double-claim defect: `scholar-ingest-cask-13` was claimed and fully worked by two gardeners
- 153621Z-progress-gardener-cc5d91.md: gardener-76 on endolinbot claimed job shepherd-ebfb-pr96
- 153657Z-progress-gardener-29d71b.md: gardener-27 on endolinbot completed job finish-ebfb-pr96
- 153823Z-error-gardener-6e2874.md: gardener-24 on endolinbot: job scholar-ingest-cask-14 handler FAILED; output captured as e69de29bb2d1d6434b8b29ae775ad8c2e48c5391, escalated to the gardener inbox, left in doin for the reaper
- 154136Z-progress-gardener-3a798b.md: gardener-47 on endolinbot completed job fix-reaper-requeue-reliability
## Latest

The `fix-reaper-requeue-reliability` fix landed (doin→tada, gardener-47), which is timely: the cask ingest chain just exhibited exactly the failure class that fix targets. Two scholar messages flag it for the maintainer — `scholar-ingest-cask-13` was double-claimed and fully worked by two gardeners (78 and 91), and the stale chain root `scholar-ingest-cask` was never closed so it stayed re-claimable, leaving three gardeners thrashing a ~5-doc remainder; gardener-80 closed the root as a no-op reconciliation (corpus already current at commit cdb975d8, 34 sources). The chain now sits at `scholar-ingest-cask-14`, but that job's handler FAILED under gardener-24 and was left in doin for the reaper — worth watching that the freshly-landed reaper fix actually requeues it. Separately, the scholar reports the change-propagation library synthesis advanced: two pubsub sources (#513, #507) curated in with factory-name divergence flagged for reconciliation when those PRs and @endo/cancel stabilize.
