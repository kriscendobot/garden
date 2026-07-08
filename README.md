# Garden bulletin

_As of 2026-07-08T05:52:45Z_

## Latest

Two design jobs went into flight — an [AWS storage platform](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/design-endo-daemon-aws-storage.md) and a [CloudFlare storage platform](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/design-endo-daemon-cloudflare-storage.md) for the Endo daemon, each a peer of the node/web platforms — leaving the todo board empty. On the completion side, the `endoclaw-network-fetch` builder **stopped rather than build**: it found that [endo-but-for-bots#566](https://github.com/endojs/endo-but-for-bots/pull/566) (a DRAFT confined `HttpClient`/`HttpClientControl` cap by 0xpatrickbot, updated today) already implements the cited design in full, so it opened no competing PR and flagged the job as already-satisfied — the maintainer message recommends retiring the job and instead shepherding #566 to green, noting it bases on `llm` rather than `master`. Two weaves also landed: [endo-but-for-bots#617](https://github.com/endojs/endo-but-for-bots/pull/617) is now mergeable (UNSTABLE = clean merge, CI still running) and [endo-but-for-bots#609](https://github.com/endojs/endo-but-for-bots/pull/609) completed, alongside a Docker self-host build and a fetch-source gzip-decode improvement.

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

- `20260708T053541Z-30f34a` — from gardener:endojs-endo-but-for-bots-endoclaw-network-fetch-build, reply_to `endojs-endo-but-for-bots-endoclaw-network-fetch-build` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260708T053541Z-30f34a.md)

> Builder job `endoclaw-network-fetch` (build the HttpClient/HttpClientControl cap in endojs/endo-but-for-bots): STOPPED — the job body said "no in-flight PR", but there IS a comprehensive one.
>
> **PR #566** (`feat(exo-http-client): add confined HttpClient`, DRAFT, MERGEABLE, base `llm`, author 0xpatrickbot, updated 2026-07-08 — today) already implements this exact design:
> - `packages/exo-http-client` — the `HttpClient` / `HttpClientControl` exo facet pair (`src/http-client.js`, `src/types.ts`, tests)
> - `packages/http-confine` — shared pure confinement core: origin-parse allowlist, method/header validation, injected-clock per-minute rate limit, max-response-byte cap, redirect checks, timeout/cancel, `revoke()`
> - updates `designs/endoclaw-network-fetch.md` (the doc this job cites) + adds trust-on-first-bind policy, changesets, docs
>
> Every acceptance criterion in the design is covered. Building a second implementation would be a duplicate and would collide on the same branch/design. I did NOT open a competing PR.
>
> Recommendation: retire this job as already-satisfied by #566, and instead post a **shepherd/panel** job to drive #566 to green + out of draft if you want it landed. Say the word and I'll (as a fresh job) do that instead. Note #566 bases on `llm` not `master` — worth a reviewer eye given the base-branch norm.


## Board
### todo (0)
(none)

### doin (3)
- [`deploy-stripe-credits-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/deploy-stripe-credits-minion-town.md) — Deploy Stripe credit purchases on minion.town (AWS/box binding, TEST mode)
- [`design-endo-daemon-aws-storage`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/design-endo-daemon-aws-storage.md) — Design: an AWS storage platform for the Endo daemon (a peer of node / web / e...
- [`design-endo-daemon-cloudflare-storage`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/design-endo-daemon-cloudflare-storage.md) — Design: a CloudFlare storage platform for the Endo daemon (a peer of node / w...

### tada (1511)
- [`endojs-endo-but-for-bots-daemon-docker-selfhost-build`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-daemon-docker-selfhost-build.md) — Completion report
- [`endojs-endo-but-for-bots-endoclaw-network-fetch-build`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-endoclaw-network-fetch-build.md) — Completion report
- [`endojs-endo-but-for-bots-pr617-weave`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr617-weave.md) — PR #617 is now **MERGEABLE** (mergeStateStatus UNSTABLE = merge is clean, CI ...
- [`endojs-endo-but-for-bots-pr609-weave`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr609-weave.md) — Completion report
- [`improve-fetch-source-gzip-decode`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-fetch-source-gzip-decode.md) — Completion report
- … and 1506 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`build-account-store-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-account-store-minion-town.md) — _normal_ · Build: account store + auto-provisioning for minion.town (Phase A — ships dar...
- [`deploy-siwe-thunk-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/deploy-siwe-thunk-minion-town.md) — _normal_ · Deploy the SIWE OIDC thunk (mirroring the GitHub thunk's AWS path)
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
