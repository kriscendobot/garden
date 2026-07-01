# Garden bulletin

_As of 2026-07-01T05:52:16Z_

## Latest

The error-tracing work on [endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) (CapTP-worker error tracing) closed out and the PR is now freshly parked for kriskowal's review at the top of the queue. A new garden-infra job to add elapsed-constancy early-escalation to `gardener.sh` was claimed and is in flight, alongside the ongoing #58 test-vs-local stack-trace race diagnosis, the gardener project-worktree isolation fix, and the [issue #9](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/garden-issue-9-run-contract-control-upgrade-test-to-completion.md) contract-control-upgrade test run.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 16m)
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

### doin (4)
- [`ebfb-pr-58-error-bubble-watch-stacktrace-race`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/ebfb-pr-58-error-bubble-watch-stacktrace-race.md) — PR #58 — diagnose the test-vs-local race; make the error bubble watch for the...
- [`garden-fix-gardener-project-worktree-isolation-collision`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/garden-fix-gardener-project-worktree-isolation-collision.md) — Fix: gardeners working a project repo must get ISOLATED worktrees (concurrent...
- [`garden-issue-9-run-contract-control-upgrade-test-to-completion`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/garden-issue-9-run-contract-control-upgrade-test-to-completion.md) — #9 — RUN mhofman's contract-control-upgrade test TO COMPLETION and reply (pri...
- [`improve-gardener-elapsed-constancy-early-escalation`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/improve-gardener-elapsed-constancy-early-escalation.md) — In scripts/jobs/gardener.sh, implement the elapsed-constancy early-escalation...

### tada (785)
- [`endojs-endo-but-for-bots-pr58-4932647c`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr58-4932647c.md) — Completion report — job endojs-endo-but-for-bots-pr58-4932647c
- [`endojs-endo-but-for-bots-pr442-content-store-test-platform-powers`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr442-content-store-test-platform-powers.md) — Completion report: endojs-endo-but-for-bots-pr442-content-store-test-platform...
- [`endojs-endo-but-for-bots-pr442-review-ed950329`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr442-review-ed950329.md) — Completion report — PR #442 review by kriskowal (pullrequestreview-4605966130)
- [`endojs-endo-but-for-bots-pr277-conduct`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr277-conduct.md) — Still watching (4/24 pending). The harness will re-invoke me when the backgro...
- [`endojs-endo-but-for-bots-pr442-5f20450c`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr442-5f20450c.md) — Completion report — endojs-endo-but-for-bots-pr442-5f20450c
- … and 780 more

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
