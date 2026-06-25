# Garden bulletin

_As of 2026-06-25T20:20:07Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh; the
journalist's narrative leads in the Latest section above. This page (the journal's
README.md) IS the bulletin; the journal's layout and design narrative lives in
[DESIGN.md](DESIGN.md).

## Latest

The bulletin advanced on a single transition: the [endo-but-for-bots#509](https://github.com/endojs/endo-but-for-bots/pull/509) review (mirror of endo#3099, kriskowal's review) completed and moved to done — a gardener resolved 2 of 3 inline asks and pushed `af5894487`: restored `@ts-expect-error` annotations across the module-source files under the pinned `@babel` types (verified by tsc), and reseeded the zip benchmark-writer's corpus with `@endo/chacha12` instead of an ad hoc xorshift (benchmark + zip tests pass). The third ask — a request to profile agoric-sdk bundle generation — is parked in the maintainer inbox and needs kriskowal's call, since standing scope bars autonomous bot work on agoric-sdk; the gardener has replied on the thread that it's tracked pending direction and laid out three options (human runs the profiling, an explicit one-off authorization, or noting the report as deferred).

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#178](https://github.com/endojs/endo-but-for-bots/pull/178) — refactor(daemon): introduce locator scheme with @-delimited connection hints (per kriskowal #178) (waiting 16m)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 1h)
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

- `20260625T201849Z-31cb96` — from gardener:endojs-endo-but-for-bots-pr509-review-3c944985, reply_to `endojs-endo-but-for-bots-pr509-review-3c944985` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260625T201849Z-31cb96.md)

> PR #509 (mirror of endo#3099) review by kriskowal — 2 of 3 inline asks resolved and pushed (af5894487):
>  1. analyzer.test.js "@ts-expect-error vs @ts-ignore": restored @ts-expect-error across the module-source files the "tolerate babel type drift" commit weakened — all type-check under the pinned @babel types (verified by tsc).
>  2. zip benchmark-writer.mjs: now seeds its corpus with @endo/chacha12 instead of an ad hoc xorshift; benchmark + zip tests pass.
>
> The 3rd ask needs YOUR call — it is out of my autonomous scope:
>  zip-base64.js comment: "@kriscendobot ... Please profile agoric-sdk bundle generation and provide a report."
>  Profiling agoric-sdk bundle generation requires standing up and running the agoric-sdk monorepo, which is unconditionally off-limits for autonomous bot work (standing scope rule: bot repo + bot forks only, never agoric-sdk). I can't self-authorize it.
>  Options: (a) you/a human run the profiling and I help draft the report from the numbers, (b) you explicitly authorize a one-off agoric-sdk profiling run, or (c) we note on the thread that the cache-profiling report is deferred. I've replied on the thread that it's tracked pending your direction. Which would you like?


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

### tada (156)
- `endojs-endo-but-for-bots-pr509-review-3c944985` — Completion report — PR #509 review (kriskowal) on endojs/endo-but-for-bots
- `address-pr528-dts-types` — address-pr528-dts-types — completion report
- `endojs-endo-but-for-bots-pr178-rebase` — Completion report: endojs-endo-but-for-bots-pr178-rebase
- `endojs-endo-but-for-bots-pr178-gauntlet` — I've completed the core gauntlet work and am waiting on CI. Current status:
- `endojs-endo-but-for-bots-pr416-refresh` — Completion report: endojs-endo-but-for-bots-pr416-refresh
- … and 151 more

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners
