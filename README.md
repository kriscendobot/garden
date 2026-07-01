# Garden bulletin

_As of 2026-07-01T05:32:39Z_

## Latest

On the garden's own infrastructure, two determinism fixes landed: the watcher's observe-to-post-job path and a requeue-on-incomplete-`claude`-exit safeguard, both now fully deterministic. On the fork side, [endo-but-for-bots#277](https://github.com/endojs/endo-but-for-bots/pull/277) cleared its retcon and is now claimed for a merge conduct, and [endo-but-for-bots#475](https://github.com/endojs/endo-but-for-bots/pull/475) completed. Freshly claimed and in flight: a build to stand [endo-but-for-bots#442](https://github.com/endojs/endo-but-for-bots/pull/442)'s daemon-CAS content-store test on real `@endo/platform` powers (alongside separate attention and review directives on the same PR), an attention directive on [endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58), and a shepherd/fixer round chasing a test-swingset regression on the agoric-sdk fork's PR #7. On garden issue #9, the mhofman contract-control-upgrade test protocol is settled and its baseline run is now executing to completion under a background monitor. Maintainer attention is most owed on the newly-parked [endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) (CapTP error tracing) and the day-old [endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) and [endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403).

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 32s)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 1d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 1d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 5d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 15d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 40d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 40d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 40d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 41d)
- [endojs/endo-but-for-bots#288](https://github.com/endojs/endo-but-for-bots/pull/288) — feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing (waiting 40d)

_Showing top 10 of 28 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

(no pending maintainer messages)

## Board
### todo (0)
(none)

### doin (7)
- [`agoric-sdk-fork-pr-7-shepherd-fixer-swingset-regression`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/agoric-sdk-fork-pr-7-shepherd-fixer-swingset-regression.md) — PR #7 — shepherd/fixer round: test-swingset regression + reply (prior shepher...
- [`endojs-endo-but-for-bots-pr277-conduct`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr277-conduct.md) — conduct (merge) directive on endojs/endo-but-for-bots PR #277
- [`endojs-endo-but-for-bots-pr442-5f20450c`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr442-5f20450c.md) — attention directive on endojs/endo-but-for-bots PR #442
- [`endojs-endo-but-for-bots-pr442-content-store-test-platform-powers`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr442-content-store-test-platform-powers.md) — build: stand the daemon-cas content-store test on real @endo/platform powers
- [`endojs-endo-but-for-bots-pr442-review-ed950329`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr442-review-ed950329.md) — Review directive on endojs/endo-but-for-bots PR #442
- [`endojs-endo-but-for-bots-pr58-4932647c`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr58-4932647c.md) — attention directive on endojs/endo-but-for-bots PR #58
- [`garden-issue-9-run-contract-control-upgrade-test-to-completion`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/garden-issue-9-run-contract-control-upgrade-test-to-completion.md) — #9 — RUN mhofman's contract-control-upgrade test TO COMPLETION and reply (pri...

### tada (779)
- [`endojs-endo-but-for-bots-pr277-retcon`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr277-retcon.md) — Completion report — endojs-endo-but-for-bots-pr277-retcon
- [`garden-watcher-observe-to-postjob-fully-deterministic`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/garden-watcher-observe-to-postjob-fully-deterministic.md) — Completion report: garden-watcher-observe-to-postjob-fully-deterministic
- [`garden-deterministic-requeue-on-incomplete-claude-exit`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/garden-deterministic-requeue-on-incomplete-claude-exit.md) — Completion report
- [`garden-issue-9-mhofman-contract-control-upgrade-test-protocol`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/garden-issue-9-mhofman-contract-control-upgrade-test-protocol.md) — I'll stop polling and let the background monitor notify me when the baseline ...
- [`endojs-endo-but-for-bots-pr475-ae693c7b`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr475-ae693c7b.md) — Completion report
- … and 774 more

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
- [`garden-encode-directives-reliably-become-jobs`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/garden-encode-directives-reliably-become-jobs.md) — awaiting `garden-encode-acknowledged-comment-needs-reply` · Widen the comment-watcher: actionable maintainer directives reliably become J...

## Watch set
(none)

## Hosts
- [endolinbot](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot): 100 gardeners
- [endolinbot2](https://github.com/kriskowal/garden/blob/journal2/hosts/endolinbot2): 100 gardeners
- [main-host](https://github.com/kriskowal/garden/blob/journal2/hosts/main-host): ? gardeners
