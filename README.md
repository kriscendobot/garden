# Garden bulletin

_As of 2026-06-25T21:30:30Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh; the
journalist's narrative leads in the Latest section above. This page (the journal's
README.md) IS the bulletin; the journal's layout and design narrative lives in
[DESIGN.md](DESIGN.md).

## Latest

No board transitions resolved since the last bulletin; two jobs remain in flight — the bulletin's own [plan-queue display](https://github.com/endojs/endo-but-for-bots) work and the scholar's cycle-16 ingest of kriskowal/cask. The freshest completions cleared review and follow-up work on [endo-but-for-bots#475](https://github.com/endojs/endo-but-for-bots/pull/475) and [endo-but-for-bots#525](https://github.com/endojs/endo-but-for-bots/pull/525). Worth a look at the top of the parked queue: the @-delimited locator scheme in [endo-but-for-bots#178](https://github.com/endojs/endo-but-for-bots/pull/178) and the passable-byte-arrays work in [endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) have both surfaced in the last hour, and the [@endo/pubsub](https://github.com/endojs/endo-but-for-bots/pull/513) Sink/Spring PR has been waiting six hours.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#178](https://github.com/endojs/endo-but-for-bots/pull/178) — refactor(daemon): introduce locator scheme with @-delimited connection hints (per kriskowal #178) (waiting 32m)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 50m)
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

### doin (2)
- `bulletin-show-plan-queue` — Bulletin: display the jobs/plan/ queue (parked plan jobs) — "## Plan queue" s...
- `scholar-ingest-cask-15` — Scholar: continue the library ingest of kriskowal/cask (cycle 16) — comment-f...

### tada (177)
- `endojs-endo-but-for-bots-pr475-7a9cc2ee` — Completion report
- `endojs-endo-but-for-bots-pr525-review-25103d76` — Completion report
- `endojs-endo-but-for-bots-pr475-f56659bc` — Completion report
- `fix-compartment-mapper-esm-dynamic-import-archival` — The CI poll is in progress. I'll await the completion notification before wri...
- `endojs-endo-but-for-bots-pr475-48532f80` — Done. Completion report:
- … and 172 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
(none)

### deferred (top by priority; foreman auto-promotes when idle)
- `investigate-systemd-run-vs-gardener-loops` — _normal_ · PLAN: investigate systemd-run vs. the fixed 100-gardener-loop pool → garden d...
- `investigate-resumable-gardeners` — _normal_ · PLAN: investigate making gardeners RESUMABLE (don't lose work when an agent s...
- `ingest-ocap-library-sections` — _normal_ · PLAN: scholar — ingest sources for six missing ocap library sections
- `ingest-ocap-kernel` — _normal_ · PLAN: scholar — ingest MetaMask/ocap-kernel into the library
- `classify-lint-endo-master` — _low_ · PLAN: classify lint errors on endo master, then post per-class fix plans

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners
