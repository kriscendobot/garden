# Garden bulletin

_As of 2026-07-03T11:23:24Z_

## Latest

The reaper on endolinbot2 gave up on the `xs2rust-endor-build-stage3-arrays` builder ([endo-but-for-bots#600](https://github.com/endojs/endo-but-for-bots/pull/600)) after five requeue cycles and dropped it from the board as POISON — its handler failed every attempt, and the failure is now parked in the maintainer inbox. That stage-3 arrays child is the one repeatedly hitting the 2400s handler wall-clock; a separate `xs2rust-endor-press` job is in flight to push PR #600 toward endor integration and a green daemon test, but the poisoned child likely needs a look. Meanwhile the journal self-heal sweep continues: a fix landed for the mirror-closer's stale journal-worktree gitdir, and a new job to harden `journal_remote()` against transient dangling-gitdir failures is now in progress. No PRs merged or newly parked this cycle.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 20h)
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

- `20260703T112307Z-aa861b` — from reaper:endolinbot2, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260703T112307Z-aa861b.md)

> POISON job dropped from the board after 5 requeue cycles on endolinbot2.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> Original job base: xs2rust-endor-build-stage3-arrays
>
> --- original job body ---
> <!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-03T07:19:42Z -->
>
> ---
> model: opus
> ---
> # Builder: xs2rust-endor stage 3 (3/7) — arrays and the iteration protocol (PR #600)
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
> You are child 3 of the serial `xs2rust-endor-build-stage3` orchestration. Ground truth
> for every weight and behavior is the pin `48ee02d8cfe0` (xsRun.c, xsMemory.c, and the
> per-built-in sources); the stage-3 bar is dual-run agreement INCLUDING computrons
> (`mxMeterSome` fast-path annotations land in this stage).
>
> **Deliverable:** the Array exotic object (index/`length` semantics per `fxArraySetLength`),
> array literals/holes/spread, `Array` constructor + statics (`isArray`, `of`, `from` within
> reach), `Array.prototype` methods with their `mxMeterSome` fast-path annotations exactly
> where the pin places them, and the iteration protocol: `for-in` (enumeration order per
> XS), `for-of`, array and string iterators (generators themselves stay stage 4 per the
> roadmap).
>
> **Acceptance bar:** `built-ins/Array` dual-run sections: covered agrees bit-exactly
> INCLUDING computrons, divergent **0**, skips named. `language/statements/{for-in,for-of}`
> covered grows; report before/after verbatim. Corpus programs over literals, mutation
> methods, iteration, and spread, bit-exact.
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


## Board
### todo (0)
(none)

### doin (2)
- [`improve-journal-remote-self-heal`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/improve-journal-remote-self-heal.md) — Harden journal_remote() in scripts/jobs/common.sh (lines 490-494) so a transi...
- [`xs2rust-endor-press-20260703-112004`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-press-20260703-112004.md) — Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...

### tada (1060)
- [`self-heal-fix-garden-mirror-closer-stale-journal-worktree-gitdir`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/self-heal-fix-garden-mirror-closer-stale-journal-worktree-gitdir.md) — Completion report
- [`self-heal-fix-garden-deadmail-journal-worktree-dangling-gitdir`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/self-heal-fix-garden-deadmail-journal-worktree-dangling-gitdir.md) — Completion report
- [`self-heal-fix-garden-follow-up-journal-remote-dangling-gitdir-fallback`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/self-heal-fix-garden-follow-up-journal-remote-dangling-gitdir-fallback.md) — Completion report
- [`self-heal-fix-garden-comment-watcher-endojs-endo-but-for-bots-journal-worktree-dangling-gitdir`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/self-heal-fix-garden-comment-watcher-endojs-endo-but-for-bots-journal-worktree-dangling-gitdir.md) — Completion report
- [`self-heal-fix-garden-gardener-scaler-journal-worktree-gitdir-repair`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/self-heal-fix-garden-gardener-scaler-journal-worktree-gitdir-repair.md) — Completion report
- … and 1055 more

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
- [`port-xs-to-rust-memory-safe-engine-s6`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine-s6.md) — awaiting `xs2rust-endor-build-stage3` · Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 20 gardeners
- [endolinbot2](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot2): 20 gardeners
- [main-host](https://github.com/kriskowal/garden/blob/journal2/hosts/main-host): ? gardeners
