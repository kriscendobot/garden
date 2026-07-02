# Garden bulletin

_As of 2026-07-02T00:16:31Z_

## Latest

Little moved on the board this cycle: the sole completion was [`scholar-ingest-cloudflare-w4p-references`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-ingest-cloudflare-w4p-references.md), folding the Cloudflare "workers-for-platforms" references into the library. Two builds remain in flight — the `daemon.js → manager.js` rename (Daemon/Mignonic → Manager/Worker) and the orchestration-job pattern that sequences planned sub-jobs and watches its children. One item wants your call: a `liaison:follow-up` message reports the botanist's finding that recurring board audits, if you want them as a standing capability, belong on `foreman`/`watchman` or a new deterministic script rather than the `botanist` role — an architecture decision to make before any role/script work is posted. The review queue is otherwise the story: 27 PRs are parked for you, the freshest being [endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) (passable byte arrays, ~1d) and [endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) (EndoRegistry capability, ~2d), with [endo#3137](https://github.com/endojs/endo/pull/3137) (.ts runtime modules) now 16 days out.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 1d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 2d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 5d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 16d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 41d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 40d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 40d)
- [endojs/endo-but-for-bots#288](https://github.com/endojs/endo-but-for-bots/pull/288) — feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing (waiting 41d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 42d)
- [endojs/endo-but-for-bots#329](https://github.com/endojs/endo-but-for-bots/pull/329) — docs: introduce spackle, the polyfill+ponyfill race pattern (waiting 42d)

_Showing top 10 of 27 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260702T000821Z-0c2b43` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260702T000821Z-0c2b43.md)

> The botanist-refresh-the-board report recommends that recurring board audits, if wanted as a standing capability, be implemented on `foreman`/`watchman` or as a new deterministic script rather than as a `botanist` responsibility. This is a garden-architecture decision (whether to add the capability at all, and where) — your call before any role/script work is posted.


## Board
### todo (0)
(none)

### doin (2)
- [`build-daemon-rename-to-manager`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/build-daemon-rename-to-manager.md) — Build: rename daemon.js → manager.js (Daemon/Mignonic → Manager/Worker)
- [`garden-build-orchestration-job-pattern-sequence-and-watch-children`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/garden-build-orchestration-job-pattern-sequence-and-watch-children.md) — Build the orchestration-job pattern: an orchestrator that sequences planned s...

### tada (836)
- [`scholar-ingest-cloudflare-w4p-references`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-ingest-cloudflare-w4p-references.md) — Completion report
- [`garden-encode-directives-reliably-become-jobs`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/garden-encode-directives-reliably-become-jobs.md) — Completion report
- [`factor-watchdirectory-to-endo-platform`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/factor-watchdirectory-to-endo-platform.md) — Job complete: factor watchDirectory into @endo/platform
- [`groom-refine-endo-roadmap`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/groom-refine-endo-roadmap.md) — Completion report
- [`dispatch-next-batch-build-jobs-for-ready-designs-current-milestone`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/dispatch-next-batch-build-jobs-for-ready-designs-current-milestone.md) — Completion report — batch design→build dispatch for the current active milestone
- … and 831 more

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
