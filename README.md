# Garden bulletin

_As of 2026-06-29T01:52:57Z_

## Latest

Two lint-ratchet jobs landed on endojs/endo — `jsdoc/require-param` and `jsdoc/check-tag-names` are now error-level — alongside a pair of deadmail completions tied to a detached garden deploy that engaged the drain and quiesced the fleet. The board is otherwise quiet: no PRs transitioned this interval, and freshly queued work is routine — the hourly scholar library cycles, the Sunday-evening plan recalibration, and a new `improve-library-regenerator-safety-net-timers` job proposing two standing systemd timers to backstop the library's deterministic regenerator. Nothing here needs maintainer attention beyond the 28 PRs still parked for review.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 18h)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 2d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 3d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 4d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 13d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 38d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 37d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 37d)
- [endojs/endo-but-for-bots#288](https://github.com/endojs/endo-but-for-bots/pull/288) — feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing (waiting 38d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 39d)

_Showing top 10 of 28 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

(no pending maintainer messages)

## Board
### todo (9)
- [`improve-library-regenerator-safety-net-timers`](https://github.com/kriskowal/garden/blob/journal2/jobs/todo/improve-library-regenerator-safety-net-timers.md) — Add two standing systemd safety-net timers so the library's deterministic cou...
- [`plan-recalibrate-20260628-210527`](https://github.com/kriskowal/garden/blob/journal2/jobs/todo/plan-recalibrate-20260628-210527.md) — Weekly plan recalibration and grooming (Sunday evening)
- [`scholar-library-cycle-20260628-183543`](https://github.com/kriskowal/garden/blob/journal2/jobs/todo/scholar-library-cycle-20260628-183543.md) — Hourly scholar library cycle
- [`scholar-library-cycle-20260628-195014`](https://github.com/kriskowal/garden/blob/journal2/jobs/todo/scholar-library-cycle-20260628-195014.md) — Hourly scholar library cycle
- [`scholar-library-cycle-20260628-205020`](https://github.com/kriskowal/garden/blob/journal2/jobs/todo/scholar-library-cycle-20260628-205020.md) — Hourly scholar library cycle
- [`scholar-library-cycle-20260628-215043`](https://github.com/kriskowal/garden/blob/journal2/jobs/todo/scholar-library-cycle-20260628-215043.md) — Hourly scholar library cycle
- [`scholar-library-cycle-20260628-230522`](https://github.com/kriskowal/garden/blob/journal2/jobs/todo/scholar-library-cycle-20260628-230522.md) — Hourly scholar library cycle
- [`scholar-library-cycle-20260629-002001`](https://github.com/kriskowal/garden/blob/journal2/jobs/todo/scholar-library-cycle-20260629-002001.md) — Hourly scholar library cycle
- [`scholar-library-cycle-20260629-012012`](https://github.com/kriskowal/garden/blob/journal2/jobs/todo/scholar-library-cycle-20260629-012012.md) — Hourly scholar library cycle

### doin (0)
(none)

### tada (552)
- [`ratchet-jsdoc-require-param-error-endo`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/ratchet-jsdoc-require-param-error-endo.md) — Completion report: ratchet-jsdoc-require-param-error-endo
- [`deadmail-20260628T181513Z-7ea6f9`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260628T181513Z-7ea6f9.md) — The deploy is now running detached: it has engaged the drain and is waiting f...
- [`deadmail-20260628T180747Z-b1b988`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260628T180747Z-b1b988.md) — Completion report
- [`ratchet-jsdoc-check-tag-names-error-endo`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/ratchet-jsdoc-check-tag-names-error-endo.md) — Completion report: ratchet-jsdoc-check-tag-names-error-endo
- [`deadmail-20260628T180657Z-baff19`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260628T180657Z-baff19.md) — Completion report — deadmail-20260628T180657Z-baff19 (intent of classify-lint...
- … and 547 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`port-xs-to-rust-memory-safe-engine`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine.md) — _normal_ · PLAN (go-ahead): port XS to Rust — a memory-safe, meterable, no-JIT JS engine...
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS

### deferred (top by priority; foreman auto-promotes when idle)
- [`bot-email-dedicated-domain-counter-plan-aws-hetzner`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/bot-email-dedicated-domain-counter-plan-aws-hetzner.md) — _low_ · PLAN (low priority, counter-plan to FastMail-masking): bot-driven email on a ...
- [`investigate-fastmail-masked-email-api-for-bot-personas`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/investigate-fastmail-masked-email-api-for-bot-personas.md) — _low_ · PLAN (low priority, investigate): FastMail masked-email API for bot persona m...
- [`scholar-ingest-ocap-kernel-comment-fragments-2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scholar-ingest-ocap-kernel-comment-fragments-2.md) — _low_ · PLAN: scholar — ingest the remaining ocap-kernel kernel-internals comment fra...
- [`fix-lint-jsdoc-warnings-endo-master`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/fix-lint-jsdoc-warnings-endo-master.md) — _low_ · SUPERSEDED — fix-lint: jsdoc warnings on endo master

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`formula-inspector-retention-paths-table-v2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/formula-inspector-retention-paths-table-v2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/284` · PLAN (follow-on, re-parked): add a retention-paths table to the formula inspe...

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 100 gardeners
- [main-host](https://github.com/kriskowal/garden/blob/journal2/hosts/main-host): ? gardeners
