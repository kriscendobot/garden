# Garden bulletin

_As of 2026-07-03T05:57:32Z_

## Latest

Here is the body for the "## Latest" section:

The mentor-improvement track advanced: [`improve-mentor-skip-already-fixed-improve-jobs`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-mentor-skip-already-fixed-improve-jobs.md) completed, teaching the mentor to skip improve-jobs whose fix has already landed, and a companion job to give mentor-emitted jobs a stable directive identity for dedup is now in flight. The bulk of live work sits on the XS→Rust (Endor) port: stage-3 fundamentals building (constructors, Object, Function) with a scholar ingesting danfinley/quickjs at `native-ses` to inform the XS-evolution implementation. On the review front, [endojs/endo-but-for-bots#600](https://github.com/endojs/endo-but-for-bots/pull/600) landed, and 27 PRs remain parked for kriskowal — the oldest of note being [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) (`.ts` runtime modules via erasable type syntax, 17 days waiting) and the passable-byte-arrays work in [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503).

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 15h)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 3d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 3d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 7d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 17d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 42d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 42d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 43d)
- [endojs/endo-but-for-bots#288](https://github.com/endojs/endo-but-for-bots/pull/288) — feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing (waiting 43d)
- [endojs/endo-but-for-bots#329](https://github.com/endojs/endo-but-for-bots/pull/329) — docs: introduce spackle, the polyfill+ponyfill race pattern (waiting 43d)

_Showing top 10 of 27 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

(no pending maintainer messages)

## Board
### todo (0)
(none)

### doin (4)
- [`design-feedback-review-retrospective-loop`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/design-feedback-review-retrospective-loop.md) — designer: the double-loop — treat every PR comment as an indictment of the re...
- [`improve-mentor-improve-job-identity-dedup`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/improve-mentor-improve-job-identity-dedup.md) — Give mentor-emitted jobs a stable directive identity so re-detections of the ...
- [`scholar-ingest-quickjs-native-ses`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/scholar-ingest-quickjs-native-ses.md) — scholar: ingest danfinlay/quickjs @ native-ses for XS-evolution implementatio...
- [`xs2rust-endor-build-stage3-fundamentals`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-build-stage3-fundamentals.md) — Builder: xs2rust-endor stage 3 (2/7) — fundamentals: constructors, Object, Fu...

### tada (1028)
- [`improve-mentor-skip-already-fixed-improve-jobs`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-mentor-skip-already-fixed-improve-jobs.md) — Completion report
- [`endojs-endo-but-for-bots-pr600-6983cac7`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr600-6983cac7.md) — Completion report
- [`xs2rust-endor-press-20260703-053522`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xs2rust-endor-press-20260703-053522.md) — **Press check-in complete: observe-and-defer — the stage-3 build chain owns t...
- [`improve-xs2rust-press-preflight`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-xs2rust-press-preflight.md) — Completion report
- [`xs2rust-endor-build-stage3-language`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xs2rust-endor-build-stage3-language.md) — Stage-3 child-1 (language) — completion report
- … and 1023 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...

### deferred (top by priority; foreman auto-promotes when idle)
- [`xs2rust-endor-meter-opcode-cost-instrumentation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-meter-opcode-cost-instrumentation.md) — _normal_ · xs2rust-endor: optional opcode cost-calibration instrumentation
- [`xs2rust-endor-strings-utf16-replace-cesu8`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-strings-utf16-replace-cesu8.md) — _normal_ · xs2rust-endor: replace CESU-8 string storage with UTF-16 (drop the constant-t...
- [`fix-lint-jsdoc-warnings-endo-master`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/fix-lint-jsdoc-warnings-endo-master.md) — _low_ · SUPERSEDED — fix-lint: jsdoc warnings on endo master
- [`investigate-fastmail-masked-email-api-for-bot-personas`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/investigate-fastmail-masked-email-api-for-bot-personas.md) — _low_ · PLAN (low priority, investigate): FastMail masked-email API for bot persona m...
- [`scholar-ingest-ocap-kernel-comment-fragments-2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scholar-ingest-ocap-kernel-comment-fragments-2.md) — _low_ · PLAN: scholar — ingest the remaining ocap-kernel kernel-internals comment fra...
- [`scheduler-timezone-anchored-cadence`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scheduler-timezone-anchored-cadence.md) — _low_ · design/build: timezone-anchored scheduler cadence (fix daily-progress-summary...
- [`xs2rust-endor-corpus-test262-and-xst-harness`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-corpus-test262-and-xst-harness.md) — _low_ · Designer: converge the xs2rust-endor corpus on test262 + the harness on xst (...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-daemon-rename-to-manager-phase2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/598` · Build: daemon→manager rename Phase 2 (identifier renames)
- [`build-daemon-rename-to-manager-phase3`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase3.md) — awaiting `build-daemon-rename-to-manager-phase2` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`build-feedback-review-retrospective-loop`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-feedback-review-retrospective-loop.md) — awaiting `design-feedback-review-retrospective-loop` · builder: implement the double-loop feedback-retrospective self-improvement me...
- [`port-xs-to-rust-memory-safe-engine-s6`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine-s6.md) — awaiting `xs2rust-endor-build-stage3` · Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 20 gardeners
- [endolinbot2](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot2): 20 gardeners
- [main-host](https://github.com/kriskowal/garden/blob/journal2/hosts/main-host): ? gardeners
