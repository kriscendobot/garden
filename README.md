# Garden bulletin

_As of 2026-06-25T18:51:23Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh; the
journalist's narrative leads in the Latest section above. This page (the journal's
README.md) IS the bulletin; the journal's layout and design narrative lives in
[DESIGN.md](DESIGN.md).

## Latest

Garden infrastructure work landed: a deterministic pre-PR verification harness, a dedicated gitignored scratch tree for job worktrees, a comment-watcher fix that now captures the whole review as one unit, and a fuzzy-ranked top-10 parked-PR queue on this dashboard. A new `add-plan-job-category` job just opened to carve out a "plan" board category for work gated on maintainer go-ahead, joining active threads on the plan-in-journal implementation (garden#4, Phase 0), three compartment-mapper archival fixes (ESM dynamic `import()`, exit-module reexport, CJS missing-deps), and the scholar's cask ingest. On the PR side, [endo-but-for-bots#528](https://github.com/endojs/endo-but-for-bots/pull/528) cleared its panel with the verdict posted and is now waiting on CI before the terminal un-draft. The parked queue still wants a human: [endo-but-for-bots#513](https://github.com/endojs/endo-but-for-bots/pull/513) (new @endo/pubsub) has been waiting 3h, with [endo-but-for-bots#442](https://github.com/endojs/endo-but-for-bots/pull/442), [endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403), and [endo-but-for-bots#440](https://github.com/endojs/endo-but-for-bots/pull/440) all parked a day or more.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#513](https://github.com/endojs/endo-but-for-bots/pull/513) — feat(pubsub): create @endo/pubsub with Sink/Spring async promise linked list (changes + latest variants) (waiting 3h)
- [endojs/endo-but-for-bots#442](https://github.com/endojs/endo-but-for-bots/pull/442) — feat(daemon-cas): extract CAS surface into @endo/daemon-cas (waiting 1d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 1d)
- [endojs/endo-but-for-bots#440](https://github.com/endojs/endo-but-for-bots/pull/440) — feat(daemon,cli,chat): drop @info name hub for formula-inspector design (#439) (waiting 1d)
- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 2d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 3d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 10d)
- [endojs/endo-but-for-bots#231](https://github.com/endojs/endo-but-for-bots/pull/231) — design(familiar): MVR release plan (closes #229) (waiting 24d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 34d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 34d)

_Showing top 10 of 32 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

(no pending maintainer messages)

## Board
### todo (0)
(none)

### doin (7)
- `add-plan-job-category` — Add a "plan" job-board category for jobs gated on maintainer go-ahead or defe...
- `fix-compartment-mapper-archive-exit-reexport` — Fix compartment-mapper: archive exit-module via modules map fails through a r...
- `fix-compartment-mapper-bundle-missing-deps` — Fix compartment-mapper: CJS bundler aborts on missing/optional internal modul...
- `fix-compartment-mapper-esm-dynamic-import-archival` — Fix compartment-mapper: ESM dynamic import() not traced during archival (on m...
- `implement-plan-in-journal` — Implement the plan-in-journal design (garden#4, approved — do NOT merge the PR)
- `plan-in-journal-impl-p0` — build: implement plan-in-journal — Phase 0 (schema, validator, reconciler, on...
- `scholar-ingest-cask-14` — Scholar: continue the library ingest of kriskowal/cask (cycle 15) — comment-f...

### tada (149)
- `build-local-prepr-verification` — Completion report: build-local-prepr-verification
- `comment-watcher-capture-full-review` — Completion report — comment-watcher-capture-full-review
- `garden-dedicated-scratch-dir` — Completion report: garden-dedicated-scratch-dir
- `endojs-endo-but-for-bots-pr528-gauntlet` — Panel complete and verdict posted; waiting on CI before the terminal un-draft...
- `bulletin-parked-prs-fuzzy-sort-top10` — Completion report: bulletin-parked-prs-fuzzy-sort-top10
- … and 144 more

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners
