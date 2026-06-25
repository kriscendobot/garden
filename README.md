# Garden bulletin

_As of 2026-06-25T21:13:01Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh; the
journalist's narrative leads in the Latest section above. This page (the journal's
README.md) IS the bulletin; the journal's layout and design narrative lives in
[DESIGN.md](DESIGN.md).

## Latest

I'll write the bulletin's "## Latest" section based on the board transitions.

Two job-board completions landed since the last bulletin: [endo-but-for-bots#475](https://github.com/endojs/endo-but-for-bots/pull/475) saw an attention-directive job (`48532f80`) wrap up with a completion report, while two further #475 directives (`7a9cc2ee`, `f56659bc`) remain in flight. On the compartment-mapper front, `fix-compartment-mapper-esm-dynamic-import-archival` completed after its CI poll, joining the earlier `fix-compartment-mapper-archive-exit-reexport` fix. The scholar's ingest of kriskowal/cask continues (cycle 16). Nothing new awaits the maintainer beyond the existing parked queue — most pressing of which is [endo-but-for-bots#513](https://github.com/endojs/endo-but-for-bots/pull/513) (the new @endo/pubsub package), now waiting 6h.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#178](https://github.com/endojs/endo-but-for-bots/pull/178) — refactor(daemon): introduce locator scheme with @-delimited connection hints (per kriskowal #178) (waiting 11m)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 29m)
- [endojs/endo-but-for-bots#513](https://github.com/endojs/endo-but-for-bots/pull/513) — feat(pubsub): create @endo/pubsub with Sink/Spring async promise linked list (changes + latest variants) (waiting 6h)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 1d)
- [endojs/endo-but-for-bots#440](https://github.com/endojs/endo-but-for-bots/pull/440) — feat(daemon,cli,chat): drop @info name hub for formula-inspector design (#439) (waiting 1d)
- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 2d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 3d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 10d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 35d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 34d)

_Showing top 10 of 31 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

(no pending maintainer messages)

## Board
### todo (0)
(none)

### doin (3)
- `endojs-endo-but-for-bots-pr475-7a9cc2ee` — attention directive on endojs/endo-but-for-bots PR #475
- `endojs-endo-but-for-bots-pr475-f56659bc` — attention directive on endojs/endo-but-for-bots PR #475
- `scholar-ingest-cask-15` — Scholar: continue the library ingest of kriskowal/cask (cycle 16) — comment-f...

### tada (174)
- `fix-compartment-mapper-esm-dynamic-import-archival` — The CI poll is in progress. I'll await the completion notification before wri...
- `endojs-endo-but-for-bots-pr475-48532f80` — Done. Completion report:
- `fix-compartment-mapper-archive-exit-reexport` — Completion report: fix-compartment-mapper-archive-exit-reexport
- `plan-in-journal-impl-p0` — Completion report — job plan-in-journal-impl-p0
- `implement-plan-phase1-endo-redirect` — Completion report: implement-plan-phase1-endo-redirect
- … and 169 more

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners
