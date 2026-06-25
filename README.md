# Garden bulletin

_As of 2026-06-25T17:56:52Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh; the
journalist's narrative leads in the Latest section above. This page (the journal's
README.md) IS the bulletin; the journal's layout and design narrative lives in
[DESIGN.md](DESIGN.md).

## Latest

A review directive on [kriskowal/garden#4](https://github.com/kriskowal/garden/pull/4) was claimed and is now in flight alongside a round-two finalize job for the same PR. Recently landed: the banner-and-set cleanup on [endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503), a new deterministic garden-mirror-closer service, and the bulletin restructure that now leads with this Latest section over the parked-PR queue. Freshly parked for review is [endo-but-for-bots#513](https://github.com/endojs/endo-but-for-bots/pull/513) (the new `@endo/pubsub` package), waiting only a few hours; everything else in the parked list is unchanged.

## Parked for maintainer feedback

- [endojs/Jessie#127](https://github.com/endojs/Jessie/pull/127) — Add Blockly visual programming tools for JSON, Justin, and Jessie (waiting 102d)
- [endojs/endo#2673](https://github.com/endojs/endo/pull/2673) — feat(non-trapping-shim): opt-in shim of the non-trapping integrity trait (waiting 117d)
- [endojs/endo#2675](https://github.com/endojs/endo/pull/2675) — feat(ses,pass-style): use non-trapping integrity trait for safety (waiting 117d)
- [endojs/endo#2701](https://github.com/endojs/endo/pull/2701) — fix(pass-style): fix #2700 ignore more safe async_hook extra properties (waiting 58d)
- [endojs/endo#2797](https://github.com/endojs/endo/pull/2797) — fix(pass-style): avoid symbol-named methods (waiting 118d)
- [endojs/endo#2952](https://github.com/endojs/endo/pull/2952) — fix(ses): fix #2951 stronger sniffing for v8 (waiting 118d)
- [endojs/endo#3073](https://github.com/endojs/endo/pull/3073) — feat(patterns): Add `M.choose` (waiting 43d)
- [endojs/endo#3102](https://github.com/endojs/endo/pull/3102) — chore(ci): create custom CHANGELOG generator (waiting 42d)
- [endojs/endo#3110](https://github.com/endojs/endo/pull/3110) — refactor(error-console-internal): for use only by ses and @endo/errors (waiting 80d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 10d)
- [endojs/endo#3254](https://github.com/endojs/endo/pull/3254) — chore: harden browser-test installation (waiting 2d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 35d)
- [endojs/endo-but-for-bots#112](https://github.com/endojs/endo-but-for-bots/pull/112) — feat(ocapn-noise): Noise IK netlayer (#59 stack 2/3) (waiting 48d)
- [endojs/endo-but-for-bots#113](https://github.com/endojs/endo-but-for-bots/pull/113) — test(ocapn-noise): integration + transport tests (#59 stack 3/3) (waiting 48d)
- [endojs/endo-but-for-bots#166](https://github.com/endojs/endo-but-for-bots/pull/166) — feat(endor): add rust/endor TUI skeleton (re-opened from #31 under the bot) (waiting 47d)
- [endojs/endo-but-for-bots#170](https://github.com/endojs/endo-but-for-bots/pull/170) — feat(pass-style,marshal,eventual-send,captp): pass-style promise + HandledPromise.settle (per #169) (waiting 43d)
- [endojs/endo-but-for-bots#174](https://github.com/endojs/endo-but-for-bots/pull/174) — test: repro empty-{} rendering of Error reasons in disconnect trap (#171) (waiting 43d)
- [endojs/endo-but-for-bots#178](https://github.com/endojs/endo-but-for-bots/pull/178) — refactor(daemon): introduce locator scheme with @-delimited connection hints (per kriskowal #178) (waiting 44d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 34d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 34d)
- [endojs/endo-but-for-bots#231](https://github.com/endojs/endo-but-for-bots/pull/231) — design(familiar): MVR release plan (closes #229) (waiting 24d)
- [endojs/endo-but-for-bots#237](https://github.com/endojs/endo-but-for-bots/pull/237) — design: lal define-jessie tool with Blockly rendering (waiting 41d)
- [endojs/endo-but-for-bots#249](https://github.com/endojs/endo-but-for-bots/pull/249) — design(ses,module-source): top-level-await proposal (leads with the test suite) (waiting 41d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 36d)
- [endojs/endo-but-for-bots#288](https://github.com/endojs/endo-but-for-bots/pull/288) — feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing (waiting 35d)
- [endojs/endo-but-for-bots#329](https://github.com/endojs/endo-but-for-bots/pull/329) — docs: introduce spackle, the polyfill+ponyfill race pattern (waiting 35d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 3d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 1d)
- [endojs/endo-but-for-bots#440](https://github.com/endojs/endo-but-for-bots/pull/440) — feat(daemon,cli,chat): drop @info name hub for formula-inspector design (#439) (waiting 1d)
- [endojs/endo-but-for-bots#442](https://github.com/endojs/endo-but-for-bots/pull/442) — feat(daemon-cas): extract CAS surface into @endo/daemon-cas (waiting 1d)
- [endojs/endo-but-for-bots#513](https://github.com/endojs/endo-but-for-bots/pull/513) — feat(pubsub): create @endo/pubsub with Sink/Spring async promise linked list (changes + latest variants) (waiting 3h)
- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 2d)
- [endojs/playground#14](https://github.com/endojs/playground/pull/14) — feat: rock-paper-scissors (waiting 789d)
## Messages to the maintainer

(no pending maintainer messages)

## Board
### todo (0)
(none)

### doin (5)
- `classify-compartment-mapper-failures` — Classify & investigate compartment-mapper's known test failures, then fan out...
- `finalize-garden-pr4-round2` — Finalize garden#4 per kriskowal's answers to the open questions (review round 2)
- `kriskowal-garden-pr4-review-022d380c` — review directive on kriskowal/garden PR #4
- `reinforce-cw-maintainer-reviews` — Reinforce the comment-watcher: a trusted maintainer's review with inline comm...
- `scholar-ingest-cask-14` — Scholar: continue the library ingest of kriskowal/cask (cycle 15) — comment-f...

### tada (137)
- `bulletin-restructure-latest-top-parked-prs` — Completion report
- `fix-ebfb-pr503-banners-and-set` — Completion report — fix-ebfb-pr503-banners-and-set
- `address-review-garden-pr4` — The worktree was removed (the earlier error was just the shell's cwd being de...
- `endojs-endo-but-for-bots-pr503-7822ef8a` — Completion report — job endojs-endo-but-for-bots-pr503-7822ef8a
- `build-mirror-closer-service` — Completion report — build-mirror-closer-service
- … and 132 more

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners
