# Garden bulletin

_As of 2026-06-25T18:00:12Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh; the
journalist's narrative leads in the Latest section above. This page (the journal's
README.md) IS the bulletin; the journal's layout and design narrative lives in
[DESIGN.md](DESIGN.md).

## Latest

The most urgent item: watchman reports `main2` on host endolinbot is **wedged** — `origin/main2` has advanced but the live tree is stuck at `153c3026` because tracked edits to `scripts/jobs/comment-watcher.sh`, `comment-source-gh.sh`, and `comment-watcher-test.sh` block the fast-forward, so this host won't pick up new roles/skills/scripts until the tree is cleaned.

On the autonomous side, a gardener classified `@endo/compartment-mapper`'s 12 known master test failures into three root causes — ESM dynamic `import()` not traced during archival (10 of 12), the CJS bundler aborting on missing/optional internal modules, and an archive exit-module re-export missing its `notify` notifier — and fanned out one fix job per class, all now in flight. Garden [kriskowal/garden#4](https://github.com/kriskowal/garden/pull/4) round-two work landed (the maintainer-reviews reinforcement and finalize jobs completed), and fresh directives were claimed for [endo-but-for-bots#474](https://github.com/endojs/endo-but-for-bots/pull/474) (retcon) and [endo-but-for-bots#96](https://github.com/endojs/endo-but-for-bots/pull/96) (attention).

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

- `20260625T175821Z-6b5f31` — from watchman, reply_to `watchman-dirty-tree` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260625T175821Z-6b5f31.md)

> watchman: main2 on host endolinbot is WEDGED — this host's deploy is frozen.
>
> origin/main2 has advanced to c81e3641396945f59d9f545e08e6202ba16384bb but the live tree is stuck at 153c30264865a22c97a4e5b351f00e6c7cda4c41: tracked working-tree changes block the fast-forward.
> Until the tree is clean this host will NOT pick up new roles/skills/scripts.
>
> Tracked changes blocking the fast-forward:
> ```
>  M scripts/jobs/comment-watcher.sh
>  M scripts/jobs/handlers/comment-source-gh.sh
>  M scripts/jobs/test/comment-watcher-test.sh
> ```
>
> Verify these are not unsaved work, then clean the tree (checkout/stash) so the watchman can deploy.

- `20260625T175939Z-28a7e0` — from gardener:classify-compartment-mapper-failures, reply_to `classify-compartment-mapper-failures` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260625T175939Z-28a7e0.md)

> Classified @endo/compartment-mapper's 12 known test failures on master (endo-but-for-bots master == endo@master for this package; no bot-master reset needed). All 12 reproduce on master and collapse into **3 root-cause classes**, one fix-proposal job posted per class:
>
> 1. **ESM dynamic `import()` not traced during archival** (10/12) — `dynamic-import-esm` ×5 + `optionalDependencies/esm` ×5, all archive-only combos. Archiver follows only static bindings; dynamically-imported modules are absent from the archive → "Cannot find external module … in archive". Job `fix-compartment-mapper-esm-dynamic-import-archival`.
> 2. **CJS bundler aborts on missing/optional internal modules** (1/12) — `bundle cjs-compat`. Importer tolerates a missing `require('./spam')` as a deferredError; bundler treats it as fatal. Job `fix-compartment-mapper-bundle-missing-deps`.
> 3. **Archive exit-module via `modules` map fails through a re-export** (1/12) — `exit` URL-scheme case. `{ namespace }` record lacks the `notify` export-notifier → `TypeError: notify is not a function` in ses module-instance on re-export. Likely ses+compartment-mapper. Job `fix-compartment-mapper-archive-exit-reexport`.
>
> Full classification (per-test mapping, reproduced errors, fix directions) in journal result entry. No failure left unexplained.


## Board
### todo (0)
(none)

### doin (9)
- `classify-compartment-mapper-failures` — Classify & investigate compartment-mapper's known test failures, then fan out...
- `endojs-endo-but-for-bots-pr474-retcon` — retcon directive on endojs/endo-but-for-bots PR #474
- `endojs-endo-but-for-bots-pr96-0105506f` — attention directive on endojs/endo-but-for-bots PR #96
- `fix-compartment-mapper-archive-exit-reexport` — Fix compartment-mapper: archive exit-module via modules map fails through a r...
- `fix-compartment-mapper-bundle-missing-deps` — Fix compartment-mapper: CJS bundler aborts on missing/optional internal modul...
- `fix-compartment-mapper-esm-dynamic-import-archival` — Fix compartment-mapper: ESM dynamic import() not traced during archival (on m...
- `kriskowal-garden-pr4-b8d45a0f` — attention directive on kriskowal/garden PR #4
- `kriskowal-garden-pr4-review-022d380c` — review directive on kriskowal/garden PR #4
- `scholar-ingest-cask-14` — Scholar: continue the library ingest of kriskowal/cask (cycle 15) — comment-f...

### tada (139)
- `reinforce-cw-maintainer-reviews` — Completion report: reinforce-cw-maintainer-reviews
- `finalize-garden-pr4-round2` — Done. Completion report follows.
- `bulletin-restructure-latest-top-parked-prs` — Completion report
- `fix-ebfb-pr503-banners-and-set` — Completion report — fix-ebfb-pr503-banners-and-set
- `address-review-garden-pr4` — The worktree was removed (the earlier error was just the shell's cwd being de...
- … and 134 more

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners
