# Garden bulletin

_As of 2026-06-30T20:10:38Z_

## Latest

Bot-side, the lone item that moved since the last bulletin is [kriskowal/garden#9](https://github.com/kriskowal/garden/issues/9)'s reply to mhofman on the functor value-stack thread, which completed — the queue is otherwise idle (todo and doin both empty). Worth a maintainer's eye: ten PRs are parked awaiting review, the oldest being [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) (erasable-type-syntax `.ts` runtime modules, 15 days) and [endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) (Web Speech voice input, 40 days), while the freshest are [endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) (CapTP error tracing) and [endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) (passable byte arrays), each ~15h in. Four plans still sit on the runway awaiting go-ahead, including verifying the ymax0 hex fix and the XS-to-Rust port.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 15h)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 15h)
- [endojs/endo-but-for-bots#343](https://github.com/endojs/endo-but-for-bots/pull/343) — design(gateway): overarching @endo/gateway package integrating the gateway/weblet/Noise cluster (waiting 1d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 1d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 4d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 15d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 40d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 39d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 39d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 41d)

_Showing top 10 of 29 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

(no pending maintainer messages)

## Board
### todo (0)
(none)

### doin (0)
(none)

### tada (698)
- [`garden-issue-9-reply-mhofman-functor-stack`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/garden-issue-9-reply-mhofman-functor-stack.md) — Completion report
- [`endojs-endo-but-for-bots-pr475-179927d7`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr475-179927d7.md) — Completion report — job endojs-endo-but-for-bots-pr475-179927d7
- [`improve-dependabotany-self-schedule-precise-recheck`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-dependabotany-self-schedule-precise-recheck.md) — Completion report
- [`dependabotany-recheck-endo-but-for-bots-20260630-143503`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/dependabotany-recheck-endo-but-for-bots-20260630-143503.md) — Completion report
- [`daily-progress-summary-20260630-143503`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/daily-progress-summary-20260630-143503.md) — The periodical is landed on origin/journal2 (442be7523), inbox empty, and thi...
- … and 693 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`port-xs-to-rust-memory-safe-engine`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine.md) — _normal_ · PLAN (go-ahead): port XS to Rust — a memory-safe, meterable, no-JIT JS engine...
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...

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
- [endolinbot2](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot2): 100 gardeners
- [main-host](https://github.com/kriskowal/garden/blob/journal2/hosts/main-host): ? gardeners
