# Garden bulletin

_As of 2026-06-30T23:21:06Z_

## Latest

Two completions landed since the last bulletin. The shepherd rebased [endo-but-for-bots#277](https://github.com/endojs/endo-but-for-bots/pull/277) onto current `llm`, force-pushed, and CI is re-running on the macOS path; separately, the title, description, and template were refreshed on the agoric-sdk fork's [kriscendobot/agoric-sdk#7](https://github.com/kriscendobot/agoric-sdk/pull/7). Newly claimed and in flight: a refresh directive on [endo-but-for-bots#197](https://github.com/endojs/endo-but-for-bots/pull/197) (the electron 40→42 bump, now also under a one-time embargo reevaluation), plus two strands of the [kriskowal/garden#9](https://github.com/kriskowal/garden/issues/9) ymax0 repro work — folding in kriskowal's mainnet-validation-tree bundle-publishing examples and mhofman's contract-kit/Inquisitor-bridge guidance. Maintainer attention is most useful on the freshly parked [endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) (CapTP error tracing, waiting 13m).

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 13m)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 18h)
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

### doin (5)
- [`dependabotany-recheck-endo-but-for-bots-pr197`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/dependabotany-recheck-endo-but-for-bots-pr197.md) — One-time embargo reevaluation: endojs/endo-but-for-bots PR #197 (electron 40→42)
- [`ebfb-retention-paths-chat-panel`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/ebfb-retention-paths-chat-panel.md) — Build: retention-paths Chat UI Paths panel (read-only) — next phase after #284
- [`endojs-endo-but-for-bots-pr197-refresh`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr197-refresh.md) — refresh directive on endojs/endo-but-for-bots PR #197
- [`garden-issue-9-kriskowal-mainnet-validation-tree-bundle-publish`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/garden-issue-9-kriskowal-mainnet-validation-tree-bundle-publish.md) — #9 ymax0 repro — use the mainnet-validation-tree bundle-publishing examples (...
- [`garden-issue-9-mhofman-contract-kit-and-inquisitor-bridge`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/garden-issue-9-mhofman-contract-kit-and-inquisitor-bridge.md) — Incorporate mhofman's latest #9 guidance (contract-kit reachability + Inquisi...

### tada (720)
- [`agoric-sdk-fork-pr-7-update-title-description-template`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/agoric-sdk-fork-pr-7-update-title-description-template.md) — Completion report
- [`ebfb-pr-277-shepherd-macos-and-reply`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/ebfb-pr-277-shepherd-macos-and-reply.md) — I've rebased PR #277 onto current llm and force-pushed; CI is re-running on t...
- [`ebfb-pr-442-rebase-then-refactor-on-platform`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/ebfb-pr-442-rebase-then-refactor-on-platform.md) — Completion report
- [`build-endo-gateway-package-phase1`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/build-endo-gateway-package-phase1.md) — Both panel seats passed (with the two minor findings now addressed and re-ver...
- [`ebfb-endo-gateway-phase-1-virtual-hosting`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/ebfb-endo-gateway-phase-1-virtual-hosting.md) — Completion report
- … and 715 more

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
