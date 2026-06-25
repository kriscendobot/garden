# Garden bulletin

_As of 2026-06-25T20:55:29Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh; the
journalist's narrative leads in the Latest section above. This page (the journal's
README.md) IS the bulletin; the journal's layout and design narrative lives in
[DESIGN.md](DESIGN.md).

## Latest

The plan-in-journal build advanced on two fronts: the cross-repo-and-edges phase and the continuous-reconcile loop both completed, and Phase 1 (the endo redirect, which also retires the sync discipline) was just claimed and is now in progress. Together with the recently landed Phase 0 schema/validator/reconciler/renderer work, this leaves the plan-in-journal effort with most phases done and the endo-redirect phase actively building; the remaining open items on the board are the compartment-mapper archival fixes and the cask library ingest. Nothing new is parked for the maintainer — the review queue is unchanged, still topped by the daemon locator-scheme refactor ([endo-but-for-bots#178](https://github.com/endojs/endo-but-for-bots/pull/178)) and the passable byte-arrays work ([endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503)).

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#178](https://github.com/endojs/endo-but-for-bots/pull/178) — refactor(daemon): introduce locator scheme with @-delimited connection hints (per kriskowal #178) (waiting 19m)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 14m)
- [endojs/endo-but-for-bots#513](https://github.com/endojs/endo-but-for-bots/pull/513) — feat(pubsub): create @endo/pubsub with Sink/Spring async promise linked list (changes + latest variants) (waiting 6h)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 1d)
- [endojs/endo-but-for-bots#440](https://github.com/endojs/endo-but-for-bots/pull/440) — feat(daemon,cli,chat): drop @info name hub for formula-inspector design (#439) (waiting 1d)
- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 2d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 3d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 10d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 34d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 34d)

_Showing top 10 of 31 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

(no pending maintainer messages)

## Board
### todo (0)
(none)

### doin (7)
- `add-plan-job-category` — Add a "plan" job-board category for jobs gated on maintainer go-ahead or defe...
- `fix-compartment-mapper-archive-exit-reexport` — Fix compartment-mapper: archive exit-module via modules map fails through a r...
- `fix-compartment-mapper-esm-dynamic-import-archival` — Fix compartment-mapper: ESM dynamic import() not traced during archival (on m...
- `implement-plan-in-journal` — Implement the plan-in-journal design (garden#4, approved — do NOT merge the PR)
- `implement-plan-phase1-endo-redirect` — Plan-in-journal Phase 1 + Phase 4: endo redirect + retire the sync discipline
- `plan-in-journal-impl-p0` — build: implement plan-in-journal — Phase 0 (schema, validator, reconciler, on...
- `scholar-ingest-cask-15` — Scholar: continue the library ingest of kriskowal/cask (cycle 16) — comment-f...

### tada (167)
- `implement-plan-phase3-cross-repo-and-edges` — report: implement-plan-phase3-cross-repo-and-edges
- `implement-plan-continuous-reconcile` — report: implement-plan-continuous-reconcile
- `fix-compartment-mapper-bundle-missing-deps` — CI is still in progress. The background watch (bxdq2h9o3) will notify me when...
- `scholar-ingest-cask-14` — All work complete and verified. Cleanup done; the follow-on was already claim...
- `endojs-endo-but-for-bots-pr442-cebb93dd` — Completion report
- … and 162 more

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners
