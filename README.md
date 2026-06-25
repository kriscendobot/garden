# Garden bulletin

_As of 2026-06-25T20:07:09Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh; the
journalist's narrative leads in the Latest section above. This page (the journal's
README.md) IS the bulletin; the journal's layout and design narrative lives in
[DESIGN.md](DESIGN.md).

## Latest

The d.ts types work on [endo-but-for-bots#528](https://github.com/endojs/endo-but-for-bots/pull/528) just landed, and that PR is also moving through review and shepherd directives in parallel. Otherwise the board is steady with twelve jobs in flight and nothing waiting in the queue: a retcon on the passable-byte-arrays [endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503), attention and review directives on [endo-but-for-bots#442](https://github.com/endojs/endo-but-for-bots/pull/442), three compartment-mapper bug fixes (archive exit-module re-export, CJS missing-dep aborts, and untraced ESM dynamic `import()`), and the early phases of the plan-in-journal implementation (garden#4). A maintainer's eye is most needed on the parked queue, where [endo-but-for-bots#513](https://github.com/endojs/endo-but-for-bots/pull/513) (the new `@endo/pubsub` package) has now waited five hours and [endo#3137](https://github.com/endojs/endo/pull/3137) (`.ts` runtime modules via erasable type syntax) sits at ten days.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#178](https://github.com/endojs/endo-but-for-bots/pull/178) — refactor(daemon): introduce locator scheme with @-delimited connection hints (per kriskowal #178) (waiting 1m)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 57m)
- [endojs/endo-but-for-bots#513](https://github.com/endojs/endo-but-for-bots/pull/513) — feat(pubsub): create @endo/pubsub with Sink/Spring async promise linked list (changes + latest variants) (waiting 5h)
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

### doin (12)
- `add-plan-job-category` — Add a "plan" job-board category for jobs gated on maintainer go-ahead or defe...
- `endojs-endo-but-for-bots-pr442-cebb93dd` — attention directive on endojs/endo-but-for-bots PR #442
- `endojs-endo-but-for-bots-pr442-review-b7f5f9e9` — Review directive on endojs/endo-but-for-bots PR #442
- `endojs-endo-but-for-bots-pr503-retcon` — retcon directive on endojs/endo-but-for-bots PR #503
- `endojs-endo-but-for-bots-pr528-review-4f5fb2c7` — Review directive on endojs/endo-but-for-bots PR #528
- `endojs-endo-but-for-bots-pr528-shepherd` — shepherd directive on endojs/endo-but-for-bots PR #528
- `fix-compartment-mapper-archive-exit-reexport` — Fix compartment-mapper: archive exit-module via modules map fails through a r...
- `fix-compartment-mapper-bundle-missing-deps` — Fix compartment-mapper: CJS bundler aborts on missing/optional internal modul...
- `fix-compartment-mapper-esm-dynamic-import-archival` — Fix compartment-mapper: ESM dynamic import() not traced during archival (on m...
- `implement-plan-in-journal` — Implement the plan-in-journal design (garden#4, approved — do NOT merge the PR)
- `plan-in-journal-impl-p0` — build: implement plan-in-journal — Phase 0 (schema, validator, reconciler, on...
- `scholar-ingest-cask-14` — Scholar: continue the library ingest of kriskowal/cask (cycle 15) — comment-f...

### tada (155)
- `address-pr528-dts-types` — address-pr528-dts-types — completion report
- `endojs-endo-but-for-bots-pr178-rebase` — Completion report: endojs-endo-but-for-bots-pr178-rebase
- `endojs-endo-but-for-bots-pr178-gauntlet` — I've completed the core gauntlet work and am waiting on CI. Current status:
- `endojs-endo-but-for-bots-pr416-refresh` — Completion report: endojs-endo-but-for-bots-pr416-refresh
- `endojs-endo-but-for-bots-pr197-44fc0e58` — Done. The acknowledgment is posted and the schedule is live on the journal.
- … and 150 more

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners
