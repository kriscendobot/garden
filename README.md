# Garden bulletin

_As of 2026-07-22T05:39:06Z_

## Latest

The [xs2rust-endor](https://github.com/endojs/endo-but-for-bots/pull/600) press stalled hard overnight — seven ticks with HEAD pinned at `03656bac9d` — on a single blocker: `daemon_bootstrap.js` generation fails because `blobref.js` pulls in `node:crypto`, which the SES/XS bundler can't handle. The Rust engine itself is healthy (82/82 cargo tests, ~2750 dual-run oracle tests green, stages 1–6 done), but `test:rust` stays unverified until the bundle builds. The maintainer has now given direction — option (a), add an XS crypto polyfill — and a fresh press job (`xs2rust-endor-press-20260722-045001`) is implementing it. A new review directive landed on [endo-but-for-bots#705](https://github.com/endojs/endo-but-for-bots/pull/705) and is in progress alongside the review of [endo-but-for-bots#719](https://github.com/endojs/endo-but-for-bots/pull/719); daemon-store build phases 2 and 3 completed. Note 27 PRs remain parked for review, several a week or more old — [#670](https://github.com/endojs/endo-but-for-bots/pull/670) (LAL subscription OAuth, 8d) and [#403](https://github.com/endojs/endo-but-for-bots/pull/403) (registry capability, 22d) longest among them.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#621](https://github.com/endojs/endo-but-for-bots/pull/621) — design: refine endoclaw-oauth as the connector credential foundation (settle first-mint flow) (waiting 1d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 2d)
- [endojs/endo-but-for-bots#166](https://github.com/endojs/endo-but-for-bots/pull/166) — feat(endor): add rust/endor TUI skeleton (re-opened from #31 under the bot) (waiting 2d)
- [endojs/endo-but-for-bots#671](https://github.com/endojs/endo-but-for-bots/pull/671) — feat(daemon): EndoRegistry capability and required @registry host name (waiting 4d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 4d)
- [endojs/endo-but-for-bots#475](https://github.com/endojs/endo-but-for-bots/pull/475) — feat(pass-style): narrow byteArray to plain frozen Uint8Array (waiting 4d)
- [endojs/endo-but-for-bots#594](https://github.com/endojs/endo-but-for-bots/pull/594) — chore(lint): lint per package to avoid the typescript-eslint project-service ceiling (waiting 5d)
- [endojs/endo-but-for-bots#670](https://github.com/endojs/endo-but-for-bots/pull/670) — feat(lal): subscription OAuth flow and encrypted auth store (M3) (waiting 8d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 19d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 22d)

_Showing top 10 of 27 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260722T051739Z-1f1dee` — from gardener:xs2rust-endor-press-20260722-033502, reply_to `xs2rust-endor-press-20260722-033502` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260722T051739Z-1f1dee.md)

> FINAL STALL NOTICE (tick 7): No HEAD movement since tick 4. Branch stable at 03656bac9d across 4 consecutive check-ins. Maintainer blocker message sent in tick 6 — no reply received. 
>
> Current state:
> - Rust engine healthy: endo binary builds with endor-engine feature; 82/82 cargo test pass
> - Dual-run oracle: ~2750 tests green (zero failures) across language/built-ins grammars
> - Stage 1-6 complete per roadmap; stage-5 byte-identity confirmed
> - CRITICAL BLOCKER: daemon_bootstrap.js generation fails — @endo/platform/fs/extended/shared/blobref.js imports node:crypto which SES/XS bundler cannot handle
> - test:rust not verified (blocked by XS bundle)
> - No concurrent active pusher on xs2rust-endor
>
> Without maintainer direction on the platform crypto polyfill / package.json exports restructuring approach, this press cannot proceed. Requesting specific guidance to unblock.

- `20260722T052437Z-d3d90a` — from gardener:xs2rust-endor-press-20260722-033502, reply_to `xs2rust-endor-press-20260722-033502` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260722T052437Z-d3d90a.md)

> Acknowledged maintainer direction: option (a) — adding XS crypto polyfill. Commencing implementation now. Will update upon completion.


## Spend & quota
_Trailing 7d window; billable tokens (cache reads excluded). Leader-host local spend._

| Provider | Token spend | Dollar spend | % of quota |
| --- | --- | --- | --- |
| Claude | 94.2M | $1037.06 _(notional, rate-card)_ | no quota set |
| Codex | 634.6M _(+513.1M cached)_ | n/a _(ChatGPT plan — no per-token $; plan-metered)_ | no quota set |

## Board
### todo (0)
(none)

### doin (5)
- [`daemon-store-phase4-sorted`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/daemon-store-phase4-sorted.md) — Build Phase 4: sorted variants and range queries (design Phase 4)
- [`endojs-endo-but-for-bots-pr705-review-207112c7`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr705-review-207112c7.md) — Review directive on endojs/endo-but-for-bots PR #705
- [`endojs-endo-but-for-bots-pr719-review-9fcf7da1`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr719-review-9fcf7da1.md) — Review directive on endojs/endo-but-for-bots PR #719
- [`xs2rust-endor-press-20260722-033502`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-press-20260722-033502.md) — Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260722-045001`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-press-20260722-045001.md) — Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...

### tada (3228)
- [`design-endo-platform-neutral-hash`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/design-endo-platform-neutral-hash.md) — Completion report
- [`daemon-store-phase3-weak-ertp`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/daemon-store-phase3-weak-ertp.md) — Completion report — daemon-store-phase3-weak-ertp (build Phase 3)
- [`explainer-from-archive4-compartment`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/explainer-from-archive4-compartment.md) — Completed and pushed:
- [`minion-town-agenda-review-20260722-045001`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/minion-town-agenda-review-20260722-045001.md) — Completion report
- [`daemon-store-phase2-setstore`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/daemon-store-phase2-setstore.md) — Build Phase 2: durable strong SetStore in the endo pet daemon (kriskowal/gard...
- … and 3223 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`build-endo-daemon-cloudflare-storage`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-endo-daemon-cloudflare-storage.md) — _normal_ · Build: Endo daemon Cloudflare storage platform (phases 1-2 of the design)
- [`build-kebab-case-lint-wildcard-test262`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-kebab-case-lint-wildcard-test262.md) — _normal_ · Reconstruct the kebab-case file-name linter (endojs/endo#2947) with WILDCARD ...
- [`deploy-endo-daemon-aws-storage-reference`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/deploy-endo-daemon-aws-storage-reference.md) — _normal_ · Build: reference deployment + operations for the daemon AWS storage platform ...
- [`deploy-siwe-thunk-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/deploy-siwe-thunk-minion-town.md) — _normal_ · Deploy the SIWE OIDC thunk (mirroring the GitHub thunk's AWS path)
- [`ebfb-124-resume-rebase-review-fixups`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ebfb-124-resume-rebase-review-fixups.md) — _normal_ · ---
- [`ebfb-124-sqlite-iterate-streaming`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ebfb-124-sqlite-iterate-streaming.md) — _normal_ · ---
- [`ebfb-124-sqlite-pragma-simple`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ebfb-124-sqlite-pragma-simple.md) — _normal_ · ---
- [`ebfb-124-sqlite-shutdown-checkpoint`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ebfb-124-sqlite-shutdown-checkpoint.md) — _normal_ · ---
- [`endo-vfs-parity-press-20260717-182002`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endo-vfs-parity-press-20260717-182002.md) — _normal_ · Press VFS tool-call-surface parity forward (endojs/endo-but-for-bots, base llm)
- [`endojs-endo-but-for-bots-pr124-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr124-shepherd.md) — _normal_ · shepherd (auto: red CI) on endojs/endo-but-for-bots PR #124
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`endojs-endo-but-for-bots-pr160-fixer`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr160-fixer.md) — _normal_ · fixer (shepherd→fixer auto-chain) on endojs/endo-but-for-bots PR #160
- [`endojs-endo-but-for-bots-pr592-cancel-in-options`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr592-cancel-in-options.md) — _normal_ · Fixer: reshape watchDirectory cancellation API (endojs/endo-but-for-bots #592)
- [`endojs-endo-but-for-bots-pr704-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr704-shepherd.md) — _normal_ · shepherd (auto: red CI) on endojs/endo-but-for-bots PR #704
- [`endojs-endo-but-for-bots-pr763-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr763-shepherd.md) — _normal_ · shepherd (auto: red CI) on endojs/endo-but-for-bots PR #763
- [`endojs-endo-but-for-bots-pr809-review-2f33af27`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr809-review-2f33af27.md) — _normal_ · Review directive on endojs/endo-but-for-bots PR #809
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`garden-style-url-not-path`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/garden-style-url-not-path.md) — _normal_ · ---
- [`gauntlet-endo-but-for-bots-pr661-agent-tools-http-client`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/gauntlet-endo-but-for-bots-pr661-agent-tools-http-client.md) — _normal_ · ---
- [`gauntlet-endo-but-for-bots-pr694-daemon-docker-self-hosting`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/gauntlet-endo-but-for-bots-pr694-daemon-docker-self-hosting.md) — _normal_ · ---
- [`gauntlet-endo-but-for-bots-pull-request-707-git-capability-worked-version-controlled-filesystem-loop`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/gauntlet-endo-but-for-bots-pull-request-707-git-capability-worked-version-controlled-filesystem-loop.md) — _normal_ · ---
- [`kriscendobot-agoric-sdk-pr15-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/kriscendobot-agoric-sdk-pr15-shepherd.md) — _normal_ · shepherd (auto: red CI) on kriscendobot/agoric-sdk PR #15
- [`merge-upstream-master-into-llm-20260717`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/merge-upstream-master-into-llm-20260717.md) — _normal_ · Merge upstream master into the endo-but-for-bots llm branch (propose PR -> sh...
- [`migrate-endo-but-for-bots-master-to-npm`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-npm.md) — _normal_ · ---
- [`migrate-endo-but-for-bots-master-to-pnpm`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-pnpm.md) — _normal_ · ---
- [`ocapn-noise-press-20260717-000503`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ocapn-noise-press-20260717-000503.md) — _normal_ · Press OCapN-over-Noise forward (endojs/endo-but-for-bots, base llm)
- [`ocapn-noise-press-20260717-182002`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ocapn-noise-press-20260717-182002.md) — _normal_ · Press OCapN-over-Noise forward (endojs/endo-but-for-bots, base llm)
- [`ocapn-noise-press-20260719-003513`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/ocapn-noise-press-20260719-003513.md) — _normal_ · Press OCapN-over-Noise forward (endojs/endo-but-for-bots, base llm)
- [`open-signup-gate-flip-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/open-signup-gate-flip-minion-town.md) — _normal_ · Build: open-signup gate flip for minion.town (Phase B — THE consequential cha...
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...
- [`weave-endo-but-for-bots-pr626-stack-surgery-eval`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/weave-endo-but-for-bots-pr626-stack-surgery-eval.md) — _normal_ · Weave endojs/endo-but-for-bots PR #626 (Phase-5 stack-surgery eval) onto llm
- [`wire-siwe-onchain-authz-minion-town`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/wire-siwe-onchain-authz-minion-town.md) — _normal_ · Wire the chosen SIWE on-chain authorization tier into minion.town's policy layer
- [`xs2rust-endor-press-20260720-022510`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260720-022510.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260720-123515`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260720-123515.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260720-145005`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260720-145005.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260720-172003`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260720-172003.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260720-192031`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260720-192031.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260720-203502`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260720-203502.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260720-215002`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260720-215002.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260720-230516`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260720-230516.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260721-002001`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260721-002001.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260721-022003`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260721-022003.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260721-043501`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260721-043501.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260721-053503`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260721-053503.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260721-063505`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260721-063505.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260721-100501`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260721-100501.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260721-122001`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260721-122001.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260721-143501`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260721-143501.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260721-165010`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260721-165010.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260721-180501`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260721-180501.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260721-202001`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260721-202001.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-press-20260722-012002`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260722-012002.md) — _normal_ · Press xs2rust-endor (PR #600) forward — to endor integration + green daemon t...
- [`xs2rust-endor-stage10p-fresh-env-sweep`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-stage10p-fresh-env-sweep.md) — _normal_ · Stage-10p child 3 (re-posted by s47 after the serial-halt sweep — spec unchan...

### deferred (top by priority; foreman auto-promotes when idle)
- [`endojs-endo-but-for-bots-pr809-review-722e1113-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr809-review-722e1113-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #809 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr809-review-39ff950a-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr809-review-39ff950a-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #809 (primary: endojs-endo-but-f...
- [`kriscendobot-minion.town-pr12-a3def291-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr12-a3def291-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #12 (primary: kriscendobot-minio...
- [`endojs-endo-but-for-bots-pr719-review-9fcf7da1-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr719-review-9fcf7da1-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #719 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr705-review-207112c7-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr705-review-207112c7-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #705 (primary: endojs-endo-but-f...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-endo-inspect`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-endo-inspect.md) — awaiting `endojs/endo-but-for-bots#715` · Build: implement @endo/inspect per the landed design
- [`build-endo-regexp-conservative-subset`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-endo-regexp-conservative-subset.md) — awaiting `endojs/endo-but-for-bots#676` · Build: implement @endo/regexp — the conservative-regexp-subset linear matcher
- [`daemon-rename-to-manager-phase3`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/daemon-rename-to-manager-phase3.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/780` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`port-xs-to-rust-memory-safe-engine-s48`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine-s48.md) — awaiting `xs2rust-endor-stage10p-fresh-env-sweep` · Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...
- [`registry-immutable-byte-array-followup`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/registry-immutable-byte-array-followup.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/671` · Immutable byte-array RegistryInterface follow-up
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
kriscendobot-agoric-3-proposals kriscendobot-agoric-sdk kriscendobot-chrome-native-function-caller-arguments-repro kriscendobot-cosgov kriscendobot-endo kriscendobot-finbot kriscendobot-garden kriscendobot-minion.town kriscendobot-ocapn kriscendobot-proposal-compartments kriscendobot-test262 kriscendobot-vattr97 kriscendobot-ymax-e2e kriscendobot-ymax-stdio-mcp

## Hosts
- [endolin-garden-ece02cb4](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 20 gardeners
- [endolin-garden2-5bcdff64](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 10 gardeners
