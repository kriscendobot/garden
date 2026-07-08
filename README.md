# Garden bulletin

_As of 2026-07-08T05:34:04Z_

## Latest

Now that signup is open, the report `open-signup-live-minion-town` flagged that no CloudWatch billing alarm was armed on the Cognito pool MAU or DynamoDB spend, and the liaison [escalated it to the maintainer](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260708T014900Z-a4afa2.md) — kriskowal needs to set MAU/spend thresholds and a notification target before a gardener can arm it. On the board, [endo-but-for-bots#617](https://github.com/endojs/endo-but-for-bots/pull/617) came back clean from a weave (now mergeable, CI green), a weave completed on [endo-but-for-bots#609](https://github.com/endojs/endo-but-for-bots/pull/609), and fetch-source work landed a gzip-decode improvement alongside a network-fetch build for endoclaw now in progress. The minion.town rollout remains gated on kriskowal: the whole Phase A→C chain (account store, open-signup gate flip, styled privilege surfaces) plus the SIWE and Stripe-credits deploys sit parked awaiting go-ahead.

## Parked for maintainer feedback

- [endojs/endo#3319](https://github.com/endojs/endo/pull/3319) — feat(eslint-plugin)!: support ESLint 10+ (waiting 6h)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 5d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 8d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 8d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 12d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 22d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 47d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 47d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 48d)
- [endojs/endo-but-for-bots#329](https://github.com/endojs/endo-but-for-bots/pull/329) — docs: introduce spackle, the polyfill+ponyfill race pattern (waiting 48d)

_Showing top 10 of 27 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260708T014900Z-a4afa2` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260708T014900Z-a4afa2.md)

> Report `open-signup-live-minion-town` recommends creating a CloudWatch billing alarm on Cognito pool MAU (and DynamoDB spend) now that signup is open, but none was created. This needs your call on thresholds and the notification target before a gardener can arm it via the aws-administration skill — please confirm the MAU/spend limits and where alerts should go.


## Board
### todo (0)
(none)

### doin (1)
- [`endojs-endo-but-for-bots-endoclaw-network-fetch-build`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-endoclaw-network-fetch-build.md) — ---

### tada (1509)
- [`endojs-endo-but-for-bots-pr617-weave`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr617-weave.md) — PR #617 is now **MERGEABLE** (mergeStateStatus UNSTABLE = merge is clean, CI ...
- [`endojs-endo-but-for-bots-pr609-weave`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr609-weave.md) — Completion report
- [`improve-fetch-source-gzip-decode`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-fetch-source-gzip-decode.md) — Completion report
- [`mention-kriskowal-garden-29-7f521daa`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/mention-kriskowal-garden-29-7f521daa.md) — Completion report
- [`scholar-ingest-codex-orchestration-symphony`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-ingest-codex-orchestration-symphony.md) — Completion report — scholar-ingest-codex-orchestration-symphony
- … and 1504 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`build-account-store-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-account-store-minion-town.md) — _normal_ · Build: account store + auto-provisioning for minion.town (Phase A — ships dar...
- [`deploy-siwe-thunk-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/deploy-siwe-thunk-minion-town.md) — _normal_ · Deploy the SIWE OIDC thunk (mirroring the GitHub thunk's AWS path)
- [`deploy-stripe-credits-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/deploy-stripe-credits-minion-town.md) — _normal_ · Deploy Stripe credit purchases on minion.town (AWS/box binding, TEST mode)
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`open-signup-gate-flip-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/open-signup-gate-flip-minion-town.md) — _normal_ · Build: open-signup gate flip for minion.town (Phase B — THE consequential cha...
- [`styled-privilege-surfaces-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/styled-privilege-surfaces-minion-town.md) — _normal_ · Build: styled privilege surfaces for minion.town (Phase C — role-aware landin...
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...
- [`wire-siwe-onchain-authz-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/wire-siwe-onchain-authz-minion-town.md) — _normal_ · Wire the chosen SIWE on-chain authorization tier into minion.town's policy layer

### deferred (top by priority; foreman auto-promotes when idle)
(none)

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-daemon-rename-to-manager-phase2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/598` · Build: daemon→manager rename Phase 2 (identifier renames)
- [`build-daemon-rename-to-manager-phase3`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase3.md) — awaiting `build-daemon-rename-to-manager-phase2` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`port-xs-to-rust-memory-safe-engine-s18`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine-s18.md) — awaiting `xs2rust-endor-build-stage5-fix6` · Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
(none)

## Hosts
- [endolin-garden-ece02cb4](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 20 gardeners
- [endolin-garden2-5bcdff64](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 20 gardeners
