# Garden bulletin

_As of 2026-06-25T18:27:37Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh; the
journalist's narrative leads in the Latest section above. This page (the journal's
README.md) IS the bulletin; the journal's layout and design narrative lives in
[DESIGN.md](DESIGN.md).

## Latest

No board transitions landed this cycle, so the refresh reflects in-flight work rather than new completions. A cluster of compartment-mapper fixes is underway — ESM dynamic `import()` not traced during archival, the CJS bundler aborting on missing/optional internal modules, and archive exit-module reexport failing through a renaming reexport — all seeded by the just-completed failure-classification pass. Also active: Phase 0 of the plan-in-journal build (garden#4, approved but explicitly not to be merged) and the gauntlet on [endo-but-for-bots#528](https://github.com/endojs/endo-but-for-bots/pull/528). The [endo-but-for-bots#474](https://github.com/endojs/endo-but-for-bots/pull/474) retcon also wrapped up recently. For review, the freshest parked item is [endo-but-for-bots#513](https://github.com/endojs/endo-but-for-bots/pull/513), the new @endo/pubsub package with Sink/Spring async linked lists.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#513](https://github.com/endojs/endo-but-for-bots/pull/513) — feat(pubsub): create @endo/pubsub with Sink/Spring async promise linked list (changes + latest variants) (waiting 3h)
- [endojs/endo-but-for-bots#442](https://github.com/endojs/endo-but-for-bots/pull/442) — feat(daemon-cas): extract CAS surface into @endo/daemon-cas (waiting 1d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 1d)
- [endojs/endo-but-for-bots#440](https://github.com/endojs/endo-but-for-bots/pull/440) — feat(daemon,cli,chat): drop @info name hub for formula-inspector design (#439) (waiting 1d)
- [endojs/endo#3254](https://github.com/endojs/endo/pull/3254) — chore: harden browser-test installation (waiting 2d)
- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 2d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 3d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 10d)
- [endojs/endo-but-for-bots#231](https://github.com/endojs/endo-but-for-bots/pull/231) — design(familiar): MVR release plan (closes #229) (waiting 24d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 34d)

_Showing top 10 of 33 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

(no pending maintainer messages)

## Board
### todo (0)
(none)

### doin (8)
- `bulletin-parked-prs-fuzzy-sort-top10` — Bulletin "Parked for maintainer feedback": fuzzy-sort by recency + roadmap re...
- `endojs-endo-but-for-bots-pr528-gauntlet` — gauntlet directive on endojs/endo-but-for-bots PR #528
- `fix-compartment-mapper-archive-exit-reexport` — Fix compartment-mapper: archive exit-module via modules map fails through a r...
- `fix-compartment-mapper-bundle-missing-deps` — Fix compartment-mapper: CJS bundler aborts on missing/optional internal modul...
- `fix-compartment-mapper-esm-dynamic-import-archival` — Fix compartment-mapper: ESM dynamic import() not traced during archival (on m...
- `implement-plan-in-journal` — Implement the plan-in-journal design (garden#4, approved — do NOT merge the PR)
- `plan-in-journal-impl-p0` — build: implement plan-in-journal — Phase 0 (schema, validator, reconciler, on...
- `scholar-ingest-cask-14` — Scholar: continue the library ingest of kriskowal/cask (cycle 15) — comment-f...

### tada (144)
- `endojs-endo-but-for-bots-pr96-0105506f` — Completion report: attention directive on endojs/endo-but-for-bots PR #96
- `kriskowal-garden-pr4-b8d45a0f` — The directive is fully discharged. The implementation job is posted and alrea...
- `kriskowal-garden-pr4-review-022d380c` — Completion report — job kriskowal-garden-pr4-review-022d380c
- `endojs-endo-but-for-bots-pr474-retcon` — Completion report: endojs-endo-but-for-bots-pr474-retcon
- `classify-compartment-mapper-failures` — Completion report — classify-compartment-mapper-failures
- … and 139 more

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners
