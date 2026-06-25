# Garden bulletin

_As of 2026-06-25T15:51:14Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

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

- `20260625T154855Z-c21859` — from gardener:finish-ebfb-pr96, reply_to `finish-ebfb-pr96` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260625T154855Z-c21859.md)

> PR #96 (compartment-mapper auxiliary package.json) — Phase 7 collision report.
>
> While I was implementing "finish #96 as designed", a concurrent peer gardener
> finished Phase 7 first and pushed it to the PR:
>   729e07f11 / 905cb7204 "honor languageForExtensionByPrefix at parse time (#96)".
> That commit addresses your flagged gap (collectLanguageOverrides was computed but
> unconsumed) for the ENTRY-path case: a `.js` file under a `{"type":"module"}` /
> `{"type":"commonjs"}` auxiliary that sits on the entry module's own path now parses
> correctly. Your fixture (apackage/afolder/file.js) and the design's nested case
> (rootpkg/sub1/sub2/x.js, loaded as the entry) are covered. So the PR-facing ask is
> satisfied — no action needed from me there.
>
> That commit explicitly DEFERS one piece as "future work": auxiliary subtrees that
> live inside a DEPENDENCY package reached by relative import (not on the entry path)
> are still not honored. Example: app imports aux-pkg by name; aux-pkg/index.js does
> `import "./cjs-sub/leaf.js"` where cjs-sub/ is a `{"type":"commonjs"}` auxiliary —
> leaf.js is still misparsed.
>
> I independently implemented that general case via a lazy per-module walk in the
> import hook (it has maybeRead + the sync/async trampoline, so it covers both paths).
> To avoid clobbering the peer's just-pushed commit, I did NOT push to the PR; my work
> is on a side branch instead:
>   origin/pr96-auxiliary-lazy-parse-general-case  (5483f04ba)
> All 917 compartment-mapper tests pass (12 known failures unchanged), tsc + eslint
> clean, regression-proven (neutralizing the override fails all 3 integration tests).
>
> The two implementations overlap (both touch map-parser resolveLanguage, the
> languageForExtensionByPrefix field, and types) and use different architectures
> (peer: precompute on the entry compartment at map time; mine: lazy per-module at
> parse time), so they don't compose trivially.
>
> Decision for you: (a) accept the entry-path scope now on #96 and treat the general
> dependency-subtree case as future work, or (b) reconcile onto the lazy approach so
> the general case lands too. If (b), point me at it and I'll rebase my side branch
> onto the current PR head and reconcile the two mechanisms into one.


## Board
### todo (0)
(none)

### doin (1)
- `scholar-ingest-cask-14` — Scholar: continue the library ingest of kriskowal/cask (cycle 15) — comment-f...

### tada (125)
- `shepherd-ebfb-pr96` — Completion report
- `finish-ebfb-pr96` — Completion report — finish endo-but-for-bots #96 (Phase 7)
- `fix-reaper-requeue-reliability` — Report: fix-reaper-requeue-reliability
- `scholar-ingest-cask-13` — Completion report — scholar-ingest-cask-13 (gardener 91, endolinbot)
- `scholar-ingest-cask` — Done. Here is my completion report.
- … and 120 more

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners

## Recent progress
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
- 154945Z-progress-gardener-35fe1c.md: gardener-33 on endolinbot completed job finish-ebfb-pr96
- 155052Z-progress-gardener-af96ac.md: gardener-76 on endolinbot completed job shepherd-ebfb-pr96
## Latest

The shepherd lane on endo-but-for-bots #96 closed out — `shepherd-ebfb-pr96` moved from doin to tada, leaving the board at a single in-flight job (`scholar-ingest-cask-14`) and an otherwise empty queue. The headline for a human is PR #96 itself: a peer gardener landed the entry-path fix for the flagged `languageForExtensionByPrefix` gap (729e07f11/905cb7204), and `finish-ebfb-pr96` reports the PR-facing ask is satisfied — but it parked an independent general-case fix (dependency-subtree auxiliaries reached by relative import) on side branch `origin/pr96-auxiliary-lazy-parse-general-case` rather than clobber the peer's commit, and is asking whether to accept entry-path scope now or reconcile the lazy approach in. Two reliability notes also surfaced: the cask ingest chain hit a double-claim (gardeners 78 and 91 both worked `scholar-ingest-cask-13`) plus a stale re-claimable chain root, and `scholar-ingest-cask-14`'s handler failed and was left in doin for the reaper — both flagged as the same class as the just-completed `fix-reaper-requeue-reliability`.
