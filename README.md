# Garden bulletin

_As of 2026-07-02T00:07:08Z_

## Latest

The batch design→build dispatch for the current active milestone [completed](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/dispatch-next-batch-build-jobs-for-ready-designs-current-milestone.md), clearing the last active claim into `tada` and leaving `todo` empty. Six jobs remain in flight — the daemon→manager rename, the `watchDirectory`→`@endo/platform` factoring, the orchestration-job pattern build, the comment-watcher directive-to-job widening, the endo-roadmap groom, and the Cloudflare Workers-for-Platforms scholar ingest — but none advanced this cycle. Nothing new landed for maintainer review; the freshest items still parked are [endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) (passable byte arrays, 1d) and [endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) (EndoRegistry capability, 2d).

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

(no pending maintainer messages)

## Board
### todo (0)
(none)

### doin (6)
- [`build-daemon-rename-to-manager`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/build-daemon-rename-to-manager.md) — Build: rename daemon.js → manager.js (Daemon/Mignonic → Manager/Worker)
- [`factor-watchdirectory-to-endo-platform`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/factor-watchdirectory-to-endo-platform.md) — Factor watchDirectory out of the daemon into @endo/platform
- [`garden-build-orchestration-job-pattern-sequence-and-watch-children`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/garden-build-orchestration-job-pattern-sequence-and-watch-children.md) — Build the orchestration-job pattern: an orchestrator that sequences planned s...
- [`garden-encode-directives-reliably-become-jobs`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/garden-encode-directives-reliably-become-jobs.md) — Widen the comment-watcher: actionable maintainer directives reliably become J...
- [`groom-refine-endo-roadmap`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/groom-refine-endo-roadmap.md) — Groom: refine the endo roadmap
- [`scholar-ingest-cloudflare-w4p-references`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/scholar-ingest-cloudflare-w4p-references.md) — Scholar: ingest Cloudflare Workers for Platforms — reference pages

### tada (832)
- [`dispatch-next-batch-build-jobs-for-ready-designs-current-milestone`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/dispatch-next-batch-build-jobs-for-ready-designs-current-milestone.md) — Completion report — batch design→build dispatch for the current active milestone
- [`scholar-ingest-cloudflare-w4p-remainder`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-ingest-cloudflare-w4p-remainder.md) — Completion report
- [`botanist-refresh-the-board`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/botanist-refresh-the-board.md) — What I did
- [`scholar-ingest-cloudflare-workers-for-platforms`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-ingest-cloudflare-workers-for-platforms.md) — Completion report
- [`improve-repo-watcher-self-heal-missing-template`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-repo-watcher-self-heal-missing-template.md) — Completion report
- … and 827 more

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
