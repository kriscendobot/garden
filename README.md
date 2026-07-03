# Garden bulletin

_As of 2026-07-03T15:57:28Z_

## Latest

The **xs2rust-endor stage-3 orchestration halted**: running serially with a halt-on-failure policy, it completed 4 of 7 children before the `collections` child — the Map/Set/ArrayBuffer/TypedArray/BigInt builder for [endojs/endo-but-for-bots#600](https://github.com/endojs/endo-but-for-bots/pull/600) (kept draft) — failed. The reaper dropped that job as POISON after 5 requeue cycles, its handler failing every time; this echoes the stage-2 monolith's repeated deaths at the 2400s handler wall-clock, so the collections/binary-data/BigInt work needs a smaller decomposition or a resumable-worktree budget before it can land. The already-swept `promises` and `xsre` children survived the halt. Two supervisor jobs remain in flight — the Fable XS→Rust supervisor and a fresh press to drive PR #600 toward Endor integration. On the infra side, a reaper improvement landed so a productive cycle resets the overrun counter, and a self-heal check confirmed the `garden-unblock` journal-worktree gitdir fix was already present upstream. No job-board claims or completions otherwise moved since the last bulletin.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 1d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 3d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 4d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 7d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 17d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 42d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 42d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 44d)
- [endojs/endo-but-for-bots#288](https://github.com/endojs/endo-but-for-bots/pull/288) — feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing (waiting 43d)
- [endojs/endo-but-for-bots#329](https://github.com/endojs/endo-but-for-bots/pull/329) — docs: introduce spackle, the polyfill+ponyfill race pattern (waiting 43d)

_Showing top 10 of 27 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260703T152317Z-0f2511` — from reaper:endolinbot2, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260703T152317Z-0f2511.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot2.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: xs2rust-endor-build-stage3-collections
>
> --- original job body ---
> <!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-03T14:12:09Z -->
>
> ---
> model: opus
> ---
> # Builder: xs2rust-endor stage 3 (5/7) — collections, binary data, BigInt (PR #600)
>
> Repo: `endojs/endo-but-for-bots`, branch `xs2rust-endor` (PR #600 — same PR as the design;
> keep DRAFT). Workspace `rust/engine/`. Read in order: `designs/xs2rust-endor-engine.md`
> (§ Resolved Questions is BINDING; § Staged Roadmap "Stage-3 decomposition" is your charter),
> the supervisor's stage-2b review
> (https://github.com/endojs/endo-but-for-bots/pull/600#issuecomment-4872378323), and
> `rust/engine/README.md` (the c/moddable oracle-pin procedure — the shallow sha-fetch is
> rejected upstream; use the documented fallbacks, and mind the empty-gitlink footgun:
> clone into `c/moddable` before any `git -C c/moddable` command; a populated sibling
> checkout under /home/kris/scratch/project-wt-* is the fastest fallback).
>
> You are child 5 of the serial `xs2rust-endor-build-stage3` orchestration. Ground truth
> for every weight and behavior is the pin `48ee02d8cfe0` (xsRun.c, xsMemory.c, and the
> per-built-in sources); the stage-3 bar is dual-run agreement INCLUDING computrons
> (`mxMeterSome` fast-path annotations land in this stage).
>
> **Deliverable:** Map/Set/WeakMap/WeakSet (XS's hashing and entry-slot allocation shapes,
> metered faithfully — entry allocation is `fxNewSlot`-visible and affects computrons);
> ArrayBuffer/TypedArray (every element kind)/DataView with XS's chunk-backed buffer model
> and byte-level metering; BigInt (`XS_BIGINT_METERING` per digit step, the pin's xsBigInt.c
> algorithms reproduced so digit counts — and therefore computrons — agree exactly).
>
> **Acceptance bar:** `built-ins/{Map,Set,WeakMap,WeakSet,ArrayBuffer,TypedArray,DataView,
> BigInt}` dual-run sections: covered agrees bit-exactly INCLUDING computrons, divergent
> **0**, skips named. Report per-section before/after verbatim. Corpus programs over
> collection growth (rehash boundaries), typed-array views/aliasing, and BigInt arithmetic
> spanning digit-count boundaries, bit-exact.
>
> **Standing invariants (every child):** all existing corpora and tests stay green and
> bit-exact (stage-1 86, stage-2 23, stage-2b 33/10/25, the 953-file covered-grammar test);
> the honest covered/skipped split is never diluted (a skip is named, a wrong primitive
> value is a hard divergence); `#![forbid(unsafe_code)]` everywhere but endor-oracle; GC
> suite green under Miri; new grammar gets corpus programs AND fuzz-grammar arms where the
> differential generator can reach it.
>
> Budget discipline: the stage-2 monolith died twice at the 2400s handler wall-clock.
> Commit and push green increments EARLY and often; if the budget nears, push what is
> green and exit WITHOUT the completion signal so the requeue resumes your worktree.
> Do not message the maintainer; a genuinely blocking discovery goes to the supervisor's
> inbox (`/home/kris/scripts/jobs/inbox-send.sh port-xs-to-rust-memory-safe-engine-s6`)
> AND into your tada report. Reopening a resolved design question is a supervisor ruling —
> record it, decide per the design as written, move on.
>
> Report: what landed, acceptance evidence verbatim (section totals, covered/divergent
> counts, computron agreement, Miri run), scope folds/frictions for the supervisor.
> Commit to `xs2rust-endor`, push, keep the PR draft.

- `20260703T152449Z-da14b4` — from orchestrator:xs2rust-endor-build-stage3-halted, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260703T152449Z-da14b4.md)

> Orchestration xs2rust-endor-build-stage3 HALTED: child xs2rust-endor-build-stage3-collections failed (serial, on-child-failure=halt). 4/7 done before halt; swept: xs2rust-endor-build-stage3-promises xs2rust-endor-build-stage3-xsre


## Board
### todo (0)
(none)

### doin (2)
- [`port-xs-to-rust-memory-safe-engine-s6`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/port-xs-to-rust-memory-safe-engine-s6.md) — Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...
- [`xs2rust-endor-press-20260703-152012`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-press-20260703-152012.md) — Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...

### tada (1084)
- [`self-heal-fix-garden-unblock-broken-journal-worktree-gitdir`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/self-heal-fix-garden-unblock-broken-journal-worktree-gitdir.md) — This job is already fully satisfied in origin/main2; no code change is needed.
- [`xs2rust-endor-build-stage3`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xs2rust-endor-build-stage3.md) — orchestration xs2rust-endor-build-stage3 — HALTED
- [`deadmail-20260703T144011Z-dcca23`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260703T144011Z-dcca23.md) — Completion report
- [`improve-reaper-productive-cycle-resets-overrun-counter`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-reaper-productive-cycle-resets-overrun-counter.md) — Completion report
- [`deadmail-20260703T140832Z-8d56e5`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260703T140832Z-8d56e5.md) — Inbox empty. Work complete.
- … and 1079 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...

### deferred (top by priority; foreman auto-promotes when idle)
- [`xs2rust-endor-meter-opcode-cost-instrumentation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-meter-opcode-cost-instrumentation.md) — _normal_ · xs2rust-endor: optional opcode cost-calibration instrumentation
- [`xs2rust-endor-strings-utf16-replace-cesu8`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-strings-utf16-replace-cesu8.md) — _normal_ · xs2rust-endor: replace CESU-8 string storage with UTF-16 (drop the constant-t...
- [`xs2rust-endor-metering-doctrine-accuracy-over-parity`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-metering-doctrine-accuracy-over-parity.md) — _normal_ · xs2rust-endor: revise the metering doctrine to accuracy-over-parity
- [`fix-lint-jsdoc-warnings-endo-master`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/fix-lint-jsdoc-warnings-endo-master.md) — _low_ · SUPERSEDED — fix-lint: jsdoc warnings on endo master
- [`investigate-fastmail-masked-email-api-for-bot-personas`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/investigate-fastmail-masked-email-api-for-bot-personas.md) — _low_ · PLAN (low priority, investigate): FastMail masked-email API for bot persona m...
- [`scholar-ingest-ocap-kernel-comment-fragments-2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scholar-ingest-ocap-kernel-comment-fragments-2.md) — _low_ · PLAN: scholar — ingest the remaining ocap-kernel kernel-internals comment fra...
- [`scheduler-timezone-anchored-cadence`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scheduler-timezone-anchored-cadence.md) — _low_ · design/build: timezone-anchored scheduler cadence (fix daily-progress-summary...
- [`xs2rust-endor-corpus-test262-and-xst-harness`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-corpus-test262-and-xst-harness.md) — _low_ · Designer: converge the xs2rust-endor corpus on test262 + the harness on xst (...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-daemon-rename-to-manager-phase2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/598` · Build: daemon→manager rename Phase 2 (identifier renames)
- [`build-daemon-rename-to-manager-phase3`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase3.md) — awaiting `build-daemon-rename-to-manager-phase2` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 20 gardeners
- [endolinbot2](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot2): 20 gardeners
- [main-host](https://github.com/kriskowal/garden/blob/journal2/hosts/main-host): ? gardeners
