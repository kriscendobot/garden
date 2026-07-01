# Garden bulletin

_As of 2026-07-01T23:21:46Z_

## Latest

The bulletin work moved to the board itself: a new job to teach the [repo-watcher self-healing for a missing timer template](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/improve-repo-watcher-self-heal-missing-template.md) was posted and immediately claimed, joining the in-flight [second PR for #548's inter-package plain re-exports](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/ebfb-pr548-inter-package-re-exports-mechanical-repoint-remove-followup.md) — the mechanical repoint-and-remove follow-up to [endo-but-for-bots#548](https://github.com/endojs/endo-but-for-bots/pull/548). Both are garden-internal plumbing; nothing new landed for maintainer review this cycle, and the 27-deep parked queue is unchanged, still fronted by [endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) (passable byte arrays) and [endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) (EndoRegistry capability), the two most recently parked.

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

### doin (2)
- [`ebfb-pr548-inter-package-re-exports-mechanical-repoint-remove-followup`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/ebfb-pr548-inter-package-re-exports-mechanical-repoint-remove-followup.md) — Write the SECOND PR for #548's inter-package plain re-exports: the mechanical...
- [`improve-repo-watcher-self-heal-missing-template`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/improve-repo-watcher-self-heal-missing-template.md) — In scripts/jobs/repo-watcher.sh, reconcile_set() arms <prefix>@<slug>.timer p...

### tada (825)
- [`agoric-3-proposals-pr1-retcon`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/agoric-3-proposals-pr1-retcon.md) — Completion report — agoric-3-proposals-pr1-retcon
- [`endojs-endo-but-for-bots-pr586-review-73c9bcb3`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr586-review-73c9bcb3.md) — Completion report: endojs-endo-but-for-bots-pr586-review-73c9bcb3
- [`endojs-endo-but-for-bots-pr472-66cd8af6`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr472-66cd8af6.md) — Completion report
- [`endojs-endo-but-for-bots-pr548-a1f701d4`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr548-a1f701d4.md) — Completion report: attention directive on endojs/endo-but-for-bots #548 (comm...
- [`endojs-endo-but-for-bots-pr472-review-f6149cf0`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr472-review-f6149cf0.md) — Completion report: review directive on endojs/endo-but-for-bots PR #472
- … and 820 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`port-xs-to-rust-memory-safe-engine`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine.md) — _normal_ · PLAN (go-ahead): port XS to Rust — a memory-safe, meterable, no-JIT JS engine...
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...

### deferred (top by priority; foreman auto-promotes when idle)
- [`factor-watchdirectory-to-endo-platform`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/factor-watchdirectory-to-endo-platform.md) — _normal_ · Factor watchDirectory out of the daemon into @endo/platform
- [`bot-email-dedicated-domain-counter-plan-aws-hetzner`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/bot-email-dedicated-domain-counter-plan-aws-hetzner.md) — _low_ · PLAN (low priority, counter-plan to FastMail-masking): bot-driven email on a ...
- [`investigate-fastmail-masked-email-api-for-bot-personas`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/investigate-fastmail-masked-email-api-for-bot-personas.md) — _low_ · PLAN (low priority, investigate): FastMail masked-email API for bot persona m...
- [`scholar-ingest-ocap-kernel-comment-fragments-2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scholar-ingest-ocap-kernel-comment-fragments-2.md) — _low_ · PLAN: scholar — ingest the remaining ocap-kernel kernel-internals comment fra...
- [`fix-lint-jsdoc-warnings-endo-master`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/fix-lint-jsdoc-warnings-endo-master.md) — _low_ · SUPERSEDED — fix-lint: jsdoc warnings on endo master

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`formula-inspector-retention-paths-table-v2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/formula-inspector-retention-paths-table-v2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/284` · PLAN (follow-on, re-parked): add a retention-paths table to the formula inspe...
- [`garden-encode-directives-reliably-become-jobs`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/garden-encode-directives-reliably-become-jobs.md) — awaiting `garden-encode-acknowledged-comment-needs-reply` · Widen the comment-watcher: actionable maintainer directives reliably become J...

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 100 gardeners
- [endolinbot2](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot2): 100 gardeners
- [main-host](https://github.com/kriskowal/garden/blob/journal2/hosts/main-host): ? gardeners
