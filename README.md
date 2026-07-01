# Garden bulletin

_As of 2026-07-01T01:23:36Z_

## Latest

A fresh completion landed on [endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) (CapTP-worker error tracing), but the PR is back in the parked queue (waiting 4m) and a live job — `ebfb-pr-58-fix-error-rendering-verify-in-chrome` — is still open to *actually* fix the error rendering and confirm it in a real Chrome run rather than re-asserting a "verified" that a prior pass couldn't back. The review directive on [endo-but-for-bots#442](https://github.com/endojs/endo-but-for-bots/pull/442) closed out, and the [endo-but-for-bots#277](https://github.com/endojs/endo-but-for-bots/pull/277) review is now waiting on the CI-settle watcher to trigger a conductor merge. On the garden itself, the phase-0 bid/accept market build and the encode of the "verification claims require real evidence" rule both landed on main2, and a new job began teaching the CI classifier to treat Claude Code session/usage-limit errors as transient. The `.js`-extension lint enforcement and EndoMount name-hub unification builds for endo-but-for-bots remain in flight.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 4m)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 20h)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 1d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 4d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 15d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 40d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 39d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 39d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 41d)
- [endojs/endo-but-for-bots#288](https://github.com/endojs/endo-but-for-bots/pull/288) — feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing (waiting 40d)

_Showing top 10 of 28 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

(no pending maintainer messages)

## Board
### todo (0)
(none)

### doin (9)
- [`agoric-sdk-fork-pr-7-shepherd-after-slim-down`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/agoric-sdk-fork-pr-7-shepherd-after-slim-down.md) — PR #7 — shepherd to green after the slim-down/feedback churn (maintainer dire...
- [`build-ebfb-namehub-interface-unification`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/build-ebfb-namehub-interface-unification.md) — Build: EndoMount name-hub interface unification (unblocked by PR #277)
- [`builder-ebfb-enforce-js-extension-jsdoc-import-lint`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/builder-ebfb-enforce-js-extension-jsdoc-import-lint.md) — builder: enforce .js extension on module specifiers via lint (endojs/endo-but...
- [`deadmail-issue-comment-4849045455`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/deadmail-issue-comment-4849045455.md) — Dead-lettered message — pick up its intent
- [`ebfb-pr-58-fix-error-rendering-verify-in-chrome`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/ebfb-pr-58-fix-error-rendering-verify-in-chrome.md) — PR #58 — actually fix the error rendering AND verify in real Chrome (prior "v...
- [`endojs-endo-but-for-bots-pr442-review-ea91182a`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr442-review-ea91182a.md) — Review directive on endojs/endo-but-for-bots PR #442
- [`enforce-js-extension-lint-endo-but-for-bots`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/enforce-js-extension-lint-endo-but-for-bots.md) — Builder: enforce .js extension on imports via lint (endojs/endo-but-for-bots)
- [`improve-classify-claude-session-limit-as-transient`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/improve-classify-claude-session-limit-as-transient.md) — Add the Claude Code session/usage-limit signature to the canonical transient-...
- [`issue-kriskowal-garden-20`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/issue-kriskowal-garden-20.md) — Issue from kriskowal on kriskowal/garden #20

### tada (748)
- [`endojs-endo-but-for-bots-pr58-15926293`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr58-15926293.md) — Completion report
- [`build-bid-accept-market-phase0-1`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/build-bid-accept-market-phase0-1.md) — Completion report
- [`endojs-endo-but-for-bots-pr277-review-64e9f470`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr277-review-64e9f470.md) — Waiting on the CI-settle watcher; I'll dispatch the conductor merge once chec...
- [`garden-encode-verification-claims-require-real-evidence`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/garden-encode-verification-claims-require-real-evidence.md) — The work is complete and landed on main2. Here is my completion report.
- [`endojs-endo-but-for-bots-pr442-f8df35b4`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr442-f8df35b4.md) — Completion report
- … and 743 more

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
